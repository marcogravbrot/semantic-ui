local PANEL = {}

PANEL.methods = {
	["container"] = function(panel, var)
		panel.Container = var
	end,
}

function PANEL:Init()
	self:SetText("")
end

function PANEL:Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function PANEL:Paint(w, h)
	local color = semantic.color.white
	local bg = semantic.color.grey
	self.mod = self.mod or 0
	if self.Hovered then
		self.mod = math.Approach(self.mod, 5, FrameTime()*50)
	end

	if self.Depressed then
		self.mod = math.Approach(self.mod, 10, FrameTime()*100)
	end

	if not self.Hovered then
		self.mod = math.Approach(self.mod, 0, FrameTime()*50)
	end
	
	draw.NoTexture()

	//draw.RoundedBox(5, 0, 0, w, h, Color(bg.r-self.mod*4, bg.g-self.mod*4, bg.b-self.mod*4, 255))
	//draw.RoundedBox(5, 1, 1, w-2, h-2, Color(color.r, color.g, color.b, 255))

	surface.SetDrawColor(bg.r-self.mod*5, bg.g-self.mod*5, bg.b-self.mod*5, 255)
	self:Circle(math.Round(w/2), math.Round(h/2), math.Round(w/2)-1, 360)

	surface.SetDrawColor(color.r, color.g, color.b, 255)
	self:Circle(math.Round(w/2), math.Round(h/2), math.Round(w/2)-2, 360)

	if self.Container then
		if (self.Container.Selected == self) then
			draw.NoTexture()
			surface.SetDrawColor(semantic.color.text)
			self:Circle(math.Round(w/2), math.Round(h/2), math.Round(w/4), 360)
		end
	end
end

function PANEL:DoClick()
	if self.Container then
		self.Container.Selected = self
	end
end

semantic.register("checkbox", PANEL, "DButton")