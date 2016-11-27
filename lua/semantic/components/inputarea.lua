local PANEL = {}

function PANEL:Init()
	self:SetAllowNonAsciiCharacters(true)
	self:SetMultiline(true)

	self:SetCursor("beam")
end

function PANEL:PaintTextEntryBackground(w, h)
	draw.RoundedBox(5, 0, 0, w, h, self:HasFocus() and semantic.color.blue or semantic.color.grey)

	draw.RoundedBox(5, 1, 1, w-2, h-2, semantic.color.white)
end

function PANEL:Paint(w, h)
	self:PaintTextEntryBackground(w, h)

	self:SetFontInternal("Lato Button Regular")

	local color = semantic.color.text

	if (not self:IsEnabled()) or not self:HasFocus() then
		color = Color(130, 130, 130)
	end

	self:DrawTextEntryText(color, Color(107, 185, 240), color)
end

semantic.register("inputarea", PANEL, "DTextEntry")