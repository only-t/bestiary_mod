local BestiaryData = Class(function(self)
	self.discovered_mobs = {  }
	self.learned_mobs = {  }

	-- self.new_mobs = {  }
end)

function BestiaryData:Save(force_save)
	if force_save then
		-- local str = json.encode({ discovered_mobs = self.discovered_mobs, learned_mobs = self.learned_mobs, new_mobs = self.new_mobs })
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
				-- self.new_mobs = bestiary.new_mobs or {  }
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
        -- table.insert(self.new_mobs, prefab)

        if ThePlayer then -- Push only it's the client
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

function BestiaryData:RemoveFromTable(table, value)
    for i, table_value in ipairs(self[table]) do
		if table_value == value then
			self[table][i] = nil
		end
	end

    self:Save(true)
end

function BestiaryData:Forgor()
    self.discovered_mobs = {  }
	self.learned_mobs = {  }
    -- self.new_mobs = {  }

    self:Save(true)
end

return BestiaryData
