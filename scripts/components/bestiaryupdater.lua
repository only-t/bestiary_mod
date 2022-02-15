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

function BestiaryUpdater:Forgor()
	self.bestiary:Forgor()
end


return BestiaryUpdater