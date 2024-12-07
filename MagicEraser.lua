-- Namespace for MagicEraser
local MagicEraser = {}

-- Constants
local DEFAULT_ICON = "Interface\\Icons\\inv_misc_bag_07_green"
local UPDATE_THROTTLE = 0.5

-- Load allowed item lists
MagicEraser.AllowedDeleteQuestItems = MagicEraser_AllowedDeleteQuestItems
MagicEraser.AllowedDeleteConsumables = MagicEraser_AllowedDeleteConsumables
MagicEraser.AllowedDeleteEquipment = MagicEraser_AllowedDeleteEquipment

-- Helper function to format currency values
function MagicEraser:FormatCurrency(value)
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

-- Function to check if the player has completed any quest in the list
function MagicEraser:IsAnyQuestCompleted(questIDs)
    for _, questID in ipairs(questIDs) do
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            return true
        end
    end
    return false
end

-- Function to check if the consumable's use level is valid
function MagicEraser:IsConsumableAndLevelAllowed(itemID)
    local useLevel = select(5, GetItemInfo(itemID))
    if useLevel and useLevel > 0 then
        local playerLevel = UnitLevel("player")
        return (playerLevel - useLevel >= 10)
    end
    return true
end

-- Function to get the next erasable item info
function MagicEraser:GetNextErasableItem()
    local lowestValue, lowestItemInfo = nil, nil

    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.hyperlink then
                local itemID = itemInfo.itemID
                local _, _, itemRarity, _, _, _, _, _, _, itemIcon, itemSellPrice = GetItemInfo(itemInfo.hyperlink)
                if not itemRarity or not itemSellPrice then
                    return nil
                end

                local stackCount = itemInfo.stackCount or 1
                local totalValue = itemSellPrice * stackCount

                if
                    (self.AllowedDeleteQuestItems[itemID] and
                        self:IsAnyQuestCompleted(self.AllowedDeleteQuestItems[itemID])) or
                        (self.AllowedDeleteConsumables[itemID] and self:IsConsumableAndLevelAllowed(itemID)) or
                        self.AllowedDeleteEquipment[itemID] or
                        (itemRarity == 0 and itemSellPrice > 0)
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

    return lowestItemInfo
end

-- Function to delete the lowest value item
function MagicEraser:RunEraser()
    local itemInfo = self:GetNextErasableItem()
    if itemInfo then
        C_Container.PickupContainerItem(itemInfo.bag, itemInfo.slot)
        DeleteCursorItem()

        local message

        -- Check if the item is associated with a completed quest
        if self.AllowedDeleteQuestItems[itemInfo.itemID] then
            local questIDs = self.AllowedDeleteQuestItems[itemInfo.itemID]
            if questIDs and self:IsAnyQuestCompleted(questIDs) then
                message =
                    string.format(
                    "|cff00B0FFMagic Eraser|r : Erased %s, this item was associated with a quest you have completed.",
                    itemInfo.link
                )
            else
                -- Fallback if quest is not completed (shouldn't happen)
                message =
                    string.format(
                    "|cff00B0FFMagic Eraser|r : Erased %s, associated with an incomplete quest.",
                    itemInfo.link
                )
            end
        else
            -- Default message for non-quest items
            local valueString = self:FormatCurrency(itemInfo.value)
            local stackString = (itemInfo.count > 1) and string.format(" x%d", itemInfo.count) or ""
            message =
                string.format(
                "|cff00B0FFMagic Eraser|r : Erased %s%s, worth %s.",
                itemInfo.link,
                stackString,
                valueString
            )
        end

        -- Print debug info for validation
        print("Item ID:", itemInfo.itemID, "Quest IDs:", self.AllowedDeleteQuestItems[itemInfo.itemID])
        print("Final Message:", message)

        print(message)
    else
        print(
            "|cff00B0FFMagic Eraser|r : Congratulations, your bags are full of good stuff! You'll have to manually erase something if you need to free up more space."
        )
    end

    self:UpdateMinimapIconAndTooltip()
end

-- Function to update the minimap icon and tooltip
function MagicEraser:UpdateMinimapIconAndTooltip()
    local itemInfo = self:GetNextErasableItem()

    -- Update the icon with the item's icon or fall back to the default
    if itemInfo and itemInfo.icon then
        self.MagicEraserLDB.icon = itemInfo.icon
    else
        self.MagicEraserLDB.icon = DEFAULT_ICON
    end

    -- Refresh the GameTooltip if visible
    if GameTooltip:IsVisible() then
        self:RefreshTooltip()
    end

    -- Ensure LDBIcon updates the minimap button
    if LDBIcon then
        LDBIcon:Refresh("MagicEraser", MagicEraser.DB)
    end
end

-- Function to refresh the tooltip
function MagicEraser:RefreshTooltip()
    local itemInfo = self:GetNextErasableItem()
    GameTooltip:ClearLines()

    GameTooltip:AddLine("|cff00B0FFMagic Eraser|r", 1, 1, 1)
    GameTooltip:AddLine(" ", 1, 1, 1)
    GameTooltip:AddLine("Click to erase the lowest-value item in your bags.", 1, 1, 1)
    GameTooltip:AddLine(" ", 1, 1, 1)

    if itemInfo then
        local valueString = self:FormatCurrency(itemInfo.value)
        local stackString = (itemInfo.count > 1) and string.format(" x%d", itemInfo.count) or ""

        GameTooltip:AddDoubleLine(string.format("%s%s", itemInfo.link, stackString), valueString, 1, 1, 1, 1, 1, 1)
        GameTooltip:AddTexture(itemInfo.icon)
    else
        GameTooltip:AddLine("Congratulations, your bags are full of good stuff!")
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("You'll have to manually erase something if you need to free up more space.")
    end

    GameTooltip:Show()
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
        OnEnter = function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
            MagicEraser:RefreshTooltip()
        end,
        OnLeave = function()
            GameTooltip:Hide()
        end
    }
)

-- Register and initialize the minimap button on load
LDBIcon:Register("MagicEraser", MagicEraser.MagicEraserLDB, MagicEraser.DB)

-- Event handling with throttle
local frame = CreateFrame("Frame")
local lastUpdateTime = 0

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("BAG_UPDATE")
frame:SetScript(
    "OnEvent",
    function(_, event)
        if event == "BAG_UPDATE" and (GetTime() - lastUpdateTime < UPDATE_THROTTLE) then
            return
        end
        lastUpdateTime = GetTime()
        MagicEraser:UpdateMinimapIconAndTooltip()
        if event == "PLAYER_LOGIN" then
            LDBIcon:Show("MagicEraser")
        end
    end
)
