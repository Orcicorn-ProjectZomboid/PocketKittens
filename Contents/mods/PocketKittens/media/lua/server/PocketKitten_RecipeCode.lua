-- When transferring kittens (stray/pet/pocket) we want to keep the
-- weight. If you use "transferweight" as a tag on an item then call
-- this function OnCreate it'll transfer the weight with the item
-- Also if a kitten has a custom name, it'll be transferred as well
function PocketKitten_KeepWeight(items, result, player)
    for i=0, items:size()-1 do
        local item = items:get(i)
        -- Transfer the Weight between pocket/kitten
        if item:getTags() and item:getTags():contains("transferweight") then
            local original = item:getActualWeight();
            result:setWeight(original);
            result:setActualWeight(original);
            result:setCustomWeight(true);
        end
        -- If the kitty has been renamed, transfer it's name between pocket and kitten
        if item:getType():contains("PetKitten") or item:getType():contains("PocketKitten") then 
            if item:isCustomName() then 
                result:setName(item:getName());
                result:setCustomName(true)
            end
        end
    end
end


-- Feed a Kitten
-- Small/fun interaction with the cat and it does a miniscule amoun of happiness
-- Increase. Happiness is 0-100 so 0.5 is nothing, Would take 200 feedings to be fully happy
function PocketKitten_FeedKitten(items, result, player)
    bodyDamage = player:getBodyDamage();
    bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - 0.5);
end


-- Pet a kitten
-- Small/fun/useless interaction. Lets you pet a cat. Does a miniscule amount of
-- boredom decrease. Essentially the amount of boredom you'd gain while crafting
-- this interaction is removed for a netgain of zero
function PocketKitten_PetKitten(items, result, player)
    -- Reduce Boredom by a miniscule amount
    player = getPlayer();
    bodyDamage = player:getBodyDamage();
    bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - 0.12);

    -- Add some randomness to the meowing
    if ZombRand(1, 10) <= 1 then 
        player:playSound("meow" .. ZombRand(1,5))
    end

end


-- Dumbass, pet a zombie cat
-- You're an idiot who pet the zombie cat.  Well there's an 80% chance
-- that you're going to get hurt. If you do get hurt, there's a 60% chance 
-- that it's a scratch, a 30% chance it's a deep laceration, and a 10% chance it's a bite
-- The kitten carries the virus, so you may get infected. Same chances as if a zombie did 
-- those actions to you.
function PocketKitten_PetZombie(items, result, player)
    local chanceYouGetScratched = 60;
    local chanceYouGetLacerated = 30;

    local infectedChance = 0;
    local attackType = 0;
    
    if ZombRand(1,10) <= 8 then
        -- 80% Chance something bad happens to you
        player:playSound("catscream1");
        playerDamage = player:getBodyDamage();
        bodyPart = playerDamage:getBodyPart(BodyPartType.FromString("Hand_R"));
        
        attackType = ZombRand(1, 100);
        
        if attackType <= 60 then 
            -- [[ SCRATCH ]]
            infectionChance = 7;
            bodyPart:setScratched(true, true);
            bodyPart:setScratchTime(bodyPart:getScratchTime()+ZombRand(1,3));
            HaloTextHelper.addTextWithArrow(player, getText("IGUI_PocketKittenScratch"), false, HaloTextHelper.getColorRed());

        elseif attackType > 60 and attackType <= 90 then 
            -- [[ DEEP CUT / LACERATION ]]
            infectionChance = 25;
            bodyPart:setCut(true, true);
            HaloTextHelper.addTextWithArrow(player, getText("IGUI_PocketKittenLacerate"), false, HaloTextHelper.getColorRed());
        else
            -- [[ BITE ]]
            infectionChance = 100;
            bodyPart:SetBitten(true, true)
            HaloTextHelper.addTextWithArrow(player, getText("IGUI_PocketKittenBitten"), false, HaloTextHelper.getColorRed());
        end

        -- Regardless it's a 10% chance now the cat infected you with zombie virus
        if ZombRand(1, 100) <= infectionChance then
            playerDamage:setInfected(true);
        end  
    end
end