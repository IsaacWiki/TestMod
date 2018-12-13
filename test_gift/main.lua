-- 测试神秘礼物生成大便/煤块概率
-- 设置
local base_luck = 9
local luck_step = 1

-- 
local game = Game();
local mod = RegisterMod("test_gift", 1);
local counts = {}
local finished = false
local pause = false
local luck = base_luck

function setluck()
    local player = Isaac.GetPlayer(1)
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
end

function mod:setluck()
    Isaac.GetPlayer(0).Luck = luck
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.setluck);

function mod:handler_game_start()
    setluck()
    counts = {}
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED , mod.handler_game_start);


function add_count(SubType)
    local is_poop = 0
    local is_lump = 0
    if SubType == CollectibleType.COLLECTIBLE_POOP then
        is_poop = 1
    elseif SubType == CollectibleType.COLLECTIBLE_LUMP_OF_COAL then
        is_lump = 1
    end
    luck = Isaac.GetPlayer(1).Luck
    if counts[luck] then
        counts[luck][1] = counts[luck][1] + 1
        counts[luck][2] = counts[luck][2] + is_poop
        counts[luck][3] = counts[luck][3] + is_lump
    else
        counts[luck] = {1, is_poop, is_lump}
    end
end

function mod:update()
    -- 生成文字
    for i in pairs(counts) do
        Isaac.RenderScaledText(
            string.format("Luck %.2f -- Lump:Poop:Sum=%d:%d:%d=%.4f%%,%.4f%%,%.4f%%", i, counts[i][3], counts[i][2], counts[i][1], 100*counts[i][2]/counts[i][1], 100*counts[i][3]/counts[i][1], 100*(counts[i][3]+counts[i][2])/counts[i][1]),
            100, 20+(i-base_luck)/luck_step*5, 0.5, 0.5, 255, 255, 255, 255);
    end
    if game:IsPaused() or game.TimeCounter < 60 or finished then
        return
    end

    player = Isaac.GetPlayer(1)
    luck = player.Luck

    if not pause then
        -- 自动使用神秘礼物
        for i=1,10 do
            player:UseActiveItem(
                CollectibleType.COLLECTIBLE_MYSTERY_GIFT,false,false,false,false)
        -- player:UseActiveItem(CollectibleType.COLLECTIBLE_POOP,false,false,false,false)
        end
        remove()
        if counts[luck]~= nil and counts[luck][1] >= 10000 then -- 测试一万次，加幸运
            if counts[luck][1] == counts[luck][2] or luck > 1099 then
                -- 概率 100%, 停止测试
                finished = true
            else
                luck = luck + luck_step
                setluck()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);


function remove()
    -- 统计 大便/煤块 数并移除
    entities = Isaac.GetRoomEntities()
    for i=1,#entities do
        e = entities[i]
        if e.Type == 5 and e.Variant == 100 then
            add_count(e.SubType)
            e:Remove()
        end
    end
end
-- mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.remove);


function mod:command(cmd, params)
    if (cmd == "gift") then
        if (string.lower(params) == "pause") then
            pause = not pause
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.command);