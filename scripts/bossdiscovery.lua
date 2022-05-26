if not GLOBAL.DISCOVERABLE_MOBS_CONFIG then -- Skip all the 'discovering' part if it's disabled
	return
end

local bosses = {
    "minotaur",
    "antlion",
    "bearger",
    "stalker",
    "deerclops",
    "eyeofterror",
    "klaus",
    "lordfruitfly",
    "malbatross",
    "moose",
    "twinofterror1",
    "shadow_bishop",
    "shadow_knight",
    "shadow_rook",
    "twinofterror2",
    "spiderqueen",
    "leif",
    "warg",
    "stalker_atrium",
    "beequeen",
    "alterguardian_phase1",
    "alterguardian_phase2",
    "alterguardian_phase3",
    "crabking",
    "dragonfly",
    "toadstool",
    "toadstool_dark",
}

for i, prefab in ipairs(bosses) do
    AddPrefabPostInit(prefab, function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return inst
        end

        inst:ListenForEvent("death", function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 16, { "player" }, { "playerghost" })

            for i, ent in ipairs(ents) do
                if ent and ent.components.health and not ent.components.health:IsDead() then
                    ent.components.bestiaryupdater:LearnMob(inst.discoverable_prefab or inst.prefab)
                end
            end
        end)
    end)
end