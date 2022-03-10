----						  [ Coder ]						  ----
---- 							 -т-						  ----
----  https://forums.kleientertainment.com/profile/365042-t/  ----
----  					  Discord: -т-#1234				  	  ----

local require = GLOBAL.require

GLOBAL.CHEATS_ENABLED = true
require("debugkeys")

--\/ INIT \/--

modimport("init/init_assets")
modimport("init/init_prefabs")
modimport("init/init_desc")
modimport("init/init_strings")
modimport("init/init_tuning")
modimport("init/init_recipes")

--/\ INIT /\--

--\/ EXTERNAL CODE \/--

modimport("scripts/addbestiaryaction")
modimport("scripts/addstates")
modimport("scripts/bestiarypopup")
modimport("scripts/bestiaryhud")

--/\ EXTERNAL CODE /\--

GLOBAL.global("TheBestiary")
GLOBAL.TheBestiary = nil
GLOBAL.TheBestiary = require("bestiarydata")()
GLOBAL.TheBestiary:Load()

GLOBAL.DISCOVERABLE_MOBS_CONFIG = GetModConfigData("Discoverable Mobs")

AddPlayerPostInit(function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("bestiaryreader")
end)

if not GLOBAL.DISCOVERABLE_MOBS_CONFIG then -- Skip all the 'discovering' part if it's disabled
	return
end

AddClientModRPCHandler("bestiarymod", "DiscoverMob", function(mob, ...)
	local bestiaryupdater = GLOBAL.ThePlayer.components.bestiaryupdater

	if bestiaryupdater and mob then
		bestiaryupdater:DiscoverMob(mob)
	end
end)

AddClientModRPCHandler("bestiarymod", "LearnMob", function(mob, ...)
	local bestiaryupdater = GLOBAL.ThePlayer.components.bestiaryupdater

	if bestiaryupdater and mob then
		bestiaryupdater:LearnMob(mob)
	end
end)

AddModRPCHandler("bestiarymod", "ForgetBestiary", function(player)
	player.components.bestiaryupdater:Forgor() -- Server sided
end)

local function IsInMonstersTable(mob)
	for i, data in ipairs(require "monsterinfo") do
		if (data.prefab or data.forms[1].prefab) == (mob.discoverable_prefab or mob.prefab) then
			return true
		end
	end

	return false
end

local CANT_TAGS = { "structure", "FX", "DECOR", "NOCLICK", "INLIMBO",  }
local MUST_ONE_OF_TAGS = { "_health", "_combat", "character", "NET_workable", "king", "mermking" } -- Should cover about 99.3141% of all mobs
AddPlayerPostInit(function(inst)
	local function CheckNearbyMobs(inst)
		local radius = GLOBAL.TUNING.DISCOVER_MOB_RANGE
		local mob = GLOBAL.FindEntity(
			inst,
			radius,
			nil,
			nil,
			CANT_TAGS,
			MUST_ONE_OF_TAGS
		)
	
		if mob and IsInMonstersTable(mob) then
			inst.components.bestiaryupdater:DiscoverMob(mob.discoverable_prefab or mob.prefab)

			if mob.prefab == "hermitcrab" or mob.prefab == "gestalt" or mob.prefab == "gestalt_guard" then -- There cannot be killed or interacted with really...
				inst.components.bestiaryupdater:LearnMob(mob.discoverable_prefab or mob.prefab)
			end
		end
	end
	
	local function CheckCatchedMob(inst, data)
		if data.target and data.action == GLOBAL.ACTIONS.NET then
			inst.components.bestiaryupdater:DiscoverMob(data.target.discoverable_prefab or data.target.prefab) -- If catched without discovering first
			inst.components.bestiaryupdater:LearnMob(data.target.discoverable_prefab or data.target.prefab)
		end
	end

	local function CheckKilledMob(inst, data)
		if data.victim then
			if not data.victim:HasTag("structure") and not data.victim.components.childspawner then
				inst.components.bestiaryupdater:DiscoverMob(data.victim.discoverable_prefab or data.victim.prefab) -- If killed without discovering first
				inst.components.bestiaryupdater:LearnMob(data.victim.discoverable_prefab or data.victim.prefab)
			end
		end
	end

	inst:AddComponent("bestiaryupdater") -- Client-sided

	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst:DoPeriodicTask(2, CheckNearbyMobs)
	inst:ListenForEvent("killed", CheckKilledMob)
	inst:ListenForEvent("finishedwork", CheckCatchedMob)
end)

AddPrefabPostInit("pigking", function(inst)
	inst:ListenForEvent("trade", function(inst, data)
		if data.giver then
			data.giver.components.bestiaryupdater:DiscoverMob("pigking") -- If traded with without discovering first, highly unlikely
			data.giver.components.bestiaryupdater:LearnMob("pigking")
		end
	end)
end)

AddPrefabPostInit("mermking", function(inst)
	inst:ListenForEvent("trade", function(inst, data)
		if data.giver then
			data.giver.components.bestiaryupdater:DiscoverMob("mermking") -- If traded with without discovering first, highly unlikely
			data.giver.components.bestiaryupdater:LearnMob("mermking")
		end
	end)
end)

AddPrefabPostInit("killerbee", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "bee"
end)

AddPrefabPostInit("beeguard", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "bee"
end)

AddPrefabPostInit("canary_poisoned", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "canary"
end)

AddPrefabPostInit("crawlingnightmare", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "crawlinghorror"
end)

AddPrefabPostInit("nightmarebeak", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "terrorbeak"
end)

AddPrefabPostInit("bishop_nightmare", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "bishop"
end)

AddPrefabPostInit("knight_nightmare", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "knight"
end)

AddPrefabPostInit("rook_nightmare", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "rook"
end)

AddPrefabPostInit("firehound", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "hound"
end)

AddPrefabPostInit("icehound", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "hound"
end)

AddPrefabPostInit("koalefant_winter", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "koalefant_summer"
end)

AddPrefabPostInit("snurtle", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "slurtle"
end)

AddPrefabPostInit("toadstool_dark", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "toadstool"
end)

AddPrefabPostInit("wobybig", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "wobysmall"
end)

AddPrefabPostInit("alterguardian_phase2", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "alterguardian_phase1"
end)

AddPrefabPostInit("alterguardian_phase3", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "alterguardian_phase1"
end)

AddPrefabPostInit("stalker_minion2", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "stalker_minion1"
end)

AddPrefabPostInit("leif_sparse", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "leif"
end)

AddPrefabPostInit("wobster_sheller", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "wobster_sheller_land"
end)

AddPrefabPostInit("wobster_moonglass", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst.discoverable_prefab = "wobster_moonglass_land"
end)

local BestiaryEntry = require("widgets/bestiaryentry")
AddClassPostConstruct("widgets/controls", function(self)
	self.bestiary_notification = self.topleft_root:AddChild(BestiaryEntry(self.owner))
    self.bestiary_notification:SetPosition(215, 0, 0)
end)