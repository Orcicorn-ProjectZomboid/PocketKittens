-- --------------------------------------------------------------- --
-- LOCAL "GLOBALS" ----------------------------------------------- --
--  Settings and configurations passed between functions --------- --
-- --------------------------------------------------------------- --
local isLoading = true;             -- Determine if script is loading or not
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
    isLoading = false;
end


-- --------------------------------------------------------------- --
--  PocketKitten_IsKittenActive
--      Description:        Checks if a Pocket Kitten is Equipped or Attached
--      Trigger             OnEveryHour
--      Params              None
--      Returns             Boolean
-- --------------------------------------------------------------- --
--[[    NOTE TO SELF:
            The reason the code is setup like this instead of the previous
            check on cloghing update is because if you attach an item and
            then immediately ask the game what is the item index, it'll say -1
            which means NOT ATTACHED. It remains as -1 until you ask again.  The
            inverse is true as well if it's attached to slot 10 and you unattach it
            the game still reports back as slot 10 until the next update.

            So previously i could just watch ClothingUpdate() and set a boolean to determine
            if the reduction was enabled/disabled and save some query on the Hourly check. However
            constantly getting false positive/negatives from the getAttachedSlot() API. So now it's
            just easier to check Slot and Equipped Status every hour. Doesn't seem to error out
            like ClothingUpdated does.

            I suspect this is because an animation triggers to attach an item but clothing
            updated triggers before the animation completes. So it's technically still not, or
            still remains attached, so the slot values are wrong.

            Anyway, That's why we check every hour now instead of just doing event based detection
]]
local function PocketKitten_IsKittenActive()
    if getPlayer() == nil then return false; end
    inventory = getPlayer():getInventory();
    for _, type in pairs(pocketkittenitems) do 
        pocketkitten = inventory:getItemFromType(type)
        if pocketkitten ~=nil then
            -- Are you wearing the cat?
            if pocketkitten:isEquipped() then
                return true;
            end
            -- Or is it attached to your backpack? (AuthenticZ/Noir)
            if pocketkitten:getAttachedSlot() > -1 then 
                return true;
            end
        end
    end
    -- Not worn, not attached, so don't bother
    return false;
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
    -- Check if it's safe to reduce values
    player = getPlayer();
    if PocketKitten_IsKittenActive() == false then return; end;
    if player:isAiming() or player:isAttacking() then return; end
    -- Reduce Boredom/Unhappy/Stress
    bodyDamage = player:getBodyDamage();
    playerStats = player:getStats();
    bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - reduceBoredom);
    bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - reduceUnhappyness);
    playerStats:setStress((playerStats:getStress() - (reduceStress / 100)) - playerStats:getStressFromCigarettes());
    -- Small chance to make a cat sound effect if not sleeping
    if not player:isAsleep() and ZombRand(1,10) <= 1 then
        player:playSound("meow" .. ZombRand(1,5))
    end
end


-- --------------------------------------------------------------- --
--  EVENTS ------------------------------------------------------- --
-- --------------------------------------------------------------- --
Events.EveryHours.Add(PocketKitten_ReduceNegatives);
Events.OnGameTimeLoaded.Add(PocketKitten_OnLogin);
