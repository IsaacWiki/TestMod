-- To use the blank card, run:
-- lua for i=1,10000 do Isaac.GetPlayer(1):UseActiveItem(286) end

local mod = RegisterMod("spawn_count", 1);
local game = Game();
TARGET_TYPE = EntityType.ENTITY_PICKUP 

current_frame = -1
counts = {}


function count(vari)
    -- count the variant numbers
    if counts[vari] ~= nil then
        counts[vari] = counts[vari] + 1
    else
        counts[vari] = 1
    end
end


function remove()
    -- Clear Entity
    entities = Isaac.GetRoomEntities() 
    for i=1,#entities do
        if entities[i].Type == TARGET_TYPE then
            count(entities[i].SubType)
            entities[i]:Remove()
        end
    end
end


function mod:update()
    -- Use the Active Item
    time = game:GetFrameCount()
    if current_frame ~= time then
        for i=1,1000 do
            current_frame = time
            entity = Isaac.Spawn(5,10,0,Vector(0,0),Vector(0,0),nil)
            count(entity.SubType)
            entity:Remove()
        end
    end

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




-- mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM , mod.remove);
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
