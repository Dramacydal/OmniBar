
-- OmniBar by Jordon

local addonName, L = ...

local cooldowns = {
	[47476]  = { default = true,  duration = 60,  class = "DEATHKNIGHT" }, -- Strangulate
	[47481]  = { default = false, duration = 60,  class = "DEATHKNIGHT" }, -- Gnaw (Ghoul)
	[47482]  = { default = false, duration = 30,  class = "DEATHKNIGHT" }, -- Leap (Ghoul)
	[47528]  = { default = true,  duration = 15,  class = "DEATHKNIGHT" }, -- Mind Freeze
	[48707]  = { default = false, duration = 45,  class = "DEATHKNIGHT" }, -- Anti-Magic Shell
	[48743]  = { default = false, duration = 120, class = "DEATHKNIGHT" }, -- Death Pact
	[48792]  = { default = false, duration = 180, class = "DEATHKNIGHT" }, -- Icebound Fortitude
	[49028]  = { default = false, duration = 90,  class = "DEATHKNIGHT" }, -- Dancing Rune Weapon
	[49039]  = { default = false, duration = 120, class = "DEATHKNIGHT" }, -- Lichborne
	[49576]  = { default = false, duration = 25,  class = "DEATHKNIGHT" }, -- Death Grip
	[51052]  = { default = false, duration = 120, class = "DEATHKNIGHT" }, -- Anti-Magic Zone
	[55233]  = { default = false, duration = 60,  class = "DEATHKNIGHT" }, -- Vampiric Blood
	[91802]  = { default = true,  duration = 30,  class = "DEATHKNIGHT" }, -- Shambling Rush
	[96268]  = { default = false, duration = 30,  class = "DEATHKNIGHT" }, -- Death's Advance
	[108194] = { default = false, duration = 30,  class = "DEATHKNIGHT" }, -- Asphyxiate
	[642]    = { default = false, duration = 300, class = "PALADIN"     }, -- Divine Shield
	[853]    = { default = false, duration = 60,  class = "PALADIN"     }, -- Hammer of Justice
		[105593] = { duration = 30, class = "PALADIN", parent = 853     }, -- Fist of Justice
	[1022]   = { default = false, duration = 300, class = "PALADIN"     }, -- Hand of Protection
	[1044]   = { default = false, duration = 25,  class = "PALADIN"     }, -- Hand of Freedom
	[6940]   = { default = false, duration = 120, class = "PALADIN"     }, -- Hand of Sacrifice
	[20066]  = { default = false, duration = 15,  class = "PALADIN"     }, -- Repentance
	[31821]  = { default = false, duration = 180, class = "PALADIN"     }, -- Devotion Aura
	[31884]  = { default = false, duration = 120, class = "PALADIN"     }, -- Avenging Wrath
	[96231]  = { default = true,  duration = 15,  class = "PALADIN"     }, -- Rebuke
	[114039] = { default = false, duration = 30,  class = "PALADIN"     }, -- Hand of Purity
	[871]    = { default = false, duration = 180, class = "WARRIOR"     }, -- Shield Wall
	[1719]   = { default = false, duration = 180, class = "WARRIOR"     }, -- Recklessness
	[3411]   = { default = false, duration = 30,  class = "WARRIOR"     }, -- Intervene
	[5246]   = { default = false, duration = 90,  class = "WARRIOR"     }, -- Intimidating Shout
	[6544]   = { default = false, duration = 45,  class = "WARRIOR"     }, -- Heroic Leap
	[6552]   = { default = true,  duration = 15,  class = "WARRIOR"     }, -- Pummel
	[18499]  = { default = false, duration = 30,  class = "WARRIOR"     }, -- Berserker Rage
	[23920]  = { default = false, duration = 20,  class = "WARRIOR"     }, -- Shield Reflect
	[46968]  = { default = false, duration = 20,  class = "WARRIOR"     }, -- Shockwave
	[102060] = { default = true,  duration = 40,  class = "WARRIOR"     }, -- Disrupting Shout
	[114028] = { default = false, duration = 30,  class = "WARRIOR"     }, -- Mass Shield Reflect
	[114029] = { default = false, duration = 30,  class = "WARRIOR"     }, -- Safeguard
	[118000] = { default = false, duration = 60,  class = "WARRIOR"     }, -- Dragon Roar
	[99]     = { default = false, duration = 30,  class = "DRUID"       }, -- Disorienting Roar
	[5211]   = { default = false, duration = 50,  class = "DRUID"       }, -- Bash
	[50334]  = { default = false, duration = 180, class = "DRUID"       }, -- Berserk
	[61336]  = { default = false, duration = 180, class = "DRUID"       }, -- Survival Instincts
	[78675]  = { default = true,  duration = 60,  class = "DRUID"       }, -- Solar Beam
	[102359] = { default = false, duration = 30,  class = "DRUID"       }, -- Mass Entanglement
	[106839] = { default = true,  duration = 15,  class = "DRUID"       }, -- Skull Bash
	[132469] = { default = false, duration = 30,  class = "DRUID"       }, -- Typhoon
	[8122]   = { default = false, duration = 42,  class = "PRIEST"      }, -- Psychic Scream
	[15487]  = { default = true,  duration = 45,  class = "PRIEST"      }, -- Silence
	[33206]  = { default = false, duration = 180, class = "PRIEST"      }, -- Pain Suppression
	[47585]  = { default = false, duration = 120, class = "PRIEST"      }, -- Dispersion
	[47788]  = { default = false, duration = 180, class = "PRIEST"      }, -- Guardian Spirit
	[64044]  = { default = false, duration = 45,  class = "PRIEST"      }, -- Psychic Horror
	[6360]   = { default = false, duration = 25,  class = "WARLOCK"     }, -- Whiplash
	[19505]  = { default = false, duration = 15,  class = "WARLOCK"     }, -- Devour Magic (Felhunter)
	[119910] = { default = true,  duration = 24,  class = "WARLOCK"     }, -- Spell Lock (Felhunter)
		[132409] = { duration = 24, class = "WARLOCK", parent = 119910  }, -- Spell Lock (Grimoire of Sacrifice)
		[115781] = { duration = 24, class = "WARLOCK", parent = 119910  }, -- Optical Blast (Observer)
	[111859] = { default = false, duration = 120, class = "WARLOCK"     }, -- Grimoire: Imp
	[111896] = { default = false, duration = 120, class = "WARLOCK"     }, -- Grimoire: Succubus
	[111897] = { default = true,  duration = 120, class = "WARLOCK"     }, -- Grimoire: Felhunter
	[48020]  = { default = false, duration = 26,  class = "WARLOCK"     }, -- Demonic Portal
	[115284] = { default = false, duration = 15,  class = "WARLOCK"     }, -- Clone Magic (Observer)
	[115770] = { default = false, duration = 25,  class = "WARLOCK"     }, -- Fellash
	[8143]   = { default = false, duration = 60,  class = "SHAMAN"      }, -- Tremor Totem
	[8177]   = { default = false, duration = 25,  class = "SHAMAN"      }, -- Grounding Totem
	[30823]  = { default = false, duration = 60,  class = "SHAMAN"      }, -- Shamanistic Rage
	[51490]  = { default = false, duration = 45,  class = "SHAMAN"      }, -- Thunderstorm
	[51514]  = { default = false, duration = 45,  class = "SHAMAN"      }, -- Hex
	[57994]  = { default = true,  duration = 12,  class = "SHAMAN"      }, -- Wind Shear
	[108269] = { default = false, duration = 45,  class = "SHAMAN"      }, -- Capacitor Totem
	[108271] = { default = false, duration = 90,  class = "SHAMAN"      }, -- Astral Shift
	[108273] = { default = false, duration = 60,  class = "SHAMAN"      }, -- Windwalk Totem
	[108285] = { default = false, duration = 180, class = "SHAMAN"      }, -- Call of the Elements
	[1499]   = { default = false, duration = 30,  class = "HUNTER"      }, -- Freezing Trap
	[19263]  = { default = false, duration = 180, class = "HUNTER"      }, -- Deterrence
	[19386]  = { default = false, duration = 45,  class = "HUNTER"      }, -- Wyvern Sting
	[19574]  = { default = false, duration = 60,  class = "HUNTER"      }, -- Bestial Wrath
	[147362] = { default = true,  duration = 24,  class = "HUNTER"      }, -- Counter Shot
	[66]     = { default = false, duration = 300, class = "MAGE"        }, -- Invisibility
	[1953]   = { default = false, duration = 15,  class = "MAGE"        }, -- Blink
	[2139]   = { default = true,  duration = 24,  class = "MAGE"        }, -- Counterspell
	[11958]  = { default = false, duration = 180, class = "MAGE"        }, -- Cold Snap
	[12043]  = { default = false, duration = 90,  class = "MAGE"        }, -- Presence of Mind
	[12472]  = { default = false, duration = 180, class = "MAGE"        }, -- Icy Veins
	[31661]  = { default = false, duration = 20,  class = "MAGE"        }, -- Dragon's Breath
	[44572]  = { default = false, duration = 30,  class = "MAGE"        }, -- Deep Freeze
	[45438]  = { default = false, duration = 300, class = "MAGE"        }, -- Ice Block
	[102051] = { default = false, duration = 20,  class = "MAGE"        }, -- Frostjaw
	[113724] = { default = false, duration = 45,  class = "MAGE"        }, -- Ring of Frost
	[408]    = { default = false, duration = 20,  class = "ROGUE"       }, -- Kidney Shot
	[1766]   = { default = true,  duration = 15,  class = "ROGUE"       }, -- Kick
	[1856]   = { default = false, duration = 120, class = "ROGUE"       }, -- Vanish
	[2094]   = { default = false, duration = 180, class = "ROGUE"       }, -- Blind
	[2983]   = { default = false, duration = 60,  class = "ROGUE"       }, -- Sprint
	[5277]   = { default = false, duration = 180, class = "ROGUE"       }, -- Evasion
	[13750]  = { default = false, duration = 180, class = "ROGUE"       }, -- Adrenaline Rush
	[14185]  = { default = false, duration = 300, class = "ROGUE"       }, -- Preparation
	[31224]  = { default = false, duration = 60,  class = "ROGUE"       }, -- Cloak of Shadows
	[36554]  = { default = false, duration = 20,  class = "ROGUE"       }, -- Shadow Step
	[74001]  = { default = false, duration = 120, class = "ROGUE"       }, -- Combat Readiness
	[76577]  = { default = false, duration = 180, class = "ROGUE"       }, -- Smoke Bomb
	[115176] = { default = false, duration = 180, class = "MONK"        }, -- Zen Meditation
	[115203] = { default = false, duration = 180, class = "MONK"        }, -- Fortifying Brew
	[116705] = { default = true,  duration = 15,  class = "MONK"        }, -- Spear Hand Strike
	[116844] = { default = false, duration = 45,  class = "MONK"        }, -- Ring of Peace
	[116849] = { default = false, duration = 120, class = "MONK"        }, -- Life Cocoon
	[119381] = { default = false, duration = 45,  class = "MONK"        }, -- Leg Sweep
	[119996] = { default = false, duration = 25,  class = "MONK"        }, -- Transcendence: Transfer
	[122470] = { default = false, duration = 90,  class = "MONK"        }, -- Touch of Karma
	[122783] = { default = false, duration = 90,  class = "MONK"        }, -- Diffuse Magic
	[137562] = { default = false, duration = 120, class = "MONK"        }, -- Nimble Brew
}

local resets = {
	--[[ Grimoire of Sacrifice
	     - Spell Lock
	  ]]
	[108503] = { 119910 },

	--[[ Summon Felhunter
	     - Spell Lock
	  ]]
	[691] = { 119910 },

	--[[ Cold Snap
	     - Ice Block
	     - Presence of Mind
	     - Dragon's Breath
	  ]]
	[11958] = { 45438, 12043, 31661 },

	--[[ Preparation
	     - Sprint
	     - Vanish
	     - Evasion
	  ]]
	[14185] = { 2983, 1856, 5277 },

	--[[ Call of the Elements
	     - Tremor Totem
	     - Grounding Tote
	     - Capacitor Totem
	     - Windwalk Totem
	  ]]
	[108285] = { 8143, 8177, 108269, 108273 },
}

-- Defaults
local defaults = {
	size            = 40,
	columns         = 8,
	padding         = 2,
	locked          = false,
	center          = false,
	border          = true,
	growUpward      = true,
	showUnused      = false,
	unusedAlpha     = 0.45,
	swipeAlpha      = 0.65,
	noCooldownCount = false,
	noArena         = false,
	noBattleground  = false,
	noWorld         = false,
}

local OmniBar

local Masque = LibStub and LibStub("Masque", true)

local SETTINGS_VERSION = 2

local MAX_DUPLICATE_ICONS = 5

local BASE_ICON_SIZE = 36

StaticPopupDialogs["OMNIBAR_CONFIRM_RESET"] = {
	text = CONFIRM_RESET_SETTINGS,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		OmniBar_Reset(OmniBar)
		if OmniBarOptions then OmniBarOptions:refresh() end

		-- Refresh the cooldowns
		i = 1
		while _G["OmniBarOptionsPanel" .. i] do
			_G["OmniBarOptionsPanel" .. i]:refresh()
			i = i + 1
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	enterClicksFirstButton = true
}

for spellID,_ in pairs(cooldowns) do
	local name, _, icon = GetSpellInfo(spellID)
	cooldowns[spellID].icon = icon
	cooldowns[spellID].name = name
end

function OmniBar_ShowAnchor(self)
	if self.settings.locked or #self.active > 0 then
		self.anchor:Hide()
	else
		self.anchor:Show()
	end
end

function OmniBar_CreateIcon(self)
	if InCombatLockdown() then return end
	self.numIcons = self.numIcons + 1
	local f = CreateFrame("Button", self:GetName().."Icon"..self.numIcons, self.anchor, "OmniBarButtonTemplate")
	table.insert(self.icons, f)
end

function OmniBar_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name ~= addonName then return end
		self:UnregisterEvent("ADDON_LOADED")
		OmniBar = self
		self.icons = {}
		self.active = {}
		self.cooldowns = cooldowns
		self.BASE_ICON_SIZE = BASE_ICON_SIZE
		self.MAX_DUPLICATE_ICONS = MAX_DUPLICATE_ICONS
		self.numIcons = 0
		self:RegisterForDrag("LeftButton")

		-- Load the settings
		OmniBar_LoadSettings(self)

		-- Create the icons
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_CreateIcon(self)
			end
		end

		-- Create the duplicate icons
		for i = 1, self.MAX_DUPLICATE_ICONS do
			OmniBar_CreateIcon(self)
		end

		OmniBar_ShowAnchor(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")

		-- Add Options Panel category
		local frame = CreateFrame("Frame", "OmniBarOptions")
		frame:SetScript("OnShow", function(self)
			LoadAddOn("OmniBar_Options")
			self:refresh()
		end)
		frame.name = addonName
		InterfaceOptions_AddCategory(frame)

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, event, _, sourceGUID, _, sourceFlags, _,_,_,_,_, spellID = ...
		if self.disabled then return end
		if event == "SPELL_CAST_SUCCESS" and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
			if cooldowns[spellID] then OmniBar_AddIcon(self, spellID, sourceGUID) end

			-- Check if we need to reset any cooldowns
			if resets[spellID] then
				for i = 1, #self.active do
					if self.active[i].sourceGUID and self.active[i].sourceGUID == sourceGUID and self.active[i].cooldown:IsVisible() then
						-- cooldown belongs to this source
						for j = 1, #resets[spellID] do
							if resets[spellID][j] == self.active[i].spellID then
								self.active[i].cooldown:Hide()
							end
						end
					end
				end
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		local _, zone = IsInInstance()
		OmniBar_LoadPosition(self)
		self.disabled = (zone == "arena" and self.settings.noArena) or
			(zone == "pvp" and self.settings.noBattleground) or
			(zone == "none" and self.settings.noWorld)
		OmniBar_RefreshIcons(self)

	end
end


function OmniBar_LoadSettings(self, specific)
	if (not OmniBarDB) or (not OmniBarDB.version) or OmniBarDB.version ~= SETTINGS_VERSION then
		OmniBarDB = { version = SETTINGS_VERSION, Default = {} }
		for k,v in pairs(defaults) do
			OmniBarDB.Default[k] = v
		end
	end
	local profile = UnitName("player").." - "..GetRealmName()
	if specific then
		OmniBarDB[profile] = nil
		if specific ~= 0 then
			-- Copy the current settings
			OmniBarDB[profile] = {}
			for a,b in pairs(OmniBarDB.Default) do
				if type(b) == "table" then
					OmniBarDB[profile][a] = {}
					for c,d in pairs(b) do
						if type(d) == "table" then
							OmniBarDB[profile][a][c] = {}
							for e,f in pairs(d) do
								OmniBarDB[profile][a][c][e] = f
							end
						else
							OmniBarDB[profile][a][c] = d
						end
					end
				else
					OmniBarDB[profile][a] = b
				end
			end
		end
	end
	self.profile = OmniBarDB[profile] and profile or "Default"
	self.settings = OmniBarDB[self.profile]

	self.settings.cooldowns = self.settings.cooldowns or {}

	-- Set the scale
	self.container:SetScale(self.settings.size/BASE_ICON_SIZE)

	-- Refresh if we toggled specific
	if specific then
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)
	end	
end

function OmniBar_Reset(self)
	local profile = UnitName("player").." - "..GetRealmName()
	OmniBarDB.Default = {}
	for k,v in pairs(defaults) do
		OmniBarDB.Default[k] = v
	end
	OmniBarDB[profile] = nil
	OmniBar_LoadSettings(self, 0)
end

function OmniBar_SavePosition(self)
	local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
	if not self.settings.position then 
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
end

function OmniBar_LoadPosition(self)
	self:ClearAllPoints()
	if self.settings.position then
		self:SetPoint(self.settings.position.point, UIParent, self.settings.position.relativePoint,
			self.settings.position.xOfs, self.settings.position.yOfs)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function OmniBar_IsSpellEnabled(self, spellID)
	if not spellID then return end
	-- Check for an explicit rule
	if self.settings.cooldowns and self.settings.cooldowns[spellID] then
		if self.settings.cooldowns[spellID].enabled then
			return true
		end
	elseif cooldowns[spellID].default then
		-- Not user-set, but a default cooldown
		return true
	end
end

function OmniBar_Center(self)
	local parentWidth = UIParent:GetWidth()
	local clamp = self.settings.center and (1 - parentWidth)/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
	clamp = self.settings.center and (self.anchor:GetWidth() - parentWidth)/2 or 0
	self.anchor:SetClampRectInsets(clamp, -clamp, 0, 0)
end

function OmniBar_CooldownFinish(self)
	local icon = self:GetParent()
	local bar = icon:GetParent():GetParent()

	local flash = icon.flashAnim
	local newItemGlowAnim = icon.newitemglowAnim

	if flash:IsPlaying() or newItemGlowAnim:IsPlaying() then
		flash:Stop()
		newItemGlowAnim:Stop()
	end

	if not bar.settings.showUnused then
		for i = 1, #bar.active do
			if bar.active[i] == icon then
				table.remove(bar.active, i)
				break
			end
		end
		icon:Hide()
	else
		if bar.settings.unusedAlpha then icon:SetAlpha(bar.settings.unusedAlpha) end
	end
	bar:StopMovingOrSizing()
	OmniBar_Position(bar)
end

function OmniBar_RefreshIcons(self)
	-- Hide all the icons
	for i = 1, self.numIcons do
		if self.icons[i].MasqueGroup then
			--self.icons[i].MasqueGroup:Delete()
			self.icons[i].MasqueGroup = nil
		end
		self.icons[i].cooldown:Hide()
		self.icons[i]:Hide()
	end
	wipe(self.active)
	for i = 1, self.numIcons do
		self.icons[i].active = nil
	end
	if self.disabled then return end

	if self.settings.showUnused then
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_AddIcon(self, spellID, nil, true)
			end
		end
	end
	OmniBar_Position(self)
end

function OmniBar_AddIcon(self, spellID, sourceGUID, init, test)
	-- Check for parent spellID
	local originalSpellID = spellID
	if cooldowns[spellID].parent then spellID = cooldowns[spellID].parent end

	if not OmniBar_IsSpellEnabled(self, spellID) then return end

	local i, duplicate = 1

	-- Try to find a free bar
	while self.icons[i] and self.icons[i]:IsVisible() do

		if self.icons[i].spellID == spellID then
			-- use icon if not bound to a sourceGUID
			if not self.icons[i].sourceGUID then
				break
			end

			-- if it's the same source, reuse the icon
			if sourceGUID and sourceGUID == self.icons[i].sourceGUID then
				break
			end

			local start, duration = self.icons[i].cooldown:GetCooldownTimes()
			if start >= 0 and (start+duration)/1000-GetTime() <= 1 then
				-- just reuse the icon if it is about to expire anyway
				break
			else
				-- icon is a duplicate
				duplicate = true
			end
		end

		i = i + 1
	end

	-- We couldn't find a spare icon
	if not self.icons[i] then return end

	self.icons[i].sourceGUID = sourceGUID
	self.icons[i].duplicate = duplicate
	self.icons[i].icon:SetTexture(cooldowns[spellID].icon)
	self.icons[i].spellID = spellID
	if not self.icons[i].active then
		self.icons[i].added = GetTime()
		table.insert(self.active, self.icons[i])
	end
	self.icons[i].active = true
	--if self.settings.showUnused then
		-- Keep cooldowns together
		table.sort(self.active, function(a,b) return a.spellID == b.spellID and a.added < b.added or a.spellID > b.spellID end)
	--end
	if not init then
		-- We don't want duration to be too long if we're just testing
		local duration = test and math.random(5,30) or cooldowns[originalSpellID].duration
		self.icons[i].cooldown:SetCooldown(GetTime(), duration)
		self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
		self.icons[i]:SetAlpha(1)
		if not self.settings.noGlow then
			self.icons[i].flashAnim:Play()
			self.icons[i].newitemglowAnim:Play()
		end
	end

	-- Masque
	if Masque then
		self.icons[i].MasqueGroup = Masque:Group("OmniBar", cooldowns[spellID].name)
		self.icons[i].MasqueGroup:AddButton(self.icons[i], {
			FloatingBG = false,
			Icon = icons[i].icon,
			Cooldown = icons[i].cooldown,
			Flash = false,
			Pushed = false,
			Normal = icons[i]:GetNormalTexture(),
			Disabled = false,
			Checked = false,
			Border = _G[icons[i]:GetName().."Border"],
			AutoCastable = false,
			Highlight = false,
			Hotkey = false,
			Count = false,
			Name = false,
			Duration = false,
			AutoCast = false,
		})
	end

	self.icons[i]:Show()
end

function OmniBar_UpdateIcons(self)
	for i = 1, self.numIcons do
		-- Set show text
		self.icons[i].cooldown:SetHideCountdownNumbers(self.settings.noCooldownCount and true or false)
		self.icons[i].cooldown.noCooldownCount = self.settings.noCooldownCount and true

		-- Set swipe alpha
		self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)

		-- Set border
		if self.settings.border then
			self.icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			self.icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		self.icons[i]:SetAlpha(self.settings.unusedAlpha and self.icons[i].cooldown:GetCooldownTimes() == 0 and
			self.settings.unusedAlpha or 1)

		-- Masque
		if self.icons[i].MasqueGroup then self.icons[i].MasqueGroup:ReSkin() end

	end
end

function OmniBar_Test(self)
	self.disabled = nil
	OmniBar_RefreshIcons(self)
	for k,v in pairs(cooldowns) do
		OmniBar_AddIcon(self, k, nil, nil, true)
	end
end

function OmniBar_Position(self)
	local numActive = #self.active
	if numActive == 0 then
		-- Show the anchor if needed
		OmniBar_ShowAnchor(self)
		return
	end
	local count, rows = 0, 1
	local grow = self.settings.growUpward and 1 or -1
	local padding = self.settings.padding and self.settings.padding or 0
	for i = 1, numActive do
		if self.settings.locked then
			self.active[i]:EnableMouse(false)
		else
			self.active[i]:EnableMouse(true)
		end
		self.active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, (BASE_ICON_SIZE+padding)*rows*grow)
				count = 0
				rows = rows + 1
			else
				self.active[i]:SetPoint("TOPLEFT", self.active[i-1], "TOPRIGHT", padding, 0)
			end
			
		else
			self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, 0)
		end
	end
	OmniBar_ShowAnchor(self)
end

SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function(msg)
	local cmd, arg1 = string.split(" ", string.lower(msg))

	if cmd == "lock" or cmd == "unlock" then
		OmniBar.settings.locked = cmd == "lock" and true or false
		OmniBar_Position(OmniBar)
		if OmniBarOptionsPanelLock then OmniBarOptionsPanelLock:SetChecked(OmniBar.settings.locked) end

	elseif cmd == "reset" then
		StaticPopup_Show("OMNIBAR_CONFIRM_RESET")

	elseif cmd == "test" then
		OmniBar_Test(OmniBar)

	else
		if LoadAddOn("OmniBar_Options") then
			InterfaceOptionsFrame_OpenToCategory(addonName)
			InterfaceOptionsFrame_OpenToCategory(addonName)
		end

	end

end
