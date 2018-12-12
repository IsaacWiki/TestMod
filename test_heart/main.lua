-- 测试各种心类掉落概率

-- 设置每帧掉落心个数
local heart_num = 1000

local is_on = false
local game = Game();
local mod = RegisterMod("test_heart", 1);
local player = Isaac.GetPlayer(1)
local room = game:GetRoom()
local counts = {}
local sum = 0
local HeartName = {
    [1]='Red Heart',
    [2]='Half Heart',
    [3]='Soul Heart',
    [4]='Eternal Heart',
    [5]='Double Heart',
    [6]='Black Heart',
    [7]='Gold Heart',
    [8]='Half Soul Heart',
    [9]='Scared Heart',
    [10]='Blended Heart',
    [11]='Bone Heart'
}


function add_count(subtype)
    sum = sum + 1
    if counts[subtype] then
        counts[subtype] = counts[subtype] + 1
    else
        counts[subtype] = 1
    end
end

function reset()
    counts = {}
    sum = 0
end

function mod:handler_game_start()
    player = Isaac.GetPlayer(1)
    -- 添加主教冠
    -- player:AddCollectible(CollectibleType.COLLECTIBLE_MITRE, 0) 
    counts = {}
    sum = 0
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED , mod.handler_game_start);


function count_heart(multi)
    if is_on then
        for i=1,heart_num do
            heart = game:Spawn(
                EntityType.ENTITY_PICKUP, 10, -- 心
                Vector(0,0), Vector(0,0),
                player, 0, i+heart_num*multi)
            add_count(heart.SubType)
            heart:Remove()
        end
    end
end


function mod:update()
    -- 显示
    for subtype in pairs(counts) do
        Isaac.RenderScaledText(
            string.format(
                "%s: %d (%.3f%%)",
                HeartName[subtype],
                counts[subtype],
                100*counts[subtype]/sum),
            100, 40+subtype*5,
            0.5, 0.5, 255, 255, 255, 255);
    end 
    
    -- 刷心
    if game:IsPaused() or game.TimeCounter < 30 then
        return
    end
    count_heart(game:GetFrameCount())
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);

function mod:command(cmd, params)
    if (cmd == "mod") then
        if (params == "on") then
            is_on = (not is_on)
        end
        if (params == "reset") then
            reset()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.command);