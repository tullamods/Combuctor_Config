--[[
	parent.lua
    The parent options panel
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local FrameSelector = Combuctor.OptionsPanel.NewDropdown(UIParent, L.Frame)

function FrameSelector:Initialize()
  self:AddItem(INVENTORY_TOOLTIP, 'inventory')
  self:AddItem(BANK, 'bank')
end

function FrameSelector:AddItem(text, value)
	UIDropDownMenu_AddButton({
    	text = text,
    	func = self.Click,
    	checked = value == Addon.frameID,
    	value = value,
  	})
end

function FrameSelector:Click()
	Addon.frameID = self.value
	FrameSelector:GetParent():OnFrameChanged()
	UIDropDownMenu_SetSelectedValue(FrameSelector, Addon.frameID)
end

Addon.frameID = 'inventory'
UIDropDownMenu_SetWidth(FrameSelector, 110)
UIDropDownMenu_Initialize(FrameSelector, FrameSelector.Initialize)
UIDropDownMenu_SetSelectedValue(FrameSelector, Addon.frameID)

hooksecurefunc('InterfaceOptionsList_DisplayPanel', function(panel)
	if getmetatable(panel) == Combuctor.OptionsPanel then
		FrameSelector:SetParent(panel)
		FrameSelector:SetPoint('TOPLEFT', 6, -72)
		panel:OnFrameChanged()
	end
end)