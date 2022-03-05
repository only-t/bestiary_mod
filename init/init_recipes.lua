local RECIPETABS = GLOBAL.RECIPETABS
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
--local CRAFTING_FILTERS = GLOBAL.CRAFTING_FILTERS

--AddRecipe2("bestiary", { Ingredient("papyrus", 1), Ingredient("monstermeat", 1) }, TECH.SCIENCE_ONE, { atlas = "images/bestiary.xml", image = "bestiary.tex" }) -- For the upcoming crafting update
AddRecipe("bestiary", { Ingredient("papyrus", 1), Ingredient("monstermeat", 1) }, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/bestiary.xml", "bestiary.tex").sortkey = 80.5