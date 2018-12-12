local nopickupcapmod = RegisterMod( "No Pickup Cap", 1);

local HUDoffset = 0 -- set this to your preferred HUD offset level (0-10)

PickupCapCoinNum = 0
PickupCapBombNum = 0
PickupCapKeyNum = 0

PickupCapCoinLimit = -9
PickupCapBombLimit = -9
PickupCapKeyLimit = -9

local coincheck = 0
local bombcheck = 0
local keycheck = 0

local modrunning = false

local inshop = false
local coindisplayamount = 0

local basedamage = 0
local damageboost = 0
local healthboost = 0
local gulletamount = -1

local shopcap = 20
local allunder100 = false

local updatechecks = false

local tarotID = Isaac.GetItemIdByName("Tarot Cloth")

debug_text = ""

--max usable value actually seems to be 9223372036854775807 but that doesnt look as nice
local maxvalue = 999999999999999999

local hudOn = true

function nopickupcapmod:PostPlayerInit(player)
	--reset or load extra pickups data
	if Game():GetFrameCount() < 3 then
		PickupCapCoinNum = player:GetNumCoins()
		PickupCapBombNum = player:GetNumBombs()
		PickupCapKeyNum = player:GetNumKeys()
		local temp = savepickupdata()
		Isaac.SaveModData(nopickupcapmod, temp)
		damageboost = 0
		healthboost = 0
		gulletamount = 0
		basedamage = player.Damage
	end
	local temp = Isaac.LoadModData(nopickupcapmod)
	loadpickupdata(temp)
	updatechecks = true
	lastcoinnum = PickupCapKeyNum
	modrunning = true
end

--convert data for loading
function loadpickupdata(str)
	local section = 0
	local coinstring = ""
	local keystring = ""
	local bombstring = ""
	local coinlimitstring = ""
	local keylimitstring = ""
	local bomblimitstring = ""
	local hudstring = ""
	for i = 1, string.len(str), 1 do
		local substring = string.sub(str, i, i)
		if substring == "#" then
			section = section + 1
		else
			if section == 0 then
				hudstring = hudstring .. substring
			elseif section == 1 then
				coinlimitstring = coinlimitstring .. substring
			elseif section == 2 then
				keylimitstring = keylimitstring .. substring
			elseif section == 3 then
				bomblimitstring = bomblimitstring .. substring
			elseif section == 4 then
				coinstring = coinstring .. substring
			elseif section == 5 then
				keystring = keystring .. substring
			elseif section == 6 then
				bombstring = bombstring .. substring
			end
		end
	end
	PickupCapCoinNum = tonumber(coinstring)
	PickupCapKeyNum = tonumber(keystring)
	PickupCapBombNum = tonumber(bombstring)
	PickupCapCoinLimit = tonumber(coinlimitstring)
	PickupCapKeyLimit = tonumber(keylimitstring)
	PickupCapBombLimit = tonumber(bomblimitstring)
	HUDoffset = tonumber(hudstring)
end
--convert data for saving
function savepickupdata()
	local str = ""
	str = str .. HUDoffset
	str = str .. "#"
	str = str .. PickupCapCoinLimit
	str = str .. "#"
	str = str .. PickupCapKeyLimit
	str = str .. "#"
	str = str .. PickupCapBombLimit
	str = str .. "#"
	str = str .. PickupCapCoinNum
	str = str .. "#"
	str = str .. PickupCapKeyNum
	str = str .. "#"
	str = str .. PickupCapBombNum
	return str
end

--let player set variables in console
function nopickupcapmod:onCmd(cmd, param)
	if cmd == "hudoffset" then
		if tonumber(param) > -1 and tonumber(param) < 11 then
			HUDoffset = tonumber(param)
			Isaac.ConsoleOutput("HUD offset updated")
		else
			Isaac.ConsoleOutput("Please enter a valid number")
		end
	end
	if cmd == "pickupcap" then
		if tonumber(param) > -10 then
			PickupCapCoinLimit = tonumber(param)
			PickupCapKeyLimit = tonumber(param)
			PickupCapBombLimit = tonumber(param)
			Isaac.ConsoleOutput("Pickup caps updated")
		else
			Isaac.ConsoleOutput("Please enter a valid number")
		end
	end
	if cmd == "coincap" then
		if tonumber(param) > -10 then
			PickupCapCoinLimit = tonumber(param)
			Isaac.ConsoleOutput("Coin cap updated")
		else
			Isaac.ConsoleOutput("Please enter a valid number")
		end
	end
	if cmd == "bombcap" then
		if tonumber(param) > -10 then
			PickupCapBombLimit = tonumber(param)
			Isaac.ConsoleOutput("Bomb cap updated")
		else
			Isaac.ConsoleOutput("Please enter a valid number")
		end
	end
	if cmd == "keycap" then
		if tonumber(param) > -10 then
			PickupCapKeyLimit = tonumber(param)
			Isaac.ConsoleOutput("Key cap updated")
		else
			Isaac.ConsoleOutput("Please enter a valid number")
		end
	end
	if cmd == "showpickupcaps" then
		Isaac.ConsoleOutput("Current coin cap is " .. PickupCapCoinLimit)
		Isaac.ConsoleOutput("Current bomb cap is " .. PickupCapBombLimit)
		Isaac.ConsoleOutput("Current key cap is " .. PickupCapKeyLimit)
	end
end




function nopickupcapmod:tick()
	--toggle extra hud on key press
	if Game():GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then
		hudOn = false
	else
		hudOn = true
	end
	
	
	local player = Isaac.GetPlayer(0)
	--detect luamod reset
	if modrunning == false then
		modrunning = true
		local temp = Isaac.LoadModData(nopickupcapmod)
		loadpickupdata(temp)
		coincheck = player:GetNumCoins()
		bombcheck = player:GetNumBombs()
		keycheck = player:GetNumKeys()
		local coinstring = coincheck .. ""
		if string.len(coinstring) > 1 then
			local firstdigit = tonumber(string.sub(coinstring, 1, 1))
			coincheck = firstdigit
		end
		local bombstring = bombcheck .. ""
		if string.len(bombstring) > 1 then
			local firstdigit = tonumber(string.sub(bombstring, 1, 1))
			bombcheck = firstdigit
		end
		local keystring = keycheck .. ""
		if string.len(keystring) > 1 then
			local firstdigit = tonumber(string.sub(keystring, 1, 1))
			keycheck = firstdigit
		end
		damageboost = 0
		healthboost = 0
		gulletamount = -1
	end
	
	
	--dont let values exceed number storage limit
	if PickupCapCoinLimit > maxvalue then
		PickupCapCoinLimit = maxvalue
	end
	if PickupCapBombLimit > maxvalue then
		PickupCapBombLimit = maxvalue
	end
	if PickupCapKeyLimit > maxvalue then
		PickupCapKeyLimit = maxvalue
	end
	if PickupCapCoinNum > maxvalue then
		PickupCapCoinNum = maxvalue
	end
	if PickupCapBombNum > maxvalue then
		PickupCapBombNum = maxvalue
	end
	if PickupCapKeyNum > maxvalue then
		PickupCapKeyNum = maxvalue
	end
	--dont let pickups exceed limits
	if PickupCapCoinNum > PickupCapCoinLimit and PickupCapCoinLimit >= 0 then
		PickupCapCoinNum = PickupCapCoinLimit
	end
	if PickupCapBombNum > PickupCapBombLimit and PickupCapBombLimit >= 0 then
		PickupCapBombNum = PickupCapBombLimit
	end
	if PickupCapKeyNum > PickupCapKeyLimit and PickupCapKeyLimit >= 0 then
		PickupCapKeyNum = PickupCapKeyLimit
	end
	--set negative limits to max
	if PickupCapCoinLimit < 0 then
		PickupCapCoinLimit = maxvalue
	end
	if PickupCapBombLimit < 0 then
		PickupCapBombLimit = maxvalue
	end
	if PickupCapKeyLimit < 0 then
		PickupCapKeyLimit = maxvalue
	end
	--also don't let the players pickups go negative somehow
	if PickupCapCoinNum < 0 then
		PickupCapCoinNum = 0
	end
	if PickupCapBombNum < 0 then
		PickupCapBombNum = 0
	end
	if PickupCapKeyNum < 0 then
		PickupCapKeyNum = 0
	end
	
	--bugfix for continued run not detecting players pickup amounts
	if updatechecks then
		coincheck = player:GetNumCoins()
		bombcheck = player:GetNumBombs()
		keycheck = player:GetNumKeys()
		lastcoinnum = PickupCapKeyNum
	end
	updatechecks = false
	
	--check if player lost or gained pickups
	if player:GetNumCoins() ~= coincheck then
		local amount = player:GetNumCoins() - coincheck
		player:AddCoins(-amount)
		local newcount = PickupCapCoinNum + amount
		if newcount > PickupCapCoinNum or amount < 1 then--stop buffer overflow
			PickupCapCoinNum = newcount
		else
			PickupCapCoinNum = maxvalue
		end
	end
	if player:GetNumBombs() ~= bombcheck then
		local amount = player:GetNumBombs() - bombcheck
		player:AddBombs(-amount)
		local newcount = PickupCapBombNum + amount
		if newcount > PickupCapBombNum or amount < 1 then--stop buffer overflow
			PickupCapBombNum = newcount
		else
			PickupCapBombNum = maxvalue
		end
	end
	if player:GetNumKeys() ~= keycheck then
		local amount = player:GetNumKeys() - keycheck
		player:AddKeys(-amount)
		local newcount = PickupCapKeyNum + amount
		if newcount > PickupCapKeyNum or amount < 1 then--stop buffer overflow
			PickupCapKeyNum = newcount
		else
			PickupCapKeyNum = maxvalue
		end
	end
	
	
	--detect if isaac is in a shop
	inshop = false
	shopcap = 20
	local entities = Isaac.GetRoomEntities()
	for ent = 1, #entities do
		local entity = entities[ent]
		if entity.Type == 5 then
			if entity:ToPickup():IsShopItem() and entity:ToPickup().Price >= 0 then
				inshop = true
				--hacky workaround for high cost items, need to avoid greed's gullet bug
				if entity:ToPickup().Price > shopcap then
					if player:HasCollectible(501) then --player has greeds gullet
						entity:ToPickup().Price = shopcap 
					else
						if entity:ToPickup().Price > 50 then
							shopcap = 99
						else
							shopcap = 50
						end
					end
				end
			end
		end
	end
	
	--dont bother with extra digits if the limits are 99 or less
	allunder100 = false;
	if PickupCapCoinLimit < 100 and PickupCapBombLimit < 100 and PickupCapKeyLimit < 100 then
		if PickupCapCoinLimit >= 0 and PickupCapBombLimit >= 0 and PickupCapKeyLimit >= 0 then
			allunder100 = true;
		end
	end
	if allunder100 then
		local coinoffset = PickupCapCoinNum - player:GetNumCoins()
		if coinoffset ~= 0 then
			player:AddCoins(coinoffset)
		end
		local bomboffset = PickupCapBombNum - player:GetNumBombs()
		if bomboffset ~= 0 then
			player:AddBombs(bomboffset)
		end
		local keyoffset = PickupCapKeyNum - player:GetNumKeys()
		if keyoffset ~= 0 then
			player:AddKeys(keyoffset)
		end
	else
		--adjust games 2 digit coin display
		if inshop == false then
			local coinsstring = PickupCapCoinNum .. ""
			local coindisplaylength = string.len(coinsstring)
			local coinoffset = 0
			if coindisplaylength < 2 then
				coinoffset = PickupCapCoinNum - player:GetNumCoins()
			else
				local firstdigit = string.sub(coinsstring, 1, 1)
				local cappedcount = tonumber(firstdigit)
				coinoffset = cappedcount - player:GetNumCoins()
			end
			if coinoffset ~= 0 then
				player:AddCoins(coinoffset)
			end
		else--if player is in a shop
			coindisplayamount = PickupCapCoinNum
			if coindisplayamount > shopcap then
				coindisplayamount = shopcap
			end
			local coinoffset = coindisplayamount - player:GetNumCoins()
			if coinoffset ~= 0 then
				player:AddCoins(coinoffset)
			end
		end
		--adjust games 2 digit bomb display
		local bombsstring = PickupCapBombNum .. ""
		local bombdisplaylength = string.len(bombsstring)
		local bomboffset = 0
		if bombdisplaylength < 2 then
			bomboffset = PickupCapBombNum - player:GetNumBombs()
		else
			local firstdigit = string.sub(bombsstring, 1, 1)
			local cappedcount = tonumber(firstdigit)
			bomboffset = cappedcount - player:GetNumBombs()
		end
		if bomboffset ~= 0 then
			player:AddBombs(bomboffset)
		end
		--adjust games 2 digit key display
		local keysstring = PickupCapKeyNum .. ""
		local keydisplaylength = string.len(keysstring)
		local keyoffset = 0
		if keydisplaylength < 2 then
			keyoffset = PickupCapKeyNum - player:GetNumKeys()
		else
			local firstdigit = string.sub(keysstring, 1, 1)
			local cappedcount = tonumber(firstdigit)
			keyoffset = cappedcount - player:GetNumKeys()
		end
		if keyoffset ~= 0 then
			player:AddKeys(keyoffset)
		end
	end
	
	--update pickup number checkers
	coincheck = player:GetNumCoins()
	bombcheck = player:GetNumBombs()
	keycheck = player:GetNumKeys()
	
	--make sure pickup counts dont have decimal points
	PickupCapCoinNum = math.floor(PickupCapCoinNum)
	PickupCapBombNum = math.floor(PickupCapBombNum)
	PickupCapKeyNum = math.floor(PickupCapKeyNum)
	
	--save extra pickup data
	local temp = savepickupdata()
	Isaac.SaveModData(nopickupcapmod, temp)
	
	--check for greeds gullet
	if allunder100 == false then
		if player:HasCollectible(109) then
			if player.Damage < basedamage+damageboost then
				player.Damage = basedamage+damageboost
			end
		end
		if player:HasCollectible(501) then -- greeds gullet
			if gulletamount == -1 then
				gulletamount = PickupCapCoinNum
			end
			local newhealthboost = math.floor((PickupCapCoinNum-gulletamount)/25)
			if healthboost ~= newhealthboost then
				local hpupdate = 2*(newhealthboost - healthboost)
				player:AddMaxHearts(hpupdate, false)
			end
			healthboost = newhealthboost
		end
		if player:HasCollectible(501) == false and healthboost > 0 then -- detect loss of item
			player:AddMaxHearts(-2*healthboost, false)
			healthboost = 0
			gulletamount = -1
		end
	end
end



local pickupnumbers = Sprite()
pickupnumbers:Load("gfx/ui/hudpickupnumbers.anm2", true)
function nopickupcapmod:displayinfo()
	local currentRoom = Game():GetLevel():GetCurrentRoom()
	local Xoffsetmin = 31
	local Xoffset = Xoffsetmin + (HUDoffset*2)
	local Yoffset = 41 + (HUDoffset*1.2)
	local numbersize = Vector(6,12)
	local coinstring = "" .. PickupCapCoinNum
	local bombstring = "" .. PickupCapBombNum
	local keystring = "" .. PickupCapKeyNum
	local allunder100 = false;
	local bosscheck = true
	if currentRoom:IsClear() == false and currentRoom:GetFrameCount() == 0 and currentRoom:GetType() == RoomType.ROOM_BOSS then
		bosscheck = false
	end
	if PickupCapCoinLimit < 100 and PickupCapBombLimit < 100 and PickupCapKeyLimit < 100 then
		if PickupCapCoinLimit >= 0 and PickupCapBombLimit >= 0 and PickupCapKeyLimit >= 0 then
			allunder100 = true;
		end
	end
	if allunder100 then
		pickupnumbers:Render(Vector(-99,-99), Vector(0,0), Vector(0,0))
	elseif bosscheck and hudOn then
		if inshop == false then
			for i = 2, string.len(coinstring), 1 do
				local digit = string.sub(coinstring, i, i)
				if digit == "." then break end
				pickupnumbers:Play(digit, true)
				pickupnumbers:SetOverlayRenderPriority(true)
				pickupnumbers:Render(Vector(Xoffset,Yoffset), Vector(0,0), Vector(0,0))
				Xoffset = Xoffset + numbersize.X
			end
		elseif PickupCapCoinNum > shopcap then--if player is in a shop
			local shopcoinstring = "+" .. (PickupCapCoinNum-shopcap)
			for i = 1, string.len(shopcoinstring), 1 do
				Xoffset = Xoffset + numbersize.X
				local digit = string.sub(shopcoinstring, i, i)
				if digit == "." then break end
				pickupnumbers:Play(digit, true)
				pickupnumbers:SetOverlayRenderPriority(true)
				pickupnumbers:Render(Vector(Xoffset,Yoffset), Vector(0,0), Vector(0,0))
			end
		end
		Xoffset = Xoffsetmin + (HUDoffset*2)
		Yoffset = Yoffset + numbersize.Y
		for i = 2, string.len(bombstring), 1 do
			local digit = string.sub(bombstring, i, i)
			if digit == "." then break end
			pickupnumbers:Play(digit, true)
			pickupnumbers:SetOverlayRenderPriority(true)
			pickupnumbers:Render(Vector(Xoffset,Yoffset), Vector(0,0), Vector(0,0))
			Xoffset = Xoffset + numbersize.X
		end
		Xoffset = Xoffsetmin + (HUDoffset*2)
		Yoffset = Yoffset + numbersize.Y
		for i = 2, string.len(keystring), 1 do
			local digit = string.sub(keystring, i, i)
			if digit == "." then break end
			pickupnumbers:Play(digit, true)
			pickupnumbers:SetOverlayRenderPriority(true)
			pickupnumbers:Render(Vector(Xoffset,Yoffset), Vector(0,0), Vector(0,0))
			Xoffset = Xoffset + numbersize.X
		end
	end
	Isaac.RenderText(debug_text, 50, 50, 0, 255, 0, 255)
end

function nopickupcapmod:onCard(CardID)--check if player uses a '2 of' card
	local player = Isaac.GetPlayer(0)
	if not allunder100 then
		if CardID == 23 and PickupCapBombNum > 4 then
			player:AddBombs(-player:GetNumBombs()*0.5)
			local newcount = 2*PickupCapBombNum
			if newcount >= 0 or PickupCapBombNum < 10 then--stop buffer overflow
				PickupCapBombNum = newcount
			else
				PickupCapBombNum = maxvalue
			end
		end
		if CardID == 24 and PickupCapCoinNum > 4 then
			if inshop and PickupCapCoinNum > shopcap then
				player:AddCoins(-player:GetNumCoins()) --account for higher shop limit
				player:AddCoins(shopcap)
			else
				player:AddCoins(-player:GetNumCoins()*0.5)
			end
			local newcount = 2*PickupCapCoinNum
			if newcount >= 0 or PickupCapCoinNum < 10 then--stop buffer overflow
				PickupCapCoinNum = newcount
			else
				PickupCapCoinNum = maxvalue
			end
		end
		if CardID == 25 and PickupCapKeyNum > 4 then
			player:AddKeys(-player:GetNumKeys()*0.5)
			local newcount = 2*PickupCapKeyNum
			if newcount >= 0 or PickupCapKeyNum < 10 then--stop buffer overflow
				PickupCapKeyNum = newcount
			else
				PickupCapKeyNum = maxvalue
			end
		end
	end
end

function nopickupcapmod:onPill(pillID)
	local player = Isaac.GetPlayer(0)
	if pillID == 3 then--check if player uses bombs are key pill
		local temp = PickupCapKeyNum
		PickupCapKeyNum = PickupCapBombNum
		PickupCapBombNum = temp
		local offset = 0
		if player:GetNumBombs() > player:GetNumKeys() then
			offset = player:GetNumBombs() - player:GetNumKeys()
			PickupCapKeyNum = PickupCapKeyNum + offset
			PickupCapBombNum = PickupCapBombNum - offset
		else
			offset = player:GetNumKeys() - player:GetNumBombs()
			PickupCapBombNum = PickupCapBombNum + offset
			PickupCapKeyNum = PickupCapKeyNum - offset
		end
	end
end

local lastcoinnum = 0
local canceldamageboost = false
function nopickupcapmod:cacheUpdate()
	local player = Isaac.GetPlayer(0)
	--check for money = power
	if PickupCapCoinNum ~= lastcoinnum then
		if allunder100 == false then
			if player:HasCollectible(109) then
				basedamage = player.Damage - 0.08*player:GetNumCoins()
				player.Damage = basedamage
				damageboost = 0.04*PickupCapCoinNum
				if PickupCapCoinNum % 10 == 0 then --workaround for weird bug
					local tempcoinstring = PickupCapCoinNum .. ""
					local divisor = "1"
					while string.len(divisor) < string.len(tempcoinstring) do
						divisor = divisor .. "0"
					end
					if PickupCapCoinNum % tonumber(divisor) == 0 then
						damageboost = damageboost - 0.04
						canceldamageboost = true
					end
				end
				lastcoinnum = PickupCapCoinNum
			end
		else
			player.Damage = player.Damage - 0.04*player:GetNumCoins()
			lastcoinnum = PickupCapCoinNum
		end
	else
		if canceldamageboost then --workaround for weird bug
			local tempcoinstring = PickupCapCoinNum .. ""
			local divisor = "1"
			while string.len(divisor) < string.len(tempcoinstring) do
				divisor = divisor .. "0"
			end
			if PickupCapCoinNum % tonumber(divisor) == 0 then
				damageboost = damageboost + 0.04
				canceldamageboost = false
			end
		end
	end
end

nopickupcapmod:AddCallback(ModCallbacks.MC_POST_UPDATE, nopickupcapmod.tick);
nopickupcapmod:AddCallback(ModCallbacks.MC_POST_RENDER, nopickupcapmod.displayinfo);
nopickupcapmod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, nopickupcapmod.PostPlayerInit);
nopickupcapmod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, nopickupcapmod.onCmd);
nopickupcapmod:AddCallback(ModCallbacks.MC_USE_CARD, nopickupcapmod.onCard);
nopickupcapmod:AddCallback(ModCallbacks.MC_USE_PILL, nopickupcapmod.onPill);
nopickupcapmod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE , nopickupcapmod.cacheUpdate);