----						  [ Coder ]						  ----
---- 							 -т-						  ----
----  https://forums.kleientertainment.com/profile/365042-t/  ----
----  					  Discord: -т-#1234				  	  ----

local require = GLOBAL.require

GLOBAL.CHEATS_ENABLED = true
require("debugkeys")

GLOBAL.DISCOVERABLE_MOBS_CONFIG = GetModConfigData("Discoverable Mobs")
GLOBAL.BESTIARY_ITEM_CONFIG = GetModConfigData("Bestiary as an Item")

--\/ INIT \/--

modimport("init/init_assets")
modimport("init/init_prefabs")
modimport("init/init_desc")
modimport("init/init_strings")
modimport("init/init_tuning")
modimport("init/init_recipes")

--/\ INIT /\--

--\/ EXTERNAL CODE \/--

GLOBAL.MONSTERDATA_BESTIARY = {  }
require("monsterinfo")

modimport("scripts/addbestiaryaction")
modimport("scripts/addstates")
modimport("scripts/bestiarypopup")
modimport("scripts/bestiaryhud")
modimport("scripts/bossdiscovery")
modimport("scripts/discoverable_prefabs")

--/\ EXTERNAL CODE /\--

GLOBAL.global("TheBestiary")
GLOBAL.TheBestiary = nil
GLOBAL.TheBestiary = require("bestiarydata")()
GLOBAL.TheBestiary:Load()

AddPlayerPostInit(function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("bestiaryreader")
end)

if not GLOBAL.BESTIARY_ITEM_CONFIG then -- Skip all the 'discovering' part if it's disabled
	local BestiaryHUDWidget = require("widgets/bestiaryhudwidget")
	AddClassPostConstruct("widgets/controls", function(self)
		local bestiary_HUD = self.bottom_root:AddChild(BestiaryHUDWidget(self.owner))
		bestiary_HUD:SetPosition(-550, -15, 0)
		bestiary_HUD:SetScale(0.6, 0.6)
	end)
end

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

AddModRPCHandler("bestiarymod", "OpenBestiary", function(player)
	player.components.bestiaryreader:OpenBestiary() -- Server sided
end)

local function IsInMonstersTable(mob)
	for i, data in ipairs(GLOBAL.MONSTERDATA_BESTIARY) do
		if (data.prefab or data.forms[1].prefab) == (mob.discoverable_prefab or mob.prefab) then
			return true
		end
	end

	return false
end

local CANT_TAGS = { "structure", "FX", "DECOR", "NOCLICK", "INLIMBO",  }
local MUST_ONE_OF_TAGS = { "_health", "_combat", "character", "NET_workable", "king", "mermking" } -- Should cover about 99.3141% of all mobs
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
		inst.components.bestiaryupdater:DiscoverMob(data.victim.discoverable_prefab or data.victim.prefab) -- If killed without discovering first
		inst.components.bestiaryupdater:LearnMob(data.victim.discoverable_prefab or data.victim.prefab)
	end
end

local function onbecamehuman(inst)
	if inst.CheckNearbyMobsTask then
		inst.CheckNearbyMobsTask:Cancel()
		inst.CheckNearbyMobsTask = nil
	end

	inst.CheckNearbyMobsTask = inst:DoPeriodicTask(2, CheckNearbyMobs)
	inst:ListenForEvent("killed", CheckKilledMob)
	inst:ListenForEvent("finishedwork", CheckCatchedMob)
end

local function onbecameghost(inst)
	if inst.CheckNearbyMobsTask then
		inst.CheckNearbyMobsTask:Cancel()
		inst.CheckNearbyMobsTask = nil
	end

	inst:RemoveEventCallback("killed", CheckKilledMob)
	inst:RemoveEventCallback("finishedwork", CheckCatchedMob)
end

AddPlayerPostInit(function(inst)
	inst:AddComponent("bestiaryupdater") -- Client-sided

	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	local old_OnLoad = inst.OnLoad
	inst.OnLoad = function(inst, data, newents)
		inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
		inst:ListenForEvent("ms_becameghost", onbecameghost)

		if inst:HasTag("playerghost") then
			onbecameghost(inst)
		else
			onbecamehuman(inst)
		end

		old_OnLoad(inst, data, newents)
	end

	local old_OnNewSpawn = inst.OnNewSpawn
	inst.OnNewSpawn = function(inst, starting_item_skins)
		inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
		inst:ListenForEvent("ms_becameghost", onbecameghost)

		if inst:HasTag("playerghost") then
			onbecameghost(inst)
		else
			onbecamehuman(inst)
		end

		old_OnNewSpawn(inst, starting_item_skins)
	end
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

local BestiaryEntry = require("widgets/bestiaryentry")
AddClassPostConstruct("widgets/controls", function(self)
	self.bestiary_notification = self.topleft_root:AddChild(BestiaryEntry(self.owner))
    self.bestiary_notification:SetPosition(215, 0, 0)
end)