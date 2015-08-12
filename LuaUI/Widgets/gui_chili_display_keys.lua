--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Display Keys",
		desc      = "Displays the current key combination.",
		author    = "GoogleFrog",
		date      = "12 August 2015",
		license   = "GNU GPL, v2 or later",
		layer     = -10000,
		enabled   = false
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

include("keysym.h.lua")

local keyData, mouseData

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Options

options_path = 'Settings/HUD Panels/Extras/Display Keys'

options_order = {
	'keyReleaseTimeout', 'mouseReleaseTimeout',
}
 
options = {
	keyReleaseTimeout = {
		name  = "Key Release Timeout",
		type  = "number",
		value = 0.6, min = 0, max = 5, step = 0.025,
	},
	mouseReleaseTimeout = {
		name  = "Mouse Release Timeout",
		type  = "number",
		value = 0.3, min = 0, max = 5, step = 0.025,
	},
}

local panelColor = {1,1,1,0.7}
local highlightColor = {1,0.8, 0.1, 0.9}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Window Creation

local function InitializeDisplayLabelControl(name)
	local data = {}
	
	local screenWidth, screenHeight = Spring.GetWindowGeometry()

	local window = Chili.Window:New{
		parent = screen0,
		backgroundColor = {0, 0, 0, 0},
		color = {0, 0, 0, 0},
		dockable = true,
		name = name,
		padding = {0,0,0,0},
		x = 0,
		y = 740,
		clientWidth  = 380,
		clientHeight = 64,
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		minimizable = false,
		OnMouseDown = ShowOptions,
	}
	
	local mainPanel = Chili.Panel:New{
		backgroundColor = {1,1,1,0.7},
		color = {1,1,1, 0.7},
		parent = window,
		padding = {0,0,0,0},
		y      = 0,
		x      = 0,
		right  = 0,
		bottom = 0,
		dockable = false;
		draggable = false,
		resizable = false,
		OnMouseDown = ShowOptions,
	}
	
	local displayLabel = Chili.Label:New{
		parent = mainPanel,
		x      = 15,
		y      = 10,
		right  = 10,
		bottom = 12,
		caption = "",
		valign = "center",
 		align  = "center",
		autosize = false,
		font   = {
			size = 36, 
			outline = true, 
			outlineWidth = 2, 
			outlineWeight = 2,
		},
	}
	
	local function UpdateWindow(val)
		displayLabel:SetCaption(val)
	end
	
	local function Dispose()
		window:Dispose()
	end
	
	local data = {
		UpdateWindow = UpdateWindow,
		Dispose = Dispose,
	}
	
	return data
end

local function InitializeMouseButtonControl(name)
	local window = Chili.Window:New{
		parent = screen0,
		backgroundColor = {0, 0, 0, 0},
		color = {0, 0, 0, 0},
		dockable = true,
		name = name,
		padding = {0,0,0,0},
		x = 60,
		y = 676,
		clientWidth  = 260,
		clientHeight = 64,
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		minimizable = false,
		OnMouseDown = ShowOptions,
	}
	
	local leftPanel = Chili.Panel:New{
		backgroundColor = panelColor,
		color = panelColor,
		parent = window,
		padding = {0,0,0,0},
		y      = 0,
		x      = 0,
		right  = "62%",
		bottom = 0,
		dockable = false;
		draggable = false,
		resizable = false,
		OnMouseDown = ShowOptions,
	}
	local middlePanel = Chili.Panel:New{
		backgroundColor = panelColor,
		color = panelColor,
		parent = window,
		padding = {0,0,0,0},
		y      = 0,
		x      = "38%",
		right  = "38%",
		bottom = 0,
		dockable = false;
		draggable = false,
		resizable = false,
		OnMouseDown = ShowOptions,
	}
	local rightPanel = Chili.Panel:New{
		backgroundColor = panelColor,
		color = panelColor,
		parent = window,
		padding = {0,0,0,0},
		y      = 0,
		x      = "62%",
		right  = 0,
		bottom = 0,
		dockable = false;
		draggable = false,
		resizable = false,
		OnMouseDown = ShowOptions,
	}
	
	local function UpdateWindow(val)
		if val == 1 then
			leftPanel.backgroundColor = highlightColor
			leftPanel.color = highlightColor
			middlePanel.backgroundColor = panelColor
			middlePanel.color = panelColor
			rightPanel.backgroundColor = panelColor
			rightPanel.color = panelColor
		elseif val == 2 then
			leftPanel.backgroundColor = panelColor
			leftPanel.color = panelColor
			middlePanel.backgroundColor = highlightColor
			middlePanel.color = highlightColor
			rightPanel.backgroundColor = panelColor
			rightPanel.color = panelColor
		elseif val == 3 then
			leftPanel.backgroundColor = panelColor
			leftPanel.color = panelColor
			middlePanel.backgroundColor = panelColor
			middlePanel.color = panelColor
			rightPanel.backgroundColor = highlightColor
			rightPanel.color = highlightColor
		else
			leftPanel.backgroundColor = panelColor
			leftPanel.color = panelColor
			middlePanel.backgroundColor = panelColor
			middlePanel.color = panelColor
			rightPanel.backgroundColor = panelColor
			rightPanel.color = panelColor
		end
		leftPanel:Invalidate()
		middlePanel:Invalidate()
		rightPanel:Invalidate()
		window:Invalidate()
	end
	
	local function Dispose()
		window:Dispose()
	end
	
	local data = {
		UpdateWindow = UpdateWindow,
		Dispose = Dispose,
	}
	
	return data
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- General Functions

local function DoDelayedUpdate(data, dt)
	if not data then
		return
	end
	
	if not data.updateTime then
		return
	end
	
	data.updateTime = data.updateTime - dt
	if data.updateTime > 0 then
		return
	end
	
	data.UpdateWindow(data.updateData)
	data.updateTime = false
end

function widget:Update(dt)
	if mouseData.pressed then
		local x, y, lmb, mmb, rmb = Spring.GetMouseState()
		if not (lmb or mmb or rmb) then
			mouseData.pressed = false
			mouseData.updateData = false
			mouseData.updateTime = options.mouseReleaseTimeout.value
		end
	end

	DoDelayedUpdate(keyData, dt)
	DoDelayedUpdate(mouseData, dt)
end

function widget:Shutdown()
	if keyData then
		keyData.Dispose()
	end
	if mouseData then
		mouseData.Dispose()
	end
end

function widget:Initialize()
	Chili = WG.Chili
	screen0 = Chili.Screen0
	
	if (not Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	mouseData = InitializeMouseButtonControl("Mouse Display", 280)
	keyData = InitializeDisplayLabelControl("Key Display", 380)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Keys

local function IsMod(key)
	return key == 32 or key >= 128
end

local onlyMods = false

local function Conc(str, add, val)
	if val then
		if onlyMods then
			return (str or "") .. (str and " + " or "") .. add
		else
			return (str or "") .. add .. " + "
		end
	else
		return str
	end
end

function widget:KeyPress(key, modifier, isRepeat)
	if not keyData then
		return
	end
	
	onlyMods = IsMod(key) and not keyData.pressed

	local keyText = Conc(false, "Space", modifier.meta)
	keyText = Conc(keyText, "Ctrl", modifier.ctrl)
	keyText = Conc(keyText, "Alt", modifier.alt)
	keyText = Conc(keyText, "Shift", modifier.shift)
	
	if not onlyMods then
		if not keyData.pressed then
			keyData.pressedString = string.upper(tostring(string.char(key)))
		end
		keyData.pressed = true
		keyText = (keyText or "") .. keyData.pressedString
	end
	
	keyData.UpdateWindow(keyText or "")
	keyData.updateData = keyText or ""
	keyData.updateTime = false
end

function widget:KeyRelease(key, modifier, isRepeat)
	if not keyData then
		return
	end
	
	if not IsMod(key) then
		keyData.pressed = false
	end
	
	onlyMods = not keyData.pressed
	
	local keyText = Conc(false, "Space", modifier.meta)
	keyText = Conc(keyText, "Ctrl", modifier.ctrl)
	keyText = Conc(keyText, "Alt", modifier.alt)
	keyText = Conc(keyText, "Shift", modifier.shift)
	
	if not onlyMods then
		keyText = (keyText or "") .. keyData.pressedString
	end
	
	keyData.updateData = keyText or ""
	keyData.updateTime = options.keyReleaseTimeout.value
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Mouse

function widget:MousePress(x, y, button)
	if not mouseData then
		return
	end
	mouseData.pressed = true
	mouseData.UpdateWindow(button)
	mouseData.updateTime = false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------