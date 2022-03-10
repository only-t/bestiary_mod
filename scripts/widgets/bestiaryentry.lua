local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local SHOW_TIME = 5

local BestiaryEntry = Class(Widget, function(self, owner)
    Widget._ctor(self, "BestiaryEntry")

    self.owner = owner

    self.notification = self:AddChild(UIAnim())
    self.notification:GetAnimState():SetBank("bestiary_entry")
    self.notification:GetAnimState():SetBuild("bestiary_entry")
    self.notification:Hide()

    self.exit_task = nil

    self.owner:ListenForEvent("mob_discovered", function() self:Enter(true) end)
    self.owner:ListenForEvent("mob_learned", function() self:Enter(false) end)
end)

function BestiaryEntry:Enter(discovered)
    self.notification:Show()

    if discovered then
        self.notification:GetAnimState():PlayAnimation("enter")
        self.notification:GetAnimState():PushAnimation("idle", true)
    else
        self.notification:GetAnimState():PlayAnimation("enter_learn")
        self.notification:GetAnimState():PushAnimation("idle_learn", true)
    end

    ThePlayer.SoundEmitter:PlaySound("dontstarve/characters/actions/page_turn") -- Client-sided
    
    if self.exit_task then
        self.exit_task:Cancel()
        self.exit_task = nil
    end

    self.exit_task = self.inst:DoTaskInTime(SHOW_TIME, function() self:Exit(discovered) end)
end

function BestiaryEntry:Exit(discovered)
    if self.notification:GetAnimState():IsCurrentAnimation("idle") or self.notification:GetAnimState():IsCurrentAnimation("idle_learn") then
        if discovered then
            self.notification:GetAnimState():PlayAnimation("exit")
        else
            self.notification:GetAnimState():PlayAnimation("exit_learn")
        end
    end
end

return BestiaryEntry