local Image = require "widgets/image"
local Widget = require "widgets/widget"
local BestiaryPage = require "widgets/bestiarypage"

require("util")

local BestiaryWidget = Class(Widget, function(self, owner)
    Widget._ctor(self, "BestiaryWidget")

    self.root = self:AddChild(Widget("root"))

    local book_background = self.root:AddChild(Image("images/bestiary_book_cover.xml", "bestiary_book_cover.tex"))
    book_background:SetSize(1000, 700)

    local page = book_background:AddChild(BestiaryPage(owner))
end)

return BestiaryWidget