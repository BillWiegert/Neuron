--Neuron , a World of Warcraft® user interface addon.


local NEURON = Neuron
local CDB

NEURON.NeuronExtraBar = NEURON:NewModule("ExtraBar", "AceEvent-3.0", "AceHook-3.0")
local NeuronExtraBar = NEURON.NeuronExtraBar


local XBTN = setmetatable({}, { __index = CreateFrame("CheckButton") })

local xbarsCDB
local xbtnsCDB

local L = LibStub("AceLocale-3.0"):GetLocale("Neuron")

local gDef = {
	hidestates = ":extrabar0:",
	snapTo = false,
	snapToFrame = false,
	snapToPoint = false,
	point = "BOTTOM",
	x = 0,
	y = 205,
}

local configData = {
	stored = false,
}


-----------------------------------------------------------------------------
--------------------------INIT FUNCTIONS-------------------------------------
-----------------------------------------------------------------------------

--- **OnInitialize**, which is called directly after the addon is fully loaded.
--- do init tasks here, like loading the Saved Variables
--- or setting up slash commands.
function NeuronExtraBar:OnInitialize()

	CDB = NeuronCDB

	xbarsCDB = CDB.xbars
	xbtnsCDB = CDB.xbtns

	----------------------------------------------------------------
	XBTN.SetData = NeuronExtraBar.SetData
	XBTN.LoadData = NeuronExtraBar.LoadData
	XBTN.SaveData = NeuronExtraBar.SaveData
	XBTN.SetAux = NeuronExtraBar.SetAux
	XBTN.LoadAux = NeuronExtraBar.LoadAux
	XBTN.SetObjectVisibility = NeuronExtraBar.SetObjectVisibility
	XBTN.SetDefaults = NeuronExtraBar.SetDefaults
	XBTN.GetDefaults = NeuronExtraBar.GetDefaults
	XBTN.SetType = NeuronExtraBar.SetType
	XBTN.GetSkinned = NeuronExtraBar.GetSkinned
	XBTN.SetSkinned = NeuronExtraBar.SetSkinned
	----------------------------------------------------------------

	NEURON:RegisterBarClass("extrabar", "ExtraActionBar", L["Extra Action Bar"], "Extra Action Button", xbarsCDB, xbarsCDB, NeuronExtraBar, xbtnsCDB, "CheckButton", "NeuronActionButtonTemplate", { __index = XBTN }, 1, gDef, nil, false)

	NEURON:RegisterGUIOptions("extrabar", { AUTOHIDE = true,
		SHOWGRID = false,
		SNAPTO = true,
		UPCLICKS = true,
		DOWNCLICKS = true,
		HIDDEN = true,
		LOCKBAR = true,
		TOOLTIPS = true,
		BINDTEXT = false,
		RANGEIND = false,
		CDTEXT = false,
		CDALPHA = false }, false, false)


	NeuronExtraBar:DisableDefault()
	NeuronExtraBar:CreateBarsAndButtons()


end

--- **OnEnable** which gets called during the PLAYER_LOGIN event, when most of the data provided by the game is already present.
--- Do more initialization here, that really enables the use of your addon.
--- Register Events, Hook functions, Create Frames, Get information from
--- the game that wasn't available in OnInitialize
function NeuronExtraBar:OnEnable()

end


--- **OnDisable**, which is only called when your addon is manually being disabled.
--- Unhook, Unregister Events, Hide frames that you created.
--- You would probably only use an OnDisable if you want to
--- build a "standby" mode, or be able to toggle modules on/off.
function NeuronExtraBar:OnDisable()

end


------------------------------------------------------------------------------


-------------------------------------------------------------------------------

function NeuronExtraBar:CreateBarsAndButtons()
	if (CDB.xbarFirstRun) then

		local bar = NEURON.NeuronBar:CreateNewBar("extrabar", 1, true)
		local object = NEURON.NeuronButton:CreateNewObject("extrabar", 1)

		NEURON.NeuronBar:AddObjectToList(bar, object)

		CDB.xbarFirstRun = false

	else

		for id,data in pairs(xbarsCDB) do
			if (data ~= nil) then
				NEURON.NeuronBar:CreateNewBar("extrabar", id)
			end
		end

		for id,data in pairs(xbtnsCDB) do
			if (data ~= nil) then
				NEURON.NeuronButton:CreateNewObject("extrabar", id)
			end
		end
	end
end

function NeuronExtraBar:DisableDefault()

	local disableExtraButton = false

	for i,v in ipairs(NEURON.NeuronExtraBar) do

		if (v["bar"]) then --only disable if a specific button has an associated bar
			disableExtraButton = true
		end
	end


	if disableExtraButton then
		------Hiding the default blizzard
		MainMenuBarVehicleLeaveButton:Hide()
		MainMenuBarVehicleLeaveButton:SetPoint("BOTTOM", 0, -200)
	end

end


function NeuronExtraBar:GetSkinned(button)

end

function NeuronExtraBar:SetSkinned(button)

end

function NeuronExtraBar:SaveData(button)

	-- empty

end

function NeuronExtraBar:LoadData(button, spec, state)

	local id = button.id

	button.DB = xbtnsCDB

	if (button.DB) then

		if (not button.DB[id]) then
			button.DB[id] = {}
		end

		if (not button.DB[id].config) then
			button.DB[id].config = CopyTable(configData)
		end

		if (not button.DB[id]) then
			button.DB[id] = {}
		end

		if (not button.DB[id].data) then
			button.DB[id].data = {}
		end

		button.config = button.DB[id].config

		button.data = button.DB[id].data
	end
end

function NeuronExtraBar:SetObjectVisibility(button, show)

end

function NeuronExtraBar:SetAux(button)


end


function NeuronExtraBar:LoadAux(button)

end

function NeuronExtraBar:SetDefaults(button)

	-- empty

end

function NeuronExtraBar:GetDefaults(button)

	--empty

end

function NeuronExtraBar:SetData(button, bar)
	if (bar) then

		button.bar = bar

		button:SetFrameStrata(bar.gdata.objectStrata)
		button:SetScale(bar.gdata.scale)

	end

	button:SetFrameLevel(4)
end

function NeuronExtraBar:SetType(button, save)

	button:SetWidth(ExtraActionButton1:GetWidth()+3)
	button:SetHeight(ExtraActionButton1:GetHeight()+3)


	button:SetHitRectInsets(button:GetWidth()/2, button:GetWidth()/2, button:GetHeight()/2, button:GetHeight()/2)

	button.element = ExtraActionButton1

	local objects = NEURON:GetParentKeys(button.element)

	for k,v in pairs(objects) do
		local name = v:gsub(button.element:GetName(), "")
		button[name:lower()] = _G[v]
	end

	button.element:ClearAllPoints()
	button.element:SetParent(button)
	button.element:Show()
	button.element:SetPoint("CENTER", button, "CENTER")
	button.element:SetScale(1)


end


-------------------------------------------------------------------
-------------------------------------------------------------------



function NeuronExtraBar:VehicleLeave_OnEvent(button, event, ...)
	if (event == "UPDATE_EXTRA_ACTIONBAR") then
		button:Hide()
	end

	if (ActionBarController_GetCurrentActionBarState) then
		if (CanExitVehicle() and ActionBarController_GetCurrentActionBarState() == 1) then
			button:Show()
			button:Enable();
			if UnitOnTaxi("player") then
				button.iconframeicon:SetTexture(NEURON.SpecialActions.taxi)
			else
				button.iconframeicon:SetTexture(NEURON.SpecialActions.vehicle)
			end
		else
			button:Hide()
		end
	end
end



function NeuronExtraBar:VehicleLeave_OnEnter(button)
	if ( UnitOnTaxi("player") ) then

		GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
		GameTooltip:ClearLines()
		GameTooltip:SetText(TAXI_CANCEL, 1, 1, 1);
		GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
		GameTooltip:Show();
	end
end

function NeuronExtraBar:VehicleLeave_OnClick(button)
	if ( UnitOnTaxi("player") ) then
		TaxiRequestEarlyLanding();

		-- Show that the request for landing has been received.
		button:Disable();
		button:SetHighlightTexture([[Interface\Buttons\CheckButtonHilight]], "ADD");
		button:LockHighlight();
	else
		VehicleExit();
	end
end


function NeuronExtraBar:CreateVehicleLeave(button, index)
	button.vlbtn = CreateFrame("Button", button:GetName().."VLeave", UIParent, "NeuronNonSecureButtonTemplate")

	button.vlbtn:SetAllPoints(button)

	button.vlbtn:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	button.vlbtn:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
	button.vlbtn:RegisterEvent("UPDATE_POSSESS_BAR");
	button.vlbtn:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR");
	button.vlbtn:RegisterEvent("UPDATE_EXTRA_ACTIONBAR");
	button.vlbtn:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
	button.vlbtn:RegisterEvent("UNIT_ENTERED_VEHICLE")
	button.vlbtn:RegisterEvent("UNIT_EXITED_VEHICLE")
	button.vlbtn:RegisterEvent("VEHICLE_UPDATE")

	button.vlbtn:SetScript("OnEvent", function(self, event, ...) NeuronExtraBar:VehicleLeave_OnEvent(self, event, ...) end)
	button.vlbtn:SetScript("OnClick", function(self) NeuronExtraBar:VehicleLeave_OnClick(self) end)
	button.vlbtn:SetScript("OnEnter", function(self) NeuronExtraBar:VehicleLeave_OnEnter(self) end)
	button.vlbtn:SetScript("OnLeave", GameTooltip_Hide)

	local objects = NEURON:GetParentKeys(button.vlbtn)

	for k,v in pairs(objects) do
		local name = (v):gsub(button.vlbtn:GetName(), "")
		button.vlbtn[name:lower()] = _G[v]
	end

	button.vlbtn.iconframeicon:SetTexture(NEURON.SpecialActions.vehicle)

	button.vlbtn:SetFrameLevel(4)
	button.vlbtn.iconframe:SetFrameLevel(2)
	button.vlbtn.iconframecooldown:SetFrameLevel(3)

	button.vlbtn:Hide()
end