GLOBAL.DISCOVERABLE_MOBS_CONFIG = GetModConfigData("Discoverable Mobs")
GLOBAL.BESTIARY_ITEM_CONFIG = GetModConfigData("Bestiary as an Item")

GLOBAL.TUNING.MONSTER_SMALL_SCALING = 0.5

GLOBAL.global("TheBestiary")
GLOBAL.TheBestiary = nil
GLOBAL.TheBestiary = require("bestiarydata")()
GLOBAL.TheBestiary:Load()

modimport("init/init_assets")
modimport("init/init_prefabs")
modimport("init/init_desc")
modimport("init/init_strings")
modimport("init/init_tuning")
modimport("init/init_recipes")

GLOBAL.MONSTERDATA_BESTIARY = {  }
require("monsterinfo")

local function InjectBestiaryMenuButton(screen)
    local offset = 38

    for i, item in ipairs(screen.subscreener.menu.items) do
        local old_pos = item:GetPosition()

        if i <= 3 then
            item:SetPosition(old_pos.x, old_pos.y - offset/2)
        elseif i < 8 then
            item:SetPosition(old_pos.x, old_pos.y + offset/2)
        else
            item:SetPosition(old_pos.x, old_pos.y - offset*4.5)
        end
    end

    local old_pos = screen.tooltip:GetPosition()
    screen.tooltip:SetPosition(old_pos.x, old_pos.y - offset/2)
end

local BestiaryPage = require "widgets/bestiarypage"
AddClassPostConstruct("screens/redux/compendiumscreen", function(self)
    self.subscreener.sub_screens["bestiary"] = self.panel_root:AddChild(BestiaryPage(self))

    local bestiary_menubutton = self.subscreener:MenuButton("Bestiary", "bestiary", "The Constant's creatures encyclopedia", self.tooltip)
    self.subscreener.menu:AddCustomItem(bestiary_menubutton)

    self.subscreener:OnMenuButtonSelected("historyoftravels")

    InjectBestiaryMenuButton(self)
end)