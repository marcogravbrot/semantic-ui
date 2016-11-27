if SERVER then
	return
end

BUTTON_PRIMARY = 1
BUTTON_SECONDARY = 2
BUTTON_ACCEPT = 3
BUTTON_DECLINE = 4
BUTTON_STANDARD = 5

semantic.components = semantic.components or {}
semantic.clickexit = semantic.clickexit or {}

semantic.methods = {
	["w"] = function(panel, var)
		return panel:SetWide(var)
	end,

	["h"] = function(panel, var)
		return panel:SetTall(var)
	end,

	["x"] = function(panel, var)
		local x, y = panel:GetPos()

		return panel:SetPos(var, y)
	end,

	["y"] = function(panel, var)
		local x, y = panel:GetPos()

		return panel:SetPos(x, y)
	end,

	["center"] = function(panel, var)
		if not isbool(var) then
			semantic.error(panel, "variable is not boolean")
			return
		end

		local function center()
			return panel:Center(var)
		end

		table.insert(panel.add, center)
	end,

	["draggable"] = function(panel, var)
		if not isbool(var) then
			semantic.error(panel, "variable is not boolean")
			return
		end

		return panel:SetDraggable(var)
	end,

	["sizable"] = function(panel, var)
		if not isbool(var) then
			semantic.error(panel, "variable is not boolean")
			return
		end

		return panel:SetSizable(var)
	end,

	["dock"] = function(panel, var)
		if not ((var == TOP) or (var == BOTTOM) or (var == LEFT) or (var == RIGHT)) then
			semantic.error(panel, "dock argument is not valid")
			return
		end

		local function invalidateparent()
			panel:Dock(var)
			panel:InvalidateParent(true)
		end

		table.insert(panel.add, invalidateparent)
	end,

	["margin"] = function(panel, var)
		if not istable(var) then
			semantic.error(panel, "wrong argument to margin")
			return
		end

		if not #var == 4 then
			semantic.error(panel, "wrong amount of arguments to margin")
			return
		end

		panel:DockMargin(unpack(var))
		local function invalidateparent()
			panel:InvalidateParent(true)
		end

		table.insert(panel.add, invalidateparent)
	end,

	["padding"] = function(panel, var)
		if not istable(var) then
			semantic.error(panel, "wrong argument to padding")
			return
		end

		if not #var == 4 then
			semantic.error(panel, "wrong amount of arguments to padding")
			return
		end

		panel:DockPadding(unpack(var))
		local function invalidateparent()
			panel:InvalidateParent(true)
		end

		table.insert(panel.add, invalidateparent)
	end,

	["parent"] = function(panel, var)
		if not ispanel(var) then
			semantic.error(panel, "parent is not a panel")
			return
		end

		panel:SetParent(var)
	end,

	["closebuttons"] = function(panel, var)
		if not isbool(var) then
			semantic.error(panel, "variable is not boolean")
			return
		end

		panel:ShowCloseButton(var)
	end,

	["text"] = function(panel, var)
		if not isstring(var) then
			semantic.error(panel, "variable is not string")
			return
		end

		panel:SetText(var)
	end,

	["type"] = function(panel, var)
		if not (var == 1 or var == 2 or var == 3 or var == 4 or var == 5) then
			semantic.error(panel, "variable is not valid type")
			return
		end

		panel:SetType(var)
	end,

	["title"] = function(panel, var)
		if not isstring(var) then
			semantic.error(panel, "variable is not string")
			return
		end

		panel.Title = var	end,

	["doclick"] = function(panel, func)
		if not isfunction(func) then
			semantic.error(panel, "variable is not function")
			return
		end

		panel.DoClick = func
	end,

	["textcolor"] = function(panel, var)
		panel:SetTextColor(var)
	end,

	["font"] = function(panel, var)
		panel:SetFont(var)
	end,
}

semantic.color = {
	grey = Color(222, 222, 222),
	white = Color(255, 255, 255),
	white_background = Color(212, 212, 213),
	white_light = Color(249, 250, 251),
	white_dark_light = Color(248, 248, 248),
	white_selected = Color(243, 243, 243),
	blue = Color(33, 133, 208),
	blue_depressed = Color(30, 120, 188),
	blue_hovered = Color(50, 143, 212),
	black = Color(27, 28, 29),
	green = Color(33, 186, 69),
	text = Color(38, 38, 38),
	white_text = Color(250, 250, 250),
	red = Color(219, 40, 40),
	text_grey = Color(90, 90, 90),
	text_secondary = Color(60, 60, 60),

	warning = {
		bold = Color(121, 75, 2),
		text = Color(87, 58, 8),
		background = Color(255, 250, 243),
		border = Color(201, 186, 155),
	},
}

function semantic.scrollbar(vbar)
			vbar.Paint = function(s, w, h)
				draw.RoundedBox(4, 3, 13, 8, h - 24, Color(0, 0, 0, 70))
			end

			vbar.btnUp.Paint = function(s, w, h) end
			vbar.btnDown.Paint = function(s, w, h) end

			vbar.btnGrip.Paint = function(s, w, h)
				draw.RoundedBox(4, 5, 0, 4, h + 22, Color(0, 0, 0, 70))
			end
end

function scale(percentage, panel)
	return math.Round((panel and panel:GetTall() or ScrH())/100*percentage)
end

function scalew(percentage, panel)
	return math.Round((panel and panel:GetWide() or ScrW())/100*percentage)
end

function semantic.error(message, panel)
	if true then
		return
	end
	
	print(message, panel or "")
end

function semantic.register(name, panel, old)
	local pnl = vgui.Register(name, panel, old)

	semantic.components[name] = pnl
end

function semantic.method(panel, mt, var)
	if panel.methods then
		method = panel.methods[mt]
		if method then
			method(panel, var)

			return
		end
	end

	local method = semantic.methods[mt]
	if method then
		method(panel, var)
		return
	end

	panel[mt] = var
end

function semantic.add(name, structure, parent)
	local component = semantic.components[name]
	if not component then
		semantic.error(name, "component is not valid")

		return
	end

	local panel = vgui.Create(name)
	if parent then
		panel:SetParent(parent)
	end

	panel.add = {}
	for k, v in pairs(component) do
		if isfunction(v) then
			panel[k] = v
		end
	end

	for mt, var in pairs(structure) do
		semantic.method(panel, mt, var)
	end

	for k, v in pairs(panel.add) do
		if isfunction(v) then
			v()
		end
	end

	if panel.Callback then
		panel:Callback(structure)
	end

	if panel.ClickExit then
		table.insert(semantic.clickexit, panel)
	end

	return panel
end

local meta = FindMetaTable("Panel")
function meta:addto(name, structure)
	local p = semantic.add(name, structure, self)
	if p then
		return p
	end
end

function meta:testpaint()
	function self:Paint(w, h)
		surface.SetDrawColor(255, 150, 0, 200)
		surface.DrawRect(0, 0, w, h)
	end
end

function semantic.buildfonts()
	surface.CreateFont("Lato Button Bold", {
		font = "Lato Bold",
		size = scale(1.8),
	})

	surface.CreateFont("Lato Button Regular", {
		font = "Lato Regular",
		size = scale(1.8),
	})

	surface.CreateFont("Lato Bold", {
		font = "Lato Bold",
		size = math.Round(scale(2.75)),
	})

	surface.CreateFont("Lato Regular", {
		font = "Lato Regular",
		size = math.Round(scale(2.75)),
	})

	surface.CreateFont("Lato Title Bold", {
		font = "Lato Bold",
		size = math.Round(scale(4)),
	})

	surface.CreateFont("Lato Title Regular", {
		font = "Lato Regular",
		size = math.Round(scale(4)),
	})

	surface.CreateFont("Lato Text Bold", {
		font = "Lato Bold",
		size = math.Round(scale(2)),
	})

	surface.CreateFont("Lato Text Regular", {
		font = "Lato Regular",
		size = math.Round(scale(2)),
	})

	surface.CreateFont("Lato Warning Title", {
		font = "Lato Bold",
		size = math.Round(scale(1.9)),
	})

	surface.CreateFont("Lato Warning Text", {
		font = "Lato Regular",
		size = math.Round(scale(1.7)),
	})

	surface.CreateFont("Lato Big Bold", {
		font = "Lato Bold",
		size = math.Round(scale(6)),
	})

	surface.CreateFont("Lato Big Regular", {
		font = "Lato Regular",
		size = math.Round(scale(6)),
	})

	surface.CreateFont("FontAwesome", {
		font = "FontAwesome",
		size = math.Round(scale(2)),
		extended = true,
	})
end

semantic.buildfonts()

hook.Add("InitPostEntity", "Semantic Mouse Click", function()
	hook.Add("CreateMove", "Semantic Mouse Click", function(m, now)
		if input.WasMousePressed(MOUSE_LEFT) then
			for k, v in pairs(semantic.clickexit) do
				if v and IsValid(v) and ispanel(v) then
					if v:IsVisible() and v:IsValid() and v:HasFocus() then
						local mx, my = gui.MousePos()
						local px, py = v:GetPos()
						local pw, ph = v:GetSize()

						if (mx > px) and (my > py) and (mx < (px + pw)) and (my < (py + ph)) then
							return		
						end

						if v.Close then
							v:Close()

							return
						end

						v:Remove()
					end
				end

				v = nil
			end
		end
	end)
end)

local scrw, scrh = ScrW(), ScrH()
hook.Add("Think", "Font Auto Scale", function()
	local w, h = ScrW(), ScrH()

	if (w != scrw) or (h != scrh) then
		scrw, scrh = w, h

		hook.Call("ResolutionChange")
	end 
end)

hook.Add("ResolutionChange", "test", function()
	semantic.buildfonts()
end)

//
// Margins
//

MARGIN_DEFAULT = {scale(2.5), scale(2.5), scale(2.5), 0}