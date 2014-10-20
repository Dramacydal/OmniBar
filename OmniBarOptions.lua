local addonName, L = ...
local O = addonName .. "OptionsPanel"

local OmniBar = OmniBar

local OptionsPanel = CreateFrame("Frame", O)
OptionsPanel.name = addonName

local title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetText(addonName)

local subText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
local notes = GetAddOnMetadata(addonName, "Notes-" .. GetLocale())
if not notes then
	notes = GetAddOnMetadata(addonName, "Notes")
end
subText:SetText(notes)

title:SetPoint("TOPLEFT", 16, -16)
subText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

local Test = CreateFrame("Button", O.."Test", OptionsPanel, "OptionsButtonTemplate")
Test:SetText(L["Test"])
Test:SetPoint("TOPRIGHT", -16, -16)
Test:SetSize(100, 30)
Test:SetScript("OnClick", function()
	OmniBar:Test()
end)

local Lock = CreateFrame("CheckButton", O.."Lock", OptionsPanel, "OptionsCheckButtonTemplate")
local Center = CreateFrame("CheckButton", O.."Center", OptionsPanel, "OptionsCheckButtonTemplate")

_G[O.."LockText"]:SetText(L["Lock"])
Lock:SetScript("OnClick", function(self)
	OmniBar.settings.locked = self:GetChecked()
	OmniBar:Position()
end)
Lock:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -16)

_G[O.."CenterText"]:SetText(L["Center Lock"])
Center:SetScript("OnClick", function(self)
	OmniBar.settings.center = self:GetChecked()
	if OmniBar.settings.center then
		OmniBar:Center()
		OmniBar:LoadPosition()
		OmniBar:SavePosition()
	end
end)
Center:SetPoint("TOPLEFT", Lock, "BOTTOMLEFT", 0, -2)

local Specific = CreateFrame("CheckButton", O.."Specific", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."SpecificText"]:SetText(L["Use Global Settings"])
Specific:SetScript("OnClick", function(self)
	OmniBar:LoadSettings(self:GetChecked() and 0 or 1)
	OptionsPanel:refresh()
end)
Specific:SetPoint("TOPLEFT", Center, "BOTTOMLEFT", 0, -2)

local Visible = CreateFrame("CheckButton", O.."Visible", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."VisibleText"]:SetText(L["Show Unused Icons"])
Visible:SetScript("OnClick", function(self)
	OmniBar.settings.showUnused = self:GetChecked()
	OmniBar:RefreshIcons()
	OmniBar:UpdateIcons()
end)
Visible:SetPoint("TOPLEFT", Specific, "BOTTOMLEFT", 0, -2)

local Grow = CreateFrame("CheckButton", O.."Grow", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."GrowText"]:SetText(L["Grow Rows Upward"])
Grow:SetScript("OnClick", function(self)
	OmniBar.settings.growUpward = self:GetChecked()
	OmniBar:Position()
end)
Grow:SetPoint("TOPLEFT", Visible, "BOTTOMLEFT", 0, -2)

local ShowCooldownCount = CreateFrame("CheckButton", O.."ShowCooldownCount", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."ShowCooldownCountText"]:SetText(L["Countdown Count"])
ShowCooldownCount:SetScript("OnClick", function(self)
	OmniBar.settings.noCooldownCount = not self:GetChecked()
	OmniBar:RefreshIcons()
	OmniBar:UpdateIcons()	
end)
ShowCooldownCount:SetPoint("TOPLEFT", Grow, "BOTTOMLEFT", 0, -2)

local Border = CreateFrame("CheckButton", O.."Border", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."BorderText"]:SetText(L["Show Border"])
Border:SetScript("OnClick", function(self)
	OmniBar.settings.border = self:GetChecked()
	OmniBar:UpdateIcons()
end)
Border:SetPoint("TOPLEFT", ShowCooldownCount, "BOTTOMLEFT", 0, -2)

local function CreateSlider(text, parent, low, high, step)
	local name = parent:GetName() .. text
	local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
	slider:SetWidth(300)
	slider:SetMinMaxValues(low, high)
	slider:SetValueStep(step)
	slider:SetObeyStepOnDrag(true)
	_G[name .. "Low"]:SetText()
	local high = _G[name .. "High"]
	high:ClearAllPoints()
	high:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT", 0, 5)
	return slider
end

local Size = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
Size:SetText(L["Size"])
local SizeDescription = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
SizeDescription:SetText(L["Set the size of the icons"])

SizeSlider = CreateSlider("Size", OptionsPanel, 10, 200, 5)
SizeSlider:SetScript("OnValueChanged", function(self, value)
	_G[self:GetName() .. "High"]:SetText(value)
	OmniBar.settings.size = value
	OmniBar:UpdateIcons()
	OmniBar:Position()
end)
Size:SetPoint("TOPLEFT", Border, "BOTTOMLEFT", 0, -16)
SizeDescription:SetPoint("TOPLEFT", Size, "BOTTOMLEFT", 0, -8)
SizeSlider:SetPoint("TOPLEFT", SizeDescription, "BOTTOMLEFT", 0, -8)

local Columns = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
Columns:SetText(L["Columns"])
local ColumnsDescription = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
ColumnsDescription:SetText(L["Set the maximum icons per row"])
ColumnsSlider = CreateSlider("Columns", OptionsPanel, 1, OmniBar.MAX_ICONS, 1)
ColumnsSlider:SetScript("OnValueChanged", function(self, value)
	_G[self:GetName() .. "High"]:SetText(value >= OmniBar.MAX_ICONS and L["Unlimited"] or value)
	OmniBar.settings.columns = value < OmniBar.MAX_ICONS and value or 0
	OmniBar:Position()
end)
Columns:SetPoint("TOPLEFT", SizeSlider, "BOTTOMLEFT", 0, -16)
ColumnsDescription:SetPoint("TOPLEFT", Columns, "BOTTOMLEFT", 0, -8)
ColumnsSlider:SetPoint("TOPLEFT", ColumnsDescription, "BOTTOMLEFT", 0, -8)

local Dim = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
Dim:SetText(L["Unused Icon Alpha"])
local DimDescription = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
DimDescription:SetText(L["Set the transparency of unused icons"])
DimSlider = CreateSlider("Dim", OptionsPanel, 0, 100, 1)
DimSlider:SetScript("OnValueChanged", function(self, value)
	_G[self:GetName() .. "High"]:SetText(value.."%")
	OmniBar.settings.unusedAlpha = value/100
	OmniBar:UpdateIcons()
end)
Dim:SetPoint("TOPLEFT", ColumnsSlider, "BOTTOMLEFT", 0, -16)
DimDescription:SetPoint("TOPLEFT", Dim, "BOTTOMLEFT", 0, -8)
DimSlider:SetPoint("TOPLEFT", DimDescription, "BOTTOMLEFT", 0, -8)

local Swipe = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
Swipe:SetText(L["Swipe Alpha"])
local SwipeDescription = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
SwipeDescription:SetText(L["Set the transparency of the swipe animation"])
SwipeSlider = CreateSlider("Swipe", OptionsPanel, 0, 100, 1)
SwipeSlider:SetScript("OnValueChanged", function(self, value)
	_G[self:GetName() .. "High"]:SetText(value.."%")
	OmniBar.settings.swipeAlpha = value/100
	OmniBar:UpdateIcons()
end)
Swipe:SetPoint("TOPLEFT", DimSlider, "BOTTOMLEFT", 0, -16)
SwipeDescription:SetPoint("TOPLEFT", Swipe, "BOTTOMLEFT", 0, -8)
SwipeSlider:SetPoint("TOPLEFT", SwipeDescription, "BOTTOMLEFT", 0, -8)

OptionsPanel.refresh = function()
	Lock:SetChecked(OmniBar.settings.locked)
	Visible:SetChecked(OmniBar.settings.showUnused)
	Specific:SetChecked(OmniBar.profile == "Default")
	Grow:SetChecked(OmniBar.settings.growUpward)
	ShowCooldownCount:SetChecked(not OmniBar.settings.noCooldownCount)
	Center:SetChecked(OmniBar.settings.center)
	Border:SetChecked(OmniBar.settings.border)
	SizeSlider:SetValue(OmniBar.settings.size)
	ColumnsSlider:SetValue(OmniBar.settings.columns and OmniBar.settings.columns > 0 and OmniBar.settings.columns or OmniBar.MAX_ICONS)
	DimSlider:SetValue(OmniBar.settings.unusedAlpha and OmniBar.settings.unusedAlpha*100 or 1)
	SwipeSlider:SetValue(OmniBar.settings.swipeAlpha and OmniBar.settings.swipeAlpha*100 or 65)
end

InterfaceOptions_AddCategory(OptionsPanel)
