require "Traps/TrapDefinition"

local function addKittenToTraps(ItemID)
    -- Setup a definition of our animal for the traps
    local kitten = {}
    kitten.type = "kitten";
    kitten.strength = 20;                   -- Kitten strength to break out of trap (Same as squirrel)
    kitten.item = ItemID;
    kitten.minHour = 0;                     -- Hour of day minimum
    kitten.maxHour = 0;                     -- Hour of day maximum
    kitten.minSize = 8;                     -- Minimum size (affects weight, hunger)
    kitten.maxSize = 25;                    -- Maximum size (Chonker)

    -- Set up the trappable zones
    kitten.zone = {};
    kitten.zone["TrailerPark"] = 50;
    kitten.zone["TownZone"] = 50;
    kitten.zone["FarmLand"] = 40;
    kitten.zone["Forest"] = 10;
    kitten.zone["Vegitation"] = 8;
    kitten.zone["DeepForest"] = 2;

    -- Set up the useable traps
    kitten.traps = {};
    kitten.traps["Base.TrapCage"] = 30; 
    kitten.traps["Base.TrapBox"] = 20;
    kitten.traps["Base.TrapCrate"] = 10;
    kitten.traps["Base.TrapSnare"] = 2;

    -- Set up the useable bait
    kitten.baits = {};
    kitten.baits["Base.TunaTinOpen"] = 45;
    kitten.baits["Base.CannedMilkOpen"] = 40;
    kitten.baits["Base.CannedSardinesOpen"] = 35;
    kitten.baits["Base.FishFillet"] = 30;
    kitten.baits["Base.DeadBird"] = 20;
    kitten.baits["Base.BaitFish"] = 15;
    kitten.baits["Base.DeadMouse"] = 10;

    -- Add this kitten to the animal trap definitions (Traps/TrapDefinition)
    table.insert(Animals, kitten);
end

-- Add all our kittens to the trap options
addKittenToTraps("PocketKitten.KittenBlack");
addKittenToTraps("PocketKitten.KittenCalico");
addKittenToTraps("PocketKitten.KittenGray");
addKittenToTraps("PocketKitten.KittenGrayStriped");
addKittenToTraps("PocketKitten.KittenOrange");
addKittenToTraps("PocketKitten.KittenTuxedo");
addKittenToTraps("PocketKitten.KittenWhite");