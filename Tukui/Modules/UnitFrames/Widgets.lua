local T, C, L = unpack((select(2, ...)))

local UnitFrames = T["UnitFrames"]
local CreateFrame = _G.CreateFrame

local Widgets = {}

-- oUF base elements
-- Configures oUF element Health.
do
	local defaults = function(unitFrame)
		return {
			height = 28,
			orientation = "HORIZONTAL",
			font = C.UnitFrames.Font,
			showValue = true,
			valueAnchor = { "CENTER", 0, -6 },
			tag = "|cff549654[perhp]%|r",
			texture = C.Textures.UFHealthTexture
		}
	end

	Widgets.HealthBar = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Health = CreateFrame("StatusBar", nil, unitFrame)
		local HealthTexture = T.GetTexture(config.texture)
		local Font = T.GetFont(config.font)

		Health:SetPoint("TOPLEFT")
		Health:SetPoint("TOPRIGHT")
		Health:SetHeight(config.height)
		Health:SetStatusBarTexture(HealthTexture)
		Health:SetOrientation(config.orientation)

		Health.Background = Health:CreateTexture(nil, "BACKGROUND")
		Health.Background:SetTexture(HealthTexture)
		Health.Background:SetAllPoints(Health)
		Health.Background.multiplier = C.UnitFrames.StatusBarBackgroundMultiplier / 100

		if config.showValue then
			Health.Value = Health:CreateFontString(nil, "OVERLAY")
			Health.Value:SetFontObject(Font)
			Health.Value:SetPoint(config.valueAnchor[1], Health, config.valueAnchor[2], config.valueAnchor[3], config.valueAnchor[4])
		end

		Health.colorDisconnected = true
		Health.colorClass = true
		Health.colorReaction = true
		if C.UnitFrames.Smoothing then
			Health.smoothing = true
		end

		unitFrame.Health = Health
		unitFrame.Health.bg = Health.Background
		unitFrame:Tag(Health.Value, config.tag)
	end
end

-- Configures oUF element Power.
do
	local defaults = function(unitFrame)
		return {
			height = 3,
			font = C.UnitFrames.Font,
			showValue = false,
			valueAnchor = { "BOTTOMRIGHT", -4, 0 },
			texture = C.Textures.UFPowerTexture,
		}
	end

	Widgets.PowerBar = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Health = unitFrame.Health
		local Power = CreateFrame("StatusBar", nil, unitFrame)
		local PowerTexture = T.GetTexture(config.texture)

		Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
		Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
		Power:SetHeight(config.height)
		Power:SetStatusBarTexture(PowerTexture)

		Power.Background = Power:CreateTexture(nil, "BORDER")
		Power.Background:SetTexture(PowerTexture)
		Power.Background:SetAllPoints(Power)
		Power.Background.multiplier = C.UnitFrames.StatusBarBackgroundMultiplier / 100

		if config.showValue then
			Power.Value = Power:CreateFontString(nil, "OVERLAY")
			Power.Value:SetFontObject(config.font)
			Power.Value:SetPoint(config.valueAnchor[1], Power, config.valueAnchor[2], config.valueAnchor[3], config.valueAnchor[4])
			Power.PostUpdate = UnitFrames.PostUpdatePower
		end

		Power.colorPower = true
		if C.UnitFrames.Smoothing then
			Power.smoothing = true
		end

		unitFrame.Power = Power
		unitFrame.Power.bg = Power.Background
	end
end

-- Configures oUF element RaidTargetIndicator.
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			size = C.UnitFrames.RaidIconSize,
			anchor = { "TOP", 0, C.UnitFrames.RaidIconSize / 2 },
		}
	end

	Widgets.RaidTargetIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local RaidIcon = config.parent:CreateTexture(nil, "OVERLAY")

		RaidIcon:SetSize(config.size, config.size)
		RaidIcon:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])
		RaidIcon:SetTexture([[Interface\AddOns\Tukui\Medias\Textures\Others\RaidIcons]])

		unitFrame.RaidTargetIndicator = RaidIcon
	end
end

-- Configures oUF element ReadyCheckIndicator.
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			size = C.UnitFrames.RaidIconSize,
			anchor = { "CENTER" },
		}
	end

	Widgets.ReadyCheckIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local ReadyCheck = config.parent:CreateTexture(nil, "OVERLAY", nil, 2)

		ReadyCheck:SetSize(config.size, config.size)
		ReadyCheck:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])

		unitFrame.ReadyCheckIndicator = ReadyCheck
	end
end

-- Configures oUF element ResurrectIndicator.
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			size = 24,
			anchor = { "CENTER" },
		}
	end

	Widgets.ResurrectIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Resurrect = config.parent:CreateTexture(nil, "OVERLAY")

		Resurrect:SetSize(config.size, config.size)
		Resurrect:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])

		unitFrame.ResurrectIndicator = Resurrect
	end
end

-- Configures oUF element LeaderIndicator
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame,
			size = 16,
			anchor = { "TOPRIGHT", "TOPLEFT", -4, 0 },
		}
	end

	Widgets.LeaderIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Leader = config.parent:CreateTexture(nil, "OVERLAY")

		Leader:SetSize(config.size, config.size)
		Leader:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])
		unitFrame.LeaderIndicator = Leader
	end
end

-- Configures oUF element Range.
do
	local defaults = function(unitFrame)
		return {
			outsideAlpha = C.UnitFrames.RangeAlpha,
		}
	end

	Widgets.RangeIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Range = {
			insideAlpha = 1,
			outsideAlpha = config.outsideAlpha,
		}

		unitFrame.Range = Range
	end
end

-- Configures oUF element Buffs (part of Auras).
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			height = 16,
			width = 79,
			anchor = { "TOPLEFT" },
			buffSize = 16,
			buffNum = 5,
			filter = "HELPFUL",
			onlyShowPlayer = false,
		}
	end

	Widgets.BuffsIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Buffs = CreateFrame("Frame", unitFrame:GetName().."Buffs", config.parent)

		Buffs:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])
		Buffs:SetHeight(config.height)
		Buffs:SetWidth(config.width)

		Buffs.size = config.buffSize
		Buffs.num = config.buffNum
		Buffs.numRow = 1
		Buffs.spacing = 2
		Buffs.initialAnchor = "TOPLEFT"
		Buffs.disableCooldown = true
		Buffs.disableMouse = true
		Buffs.onlyShowPlayer = config.onlyShowPlayer
		Buffs.filter = config.filter
		Buffs.PostCreateIcon = UnitFrames.PostCreateAura
		Buffs.PostUpdateIcon = UnitFrames.DesaturateBuffs
		Buffs.PostCreateButton = UnitFrames.PostCreateAura
		Buffs.PostUpdateButton = UnitFrames.DesaturateBuffs

		unitFrame.Buffs = Buffs
	end
end

-- Configures oUF element Debuffs (part of Auras).
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			height = 16,
			width = 79,
			anchor = { "LEFT", "RIGHT", 6, 0 },
			debuffSize = 16,
			debuffNum = 5,
			filter = "HARMFUL",
		}
	end

	Widgets.Debuffs = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Debuffs = CreateFrame("Frame", unitFrame:GetName().."Debuffs", config.parent)

		Debuffs:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])
		Debuffs:SetHeight(config.height)
		Debuffs:SetWidth(config.width)
		Debuffs.size = config.debuffSize
		Debuffs.num = config.num
		Debuffs.spacing = 2
		Debuffs.initialAnchor = "TOPLEFT"
		Debuffs.filter = config.filter
		Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
		Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura
		Debuffs.PostCreateButton = UnitFrames.PostCreateAura
		Debuffs.PostUpdateButton = UnitFrames.PostUpdateAura

		unitFrame.Debuffs = Debuffs
	end
end

-- Configures oUF element HealthPrediction.
do
	local defaults = function(unitFrame)
		return {
			texture = C.Textures.UFHealthTexture,
		}
	end

	Widgets.HealComm = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Health = unitFrame.Health
		local HealthTexture = T.GetTexture(config.texture)
		local Vertical = Health:GetOrientation() == "VERTICAL" and true or false

		local myBar = CreateFrame("StatusBar", nil, Health)
		local otherBar = CreateFrame("StatusBar", nil, Health)
		local absorbBar = CreateFrame("StatusBar", nil, Health)
		local healAbsorbBar = CreateFrame("StatusBar", nil, Health)

		myBar:SetOrientation(Vertical and "VERTICAL" or "HORIZONTAL")
		myBar:SetFrameLevel(Health:GetFrameLevel())
		myBar:SetStatusBarTexture(HealthTexture)
		myBar:SetPoint(Vertical and "LEFT" or "TOP")
		myBar:SetPoint(Vertical and "RIGHT" or "BOTTOM")
		myBar:SetPoint(Vertical and "BOTTOM" or "LEFT", Health:GetStatusBarTexture(), Vertical and "TOP" or "RIGHT")
		myBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommSelfColor))

		otherBar:SetOrientation(Vertical and "VERTICAL" or "HORIZONTAL")
		otherBar:SetFrameLevel(Health:GetFrameLevel())
		otherBar:SetStatusBarTexture(HealthTexture)
		otherBar:SetPoint(Vertical and "LEFT" or "TOP")
		otherBar:SetPoint(Vertical and "RIGHT" or "BOTTOM")
		otherBar:SetPoint(Vertical and "BOTTOM" or "LEFT", myBar:GetStatusBarTexture(), Vertical and "TOP" or "RIGHT")
		otherBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommOtherColor))

		absorbBar:SetOrientation(Vertical and "VERTICAL" or "HORIZONTAL")
		absorbBar:SetFrameLevel(Health:GetFrameLevel())
		absorbBar:SetStatusBarTexture(HealthTexture)
		absorbBar:SetPoint(Vertical and "LEFT" or "TOP")
		absorbBar:SetPoint(Vertical and "RIGHT" or "BOTTOM")
		absorbBar:SetPoint(Vertical and "BOTTOM" or "LEFT", otherBar:GetStatusBarTexture(), Vertical and "TOP" or "RIGHT")
		absorbBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommAbsorbColor))

		healAbsorbBar:SetOrientation(Vertical and "VERTICAL" or "HORIZONTAL")
		healAbsorbBar:SetFrameLevel(Health:GetFrameLevel()+1)
		healAbsorbBar:SetStatusBarTexture(HealthTexture)
		healAbsorbBar:SetPoint(Vertical and "LEFT" or "TOP")
		healAbsorbBar:SetPoint(Vertical and "RIGHT" or "BOTTOM")
		healAbsorbBar:SetPoint(Vertical and "TOP" or "RIGHT", otherBar:GetStatusBarTexture())
		healAbsorbBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommHealAbsorbColor))
		healAbsorbBar:SetReverseFill(true)

		local HealthPrediction = {
			myBar = myBar,
			otherBar = otherBar,
			absorbBar = absorbBar,
			healAbsorbBar = healAbsorbBar,
			maxOverflow = 1,
		}

		-- Enable smoothing bars animation?
		if C.UnitFrames.Smoothing then
			HealthPrediction.smoothing = true
		end

		unitFrame.HealthPrediction = HealthPrediction
	end
end


-- oUF Plugins
-- Configures oUF_AuraTrack.
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			icons = C.Raid.AuraTrackIcons,
			texture = C.Raid.AuraTrackSpellTextures,
			thickness = C.Raid.AuraTrackThickness,
		}
	end

	Widgets.AuraTrackIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local AuraTrack = CreateFrame("Frame", nil, config.parent)

		AuraTrack:SetAllPoints()
		AuraTrack.Texture = C.Medias.Normal
		AuraTrack.Font = C.Medias.Font
		AuraTrack.Icons = config.icons
		AuraTrack.SpellTextures = config.texture
		AuraTrack.Thickness = config.thickness

		unitFrame.AuraTrack = AuraTrack
	end
end

-- Configures oUF_RaidDebuffs.
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			size = 24,
			anchor = { "CENTER" },
			font = C.UnitFrames.Font
		}
	end

	Widgets.DebuffIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local RaidDebuffs = CreateFrame("Frame", nil, config.parent)
		local Font = T.GetFont(config.font)

		RaidDebuffs:SetSize(config.size, config.size)
		RaidDebuffs:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])
		RaidDebuffs:SetFrameLevel(config.parent:GetFrameLevel() + 10)
		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, "ARTWORK")
		RaidDebuffs.icon:SetTexCoord(.1, .9, .1, .9)
		RaidDebuffs.icon:SetInside(RaidDebuffs)
		RaidDebuffs.cd = CreateFrame("Cooldown", nil, RaidDebuffs, "CooldownFrameTemplate")
		RaidDebuffs.cd:SetInside(RaidDebuffs, 1, 0)
		RaidDebuffs.cd:SetReverse(true)
		RaidDebuffs.cd:SetHideCountdownNumbers(true)
		RaidDebuffs.cd:SetAlpha(.7)
		RaidDebuffs.timer = RaidDebuffs:CreateFontString(nil, "OVERLAY")
		RaidDebuffs.timer:SetFontObject(Font)
		RaidDebuffs.timer:SetPoint("CENTER", RaidDebuffs, 1, 0)
		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, "OVERLAY")
		RaidDebuffs.count:SetFontObject(Font)
		RaidDebuffs.count:SetPoint("BOTTOMRIGHT", RaidDebuffs, "BOTTOMRIGHT", 2, 0)
		RaidDebuffs.count:SetTextColor(1, .9, 0)

		unitFrame.RaidDebuffs = RaidDebuffs
	end
end


-- additional plugins
-- Creates a panel for the unit name.
do
	local defaults = function(unitFrame)
		return {
			font = C.UnitFrames.Font,
			nameAnchor = { "CENTER" },
			tag = "[Tukui:GetNameColor][Tukui:NameShort]",
		}
	end

	Widgets.NamePanel = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Power = unitFrame.Power
		local Panel = CreateFrame("Frame", nil, unitFrame)
		local NameFont = T.GetFont(config.font)

		Panel:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", 0, -1)
		Panel:SetPoint("TOPRIGHT", Power, "BOTTOMRIGHT", 0, -1)
		Panel:SetPoint("BOTTOM", 0, 0)
		Panel:CreateBackdrop()
		Panel.Backdrop:SetBorderColor(0, 0, 0, 0)

		local Name = Panel:CreateFontString(nil, "OVERLAY")
		Name:SetPoint(config.nameAnchor[1], Panel, config.nameAnchor[2], config.nameAnchor[3], config.nameAnchor[4])
		Name:SetFontObject(NameFont)

		unitFrame.Panel = Panel
		unitFrame.Name = Name

		if T.Retail then
			unitFrame:Tag(Name, config.tag)
		else
			unitFrame:Tag(Name, "[Tukui:NameShort]")
		end
	end
end

-- Creates a Name element.
do
	local defaults = function(unitFrame)
		return {
			parent = unitFrame.Health,
			font = C.UnitFrames.Font,
			anchor = { "CENTER" },
			tag = "[level] [Tukui:NameLong] [Tukui:Role]",
		}
	end

	Widgets.Name = function(unitFrame, config)
		local NameFont = T.GetFont(config.font)
		
		setmetatable(config, { __index = defaults(unitFrame) })
		local Name = config.parent:CreateFontString(nil, "OVERLAY")
		Name:SetPoint(config.anchor[1], config.parent, config.anchor[2], config.anchor[3], config.anchor[4])
		Name:SetFontObject(NameFont)

		unitFrame.Name = Name

		if T.Retail then
			unitFrame:Tag(Name, config.tag)
		else
			unitFrame:Tag(Name, "[level] [Tukui:NameLong]")
		end
	end
end

-- Highlights the currently selected unit.
do
	local defaults = function(unitFrame)
		return {
			size = C.UnitFrames.HighlightSize,
			color = C.UnitFrames.HighlightColor,
		}
	end

	Widgets.HighlightIndicator = function(unitFrame, config)
		setmetatable(config, { __index = defaults(unitFrame) })
		local Highlight = CreateFrame("Frame", nil, unitFrame, "BackdropTemplate")
		local Event = T.Retail and "GROUP_ROSTER_UPDATE" or "RAID_ROSTER_UPDATE"

		Highlight:SetBackdrop({edgeFile = C.Medias.Glow, edgeSize = config.size})
		Highlight:SetOutside(unitFrame, config.size, config.size)
		Highlight:SetBackdropBorderColor(unpack(config.color))
		Highlight:SetFrameLevel(0)
		Highlight:Hide()

		unitFrame.Highlight = Highlight

		unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED", UnitFrames.Highlight, true)
		unitFrame:RegisterEvent(Event, UnitFrames.Highlight, true)
	end
end

UnitFrames.Widgets = Widgets
