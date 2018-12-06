local mod = RegisterMod("test_lilhaunt", 1);
local game = Game();
damages = {}
ds = nil
td = nil
da = nil

function mod:countdamage(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
    ds = DamageSource
    da = DamageAmount
    td = TookDamage
    
    damages[#damages+1] = game.TimeCounter
    -- if DamageSource then
    --     if DamageSource and DamageSource.ToFamiliar then
    --     end 
    -- end
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
    Isaac.RenderScaledText(
        'Counts: ' ..  table.concat(damages, ","),
        100, 40,
        0.5, 0.5, 255, 255, 255, 255);      
    Isaac.RenderScaledText(
        'Times: ' ..  game.TimeCounter,
        50, 50,
        0.5, 0.5, 255, 255, 255, 255);   
end





mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG , mod.countdamage, mod.ENTITY_MEGA_MAW);

