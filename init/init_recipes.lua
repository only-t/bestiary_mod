local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local CRAFTING_FILTERS = GLOBAL.CRAFTING_FILTERS

AddRecipe2("bestiary", { Ingredient("papyrus", 1), Ingredient("monstermeat", 1) }, TECH.SCIENCE_ONE, { atlas = "images/bestiary.xml", image = "bestiary.tex" })