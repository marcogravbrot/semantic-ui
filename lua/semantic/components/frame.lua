local PANEL = {}

PANEL.ClickExit = true

PANEL.methods = {
	["footer"] = function(panel, var)
		if isfunction(var) and panel.Footer then
			var(panel.Footer)
		elseif isstring(var) then
			panel.Footer.Text = var
		elseif var == false then
			panel.Footer:Remove()
			panel.Footer = nil
		end
	end,

	["background"] = function(panel, var)
		panel.Background = var
	end,
}

function PANEL:Init()
	self.Title = "No title"
	self.Background = true
	self.Header = vgui.Create("Panel", self)
	self.Header:Dock(TOP)
	self.Header:SetTall(scale(7))

	function self.Header.Paint(panel, w, h)
		draw.RoundedBoxEx(5, 0, 0, w, h, semantic.color.white_dark_light, true, true, false, false)

		surface.SetDrawColor(semantic.color.grey)
		surface.DrawLine(0, h-1, w, h-1)

		surface.SetFont("Lato Bold")
		local textw, texth = surface.GetTextSize(self.Title)
		surface.SetTextColor(semantic.color.text)
		surface.SetTextPos(scale(2.5), h/2-texth/2)
		surface.DrawText(self.Title)
	end

	self.Footer = vgui.Create("Panel", self)
	self.Footer:Dock(BOTTOM)
	self.Footer:SetTall(scale(7))

	function self.Footer.Paint(s, w, h)
		draw.RoundedBoxEx(5, 0, 0, w, h, (self.Footer.Color or semantic.color.white_dark_light), false, false, true, true)

		surface.SetDrawColor(self.Footer.Color or semantic.color.grey)
		surface.DrawLine(0, 1, w, 1)

		local text = self.Footer.Text or ""
		surface.SetFont("Lato Text Bold")
		local textw, texth = surface.GetTextSize(text)
		surface.SetTextColor(semantic.color.text)
		surface.SetTextPos(scale(2.5), h/2-texth/2)
		surface.DrawText(text)
	end

	self:SetAlpha(0)
	self:AlphaTo(255, 0.2, 0, function()

	end)
end

function PANEL:Paint(w, h)
	if self.Background then
		self:NoClipping(false)
		surface.SetDrawColor(0, 0, 0, 220)
		local x, y = self:ScreenToLocal(0, 0)
		surface.DrawRect(x, y, ScrW(), ScrH())
		self:NoClipping(true)
	end

	draw.RoundedBox(5, 0, 0, w, h, semantic.color.white)
end

function PANEL:Callback(structure)
	self:MakePopup()
end

semantic.register("frame", PANEL, "EditablePanel", true)