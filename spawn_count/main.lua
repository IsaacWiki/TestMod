-- To use the blank card, run:
-- lua for i=1,10000 do Isaac.GetPlayer(1):UseActiveItem(286) end

local mod = RegisterMod("spawn_count", 1);
local game = Game();
TARGET_TYPE = 6

counts = {}

function mod:count(etype, vari, stype, pos, vel, spawner, seed)
    if etype == TARGET_TYPE then
        if counts[vari] ~= nil then
            counts[vari] = counts[vari] + 1
        else
            counts[vari] = 1
        end
    end
end


function mod:update()
    -- Count entity sum
    local sum = 0
    for entity_type in pairs(counts)
    do
        sum = sum + counts[entity_type]
    end

    -- Print 
    local i = 0
    for entity_type in pairs(counts)
    do
        i = i + 1
        Isaac.RenderScaledText(
            string.format(
                "%d: %d , %.3f%%",
                entity_type,
                counts[entity_type],
                100*counts[entity_type]/sum),
            100, 40+i*5,
            0.5, 0.5, 255, 255, 255, 255);
    end 
    Isaac.RenderScaledText(
        'Sum :' .. sum,
        100, 40,
        0.5, 0.5, 255, 255, 255, 255);
end


function mod:remove()
    -- Clear Entity
    entities = Isaac.GetRoomEntities() 
    for i=1,#entities do
        if entities[i].Type == TARGET_TYPE then
            entities[i]:Remove()
        end
    end
end


mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM , mod.remove);
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN , mod.count);
