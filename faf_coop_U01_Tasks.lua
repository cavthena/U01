-- ========================================OBJECTIVES====================================
-- Objectives created for faf_coop_U01.v0001
-- Created by Ruanuku/Cavthena

local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Objectives = import('/lua/ScenarioFramework.lua').Objectives
local OpStrings = import('/maps/faf_coop_U01.v0001/faf_coop_U01_Strings.lua')
local ExtraFunc = import('/maps/faf_coop_U01.v0001/faf_coop_U01_ExtraFunc.lua')

local Difficulty = ScenarioInfo.Options.Difficulty

-- =======================================Primary Objectives==============================
-- Objective 1, Build a basic base of Mass Extractors, Power Gens and Factories.
function Objective_1(DbgCoop)
    ScenarioInfo.Ob1 = Objectives.ArmyStatCompare(
        'primary', 'incomplete',
        OpStrings.Ob1_Title, OpStrings.Ob1_Desc,
        'build',
        {
            Armies = {'Player1'},
            StatName = 'Units_Active',
            CompareOp = '>=',
            Value = 2,
            Category = categories.ueb1103, --T1 Mex
            ShowProgress = true,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob1)

    ScenarioInfo.Ob1a = Objectives.ArmyStatCompare(
        'primary', 'incomplete',
        OpStrings.Ob1a_Title, OpStrings.Ob1a_Desc,
        'build',
        {
            Armies = {'Player1'},
            StatName = 'Units_Active',
            CompareOp = '>=',
            Value = 4,
            Category = categories.ueb1101, --T1 PGens
            ShowProgress = true,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob1a)

    ScenarioInfo.Ob1b = Objectives.ArmyStatCompare(
        'primary', 'incomplete',
        OpStrings.Ob1b_Title, OpStrings.Ob1b_Desc,
        'build',
        {
            Armies = {'Player1'},
            StatName = 'Units_Active',
            CompareOp = '>=',
            Value = 1,
            Category = categories.ueb0101, --T1 Land Factory
            ShowProgress = true,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob1b)

    --Player2 Objective if Coop
    if ScenarioInfo.Coop then
        local Player = 'Player2'
        if DbgCoop then Player = 'Player1' end

        ScenarioInfo.Ob1P2 = Objectives.ArmyStatCompare(
            'primary', 'incomplete',
            OpStrings.Ob1_Title, OpStrings.Ob1_Desc,
            'build',
            {
                Armies = {Player},
                StatName = 'Units_Active',
                CompareOp = '>=',
                Value = 2,
                Category = categories.ueb1103, --T1 Mex
                ShowProgress = true,
            }
        )
        table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob1P2)

        ScenarioInfo.Ob1aP2 = Objectives.ArmyStatCompare(
            'primary', 'incomplete',
            OpStrings.Ob1a_Title, OpStrings.Ob1a_Desc,
            'build',
            {
                Armies = {Player},
                StatName = 'Units_Active',
                CompareOp = '>=',
                Value = 4,
                Category = categories.ueb1101, --T1 PGen
                ShowProgress = true,
            }
        )
        table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob1aP2)

        ScenarioInfo.Ob1bP2 = Objectives.ArmyStatCompare(
            'primary', 'incomplete',
            OpStrings.Ob1b_Title, OpStrings.Ob1b_Desc,
            'build',
            {
                Armies = {Player},
                StatName = 'Units_Active',
                CompareOp = '>=',
                Value = 1,
                Category = categories.ueb0101, --T1 Land Factory
                ShowProgress = true,
            }
        )
        table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob1bP2)
    end
end

-- Objective 2, Build 15 LAB and prepare for Cybran raids. 
function Objective_2(DbgCoop)
    if Difficulty == 1 then
        ScenarioInfo.Ob2 = Objectives.ArmyStatCompare(
            'primary', 'incomplete',
            OpStrings.Ob2_Title, OpStrings.Ob2_Desc,
            'build',
            {
                Armies = {'Player1'},
                StatName = 'Units_Active',
                CompareOp = '>=',
                Value = 15,
                Category = categories.uel0106, --T1 Light Attack Bot'
                ShowProgress = false,
                Hidden = true,
            }
        )
        table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob2)

        if ScenarioInfo.Coop then
            local Player = 'Player2'
            if DbgCoop then Player = 'Player1' end

            ScenarioInfo.Ob2P2 = Objectives.ArmyStatCompare(
                'primary', 'incomplete',
                OpStrings.Ob2_Title, OpStrings.Ob2_Desc,
                'build',
                {
                    Armies = {Player},
                    StatName = 'Units_Active',
                    CompareOp = '>=',
                    Value = 15,
                    Category = categories.uel0106, --T1 Light Attack Bot'
                    ShowProgress = false,
                    Hidden = true,
                }
            )
            table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob2P2)
        end
    else
        local time = 150
        if Difficulty == 3 then time = 40 end

        ScenarioInfo.Ob2 = Objectives.Timer(
            'primary', 'incomplete',
            OpStrings.Ob2_TitleAlt, OpStrings.Ob2_DescAlt,
            {
                Timer = time,
                ExpireResult = 'complete',
                ShowProgress = false,
            }
        )
        table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob2)
    end
end

-- Objective 2a, Survive.
function Objective_2a()
    ScenarioInfo.Ob2a = Objectives.Basic(
        'primary', 'incomplete',
        OpStrings.Ob2a_Title, OpStrings.Ob2a_Desc,
        'protect',
        {
            --Nil
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob2a)
end

-- Objective 2b, destroy the Cybran attack weve, completely.
function Objective_2b(platoon, platoon2)
    local waveUnits = {}
    if platoon and platoon.GetPlatoonUnits then
        for _, u in platoon:GetPlatoonUnits() do table.insert(waveUnits, u) end
    end
    if ScenarioInfo.Coop and platoon2 and platoon2.GetPlatoonUnits then
        for _, u in platoon2:GetPlatoonUnits() do
            table.insert(waveUnits, u)
        end
    end

    ScenarioInfo.Ob2b = Objectives.Kill(
        'primary', 'incomplete',
        OpStrings.Ob2b_Title, OpStrings.Ob2b_Desc,
        {
            Armies = {'HumanPlayers'},
            Units = waveUnits,
            ShowProgress = true,
            MarkUnits = false,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob2b)
end

-- Objective 3, destroy the Cybran Outpost and secure the location.
function Objective_3()
    --Create destroy bases objective.
    local Ob3_targetCategories = categories.FACTORY + categories.MASSEXTRACTION + categories.ENERGYPRODUCTION --Target Categories for destroy Cybran Base Objective
    local targetUnits = ArmyBrains[ScenarioInfo.Cybran]:GetUnitsAroundPoint(
        Ob3_targetCategories, ScenarioUtils.MarkerToPosition('Cybran_Outpost_Zone'),
        40, 'ALLY'
    )

    ScenarioInfo.Ob3 = Objectives.KillOrCapture(
        'primary', 'incomplete',
        OpStrings.Ob3_Title, OpStrings.Ob3_Desc,
        {
            Armies = {'HumanPlayers'},
            Units = targetUnits,
            ShowProgress = true,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob3)
end

-- Objective 4, capture the Comms Relay
function Objective_4(target)
    ScenarioInfo.Ob4 = Objectives.Capture(
        'primary', 'incomplete',
        OpStrings.Ob4_Title, OpStrings.Ob4_Desc,
        {
            Armies = {'HumanPlayers'},
            Units = {target},
            NumRequired = 1,
            MarkUnits = true,
            ShowProgress = false,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob4)
end

-- Objective 4a, Protect the Comms Relay
function Objective_4a(target)
    ScenarioInfo.Ob4a = Objectives.Protect(
        'primary', 'incomplete',
        OpStrings.Ob4a_Title, OpStrings.Ob4a_Desc,
        {
            Armies = {'HumanPlayers'},
            Units = {target},
            MarkUnits = true,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob4a)
end

-- Objective 4b, Hold for 5 minutes.
function Objective_4b()
    ScenarioInfo.Ob4b = Objectives.Timer(
        'primary', 'incomplete',
        OpStrings.Ob4b_Title, OpStrings.Ob4b_Desc,
        {
            Timer = 300,
            ExpireResult = 'complete',
            ShowProgress = true,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob4b)
end

function Objective_5()
    local areaRect = ExtraFunc.RectFromTwoMarkers('LandPN62', 'LandPN61')

    ScenarioInfo.Ob5 = Objectives.CategoriesInArea(
        'primary', 'incomplete',
        OpStrings.Ob5_Title, OpStrings.Ob5_Desc,
        'kill',
        {
            MarkArea = false,
            MarkUnits = true,
            Requirements = {
                {
                    Area = areaRect,
                    Category = categories.FACTORY,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
                {
                    Area = areaRect,
                    Category = categories.STRUCTURE * categories.ENERGYPRODUCTION,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
                {
                    Area = areaRect,
                    Category = categories.MASSEXTRACTION,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
                {
                    Area = areaRect,
                    Category = categories.url0301,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
            },
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob5)
end

local function Objective_5Sec1()
    local areaRect = ExtraFunc.RectFromTwoMarkers('', '')

    ScenarioInfo.Ob5Sec1 = Objectives.CategoriesInArea(
        'secondary', 'incomplete',
        OpStrings.Ob5Sec1_Title, OpStrings.Ob5Sec1_Desc,
        'kill',
        {
            MarkArea = false,
            MarkUnits = true,
            Requirements = {
                {
                    Area = areaRect,
                    Category = categories.FACTORY,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
            },
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob5Sec1)
end

local function Objective_5Sec1()
end