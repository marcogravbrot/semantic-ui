local PANEL = {}

PANEL.methods = {}

AccessorFunc(PANEL, "text", "Text", FORCE_STRING)

function PANEL:Init()
	self:Dock(TOP)
	self:DockMargin(scale(2.5), scale(2.5), scale(2.5), 0)
end

function PANEL:Paint(w, h)
	local text = self:GetText()
	if text then
		surface.SetFont("Lato Text Bold")
		local textw, texth = surface.GetTextSize(text)
		surface.SetTextColor(semantic.color.text)
		surface.SetTextPos(w/2-textw/2, h/2-texth/2)
		surface.DrawText(text)

		surface.SetDrawColor(semantic.color.grey)

		surface.DrawLine(0, h/2, w/2-textw/2-scale(2), h/2)
		surface.DrawLine(w/2+textw/2+scale(2), h/2, w, h/2)
	end
end

semantic.register("divider", PANEL, "EditablePanel")