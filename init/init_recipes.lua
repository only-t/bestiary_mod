local RECIPETABS = GLOBAL.RECIPETABS
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH

AddRecipe("bestiary", { Ingredient("papyrus", 1), Ingredient("monstermeat", 1) }, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/bestiary.xml", "bestiary.tex").sortkey = 80.5 -- Between the reviver and healing salve