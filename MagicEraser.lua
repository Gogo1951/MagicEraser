local MagicEraser = {}

local DEFAULT_ICON = "Interface\\Icons\\inv_misc_bag_07_green"
local UPDATE_THROTTLE = 0.25
local DATA_REQUEST_THROTTLE = 0.25
local BAG_UPDATE_DELAY = 0.25
local MAX_CACHE_ITEMS = 100

local ADDON_NAME = "Magic Eraser"

local HEX_NAME = "82B1FF"
local HEX_SEPARATOR = "2962FF"
local HEX_TEXT = "FFFFFF"
local HEX_SUCCESS = "33FF33"

local COLOR_PREFIX = "|cff"

local BRAND_PREFIX =
    COLOR_PREFIX ..
    HEX_NAME .. ADDON_NAME .. "|r " .. COLOR_PREFIX .. HEX_SEPARATOR .. "//|r" .. COLOR_PREFIX .. HEX_TEXT .. " "

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
local CursorHasItem = CursorHasItem
local ClearCursor = ClearCursor
local GetItemInfo = GetItemInfo
local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local GetContainerItemID = C_Container and C_Container.GetContainerItemID or GetContainerItemID

MagicEraser.TooltipFrame = CreateFrame("GameTooltip", "MagicEraserTooltip", UIParent, "GameTooltipTemplate")
MagicEraser.MinimapTooltipFrame =
    CreateFrame("GameTooltip", "MagicEraserMinimapTooltip", UIParent, "GameTooltipTemplate")

local HiddenScanTooltip = CreateFrame("GameTooltip", "MagicEraserScanTooltip", UIParent, "GameTooltipTemplate")
HiddenScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

MagicEraser.ItemCache = {}
MagicEraser.ItemCacheCount = 0

local function Throttled(throttle)
    local nextTime = 0
    return function()
        local now = GetTime()
        if now >= nextTime then
            nextTime = now + throttle
            return true
        end
    end
end

local CanRequestItemData = Throttled(DATA_REQUEST_THROTTLE)
local CanRefreshMinimap = Throttled(DATA_REQUEST_THROTTLE)

local function CachePut(id, info)
    if not MagicEraser.ItemCache[id] then
        MagicEraser.ItemCacheCount = MagicEraser.ItemCacheCount + 1
    end
    MagicEraser.ItemCache[id] = info
    if MagicEraser.ItemCacheCount > MAX_CACHE_ITEMS then
        local toRemove = floor(MAX_CACHE_ITEMS / 2)
        local removed = 0
        for k in pairs(MagicEraser.ItemCache) do
            MagicEraser.ItemCache[k] = nil
            removed = removed + 1
            if removed >= toRemove then
                break
            end
        end
        MagicEraser.ItemCacheCount = MagicEraser.ItemCacheCount - removed
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

function MagicEraser:GetNextErasableItem()
    local lowestValue, lowestItem = nil, nil
    local playerLevel = GetPlayerLevel()

    if not GetContainerNumSlots or not GetContainerItemInfo then
        return nil
    end

    for bag = 0, 4 do
        local numSlots = GetContainerNumSlots(bag) or 0
        for slot = 1, numSlots do
            local itemInfo = GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.hyperlink then
                local itemID = itemInfo.itemID
                local name, _, rarity, itemLevel, requiredLevel, _, _, _, _, icon, sellPrice =
                    GetItemInfo(itemInfo.hyperlink)
                CachePut(itemID, itemInfo)

                if not name or not rarity or not sellPrice or not itemLevel or not requiredLevel then
                    if C_Item and C_Item.RequestLoadItemDataByID then
                        C_Item.RequestLoadItemDataByID(itemID)
                        if CanRequestItemData() then
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
                    local requiredLevelValue = requiredLevel or 1
                    local isLowLevelConsumable = isConsumable and ((playerLevel - requiredLevelValue) >= 10)

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

local function CheckForNewDeletableQuestItems()
    local notifiedItems = {}

    for bag = 0, 4 do
        local numSlots = GetContainerNumSlots(bag) or 0
        for slot = 1, numSlots do
            local itemID = GetContainerItemID(bag, slot)
            if itemID and MagicEraser.AllowedDeleteQuestItems[itemID] then
                local isDeletable = false
                local questMap = MagicEraser.AllowedDeleteQuestItems[itemID]
                if questMap then
                    for _, qid in ipairs(questMap) do
                        if IsQuestCompleted(qid) then
                            isDeletable = true
                            break
                        end
                    end
                end

                if isDeletable then
                    local itemLink = select(2, GetItemInfo(itemID))
                    if itemLink and not notifiedItems[itemLink] then
                        print(format(BRAND_PREFIX .. "%s can be safely deleted!|r", itemLink))
                        notifiedItems[itemLink] = true
                    end
                end
            end
        end
    end
end

function MagicEraser:RunEraser()
    if InCombatLockdown() then
        print(BRAND_PREFIX .. "Cannot erase items while in combat.|r")
        return
    end

    local info = self:GetNextErasableItem()
    if info then
        if CursorHasItem() then
            ClearCursor()
        end
        C_Container.PickupContainerItem(info.bag, info.slot)
        DeleteCursorItem()

        local stackStr = (info.count > 1) and format(" x%d", info.count) or ""
        if info.value == 0 then
            print(
                format(
                    BRAND_PREFIX .. "Erased %s%s, this item was associated with a quest you have completed.|r",
                    info.link,
                    stackStr
                )
            )
        else
            print(format(BRAND_PREFIX .. "Erased %s%s, worth %s.|r", info.link, stackStr, FormatCurrency(info.value)))
        end
    else
        if not self.lastNoItemMessageTime or (GetTime() - self.lastNoItemMessageTime >= 10) then
            print(
                BRAND_PREFIX ..
                    "Congratulations, your bags are full of good stuff! You'll have to manually erase something if you need to free up more space.|r"
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

    tooltip:AddLine(ADDON_NAME, 1, 0.82, 0)
    tooltip:AddLine(" ")

    if info then
        local amount = info.value or 0
        local gold = floor(amount / 10000)
        local silver = floor((amount % 10000) / 100)
        local copper = amount % 100
        local valueString = ""

        if gold > 0 then
            valueString = valueString .. format("|cFFFFFFFF%d|r|cffffd700g|r ", gold)
        end
        if silver > 0 then
            valueString = valueString .. format("|cFFFFFFFF%d|r|cffc7c7cfs|r ", silver)
        end
        if copper > 0 or valueString == "" then
            valueString = valueString .. format("|cFFFFFFFF%d|r|cffeda55fc|r", copper)
        end

        valueString = strtrim(valueString)

        local stackString = (info.count > 1) and format(" x%d", info.count) or ""

        tooltip:AddDoubleLine(format("%s%s", info.link, stackString), valueString)

        tooltip:AddLine(" ")

        tooltip:AddDoubleLine("|cFF66BBFFLeft-Click|r", "|cFFFFFFFFErase Lowest Value Item|r")
    else
        tooltip:AddLine("|cFF00FF00Congratulations, your bags are full of good stuff!|r", nil, nil, nil, true)
        tooltip:AddLine(" ")
        tooltip:AddLine(
            "|cFFaaaaaaYou'll have to manually erase something if you need to free up more space.|r",
            nil,
            nil,
            nil,
            true
        )
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
            text = ADDON_NAME,
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
local lastUpdateTime, bagUpdateScheduled = 0, false

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:RegisterEvent("ITEM_PUSH")
frame:RegisterEvent("ITEM_LOCK_CHANGED")
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("LOOT_OPENED")
frame:RegisterEvent("QUEST_TURNED_IN")

local function HandleBagUpdateDelayed(fromQuestCompletion)
    local now = GetTime()
    if now - lastUpdateTime < UPDATE_THROTTLE then
        return
    end
    lastUpdateTime = now

    if fromQuestCompletion then
        CheckForNewDeletableQuestItems()
    end

    if CanRefreshMinimap() then
        MagicEraser:UpdateMinimapIconAndTooltip()
    end
end

local bagUpdateEvents = {
    BAG_UPDATE = true,
    ITEM_PUSH = true,
    ITEM_LOCK_CHANGED = true,
    BAG_UPDATE_DELAYED = true
}

frame:SetScript(
    "OnEvent",
    function(_, event)
        if bagUpdateEvents[event] then
            if not bagUpdateScheduled then
                bagUpdateScheduled = true
                C_Timer_After(
                    BAG_UPDATE_DELAY,
                    function()
                        HandleBagUpdateDelayed(false)
                        bagUpdateScheduled = false
                    end
                )
            end
        elseif event == "LOOT_READY" or event == "LOOT_OPENED" then
            HandleBagUpdateDelayed(false)
        elseif event == "QUEST_TURNED_IN" then
            if not bagUpdateScheduled then
                bagUpdateScheduled = true
                C_Timer_After(
                    BAG_UPDATE_DELAY,
                    function()
                        HandleBagUpdateDelayed(true)
                        bagUpdateScheduled = false
                    end
                )
            end
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
