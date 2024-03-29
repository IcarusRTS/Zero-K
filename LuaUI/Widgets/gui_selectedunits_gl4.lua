function widget:GetInfo()
	return {
		name = "Selected Units GL4 2",
		desc = "Draw selection markers under units",
		author = "Fiendicus Prime, Beherith, Floris",
		date = "2023-12-19",
		license = "GNU GPL, v2 or later",
		-- Somewhere between layer -40 and -30 GetUnitUnderCursor starts
		-- returning nil before GetUnitsInSelectionBox includes that unit.
		layer = -30,
		enabled = true,
	}
end

local HOVER_SEL, LOCAL_SEL, OTHER_SEL = 1, 2, 3

-- Configurable Parts:
local lineWidth, showOtherSelections, drawDepthCheck, platterOpacity, outlineOpacity

---- GL4 Backend Stuff----
-- FIXME: Make VBOs into a table?
local selectionShader, hoverSelectionVBO, localSelectionVBO, otherSelectionVBO
local luaShaderDir                                          = "LuaUI/Widgets/Include/"

local hasBadCulling                                         = ((Platform.gpuVendor == "AMD" and Platform.osFamily == "Linux") == true)

-- Localize for speedups:
local spGetGameFrame                                        = Spring.GetGameFrame
local spGetGameState                                        = Spring.GetGameState
local spGetSelectedUnits                                    = Spring.GetSelectedUnits
local spGetUnitDefID                                        = Spring.GetUnitDefID
local spGetUnitIsDead                                       = Spring.GetUnitIsDead
local spGetUnitTeam                                         = Spring.GetUnitTeam
local spLoadCmdColorsConfig                                 = Spring.LoadCmdColorsConfig
local spValidUnitID                                         = Spring.ValidUnitID

local SafeWGCall                                            = function(fnName, param1)
	if fnName then return fnName(param1) else return nil end
end
local GetUnitUnderCursor                                    = function(onlySelectable)
	return SafeWGCall(WG.PreSelection_GetUnitUnderCursor, onlySelectable)
end
local GetUnitsInSelectionBox                                = function()
	return SafeWGCall(WG.PreSelection_GetUnitsInSelectionBox)
end
local IsSelectionBoxActive                                  = function()
	return SafeWGCall(WG.PreSelection_IsSelectionBoxActive)
end

local glStencilFunc                                         = gl.StencilFunc
local glStencilOp                                           = gl.StencilOp
local glStencilTest                                         = gl.StencilTest
local glStencilMask                                         = gl.StencilMask
local glColorMask                                           = gl.ColorMask
local glDepthTest                                           = gl.DepthTest
local glClear                                               = gl.Clear
local GL_ALWAYS                                             = GL.ALWAYS
local GL_NOTEQUAL                                           = GL.NOTEQUAL
local GL_KEEP                                               = 0x1E00 --GL.KEEP
local GL_STENCIL_BUFFER_BIT                                 = GL.STENCIL_BUFFER_BIT
local GL_REPLACE                                            = GL.REPLACE
local GL_POINTS                                             = GL.POINTS

local selUnits                                              = {}
local checkSelectionType = {}
local allySelUnits, hoverUnitID

local Init
options_path = 'Settings/Interface/Selection/Default Selections'
options_order = { 'showallselections', 'linewidth', 'platteropacity', 'outlineopacity', 'selectionheight', 'drawdepthcheck' }
options = {
	showallselections = {
		name = 'Show Other Selections',
		desc = 'Show selections of other players',
		type = 'bool',
		value = 'true',
		OnChange = function(self)
			Init()
		end,
	},
	linewidth = {
		name = 'Outline Width',
		desc = '',
		type = 'number',
		min = 0.1,
		max = 4,
		step = 0.1,
		value = 1.7,
		OnChange = function(self)
			Init()
		end,
	},
	platteropacity = {
		name = 'Fill Opacity',
		desc = 'Opacity of the selection fill - 0 is invisble',
		type = 'number',
		min = 0.0,
		max = 1,
		step = 0.05,
		value = 0.15,
		OnChange = function(self)
			Init()
		end,
	},
	outlineopacity = {
		name = 'Outline Opacity',
		desc = 'Opacity of the selection outline - 1 is solid',
		type = 'number',
		min = 0.0,
		max = 1.0,
		step = 0.05,
		value = 0.75,
		OnChange = function(self)
			Init()
		end,
	},
	selectionheight = {
		name = 'Selection Height',
		desc = 'How much to float the selection above the unit baseline - a value of 0 is more likely to be clipped by units',
		type = 'number',
		min = 0.0,
		max = 8.0,
		step = 1.0,
		value = 2,
		OnChange = function(self)
			Init()
		end,
	},
	drawdepthcheck = {
		name = 'Draw Selections in Unit Plane',
		desc = 'If disabled, selections are only drawn below units and never above - even for planes. This can cause the selection to be invisible. On the other hand, disabling this can increase performance.',
		type = 'bool',
		value = 'true',
		OnChange = function(self)
			Init()
		end,
	}
}

-- { vertices, width, length }
local unitDefToSel = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	local scaleFactor = 8.0
	local xsize, zsize = unitDef.xsize, unitDef.zsize
	local scale = (scaleFactor * (xsize ^ 2 + zsize ^ 2) ^ 0.5)
	if unitDef.customParams and unitDef.customParams.selection_scale then
		local factor = (tonumber(unitDef.customParams.selection_scale) or 1)
		scale = scale * factor
		xsize = xsize * factor
		zsize = zsize * factor
	end
	if unitDef.isImmobile then
		local platterOverlap = 1.0 -- To make sure there aren't rendering gaps between adjacent buildings.
		unitDefToSel[unitDefID] = {
			4,
			xsize * scaleFactor + platterOverlap,
			zsize * scaleFactor + platterOverlap
		}
	elseif unitDef.canFly then
		unitDefToSel[unitDefID] = {
			3,
			scale * 0.6,
			scale * 0.7
		}
	else
		unitDefToSel[unitDefID] = {
			64,
			scale,
			scale
		}
	end
end

local function AddSelected(unitID, unitTeam, vbo, animate)
	-- Clean up current selections
	if hoverSelectionVBO.instanceIDtoIndex[unitID] then
		popElementInstance(hoverSelectionVBO, unitID)
	end
	if localSelectionVBO.instanceIDtoIndex[unitID] then
		popElementInstance(localSelectionVBO, unitID)
	end
	if otherSelectionVBO.instanceIDtoIndex[unitID] then
		popElementInstance(otherSelectionVBO, unitID)
	end
	
	if spValidUnitID(unitID) ~= true or spGetUnitIsDead(unitID) == true then
		return
	end

	local unitDefID = spGetUnitDefID(unitID)
	if unitDefID == nil then
		return
	end

	local numVertices, width, length = unpack(unitDefToSel[unitDefID])

	-- When paused we don't want to animate from initial size because that may look misaligned / bad
	local _, _, paused = spGetGameState()
	local gf = paused and -30 or spGetGameFrame()
	animate = animate and 1 or 0

	-- Add the new selection
	pushElementInstance(
		vbo, -- push into this Instance VBO Table
		{
			length, width, 0, 0,                      -- lengthwidthcornerheight
			unitTeam,                                 -- teamID
			numVertices,                              -- how many trianges should we make
			gf, animate, 0, 0,                        -- the gameFrame (for animations), whether to animate (for preselection) and unused parameters
			0, 1, 0, 1,                               -- These are our default UV atlas tranformations
			0, 0, 0, 0                                -- these are just padding zeros, that will get filled in
		},
		unitID,                                       -- this is the key inside the VBO TAble,
		true,                                         -- update existing element
		nil,                                          -- noupload, dont use unless you
		unitID                                        -- last one should be UNITID?
	)
end

local function RemoveSelected(unitID)
	selUnits[unitID] = nil
	if hoverSelectionVBO.instanceIDtoIndex[unitID] then
		popElementInstance(hoverSelectionVBO, unitID)
	end
	if localSelectionVBO.instanceIDtoIndex[unitID] then
		popElementInstance(localSelectionVBO, unitID)
	end
	if otherSelectionVBO.instanceIDtoIndex[unitID] then
		popElementInstance(otherSelectionVBO, unitID)
	end
end

local function FindPreselUnits()
	local preselection = {}
	if hoverUnitID then
		preselection[hoverUnitID] = true
	end
	for _, unitID in pairs(GetUnitsInSelectionBox() or {}) do
		preselection[unitID] = true
	end
	return preselection
end

-- Hide/show the default Spring selection boxes
local function UpdateCmdColorsConfig(isOn)
	WG.widgets_handling_selection = WG.widgets_handling_selection or 0
	WG.widgets_handling_selection = WG.widgets_handling_selection + (isOn and 1 or -1)
	if not isOn and WG.widgets_handling_selection > 0 then
		return
	end
	spLoadCmdColorsConfig('unitBox  0 1 0 ' .. (isOn and 0 or 1))
end

function Init()
	lineWidth = options.linewidth.value
	showOtherSelections = options.showallselections.value
	drawDepthCheck = options.drawdepthcheck.value
	platterOpacity = options.platteropacity.value
	outlineOpacity = options.outlineopacity.value
	
	if drawDepthCheck then
		-- We're going to draw the outline twice so tweak the opacity value accordingly
		outlineOpacity = 1 - math.sqrt(1 - outlineOpacity)
	end
	checkSelectionType[HOVER_SEL] = true
	checkSelectionType[LOCAL_SEL] = true
	checkSelectionType[OTHER_SEL] = showOtherSelections

	for unitID, _ in pairs(selUnits) do
		RemoveSelected(unitID)
	end

	local DPatUnit = VFS.Include(luaShaderDir .. "DrawPrimitiveAtUnit.lua")
	local InitDrawPrimitiveAtUnitShader = DPatUnit.InitDrawPrimitiveAtUnitShader
	local InitDrawPrimitiveAtUnitVBO = DPatUnit.InitDrawPrimitiveAtUnitVBO
	local shaderConfig = DPatUnit.shaderConfig
	shaderConfig.BILLBOARD = 0
	shaderConfig.ANIMATION = 1
	shaderConfig.INITIALSIZE = 0.90
	shaderConfig.GROWTHRATE = 10.0
	shaderConfig.HEIGHTOFFSET = options.selectionheight.value
	shaderConfig.USETEXTURE = 0
	shaderConfig.POST_GEOMETRY = "gl_Position.z = (gl_Position.z) - 16.0 / gl_Position.w;" -- Pull forward a little to reduce ground clipping. This only affects the drawWorld pass.
	shaderConfig.POST_SHADING = "fragColor.rgba = vec4(g_color.rgb, texcolor.a * " .. platterOpacity .. " + texcolor.a * sign(addRadius) * " .. (outlineOpacity - platterOpacity) .. ");"
	selectionShader = InitDrawPrimitiveAtUnitShader(shaderConfig, "selectedUnits")
	hoverSelectionVBO = InitDrawPrimitiveAtUnitVBO("selectedUnits_hover")
	localSelectionVBO = InitDrawPrimitiveAtUnitVBO("selectedUnits_local")
	otherSelectionVBO = InitDrawPrimitiveAtUnitVBO("selectedUnits_other")

	return selectionShader ~= nil
end

local function DrawSelectionType(vbo, preUnit)
	if vbo.usedElements == 0 then
		return
	end
	selectionShader:SetUniform("addRadius", 0)

	-- Draw platter
	glDepthTest(false)
	glColorMask(preUnit) -- Only draw in preUnit, stencil later
	vbo.VAO:DrawArrays(GL_POINTS, vbo.usedElements)

	-- Draw outlines
	glDepthTest(not preUnit) -- No depth check for world
	glColorMask(true)
	selectionShader:SetUniform("addRadius", lineWidth)
	vbo.VAO:DrawArrays(GL_POINTS, vbo.usedElements)
end

-- Callins

function DrawSelections(preUnit)
	if hasBadCulling then
		gl.Culling(false)
	end

	selectionShader:Activate()

	selectionShader:SetUniform("iconDistance", 99999) -- pass
	glStencilTest(true)                            --https://learnopengl.com/Advanced-OpenGL/Stencil-testing
	glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE)      -- Set The Stencil Buffer To 1 Where Draw Any Polygon		this to the shader
	glClear(GL_STENCIL_BUFFER_BIT)                 -- set stencil buffer to 0
	glStencilFunc(GL_NOTEQUAL, 1, 1)               -- use NOTEQUAL instead of ALWAYS to ensure that overlapping transparent fragments dont get written multiple times
	glStencilMask(1)

	-- Each selection priority is drawn in sequence.
	DrawSelectionType(hoverSelectionVBO, preUnit)
	DrawSelectionType(localSelectionVBO, preUnit)
	DrawSelectionType(otherSelectionVBO, preUnit)

	selectionShader:Deactivate()

	-- This is the correct way to exit out of the stencil mode, to not break drawing of area commands:
	glStencilFunc(GL_ALWAYS, 1, 1)
	glStencilTest(false)
	glStencilMask(255)
	glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP)
	glClear(GL_STENCIL_BUFFER_BIT)
	-- All the above are needed :(
end

function widget:DrawWorldPreUnit()
	DrawSelections(true)
end

function widget:DrawWorld()
	if drawDepthCheck then
		DrawSelections(false)
	end
end

function widget:SelectionChanged()
	checkSelectionType[LOCAL_SEL] = true
end

function CleanSelections(typeToClear, newSelUnits)
	local changed = false
	for unitID, type in pairs(selUnits) do
		if type == typeToClear and newSelUnits[unitID] ~= type then
			changed = true
			RemoveSelected(unitID)
		end
	end
	return changed
end

function widget:Update(dt)
	local newHoverUnitID = GetUnitUnderCursor(false)
	local isSelectionBoxActive = IsSelectionBoxActive()
	checkSelectionType[HOVER_SEL] = checkSelectionType[HOVER_SEL] or newHoverUnitID ~= hoverUnitID or isSelectionBoxActive
	hoverUnitID = newHoverUnitID

	-- TODO: Add a callin for when ally selections change?
	local newAllySelUnits = WG.allySelUnits
	checkSelectionType[OTHER_SEL] = showOtherSelections and (checkSelectionType[HOVER_SEL] or newAllySelUnits ~= allySelUnits)
	allySelUnits = newAllySelUnits

	if not checkSelectionType[HOVER_SEL] and not checkSelectionType[LOCAL_SEL] and not checkSelectionType[OTHER_SEL] then
		return
	end

	local newSelUnits = {}
	-- Hover selections
	if checkSelectionType[HOVER_SEL] then
		for unitID, _ in pairs(FindPreselUnits()) do
			if selUnits[unitID] ~= HOVER_SEL then
				local alreadySelected = selUnits[unitID]
				AddSelected(unitID, 254, hoverSelectionVBO, not alreadySelected)
				selUnits[unitID] = HOVER_SEL
				checkSelectionType[LOCAL_SEL], checkSelectionType[OTHER_SEL] = true, true
			end
			newSelUnits[unitID] = HOVER_SEL
		end
		if CleanSelections(HOVER_SEL, newSelUnits) then
			checkSelectionType[LOCAL_SEL], checkSelectionType[OTHER_SEL] = true, true
		end
	elseif wasSelectionBoxActive then
		wasSelectionBoxActive = false
	end

	-- Local selections
	if checkSelectionType[LOCAL_SEL] then
		for _, unitID in pairs(spGetSelectedUnits()) do
			if not newSelUnits[unitID] and not selUnits[unitID] ~= LOCAL_SEL then
				AddSelected(unitID, 255, localSelectionVBO, false)
				selUnits[unitID] = LOCAL_SEL
				checkSelectionType[OTHER_SEL] = true
			end
			newSelUnits[unitID] = LOCAL_SEL
		end
		if CleanSelections(LOCAL_SEL, newSelUnits) then
			checkSelectionType[OTHER_SEL] = true
		end
	end

	-- Ally/other selections
	if checkSelectionType[OTHER_SEL] then
		for unitID, _ in pairs(allySelUnits or {}) do
			if not newSelUnits[unitID] and not selUnits[unitID] ~= OTHER_SEL  then
				AddSelected(unitID, spGetUnitTeam(unitID), otherSelectionVBO, false)
				selUnits[unitID] = OTHER_SEL
			end
			newSelUnits[unitID] = OTHER_SEL
		end
		CleanSelections(OTHER_SEL, newSelUnits)
	end

    -- Prime it to check again next time around, as we may have stopped selecting without making a selection
	checkSelectionType[HOVER_SEL] = isSelectionBoxActive
	checkSelectionType[LOCAL_SEL] = false
	checkSelectionType[OTHER_SEL] = false
end

function widget:UnitDestroyed()
	checkSelectionType[LOCAL_SEL] = true
end

function widget:UnitGiven()
	checkSelectionType[LOCAL_SEL] = true
end

function widget:UnitTaken()
	checkSelectionType[LOCAL_SEL] = true
end

function widget:VisibleUnitsChanged()
	-- Only called on start/stop of api_unit_tracker
	Init()
end

function widget:Initialize()
	if not gl.CreateShader or not Init() then
		widgetHandler:RemoveWidget()
		return
	end
	UpdateCmdColorsConfig(true)
end

function widget:Shutdown()
	UpdateCmdColorsConfig(false)
end
