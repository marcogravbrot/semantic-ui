local PANEL = {}

PANEL.methods = {
	["items"] = function(panel, var)
		if not istable(var) then
			semantic.error(panel, "variable is not table")
			return
		end

		panel:Build(var)
	end,

	["selected"] = function(panel, var)
		panel.sheet.Selected = var

		for _, v in pairs(panel.sheet.Items) do
	        if _ == var then
	            panel.sheet:SetActiveTab(v.Tab)
	            panel.sheet.Selected = var
	        end
	    end
	end,
}

function PANEL:Init()
	self:Dock(FILL)
	self:InvalidateParent(true)

	self.topbar = vgui.Create("DPanel", self)
	self.topbar.Items = {}
	self.topbar:Dock(TOP)
	self.topbar:InvalidateParent(true)

	function self.topbar:PerformLayout(w, h)
		self:SetTall(scale(5))
	end

	self.sheet = vgui.Create("DPropertySheet", self)
	self.sheet:Dock(FILL)
	self.sheet:DockMargin(0, -28, 0, 0)

	self.sheet:InvalidateParent(true)
	self.sheet:SetFadeTime(0)
	self.sheet.Selected = 1

	function self.sheet:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, semantic.color.white)

		for k, v in pairs(self.Items) do
		    v.Tab:SetSize(0, 0)
		    v.Tab:SetVisible(false)
		end
	end
end

function PANEL:Build(tbl)
	local count = #tbl
	local main = self

	for k, v in pairs(tbl) do
		if not v.text then
			continue
		end

		local button = vgui.Create("DButton", self)
		button.PerformLayout = function(s, w, h)
			button:SetWide(self.topbar:GetWide()/count)
			button:SetTall(self.topbar:GetTall())
			button:SetPos((self.topbar:GetWide()/count)*(k-1), 0)
		end

		button:SetText("")

		local bg = vgui.Create("DPanel", self.sheet)
		bg:Dock(FILL)
		bg.Paint = function(s, w, h) end
		bg:InvalidateParent(true)
		v.func(bg)

		self.sheet:AddSheet(v.text, bg, nil, true, false, nil)

		local color = v.color or semantic.color.white_light
		function button:Paint(w, h)
			self.mod = self.mod or 0
			if self.Hovered or (main.sheet.Selected == k) then
				self.mod = math.Approach(self.mod, 20, FrameTime()*500)
			end

			if self.Depressed then
				self.mod = math.Approach(self.mod, 40, FrameTime()*900)
			end

			if not self.Hovered then
				self.mod = math.Approach(self.mod, 0, FrameTime()*500)
			end

			draw.RoundedBox(0, 0, 0, w, h, Color(color.r-50-self.mod, color.g-50-self.mod, color.b-50-self.mod))
			draw.RoundedBox(0, 0, 0, w, h-2, Color(color.r-self.mod, color.g-self.mod, color.b-self.mod))

			surface.SetDrawColor(semantic.color.grey)
			surface.DrawLine(0, h-1, w, h-1)
			surface.DrawLine(w-1, 0, w-1, h)

			local icon = v.icon or nil
			if icon then
				surface.SetFont("FontAwesome")
				local iconw, iconh = surface.GetTextSize(icon)

				surface.SetFont("Lato Button Bold")
				local textw, texth = surface.GetTextSize(v.text)
				surface.SetTextColor(v.textcolor or semantic.color.text)
				surface.SetTextPos(w/2-textw/2+(iconw), h/2-texth/2)
				surface.DrawText(v.text)

				surface.SetFont("FontAwesome")
				surface.SetTextPos(w/2-textw/2-(iconw), h/2-iconh/2)
				surface.DrawText(icon)
			else
				surface.SetFont("Lato Button Bold")
				local textw, texth = surface.GetTextSize(v.text)
				surface.SetTextColor(v.textcolor or semantic.color.text)
				surface.SetTextPos(w/2-textw/2, h/2-texth/2)
				surface.DrawText(v.text)
			end
		end

		function button.DoClick(pnl)
			for _, v in pairs(self.sheet.Items) do
		        if _ == k then
		            self.sheet:SetActiveTab(v.Tab)
		            self.sheet.Selected = k
		        end
		    end	
		end
	end
end
		
semantic.register("topbar", PANEL, "DPanel")