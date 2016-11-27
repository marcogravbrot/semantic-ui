local PANEL = {}

function PANEL:SetPlayer(ply)
	self.Player = ply

	self.Avatar:SetPlayer(self.Player, 184)
	self.Name:SetText(self.Player:Name())
	self.Name:SizeToContentsX()
	
	self.Group:SetText(self.Player:GetUserGroup())
	self.Group:SizeToContentsX()

	local width = self.Group:GetWide() + self.Name:GetWide()
	self.Info:SetWide(width)
end

function PANEL:GetPlayer(ply)
	return self.Player
end

function PANEL:Init()
	self:SetTall(scale(6))
	self:DockPadding(scale(1), scale(1), scale(1), scale(1))

	self.Avatar = vgui.Create("AvatarMask", self)
	self.Avatar:Dock(LEFT)
	self.Avatar:DockMargin(0, 0, scale(2), 0)
	self.Avatar:InvalidateParent(true)
	self.Avatar:SetWide(scale(4))

	self.Info = vgui.Create("Panel", self)
	self.Info:Dock(LEFT)

	self.Name = vgui.Create("DLabel", self.Info)
	self.Name:Dock(TOP)
	self.Name:SetFont("Lato Text Bold")
	self.Name:SetTextColor(semantic.color.text)
	self.Name:SizeToContentsX()

	self.Group = vgui.Create("DLabel", self.Info)
	self.Group:Dock(TOP)
	self.Group:SetFont("Lato Warning Text")
	self.Group:SetTextColor(semantic.color.text_secondary)
	self.Group:SizeToContentsX()
end

function PANEL:Paint(w, h)
	//draw.RoundedBox(5, 0, 0, w, h, semantic.color.white_background)
	//draw.RoundedBox(5, 1, 1, w-2, h-2, semantic.color.white)
end

semantic.register("player", PANEL, "Panel")