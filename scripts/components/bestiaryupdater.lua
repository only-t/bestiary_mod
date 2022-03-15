local function onplayeractivated(inst)
	local self = inst.components.bestiaryupdater

	if not TheNet:IsDedicated() and inst == ThePlayer then
		self.bestiary = TheBestiary
	end
end

local BestiaryUpdater = Class(function(self, inst)
    self.inst = inst

	self.bestiary = require("bestiarydata")()
	self.inst:ListenForEvent("playeractivated", onplayeractivated)
end)

function BestiaryUpdater:DiscoverMob(mob)
	if mob then
		local discovered = self.bestiary:DiscoverMob(mob)

		if discovered and (TheNet:IsDedicated() or (TheWorld.ismastersim and self.inst ~= ThePlayer)) and self.inst.userid then
			SendModRPCToClient(GetClientModRPC("bestiarymod", "DiscoverMob"), self.inst.userid, mob)
		end
	end
end

function BestiaryUpdater:LearnMob(mob)
	if mob then
		local learned = self.bestiary:LearnMob(mob)

		if learned and (TheNet:IsDedicated() or (TheWorld.ismastersim and self.inst ~= ThePlayer)) and self.inst.userid then
			SendModRPCToClient(GetClientModRPC("bestiarymod", "LearnMob"), self.inst.userid, mob)
		end
	end
end

function BestiaryUpdater:DiscoverAll()
	for i, data in ipairs(require("monsterinfo")) do
		if data then
			local discovered = self.bestiary:DiscoverMob(data.prefab or data.forms[1].prefab)

			if discovered and (TheNet:IsDedicated() or (TheWorld.ismastersim and self.inst ~= ThePlayer)) and self.inst.userid then
				SendModRPCToClient(GetClientModRPC("bestiarymod", "DiscoverMob"), self.inst.userid, data.prefab or data.forms[1].prefab)
			end
		end
	end
end

function BestiaryUpdater:LearnAll()
	for i, data in ipairs(require("monsterinfo")) do
		if data then
			local learned = self.bestiary:LearnMob(data.prefab or data.forms[1].prefab)

			if learned and (TheNet:IsDedicated() or (TheWorld.ismastersim and self.inst ~= ThePlayer)) and self.inst.userid then
				SendModRPCToClient(GetClientModRPC("bestiarymod", "LearnMob"), self.inst.userid, data.prefab or data.forms[1].prefab)
			end
		end
	end
end

function BestiaryUpdater:Forgor()
	self.bestiary:Forgor()
end


return BestiaryUpdater