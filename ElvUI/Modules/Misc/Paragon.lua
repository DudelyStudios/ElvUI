local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")
local DB = E:GetModule("DataBars", true)

local function AnchorParagonBadge(badge, frame)
	if not badge or not frame then return end

	badge:SetParent(frame)
	badge:SetFrameStrata(frame:GetFrameStrata() or "MEDIUM")
	badge:SetFrameLevel((frame:GetFrameLevel() or 1) + 30)
	badge:ClearAllPoints()

	local portrait = frame.Portrait
	local placedOnPortrait = false
	if portrait and frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY then
		local width = portrait.GetWidth and portrait:GetWidth() or 0
		local size = (width and width > 8) and width or 32
		badge:SetSize(size, size)
		badge:SetPoint("CENTER", portrait, "CENTER", 0, 0)
		placedOnPortrait = true
	end

	if not placedOnPortrait then
		badge:SetSize(28, 28)
		local health = frame.Health or frame
		if frame.unit == "target" then
			badge:SetPoint("CENTER", health, "RIGHT", 0, 0)
		else
			badge:SetPoint("CENTER", health, "LEFT", 0, 0)
		end
	end

	if badge.Text and badge.Text.GetFont then
		local font, _, flags = badge.Text:GetFont()
		badge.Text:SetFont(font or "Fonts\\FRIZQT__.TTF", math.max(10, badge:GetWidth() * 0.34), flags or "OUTLINE")
	end

	badge:Show()
end

hooksecurefunc(UF, "Update_PlayerFrame", function(_, frame)
	AnchorParagonBadge(ParagonCharacterLevel, frame)
end)

hooksecurefunc(UF, "Update_TargetFrame", function(_, frame)
	AnchorParagonBadge(ParagonTargetLevel, frame)
end)

if DB then
	local function RefreshParagonExpBar()
		if ParagonExpBar_UpdatePosition then
			ParagonExpBar_UpdatePosition()
		end
	end

	hooksecurefunc(DB, "ExperienceBar_Update", RefreshParagonExpBar)
	hooksecurefunc(DB, "ExperienceBar_UpdateDimensions", RefreshParagonExpBar)
end
