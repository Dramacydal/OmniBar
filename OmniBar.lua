
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
	[1022]   = { default = false, duration = 300, class = "PALADIN"     }, -- Hand of Protection
	[1044]   = { default = false, duration = 25,  class = "PALADIN"     }, -- Hand of Freedom
	[6940]   = { default = false, duration = 120, class = "PALADIN"     }, -- Hand of Sacrifice
	[20066]  = { default = false, duration = 15,  class = "PALADIN"     }, -- Repentance
	[31821]  = { default = false, duration = 180, class = "PALADIN"     }, -- Devotion Aura
	[31884]  = { default = false, duration = 120, class = "PALADIN"     }, -- Avenging Wrath
	[96231]  = { default = true,  duration = 15,  class = "PALADIN"     }, -- Rebuke
	[105593] = { default = false, duration = 30,  class = "PALADIN"     }, -- Fist of Justice
	[114039] = { default = false, duration = 30,  class = "PALADIN"     }, -- Hand of Purity
	[871]    = { default = false, duration = 180, class = "WARRIOR"     }, -- Shield Wall
	[1719]   = { default = false, duration = 180, class = "WARRIOR"     }, -- Recklessness
	[3411]   = { default = false, duration = 30,  class = "WARRIOR"     }, -- Intervene
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
	[8122]   = { default = false, duration = 15,  class = "PRIEST"      }, -- Psychic Scream
	[15487]  = { default = true,  duration = 45,  class = "PRIEST"      }, -- Silence
	[33206]  = { default = false, duration = 180, class = "PRIEST"      }, -- Pain Suppression
	[47585]  = { default = false, duration = 120, class = "PRIEST"      }, -- Dispersion
	[47788]  = { default = false, duration = 180, class = "PRIEST"      }, -- Guardian Spirit
	[64044]  = { default = false, duration = 45,  class = "PRIEST"      }, -- Psychic Horror[
	[6360]   = { default = false, duration = 25,  class = "WARLOCK"     }, -- Whiplash
	[19505]  = { default = false, duration = 15,  class = "WARLOCK"     }, -- Devour Magic (Felhunter)
	[19647]  = { default = true,  duration = 24,  class = "WARLOCK"     }, -- Spell Lock (Felhunter)
	[48020]  = { default = false, duration = 26,  class = "WARLOCK"     }, -- Demonic portal
	[115284] = { default = false, duration = 15,  class = "WARLOCK"     }, -- Clone Magic (Observer)
	[115770] = { default = false, duration = 25,  class = "WARLOCK"     }, -- Fellash
	[115781] = { default = true,  duration = 24,  class = "WARLOCK"     }, -- Optic Blast
	[8143]   = { default = false, duration = 60,  class = "SHAMAN"      }, -- Tremor Totem
	[8177]   = { default = false, duration = 25,  class = "SHAMAN"      }, -- Grounding Totem
	[30823]  = { default = false, duration = 60,  class = "SHAMAN"      }, -- Shamanistic Rage
	[51490]  = { default = false, duration = 45,  class = "SHAMAN"      }, -- Thunderstorm
	[51514]  = { default = false, duration = 45,  class = "SHAMAN"      }, -- Hex
	[57994]  = { default = true,  duration = 12,  class = "SHAMAN"      }, -- Wind Shear
	[108271] = { default = false, duration = 90,  class = "SHAMAN"      }, -- Astral Shift
	[1499]   = { default = false, duration = 30,  class = "HUNTER"      }, -- Freezing Trap
	[19263]  = { default = false, duration = 180, class = "HUNTER"      }, -- Deterrence
	[19386]  = { default = false, duration = 45,  class = "HUNTER"      }, -- Wyvern Sting
	[19574]  = { default = false, duration = 60,  class = "HUNTER"      }, -- Bestial Wrath
	[41084]  = { default = true,  duration = 24,  class = "HUNTER"      }, -- Silencing Shot
	[147362] = { default = true,  duration = 24,  class = "HUNTER"      }, -- Counter Shot
	[66]     = { default = false, duration = 300, class = "MAGE"        }, -- Invisibility
	[1953]   = { default = false, duration = 15,  class = "MAGE"        }, -- Blink
	[2139]   = { default = true,  duration = 24,  class = "MAGE"        }, -- Counterspell
	[11958]  = { default = false, duration = 180, class = "MAGE"        }, -- Cold Snap
	[12472]  = { default = false, duration = 180, class = "MAGE"        }, -- Icy Veins
	[44572]  = { default = false, duration = 30,  class = "MAGE"        }, -- Deep Freeze
	[45438]  = { default = false, duration = 300, class = "MAGE"        }, -- Ice Block
	[102051] = { default = false, duration = 20,  class = "MAGE"        }, -- Frostjaw
	[113724] = { default = false, duration = 45,  class = "MAGE"        }, -- Ring of frost
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

-- Defaults
local defaults = {
	size            = 40,
	columns         = 9,
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
	cooldowns       = {},
}

local SETTINGS_VERSION = 2

local icons, active, _ = {}, {}

for spellID,_ in pairs(cooldowns) do
	cooldowns[spellID].icon = select(3, GetSpellInfo(spellID))
end

local OmniBar = CreateFrame("Frame", "OmniBar")
OmniBar.cooldowns = cooldowns
OmniBar.MAX_ICONS = 45
OmniBar:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
OmniBar:SetFrameStrata("MEDIUM")
OmniBar:SetClampedToScreen(true)
OmniBar:SetMovable(true)
OmniBar:RegisterForDrag("LeftButton")
OmniBar:SetScript("OnDragStart", function(self)
	self:Center()
	self:StartMoving()
end)

OmniBar:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	self:SavePosition()
end)

OmniBar:EnableMouse(true)
OmniBar.text = OmniBar:CreateFontString(nil, "ARTWORK")
OmniBar.text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
OmniBar.text:SetTextColor(1, 1, 0, 1)
OmniBar.text:SetText("OmniBar")
OmniBar.text:SetPoint("CENTER", OmniBar, "CENTER", 0, 0)
local w, h = OmniBar.text:GetSize()
OmniBar:SetSize(w*1.1, h*2)
local texture = OmniBar:CreateTexture()
texture:SetAllPoints()
texture:SetTexture(0, 0, 0, 0.3)

OmniBar:RegisterEvent("ADDON_LOADED")
function OmniBar:ADDON_LOADED(addon)
	if addon == addonName then
		self:UnregisterEvent("ADDON_LOADED")

		-- Load the settings
		self:LoadSettings()

		-- Create the icons
		for i = 1, self.MAX_ICONS do
			local f = CreateFrame("Frame", "OmniBar"..i)
			f:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" and not OmniBar.settings.locked then
					OmniBar:Center()
					OmniBar:StartMoving()
				end
			end)
			f:SetScript("OnMouseUp", function(self, button)
				if button == "LeftButton" and not OmniBar.settings.locked then
					OmniBar:StopMovingOrSizing()
					OmniBar:SavePosition()
				end
			end)
			f:SetFrameStrata("LOW")
			f.icon = f:CreateTexture()
			f.icon:SetAllPoints()
			f.cooldown = CreateFrame("Cooldown", "OmniBar"..i.."Cooldown", f, "CooldownFrameTemplate")
			f.cooldown:SetAllPoints()
			f.cooldown:SetDrawBling(false)
			f.cooldown:SetReverse(true)
			f.cooldown:SetDrawEdge(false)
			f.cooldown:SetScript("OnHide", function(self)
				local bar = self:GetParent()
				if not OmniBar.settings.showUnused then
					bar:Hide()
					for i = 1, #active do
						if active[i] == bar then
							table.remove(active, i)
							break
						end
					end
				else
					if OmniBar.settings.unusedAlpha then bar:SetAlpha(OmniBar.settings.unusedAlpha) end
				end
				OmniBar:StopMovingOrSizing()
				OmniBar:Position()
			end)
			f.cooldown:SetScript("OnShow", function() OmniBar:Position() end)
			f:Hide()
			table.insert(icons, f)
		end

		if self.settings.locked then
			self:Hide()
		else
			self:Show()
		end

		self:RefreshIcons()
		self:UpdateIcons()
		self:Center()

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
	end
end

function OmniBar:LoadSettings(specific)
	if (not OmniBarDB) or (not OmniBarDB.version) or OmniBarDB.version ~= SETTINGS_VERSION then
		OmniBarDB = { version = SETTINGS_VERSION, Default = defaults }
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

	-- Refresh if we toggled specific
	if specific then
		self:LoadPosition()
		self:RefreshIcons()
		self:UpdateIcons()
		self:Center()
	end	
end

function OmniBar:SavePosition()
	local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
	if not self.settings.position then 
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
end

function OmniBar:LoadPosition()
	self:ClearAllPoints()
	if self.settings.position then
		self:SetPoint(self.settings.position.point, UIParent, self.settings.position.relativePoint,
			self.settings.position.xOfs, self.settings.position.yOfs)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function OmniBar:SpellIsEnabled(spellID)
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

function OmniBar:Enable()
	self.disabled = nil

end

function OmniBar:Disable()
	self.disabled = true
end

function OmniBar:COMBAT_LOG_EVENT_UNFILTERED(_, event, _,_,_, sourceFlags, _,_,_,_,_, spellID)
	if self.disabled then return end
	if event == "SPELL_CAST_SUCCESS" and cooldowns[spellID] and bit.band(sourceFlags, 0x00000040) == 0x00000040 then
		if self:SpellIsEnabled(spellID) then
			self:AddIcon(spellID)
		end
	end
end

function OmniBar:PLAYER_ENTERING_WORLD()
	local _, zone = IsInInstance()
	self:LoadPosition()
	self.disabled = (zone == "arena" and self.settings.noArena) or
		(zone == "pvp" and self.settings.noBattleground) or
		(zone == "none" and self.settings.noWorld)
	self:RefreshIcons()
end

function OmniBar:Center()
	local clamp = self.settings.center and (self:GetWidth() - UIParent:GetWidth() * UIParent:GetScale())/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
end

function OmniBar:RefreshIcons()
	-- Hide all the icons
	for i = 1, self.MAX_ICONS do
		icons[i].cooldown:Hide()
		icons[i]:Hide()
	end
	active = {}
	for i = 1, self.MAX_ICONS do
		icons[i].active = nil
	end
	if self.disabled then return end

	if self.settings.showUnused then
		for spellID,_ in pairs(cooldowns) do
			if self:SpellIsEnabled(spellID) then
				self:AddIcon(spellID, true)
			end
		end
	end
	self:Position()
end

function OmniBar:AddIcon(spellID, init, test)
	if not self:SpellIsEnabled(spellID) then return end

	self:Hide()

	local i, duplicate = 1

	-- Try to find a free bar
	while icons[i] and icons[i]:IsVisible() do

		if icons[i].spellID == spellID then
			local start, duration = icons[i].cooldown:GetCooldownTimes()
			if start >= 0 and (start+duration)/1000-GetTime() <= 1 then
				-- just reuse the icon if it is about to expire anyway
				break
			else
				-- icon is a duplicate
				duplicate = true
			end
		end

		i = i + 1
		if i > self.MAX_ICONS then return end
	end
	icons[i].duplicate = duplicate
	icons[i].icon:SetTexture(cooldowns[spellID].icon)
	icons[i].spellID = spellID
	if not icons[i].active then
		icons[i].added = GetTime()
		table.insert(active, icons[i])
	end
	if self.settings.showUnused then
		icons[i].active = true
		-- Keep cooldowns together
		table.sort(active, function(a,b) return a.spellID == b.spellID and a.added < b.added or a.spellID > b.spellID end)
	end
	if not init then
		-- We don't want duration to be too long if we're just testing
		local duration = test and math.random(5,30) or cooldowns[spellID].duration
		icons[i].cooldown:SetCooldown(GetTime(), duration)
		icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
		icons[i]:SetAlpha(1)
	end
	icons[i]:Show()
end

function OmniBar:UpdateIcons()
	for i = 1, self.MAX_ICONS do
		-- Set size
		icons[i]:SetSize(self.settings.size, self.settings.size)

		-- Set show text
		icons[i].cooldown:SetHideCountdownNumbers(self.settings.noCooldownCount and true or false)
		icons[i].cooldown.noCooldownCount = self.settings.noCooldownCount and true or nil

		-- Set swipe alpha
		icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)

		-- Set border
		if self.settings.border then
			icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		icons[i]:SetAlpha(self.settings.unusedAlpha and icons[i].cooldown:GetCooldownTimes() == 0 and
			self.settings.unusedAlpha or 1)
	end
end

function OmniBar:Test()
	self.disabled = nil
	self:RefreshIcons()
	for k,v in pairs(cooldowns) do
		self:AddIcon(k, nil, true)
	end
end

function OmniBar:Position()
	if #active == 0 then
		-- Show the anchor if needed
		if self.settings.locked then
			self:Hide()
		else
			self:Show()
		end
		return
	end
	local count, rows, numActive, grow = 0, 1, #active, self.settings.growUpward and 1 or -1
	for i = 1, numActive do
		if self.settings.locked then
			active[i]:EnableMouse(false)
		else
			active[i]:EnableMouse(true)
		end
		active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				active[i]:SetPoint("CENTER", OmniBar, "CENTER", -self.settings.size*(columns-1)/2, OmniBar.settings.size*rows*grow)
				count = 0
				rows = rows + 1
			else
				active[i]:SetPoint("TOPLEFT", active[i-1], "TOPRIGHT", 0, 0)
			end
			
		else
			active[i]:SetPoint("CENTER", OmniBar, "CENTER", -self.settings.size*(columns-1)/2, 0)
		end
	end
end

SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function()
	InterfaceOptionsFrame_OpenToCategory(addonName)
	InterfaceOptionsFrame_OpenToCategory(addonName)
end
