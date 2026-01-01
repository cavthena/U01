-----------------------
--UEF Mission 1 of 10--
--Created by Cavthena--
-----------------------

--Timetable Imports
local SINGLEMODE = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single.lua')
--local COOPMODE = import('/maps/faf_coop_U01.v0001/CoopMode/U01_Coop.lua')

--General Imports
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Utilities = import('/lua/utilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local AIBuffs = import('/maps/faf_coop_U01.v0001/Ruan_AIBuff.lua')

dofile('/maps/faf_coop_U01.v0001/units/uec9901_unit.bp')

--Mission Tracking
ScenarioInfo.MissionNumber = 0
ScenarioInfo.Coop = false
ScenarioInfo.AssignedObjectives = {}
local Difficulty = ScenarioInfo.Options.Difficulty

--Debug
local Debug = true
local DbgSpeed = true
local NoComs = true
local SkipNIS = true

local NIS1InitialDelay = 3

--------------------------------------------------
--Main Thread: Timetable--------------------------
-------------------------------------------------
function OnPopulate(scenario)
    --Debug Warnings
    if Debug then
        WARN('Debug Mode On. Debug Buff enabled.')
        Utilities.UserConRequest('SallyShears')
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

    if ScenarioInfo.Coop then
        --COOPMODE.CoopModeCatch(Debug, NoComs, SkipNIS)
    else
        SINGLEMODE.SingleModeCatch(Debug, NoComs, SkipNIS)
    end
end
