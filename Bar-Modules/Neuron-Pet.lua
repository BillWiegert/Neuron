--Neuron Pet Action Bar, a World of Warcraft® user interface addon.


local NEURON = Neuron
local DB

NEURON.NeuronPetBar = NEURON:NewModule("PetBar", "AceEvent-3.0", "AceHook-3.0")
local NeuronPetBar = NEURON.NeuronPetBar

local petbarsDB, petbtnsDB


local PETBTN = setmetatable({}, { __index = CreateFrame("CheckButton") })

local L = LibStub("AceLocale-3.0"):GetLocale("Neuron")


local gDef = {
    hidestates = ":pet0:",
    scale = 1.2,
    snapTo = false,
    snapToFrame = false,
    snapToPoint = false,
    point = "BOTTOM",
    x = -440,
    y = 75,
}

local configData = {
    stored = false,
}

local keyData = {

    hotKeys = ":",
    hotKeyText = ":",
    hotKeyLock = false,
    hotKeyPri = false,
}

local petElements = {}
-----------------------------------------------------------------------------
-------------------------- INIT FUNCTIONS-------------------------------------
-----------------------------------------------------------------------------

--- **OnInitialize**, which is called directly after the addon is fully loaded.
--- do init tasks here, like loading the Saved Variables
--- or setting up slash commands.
function NeuronPetBar:OnInitialize()

    petElements[1] = PetActionButton1
    petElements[2] = PetActionButton2
    petElements[3] = PetActionButton3
    petElements[4] = PetActionButton4
    petElements[5] = PetActionButton5
    petElements[6] = PetActionButton6
    petElements[7] = PetActionButton7
    petElements[8] = PetActionButton8
    petElements[9] = PetActionButton9
    petElements[10] = PetActionButton10

    DB = NeuronCDB


    petbarsDB = DB.petbars
    petbtnsDB = DB.petbtns


    ----------------------------------------------------------------
    PETBTN.SetData = NeuronPetBar.SetData
    PETBTN.LoadData = NeuronPetBar.LoadData
    PETBTN.SaveData = NeuronPetBar.SaveData
    PETBTN.SetAux = NeuronPetBar.SetAux
    PETBTN.LoadAux = NeuronPetBar.LoadAux
    PETBTN.SetGrid = NeuronPetBar.SetGrid
    PETBTN.SetDefaults = NeuronPetBar.SetDefaults
    PETBTN.GetDefaults = NeuronPetBar.GetDefaults
    PETBTN.SetType = NeuronPetBar.SetType
    PETBTN.GetSkinned = NeuronPetBar.GetSkinned
    PETBTN.SetSkinned = NeuronPetBar.SetSkinned
    ----------------------------------------------------------------

    NEURON:RegisterBarClass("pet", "PetBar", L["Pet Bar"], "Pet Button", petbarsDB, petbarsDB, NeuronPetBar, petbtnsDB, "CheckButton", "NeuronActionButtonTemplate", { __index = PETBTN }, #petElements, gDef, nil, false)

    NEURON:RegisterGUIOptions("pet", { AUTOHIDE = true, SHOWGRID = true, SNAPTO = true, UPCLICKS = true, DOWNCLICKS = true, HIDDEN = true, LOCKBAR = true, TOOLTIPS = true, BINDTEXT = true, RANGEIND = true, CDTEXT = true, CDALPHA = true }, false, 65)


    NeuronPetBar:CreateBarsAndButtons()
end

--- **OnEnable** which gets called during the PLAYER_LOGIN event, when most of the data provided by the game is already present.
--- Do more initialization here, that really enables the use of your addon.
--- Register Events, Hook functions, Create Frames, Get information from
--- the game that wasn't available in OnInitialize
function NeuronPetBar:OnEnable()
end


--- **OnDisable**, which is only called when your addon is manually being disabled.
--- Unhook, Unregister Events, Hide frames that you created.
--- You would probably only use an OnDisable if you want to
--- build a "standby" mode, or be able to toggle modules on/off.
function NeuronPetBar:OnDisable()
end


------------------------------------------------------------------------------


-------------------------------------------------------------------------------
function NeuronPetBar:CreateBarsAndButtons()
    if (DB.petbarFirstRun) then

        local bar, object = NEURON.NeuronBar:CreateNewBar("pet", 1, true)

        for i = 1, #petElements do
            object = NEURON.NeuronButton:CreateNewObject("pet", i)
            NEURON.NeuronBar:AddObjectToList(bar, object)
        end

        DB.petbarFirstRun = false

    else

        for id, data in pairs(petbarsDB) do
            if (data ~= nil) then
                NEURON.NeuronBar:CreateNewBar("pet", id)
            end
        end

        for id, data in pairs(petbtnsDB) do
            if (data ~= nil) then
                NEURON.NeuronButton:CreateNewObject("pet", id)
            end
        end
    end
end




function NeuronPetBar:SetData(button, bar)
    if (bar) then

        button.bar = bar

        button.cdText = bar.cdata.cdText

        if (bar.cdata.cdAlpha) then
            button.cdAlpha = 0.2
        else
            button.cdAlpha = 1
        end

        button.barLock = bar.cdata.barLock
        button.barLockAlt = bar.cdata.barLockAlt
        button.barLockCtrl = bar.cdata.barLockCtrl
        button.barLockShift = bar.cdata.barLockShift

        button.upClicks = bar.cdata.upClicks
        button.downClicks = bar.cdata.downClicks

        button.bindText = bar.cdata.bindText

        button.tooltips = bar.cdata.tooltips
        button.tooltipsEnhanced = bar.cdata.tooltipsEnhanced
        button.tooltipsCombat = bar.cdata.tooltipsCombat

        button:SetFrameStrata(bar.gdata.objectStrata)

        button:SetScale(bar.gdata.scale)

    end

    local down, up = "", ""

    if (button.upClicks) then up = up.."AnyUp" end
    if (button.downClicks) then down = down.."AnyDown" end

    button:RegisterForClicks(down, up)
    button:RegisterForDrag("LeftButton", "RightButton")

    button.cdcolor1 = { 1, 0.82, 0, 1 }
    button.cdcolor2 = { 1, 0.1, 0.1, 1 }
    button.auracolor1 = { 0, 0.82, 0, 1 }
    button.auracolor2 = { 1, 0.1, 0.1, 1 }
    button.buffcolor = { 0, 0.8, 0, 1 }
    button.debuffcolor = { 0.8, 0, 0, 1 }
    button.manacolor = { 0.5, 0.5, 1.0 }
    button.rangecolor = { 0.7, 0.15, 0.15, 1 }

    button:SetFrameLevel(4)
    button.iconframe:SetFrameLevel(2)
    button.iconframecooldown:SetFrameLevel(3)
    button.iconframeaurawatch:SetFrameLevel(3)
    button.iconframeicon:SetTexCoord(0.05,0.95,0.05,0.95)

end

function NeuronPetBar:SaveData(button)

    -- empty
end

function NeuronPetBar:LoadData(button, spec, state)

    local id = button.id

    button.DB = petbtnsDB

    if (button.DB and button.DB) then

        if (not button.DB[id]) then
            button.DB[id] = {}
        end

        if (not button.DB[id].config) then
            button.DB[id].config = CopyTable(configData)
        end

        if (not button.DB[id].keys) then
            button.DB[id].keys = CopyTable(keyData)
        end

        if (not button.DB[id]) then
            button.DB[id] = {}
        end

        if (not button.DB[id].keys) then
            button.DB[id].keys = CopyTable(keyData)
        end

        if (not button.DB[id].data) then
            button.DB[id].data = {}
        end

        NEURON:UpdateData(button.DB[id].config, configData)
        NEURON:UpdateData(button.DB[id].keys, keyData)

        button.config = button.DB [id].config

        if (DB.perCharBinds) then
            button.keys = button.DB[id].keys
        else
            button.keys = button.DB[id].keys
        end

        button.data = button.DB[id].data
    end
end

function NeuronPetBar:SetGrid(button, show, hide)
    if (true) then return end

    if (not InCombatLockdown()) then

        button:SetAttribute("isshown", button.showGrid)
        button:SetAttribute("showgrid", button)

        if (button or button.showGrid) then
            button:Show()
        elseif (not (button:IsMouseOver() and button:IsVisible()) and not HasPetAction(button.actionID)) then
            button:Hide()
        end
    end
end

function NeuronPetBar:SetAux(button)

end

function NeuronPetBar:LoadAux(button)

    NEURON.NeuronBinder:CreateBindFrame(button, button.objTIndex)

end

function NeuronPetBar:SetDefaults(button)

    -- empty
end

function NeuronPetBar:GetDefaults(button)

    --empty
end

function NeuronPetBar:SetSkinned(button)


end

function NeuronPetBar:GetSkinned(button)


end

function NeuronPetBar:SetType(button, save)

    if (petElements[button.id]) then

        button:SetWidth(petElements[button.id]:GetWidth()+8)
        button:SetHeight(petElements[button.id]:GetHeight()+8)
        button:SetHitRectInsets(button:GetWidth()/2, button:GetWidth()/2, button:GetHeight()/2, button:GetHeight()/2)

        button.element = petElements[button.id]

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
end
