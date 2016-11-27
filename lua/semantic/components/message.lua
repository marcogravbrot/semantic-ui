local PANEL = {}

PANEL.methods = {}

AccessorFunc(PANEL, "title", "Title", FORCE_STRING)
AccessorFunc(PANEL, "text", "Text", FORCE_STRING)

function PANEL:Init()
	self:Dock(TOP)
	self:DockMargin(scale(2.5), scale(2.5), scale(2.5), 0)

	self:SetTitle("Example")
	self:SetText("This panel is an example of the incredibly neat Semantic UI")
end

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, semantic.color.warning.border)
	draw.RoundedBox(5, 1, 1, w-2, h-2, semantic.color.warning.background)

	local text = self:GetTitle()
	surface.SetFont("Lato Warning Title")
	local textw, texth = surface.GetTextSize(text)
	surface.SetTextColor(semantic.color.warning.bold)
	surface.SetTextPos(scale(1.25), scale(1.25))
	surface.DrawText(text)

	local text = self:GetText()
	surface.SetFont("Lato Warning Text")
	surface.SetTextColor(semantic.color.warning.text)
	surface.SetTextPos(scale(1.25), texth + scale(1.25))
	surface.DrawText(text)
end

semantic.register("message", PANEL, "EditablePanel")