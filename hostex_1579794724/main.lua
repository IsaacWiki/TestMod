local mod = RegisterMod("HostEX", 1)

function mod:onUpdate()
end

Level = Game():GetLevel()
Room = Game():GetLevel():GetCurrentRoom()
rng = RNG()

--spinning fucker

local ex1Entity = Isaac.GetEntityTypeByName("ex1")
local ex1Variant = Isaac.GetEntityVariantByName("ex1")

function mod:ex1_Update(npc)
if npc.Type == 27 and npc.Variant == 444 and npc.SubType == 0 then
 	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local target = npc:GetPlayerTarget()
	local sprite = npc:GetSprite()
	local dist = target.Position:Distance(npc.Position)
 local angle = (target.Position - npc.Position):GetAngleDegrees()
	if npc:GetSprite():IsEventTriggered("PewPewPew321") then
Isaac.Spawn(9, 0, 445, npc.Position, Vector.FromAngle(angle):Resized(9), npc)
end
if npc.FlipX == true then npc.FlipX = false end
end
end

function mod:ex1Damage(entity, damage_amount, damage_flags, damage_source, damage_countdown)
    local sprite = entity:GetSprite()
    local data = entity:GetData()
       if entity.Type == 27 and entity.Variant == 444 then
if entity:GetSprite():GetFrame() < 5 then
        return false
    end
end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ex1Damage, ex1)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ex1_Update, ex1Entity)

function mod:Projectile_Update(proj)
    local sprite = proj:GetSprite()
	local data = proj:GetData()
	local spawner = proj.SpawnerEntity
	if proj.Type == 9 and proj.Variant == 0 and proj.SubType == 0 then
 if proj.SpawnerType == 27 and proj.SpawnerVariant == 444 then
 proj:Remove()
 end
  if proj.SpawnerType == 27 and proj.SpawnerVariant == 445 then
 proj:Remove()
 end
   if proj.SpawnerType == 27 and proj.SpawnerVariant == 447 then
 proj:Remove()
 end
end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.Projectile_Update, 0)

	function mod:ex1(npc)
     if npc.Type == 27 and npc.Variant == 0 and npc.SubType == 0 then
      local exx1_chance = math.random(1, 3)
      if exx1_chance == 1 then
            npc:Morph(27, 444, 0, -1)
      else
        return
      end
  end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ex1, 27)

--jumping fucker

local ex21Entity = Isaac.GetEntityTypeByName("ex21")
local ex21Variant = Isaac.GetEntityVariantByName("ex21")

local ex22Entity = Isaac.GetEntityTypeByName("ex22")
local ex22Variant = Isaac.GetEntityVariantByName("ex22")

function mod:ex21_Update(npc)
 	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local sprite = npc:GetSprite()
	local data = npc:GetData()
		if npc:GetSprite():IsEventTriggered("0321") then
		data.i = 1
		Isaac.DebugString("flag 1")
		end
		if npc:GetSprite():IsEventTriggered("o321") and data.i == 1 then
		npc:Morph(29, 445, 0, -1)
		data.i = 0
		Isaac.DebugString("flag 0")
		     if npc.Type == 27 and npc.Variant == 445 and npc.SubType == 0 then
		if npc.FlipX == true then npc.FlipX = false end
		end
		end
	end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ex21_Update, ex21Entity)


function mod:ex22_Update(npc)
  	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local target = npc:GetPlayerTarget()
	local dist = target.Position:Distance(npc.Position)
 local angle = (target.Position - npc.Position):GetAngleDegrees()
	if npc.Type == 29 and npc.Variant == 445 and npc.SubType == 0 then
		if npc:GetSprite():IsEventTriggered("JumpShot321") then
Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(angle+15):Resized(8), npc)
Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(angle):Resized(9), npc)
Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(angle-15):Resized(8), npc)
		end
		if npc:GetSprite():IsEventTriggered("321o") then
		npc:Morph(27, 445, 0, -1)
		end
		if npc.FlipX == true then npc.FlipX = false end
		end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ex22_Update, ex22Entity)

function mod:ex21Damage(entity, damage_amount, damage_flags, damage_source, damage_countdown)
    local sprite = entity:GetSprite()
    local data = entity:GetData()
       if entity.Type == 27 and entity.Variant == 445 then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ex21Damage, ex21)

function mod:ex22Damage(entity, damage_amount, damage_flags, damage_source, damage_countdown)
    local sprite = entity:GetSprite()
    local data = entity:GetData()
       if entity.Type == 29 and entity.Variant == 445 then
	   if not entity:GetSprite():IsPlaying("Hop") then
        return false
		end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ex22Damage, ex22)

	function mod:ex21(npc)
     if npc.Type == 27 and npc.Variant == 0 and npc.SubType == 0 then
      local exx1_chance = math.random(1, 3)
      if exx1_chance == 1 then
            npc:Morph(27, 445, 0, -1)
      else
        return
      end
  end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ex21, 27)

--mini jumper

local minihostEntity = Isaac.GetEntityTypeByName("minihost")
local minihostVariant = Isaac.GetEntityVariantByName("minihost")

function mod:minihost_Update(npc)
 	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local sprite = npc:GetSprite()
	local data = npc:GetData()
	if data.i then
		if npc:GetSprite():IsEventTriggered("c0unt") then
    data.i = data.i + 1
	end
else
    data.i = 0
end
if data.i == 50 then
npc:Kill()
end
if npc:GetSprite():IsEventTriggered("Landed0") then
npc:PlaySound(SoundEffect.SOUND_GOOATTACH0,1,0,false,1)
Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CREEP_RED,1,npc.Position, Vector(0,0),npc)
end
if npc.Type == 11 and npc.Variant == 1 and npc.SubType == 444 then
if npc.FlipX == true then npc.FlipX = false end
end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.minihost_Update, minihostEntity)

--splitting fucker

local hsplitEntity = Isaac.GetEntityTypeByName("hsplit")
local hsplitVariant = Isaac.GetEntityVariantByName("hsplit")

function mod:hsplit_Update(npc)
 	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local sprite = npc:GetSprite()

if npc.Type == 27 and npc.Variant == 446 and npc.SubType == 0 and (npc:IsDead()) then
Isaac.Spawn(11,1,444,npc.Position, Vector(0,0),npc)
Isaac.Spawn(11,1,444,npc.Position, Vector(0,0),npc)
Isaac.Spawn(11,1,444,npc.Position, Vector(0,0),npc)
end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.hsplit_Update, hsplitEntity)

function mod:hsplitDamage(entity, damage_amount, damage_flags, damage_source, damage_countdown)
    local sprite = entity:GetSprite()
    local data = entity:GetData()
       if entity.Type == 27 and entity.Variant == 446 then
if entity:GetSprite():GetFrame() < 5 then
        return false
    end
end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.hsplitDamage, hsplit)

	function mod:hsplit(npc)
     if npc.Type == 27 and npc.Variant == 0 and npc.SubType == 0 then
      local exx1_chance = math.random(1, 3)
      if exx1_chance == 1 then
            npc:Morph(27, 446, 0, -1)
      else
        return
      end
  end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.hsplit, hsplit)

--WALKING FUCKER

local ex31Entity = Isaac.GetEntityTypeByName("ex31")
local ex31Variant = Isaac.GetEntityVariantByName("ex31")

function mod:ex31_Update(npc)
 	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local sprite = npc:GetSprite()
	local data = npc:GetData()
		if npc:GetSprite():IsEventTriggered("04321") then
		data.i = 1
		Isaac.DebugString("flag 1")
		end
		if npc:GetSprite():IsEventTriggered("o4321") and data.i == 1 then
		npc:Morph(207, 444, 0, -1)
		data.i = 0
		Isaac.DebugString("flag 0")
		     if npc.Type == 27 and npc.Variant == 447 and npc.SubType == 0 then
		if npc.FlipX == true then npc.FlipX = false end
		end
		end
	end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ex31_Update, ex31Entity)

local ex32Entity = Isaac.GetEntityTypeByName("ex32")
local ex32Variant = Isaac.GetEntityVariantByName("ex32")

function mod:ex32_Update(npc)
 	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local sprite = npc:GetSprite()
	local data = npc:GetData()
	if data.a then
		if npc:GetSprite():IsEventTriggered("N3W") then
    data.a = data.a + 1
	end
else
    data.a = 0
end
if data.a == 10 then
data.a = 0
npc:Morph(27, 447, 0, -1)
end
if npc:GetSprite():IsEventTriggered("4ss") and data.a == 1 then
Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(angle+15):Resized(8), npc)
Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(angle):Resized(9), npc)
Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(angle-15):Resized(8), npc)
end
if npc.Type == 207 and npc.Variant == 447 and npc.SubType == 0 then
if npc.FlipX == true then npc.FlipX = false end
end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ex32_Update, ex32Entity)

function mod:ex31Damage(entity, damage_amount, damage_flags, damage_source, damage_countdown)
    local sprite = entity:GetSprite()
    local data = entity:GetData()
       if entity.Type == 27 and entity.Variant == 447 then
if entity:GetSprite():GetFrame() < 5 then
        return false
    end
end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ex31Damage, ex31)

	function mod:ex31(npc)
     if npc.Type == 27 and npc.Variant == 0 and npc.SubType == 0 then
      local exx1_chance = math.random(1, 3)
      if exx1_chance == 1 then
            npc:Morph(27, 447, 0, -1)
      else
        return
      end
  end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ex31, ex31)