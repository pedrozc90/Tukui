local T, C, L = unpack((select(2, ...)))

local Miscellaneous = T["Miscellaneous"]
local UIWidgets = CreateFrame("Frame")

function UIWidgets:SkinUIWidgetStatusBar(widgetInfo, widgetContainer)
	local Bar = self.Bar
	local Torghast = IsInJailersTower and IsInJailersTower() or false

	if Bar and not Bar.IsSkinned then
		if Bar.BGLeft and Bar.BGLeft.SetAlpha then Bar.BGLeft:SetAlpha(0) end
		if Bar.BGRight and Bar.BGRight.SetAlpha then Bar.BGRight:SetAlpha(0) end
		if Bar.BGCenter and Bar.BGCenter.SetAlpha then Bar.BGCenter:SetAlpha(0) end
		if Bar.BorderLeft and Bar.BorderLeft.SetAlpha then Bar.BorderLeft:SetAlpha(0) end
		if Bar.BorderRight and Bar.BorderRight.SetAlpha then Bar.BorderRight:SetAlpha(0) end
		if Bar.BorderCenter and Bar.BorderCenter.SetAlpha then Bar.BorderCenter:SetAlpha(0) end
		
		Bar:CreateBackdrop(Torghast and "Transparent" or "")
		
		Bar.Backdrop:CreateShadow()
		Bar.Backdrop:SetFrameLevel(Bar:GetFrameLevel())
		Bar.Backdrop:SetOutside(Bar)

		if Torghast then
			Bar.Indicator = Bar:CreateTexture(nil, "OVERLAY")
			Bar.Indicator:SetSize(16, 16)
			Bar.Indicator:SetPoint("TOP", 23, 9)
			Bar.Indicator:SetTexture(C.Medias.ArrowDown)
			Bar.Indicator:SetVertexColor(1, 0, 0)
		end

		Bar.IsSkinned = true
	end

	if self:GetParent() == UIWidgetPowerBarContainerFrame then
		Bar:ClearAllPoints()
		Bar:SetPoint("CENTER", UIWidgets.Holder, "CENTER", 0, 0)
	end

	-- Just hate that thing to be in objective tracker
	if Torghast then
		local Container = self:GetParent()

		Container:SetParent(UIWidgets.Holder)
		Container:ClearAllPoints()
		Container:SetPoint("TOP", UIWidgets.Holder, "TOP", 0, 0)
	end
end

function UIWidgets:Enable()
	local MinimapWidget = UIWidgetBelowMinimapContainerFrame

	-- Hack to avoid UIWidgetBelowMinimapContainerFrame to move in UIParent.lua (L2987)
	MinimapWidget.GetNumWidgetsShowing = function() return 0 end

	-- Create a widget holder
	self.Holder = CreateFrame("Frame", "TukuiWidget", UIParent)
	self.Holder:SetSize(220, 20)
	self.Holder:SetPoint("TOP", 3, -96)

	-- This is now the frame that contain capture bar and other shit like that.
	MinimapWidget:SetParent(self.Holder)
	MinimapWidget:ClearAllPoints()
	MinimapWidget:SetPoint("CENTER")
	
	if UIWidgetPowerBarContainerFrame then
		if C.Misc.DisplayWidgetPowerBar then
			-- This is power bar
			UIWidgetPowerBarContainerFrame:SetParent(self.Holder)
			UIWidgetPowerBarContainerFrame:ClearAllPoints()
			UIWidgetPowerBarContainerFrame:SetPoint("CENTER")
		else
			UIWidgetPowerBarContainerFrame:SetParent(T.Hider)
		end
	end

	-- Skin status bars
	hooksecurefunc(UIWidgetTemplateStatusBarMixin, "Setup", self.SkinUIWidgetStatusBar)

	T.Movers:RegisterFrame(self.Holder, "UI Widgets")
end

Miscellaneous.UIWidgets = UIWidgets
