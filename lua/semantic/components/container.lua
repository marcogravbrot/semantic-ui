local PANEL = {}

PANEL.methods = {
	["content"] = function(panel, tbl)
		panel:SetContent(tbl)
	end,	
}

function PANEL:SetContent(tbl)
	self.Items = self.Items or {}

	for k, v in pairs(tbl) do
		local comp = semantic.add(v.component, {}, self)
		if not comp then
			continue
		end
		comp:Dock(v.dock or RIGHT)
		comp:DockMargin(0, scale(1.75), scale(1.75), scale(1.75))
		comp:InvalidateParent(true)

		for k, v in pairs(v) do
			if k == "component" or k == "dock" then
				continue
			end

			semantic.method(comp, k, v)
		end

		table.insert(self.Items, comp)
	end
end

function PANEL:PerformLayout()
	if not self.Items then
		return
	end

	local width = 0
	for k, v in pairs(self.Items) do
		if not (IsValid(v) and (v != NULL) and (v != nil) and ispanel(v)) then return end
		width = width + v:GetWide() + scale(1.75)
	end

	self:SetWide(width + scale(2.5))
end

semantic.register("container", PANEL, "EditablePanel")