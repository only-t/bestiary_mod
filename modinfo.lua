name = "󰀈 Bestiary 󰀈"
description = [[The Bestiary adds a new book to Don't Starve Together with all the information of the different creatues of The Constant!

If you want to have all the information from the start disable Discoverable Mobs in the configurations!

Current version: 0.9.0 󰀔
]]
author = "-т-"
version = "0.9.1"
forumthread = "https://forums.kleientertainment.com/forums/topic/137812-the-bestiary-mod-beta-release/"
icon_atlas = "icon.xml"
icon = "icon.tex"
client_only_mod = false
all_clients_require_mod = true
dst_compatible = true
dont_starve_compatible = false
priority = 0
api_version = 10

configuration_options = {
    {
        name = "Discoverable Mobs",
        options = {
            { description = "Yes", data = 1 },
            { description = "No", data = 0 }
        },

        default = 1,
    }
}