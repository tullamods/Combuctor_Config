--[[
	General options panel
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local General = Combuctor.OptionsPanel:New('Combuctor', L.GeneralDesc)

local Managed = General:NewCheckButton(L.ActPanel, L.ActPanelTip)
Managed:SetPoint('TOPLEFT', 15, -120)
Managed:SetScript('OnClick', function()
    local profile = Combuctor.profile[Addon.frameID]
    if profile.point then
        profile.point = false
    else
        profile.point = frame:GetPoint()
    end

    Combuctor:UpdateFrames()
end)

local Reversed = General:NewCheckButton(L.LeftTabs, L.LeftTabsTip)
Reversed:SetPoint('TOPLEFT', Managed, 'BOTTOMLEFT', 0, -5)
Reversed:SetScript('OnClick', function()
    local profile = Combuctor.profile[Addon.frameID]
    profile.reversedTabs = not profile.reversedTabs
    Combuctor:UpdateFrames()
end)

local anchor = Reversed
for _, key in ipairs {'glowQuality', 'glowNew', 'glowQuest', 'glowSets', 'glowUnusable', 'tipCount'} do
    local button = General:NewCheckButton(L[key:gsub('^.', strupper)])
    button:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -5)
    button:SetChecked(Combuctor.sets[key])
    button:SetScript('OnClick', function()
        Combuctor.sets[key] = not Combuctor.sets[key]
        Combuctor:UpdateFrames()
    end)

    anchor = button
end

function General:OnFrameChanged()
    local profile = Combuctor.profile[Addon.frameID]
    Managed:SetChecked(not profile.point)
    Reversed:SetChecked(profile.reversedTabs)
end