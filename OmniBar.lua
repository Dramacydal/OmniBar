
-- OmniBar by Jordon

local addonName, L = ...

local abilities = {
	[2139]   = { duration = 24 }, -- Counterspell
	[19647]  = { duration = 24 }, -- Spell Lock
	[57994]  = { duration = 12 }, -- Wind Shear
	[6552]   = { duration = 15 }, -- Pummel
	[102060] = { duration = 40 }, -- Disrupting Shout
	[47528]  = { duration = 15 }, -- Mind Freeze
	[1766]   = { duration = 15 }, -- Kick
	[96231]  = { duration = 15 }, -- Rebuke
	[116705] = { duration = 15 }, -- Spear Hand Strike
	[78675]  = { duration = 60 }, -- Solar Beam
	[15487]  = { duration = 45 }, -- Silence
	[41084]  = { duration = 24 }, -- Silencing Shot
	[115781] = { duration = 24 }, -- Optical Blast
	[147362] = { duration = 24 }, -- Counter Shot
}

-- Defaults
defaults = {
	size            = 40,
	columns         = 0,
	locked          = false,
	center          = false,
	border          = true,
	growUpward      = true,
	showUnused      = false,
	unusedAlpha     = 0.45,
	swipeAlpha      = 0.65,
	noCooldownCount = false,
}

local SETTINGS_VERSION = 2

local icons, active, _ = {}, {}

for spellID,_ in pairs(abilities) do
	abilities[spellID].icon = select(3, GetSpellInfo(spellID))
end

local OmniBar = CreateFrame("Frame", "OmniBar")
OmniBar.MAX_ICONS = 30
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
			for k,v in pairs(OmniBarDB.Default) do
				if type(v) == "table" then
					OmniBarDB[profile][k] = {}
					for x,y in pairs(v) do
						OmniBarDB[profile][k][x] = y
					end
				else
					OmniBarDB[profile][k] = v
				end
			end
		end
	end
	self.profile = OmniBarDB[profile] and profile or "Default"
	self.settings = OmniBarDB[self.profile]

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

function OmniBar:COMBAT_LOG_EVENT_UNFILTERED(_, event, _,_,_, sourceFlags, _,_,_,_,_, spellID)
	if event == "SPELL_CAST_SUCCESS" and abilities[spellID] and bit.band(sourceFlags, 0x00000040) == 0x00000040 then
		self:AddIcon(spellID)
	end
end

function OmniBar:PLAYER_ENTERING_WORLD()
	self:LoadPosition()
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
		if icons[i].duplicate or not self.settings.showUnused then
			icons[i]:Hide()
		end
	end
	active = {}
	for i = 1, self.MAX_ICONS do
		icons[i].active = nil
	end

	if self.settings.showUnused then
		for spellID,_ in pairs(abilities) do
			self:AddIcon(spellID, true)
		end
	end
	self:Position()
end

function OmniBar:AddIcon(spellID, init, test)
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
	icons[i].icon:SetTexture(abilities[spellID].icon)
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
		local duration = test and math.random(5,30) or abilities[spellID].duration
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
	self:RefreshIcons()
	for k,v in pairs(abilities) do
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
