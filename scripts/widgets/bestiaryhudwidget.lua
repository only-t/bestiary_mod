local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"

local BestiaryHUDWidget = Class(Widget, function(self, owner)
    Widget._ctor(self, "BestiaryHUDWidget")

    self.owner = owner

    self.bestiary_bg = self:AddChild(UIAnim())
    self.bestiary_bg:GetAnimState():SetBank("bestiaryhudwidget")
    self.bestiary_bg:GetAnimState():SetBuild("bestiaryhudwidget")
    self.bestiary_bg:GetAnimState():PlayAnimation("idle", true)

    self.bestiary_button = self.bestiary_bg:AddChild(ImageButton("images/global.xml", "square.tex"))
    self.bestiary_button:SetPosition(0, 60, 0)
    self.bestiary_button:SetScale(1.7, 1.7)
    self.bestiary_button.image:SetTint(1, 1, 1, 0)

    self.bestiary_button.ongainfocusfn = function()
        self.bestiary_bg:GetAnimState():PlayAnimation("mouseover")
        self.bestiary_bg:GetAnimState():PushAnimation("mouseover_loop", true)
    end

    self.bestiary_button.onlosefocusfn = function()
        self.bestiary_bg:GetAnimState():PlayAnimation("mouseover_stop")
        self.bestiary_bg:GetAnimState():PushAnimation("idle", true)
    end

    self.bestiary_button:SetOnClick(function()
        SendModRPCToServer(GetModRPC("bestiarymod", "OpenBestiary"), ThePlayer)
    end)
end)

return BestiaryHUDWidget