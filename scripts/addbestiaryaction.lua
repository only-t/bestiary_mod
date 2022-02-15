local function open_bestiaryfn(act)
	local targ = act.target or act.invobject

	if targ and act.doer then
		if targ.components.bestiary and act.doer.components.bestiaryreader then
			return act.doer.components.bestiaryreader:OpenBestiary(targ)
		end
	end
end

AddAction("OPEN_BESTIARY", "Open", open_bestiaryfn)
AddComponentAction("INVENTORY", "bestiary", function(inst, doer, actions)
	if doer:HasTag("bestiaryreader") then
		table.insert(actions, GLOBAL.ACTIONS.OPEN_BESTIARY)
	end
end)