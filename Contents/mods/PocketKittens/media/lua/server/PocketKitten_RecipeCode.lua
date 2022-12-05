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