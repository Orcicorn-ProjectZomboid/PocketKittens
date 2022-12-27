--[[
    The basic run down here is that if you right-click an item in your inventory windows
    then if it is an adopted kitten, or a pocket kitten, we give you the option to rename it.
    
    If you click "Rename" (pulled from ContextMenu Translations) we pop-up a text box that allows
    you to type in a name you wish to rename it to.  That item is then renamed and we make note 
    that a custom name is in use.

    In PocketKitten_RecipeCode.lua anytime a kitten is added or removed from a pocket, we check to 
    see if a custom name is set. If it is, we transfer the name between items so that "Mr.Jing" is
    always Mr.Jing and never reverts back to "Orange Kitten"
]]

ISPocketKittenRename = {};
require "ISInventoryPaneContextMenu"

-- If you right-click a PocketKitten or a PetKitten, you get the option to rename it
-- ISPocketKittenRename.createMenu
--  @desc       When right-clicking items in your backpack, if it's a pocket kitten we
--              give you the option to rename them to suit your preferences
--  @params     IsoPlayer
--  @params     context menu
--  @params     InventoryItems (key, value)
--  @returns    nothing
ISPocketKittenRename.createMenu = function(player, context, items)
    local objectToRename = nil;
    for key, value in ipairs(items) do
        local item = value;
        if not instanceof(item, "InventoryItem") then
            item = value.items[1];
        end
        if item:getType():contains("PetKitten") or item:getType():contains("PocketKitten") then 
            if item:isInPlayerInventory() then
                context:addOption(getText("ContextMenu_RenameFood"), item, ISPocketKittenRename.onRename, player)
            end
        end
    end
end

-- ISPocketKittenRename.onRename
--  @desc       When you select the "Rename" menu item, this triggers and we 
--              open up a text box asking you what to name the kitten
--  @params     InventoryItem
--  @params     IsoPlayer
--  @returns    nothing
ISPocketKittenRename.onRename = function(item, player)
    local modal = ISTextBox:new(0, 0, 300, 150, getText("ContextMenu_RenameFood"), item:getName(), nil, ISPocketKittenRename.onRenameButton, player, getSpecificPlayer(player), item)
    modal:initialise();
    modal:addToUIManager();
end

-- ISPocketKittenRename.onRenameButton
--  @desc       When you click OK or Cancel on the rename prompt this function triggers
--              and handles the renaming logic if necessary. 
--  @params     nil
--  @params     button (OK or CANCEL)
--  @params     IsoPlayer
--  @params     InventoryItem
--  @returns    nothing
function ISPocketKittenRename.onRenameButton(x, button, player, item)
    if button.internal == "OK" then
        if button.parent.entry:getText() and string.trim(button.parent.entry:getText()) ~= "" then
            -- Rename the Kitten
            item:setName(string.trim(button.parent.entry:getText()));
            item:setCustomName(true);
            -- Update the backpacks to show re-sort with the new name
            local playerData = getPlayerData(player:getPlayerNum());
            playerData.playerInventory:refreshBackpacks();
            playerData.lootInventory:refreshBackpacks();
        end
    end
end

Events.OnPreFillInventoryObjectContextMenu.Add(ISPocketKittenRename.createMenu);