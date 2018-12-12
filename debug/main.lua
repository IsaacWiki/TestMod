local mod = RegisterMod( "debug", 1);
local spawnModItems = false;
local spawnModTrinkets = false;
local debugGameValues = false;
local debugSfxs = false;
local debugEnemies = false;
local debugPickups = false;
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
local last_tear = nil;
local init_h = 0;
local init_fv = 0;
local init_fa = 0;
local init_x = 0;
local last_x = 0;

function mod:update()

	local entities = Isaac.GetRoomEntities();
    DebugMaxDistance()
	for i = 1, #entities do
        if entities[i]:ToPlayer() then
            DebugPlayer(entities[i]:ToPlayer());
        elseif nil and entities[i]:ToTear() then
            DebugTear(entities[i]:ToTear());
        end
	end
end

function DebugMaxDistance()
    Isaac.RenderScaledText(
        'Init Height: ' .. init_h, 100, 25,
        1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        'Init FallV: ' .. init_fv, 100, 40,
        1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        'Max Distance: ' .. last_x - init_x,
        100, 55,
        1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        'Init FallA: ' .. init_fa,
        100, 70,
        1, 1, 255, 255, 255, 255);
end

function DebugPlayer(player)
    local pos = game:GetRoom():WorldToScreenPosition(player.Position, false);
    local height = "Tear Height: " .. player.TearHeight
    local falling_speed = "Tear Falling Speed: " .. player.TearFallingSpeed
    local falling_acceleration = "Tear Falling Acceleration: " .. player.TearFallingAcceleration
    Isaac.RenderScaledText(
        height,
        pos.X - 30, pos.Y - 50,
        0.8, 0.8, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        falling_speed,
        pos.X - 30, pos.Y - 60,
        0.8, 0.8, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        falling_acceleration,
        pos.X - 30 , pos.Y - 70,
        0.8, 0.8, 255, 255, 255, 255);
end

function DebugTear(tear)
        
    -- local height = "Height: " .. tear.Height
    local fallv = "FallV: " .. tear.FallingSpeed
    local falla = "FallA: " .. tear.FallingAcceleration
    local Rotation = "Rotation: " .. tear.Rotation
    local Scale = "Scale: " .. tear.Scale
    local BaseScale = "BaseScale: " .. tear.BaseScale
    if last_tear == nil then
        last_tear = 1
        init_h = tear.Height
        init_fv = tear.FallingSpeed
        init_x = tear.Position.X
    end
    last_x = tear.Position.X
    Isaac.RenderScaledText(
        height, 300, 25,
        1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        fallv, 300, 40,
        1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        falla, 300, 55,
        1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        Rotation, 300, 70,
        1, 1, 255, 255, 255, 255);
    Isaac.RenderScaledText(
        Scale, 300, 85,
        1, 1, 255, 255, 255, 255);    
    Isaac.RenderScaledText(
        BaseScale, 300, 100,
        1, 1, 255, 255, 255, 255);
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
	if (cmd == "tear") then
		if (string.lower(params) == "reset") then
            last_tear = nil
            init_h = nil;
            init_fv = nil;
            init_x = 0;
            init_fa = 0;
            last_x = 0;
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