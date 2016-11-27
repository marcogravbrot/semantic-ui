local PANEL = {}

PANEL.methods = {
	["items"] = function(panel, var)
		if not istable(var) then
			semantic.error(panel, "variable is not table")
			return
		end

		for k, v in pairs(var) do
			panel:Add(v.text, v.func)
		end
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

	self.sidebar = vgui.Create("Panel", self)
	self.sidebar.Items = {}
	self.sidebar:Dock(LEFT)
	self.sidebar:SetWide(scale(20))
	self.sidebar:InvalidateParent(true)

	function self.sidebar:Paint(w, h)
		surface.SetDrawColor(30, 30, 30)
		surface.DrawRect(0, 0, w, h)
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

function PANEL:Add(text, func)
	self.sidebar.Items = self.sidebar.Items or {}
	table.insert(self.sidebar.Items, {text = text, func = func})
	local k = #self.sidebar.Items

	local button = vgui.Create("DButton", self)
	button:SetPos(0, (k-1)*(scale(6)))
	button:SetTall(scale(6))
	button:SetWide(self.sidebar:GetWide())
	button:SetText(text)
	button:SetTextColor(Color(0, 0, 0, 0))

	local bg = vgui.Create("Panel", self.sheet)
	bg:Dock(FILL)
	bg.Paint = function(s, w, h) s.Width = w s.Height = h end
	bg:InvalidateParent(true)
	func(bg)

	self.sheet:AddSheet(text, bg, nil, true, false, nil)

	local color = semantic.color.black
	function button:Paint(w, h)
		self.mod = self.mod or 0
		if self.Hovered then
			self.mod = math.Approach(self.mod, 20, FrameTime()*500)
		end

		if self.Depressed then
			self.mod = math.Approach(self.mod, 40, FrameTime()*900)
		end

		if not self.Hovered then
			self.mod = math.Approach(self.mod, 0, FrameTime()*500)
		end

		draw.RoundedBox(0, 0, 0, w, h, Color(28+self.mod, 28+self.mod, 28+self.mod))

		surface.SetDrawColor(Color(45, 46, 47))
		surface.DrawLine(0, h-1, w, h-1)

		surface.SetFont("Lato Button Bold")
		local textw, texth = surface.GetTextSize(self:GetText())
		surface.SetTextColor(semantic.color.white_text)
		surface.SetTextPos(scale(2.5), h/2-texth/2)
		surface.DrawText(self:GetText())
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
		
semantic.register("sidebar", PANEL, "DPanel")