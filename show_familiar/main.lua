local mod = RegisterMod("show_familiar", 1);
local game = Game();


function mod:update()
    -- Print 
    local i = 0
    entities = Isaac.GetRoomEntities() 
    for i=1,#entities do
        entity = entities[i]
        local pos = game:GetRoom():WorldToScreenPosition(entity.Position, false);
        if entity.Type == 3 then
            Isaac.RenderScaledText(
            entity.Variant .. '.' .. entity.SubType,
                pos.X - 5, pos.Y - 32,
                0.5, 0.5, 255, 255, 255, 255);
        end
    end
end


mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
