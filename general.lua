--[[
	General options panel
--]]

local ADDON, Addon = ...
local General = Addon:NewPanel('General')

local L = LibStub('AceLocale-3.0'):GetLocale('Combuctor')
local frame

local Managed = General:NewCheckButton(L.ActPanel, L.ActPanelTip)
Managed:SetPoint('TOPLEFT', 15, -120)
Managed:SetScript('OnClick', function()
  if frame.sets.position then
    frame:SavePosition(nil)
  else
    frame:SavePosition(frame:GetPoint())
  end
end)

local Reversed = General:NewCheckButton(L.LeftFilters, L.LeftFiltersTip)
Reversed:SetPoint('TOPLEFT', Managed, 'BOTTOMLEFT', 0, -5)
Reversed:SetScript('OnClick', function()
  frame:SetLeftSideFilter(not frame:IsSideFilterOnLeft())
end)

local TipCounts = General:NewCheckButton(L.TipCounts, L.TipCountsTip)
TipCounts:SetPoint('TOPLEFT', Reversed, 'BOTTOMLEFT', 0, -5)
TipCounts:SetChecked(Combuctor:IsTipCountEnabled())
TipCounts:SetScript('OnClick', function()
  Combuctor:ToggleTipCounts()
end)

function General:OnFrameChanged()
  frame = Combuctor:GetFrame(Addon.frame)

  Managed:SetChecked(not frame.sets.position)
  Reversed:SetChecked(frame:IsSideFilterOnLeft())
end