local PANEL = {}

PANEL.methods = {
	["model"] = function(panel, var)
		panel:SetModel(var)
	end,

	["material"] = function(panel, var)
		if isstring(var) then
			var = Material(var)
		end
		
		panel:SetMaterial(var)
	end,
}

function PANEL:SetModel(model)
	self.Model = model
	local p = self
	self.preview = vgui.Create("DModelPanel", self.pcont)
	self.preview:Dock(TOP)
	self.preview:DockMargin(0, 0, scale(2), 0)
	function self.preview:PerformLayout(w, h)
		self:SetTall(scale(10))
	end

	self.preview:SetModel(model)
	local mn, mx = self.preview.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
	self.preview:SetFOV( 45 )
	self.preview:SetCamPos( Vector( size, size, size ) )
	self.preview:SetLookAt( (mn + mx) * 0.5 )
end

function PANEL:SetMaterial(mat)
	self.Material = mat

	self.preview = vgui.Create("Panel", self.pcont)
	self.preview:Dock(TOP)
	self.preview:DockMargin(0, 0, scale(2), 0)
	function self.preview:PerformLayout(w, h)
		self:SetTall(scale(10))
	end

	function self.preview:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0, 0, h, h)
	end
end


function PANEL:GetModel(model)
	return self.Model
end

function PANEL:Init()
	self:SetTall(scale(12))
	self:DockPadding(scale(1), scale(0), scale(1), scale(0))

	self.pcont = self:addto("container", {
		dock = LEFT,
		w = scale(12),
	})

	self.price = vgui.Create("DLabel", self.pcont)
	self.price:Dock(BOTTOM)
	self.price:SetFont("Lato Warning Text")
	self.price:SetTextColor(semantic.color.text)

	self.Info = vgui.Create("Panel", self)
	self.Info:Dock(LEFT)
	self.Info.PerformLayout = function(w, h)
		if self.preview then
			self.Info:SetWide(self:GetWide()-self.preview:GetWide())
		end
	end

	self.Title = vgui.Create("DLabel", self.Info)
	self.Title:Dock(TOP)
	self.Title:SetFont("Lato Text Bold")
	self.Title:SetTextColor(semantic.color.text)
	self.Title:SizeToContents()

	self.Subtitle = self.Info:addto("text", {
		dock = TOP,
		margin = {0, 0, scale(2), 0},
	})
end

function PANEL:Paint(w, h)
	//draw.RoundedBox(5, 0, 0, w, h, semantic.color.white_background)
	//draw.RoundedBox(5, 1, 1, w-2, h-2, semantic.color.white)
end

semantic.register("item", PANEL, "Panel")