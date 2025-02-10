-- Namespace for MagicEraser
local MagicEraser = {}

-- Constants
local DEFAULT_ICON = "Interface\\Icons\\inv_misc_bag_07_green"
local UPDATE_THROTTLE = 0.25 -- Reduced throttle to ensure updates are frequent
local DATA_REQUEST_THROTTLE = 0.25 -- Reduced throttle to ensure updates are frequent
local BAG_UPDATE_DELAY = 0.25 -- Reduced delay to ensure updates are frequent
local MAX_CACHE_ITEMS = 100 -- Reduced cache size

-- Load allowed item lists
MagicEraser.AllowedDeleteQuestItems = MagicEraser_AllowedDeleteQuestItems or {}
MagicEraser.AllowedDeleteConsumables = MagicEraser_AllowedDeleteConsumables or {}
MagicEraser.AllowedDeleteEquipment = MagicEraser_AllowedDeleteEquipment or {}

-- Tooltip Frame
MagicEraser.TooltipFrame = CreateFrame("GameTooltip", "MagicEraserTooltip", UIParent, "GameTooltipTemplate")

-- Separate Tooltip Frame for Minimap Icon
MagicEraser.MinimapTooltipFrame =
    CreateFrame("GameTooltip", "MagicEraserMinimapTooltip", UIParent, "GameTooltipTemplate")

-- Cache for item information
MagicEraser.ItemCache = setmetatable({}, {__mode = "v"}) -- Use weak table for cache

-- Helper function to format currency values
local function FormatCurrency(value)
    local valueGold = math.floor(value / 10000)
    local valueSilver = math.floor((value % 10000) / 100)
    local valueCopper = value % 100
    local parts = {}

    if valueGold > 0 then
        table.insert(parts, string.format("%d|cffffd700g|r", valueGold))
    end
    if valueSilver > 0 then
        table.insert(parts, string.format("%d|cffc7c7cfs|r", valueSilver))
    end
    if valueCopper > 0 or #parts == 0 then
        table.insert(parts, string.format("%d|cffeda55fc|r", valueCopper))
    end

    return table.concat(parts, " ")
end

-- Function to check if a quest is completed
local function IsQuestCompleted(questID)
    if C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    end
    return false
end

-- Function to get the player's current level
local function GetPlayerLevel()
    return UnitLevel("player")
end

-- Function to get the next erasable item info
function MagicEraser:GetNextErasableItem()
    local lowestValue, lowestItemInfo = nil, nil
    local playerLevel = GetPlayerLevel()

    -- Clear the cache if it exceeds the maximum size
    if #MagicEraser.ItemCache > MAX_CACHE_ITEMS then
        MagicEraser.ItemCache = {}
    end

    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.hyperlink then
                local itemID = itemInfo.itemID
                local itemName, _, itemRarity, itemLevel, _, _, _, _, _, itemIcon, itemSellPrice =
                    GetItemInfo(itemInfo.hyperlink)

                -- Cache the item information
                MagicEraser.ItemCache[itemID] = itemInfo

                -- If item data is incomplete, request it and skip this item for now
                if not itemName or not itemRarity or not itemSellPrice or not itemLevel then
                    C_Item.RequestLoadItemDataByID(itemID)
                    -- Schedule a recheck of this item in the next run
                    C_Timer.After(
                        0.5,
                        function()
                            self:UpdateMinimapIconAndTooltip()
                        end
                    )
                else
                    local stackCount = itemInfo.stackCount or 1
                    local totalValue = itemSellPrice * stackCount

                    local canDeleteQuestItem = false
                    if self.AllowedDeleteQuestItems[itemID] then
                        for _, questID in ipairs(self.AllowedDeleteQuestItems[itemID]) do
                            if IsQuestCompleted(questID) then
                                canDeleteQuestItem = true
                                break
                            end
                        end
                    end

                    -- Check if the item is a consumable and if its level is at least 10 levels lower than the player's level
                    local isConsumable = self.AllowedDeleteConsumables[itemID]
                    local isLowLevelConsumable = isConsumable and itemLevel and (playerLevel - itemLevel >= 10)

                    if
                        (canDeleteQuestItem or isLowLevelConsumable or self.AllowedDeleteEquipment[itemID] or
                            (itemRarity == 0 and itemSellPrice > 0))
                     then
                        if not lowestValue or totalValue < lowestValue then
                            lowestValue = totalValue
                            lowestItemInfo = {
                                link = itemInfo.hyperlink,
                                count = stackCount,
                                value = totalValue,
                                icon = itemIcon,
                                bag = bag,
                                slot = slot
                            }
                        end
                    end
                end
            end
        end
    end

    return lowestItemInfo
end

-- Function to erase the lowest value item
function MagicEraser:RunEraser()
    if InCombatLockdown() then
        print("|cff00B0FFMagic Eraser|r : Cannot erase items while in combat.")
        return
    end

    local itemInfo = self:GetNextErasableItem()
    if itemInfo then
        C_Container.PickupContainerItem(itemInfo.bag, itemInfo.slot)
        DeleteCursorItem()

        local message
        if itemInfo.value == 0 then
            local stackString = (itemInfo.count > 1) and string.format(" x%d", itemInfo.count) or ""
            message =
                string.format(
                "|cff00B0FFMagic Eraser|r : Erased %s%s, this item was associated with a quest you have completed.",
                itemInfo.link,
                stackString
            )
        else
            local valueString = FormatCurrency(itemInfo.value)
            local stackString = (itemInfo.count > 1) and string.format(" x%d", itemInfo.count) or ""
            message =
                string.format(
                "|cff00B0FFMagic Eraser|r : Erased %s%s, worth %s.",
                itemInfo.link,
                stackString,
                valueString
            )
        end
        print(message)
    else
        -- Throttled no-item message
        if not self.lastNoItemMessageTime or (GetTime() - self.lastNoItemMessageTime >= 10) then
            print(
                "|cff00B0FFMagic Eraser|r : Congratulations, your bags are full of good stuff! You'll have to manually erase something if you need to free up more space."
            )
            self.lastNoItemMessageTime = GetTime()
        end
    end

    -- Update the icon and tooltip
    self:UpdateMinimapIconAndTooltip()
end

-- Function to refresh the minimap tooltip
function MagicEraser:RefreshMinimapTooltip()
    local tooltip = self.MinimapTooltipFrame
    local itemInfo = self:GetNextErasableItem()

    tooltip:ClearLines()
    tooltip:AddLine("|cff00B0FFMagic Eraser|r", 1, 1, 1)
    tooltip:AddLine(" ", 1, 1, 1)

    if (itemInfo ~= nil) then
        tooltip:AddLine("Click to erase the lowest-value item in your bags.", 0.8, 0.8, 0.8)
        tooltip:AddLine(" ", 1, 1, 1)
        local valueString = FormatCurrency(itemInfo.value)
        local stackString = (itemInfo.count > 1) and string.format(" x%d", itemInfo.count) or ""

        tooltip:AddDoubleLine(string.format("%s%s", itemInfo.link, stackString), valueString, 1, 1, 1, 1, 1, 1)
    else
        tooltip:AddLine("|cff33FF33Congratulations, your bags are full of good stuff!|r", 1, 1, 1)
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffFFFFFFYou'll have to manually erase something if you|r", 1, 1, 1)
        tooltip:AddLine("|cffFFFFFFneed to free up more space.|r", 1, 1, 1)
    end

    tooltip:Show()
end

-- Function to update the minimap icon and tooltip
function MagicEraser:UpdateMinimapIconAndTooltip()
    -- Ensure MagicEraserLDB is initialized
    if not self.MagicEraserLDB then
        return
    end

    local itemInfo = self:GetNextErasableItem()

    if itemInfo and itemInfo.icon then
        self.MagicEraserLDB.icon = itemInfo.icon
    else
        self.MagicEraserLDB.icon = DEFAULT_ICON
    end

    if LDBIcon then
        LDBIcon:Refresh("MagicEraser", MagicEraser.DB)
    end

    self:RefreshMinimapTooltip()
end

-- Minimap icon initialization
local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)

MagicEraser.DB = MagicEraserDB or {}

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

-- Ensure that the LDB object is properly created before registering
if MagicEraser.MagicEraserLDB then
    LDBIcon:Register("MagicEraser", MagicEraser.MagicEraserLDB, MagicEraser.DB)
end

-- Event handling with throttle and delay
local frame = CreateFrame("Frame")
local lastUpdateTime = 0
local lastDataRequestTime = 0
local bagUpdateScheduled = false

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:RegisterEvent("ITEM_PUSH")
frame:RegisterEvent("ITEM_LOCK_CHANGED")
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("LOOT_OPENED")

-- Function to handle BAG_UPDATE_DELAYED event
local function HandleBagUpdateDelayed()
    if GetTime() - lastUpdateTime < UPDATE_THROTTLE then
        return
    end
    lastUpdateTime = GetTime()

    if GetTime() - lastDataRequestTime >= DATA_REQUEST_THROTTLE then
        MagicEraser:UpdateMinimapIconAndTooltip()
        lastDataRequestTime = GetTime()
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
                C_Timer.After(
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
            -- Ensure it reads the lowest value item on load
            MagicEraser:UpdateMinimapIconAndTooltip()
            LDBIcon:Show("MagicEraser")
        end
    end
)
