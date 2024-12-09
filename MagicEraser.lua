-- Namespace for MagicEraser
local MagicEraser = {}

-- Constants
local DEFAULT_ICON = "Interface\\Icons\\inv_misc_bag_07_green"
local UPDATE_THROTTLE = 0.5

-- Load allowed item lists
MagicEraser.AllowedDeleteQuestItems = MagicEraser_AllowedDeleteQuestItems or {}
MagicEraser.AllowedDeleteConsumables = MagicEraser_AllowedDeleteConsumables or {}
MagicEraser.AllowedDeleteEquipment = MagicEraser_AllowedDeleteEquipment or {}

-- Tooltip Frame
MagicEraser.TooltipFrame = CreateFrame("GameTooltip", "MagicEraserTooltip", UIParent, "GameTooltipTemplate")

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

-- Function to check if a quest is completed
function MagicEraser:IsQuestCompleted(questID)
    if C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    end
    return false
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

                local canDeleteQuestItem = false
                if self.AllowedDeleteQuestItems[itemID] then
                    for _, questID in ipairs(self.AllowedDeleteQuestItems[itemID]) do
                        if self:IsQuestCompleted(questID) then
                            canDeleteQuestItem = true
                            break
                        end
                    end
                end

                if
                    (canDeleteQuestItem) or (self.AllowedDeleteConsumables[itemID]) or
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
        if itemInfo.value == 0 then
            local stackString = (itemInfo.count > 1) and string.format(" x%d", itemInfo.count) or ""
            message =
                string.format(
                "|cff00B0FFMagic Eraser|r : Erased %s%s, this item was associated with a quest you have completed.",
                itemInfo.link,
                stackString
            )
        else
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
        print(message)
    else
        print(
            "|cff00B0FFMagic Eraser|r : Congratulations, your bags are full of good stuff! You'll have to manually erase something if you need to free up more space."
        )
    end

    -- Update the icon and tooltip
    self:UpdateMinimapIconAndTooltip()

    -- Always refresh the tooltip
    GameTooltip:Hide() -- Ensure the tooltip resets
    self:RefreshTooltip()
end

-- Function to refresh the tooltip
function MagicEraser:RefreshTooltip()
    local tooltip = GameTooltip -- Use the standard GameTooltip
    local itemInfo = self:GetNextErasableItem()

    -- Reset the tooltip
    tooltip:ClearLines()

    tooltip:AddLine("|cff00B0FFMagic Eraser|r", 1, 1, 1)
    tooltip:AddLine(" ", 1, 1, 1)
    tooltip:AddLine("Click to erase the lowest-value item in your bags.", 1, 1, 1)
    tooltip:AddLine(" ", 1, 1, 1)

    if itemInfo then
        local valueString = self:FormatCurrency(itemInfo.value)
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
    local itemInfo = self:GetNextErasableItem()

    if itemInfo and itemInfo.icon then
        self.MagicEraserLDB.icon = itemInfo.icon
    else
        self.MagicEraserLDB.icon = DEFAULT_ICON
    end

    if LDBIcon then
        LDBIcon:Refresh("MagicEraser", MagicEraser.DB)
    end
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
                print("MagicEraser: Invalid icon frame passed to OnEnter.")
                return
            end

            GameTooltip:SetOwner(iconFrame, "ANCHOR_BOTTOMLEFT") -- Attach tooltip to frame
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

        -- Always refresh the tooltip
        GameTooltip:Hide() -- Ensure the tooltip resets
        MagicEraser:RefreshTooltip()

        if event == "PLAYER_LOGIN" then
            LDBIcon:Show("MagicEraser")
        end
    end
)
