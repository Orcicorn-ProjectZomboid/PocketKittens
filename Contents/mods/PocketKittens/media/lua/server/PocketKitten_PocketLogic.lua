-- --------------------------------------------------------------- --
-- LOCAL "GLOBALS" ----------------------------------------------- --
--  Settings and configurations passed between functions --------- --
-- --------------------------------------------------------------- --
local isLoading = true;             -- Determine if script is loading or not
local enableReduction = false;      -- Determine if we should reduce boredom
local pocketkittenitems = {};       -- List of acceptable pocketkittens
local reduceBoredom = nil;          -- Amount of Boredom reduced each hour when equipped
local reduceUnhappyness = nil;      -- Amount of Unhappyness reduced each hour when equipped
local reduceStress = nil;           -- Amount of Stress reduced each hour when equipped (/100)


-- --------------------------------------------------------------- --
--  PocketKitten_LoadKittenTags()
--      Description:    Searches through the game's items and gets
--                      a listing of all items that contain the
--                      tag "pocketkitten"
--      Trigger         Requested from OnLogin()
--      Parameters:     None
--      Returns:        Nothing. Updates pocketkittenitems global
-- --------------------------------------------------------------- --
local function PocketKitten_LoadKittenTags()
    kittens = getScriptManager():getItemsTag("pocketkitten");   
    if kittens then
        for i=0, kittens:size()-1 do
            table.insert(pocketkittenitems, kittens:get(i):getFullName())
        end
    end
end


-- --------------------------------------------------------------- --
-- PocketKitten_IsKittenEquipped
--      Description:        Determines if a valid pocket kitten is equipped
--      Trigger:            Requested from OnLogin/ClothingUpdate()
--      Params:             None
--      Returns:            Boolean (True/False if pocket kitten is equipped)
-- --------------------------------------------------------------- --
local function PocketKitten_IsKittenEquipped()
    if getPlayer() == nil then return false; end;
    inventory = getPlayer():getInventory();
    for _, type in pairs(pocketkittenitems) do 
        pocketkitten = inventory:getItemFromType(type)
        if pocketkitten ~=nil then
            if pocketkitten:isEquipped() then
                return true;
            end
        end
    end
    return false;
end


-- --------------------------------------------------------------- --
--  PocketKitten_ClothingUpdate
--      Description:        When triggered it updates the enableReduction
--                          variable to determine if a pocket kitten is equipped
--      Trigger:            Clothing change
--      Params              None
--      Returns             Nothing
-- --------------------------------------------------------------- --
local function PocketKitten_ClothingUpdate(player)
    if isLoading == true then return end;
    enableReduction = PocketKitten_IsKittenEquipped()
end


-- --------------------------------------------------------------- --
--  PocketKitten_OnLogin
--      Description:        Sets up Sandbox Variables and pocket items
--      Trigger             On Game Login/Start
--      Params              None
--      Returns             Nothing
-- --------------------------------------------------------------- --
local function PocketKitten_OnLogin()
    reduceBoredom = (SandboxVars.PocketKitten.ReduceBoredom or 12);
    reduceUnhappyness = (SandboxVars.PocketKitten.ReduceUnhappyness or 12);
    reduceStress = (SandboxVars.PocketKitten.ReduceStress or 5);
    PocketKitten_LoadKittenTags();
    enableReduction = PocketKitten_IsKittenEquipped()
    isLoading = false;
end


-- --------------------------------------------------------------- --
--  PocketKitten_ReduceNegatives
--      Description:        Reduces boredom/unhappyness on the player
--                          character if enableReduction is set to true
--      Trigger             Every In-Game Hour
--      Params              None
--      Returns             Nothing
-- --------------------------------------------------------------- --
local function PocketKitten_ReduceNegatives()
    player = getPlayer();
    if enableReduction == false then return; end
    if player:isAiming() or player:isAttacking() then return; end
    -- Reduce Boredom/Unhappy/Stress
    bodyDamage = player:getBodyDamage();
    playerStats = player:getStats();
    bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - reduceBoredom);
    bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - reduceUnhappyness);
    playerStats:setStress(playerStats:getStress() - (reduceStress / 100));
    -- Small chance to make a cat sound effect if not sleeping
    if not player:isAsleep() and ZombRand(1,10) <= 1 then
        player:playSound("meow" .. ZombRand(1,5))
    end
end


-- --------------------------------------------------------------- --
--  EVENTS ------------------------------------------------------- --
-- --------------------------------------------------------------- --
Events.EveryHours.Add(PocketKitten_ReduceNegatives);
Events.OnClothingUpdated.Add(PocketKitten_ClothingUpdate);
Events.OnGameTimeLoaded.Add(PocketKitten_OnLogin);
