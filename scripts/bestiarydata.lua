local BestiaryData = Class(function(self)
	self.discovered_mobs = {  }
	self.learned_mobs = {  }

	self.new_mobs = {  }
end)

function BestiaryData:Save(force_save)
	if force_save then
		local str = json.encode({ discovered_mobs = self.discovered_mobs, learned_mobs = self.learned_mobs })

		TheSim:SetPersistentString("bestiary", str, false) -- Basically a carbon copy of cookbooks saving/loading
	end
end

function BestiaryData:Load()
	self.discovered_mobs = {  }
	self.learned_mobs = {  }

	TheSim:GetPersistentString("bestiary", function(load_success, data)
		if load_success and data then
			local status, bestiary = pcall(function() return json.decode(data) end)

		    if status and bestiary then
				self.discovered_mobs = bestiary.discovered_mobs or {  }
				self.learned_mobs = bestiary.learned_mobs or {  }
            else
                print("Failed to load the bestiary!", status, bestiary)
            end
		end
	end)
end

function BestiaryData:DiscoverMob(prefab)
    local function ValidDiscoverableMob(prefab)
        for i, mob in ipairs(self.discovered_mobs) do
            if mob == prefab then
                return false
            end
        end
    
        return true
    end

	if prefab == nil then
		print("Invalid mob prefab!")

		return
	end

    if ValidDiscoverableMob(prefab) then
        table.insert(self.discovered_mobs, prefab)
        self.new_mobs[prefab] = true

        if ThePlayer then -- Push only if it's the client
		    ThePlayer:PushEvent("mob_discovered")
        end

        self:Save(true)

        return true
    else
        return false
    end
end

function BestiaryData:LearnMob(prefab)
    local function ValidLearnableMob(prefab)
        for i, mob in ipairs(self.learned_mobs) do
            if mob == prefab then
                return false
            end
        end
    
        return true
    end

	if prefab == nil then
		print("Invalid mob prefab!")

		return
	end

    if ValidLearnableMob(prefab) then
        table.insert(self.learned_mobs, prefab)
        
        self:Save(true)

        return true
    else
        return false
    end
end

function BestiaryData:IsNew(value)
    return self.new_mobs[value]
end

function BestiaryData:Forgor()
    self.discovered_mobs = {  }
	self.learned_mobs = {  }
    self.new_mobs = {  }

    self:Save(true)
end

return BestiaryData
