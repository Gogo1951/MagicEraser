local MagicEraser = {}

local DEFAULT_ICON = "Interface\\Icons\\inv_misc_bag_07_green"
local UPDATE_THROTTLE = 0.25
local DATA_REQUEST_THROTTLE = 0.25
local BAG_UPDATE_DELAY = 0.25
local MAX_CACHE_ITEMS = 100

MagicEraser.AllowedDeleteQuestItems = MagicEraser_AllowedDeleteQuestItems or {}
MagicEraser.AllowedDeleteConsumables = MagicEraser_AllowedDeleteConsumables or {}
MagicEraser.AllowedDeleteEquipment = MagicEraser_AllowedDeleteEquipment or {}

local _G = _G
local floor = math.floor
local insert = table.insert
local format = string.format
local C_Timer_After = C_Timer.After
local GetTime = GetTime
local UnitLevel = UnitLevel
local InCombatLockdown = InCombatLockdown
local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

MagicEraser.TooltipFrame = CreateFrame("GameTooltip", "MagicEraserTooltip", UIParent, "GameTooltipTemplate")
MagicEraser.MinimapTooltipFrame =
    CreateFrame("GameTooltip", "MagicEraserMinimapTooltip", UIParent, "GameTooltipTemplate")

local HiddenScanTooltip = CreateFrame("GameTooltip", "MagicEraserScanTooltip", UIParent, "GameTooltipTemplate")
HiddenScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

MagicEraser.ItemCache = {}
MagicEraser.ItemCacheCount = 0

local function CachePut(id, info)
    if MagicEraser.ItemCache[id] then
        MagicEraser.ItemCache[id] = info
        return
    end
    MagicEraser.ItemCache[id] = info
    MagicEraser.ItemCacheCount = MagicEraser.ItemCacheCount + 1
    if MagicEraser.ItemCacheCount > MAX_CACHE_ITEMS then
        local removed = 0
        for k in pairs(MagicEraser.ItemCache) do
            MagicEraser.ItemCache[k] = nil
            removed = removed + 1
            if removed >= floor(MAX_CACHE_ITEMS / 2) then
                break
            end
        end
        MagicEraser.ItemCacheCount = 0
        for _ in pairs(MagicEraser.ItemCache) do
            MagicEraser.ItemCacheCount = MagicEraser.ItemCacheCount + 1
        end
    end
end

local function FormatCurrency(value)
    local g = floor(value / 10000)
    local s = floor((value % 10000) / 100)
    local c = value % 100
    local parts = {}
    if g > 0 then
        insert(parts, format("%d|cffffd700g|r", g))
    end
    if s > 0 then
        insert(parts, format("%d|cffc7c7cfs|r", s))
    end
    if c > 0 or #parts == 0 then
        insert(parts, format("%d|cffeda55fc|r", c))
    end
    return table.concat(parts, " ")
end

local function IsQuestCompleted(questID)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    end
    return false
end

local function GetPlayerLevel()
    return UnitLevel("player")
end

function MagicEraser:GetItemRequiredLevel(itemID)
    if not itemID then
        return nil
    end
    HiddenScanTooltip:ClearLines()
    HiddenScanTooltip:SetHyperlink("item:" .. itemID)
    for i = 2, HiddenScanTooltip:NumLines() do
        local line = _G["MagicEraserScanTooltipTextLeft" .. i]
        local text = line and line:GetText()
        if text then
            local n = text:match("Requires Level (%d+)")
            if n then
                return tonumber(n)
            end
        end
    end
    return 1
end

local pendingDataRefreshAt = 0

function MagicEraser:GetNextErasableItem()
    local lowestValue, lowestItem = nil, nil
    local playerLevel = GetPlayerLevel()

    for bag = 0, 4 do
        local numSlots = C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(bag) or 0
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.hyperlink then
                local itemID = itemInfo.itemID
                local name, _, rarity, itemLevel, _, _, _, _, _, icon, sellPrice = GetItemInfo(itemInfo.hyperlink)
                CachePut(itemID, itemInfo)

                if not name or not rarity or not sellPrice or not itemLevel then
                    if C_Item and C_Item.RequestLoadItemDataByID then
                        C_Item.RequestLoadItemDataByID(itemID)
                        if GetTime() >= pendingDataRefreshAt then
                            pendingDataRefreshAt = GetTime() + DATA_REQUEST_THROTTLE
                            C_Timer_After(
                                DATA_REQUEST_THROTTLE,
                                function()
                                    if MagicEraser.UpdateMinimapIconAndTooltip then
                                        MagicEraser:UpdateMinimapIconAndTooltip()
                                    end
                                end
                            )
                        end
                    end
                else
                    local count = itemInfo.stackCount or 1
                    local totalValue = (sellPrice or 0) * count

                    local canDeleteQuestItem = false
                    local questMap = self.AllowedDeleteQuestItems[itemID]
                    if questMap then
                        for _, qid in ipairs(questMap) do
                            if IsQuestCompleted(qid) then
                                canDeleteQuestItem = true
                                break
                            end
                        end
                    end

                    local isConsumable = self.AllowedDeleteConsumables[itemID] or false
                    local requiredLevel = self:GetItemRequiredLevel(itemID)
                    local isLowLevelConsumable =
                        isConsumable and requiredLevel and ((playerLevel - requiredLevel) >= 10)

                    if
                        canDeleteQuestItem or isLowLevelConsumable or self.AllowedDeleteEquipment[itemID] or
                            (rarity == 0 and (sellPrice or 0) > 0)
                     then
                        if not lowestValue or totalValue < lowestValue then
                            lowestValue = totalValue
                            lowestItem = {
                                link = itemInfo.hyperlink,
                                count = count,
                                value = totalValue,
                                icon = icon,
                                bag = bag,
                                slot = slot
                            }
                        end
                    end
                end
            end
        end
    end

    return lowestItem
end

function MagicEraser:RunEraser()
    if InCombatLockdown() then
        print("|cff00B0FFMagic Eraser|r : Cannot erase items while in combat.")
        return
    end

    local info = self:GetNextErasableItem()
    if info then
        C_Container.PickupContainerItem(info.bag, info.slot)
        DeleteCursorItem()
        local stackStr = (info.count > 1) and format(" x%d", info.count) or ""
        if info.value == 0 then
            print(
                format(
                    "|cff00B0FFMagic Eraser|r : Erased %s%s, this item was associated with a quest you have completed.",
                    info.link,
                    stackStr
                )
            )
        else
            print(
                format(
                    "|cff00B0FFMagic Eraser|r : Erased %s%s, worth %s.",
                    info.link,
                    stackStr,
                    FormatCurrency(info.value)
                )
            )
        end
    else
        if not self.lastNoItemMessageTime or (GetTime() - self.lastNoItemMessageTime >= 10) then
            print(
                "|cff00B0FFMagic Eraser|r : Congratulations, your bags are full of good stuff! You'll have to manually erase something if you need to free up more space."
            )
            self.lastNoItemMessageTime = GetTime()
        end
    end

    self:UpdateMinimapIconAndTooltip()
end

function MagicEraser:RefreshMinimapTooltip()
    local tooltip = self.MinimapTooltipFrame
    local info = self:GetNextErasableItem()
    tooltip:ClearLines()
    tooltip:AddLine("|cff00B0FFMagic Eraser|r", 1, 1, 1)
    tooltip:AddLine(" ", 1, 1, 1)

    if info then
        tooltip:AddLine("Click to erase the lowest-value item in your bags.", 0.8, 0.8, 0.8)
        tooltip:AddLine(" ", 1, 1, 1)
        local valueString = FormatCurrency(info.value)
        local stackString = (info.count > 1) and format(" x%d", info.count) or ""
        tooltip:AddDoubleLine(format("%s%s", info.link, stackString), valueString, 1, 1, 1, 1, 1, 1)
    else
        tooltip:AddLine("|cff33FF33Congratulations, your bags are full of good stuff!|r", 1, 1, 1)
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffFFFFFFYou'll have to manually erase something if you|r", 1, 1, 1)
        tooltip:AddLine("|cffFFFFFFneed to free up more space.|r", 1, 1, 1)
    end

    tooltip:Show()
end

function MagicEraser:UpdateMinimapIconAndTooltip()
    if not self.MagicEraserLDB then
        return
    end
    local info = self:GetNextErasableItem()
    if info and info.icon then
        self.MagicEraserLDB.icon = info.icon
    else
        self.MagicEraserLDB.icon = DEFAULT_ICON
    end
    if LDBIcon and LDBIcon.Refresh then
        LDBIcon:Refresh("MagicEraser", MagicEraser.DB)
    end
    self:RefreshMinimapTooltip()
end

MagicEraser.DB = MagicEraserDB or {}

if LDB then
    MagicEraser.MagicEraserLDB =
        LDB:NewDataObject(
        "MagicEraser",
        {
            type = "data source",
            text = "Magic Eraser",
            icon = DEFAULT_ICON,
            OnClick = function(_, button)
                if button == "LeftButton" then
                    MagicEraser:RunEraser()
                end
            end,
            OnEnter = function(iconFrame)
                if not iconFrame or not iconFrame:IsObjectType("Frame") then
                    return
                end
                MagicEraser.MinimapTooltipFrame:SetOwner(iconFrame, "ANCHOR_BOTTOMLEFT")
                MagicEraser:RefreshMinimapTooltip()
            end,
            OnLeave = function()
                MagicEraser.MinimapTooltipFrame:Hide()
            end
        }
    )
    if MagicEraser.MagicEraserLDB and LDBIcon and LDBIcon.Register then
        LDBIcon:Register("MagicEraser", MagicEraser.MagicEraserLDB, MagicEraser.DB)
    end
end

local frame = CreateFrame("Frame")
local lastUpdateTime, lastDataRequestTime, bagUpdateScheduled = 0, 0, false

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:RegisterEvent("ITEM_PUSH")
frame:RegisterEvent("ITEM_LOCK_CHANGED")
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("LOOT_OPENED")

local function HandleBagUpdateDelayed()
    local now = GetTime()
    if now - lastUpdateTime < UPDATE_THROTTLE then
        return
    end
    lastUpdateTime = now
    if now - lastDataRequestTime >= DATA_REQUEST_THROTTLE then
        MagicEraser:UpdateMinimapIconAndTooltip()
        lastDataRequestTime = now
    end
end

frame:SetScript(
    "OnEvent",
    function(_, event)
        if
            event == "BAG_UPDATE" or event == "ITEM_PUSH" or event == "ITEM_LOCK_CHANGED" or
                event == "BAG_UPDATE_DELAYED"
         then
            if not bagUpdateScheduled then
                bagUpdateScheduled = true
                C_Timer_After(
                    BAG_UPDATE_DELAY,
                    function()
                        HandleBagUpdateDelayed()
                        bagUpdateScheduled = false
                    end
                )
            end
        elseif event == "LOOT_READY" or event == "LOOT_OPENED" then
            HandleBagUpdateDelayed()
        elseif event == "PLAYER_LOGIN" then
            if MagicEraser.UpdateMinimapIconAndTooltip then
                MagicEraser:UpdateMinimapIconAndTooltip()
            end
            if LDBIcon and LDBIcon.Show then
                LDBIcon:Show("MagicEraser")
            end
        end
    end
)
