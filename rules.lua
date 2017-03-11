--[[
	Rulesets options panel
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Panel = Combuctor.OptionsPanel:New(L.RuleSettings, L.RuleSettingsDesc, 'Combuctor')

local MAX_ENTRIES = 14
local HEIGHT = 26
local expanded = {}

local getProfile = function()
  return Combuctor.profile[Addon.frameID]
end


--[[ List Button ]]--

local function ListButtonCheck_OnClick(self)
	local id = self:GetParent().rule.id
	local profile = getProfile()

	for i, rule in ipairs(profile.rules) do
		if rule == id then
			tremove(profile.rules, i)
		end
	end

	if profile.hiddenRules[id] then
		tinsert(profile.rules, id)
	end

	profile.hiddenRules[id] = not profile.hiddenRules[id]
	Combuctor:UpdateFrames()
end

local function ListButtonToggle_OnClick(self)
	local id = self:GetParent().rule.id
	expanded[id] = not expanded[id]

	self:GetParent():GetParent():UpdateList()
end

local function ListButton_Setup(self, rule)
	if rule.icon then
		_G[self.check:GetName() .. 'Text']:SetFormattedText('|T%s:%d|t %s', rule.icon, 26, rule.name)
	else
		_G[self.check:GetName() .. 'Text']:SetText(rule.name)
	end

	if expanded[rule.id] then
		self.toggle:SetNormalTexture('Interface\\Buttons\\UI-MinusButton-UP')
		self.toggle:SetPushedTexture('Interface\\Buttons\\UI-MinusButton-DOWN')
	else
		self.toggle:SetNormalTexture('Interface\\Buttons\\UI-PlusButton-UP')
		self.toggle:SetPushedTexture('Interface\\Buttons\\UI-PlusButton-DOWN')
	end

	self.rule = rule
	self.check:SetChecked(not getProfile().hiddenRules[rule.id])
	self.toggle:SetShown(not rule.id:find('/'))
end

local function ListButton_Create(id, parent)
	local name = format('%sButton%d', parent:GetName(), id)
	local b = CreateFrame('Frame', name, parent)
	b:SetSize(200, 24)
	b.Setup = ListButton_Setup

	local toggle = CreateFrame('Button', nil, b)
	toggle:SetPoint('LEFT', b)
	toggle:SetWidth(14)
	toggle:SetHeight(14)
	toggle:SetNormalTexture('Interface\\Buttons\\UI-PlusButton-UP')
	toggle:SetPushedTexture('Interface\\Buttons\\UI-PlusButton-DOWN')
	toggle:SetHighlightTexture('Interface\\Buttons\\UI-PlusButton-Hilight')
	toggle:SetScript('OnClick', ListButtonToggle_OnClick)
	b.toggle = toggle

	local check = CreateFrame('CheckButton', name .. 'Check', b, 'InterfaceOptionsCheckButtonTemplate')
	check:SetScript('OnClick', ListButtonCheck_OnClick)
	check:SetPoint('LEFT', toggle, 'RIGHT', 4, 0)
	b.check = check

	return b
end


--[[ Panel ]]--

function Panel:UpdateList()
	local offset = FauxScrollFrame_GetOffset(self.scrollFrame)
	local entries = {}
	local i = 1

	for _,parent in Combuctor.Rules:IterateParents() do
		tinsert(entries, parent)

		if expanded[parent.id] then
			for _,child in pairs(parent.children) do
				tinsert(entries, child)
			end
		end
	end

	while i <= MAX_ENTRIES and entries[i + offset] do
		local button = self.buttons[i]
		button:Setup(entries[i + offset])

		local offLeft = button.rule.id:find('/') and 24 or 0
		button:SetPoint('TOPLEFT', 14 + offLeft, -(100 + 30 * i))
		button:Show()

		i = i + 1
	end

	for j = i, #self.buttons do
		self.buttons[j]:Hide()
	end

	FauxScrollFrame_Update(self.scrollFrame, #entries, MAX_ENTRIES, self.buttons[1]:GetHeight())
end

do
 	Panel.OnFrameChanged = Panel.UpdateList
	Panel:SetScript('OnHide', function(self) expanded = {} end)

	local scroll = CreateFrame('ScrollFrame', '$parentScrollFrame', Panel, 'FauxScrollFrameTemplate')
	scroll:SetPoint('TOPLEFT', 6, -120)
	scroll:SetPoint('BOTTOMRIGHT', -32, 8)
	scroll:SetScript('OnVerticalScroll', function(self, arg1)
		FauxScrollFrame_OnVerticalScroll(self, arg1, HEIGHT, function()
			Panel:UpdateList()
		end)
	end)

  	local bg = scroll.ScrollBar:CreateTexture()
  	bg:SetTexture(0, 0, 0, .3)
  	bg:SetAllPoints()

	Panel.scrollFrame = scroll
	Panel.buttons = setmetatable({}, {__index = function(t, k)
		t[k] = ListButton_Create(k, Panel)
		return t[k]
	end})
end