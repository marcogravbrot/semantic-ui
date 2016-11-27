local PANEL = {}

AccessorFunc(PANEL, "type", "Type", FORCE_NUMBER)

function PANEL:Init()
	self:SetTextColor(semantic.color.white)
	self:SetFont("Lato Button Bold")
	self:SetType(BUTTON_PRIMARY)
	self:SetTall(scale(4))
end

function PANEL:PerformLayout()
	surface.SetFont(self:GetFont())
	local textw, texth = surface.GetTextSize(self:GetText())
	textw = textw + scale(5)

	self:SetSize(textw, self:GetTall())
end

function PANEL:Paint(w, h)
	local color
	if self:GetType() == BUTTON_PRIMARY then
		color = semantic.color.blue
	elseif self:GetType() == BUTTON_SECONDARY then
		color = semantic.color.black
	elseif self:GetType() == BUTTON_ACCEPT then
		color = semantic.color.green
	elseif self:GetType() == BUTTON_DECLINE then
		color = semantic.color.red
	end

	if self:GetType() == BUTTON_STANDARD then
		color = semantic.color.grey

		self:SetTextColor(semantic.color.text_grey)
	else
		self:SetTextColor(semantic.color.white)
	end

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

	if self:GetType() == BUTTON_SECONDARY then
		draw.RoundedBox(5, 0, 0, w, h, Color(color.r, color.g, color.b, 255-self.mod))
	else
		draw.RoundedBox(5, 0, 0, w, h, Color(color.r-self.mod*4, color.g-self.mod*4, color.b-self.mod*4, 255))
	end
end

semantic.register("button", PANEL, "DButton")