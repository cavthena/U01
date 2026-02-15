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
local OpStrings = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single_Strings.lua')

local AIBuffs = import('/maps/faf_coop_U01.v0001/Ruan_AIBuff.lua')

--Mission Tracking
ScenarioInfo.MissionNumber = 0
ScenarioInfo.Coop = false
ScenarioInfo.AssignedObjectives = {}
local Difficulty = ScenarioInfo.Options.Difficulty

--Debug
local Debug = true
local DbgFog = true
local DbgSpeed = true
local NoComs = false
local SkipNIS = false

local NIS1InitialDelay = 0

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
        ScenarioFramework.CreateTimerTrigger(OpenCinematic, NIS1InitialDelay)
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

function OpenCinematic()
    local intelMarker = {}

    Cinematics.EnterNISMode()
    Cinematics.CameraSetZoom(0, 0)

    local function ValleyPan()
        Cinematics.CameraSetZoom(144, 0)
        Cinematics.CameraMoveToMarker('CS_01', 0)

        if ScenarioInfo.Coop then
            intelMarker[1] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_01', 0, ArmyBrains[ScenarioInfo.Player1])
            intelMarker[2] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_02', 0, ArmyBrains[ScenarioInfo.Player1])
            intelMarker[3] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_01', 0, ArmyBrains[ScenarioInfo.Player2])
            intelMarker[4] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_02', 0, ArmyBrains[ScenarioInfo.Player2])
        else
            intelMarker[1] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_01', 0, ArmyBrains[ScenarioInfo.Player1])
            intelMarker[2] = ScenarioFramework.CreateVisibleAreaLocation(48, 'Reveal_02', 0, ArmyBrains[ScenarioInfo.Player1])
        end

        ScenarioFramework.Dialogue(OpStrings.Cinema2, MissionHandOff, true, nil)
        Cinematics.CameraMoveToMarker('CS_02', 15)
    end

    ScenarioFramework.Dialogue(OpStrings.Cinema1, ValleyPan, true, nil)
end

function MissionHandOff()
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
