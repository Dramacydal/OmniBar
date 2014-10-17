
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
}

OmniBarDB = OmniBarDB or {
	size   = 40,
	locked = false,
	spiral = true,
}

local bars, active, _ = {}, {}

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
OmniBar:SetScript("OnDragStart", OmniBar.StartMoving)
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
			f:SetScript("OnMouseDown", function(self,button)
				if button == "LeftButton" and not OmniBarDB.locked then
					OmniBar:StartMoving()
				end
			end)
			f:SetScript("OnMouseUp", function(self,button)
				if button == "LeftButton" and not OmniBarDB.locked then
					OmniBar:StopMovingOrSizing()
				end
			end)
			f:SetFrameStrata("LOW")
			f:SetSize(OmniBarDB.size, OmniBarDB.size)
			f.icon = f:CreateTexture()
			f.icon:SetAllPoints()
			f.cooldown = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
			f.cooldown:SetAllPoints()
			f.cooldown:SetDrawEdge(false)
			if not OmniBarDB.spiral then
				f.cooldown:SetDrawSwipe(false)
			end
			f.cooldown:SetScript("OnHide", function(self)
				local bar = self:GetParent()
				bar:Hide()
				for i = 1, #active do
					if active[i] == bar then
						OmniBar:StopMovingOrSizing()
						table.remove(active, i)
						break
					end
				end
				OmniBar_Position()
			end)
			f.cooldown:SetScript("OnShow", OmniBar_Position)
			f:Hide()
			table.insert(bars, f)
		end

		if OmniBarDB.locked then
			OmniBar:Hide()
		else
			OmniBar:Show()
		end
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

function OmniBar_Hide()
	-- Hide all the bars
	for i = 1, MAX_OMNI_BARS do
		bars[i]:Hide()
	end
	OmniBar.test = nil
end

function OmniBar_Show(spellID)
	OmniBar:Hide()
	local i = 1

	-- Try to find a free bar
	while bars[i] and bars[i]:IsVisible() do
		i = i + 1
		if i > MAX_OMNI_BARS then return end
	end

	bars[i].icon:SetTexture(abilities[spellID].icon)
	bars[i].cooldown:SetCooldown(GetTime(), abilities[spellID].duration)
	bars[i]:Show()
	table.insert(active, bars[i])
	OmniBar_Position()
end

function OmniBar_Position()
	if #active == 0 then
		if OmniBarDB.locked then
			OmniBar:Hide()
		else
			OmniBar:Show()
		end
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
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob center")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob spiral")
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: /ob test")
	end
end
