------------------------------------------------------------
-- UEF Mission 01/10 -- SINGLE PLAYER HARD -----------------
-- By Cavthena ---------------------------------------------
------------------------------------------------------------

--Manager Imports
local BuildMgr = import('/maps/faf_coop_U01.v0001/manager_UnitBuilder.lua')
local SpawnMgr = import('/maps/faf_coop_U01.v0001/manager_UnitSpawner.lua')
local EngiMgr = import('/maps/faf_coop_U01.v0001/manager_BaseEngineer.lua')
local plaAtk = import('/maps/faf_coop_U01.v0001/platoon_AttackFunctions.lua')

--AI Imports
local CybranHard = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single_CybranHard.lua')

--General Imports
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local Objectives = import('/lua/ScenarioFramework.lua').Objectives
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Utilities = import('/lua/utilities.lua')
local EffectUtilities = import('/lua/effectutilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local Cinematics = import('/lua/cinematics.lua')
local Triggers = import('/lua/scenariotriggers.lua')

local Tasks = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single_Tasks.lua')
local OpStrings = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single_Strings.lua')
local AIBuffs = import('/maps/faf_coop_U01.v0001/Ruan_AIBuff.lua')
local ExtraFunc = import('/maps/faf_coop_U01.v0001/faf_coop_U01_ExtraFunc.lua')

--Mission Tracking Refrence
--(Ref.) ScenarioInfo.MissionNumber = 0
--(Ref.) ScenarioInfo.Coop = false
--(Ref.) ScenarioInfo.AssignedObjectives = {}
local Difficulty = ScenarioInfo.Options.Difficulty

--Debug
local Debug
local NoComs
local SkipNIS

local NIS1InitialDelay = 3

function HardModeCatch(SetDbg, SetComs, SetNIS)
    LOG('Setting up mission in Single Player Mode.')
    Debug = SetDbg
    NoComs = SetComs
    SkipNIS = SetNIS

    SetArmyUnitCap(ScenarioInfo.Player1, 100)
    if Debug then LOG('Set Player1 army cap to 100.') end

    ScenarioFramework.SetPlayableArea('SINGLE_1', false)

    Ob1_Hard()
end

--==========================
--==Set Difficulty to Hard==
--==========================
--[[
Operation 1: Build 2 T1 Mass Extractors, 4 T1 PGens, 1 T1 Land Factory.
-Hard: Escalating Objective. UCap 100.
--]]
function Ob1_Hard()
    ScenarioInfo.MissionNumber = 1
    LOG('Ob1_Hard: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob1_Hard: Begin Objective 1.')

    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb1103 + categories.ueb1101 + categories.ueb0101) --Allow T1 Mass Extractor, PGen and Land Factory

    ExtraFunc.SpawnPlayerCommanders()
    ScenarioFramework.CreateUnitDamagedTrigger(function()
        LOG('Operation Hard: Player1 Commander destroyed. Mission failed!')
        ExtraFunc.CommanderDestroyed(ScenarioInfo.Player1CDR, NoComs)
    end, ScenarioInfo.Player1CDR, 0.99)

    local function Ob2Handoff()
        ScenarioFramework.PlayUnlockDialogue()
        ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb2101 + categories.ueb5101) --Allow T1 PD, Walls

        if ScenarioInfo.MissionNumber == 1 then
            Ob2_Hard()
        else
            ScenarioFramework.Dialogue(OpStrings.Main1_3, nil, false, nil)
        end
    end

    local advancetrigger = nil
    local function Ob1Continue()
        Tasks.Objective_1()
        ScenarioInfo.Ob1Group = Objectives.CreateGroup('Ob1Group_Complete', function()
            if (not NoComs) and (ScenarioInfo.MissionNumber == 1) then
                if advancetrigger then
                    KillThread(advancetrigger)
                end
                
                ScenarioFramework.Dialogue(OpStrings.Main1_2, nil, true, nil)
                Ob2Handoff()
            else
                Ob2Handoff()
            end
        end)
        ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1)
        ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1a)
        ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1b)

        Triggers.CreateArmyStatTrigger(function()
            if not NoComs then ScenarioFramework.Dialogue(OpStrings.Extra1_1, nil, false, nil) end
        end,
        ArmyBrains[ScenarioInfo.Player1],
        'Player1LowMass',
        {
            {
                StatType = 'Economy_Stored_Mass',
                CompareType = 'LessThanOrEqual',
                Value = 300,
            },
        })

        advancetrigger = ScenarioFramework.CreateTimerTrigger(function()
            ScenarioFramework.Dialogue(OpStrings.Main1_4, Ob2_Hard, true, nil)
        end, 180)
    end

    if not NoComs then
        ScenarioFramework.CreateTimerTrigger(ScenarioFramework.Dialogue(OpStrings.Main1_1, Ob1Continue, true, nil), 3)
    else
        Ob1Continue()
    end
end

--[[
Operation 2: Prepare for attack.
-Hard: Time limited Objective.
--]]
function Ob2_Hard()
    ScenarioInfo.MissionNumber = 2
    LOG('Ob2_Hard: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob2_Hard: Begin Objective 2.')

    ScenarioFramework.RemoveRestrictionForAllHumans(categories.uel0106) --Allow T1 LAB

    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main2_1_1, nil, true, nil) end

    Tasks.Objective_2() --Timed Objective
    ScenarioInfo.Ob2:AddResultCallback(function()
        Ob2a_Hard()
    end)
end

--[[
Operation 2a: Repel Cybran Raids.
-Hard: Static Objective.
--]]
function Ob2a_Hard()
    LOG('Ob2a_Hard: Begin Objective 2a.')

    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main2a_1, nil, true, nil) end

    local function Ob2bPrep()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main2a_2, nil, true, nil) end

        ScenarioInfo.Ob2a:ManualResult(true)
        Ob2b_Hard()
    end

    Tasks.Objective_2a()
    CybranHard.AREA1_CybranScoutAttack()
    ScenarioInfo.CybranScoutAttack:AddCallback(function()
        Ob2bPrep()
    end, 'OnSpawnerComplete')
end

--[[
Operation 2b: Repel Cybran attack.
-Hard: Static Objective.
--]]
function Ob2b_Hard()
    LOG('Ob2b_Hard: Begin Objective 2b.')

    ScenarioFramework.CreateTimerTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info2b_1, nil, false, nil) end

        local platoon = CybranHard.AREA1_CybranAttackPlatoon()
        Tasks.Objective_2b(platoon)
        ScenarioInfo.Ob2b:AddResultCallback(function()
            if not NoComs then
                ScenarioFramework.Dialogue(OpStrings.Main2b_1, function()
                    Ob3_Hard()
                end, true, nil)
            else
                Ob3_Hard()
            end
        end)
    end, 3)
end

--[[
Operation 3: Destroy Cybran Automated Outpost.
-Hard: Advance at 25% of base destroyed.
--]]
function Ob3_Hard()
    ScenarioInfo.MissionNumber = 3
    LOG('Ob3_Hard: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob3_Hard: Begin Objective 3.')

    CybranHard.Cybran_Outpost_AI()

    ScenarioFramework.RemoveRestrictionForAllHumans((categories.UEF * categories.TECH1 * (categories.LAND + categories.STRUCTURE)) - (categories.FACTORY * (categories.AIR + categories.NAVAL) + categories.SONAR + categories.AIRSTAGINGPLATFORM + categories.ueb2109)) --Allow for all T1 Land units and structures.
    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main3_1_1, nil, true, nil) end

    Triggers.CreateArmyIntelTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Extra3_1, nil, false, nil) end
    end, ArmyBrains[ScenarioInfo.Player1], 'LOSNow', false, true, categories.urb2101, true, ArmyBrains[ScenarioInfo.Cybran])

    Triggers.CreateArmyIntelTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Extra3_2, nil, false, nil) end
    end, ArmyBrains[ScenarioInfo.Player1], 'LOSNow', false, true, categories.urb4203, true, ArmyBrains[ScenarioInfo.Cybran])

    ScenarioFramework.SetPlayableArea('SINGLE_2', true)

    Tasks.Objective_3()
    ScenarioInfo.Ob3:AddResultCallback(function()
        EngiMgr.Stop(ScenarioInfo.COBEngi)
        BuildMgr.Stop(ScenarioInfo.COBWave)
        BuildMgr.Stop(ScenarioInfo.COBArtyWave)

        if (not NoComs) and (ScenarioInfo.MissionNumber == 3) then
            ScenarioFramework.Dialogue(OpStrings.Main3_2, Ob4_Hard, true, nil)
        elseif ScenarioInfo.MissionNumber == 3 then
            Ob4_Hard()
        else
            ScenarioFramework.Dialogue(OpStrings.Main3_2, nil, false, nil)
        end
    end)

    local rect = ExtraFunc.RectFromTwoMarkers('LandPN31', 'LandPN29')
    local brain = ArmyBrains[ScenarioInfo.Cybran]
    local cats = (categories.CYBRAN * categories.STRUCTURE) - categories.MOBILE - categories.WALL
    ForkThread(function()
        if ExtraFunc.AreaAmountDestroyed(brain, rect, 0.25, cats) and ScenarioInfo.MissionNumber == 3 then
            Ob4_Hard()
        end
    end)
end

--[[
Operation 4: Secure the UEF Quantum Coms Station.
-Hard: Timed Escalation. UCap 150.
--]]
function Ob4_Hard()
    ScenarioInfo.MissionNumber = 4
    LOG('Ob4_Hard: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob4_Hard: Begin Objective 4.')

    SetArmyUnitCap(ScenarioInfo.Player1, 150)

    local Ob4_CaptureTarget = 'Ob4_ComsStation'
    local Ob4_ObjectiveGroup = ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Objectives')
    for _, u in ipairs(Ob4_ObjectiveGroup or {}) do
        if not u.Dead and u.UnitName == Ob4_CaptureTarget then
            Ob4_CaptureTarget = u
            break
        end
    end

    local old = Ob4_CaptureTarget
    local pos = old:GetPosition()
    local new = CreateUnitHPR('uec9901', ScenarioInfo.UEFOutpost, pos[1], pos[2], pos[3], 0, 0, 0)
    old:Destroy()
    Ob4_CaptureTarget = new

    --Ob4_CaptureTarget:SetCanTakeDamage(true)
    --Ob4_CaptureTarget:SetDoNotTarget(false)
    --Ob4_CaptureTarget:SetCanBeKilled(true)
    Ob4_CaptureTarget:SetReclaimable(false)

    ScenarioFramework.CreateUnitDamagedTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_1, nil, false, nil) end

        ScenarioFramework.CreateUnitDamagedTrigger(function()
            if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_2, nil, false, nil) end

            ScenarioFramework.CreateUnitDamagedTrigger(function()
                ExtraFunc.ComsDestroyed(Ob4_CaptureTarget, NoComs)
            end, Ob4_CaptureTarget, 0.99)
        end, Ob4_CaptureTarget, 0.5)
    end, Ob4_CaptureTarget, -1)

    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Def_D'.. Difficulty)
    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Main')

    ScenarioFramework.SetPlayableArea('AREA_3', true)

    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main4_1_1, nil, true, nil) end

    Tasks.Objective_4(Ob4_CaptureTarget)
    ScenarioInfo.Ob4:AddResultCallback(function(success, payload)
        local captured = payload
        if type(payload) == 'table' then
            for _, u in payload do
                if u and not u.Dead then captured = u break end
            end
        end

        SpawnMgr.Stop(ScenarioInfo.AREA3_Wave1)
        SpawnMgr.Stop(ScenarioInfo.AREA3_WaveArty)
        SpawnMgr.Stop(ScenarioInfo.AREA3_Raid)

        if not NoComs then
            ScenarioFramework.Dialogue(OpStrings.Main4_2, function()
                Ob4a_Hard(captured)
            end, true, nil)
        else
            Ob4a_Hard(captured)
        end
    end)

    CybranHard.AREA3_CybranWaveAttacks({'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'})
    ScenarioFramework.CreateTimerTrigger(function()
        CybranHard.AREA3_CybranRaidAttacks({'AREA3_SPAWNER_EAST'})
    end, 120)

    ScenarioFramework.CreateTimerTrigger(function()
        ScenarioFramework.Dialogue(OpStrings.Extra4_1, nil, false, nil)
    end, 120)

    ScenarioFramework.CreateTimerTrigger(function()
        if ScenarioInfo.Ob4.Active and not Objectives.isComplete(ScenarioInfo.Ob4) then
            SpawnMgr.Stop(ScenarioInfo.AREA3_Wave1)
            SpawnMgr.Stop(ScenarioInfo.AREA3_WaveArty)
            SpawnMgr.Stop(ScenarioInfo.AREA3_Raid)

            CybranHard.AREA3_CybranWaveAttacks({'AREA3_SPAWNER_OFFMAPWEST', 'AREA3_SPAWNER_OFFMAPEAST'})
            CybranHard.AREA3_CybranRaidAttacks({'AREA3_SPAWNER_OFFMAPEAST'})
        end

        if ScenarioInfo.Ob4b.Active and not Objectives.isComplete(ScenarioInfo.Ob4b) then
            SpawnMgr.Stop(ScenarioInfo.AREA3_HoldingWave)

            CybranHard.AREA3_HoldingAttack({'AREA3_SPAWNER_OFFMAPWEST', 'AREA3_SPAWNER_OFFMAPEAST'}, {'AREA3_SPAWNER_OFFMAPEAST'})
        end

        if ScenarioInfo.MissionNumber < 5 then
            Ob5_Hard()
        end
    end, 900)
end

--[[
Operation 4a/b: Defend the UEF Quantum Coms Station for 5 minutes.
-Hard: Static Objective.
--]]
function Ob4a_Hard(captured)
    LOG('Ob4a_Hard: Begin Objective 4a/b')

    --captured:SetDoNotTarget(false)
    --captured:SetCanTakeDamage(true)
    --captured:SetCanBeKilled(true)
    captured:SetReclaimable(false)

    ScenarioFramework.CreateUnitDamagedTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_1, nil, false, nil) end

        ScenarioFramework.CreateUnitDamagedTrigger(function()
            if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_2, nil, false, nil) end

            ScenarioFramework.CreateUnitDamagedTrigger(function()
                ExtraFunc.ComsDestroyed(captured, NoComs)
            end, captured, 0.99)
        end, captured, 0.5)
    end, captured, -1)

    Tasks.Objective_4a(captured)

    Tasks.Objective_4b()
    ScenarioInfo.Ob4b:AddResultCallback(function()
        SpawnMgr.Stop(ScenarioInfo.AREA3_HoldingWave)

        if ScenarioInfo.MissionNumber < 5 then
            if not NoComs then
                ScenarioFramework.Dialogue(OpStrings.Main4a_1_1, Ob5_Hard, true, nil)
            else
                Ob5_Hard()
            end
        else
            if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main4a_1_1, nil, true, nil) end
        end
    end)

    ScenarioFramework.CreateTimerTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4a_1, nil, false, nil) end
    end, 150)
    ScenarioFramework.CreateTimerTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4a_2, nil, false, nil) end
    end, 270)

    if ScenarioInfo.MissionNumber == 4 then
        CybranHard.AREA3_HoldingAttack({'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'}, {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'})
    end
end

--[[
Operation 5: Destroy Cybran base and Support Commander.
-Hard: Static Objective. Ucap 200.
--]]
function Ob5_Hard()
    ScenarioInfo.MissionNumber = 5
    LOG('Ob5_Hard: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob5_Hard: Begin Objective 5.')

    SetArmyUnitCap(ScenarioInfo.Player1, 200)

    local DAT = false
    local function DetectAirThread()
        if not DAT then
            DAT = true
            if not NoComs then
                ScenarioFramework.Dialogue(OpStrings.Side5_1_1, function()
                    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb0102 + categories.uea0102 + categories.uea0101) --Allow for T1 Air Factory, scout and fighter.
                end, true, nil)
            else
                ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb0102 + categories.uea0102 + categories.uea0101) --Allow for T1 Air Factory, scout and fighter.
            end

            Tasks.Objective_5Sec1()
            ScenarioInfo.Ob5Sec1:AddResultCallback(function()
                if not NoComs then ScenarioFramework.Dialogue(OpStrings.Side5_2, nil, false, nil) end
            end)
        end
    end

    Triggers.CreateArmyIntelTrigger(DetectAirThread, ArmyBrains[ScenarioInfo.Player1], 'Radar', false, true, categories.AIR, true, ArmyBrains[ScenarioInfo.Cybran])
    Triggers.CreateArmyIntelTrigger(DetectAirThread, ArmyBrains[ScenarioInfo.Player1], 'LOSNow', false, true, categories.AIR, true, ArmyBrains[ScenarioInfo.Cybran])

    CybranHard.Cybran_MainBase_AI()
    CybranHard.Cybran_SupportAirBase_AI()
    ScenarioUtils.CreateArmyGroup('Cybran', 'Cybran_SupportBase2_Main_D'..Difficulty)
    local comGroup = ScenarioUtils.CreateArmyGroup('Cybran', 'Cybran_MainBase_Com')

    local comUnit = nil
    for _, u in ipairs(comGroup) do
        if u.UnitName == 'Cybran_Com' then
            comUnit = u
            break
        end
    end
    if not comUnit then
        WARN('Ob5_Hard: Cybran_Com not found.')
    else
        ScenarioInfo.CMBEngi:AssignEngineerUnit(comUnit)
    end

    local function Ob5Continue()
        ScenarioFramework.SetPlayableArea('AREA_4', true)

        Tasks.Objective_5()
        ScenarioInfo.Ob5:AddResultCallback(function()
            if not NoComs then
                ScenarioInfo.Ob4a:ManualResult(true)
                ScenarioFramework.Dialogue(OpStrings.Main5_2, ExtraFunc.OperationComplete, true, nil)
            else
                ScenarioInfo.Ob4a:ManualResult(true)
                ExtraFunc.OperationComplete()
            end
        end)

        ScenarioFramework.CreateTimerTrigger(function()
            if not NoComs then ScenarioFramework.Dialogue(OpStrings.Side5_3, nil, false, nil) end

            local areaName = ExtraFunc.AreaFromMarkers('Ob5Sec2Area', 'LandPN46', 'LandPN44')
            local CybranMex = ScenarioFramework.GetCatUnitsInArea(categories.CYBRAN * categories.STRUCTURE * categories.MASSEXTRACTION * categories.TECH1, areaName, ArmyBrains[ScenarioInfo.Cybran])
            Tasks.Objective_5Sec2(CybranMex)
            ScenarioInfo.Ob5Sec2:AddResultCallback(function()
                if not NoComs then ScenarioFramework.Dialogue(OpStrings.Side5_4, nil, false, nil) end
            end)
        end, 15)
    end

    if not NoComs then
        ScenarioFramework.Dialogue(OpStrings.Main5_1_1, Ob5Continue, true, nil)
    else
        Ob5Continue()
    end
end