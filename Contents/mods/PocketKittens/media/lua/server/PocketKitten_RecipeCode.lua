-- When transferring kittens (stray/pet/pocket) we want to keep the
-- weight. If you use "transferweight" as a tag on an item then call
-- this function OnCreate it'll transfer the weight with the item
function PocketKitten_KeepWeight(items, result, player)
    for i=0, items:size()-1 do
        print(items:get(i):getTags())
        if items:get(i):getTags() and items:get(i):getTags():contains("transferweight") then
            local original = items:get(i):getActualWeight();
            result:setWeight(original);
            result:setActualWeight(original);
            result:setCustomWeight(true);
        end
    end
end