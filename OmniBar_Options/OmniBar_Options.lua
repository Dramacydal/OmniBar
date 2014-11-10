local _, L = ...

local OmniBar = OmniBar

function OmniBarOptionsPanel_OnLoad(self)
	-- Set localized text
	OmniBarOptionsPanelVersionLabel:SetText(L["Version"])
	OmniBarOptionsPanelAuthorLabel:SetText(L["Author"])
	OmniBarOptionsPanelReset:SetText(L["Reset Settings"])
	OmniBarOptionsPanelTest:SetText(L["Test"])
	OmniBarOptionsPanelLockText:SetText(L["Lock"])
	OmniBarOptionsPanelCenterLockText:SetText(L["Center Lock"])
	OmniBarOptionsPanelShowUnusedText:SetText(L["Show Unused Icons"])
	OmniBarOptionsPanelGrowUpwardText:SetText(L["Grow Rows Upward"])
	OmniBarOptionsPanelCountdownCountText:SetText(L["Countdown Count"])
	OmniBarOptionsPanelShowBorderText:SetText(L["Show Border"])
	OmniBarOptionsPanelUseGlobalText:SetText(L["Use Global Settings"])
	OmniBarOptionsPanelShowArenaText:SetText(L["Show in Arenas"])
	OmniBarOptionsPanelShowBattlegroundText:SetText(L["Show in Battlegrounds"])
	OmniBarOptionsPanelShowWorldText:SetText(L["Show in World"])
	OmniBarOptionsPanelGlowText:SetText(L["Glow Icons"])
	OmniBarOptionsPanelSizeTitle:SetText(L["Size"])
	OmniBarOptionsPanelSizeDescription:SetText(L["Set the size of the icons"])
	OmniBarOptionsPanelUnusedAlphaTitle:SetText(L["Unused Icon Transparency"])
	OmniBarOptionsPanelUnusedAlphaDescription:SetText(L["Set the transparency of unused icons"])
	OmniBarOptionsPanelSwipeAlphaTitle:SetText(L["Swipe Transparency"])
	OmniBarOptionsPanelSwipeAlphaDescription:SetText(L["Set the transparency of the swipe animation"])
	OmniBarOptionsPanelColumnsTitle:SetText(L["Columns"] )
	OmniBarOptionsPanelColumnsDescription:SetText(L["Set the maximum icons per row"])
	OmniBarOptionsPanelPaddingTitle:SetText(L["Padding"] )
	OmniBarOptionsPanelPaddingDescription:SetText(L["Set the space between icons"])
end

function OmniBarOptionsPanelLock_OnClick(self)
	OmniBar.settings.locked = self:GetChecked()
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelCenterLock_OnClick(self)
	OmniBar.settings.center = self:GetChecked()
	if OmniBar.settings.center then
		OmniBar_Center(OmniBar)
		OmniBar_LoadPosition(OmniBar)
		OmniBar_SavePosition(OmniBar)
	end
end

function OmniBarOptionsPanelShowUnused_OnClick(self)
	OmniBar.settings.showUnused = self:GetChecked()
	OmniBar_RefreshIcons(OmniBar)
	OmniBar_UpdateIcons(OmniBar)
end

function OmniBarOptionsPanelGrowUpward_OnClick(self)
	OmniBar.settings.growUpward = self:GetChecked()
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelCountdownCount_OnClick(self)
	OmniBar.settings.noCooldownCount = not self:GetChecked()
	OmniBar_RefreshIcons(OmniBar)
	OmniBar_UpdateIcons(OmniBar)
end

function OmniBarOptionsPanelShowBorder_OnClick(self)
	OmniBar.settings.border = self:GetChecked()
	OmniBar_UpdateIcons(OmniBar)
end

function OmniBarOptionsPanelUseGlobal_OnClick(self)
	OmniBar_LoadSettings(OmniBar, self:GetChecked() and 0 or 1)
	OmniBarOptions:refresh()

	-- Refresh the cooldowns
	i = 1
	while _G["OmniBarOptionsPanel" .. i] do
		_G["OmniBarOptionsPanel" .. i]:refresh()
		i = i + 1
	end
end

function OmniBarOptionsPanelShowArena_OnClick(self)
	OmniBar.settings.noArena = not self:GetChecked()
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelShowBattleground_OnClick(self)
	OmniBar.settings.noBattleground = not self:GetChecked()
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelShowWorld_OnClick(self)
	OmniBar.settings.noWorld = not self:GetChecked()
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelGlow_OnClick(self)
	OmniBar.settings.noGlow = not self:GetChecked()
end

local function OmniBarOptionsPanelSizeSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value)
	OmniBar.settings.size = value
	OmniBar.container:SetScale(value/OmniBar.BASE_ICON_SIZE)
end

function OmniBarOptionsPanelSize_OnLoad(self)
	self.slider:SetMinMaxValues(10, 200)
	self.slider:SetScript("OnValueChanged", OmniBarOptionsPanelSizeSlider_OnValueChanged)
end

function OmniBarOptionsPanelColumnsSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value >= 100 and L["Unlimited"] or value)
	OmniBar.settings.columns = value < 100 and value or 0
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelPaddingSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value)
	OmniBar.settings.padding = value
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelUnusedAlphaSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value.."%")
	OmniBar.settings.unusedAlpha = value/100
	OmniBar_UpdateIcons(OmniBar)
end

function OmniBarOptionsPanelSwipeAlphaSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value.."%")
	OmniBar.settings.swipeAlpha = value/100
	OmniBar_UpdateIcons(OmniBar)
end

OmniBarOptions.refresh = function()
	OmniBarOptionsPanelLock:SetChecked(OmniBar.settings.locked)
	OmniBarOptionsPanelShowUnused:SetChecked(OmniBar.settings.showUnused)
	OmniBarOptionsPanelUseGlobal:SetChecked(OmniBar.profile == "Default")
	OmniBarOptionsPanelGrowUpward:SetChecked(OmniBar.settings.growUpward)
	OmniBarOptionsPanelCountdownCount:SetChecked(not OmniBar.settings.noCooldownCount)
	OmniBarOptionsPanelCenterLock:SetChecked(OmniBar.settings.center)
	OmniBarOptionsPanelShowBorder:SetChecked(OmniBar.settings.border)
	OmniBarOptionsPanelShowArena:SetChecked(not OmniBar.settings.noArena)
	OmniBarOptionsPanelShowBattleground:SetChecked(not OmniBar.settings.noBattleground)
	OmniBarOptionsPanelShowWorld:SetChecked(not OmniBar.settings.noWorld)
	OmniBarOptionsPanelGlow:SetChecked(not OmniBar.settings.noGlow)
	OmniBarOptionsPanelSizeSlider:SetValue(OmniBar.settings.size)
	OmniBarOptionsPanelPaddingSlider:SetValue(OmniBar.settings.padding or 0)
	OmniBarOptionsPanelColumnsSlider:SetValue(OmniBar.settings.columns and OmniBar.settings.columns > 0 and OmniBar.settings.columns or 100)
	OmniBarOptionsPanelUnusedAlphaSlider:SetValue(OmniBar.settings.unusedAlpha and OmniBar.settings.unusedAlpha*100 or 1)
	OmniBarOptionsPanelSwipeAlphaSlider:SetValue(OmniBar.settings.swipeAlpha and OmniBar.settings.swipeAlpha*100 or 65)
end

local subIndex = 1
local function CreateSub(name)
	local OptionsPanelFrame = CreateFrame("Frame", "OmniBarOptionsPanel"..subIndex)
	OptionsPanelFrame.spells = {}
	OptionsPanelFrame.parent = "OmniBar"
	OptionsPanelFrame.name = LOCALIZED_CLASS_NAMES_MALE[name] or L[name]

	local index, parent = 1
	for spellID, cooldown in pairs(OmniBar.cooldowns) do
		if cooldown.class == name then
			local spell = CreateFrame("CheckButton", "OmniBarOptionsPanel"..subIndex.."Item"..index, OptionsPanelFrame, "OptionsCheckButtonTemplate")
			_G["OmniBarOptionsPanel"..subIndex.."Item"..index.."Text"]:SetText(GetSpellInfo(spellID))
			spell:SetScript("OnClick", function(self)
				if not OmniBar.settings.cooldowns[spellID] then OmniBar.settings.cooldowns[spellID] = {} end
				local enabled = self:GetChecked()
				OmniBar.settings.cooldowns[spellID].enabled = enabled
				if enabled then OmniBar_CreateIcon(OmniBar) end
				OmniBar_RefreshIcons(OmniBar)
				OmniBar_UpdateIcons(OmniBar)
				local i = 1
				while _G["OmniBarOptionsPanel"..i] do
					_G["OmniBarOptionsPanel"..i]:refresh()
					i = i + 1
				end
			end)
			if index > 1 then
				-- Split into columns if we're showing all cooldowns
				if (index-1) % 3 == 0 then
					spell:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -2)
					parent = spell
				else
					spell:SetPoint("TOPLEFT", left, "TOPLEFT", 190, 0)
				end
			else
				spell:SetPoint("TOPLEFT", 24, -24)
				parent = spell
			end
			left = spell
			index = index + 1
			spell.spellID = spellID
			table.insert(OptionsPanelFrame.spells, spell)
		end
	end
	
	OptionsPanelFrame.default = OmniBarOptions.default
	OptionsPanelFrame.refresh = function(self)
		for i = 1, #self.spells do
			self.spells[i]:SetChecked(OmniBar_IsSpellEnabled(OmniBar, self.spells[i].spellID))
		end
	end

	InterfaceOptions_AddCategory(OptionsPanelFrame)
	subIndex = subIndex + 1
	InterfaceAddOnsList_Update()
end

for i in pairs(CLASS_SORT_ORDER) do
	CreateSub(CLASS_SORT_ORDER[i])
end
