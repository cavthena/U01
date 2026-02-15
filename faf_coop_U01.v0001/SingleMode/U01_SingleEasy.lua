------------------------------------------------------------
-- UEF Mission 01/10 -- SINGLE PLAYER EASY -----------------
-- By Cavthena ---------------------------------------------
------------------------------------------------------------

--Manager Imports
local BuildMgr = import('/maps/faf_coop_U01.v0001/manager_UnitBuilder.lua')
local SpawnMgr = import('/maps/faf_coop_U01.v0001/manager_UnitSpawner.lua')
local EngiMgr = import('/maps/faf_coop_U01.v0001/manager_BaseEngineer.lua')
local plaAtk = import('/maps/faf_coop_U01.v0001/platoon_AttackFunctions.lua')

--AI Imports
local CybranEasy = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single_CybranEasy.lua')

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

function EasyModeCatch(SetDbg, SetComs, SetNIS)
    LOG('Setting up mission in Single Player Mode.')
    Debug = SetDbg
    NoComs = SetComs
    SkipNIS = SetNIS

    SetArmyUnitCap(ScenarioInfo.Player1, 100)
    if Debug then LOG('Set Player1 army cap to 100.') end

    ScenarioFramework.SetPlayableArea('SINGLE_1', false)

    Ob1_Easy()
end

--==========================
--==Set Difficulty to Easy==
--==========================
--[[
Operation 1: Build 2 T1 Mass Extractors, 4 T1 PGens, 1 T1 Land Factory.
-EASY: Static Objective. No Opposition. UCap 100.
--]]
function Ob1_Easy()
    ScenarioInfo.MissionNumber = 1
    LOG('Ob1_Easy: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob1_Easy: Begin Objective 1.')

    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb1103 + categories.ueb1101 + categories.ueb0101) --Allow T1 Mass Extractor, PGen and Land Factory
    if Debug then LOG('Ob1_Easy: Added ueb1103, ueb1101, ueb0101 to build list.') end

    ExtraFunc.SpawnPlayerCommanders()
    ScenarioFramework.CreateUnitDestroyedTrigger(function()
        LOG('Operation Easy: Player1 Commander destroyed. Mission failed!')
        ExtraFunc.CommanderDestroyed(ScenarioInfo.Player1CDR, NoComs)
    end, ScenarioInfo.Player1CDR)
    if Debug then LOG('Ob1_Easy: Spawned Commander and added death trigger to fail the operation.') end

    local function Ob2Handoff()
        ScenarioFramework.PlayUnlockDialogue()
        ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb2101 + categories.ueb5101) --Allow T1 PD, Walls
        if Debug then LOG('Ob1_Easy: Added ueb2101 and ueb5101 to build list.') end

        Ob2_Easy()
    end

    local function Ob1Continue()
        Tasks.Objective_1()
        ScenarioInfo.Ob1Group = Objectives.CreateGroup('Ob1Group_Complete', function()
            LOG('Ob1_Easy: All Objectives for Mission 1 Complete. Starting Objective 2.')

            if not NoComs then 
                ScenarioFramework.Dialogue(OpStrings.Main1_2, nil, true, nil)
                Ob2Handoff()
            else
                Ob2Handoff()
            end
        end)
        ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1)
        ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1a)
        ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1b)
        if Debug then LOG('Ob1_Easy: Created Objective 1, 1a, 1b and added to objective group.') end

        Triggers.CreateArmyStatTrigger(
            function()
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
            }
        )
        if Debug then LOG('Ob1_Easy: Created low mass trigger for Player1.') end
    end

    if not NoComs then 
        ScenarioFramework.CreateTimerTrigger(ScenarioFramework.Dialogue(OpStrings.Main1_1, Ob1Continue, true, nil), 3)
    else
        Ob1Continue()
    end
end

--[[
Operation 2: Prepare for attack.
-EASY: Static Objective. Objective to build 10 LABs. No Opposition.
--]]
function Ob2_Easy()
    ScenarioInfo.MissionNumber = 2
    LOG('Ob2_Easy: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob2_Easy: Begin Objective 2.')

    ScenarioFramework.RemoveRestrictionForAllHumans(categories.uel0106) --Allow T1 LAB
    if Debug then LOG('Ob1_Easy: Added ueb0106 to build list.') end

    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main2_1_1, nil, true, nil) end

    Tasks.Objective_2()
    ScenarioInfo.Ob2:AddResultCallback(function()
        LOG('Ob2_Easy: Objective completed for Mission 2. Starting Objective 2a.')

        Ob2a_Easy()
    end)
    if Debug then LOG('Ob2_Easy: Created Objective 2 and created ResultCallback.') end
end

--[[
Operation 2a: Repel Cybran Raids.
-EASY: Static Objective. Controlled attacks.
--]]
function Ob2a_Easy()
    LOG('Ob2a_Easy: Begin Objective 2a.')

    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main2a_1, nil, true, nil) end

    local function Ob2bPrep()
        LOG('Ob2a_Easy: Objectives for Mission 2a completed. Start Objective 2b.')

        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main2a_2, nil, true, nil) end

        ScenarioInfo.Ob2a:ManualResult(true)
        if Debug then LOG('Ob2a_Easy: Objective 2a manual result to true/complete/success.') end

        Ob2b_Easy()
    end

    Tasks.Objective_2a()
    if Debug then LOG('Ob2a_Easy: Created Objective 2a.') end

    CybranEasy.AREA1_CybranScoutAttack()
    ScenarioInfo.CybranScoutAttack:AddCallback(function()
        Ob2bPrep()
    end, 'OnSpawnerComplete')
    if Debug then LOG('Ob2a_Easy: Cybran Scout attacks created and added Callback for when complete.') end
end

--[[
Operation 2b: Repel Cybran attack.
-EASY: Static Objective. Controlled attacks.
--]]
function Ob2b_Easy()
    LOG('Ob2b_Easy: Begin Objective 2b.')

    ScenarioFramework.CreateTimerTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info2b_1, nil, false, nil) end

        local platoon = CybranEasy.AREA1_CybranAttackPlatoon()
        Tasks.Objective_2b(platoon)
        ScenarioInfo.Ob2b:AddResultCallback(function()
            LOG('Ob2b_Easy: Objectives for Mission 2b completed. Start Objective 3.')

            if not NoComs then 
                ScenarioFramework.Dialogue(OpStrings.Main2b_1, function()
                    Ob3_Easy()
                end, true, nil) 
            else
                Ob3_Easy()
            end
        end)
        if Debug then LOG('Ob2b_Easy: Created attack platoon and objective and ResultCallback.') end
    end, 3)
end

--[[
Operation 3: Destroy Cybran Automated Outpost.
-EASY: Static Objective. Cybran Base attacks.
--]]
function Ob3_Easy()
    ScenarioInfo.MissionNumber = 3
    LOG('Ob3_Easy: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob3_Easy: Begin Objective 3.')

    CybranEasy.Cybran_Outpost_AI()
    if Debug then LOG('Ob3_Easy: Created Cybran Outpost Base and its attacks.') end

    ScenarioFramework.RemoveRestrictionForAllHumans((categories.UEF * categories.TECH1 * (categories.LAND + categories.STRUCTURE)) - (categories.FACTORY * (categories.AIR + categories.NAVAL) + categories.SONAR + categories.AIRSTAGINGPLATFORM + categories.ueb2109)) --Allow for all T1 Land units and structures.
    if Debug then LOG('Ob3_Easy: Added all T1 Ground Units, excluding Air and Naval, to build list.') end
    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main3_1_1, nil, true, nil) end

    Triggers.CreateArmyIntelTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Extra3_1, nil, false, nil) end
    end, ArmyBrains[ScenarioInfo.Player1], 'LOSNow', false, true, categories.urb2101, true, ArmyBrains[ScenarioInfo.Cybran])
    if Debug then LOG('Ob3_Easy: Created Player1 IntelTrigger for urb2101.') end

    Triggers.CreateArmyIntelTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Extra3_2, nil, false, nil) end
    end, ArmyBrains[ScenarioInfo.Player1], 'LOSNow', false, true, categories.urb4203, true, ArmyBrains[ScenarioInfo.Cybran])
    if Debug then LOG('Ob3_Easy: Created Player1 IntelTrigger for urb4203.') end

    ScenarioFramework.SetPlayableArea('SINGLE_2', true)
    
    Tasks.Objective_3()
    ScenarioInfo.Ob3:AddResultCallback(function()
        LOG('Ob3_Easy: Objectives for Mission 3 Completed. Starting Objective 4.')

        EngiMgr.Stop(ScenarioInfo.COBEngi)
        BuildMgr.Stop(ScenarioInfo.COBWave)
        BuildMgr.Stop(ScenarioInfo.COBArtyWave)
        if Debug then LOG('Ob3_Easy: Stopped COBEngi, COBWave, COBArtyWave.') end

        if not NoComs then 
            ScenarioFramework.Dialogue(OpStrings.Main3_2, Ob4_Easy, true, nil) 
        else
            Ob4_Easy()
        end
    end)
    if Debug then LOG('Ob3_Easy: Created Objective 3 and ResultCallback.') end
end

--[[
Operation 4: Secure the UEF Quantum Coms Station.
-EASY: Static Objective. Off map attacks. Coms Station not targeted. UCap 200.
--]]
function Ob4_Easy()
    ScenarioInfo.MissionNumber = 4
    LOG('Ob4_Easy: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob4_Easy: Begin Objective 4.')

    SetArmyUnitCap(ScenarioInfo.Player1, 200)
    if Debug then LOG('Ob4_Easy: Set Player1 army cap to 200.') end

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

    Ob4_CaptureTarget:SetCanTakeDamage(false)
    Ob4_CaptureTarget:SetDoNotTarget(true)
    Ob4_CaptureTarget:SetCanBeKilled(false)
    Ob4_CaptureTarget:SetReclaimable(false)
    if Debug then LOG('Ob4_Easy: Create Objective unit, find/save and set special status.') end

    ScenarioFramework.CreateUnitDamagedTrigger(function()
        ExtraFunc.ComsDestroyed(Ob4_CaptureTarget, NoComs)
    end, Ob4_CaptureTarget, 0.99)
    ScenarioFramework.CreateUnitDamagedTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_2, nil, false, nil) end
    end, Ob4_CaptureTarget, 0.5)
    ScenarioFramework.CreateUnitDamagedTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_1, nil, false, nil) end
    end, Ob4_CaptureTarget, -1)

    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Def_D'.. Difficulty)
    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Main')
    if Debug then LOG('Ob4_Easy: Create UEFOutpost base.') end

    ScenarioFramework.SetPlayableArea('AREA_3', true)

    if not NoComs then ScenarioFramework.Dialogue(OpStrings.Main4_1_1, nil, true, nil) end

    Tasks.Objective_4(Ob4_CaptureTarget)
    ScenarioInfo.Ob4:AddResultCallback(function(success, payload)
        LOG('Ob4_Easy: Objectives for Objective 4 complete. Starting Objective 4a.')

        local captured = payload
        if type(payload) == 'table' then
            for _, u in payload do
                if u and not u.Dead then captured = u break end
            end
        end

        SpawnMgr.Stop(ScenarioInfo.AREA3_Wave1)
        SpawnMgr.Stop(ScenarioInfo.AREA3_WaveArty)
        if Debug then LOG('Ob4_Easy: Stopped AREA3_Wave1, AREA3_WaveArty') end

        if not NoComs then 
            ScenarioFramework.Dialogue(OpStrings.Main4_2, function()
                Ob4a_Easy(captured)
            end, true, nil) 
        else
            Ob4a_Easy(captured)
        end
    end)
    if Debug then LOG('Ob4_Easy: Created Objective 4 and ResultCallback.') end

    CybranEasy.AREA3_CybranWaveAttacks()
    if Debug then LOG('Ob4_Easy: Start Cybran Wave attacks.') end

    ScenarioFramework.CreateTimerTrigger(function()
        ScenarioFramework.Dialogue(OpStrings.Extra4_1, nil, false, nil)
    end, 120)
    if Debug then LOG('Ob4_Easy: Created Timer Trigger for hint.') end
end

--[[
Operation 4a/b: Defend the UEF Quantum Coms Station for 5 minutes.
-EASY: Static Objective. Coms Station targeted attacks.
--]]
function Ob4a_Easy(captured)
    LOG('Ob4a_Easy: Begin Objective 4a/b.')

    captured:SetDoNotTarget(false)
    captured:SetCanTakeDamage(true)
    captured:SetCanBeKilled(true)
    captured:SetReclaimable(false)
    if Debug then LOG('Ob4a_Easy: Reset Objective target special status.') end

    ScenarioFramework.CreateUnitDamagedTrigger(function()
        ExtraFunc.ComsDestroyed(captured, NoComs)
    end, captured, 0.99)
    ScenarioFramework.CreateUnitDamagedTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_2, nil, false, nil) end
    end, captured, 0.5)
    ScenarioFramework.CreateUnitDamagedTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4_1, nil, false, nil) end
    end, captured, -1)

    Tasks.Objective_4a(captured)
    ScenarioInfo.Ob4a:AddResultCallback(function(success)
        if not success then
            LOG('Ob4a_Easy: Objective 4a failed. Mission Failure!')
        end
    end)
    if Debug then LOG('Ob4a_Easy: Created Objective 4a and ResultCallback.') end

    Tasks.Objective_4b()
    ScenarioInfo.Ob4b:AddResultCallback(function()
        LOG('Ob4a_Easy: Objective 4b Completed. Success on Objective 4a. Starting Objective 5.')

        local function StartOb5()
            ScenarioInfo.Ob4a:ManualResult(true)
            if Debug then LOG('Ob4a_Easy: Objective 4a manual result to true/complete/success.') end

        Ob5_Easy()
        end

        if not NoComs then 
            ScenarioFramework.Dialogue(OpStrings.Main4a_1_1, StartOb5, true, nil)
        else
            StartOb5()
        end
    end)
    if Debug then LOG('Ob4a_Easy: Created Objective 4b and ResultCallback.') end

    ScenarioFramework.CreateTimerTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4a_1, nil, false, nil) end
    end, 150)
    ScenarioFramework.CreateTimerTrigger(function()
        if not NoComs then ScenarioFramework.Dialogue(OpStrings.Info4a_2, nil, false, nil) end
    end, 270)
    if Debug then LOG('Ob4a_Easy: Created TimerTrigger for 50% and 30s remaining.') end

    CybranEasy.AREA3_HoldingAttack()
    if Debug then LOG('Ob4a_Easy: Started AREA3_HoldingAttack.') end
end

--[[
Operation 5: Destroy Cybran base and Support Commander.
-EASY: Static Objective. Cybran Base attacks + Support Base attacks.
--]]
function Ob5_Easy()
    ScenarioInfo.MissionNumber = 5
    LOG('Ob5_Easy: Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Ob5_Easy: Begin Objective 5.')

    local DAT = false
    local function DetectAirThread()
        if not DAT then
            DAT = true

            if not NoComs then
                ScenarioFramework.Dialogue(OpStrings.Side5_1_1, function()
                    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb0102 + categories.uea0102 + categories.uea0101)
                end, true, nil)
            else
                ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb0102 + categories.uea0102 + categories.uea0101)
            end

            Tasks.Objective_5Sec1()
            ScenarioInfo.Ob5Sec1:AddResultCallback(function()
                if not NoComs then ScenarioFramework.Dialogue(OpStrings.Side5_2, nil, false, nil) end
            end)
            if Debug then LOG('Ob5_Easy: Created Objective 5 Secondary 1 and ResultCallback.') end
        end
    end

    Triggers.CreateArmyIntelTrigger(DetectAirThread, ArmyBrains[ScenarioInfo.Player1], 'Radar', false, true, categories.AIR, true, ArmyBrains[ScenarioInfo.Cybran])
    Triggers.CreateArmyIntelTrigger(DetectAirThread, ArmyBrains[ScenarioInfo.Player1], 'LOSNow', false, true, categories.AIR, true, ArmyBrains[ScenarioInfo.Cybran])
    if Debug then LOG('Ob5_Easy: Created IntelTrigger for air units. On trigger added ueb0102, uea0102, uea0101 to build list.') end

    CybranEasy.Cybran_MainBase_AI()
    CybranEasy.Cybran_SupportAirBase_AI()
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
        WARN('Ob5_Easy: Cybran_Com not found.')
    else
        ScenarioInfo.CMBEngi:AssignEngineerUnit(comUnit)
    end
    if Debug then LOG('Ob5_Easy: Created Cybran Main Base, Support Base and extra extractors. Assigned Support Commander to Base.') end

    local function Ob5Continue()
        ScenarioFramework.SetPlayableArea('AREA_4', true)

        Tasks.Objective_5()
        ScenarioInfo.Ob5:AddResultCallback(function()
            LOG('Ob5_Easy: Objective 5 Completed. Mission success!')

            if not NoComs then 
                ScenarioFramework.Dialogue(OpStrings.Main5_2, ExtraFunc.OperationComplete, true, nil)
            else
                ExtraFunc.OperationComplete()
            end
        end)
        if Debug then LOG('Ob5_Easy: Created Objective 5 and ResultCallback.') end

        ScenarioFramework.CreateTimerTrigger(function()
            if not NoComs then ScenarioFramework.Dialogue(OpStrings.Side5_3, nil, false, nil) end

            local areaName = ExtraFunc.AreaFromMarkers('Ob5Sec2Area', 'LandPN46', 'LandPN44')
            local CybranMex = ScenarioFramework.GetCatUnitsInArea(categories.CYBRAN * categories.STRUCTURE * categories.MASSEXTRACTION * categories.TECH1, areaName, ArmyBrains[ScenarioInfo.Cybran])
            Tasks.Objective_5Sec2(CybranMex)
            ScenarioInfo.Ob5Sec2:AddResultCallback(function()
                if Debug then LOG('Ob5_Easy: Objective 5 Secondary 2 Completed.') end
                if not NoComs then ScenarioFramework.Dialogue(OpStrings.Side5_4, nil, false, nil) end
            end)
        end, 15)
        if Debug then LOG('Ob5_Easy: Created TimerTrigger for dialog.') end
    end

    if not NoComs then 
        ScenarioFramework.Dialogue(OpStrings.Main5_1_1, Ob5Continue, true, nil) 
    else
        Ob5Continue()
    end
end