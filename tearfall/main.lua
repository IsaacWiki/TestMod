local mod = RegisterMod("tearfall", 1);
local game = Game();
local heights = {};
local fallvs = {};
local fallas = {0};
local count = 1
local init_x = 0;
local sec_x = 0;
local last_x = 0;

function floats_to_str(s)
    local t = {}
    for k,v in ipairs(s) do
        t[#t+1] = string.format('%.2f', v)
    end
    return table.concat(t, ",")
end

function caculate_a()
    for i, v in ipairs(fallvs) do
        if i > 1 then
            fallas[i] = fallvs[i] - fallvs[i-1]
        end
    end
end

function mod:update()
	local entities = Isaac.GetRoomEntities();
    DebugMaxDistance()
	for i = 1, #entities do
        if entities[i]:ToPlayer() then
            DebugPlayer(entities[i]:ToPlayer());
        elseif entities[i]:ToTear() then
            UpdateTearState(entities[i]:ToTear());
        end
	end
end

function DebugMaxDistance()
    heightstr = floats_to_str(heights)
    Isaac.RenderScaledText(
        'Heights: ' .. heightstr, 100, 25,
        0.5, 0.5, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        'FallVs: ' .. floats_to_str(fallvs), 100, 40,
        0.5, 0.5, 255, 255, 255, 255);    
    Isaac.RenderScaledText(
        'Max Distance: ' .. last_x - init_x,
        100, 55,
        0.5, 0.5, 255, 255, 255, 255);
    caculate_a(fallvs, fallas)   
    Isaac.RenderScaledText(
        'FallAs: ' .. floats_to_str(fallas),
        100, 70,
        0.5, 0.5, 255, 255, 255, 255);    
end

function DebugPlayer(player)
    heights[1] = - player.TearHeight
    fallvs[1] = player.TearFallingSpeed
    fallas[1] = 0
    Isaac.RenderScaledText(
        'Size: ' .. player.SizeMulti.X .. ', ' .. player.SizeMulti.Y,
        50, 70,
        0.5, 0.5, 255, 255, 255, 255);    
end

function UpdateTearState(tear)
    count = count + 1
    if count % 2 == 0 then
        heights[count / 2] = - tear.Height
        fallvs[count / 2] = - tear.FallingSpeed
    end
end


mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
