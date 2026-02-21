-----------------------
--UEF Mission 1 of 10--
--Created by Cavthena--
-----------------------

--Timetable Imports
local MODEEASY = import('/maps/faf_coop_U01.v0001/SingleMode/U01_SingleEasy.lua')
local MODEMED = import('/maps/faf_coop_U01.v0001/SingleMode/U01_SingleMed.lua')
local MODEHARD = import('/maps/faf_coop_U01.v0001/SingleMode/U01_SingleHard.lua')
--local COOPMODE = import('/maps/faf_coop_U01.v0001/CoopMode/U01_Coop.lua')

--General Imports
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Utilities = import('/lua/utilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ExtraFunc = import('/maps/faf_coop_U01.v0001/faf_coop_U01_ExtraFunc.lua')
local Cinematics = import('/lua/cinematics.lua')
local OpStrings = import('/maps/faf_coop_U01.v0001/U01_Strings.lua')

local AIBuffs = import('/maps/faf_coop_U01.v0001/Ruan_AIBuff.lua')

--Mission Tracking
ScenarioInfo.MissionNumber = 0
ScenarioInfo.Coop = false
ScenarioInfo.AssignedObjectives = {}
local Difficulty = ScenarioInfo.Options.Difficulty

--Debug
local Debug = true
local DbgFog = false
local DbgSpeed = false
local NoComs = false
local SkipNIS = false

local NIS1InitialDelay = 3
local intelMarker = {}

--------------------------------------------------
--Main Thread: Timetable--------------------------
-------------------------------------------------
function OnPopulate(scenario)
    --Debug Warnings
    if Debug then
        WARN('Debug Mode On. Debug Buff enabled.')
        if DbgFog then
            Utilities.UserConRequest('SallyShears')
        end
    end
    if NoComs then
        WARN('Dialogue has been disabled. Event timing may be off')
    end
    if SkipNIS then
        WARN('Cutscenes have been disabled. Event timing may be off')
    end

    --Set colors, setup armies and set coop.
    ScenarioUtils.InitializeScenarioArmies()
    local tblArmy = ListArmies()
    for i, name in ipairs(tblArmy) do
        ScenarioInfo[name] = i
        if Debug then
            LOG(string.format('Assigned ScenarioInfo.%s = %d', name, i))
        end
    end
    
    local colors = {
        ['Player1'] = {41, 41, 225},
        ['Player2'] = {41, 40, 140},
        ['UEFOutpost'] = {16, 16, 86},
        ['Cybran'] = {128, 39, 37},
    }
    for name, color in pairs(colors) do
        if tblArmy[ScenarioInfo[name]] then
            ScenarioFramework.SetArmyColor(ScenarioInfo[name], unpack(color))
        end
    end
    
    if ScenarioInfo.Player2 then
        ScenarioInfo.Coop = true
        LOG('Coop is enabled')
    else
        LOG('Coop is not enabled')
    end

    -- Hide all scores
    for i = 1, table.getn(ArmyBrains) do
        SetArmyShowScore(i, false)
    end
    if Debug then
        LOG('All scores have been hidden.')
    end

    -- Setup resources
    GetArmyBrain(ScenarioInfo.UEFOutpost):SetResourceSharing(false)
    if Debug then
        LOG('UEFOutpost no longer sharing resources.')
    end
    GetArmyBrain(ScenarioInfo.Cybran):GiveStorage('MASS', 2000)
    GetArmyBrain(ScenarioInfo.Cybran):GiveStorage('ENERGY', 40000)
    SetArmyEconomy(ScenarioInfo.Cybran, 2000, 40000)

    --AI Unit Cap
    SetArmyUnitCap(ScenarioInfo.Cybran, 1000)
    if Debug then
        LOG('Cybran army cap set to 1000.')
    end
end

function OnStart(scenario)
    --Set Debug quick build and resources.
    if DbgSpeed then
        ForkThread(AIBuffs.EnableIncomeBuffForArmy, ScenarioInfo.Player1)
    end

    ForkThread(AIBuffs.EnableAIBuff, ScenarioInfo.Cybran)
    ForkThread(AIBuffs.FuelAIBuff, ScenarioInfo.Cybran)

    ScenarioFramework.AddRestrictionForAllHumans(categories.UEF)
    ScenarioFramework.AddRestrictionForAllHumans(categories.CYBRAN)
    ScenarioFramework.RestrictEnhancements({
        'AdvancedEngineering',
        'T3Engineering',
        'DamageStabilization',
        'HeavyAntiMatterCannon',
        'LeftPod',
        'RightPod',
        'Shield',
        'ShieldGeneratorField',
        'TacticalMissile',
        'TacticalNukeMissile',
        'ResourceAllocation',
        'Teleporter'
    })

    if not SkipNIS then
        ScenarioFramework.CreateTimerTrigger(OpenCinematicStep1, 1)
    else
        if ScenarioInfo.Coop then
            --COOPMODE.CoopModeCatch(Debug, NoComs, SkipNIS)
        else
            if Difficulty == 1 then
                MODEEASY.EasyModeCatch(Debug, NoComs, SkipNIS)
            elseif Difficulty == 2 then
                MODEMED.MediumModeCatch(Debug, NoComs, SkipNIS)
            else
                MODEHARD.HardModeCatch(Debug, NoComs, SkipNIS)
            end
        end
    end
end

function OpenCinematicStep1()
    Cinematics.EnterNISMode()

    local function ValleyPan()
        intelMarker[1] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_01', 0, ArmyBrains[ScenarioInfo.Player1])
        intelMarker[2] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_02', 0, ArmyBrains[ScenarioInfo.Player1])
        if ScenarioInfo.Coop then
            intelMarker[3] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_01', 0, ArmyBrains[ScenarioInfo.Player2])
            intelMarker[4] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_02', 0, ArmyBrains[ScenarioInfo.Player2])
        end

        ScenarioFramework.Dialogue(OpStrings.Cinema2, OpenCinematicStep2, true, nil)
        Cinematics.CameraSetZoom(100, 0)
        Cinematics.CameraMoveToMarker('CS_02', 10)
    end

    Cinematics.CameraMoveToMarker('CS_01', 0)
    Cinematics.CameraSetZoom(1, 0)

    ScenarioFramework.CreateTimerTrigger(function()
        ScenarioFramework.Dialogue(OpStrings.Cinema1, ValleyPan, true, nil)
    end, NIS1InitialDelay)
    Cinematics.CameraSetZoom(100, 15)
end

function OpenCinematicStep2()
    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Objectives')
    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Def_D'.. Difficulty)
    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Main')

    intelMarker[5] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_03', 0, ArmyBrains[ScenarioInfo.Player1])
    if ScenarioInfo.Coop then
        intelMarker[6] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_03', 0, ArmyBrains[ScenarioInfo.Player2])
    end

    ScenarioFramework.Dialogue(OpStrings.Cinema3, OpenCinematicStep3, true, nil)
    Cinematics.CameraMoveToMarker('CS_03', 5)
    Cinematics.CameraSpinAndZoom(0.02, 0, 0)
end

function OpenCinematicStep3()
    local pos = ScenarioUtils.MarkerToPosition('CS_MoveOrder')
    local units = ScenarioUtils.CreateArmyGroup('Cybran', 'CS_PlatoonMoving')
    IssueFormMove(units, pos, 'AttackFormation', 1)

    intelMarker[7] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_04', 0, ArmyBrains[ScenarioInfo.Player1])
    intelMarker[8] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_05', 0, ArmyBrains[ScenarioInfo.Player1])
    if ScenarioInfo.Coop then
        intelMarker[9] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_04', 0, ArmyBrains[ScenarioInfo.Player2])
        intelMarker[10] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_05', 0, ArmyBrains[ScenarioInfo.Player2])
    end

    Cinematics.CameraMoveToMarker('CS_04', 3)
    Cinematics.CameraTrackEntities(units,  40, 0)

    ScenarioFramework.Dialogue(OpStrings.Cinema4, MissionHandOff, true, nil)
end

function MissionHandOff()
    local function Handoff()
        Cinematics.ExitNISMode()

        if ScenarioInfo.Coop then
            --COOPMODE.CoopModeCatch(Debug, NoComs, SkipNIS)
        else
            if Difficulty == 1 then
                MODEEASY.EasyModeCatch(Debug, NoComs, SkipNIS)
            elseif Difficulty == 2 then
                MODEMED.MediumModeCatch(Debug, NoComs, SkipNIS)
            else
                MODEHARD.HardModeCatch(Debug, NoComs, SkipNIS)
            end
        end
    end

    ScenarioFramework.Dialogue(OpStrings.Cinema5, Handoff, true, nil)
    Cinematics.CameraMoveToMarker('CS_02', 5)

    --Cinematics.CameraReset()
    for i, m in ipairs(intelMarker) do
        if m and not m.Dead then
            local pos = m:GetPosition()
            m:Destroy()
            ScenarioFramework.ClearIntel(pos, 48)
            intelMarker[i] = nil
        end
    end

    local brain = ArmyBrains[ScenarioInfo.Cybran]
    local units = brain:GetListOfUnits(categories.ALLUNITS, false, false) or {}
    for _, u in pairs(units) do
        if u and not u.Dead then
            u:Destroy()
        end
    end
    
    brain = ArmyBrains[ScenarioInfo.UEFOutpost]
    units = brain:GetListOfUnits(categories.ALLUNITS, false, false) or {}
    for _, u in pairs(units) do
        if u and not u.Dead then
            u:Destroy()
        end
    end
end

