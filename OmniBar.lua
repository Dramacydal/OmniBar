
-- OmniBar by Jordon

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

OmniBarDB = OmniBarDB or {
	size            = 40,
	locked          = false,
	spiral          = true,
	center          = false,
	dim             = true,
	noborder        = false,
	noCooldownCount = false,
}

local bars, active, _ = {}, {}

OMNI_BAR_DIM = 0.45

local MAX_OMNI_BARS = 30

for spellID,_ in pairs(abilities) do
	abilities[spellID].icon = select(3, GetSpellInfo(spellID))
end

local OmniBar = CreateFrame("Frame", "OmniBar")
OmniBar:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

OmniBar:SetFrameStrata("HIGH")
OmniBar:SetPoint("CENTER")
OmniBar:SetClampedToScreen(true)
OmniBar:SetMovable(true)
OmniBar:RegisterForDrag("LeftButton")
OmniBar:SetScript("OnDragStart", function()
	OmniBar_Center()
	OmniBar:StartMoving()
end)

OmniBar:SetScript("OnDragStop", OmniBar.StopMovingOrSizing)
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
	if addon == "OmniBar" then
		OmniBar:UnregisterEvent("ADDON_LOADED")

		-- Create the bars
		for i = 1, MAX_OMNI_BARS do
			local f = CreateFrame("Frame", "OmniBar"..i)
			f:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" and not OmniBarDB.locked then
					OmniBar_Center()
					OmniBar:StartMoving()
				end
			end)
			f:SetScript("OnMouseUp", function(self, button)
				if button == "LeftButton" and not OmniBarDB.locked then
					OmniBar:StopMovingOrSizing()
				end
			end)
			f:SetFrameStrata("LOW")
			f:SetSize(OmniBarDB.size, OmniBarDB.size)
			f.icon = f:CreateTexture()
			f.icon:SetAllPoints()
			f.cooldown = CreateFrame("Cooldown", "OmniBar"..i.."Cooldown", f, "CooldownFrameTemplate")
			f.cooldown:SetAllPoints()

			if OmniBarDB.noborder then
				f.icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
			end
			if OmniBarDB.noCooldownCount then
				f.cooldown:SetHideCountdownNumbers(true)
				f.cooldown.noCooldownCount = true
			end
			f.cooldown:SetReverse(true)
			f.cooldown:SetDrawEdge(false)

			if not OmniBarDB.spiral then
				f.cooldown:SetDrawSwipe(false)
			end
			f.cooldown:SetScript("OnHide", function(self)
				local bar = self:GetParent()
				if not OmniBarDB.visible then
					bar:Hide()
					for i = 1, #active do
						if active[i] == bar then
							table.remove(active, i)
							break
						end
					end
				else
					if OmniBarDB.dim then bar:SetAlpha(OMNI_BAR_DIM) end
				end
				OmniBar:StopMovingOrSizing()
				OmniBar_Position()
			end)
			if OmniBarDB.dim then f:SetAlpha(OMNI_BAR_DIM) end
			f.cooldown:SetScript("OnShow", OmniBar_Position)
			f:Hide()
			table.insert(bars, f)
		end

		if OmniBarDB.locked then
			OmniBar:Hide()
		else
			OmniBar:Show()
		end

		if OmniBarDB.visible then
			for spellID,_ in pairs(abilities) do
				OmniBar_Show(spellID, true)
			end
		end
		OmniBar_Position()

		OmniBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		OmniBar:RegisterEvent("PLAYER_ENTERING_WORLD")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: Type /ob for options." )
	end
end

function OmniBar:COMBAT_LOG_EVENT_UNFILTERED(_, event, _,_,_, sourceFlags, _,_,_,_,_, spellID)
	if event == "SPELL_CAST_SUCCESS" and abilities[spellID] and bit.band(sourceFlags, 0x00000040) == 0x00000040 then
		OmniBar_Show(spellID)
	end
end

function OmniBar:PLAYER_ENTERING_WORLD()
	OmniBar_Hide()
end

function OmniBar_Center()
	local clamp = OmniBarDB.center and (OmniBar:GetWidth() - UIParent:GetWidth() * UIParent:GetScale())/2 or 0
	OmniBar:SetClampRectInsets(clamp, -clamp, 0, 0)
end
OmniBar_Center()

function OmniBar_Hide()
	-- Hide all the bars
	for i = 1, MAX_OMNI_BARS do
		bars[i].cooldown:Hide()
		if not OmniBarDB.visible then
			bars[i]:Hide()
		end
	end
	OmniBar.test = nil
end

function OmniBar_Show(spellID, init)
	OmniBar:Hide()
	local i = 1

	-- Try to find a free bar
	while bars[i] and bars[i]:IsVisible() do
		if OmniBarDB.visible then
			if bars[i].spellID == spellID then
				local start, duration = bars[i].cooldown:GetCooldownTimes()
				if start >= 0 and math.floor((start+duration)/1000-GetTime()) <= 1 then
					-- just reuse the bar if it is about to expire anyway
					break
				end
			end
		end
		i = i + 1
		if i > MAX_OMNI_BARS then return end
	end

	bars[i].icon:SetTexture(abilities[spellID].icon)
	bars[i].spellID = spellID
	if not bars[i].active then
		bars[i].added = GetTime()
		table.insert(active, bars[i])
	end
	if OmniBarDB.visible then
		bars[i].active = true
		-- Keep cooldowns together
		table.sort(active, function(a,b) return a.spellID == b.spellID and a.added < b.added or a.spellID > b.spellID end)
	end
	if not init then
		-- We don't want duration to be too long if we're just testing
		local duration = OmniBar.test and math.random(5,30) or abilities[spellID].duration
		bars[i].cooldown:SetCooldown(GetTime(), duration)
		bars[i].cooldown:SetSwipeColor(0, 0, 0, 0.65)
		bars[i]:SetAlpha(1)
	end
	bars[i]:Show()
end

function OmniBar_Position()
	if #active == 0 then
		if OmniBarDB.locked then
			OmniBar:Hide()
		else
			OmniBar:Show()
		end
		OmniBar.test = nil
		return
	end
	for i = 1, #active do
		active[i]:ClearAllPoints()
		if i > 1 then
			active[i]:SetPoint("TOPLEFT", active[i-1], "TOPRIGHT", 0, 0)
		else
			active[i]:SetPoint("CENTER", OmniBar, "CENTER", -OmniBarDB.size*(#active-1)/2, 0)
		end
	end
end

SLASH_OmniBar1 = "/ob"
SlashCmdList.OmniBar = function(msg)
	local cmd, arg1 = string.split(" ", string.lower(msg))

	if cmd == "center" then
		OmniBarDB.center = not OmniBarDB.center
		local status = OmniBarDB.center and "Enabled" or "Disabled"
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: Center " .. status)
		local y = select(5, OmniBar:GetPoint())
		OmniBar:SetPoint("CENTER", 0, y)

	elseif cmd == "size" then
		local size = tonumber(arg1)
		if size and size > 0 then
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: Size set to " .. size)
			if size ~= OmniBarDB.size then
				for i = 1, MAX_OMNI_BARS do
					bars[i]:SetSize(size, size)
				end
			end

			OmniBarDB.size = size
			OmniBar_Position()
		end

	elseif cmd == "hide" or cmd == "show" then
		OmniBarDB.visible = cmd == "show" and true or false
		local status = OmniBarDB.visible and "Show" or "Hide"
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: " .. status)
		OmniBar_Hide()
		active = {}
		for i = 1, MAX_OMNI_BARS do
			bars[i].active = nil
		end

		if OmniBarDB.visible then
			for spellID,_ in pairs(abilities) do
				OmniBar_Show(spellID, true)
			end
		end
		OmniBar_Position()

	elseif cmd == "border" then
		OmniBarDB.noborder = not OmniBarDB.noborder
		local status = OmniBarDB.noborder and "disabled" or "enabled"
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: Border " .. status)
		for i = 1, MAX_OMNI_BARS do
			bars[i].cooldown:SetDrawSwipe(OmniBarDB.spiral)
			if OmniBarDB.noborder then
				bars[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
			else
				bars[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			end
		end

	elseif cmd == "text" then
		OmniBarDB.noCooldownCount = not OmniBarDB.noCooldownCount
		local status = OmniBarDB.noCooldownCount and "Disabled" or "Enabled"
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: Text " .. status)
		for i = 1, MAX_OMNI_BARS do
			bars[i].cooldown:SetHideCountdownNumbers(OmniBarDB.noCooldownCount and true or false)
			bars[i].cooldown.noCooldownCount = OmniBarDB.noCooldownCount and true or nil
		end

	elseif cmd == "dim" then
		OmniBarDB.dim = not OmniBarDB.dim
		local status = OmniBarDB.dim and "Dim Enabled" or "Dim Disabled"
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: " .. status)
		for i = 1, MAX_OMNI_BARS do
			bars[i]:SetAlpha(OmniBarDB.dim and bars[i].cooldown:GetCooldownTimes() == 0 and OMNI_BAR_DIM or 1)
		end

	elseif cmd == "lock" or cmd == "unlock" then
		OmniBarDB.locked = cmd == "lock" and true or false
		local status = OmniBarDB.locked and "Locked" or "Unlocked"
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: " .. status)
		OmniBar_Position()

	elseif cmd == "spiral" then
		OmniBarDB.spiral = not OmniBarDB.spiral
		for i = 1, MAX_OMNI_BARS do
			bars[i].cooldown:SetDrawSwipe(OmniBarDB.spiral)
		end
		local status = OmniBarDB.spiral and "enabled" or "disabled"
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: Spiral " .. status)

	elseif cmd == "test" then
		local test, count = OmniBar.test, 0
		OmniBar_Hide()
		if test then return end
		OmniBar.test = true		
		for k,v in pairs(abilities) do
			OmniBar_Show(k)
			count = count + 1
			if arg1 and count >= tonumber(arg1) then break end
		end

	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: @project-version@")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob size <value>")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob lock")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob unlock")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob hide")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob show")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob dim")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob border")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob center")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob text")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob spiral")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob test")
	end
end
