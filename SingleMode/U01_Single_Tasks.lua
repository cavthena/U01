-- ========================================OBJECTIVES====================================
-- Objectives created for faf_coop_U01.v0001
-- Created by Cavthena

local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Objectives = import('/lua/ScenarioFramework.lua').Objectives
local OpStrings = import('/maps/faf_coop_U01.v0001/U01_Strings.lua')
local ExtraFunc = import('/maps/faf_coop_U01.v0001/faf_coop_U01_ExtraFunc.lua')

local Difficulty = ScenarioInfo.Options.Difficulty

-- =======================================Primary Objectives==============================
-- Objective 1, Build a basic base of Mass Extractors, Power Gens and Factories.
function Objective_1()
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
end

-- Objective 2, Build 10 LAB and prepare for Cybran raids. 
function Objective_2()
    if Difficulty == 1 then
        ScenarioInfo.Ob2 = Objectives.ArmyStatCompare(
            'primary', 'incomplete',
            OpStrings.Ob2_Title, OpStrings.Ob2_Desc,
            'build',
            {
                Armies = {'Player1'},
                StatName = 'Units_Active',
                CompareOp = '>=',
                Value = 10,
                Category = categories.uel0106, --T1 Light Attack Bot'
                ShowProgress = true,
            }
        )
        table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob2)
    else
        local time = 150
        if Difficulty == 3 then time = 50 end

        ScenarioInfo.Ob2 = Objectives.Timer(
            'primary', 'incomplete',
            OpStrings.Ob2_TitleAlt, OpStrings.Ob2_DescAlt,
            {
                Timer = time,
                ExpireResult = 'complete',
                ShowProgress = true,
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
function Objective_2b(platoon)
    local waveUnits = {}
    if platoon and platoon.GetPlatoonUnits then
        for _, u in platoon:GetPlatoonUnits() do table.insert(waveUnits, u) end
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
    local areaName = ExtraFunc.AreaFromMarkers('Ob3Area', 'LandPN31', 'LandPN29')
    ScenarioInfo.Ob3 = Objectives.CategoriesInArea(
        'primary', 'incomplete',
        OpStrings.Ob3_Title, OpStrings.Ob3_Desc,
        'kill',
        {
            MarkArea = false,
            MarkUnits = true,
            Requirements = {
                {
                    Area = areaName,
                    Category = (categories.FACTORY) + (categories.STRUCTURE * categories.ENERGYPRODUCTION) + (categories.MASSEXTRACTION),
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
            },
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
    local areaName = ExtraFunc.AreaFromMarkers('Ob5Area', 'LandPN62', 'LandPN61')

    ScenarioInfo.Ob5 = Objectives.CategoriesInArea(
        'primary', 'incomplete',
        OpStrings.Ob5_Title, OpStrings.Ob5_Desc,
        'kill',
        {
            MarkArea = false,
            MarkUnits = true,
            Requirements = {
                {
                    Area = areaName,
                    Category = categories.FACTORY + (categories.STRUCTURE * categories.ENERGYPRODUCTION) + categories.MASSEXTRACTION + categories.url0301,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
            },
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob5)
end

function Objective_5Sec1()
    local areaName = ExtraFunc.AreaFromMarkers('Ob5Sec1Area', 'LandPN58', 'LandPN57')

    ScenarioInfo.Ob5Sec1 = Objectives.CategoriesInArea(
        'secondary', 'incomplete',
        OpStrings.Ob5Sec1_Title, OpStrings.Ob5Sec1_Desc,
        'kill',
        {
            MarkArea = false,
            MarkUnits = true,
            Requirements = {
                {
                    Area = areaName,
                    Category = categories.FACTORY + (categories.STRUCTURE * categories.ENERGYPRODUCTION) + categories.MASSEXTRACTION,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = ScenarioInfo.Cybran,
                },
            },
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob5Sec1)
end

function Objective_5Sec2(CybranMex)
    ScenarioInfo.Ob5Sec2 = Objectives.KillOrCapture(
        'secondary', 'incomplete',
        OpStrings.Ob5Sec2_Title, OpStrings.Ob5Sec2_Desc,
        {
            Units = CybranMex,
            MarkUnits = false,
            ShowProgress = true,
        }
    )
    table.insert(ScenarioInfo.AssignedObjectives, ScenarioInfo.Ob5Sec2)
end