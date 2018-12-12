-- 测试反人类卡+点金术生成金大便概率

local game = Game();
local mod = RegisterMod("count_gridentity", 1);
local counts = {}
local room = game:GetRoom()
local gridsize = room:GetGridSize()
local last_time = -1
local sum = 0

function mod:handler_game_start()
    local player = Isaac.GetPlayer(1)
    player:AddCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH, 0) -- 添加点金术
    player:AddCard(Card.CARD_HUMANITY) -- 添加反人类卡
    for i=1,5 do -- 降低幸运
        player:UsePill(PillEffect.PILLEFFECT_LUCK_DOWN, 0)
    end
    counts = {}
    last_time = -1
    sum = 0
end

function mod:handler_change_room()
    -- 更新房间大小
    room = game:GetRoom()
    if room ~= nil then
        gridsize = room:GetGridSize()
    end
end

function add_count(is_gold)
    --辅助函数: is_gold, 0表示不是，1表示是金大便
    sum = sum + 1
    luck = Isaac.GetPlayer(1).Luck
    if counts[luck] then
        counts[luck][1] = counts[luck][1] + 1
        counts[luck][2] = counts[luck][2] + is_gold
    else
        counts[luck] = {1, is_gold}
    end
end

function mod:update()
    -- 生成文字
    for i in pairs(counts) do
        Isaac.RenderScaledText(
            'Luck ' .. i .. ': ' .. string.format("%d/%d=%.4f%%", counts[i][2], counts[i][1], 100*counts[i][2]/counts[i][1]),
            100, 80+i*5, 0.5, 0.5, 255, 255, 255, 255);
    end

    if game:IsPaused() or game.TimeCounter < 30 then
        return
    end

    -- 大便生成与时间戳相关
    -- time = os.time() 无法获取
    time = game:GetFrameCount()
    if last_time == time then
        return
    end
    last_time = time

    player = Isaac.GetPlayer(1)
    luck = player.Luck
    if true then
        -- 自动使用白卡 x 次
        -- for i=1,2 do
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BLANK_CARD,false,false,false,false)
        -- player:UseActiveItem(CollectibleType.COLLECTIBLE_POOP,false,false,false,false)
        -- end
        if counts[luck]~= nil and counts[luck][1] >= 1000 then -- 测试一万次，加幸运
            if counts[luck][1] == counts[luck][2] then
                -- 概率 100%, 停止测试
                break
            else
                Isaac.GetPlayer(1):AddCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT, 0)
            end
        end
    end
end


function mod:remove()
    -- 统计金大便数并移除
    for i = 1, gridsize do
        gridentity = room:GetGridEntity(i)
        if gridentity ~= nil then
            etype = gridentity:GetType()
            -- 判断是否是大便
            if etype == GridEntityType.GRID_POOP then
                vari = gridentity:GetVariant()
                if vari == 0 then -- 普通大便
                    add_count(0)
                elseif vari == 3 then -- 金大便
                    add_count(1)
                end
                room:RemoveGridEntity(i,0,false)  -- 立即摧毁大便
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM , mod.remove);
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.handler_change_room);
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED , mod.handler_game_start);