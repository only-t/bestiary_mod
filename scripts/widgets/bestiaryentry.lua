local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local time = 5

local BestiaryEntry = Class(Widget, function(self, owner)
    Widget._ctor(self, "BestiaryEntry")

    self.owner = owner

    self.notification = self:AddChild(UIAnim())
    self.notification:GetAnimState():SetBank("bestiary_entry")
    self.notification:GetAnimState():SetBuild("bestiary_entry")
    self.notification:GetAnimState():PlayAnimation("exit")
    self.notification:Hide()

    self.owner:ListenForEvent("mob_discovered", function() self:Enter() end)
end)

function BestiaryEntry:Enter()
    if self.notification:GetAnimState():AnimDone() then
        self.notification:Show()
        self.notification:GetAnimState():PlayAnimation("enter")
        self.notification:GetAnimState():PushAnimation("idle", true)

        self.inst:DoTaskInTime(time, function() self:Exit() end)
    end
end

function BestiaryEntry:Exit()
    if self.notification:GetAnimState():IsCurrentAnimation("idle") then
        self.notification:GetAnimState():PlayAnimation("exit")
    end
end

return BestiaryEntry