local mod = RegisterMod("test_lilhaunt", 1);
local game = Game();
damages = {}
start_time = 0

function SpawnTestMonster()
    
end


function mod:countdamage(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
    if #damages == 0 then
        start_time = game.TimeCounter
    end
    damages[#damages+1] = game.TimeCounter - start_time
    return true
end

function mod:update()
    -- if ds then
    --     Isaac.RenderScaledText(
    --         'Type: ' ..  type(ds.ToFamiliar),
    --         150, 25,
    --         0.5, 0.5, 255, 255, 255, 255);
    --     Isaac.RenderScaledText(
    --         'TookDamage: ' ..  td,
    --         150, 30,
    --         0.5, 0.5, 255, 255, 255, 255);           
    --     Isaac.RenderScaledText(
    --         'DamageAmount: ' ..  da,
    --         150, 35,
    --         0.5, 0.5, 255, 255, 255, 255);   
    -- end
    local i = 0;
    while (i*10 < #damages)
    do
        -- Isaac.RenderScaledText(
        --     'Counts: ' ..  damages[#damages],
        --     100, 40+i*5,
        --     0.5, 0.5, 255, 255, 255, 255);
        s = table.concat(damages, ",", i*10+1, math.min(i*10+10, #damages))
        Isaac.RenderScaledText(
            'Counts: ' ..  s,
            100, 40+i*5,
            0.5, 0.5, 255, 255, 255, 255);
        i = i + 1
    end 
end





mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG , mod.countdamage, mod.ENTITY_MEGA_MAW);

