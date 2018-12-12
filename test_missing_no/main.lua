local mod = RegisterMod("test_missing_no", 1);
local counts = {0, 0, 0}



function mod:update()
    local entities = Isaac.GetRoomEntities();
    for i = 1, #entities do
        player = entities[i]:ToPlayer()
        if player ~= nil then
            count = player:GetCollectibleCount() + 1
            if counts[count] then
                counts[count] = counts[count] + 1
            else
                counts[count] = 1
            end
        end
    end
    for i = 1, #counts do
        Isaac.RenderScaledText(
            'Counts: ' ..  i-1 .. ':' .. counts[i],
            100, 40+i*5,
            0.5, 0.5, 255, 255, 255, 255);
        i = i + 1
    end 
end





mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);