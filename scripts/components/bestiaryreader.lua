local BestiaryReader = Class(function(self, inst) -- I didn't realise there's a simplebook component and didn't care enough to change it
    self.inst = inst

	self.inst:AddTag("bestiaryreader")
end)

function BestiaryReader:OnRemoveFromEntity()
	self.inst:RemoveTag("bestiaryreader")
end

function BestiaryReader:OpenBestiary(bestiary)
	if bestiary then
		self.inst:ShowPopUp(POPUPS.BESTIARY, true)
		
		return true
	else
		return false
	end
end

return BestiaryReader