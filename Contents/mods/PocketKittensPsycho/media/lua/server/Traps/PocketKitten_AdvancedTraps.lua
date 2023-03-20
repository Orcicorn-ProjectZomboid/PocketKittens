require "Traps/TrapDefinition"

function AddCatMeatToTraps()
    for k, v in ipairs(Animals) do 
        if Animals[k].type == "rat" then
            Animals[k]["baits"]["PocketKitten.StrayCatMeat"] = 65;
            Animals[k]["baits"]["PocketKitten.ZombieCatMeat"] = 25;
            return;
        end
    end
end
Events.OnGameStart.Add(AddCatMeatToTraps);	
