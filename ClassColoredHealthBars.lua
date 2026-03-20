-- Recolor UnitFrame health bars
local WATCHED_UNITS = {
    target       = true,
    focus        = true,
    targettarget = true,
    focustarget  = true,
}

local CLASS_COLORS = RAID_CLASS_COLORS

local function ResetBarTexture(statusbar)
    local tex = statusbar:GetStatusBarTexture()
    if tex then
        tex:SetDesaturation(0)
        tex:SetVertexColor(1, 1, 1)
    end
end

local function ApplyClassColorToBar(statusbar, unit)
    if not WATCHED_UNITS[unit] then return end

    local tex = statusbar:GetStatusBarTexture()
    if not tex then return end

    if not UnitExists(unit) or not UnitIsPlayer(unit) then
        ResetBarTexture(statusbar)
        return
    end


    local _, class = UnitClass(unit)
    if not class or not CLASS_COLORS[class] then
        ResetBarTexture(statusbar)
        return
    end

    local c = CLASS_COLORS[class]
    tex:SetDesaturation(1)
    tex:SetVertexColor(c.r, c.g, c.b)
end

hooksecurefunc("UnitFrameHealthBar_Update", ApplyClassColorToBar)

hooksecurefunc("UnitFrameHealthBar_OnUpdate", function(statusbar)
    if statusbar and statusbar.unit then
        ApplyClassColorToBar(statusbar, statusbar.unit)
    end
end)

-- Unload portrait text
hooksecurefunc("CombatFeedback_OnCombatEvent", function(frame)
    if frame == PlayerFrame or frame == PetFrame then
        if frame.combatFeedbackText then
            frame.combatFeedbackText:SetText("")
            frame.combatFeedbackText:Hide()
        end
    end
end)

hooksecurefunc("CombatFeedback_OnUpdate", function(frame)
    if frame == PlayerFrame or frame == PetFrame then
        if frame.combatFeedbackText then
            frame.combatFeedbackText:SetText("")
            frame.combatFeedbackText:Hide()
        end
    end
end)

local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_LOGIN")
init:SetScript("OnEvent", function()
    local hitText = PlayerFrame.PlayerFrameContent
                    and PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
                    and PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator
                    and PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText

    if hitText then
        hitText:Hide()
        hitText.Show = function() end
    end
end)
