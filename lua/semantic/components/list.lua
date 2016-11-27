local PANEL = {}

AccessorFunc(PANEL, "title", "Title", FORCE_STRING)

PANEL.methods = {
	["title"] = function(panel, var)
		panel:SetTitle(var)
	end,

	["corners"] = function(panel, var)
		panel.Corners = var
	end,

	["doclick"] = function(panel, var)
		panel.Header.DoClick = var
	end,

	["textcolor"] = function(panel, var)
		panel.textcolor = var
	end,
}

function PANEL:Insert(pnl)
	pnl:SetParent(self.Usable)
	pnl:Dock(TOP)
	pnl:DockMargin(scale(1), scale(1), scale(1), 0)
	pnl:InvalidateParent(true)
	
	table.insert(self.Items, pnl)
	return pnl
end

function PANEL:Init()
	self.Corners = {true, true, true, true}
	self.Items = {}

	self:SetTitle("Example")
	self:SetTall(scale(4))

	self.Header = vgui.Create("DButton", self)
	self.Header:Dock(TOP)
	self.Header:SetTall(scale(5))
	self.Header:SetText("")

	function self.Header.Paint(panel, w, h)
		if not self:GetTitle() then
			panel:Remove()
		end
		
		panel.mod = panel.mod or 0
		panel.textmod = panel.textmod or 0
		if panel.Hovered then
			panel.mod = math.Approach(panel.mod, 225, FrameTime()*600)
		end

		if panel.Depressed then
			panel.mod = math.Approach(panel.mod, 180, FrameTime()*1200)
		end

		if not panel.Hovered then
			panel.mod = math.Approach(panel.mod, 255, FrameTime()*600)
		end

		if panel.Hovered then
			panel.textmod = math.Approach(panel.textmod, 0, FrameTime()*2000)
		else
			panel.textmod = math.Approach(panel.textmod, 255, FrameTime()*2000)
		end

		local col = self.color or semantic.color.white_selected
		col.a = panel.mod

		self.textcolor = self.textcolor or semantic.color.text

		draw.RoundedBoxEx(5, 0, 0, w, h, semantic.color.white_background, self.Corners[1], self.Corners[2], false, false)
		draw.RoundedBoxEx(5, 1, 1, w-2, h-2, semantic.color.black, self.Corners[1], self.Corners[2], false, false)
		draw.RoundedBoxEx(5, 1, 1, w-2, h-2, col, self.Corners[1], self.Corners[2], false, false)

		if self.second_title then
			local text = self.second_title
			surface.SetFont("Lato Text Regular")
			local textw, texth = surface.GetTextSize(text)
			local tcol = Color(self.textcolor.r, self.textcolor.g, self.textcolor.g)
			tcol.a = 255-panel.textmod
			surface.SetTextColor(tcol)
			surface.SetTextPos(w/2-textw/2, h/2-texth/2)
			surface.DrawText(text)
		end

		local text = self:GetTitle()
		surface.SetFont("Lato Text Regular")
		local textw, texth = surface.GetTextSize(text)
		local tcol = Color(self.textcolor.r, self.textcolor.g, self.textcolor.g)
		tcol.a = self.second_title and panel.textmod or 255
		surface.SetTextColor(tcol)
		surface.SetTextPos(w/2-textw/2, h/2-texth/2)
		surface.DrawText(text)
	end

	self.Usable = vgui.Create("DScrollPanel", self)
	self.Usable:Dock(FILL)
	self.Usable:DockMargin(0, 0, 0, 1)
	self.Usable:InvalidateParent(true)
	semantic.scrollbar(self.Usable.VBar)
end

function PANEL:Paint(w, h)
	draw.RoundedBoxEx(5, 0, 0, w, h, semantic.color.white_background, unpack(self.Corners))
	draw.RoundedBoxEx(5, 1, 1, w-2, h-2, semantic.color.white, unpack(self.Corners))
end

semantic.register("list", PANEL, "EditablePanel")