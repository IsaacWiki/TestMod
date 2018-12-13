-- 自由设置游戏变量
-- 例子：
--     set luck 1.2
--     set l 1.2
local mod = RegisterMod("anyvalue", 1);
local game = Game();
local values = {}

function mod:setvalue(Player, CacheFlag)
    if values['Damage'] ~= nil then
        Player.Damage = values['Damage']
    end
    if values['Luck'] ~= nil then
        Player.Luck = values['Luck']
    end    
    if values['TearHeight'] ~= nil then
        Player.TearHeight = values['TearHeight']
    end    
    if values['TearFallingSpeed'] ~= nil then
        Player.TearFallingSpeed = values['TearFallingSpeed']
    end
    if values['TearFallingAcceleration'] ~= nil then
        Player.TearFallingAcceleration = values['TearFallingAcceleration']
    end    
    if values['FireDelay'] ~= nil then
        Player.FireDelay = values['FireDelay']
    end
    if values['MaxFireDelay'] ~= nil then
        Player.MaxFireDelay = values['MaxFireDelay']
    end
    if values['ShotSpeed'] ~= nil then
        Player.ShotSpeed = values['ShotSpeed']
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.setvalue);


function split_param(line)
    res = {}
    for k1, k2 in string.gmatch(line, "(%w+) +([0-9.-]+)") do
        res[1] = k1
        res[2] = k2
    end
    return res
end


function mod:command(cmd, params)
    params = split_param(params)
    attr = params[1]
    value = tonumber(params[2])
    if (cmd == "set") then
        if (attr == "luck" or attr == "l") then
            values['Luck'] = value
        elseif (attr == "damage" or attr == "d") then
            values['Damage'] = value
        elseif (attr == "tearheight" or attr == "range" or attr == "th") then
            values['TearHeight'] = value
        elseif (attr == "tearfallingspeed" or attr == "tfs") then
            values['TearFallingSpeed'] = value
        elseif (attr == "tearfallingacceleration" or attr == "tfa") then
            values['TearFallingAcceleration'] = value
        elseif (attr == "firedelay" or attr == "fd") then
            values['FireDelay'] = value
        elseif (attr == "maxfiredelay" or attr == "mfd") then
            values['MaxFireDelay'] = value
        elseif (attr == "shotspeed" or attr == "ss") then
            values['ShotSpeed'] = value
        end
        -- Isaac.GetPlayer(1):AddCacheFlags(CacheFlag.CACHE_ALL)
        Isaac.GetPlayer(1):AddCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT, 0)
    end
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.command);