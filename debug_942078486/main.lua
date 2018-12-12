local mod = RegisterMod( "debug", 1);
local spawnModItems = true;
local spawnModTrinkets = true;
local debugGameValues = true;
local debugSfxs = true;
local debugEnemies = true;
local debugPickups = true;
local debugCollectibles = false;
local tryDebugAll = true;

local sfxsPlayedThisRoom = {};

-- Enum init --
	local stateList = {"init", "appear", "appear custom", "idle", "move", "suicide", "jump", "stomp", "attack",
	"attack2", "attack3", "attack4", "summon", "summon2", "summon3", "special", "unique death", "death"};

	local damageFlagList = {"no kill", "fire", "explosion", "laser", "acid", "red hearts", "countdown", "spikes", "clones", "poop", "devil",
	"isaac's' heart", "tnt", "invincible", "spawn fly", "poison burn", "cursed door", "timer", "IV bag", "pitfall", "chest", "fake"};

	local curseList = {"darkness", "labyrinth", "lost", "unknown", "cursed", "maze", "blind"};

	local sfxList = {"1UP", "BIRD_FLAP", "BLOBBY_WIGGLE", "INSECT_SWARM_LOOP", "BLOOD_LASER", "", "BLOOD_LASER_LARGE", "BOOK_PAGE_TURN_12", "BOSS_BUG_HISS", "",
    "BOSS_GURGLE_ROAR", "BOSS_LITE_GURGLE", "BOSS_LITE_HISS", "BOSS_LITE_ROAR", "BOSS_LITE_SLOPPY_ROAR", "BOSS_SPIT_BLOB_BARF", "", "", "", "", "CHEST_DROP", "CHEST_OPEN",
    "CHOIR_UNLOCK", "COIN_SLOT", "CUTE_GRUNT", "", "", "DEATH_BURST_LARGE", "", "DEATH_BURST_SMALL", "", "", "DEATH_CARD", "DEVIL_CARD", "DOOR_HEAVY_CLOSE", "DOOR_HEAVY_OPEN",
    "FART", "FETUS_JUMP", "", "FETUS_LAND", "", "", "FIREDEATH_HISS", "FLOATY_BABY_ROAR", "", "", "", "FORESTBOSS_STOMPS", "", "", "GASCAN_POUR", "HELLBOSS_GROUNDPOUND", "",
    "HOLY", "ISAAC_HURT_GRUNT", "CHILD_HAPPY_ROAR_SHORT", "CHILD_ANGRY_ROAR", "KEYPICKUP_GAUNTLET", "KEY_DROP0", "BABY_HURT", "", "", "", "MAGGOT_BURST_OUT", "", "MAGGOT_ENTER_GROUND",
    "", "MEAT_FEET_SLOW0", "MEAT_IMPACTS", "", "", "MEAT_JUMPS", "", "", "", "", "MEATY_DEATHS", "", "", "", "", "MOM_VOX_DEATH", "", "MOM_VOX_EVILLAUGH", "MOM_VOX_FILTERED_DEATH_1",
    "MOM_VOX_FILTERED_EVILLAUGH", "MOM_VOX_FILTERED_HURT", "", "", "MOM_VOX_FILTERED_ISAAC", "", "", "MOM_VOX_GRUNT", "", "", "", "MOM_VOX_HURT", "", "", "", "MOM_VOX_ISAAC01", "", "",
    "MONSTER_GRUNT_0", "", "MONSTER_GRUNT_1", "", "MONSTER_GRUNT_2", "", "", "", "MONSTER_GRUNT_4", "", "MONSTER_GRUNT_5", "MONSTER_ROAR_0", "MONSTER_ROAR_1", "MONSTER_ROAR_2",
    "MONSTER_ROAR_3", "MONSTER_YELL_A", "", "", "MONSTER_YELL_B", "", "", "", "", "", "POWERUP1", "POWERUP2", "POWERUP3", "", "POWERUP_SPEWER", "REDLIGHTNING_ZAP", "", "", "",
    "ROCK_CRUMBLE", "POT_BREAK", "MUSHROOM_POOF", "", "ROCKET_BLAST_DEATH", "SMB_LARGE_CHEWS_4", "SCARED_WHIMPER", "", "", "SHAKEY_KID_ROAR", "", "", "SINK_DRAIN_GURGLE", "TEARIMPACTS",
    "", "", "TEARS_FIRE", "", "", "UNLOCK00", "VAMP_GULP", "WHEEZY_COUGH", "SPIDER_COUGH", "", "", "", "", "", "ZOMBIE_WALKER_KID", "ANIMAL_SQUISH", "ANGRY_GURGLE", "", "BAND_AID_PICK_UP",
    "BATTERYCHARGE", "BEEP", "", "", "", "BLOODBANK_SPAWN", "", "", "BLOODSHOOT", "", "", "BOIL_HATCH", "BOSS1_EXPLOSIONS", "", "", "BOSS2_BUBBLES", "", "BOSS2INTRO_ERRORBUZZ", "", "",
    "CASTLEPORTCULLIS", "", "", "", "CHARACTER_SELECT_LEFT", "CHARACTER_SELECT_RIGHT", "", "DERP", "DIMEDROP", "DIMEPICKUP", "", "FETUS_FEET", "", "", "GOLDENKEY", "GOOATTACH0", "",
    "GOODEATH", "", "", "", "HAND_LASERS", "HEARTIN", "HEARTOUT", "HELL_PORTAL1", "HELL_PORTAL2", "", "ISAACDIES", "ITEMRECHARGE", "KISS_LIPS1", "", "LEECH", "", "", "MAGGOTCHARGE", "",
    "MEATHEADSHOOT", "", "", "METAL_BLOCKBREAK", "", "NICKELDROP", "NICKELPICKUP", "PENNYDROP", "PENNYPICKUP", "", "", "PLOP", "SATAN_APPEAR", "SATAN_BLAST", "SATAN_CHARGE_UP",
    "SATAN_GROW", "SATAN_HURT", "SATAN_RISE_UP", "", "SATAN_SPIT", "SATAN_STOMP", "", "", "SCAMPER", "", "", "SHELLGAME", "", "", "SLOTSPAWN", "", "", "SPLATTER", "", "", "STEAM_HALFSEC",
    "STONESHOOT", "WEIRD_WORM_SPIT", "", "SUMMONSOUND", "SUPERHOLY", "THUMBS_DOWN", "THUMBSUP", "FIRE_BURN", "HAPPY_RAINBOW", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "BOO_MAD", "FART_GURG", "FAT_GRUNT", "FAT_WIGGLE", "FIRE_RUSH", "GHOST_ROAR", "GHOST_SHOOT", "GRROOWL", "GURG_BARF", "INHALE",
    "LOW_INHALE", "MEGA_PUKE", "MOUTH_FULL", "MULTI_SCREAM", "SKIN_PULL", "WHISTLE", "DEVILROOM_DEAL", "SPIDER_SPIT_ROAR", "WORM_SPIT", "LITTLE_SPIT", "SATAN_ROOM_APPEAR", "HEARTBEAT",
    "HEARTBEAT_FASTER", "HEARTBEAT_FASTEST", "48_HR_ENERGY", "ALGIZ", "AMNESIA", "ANZUS", "BAD_GAS", "BAD_TRIP", "BALLS_OF_STEEL", "BERKANO", "BOMBS_ARE_KEY", "CARD_VS_HUMAN", "CHAOS_CARD",
    "CREDIT_CARD", "DAGAZ", "DEATH", "EHWAZ", "EXPLOSIVE_DIAH", "FULL_HP", "HAGALAZ", "HP_DOWN", "HP_UP", "HEMATEMISIS", "I_FOUND_PILLS", "JERA", "JOKER", "JUDGEMENT", "JUSTICE",
    "LEMON_PARTY", "LUCK_DOWN", "LUCK_UP", "PARALYSIS", "PERTHRO", "PHEROMONES", "PRETTY_FLY", "PUBERTY", "RUA_WIZ", "RANGE_DOWN", "RANGE_UP", "RULES_CARD", "SEE_4EVER", "SPEED_DOWN",
    "SPEED_UP", "STRENGTH", "SUICIDE_KING", "TEARS_DOWN", "TEARS_UP", "TELEPILLS", "TEMPERANCE", "THE_CHARIOT", "THE_DEVIL", "THE_EMPEROR", "EMPRESS", "FOOL", "HANGED_MAN", "HERMIT",
    "HIEROPHANT", "HIGHT_PRIESTESS", "THE_LOVERS", "MAGICIAN", "MOON", "STARS", "SUN", "TOWER", "WORLD", "TWO_CLUBS", "TWO_DIAMONDS", "TWO_HEARTS", "TWO_SPADES", "WHEEL_OF_FORTUNE",
    "RAGMAN_1", "RAGMAN_2", "RAGMAN_3", "RAGMAN_4", "FLUSH", "WATER_DROP", "WET_FEET", "ADDICTED", "DICE_SHARD", "EMERGENCY", "INFESTED_EXCL", "INFESTED_QUEST", "JAIL_CARD", "LARGER",
    "PERCS", "POWER_PILL", "QUESTION_MARK", "RELAX", "RETRO", "SMALL", "QQQ", "DANGLE_WHISTLE", "LITTLE_HORN_COUGH", "LITTLE_HORN_GRUNT_1", "LITTLE_HORN_GRUNT_2", "THE_FORSAKEN_LAUGH",
    "THE_FORSAKEN_SCREAM", "THE_STAIN_BURST", "BROWNIE_LAUGH", "HUSH_ROAR", "HUSH_GROWL", "HUSH_LOW_ROAR", "FRAIL_CHARGE", "HUSH_CHARGE", "MAW_OF_VOID", "ULTRA_GREED_COIN_DESTROY",
    "ULTRA_GREED_COINS_FALLING", "ULTRA_GREED_DEATH_SCREAM", "ULTRA_GREED_TURN_GOLD_1", "ULTRA_GREED_TURN_GOLD_2", "ULTRA_GREED_ROAR_1", "ULTRA_GREED_ROAR_2", "ULTRA_GREED_SPIT",
    "ULTRA_GREED_PULL_SLOT", "ULTRA_GREED_SLOT_SPIN_LOOP", "ULTRA_GREED_SLOT_STOP", "ULTRA_GREED_SLOT_WIN_LOOP_END", "ULTRA_GREED_SLOT_WIN_LOOP", "ULTRA_GREED_SPINNING", "DOG_BARK",
    "DOG_HOWELL", "X_LAX", "WRONG", "VURP", "SUNSHINE", "SPADES", "HORF", "HOLY_CARD", "HEARTS", "GULP", "FRIENDS", "EXCITED", "DROWSY", "DIAMONDS", "CLUBS", "BLACK_RUNE"};

local game = Game();

function mod:update()

	local player = Isaac.GetPlayer(0);
	local entities = Isaac.GetRoomEntities();

	if debugGameValues then
		DebugGameValues();
	end

	if debugSfxs then
		UpdateSfxsPlaying();
		Isaac.RenderScaledText("Sfxs played this room:", 390, 55, 0.5, 0.5, 255, 255, 255, 255);
		for i=1, #sfxsPlayedThisRoom do
			Isaac.RenderScaledText(tostring(sfxsPlayedThisRoom[i]) .. ": SOUND_" .. sfxList[sfxsPlayedThisRoom[i]], 390, 55 + 7*i, 0.5, 0.5, 255, 255, 255, 255);
		end
	end

	for i = 1, #entities do
		
		if entities[i]:ToNPC() ~= nil then
			if debugEnemies then
				DebugEnemy(entities[i]:ToNPC());
			end
		else
            if entities[i]:ToTear()  ~= nil then
                DebugTear(entities[i]:ToTear());
            end

			if entities[i]:ToPickup() ~= nil then
				if entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE then
					if debugCollectibles then
						DebugPickup(entities[i]:ToPickup());
					end
				else
					if debugPickups then
						DebugPickup(entities[i]:ToPickup());
					end
				end
			else
				if tryDebugAll then
					DebugAnything(entities[i]);
				end
			end
		end
	end
end

function getStringWidth(value)
	return (string.len(tostring(value))*1.6) - 1;
end

function DebugGameValues()
	local player = Isaac.GetPlayer(0);
	Isaac.RenderScaledText("Character: " .. player:GetName(), 50, 35, 0.5, 0.5, 255, 255, 255, 255);
	local source = player:GetLastDamageSource();
	if source ~= nil then
		Isaac.RenderScaledText("Last damage source: " .. source.Type .. "." .. source.Variant, 50, 42, 0.5, 0.5, 255, 255, 255, 255);
	end
	local text = StringList(player:GetLastDamageFlags(), damageFlagList);
	Isaac.RenderScaledText("Last damage flags: " .. text, 50, 49, 0.5, 0.5, 255, 255, 255, 255);

	Isaac.RenderScaledText("Current room index: " .. game:GetLevel():GetCurrentRoomIndex(), 50, 63, 0.5, 0.5, 255, 255, 255, 255);
	text = StringList(game:GetLevel():GetCurses(), curseList);
	Isaac.RenderScaledText("Curses: " .. text, 50, 70, 0.5, 0.5, 255, 255, 255, 255);
end

function DebugEnemy(enemy)
	local pos = game:GetRoom():WorldToScreenPosition(enemy.Position, false); -- get its position
	
	-- render health
	local text = "" .. math.floor(enemy.HitPoints*10)/10 .. "/" .. math.floor(enemy.MaxHitPoints*10)/10;
	Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-57, 0.5, 0.5, 255, 255, 0, 255);
	
	-- render state
	text = "" .. stateList[enemy:ToNPC().State+1];
	Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-52, 0.5, 0.5, 0, 255, 255, 255);

	-- render type.variant.subtype
	text = "" .. enemy.Type .. "." .. enemy.Variant .. "." .. enemy.SubType;
	Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-47, 0.5, 0.5, 255, 255, 255, 255);
	
	-- render spawner
	text = "spawner: " .. enemy.SpawnerType .. "." .. enemy.SpawnerVariant;
	if (text ~= "spawner: 0.0") then
		Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-42, 0.5, 0.5, 255, 255, 255, 255);
	end
end

function DebugPickup(pickup)
	local pos = game:GetRoom():WorldToScreenPosition(pickup.Position, false); -- get its position

	-- render type.variant.subtype
	local text = "" .. pickup.Type .. "." .. pickup.Variant .. "." .. pickup.SubType;
	Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-27, 0.5, 0.5, 255, 255, 255, 255);
	
	-- render spawner
	text = "spawner: " .. pickup.SpawnerType .. "." .. pickup.SpawnerVariant;
	if (text ~= "spawner: 0.0") then
		Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-22, 0.5, 0.5, 255, 255, 255, 255);
	end
end


function DebugTear(tear)
    local pos = game:GetRoom():WorldToScreenPosition(tear.Position, false); -- get its position

    -- render type.variant.subtype
    local height = "Height: " .. tear.Height
    local fall = "Fall: " .. tear.FallingSpeed .. '/' .. tear.FallingAcceleration
    Isaac.RenderScaledText(
        height, pos.X-getStringWidth(height),
        pos.Y-30, 1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        fall, pos.X-getStringWidth(fall),
        pos.Y-40, 1, 1, 255, 255, 255, 255);
end




function DebugAnything(entity)
	if entity.Type ~= EntityType.ENTITY_EFFECT and entity.Type ~= EntityType.ENTITY_TEXT then -- if it's neither a text nor an effect
		local pos = game:GetRoom():WorldToScreenPosition(entity.Position, false); -- get its position
		local text = "" .. entity.Type .. "." .. entity.Variant .. "." .. entity.SubType
		Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-47, 0.5, 0.5, 255, 255, 255, 255);
		text = "spawner: " .. entity.SpawnerType .. "." .. entity.SpawnerVariant;
		if (text ~= "spawner: 0.0") then
			Isaac.RenderScaledText(text, pos.X-getStringWidth(text), pos.Y-42, 0.5, 0.5, 255, 255, 255, 255);
		end
	end
end

function UpdateSfxsPlaying()
	local sfx = SFXManager();
	for i = 1, SoundEffect.NUM_SOUND_EFFECTS do
		if sfx:IsPlaying(i) then
			local shouldAddIt = true;
			for j = 1, #sfxsPlayedThisRoom do
				if sfxsPlayedThisRoom[j] == i then
					shouldAddIt = false;
					break;
				end
			end
			if shouldAddIt then
				sfxsPlayedThisRoom[#sfxsPlayedThisRoom + 1] = i;
			end
		end
	end
end

function StringList(number, stringTable) -- it's easier to iterate on bit values this way than doing bitwise comparisons
	local bitTab = ToBitTab(number);
	local returnString = "";

	for i = 1, #stringTable do
		if bitTab[i]==1 then
			if (returnString == "") then
				returnString = returnString .. stringTable[i];
			else
				returnString = returnString .. ", " .. stringTable[i];
			end
		end
	end
	if (returnString == "") then
		return "none";
	end
	return returnString;
end

function ToBitTab(num)
    local t={};
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t;
end

function mod:start(fromsave)
	local player = Isaac.GetPlayer(0);
	if Isaac.HasModData(mod) then
		Load();
	end
	if not fromsave then
		if spawnModItems then
			local id = CollectibleType.NUM_COLLECTIBLES;
			while Isaac.GetItemConfig():GetCollectible(id) ~= nil do
				Isaac.ExecuteCommand("spawn 5.100." .. id);
				id = id+1
			end
		end
		if spawnModTrinkets then
			local id = TrinketType.NUM_TRINKETS;
			while Isaac.GetItemConfig():GetTrinket(id) ~= nil do
				Isaac.ExecuteCommand("spawn 5.350." .. id);
				id = id+1
			end
		end
	end
end

function mod:newRoom()
	sfxsPlayedThisRoom = {};
end

function mod:command(cmd, params)
	if (cmd == "moddebug") then
		if (string.lower(params) == "spawnitems") then
			spawnModItems = not spawnModItems;
			if spawnModItems then
				Isaac.ConsoleOutput("Mod item spawning enabled");
			else
				Isaac.ConsoleOutput("Mod item spawning disabled");
			end
		end
		if (string.lower(params) == "spawntrinkets") then
			spawnModTrinkets = not spawnModTrinkets;
			if spawnModTrinkets then
				Isaac.ConsoleOutput("Mod trinket spawning enabled");
			else
				Isaac.ConsoleOutput("Mod trinket spawning disabled");
			end
		end
		if (string.lower(params) == "gameinfo") then
			debugGameValues = not debugGameValues;
			if debugGameValues then
				Isaac.ConsoleOutput("Game info debugging enabled");
			else
				Isaac.ConsoleOutput("Game info debugging disabled");
			end
		end
		if (string.lower(params) == "sfx") then
			debugSfxs = not debugSfxs;
			if debugSfxs then
				Isaac.ConsoleOutput("Sfx debugging enabled");
			else
				Isaac.ConsoleOutput("Sfx debugging disabled");
			end
		end
		if (string.lower(params) == "enemies") then
			debugEnemies = not debugEnemies;
			if debugEnemies then
				Isaac.ConsoleOutput("Enemy debugging enabled");
			else
				Isaac.ConsoleOutput("Enemy debugging disabled");
			end
		end
		if (string.lower(params) == "pickups") then
			debugPickups = not debugPickups;
			if debugPickups then
				Isaac.ConsoleOutput("Pickup debugging enabled");
			else
				Isaac.ConsoleOutput("Pickup debugging disabled");
			end
		end
		if (string.lower(params) == "items") then
			debugCollectibles = not debugCollectibles;
			if debugCollectibles then
				debugPickups = true;
				Isaac.ConsoleOutput("Item debugging enabled");
			else
				Isaac.ConsoleOutput("Item debugging disabled");
			end
		end
		if (string.lower(params) == "all") then
			tryDebugAll = not tryDebugAll;
			if tryDebugAll then
				Isaac.ConsoleOutput("All entities debugging enabled");
			else
				Isaac.ConsoleOutput("All entities debugging disabled");
			end
		end
		if (string.lower(params) == "help") then
			Isaac.ConsoleOutput("spawnitems: Toggles modded items spawning");
			Isaac.ConsoleOutput("spawntrinkets: Toggles modded trinket spawning");
			Isaac.ConsoleOutput("gameinfo: Toggles game info debugging");
			Isaac.ConsoleOutput("sfx: Toggles sfx debugging");
			Isaac.ConsoleOutput("enemies: Toggles enemy debugging");
			Isaac.ConsoleOutput("pickups: Toggles pickup debugging");
			Isaac.ConsoleOutput("items: Toggles item debugging");
			Isaac.ConsoleOutput("all: Toggles all entities debugging");
		end
		Save();
	end
end

function mod:exit()
	Save();
end

function Save()
	local data = "";
	data = data .. (spawnModItems and "1" or "0");
	data = data .. (spawnModTrinkets and "1" or "0");
	data = data .. (debugGameValues and "1" or "0");
	data = data .. (debugSfxs and "1" or "0");
	data = data .. (debugEnemies and "1" or "0");
	data = data .. (debugPickups and "1" or "0");
	data = data .. (debugCollectibles and "1" or "0");
	data = data .. (tryDebugAll and "1" or "0");
	Isaac.SaveModData(mod, data);
end

function Load()
	local data = tostring(Isaac.LoadModData(mod));
	spawnModItems     = (string.sub(data, 1, 1) == "1");
	spawnModTrinkets  = (string.sub(data, 2, 2) == "1");
	debugGameValues   = (string.sub(data, 3, 3) == "1");
	debugSfxs         = (string.sub(data, 4, 4) == "1");
	debugEnemies      = (string.sub(data, 5, 5) == "1");
	debugPickups      = (string.sub(data, 6, 6) == "1");
	debugCollectibles = (string.sub(data, 7, 7) == "1");
	tryDebugAll       = (string.sub(data, 8, 8) == "1");
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.update);
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.start);
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.newRoom);
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.command);
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.exit);
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.exit);