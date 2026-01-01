------------------------------------------------------------
-- UEF Mission 01/10 -- SINGLE PLAYER ----------------------
-- By Cavthena ---------------------------------------------
------------------------------------------------------------

--Manager Imports
local BuildMgr = import('/maps/faf_coop_U01.v0001/manager_UnitBuilder.lua')
local SpawnMgr = import('/maps/faf_coop_U01.v0001/manager_UnitSpawner.lua')
local EngiMgr = import('/maps/faf_coop_U01.v0001/manager_BaseEngineer.lua')
local plaAtk = import('/maps/faf_coop_U01.v0001/platoon_AttackFunctions.lua')

--AI Imports
local CybranAI = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single_CybranAI.lua')

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

function SingleModeCatch(SetDbg, SetComs, SetNIS)
    LOG('Setting up mission in Single Player Mode.')
    Debug = SetDbg
    NoComs = SetComs
    SkipNIS = SetNIS

    SetArmyUnitCap(ScenarioInfo.Player1, 100)
    if Debug then LOG('Set Player1 army cap to 100.') end

    ScenarioFramework.SetPlayableArea('SINGLE_1', false)

    if Difficulty == 1 then
        Ob1_Easy()
    elseif Difficulty == 2 then
        Ob1_Med()
    else
        Ob1_Hard()
    end
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
    LOG('Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Begin Objective 1.')

    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb1103 + categories.ueb1101 + categories.ueb0101) --Allow T1 Mass Extractor, PGen and Land Factory
    if Debug then LOG('Added ueb1103, ueb1101, ueb0101 to build list.') end

    ExtraFunc.SpawnPlayerCommanders()
    ScenarioInfo.Player1CDR:AddUnitCallback(ExtraFunc.Player1Kill, 'OnKilled')
    if Debug then LOG('Spawned Commander and added death callback to fail the operation.') end

    -------------------------------------
    --Dialog: Build a base instructions.
    -------------------------------------

    Tasks.Objective_1()
    ScenarioInfo.Ob1Group = Objectives.CreateGroup('Ob1Group_Complete', function()
        LOG('All Objectives for Mission 1 Complete. Starting Objective 2.')

        ---------------------------------------------
        --DIALOG: Base built, uploading PD and walls.
        ---------------------------------------------

        ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb2101 + categories.ueb5101) --Allow T1 PD, Walls
        if Debug then LOG('Added ueb2101 and ueb5101 to build list.') end

        Ob2_Easy()
    end)
    ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1)
    ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1a)
    ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1b)
    if Debug then LOG('Created Objective 1, 1a, 1b and added to objective group.') end
end

--[[
Operation 2: Prepare for attack.
-EASY: Static Objective. Objective to build 10 LABs. No Opposition.
--]]
function Ob2_Easy()
    ScenarioInfo.MissionNumber = 2
    LOG('Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Begin Objective 2.')

    ScenarioFramework.RemoveRestrictionForAllHumans(categories.uel0106) --Allow T1 LAB
    if Debug then LOG('Added ueb0106 to build list.') end

    ----------------------------------------------------------------------------
    --DIALOG: Uploaded the T1 LAB, construct 10 and prepare for the Cybran raid!
    ----------------------------------------------------------------------------

    Tasks.Objective_2()
    ScenarioInfo.Ob2:AddResultCallback(function()
        LOG('Objective completed for Mission 2. Starting Objective 2a.')

        Ob2a_Easy()
    end)
    if Debug then LOG('Created Objective 2 and created ResultCallback.') end
end

--[[
Operation 2a: Repel Cybran Raids.
-EASY: Static Objective. Controlled attacks.
--]]
function Ob2a_Easy()
    LOG('Begin Objective 2a.')

    -------------------------
    --DIALOG: Here they come!
    -------------------------

    local function Ob2bPrep()
        LOG('Objectives for Mission 2a completed. Start Objective 2b.')

        ---------------------------------
        --DIALOG: Incoming larger attack!
        ---------------------------------

        ScenarioInfo.Ob2a:ManualResult(true)
        if Debug then LOG('Objective 2a manual result to true/complete/success.') end

        Ob2b_Easy()
    end

    Tasks.Objective_2a()
    if Debug then LOG('Created Objective 2a.') end

    CybranAI.AREA1_CybranScoutAttack(2, 6, 60)
    ScenarioInfo.CybranScoutAttack:AddCallback(function()
        ForkThread(Ob2bPrep)
    end, 'OnSpawnerComplete')
    if Debug then LOG('Cybran Scout attacks created and added Callback for when complete.') end
end

--[[
Operation 2b: Repel Cybran attack.
-EASY: Static Objective. Controlled attacks.
--]]
function Ob2b_Easy()
    LOG('Begin Objective 2b.')

    ------------------------------------------
    --DIALOG: Upload will not make it in time!
    ------------------------------------------

    local platoon = CybranAI.AREA1_CybranAttackPlatoon('AREA1_SPAWN_EAST_3')
    Tasks.Objective_2b(platoon)
    ScenarioInfo.Ob2b:AddResultCallback(function()
        LOG('Objectives for Mission 2b completed. Start Objective 3.')

        ----------------------
        --DIALOG: You survived
        ----------------------

        Ob3_Easy()
    end)
    if Debug then LOG('Created attack platoon and objective and ResultCallback.') end
end

--[[
Operation 3: Destroy Cybran Automated Outpost.
-EASY: Static Objective. Cybran Base attacks.
--]]
function Ob3_Easy()
    ScenarioInfo.MissionNumber = 3
    LOG('Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Begin Objective 3.')

    CybranAI.Cybran_Outpost_AI()
    if Debug then LOG('Created Cybran Outpost Base and its attacks.') end

    ----------------------------------------------------------------------------------------------------
    --DIALOG: Detected a Cybran base. Uploading units to expand the base and begin offensive operations.
    ----------------------------------------------------------------------------------------------------

    ScenarioFramework.RemoveRestrictionForAllHumans((categories.UEF * categories.TECH1 * (categories.LAND + categories.STRUCTURE))- (categories.FACTORY * (categories.AIR + categories.NAVAL) + categories.SONAR + categories.AIRSTAGINGPLATFORM + categories.ueb2109)) --Allow for all T1 Land units and structures.
    if Debug then LOG('Added all T1 Ground Units, excluding Air and Naval, to build list.') end

    Triggers.CreateArmyIntelTrigger(ExtraFunc.DetectTurretThread, ArmyBrains[ScenarioInfo.Player1], 'LOSNow', false, true, categories.urb2101, true, ArmyBrains[ScenarioInfo.Cybran])
    if Debug then LOG('Created Player1 IntelTrigger for urb2101.') end

    ScenarioFramework.SetPlayableArea('SINGLE_2', true)
    
    Tasks.Objective_3()
    ScenarioInfo.Ob3:AddResultCallback(function()
        LOG('Objectives for Mission 3 Completed. Starting Objective 4.')

        EngiMgr.Stop(ScenarioInfo.COBEngi)
        BuildMgr.Stop(ScenarioInfo.COBWave)
        BuildMgr.Stop(ScenarioInfo.COBArtyWave)
        if Debug then LOG('Stopped COBEngi, COBWave, COBArtyWave.') end

        -----------------------------------
        --DIALOG: Cybran Outpost destroyed!
        -----------------------------------

        Ob4_Easy()
    end)
    if Debug then LOG('Created Objective 3 and ResultCallback.') end
end

--[[
Operation 4: Secure the UEF Quantum Coms Station.
-EASY: Static Objective. Off map attacks. Coms Station not targeted. UCap 200.
--]]
function Ob4_Easy()
    ScenarioInfo.MissionNumber = 4
    LOG('Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Begin Objective 4.')

    SetArmyUnitCap(ScenarioInfo.Player1, 200)
    if Debug then LOG('Set Player1 army cap to 200.') end

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
    Ob4_CaptureTarget:SetMaxHealth(50000)
    Ob4_CaptureTarget:SetHealth(Ob4_CaptureTarget, 50000)
    --Ob4_CaptureTarget:SetCustomName('Communication Array')
    if Debug then LOG('Create Objective unit, find/save and set special status.') end

    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Def_D'.. Difficulty)
    ScenarioUtils.CreateArmyGroup('UEFOutpost', 'UEF_ComsBase_Main')
    if Debug then LOG('Create UEFOutpost base.') end

    ScenarioFramework.SetPlayableArea('AREA_3', true)

    --------------------------------
    --DIALOG: Capture the Coms Array
    --------------------------------

    Tasks.Objective_4(Ob4_CaptureTarget)
    ScenarioInfo.Ob4:AddResultCallback(function(success, payload)
        LOG('Objectives for Objective 4 complete. Starting Objective 4a.')

        local captured = payload
        if type(payload) == 'table' then
            for _, u in payload do
                if u and not u.Dead then captured = u break end
            end
        end

        -----------------------------------
        --DIALOG: Hold the array for 5 min.
        -----------------------------------

        SpawnMgr.Stop(ScenarioInfo.AREA3_Wave1)
        SpawnMgr.Stop(ScenarioInfo.AREA3_WaveArty)
        if Debug then LOG('Stopped AREA3_Wave1, AREA3_WaveArty') end

        Ob4a_Easy(captured)
    end)
    if Debug then LOG('Created Objective 4 and ResultCallback.') end

    CybranAI.AREA3_CybranWaveAttacks(15, 30, {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'})
    if Debug then LOG('Start Cybran Wave attacks.') end
end

--[[
Operation 4a/b: Defend the UEF Quantum Coms Station for 5 minutes.
-EASY: Static Objective. Coms Station targeted attacks.
--]]
function Ob4a_Easy(captured)
    LOG('Begin Objective 4a/b.')

    captured:SetDoNotTarget(false)
    captured:SetCanTakeDamage(true)
    captured:SetCanBeKilled(true)
    captured:SetReclaimable(false)
    captured:SetMaxHealth(50000)
    captured:SetHealth(captured, 50000)
    captured:SetCustomName('Communication Array')
    --captured:AddUnitCallback(ComsDestroyed, 'OnKilled')
    if Debug then LOG('Reset Objective target special status.') end

    Tasks.Objective_4a(captured)
    ScenarioInfo.Ob4a:AddResultCallback(function(success)
        if not success then
            LOG('Objective 4a failed. Mission Failure!')
            -------------------------------
            --DIALOG: Coms array destroyed!
            -------------------------------
        end
    end)
    if Debug then LOG('Created Objective 4a and ResultCallback.') end

    Tasks.Objective_4b()
    ScenarioInfo.Ob4b:AddResultCallback(function()
        LOG('Objective 4b Completed. Success on Objective 4a. Starting Objective 5.')

        ----------------------------
        --DIALOG: Connection created
        ----------------------------

        ScenarioInfo.Ob4a:ManualResult(true)
        if Debug then LOG('Objective 4a manual result to true/complete/success.') end

        Ob5_Easy()
    end)
    if Debug then LOG('Created Objective 4b and ResultCallback.') end

    ScenarioFramework.CreateTimerTrigger(function()
        ------------------
        --DIALOG: Half way
        ------------------
    end, 150)
    ScenarioFramework.CreateTimerTrigger(function()
        ------------------
        --DIALOG: 30s left
        ------------------
    end, 270)
    if Debug then LOG('Created TimerTrigger for 50% and 30s remaining.') end

    CybranAI.AREA3_HoldingAttack()
    if Debug then LOG('Started AREA3_HoldingAttack.') end
end

--[[
Operation 5: Destroy Cybran base and Support Commander.
-EASY: Static Objective. Cybran Base attacks + Support Base attacks.
--]]
function Ob5_Easy()
    ScenarioInfo.MissionNumber = 5
    LOG('Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Begin Objective 5.')

    Triggers.CreateArmyIntelTrigger(ExtraFunc.DetectAirThread, ArmyBrains[ScenarioInfo.Player1], 'Radar', false, true, categories.AIR, true, ArmyBrains[ScenarioInfo.Cybran])
    if Debug then LOG('Created IntelTrigger for air units. On trigger added ueb0102, uea0102, uea0101 to build list.') end

    CybranAI.Cybran_MainBase_AI(0, 0)
    CybranAI.Cybran_SupportAirBase_AI()
    ScenarioUtils.CreateArmyGroup('Cybran', 'Cybran_SupportBase2_Main_D'..Difficulty)
    local com = ScenarioUtils.CreateArmyGroup('Cybran', 'Cybran_MainBase_Com')

    com:AddUnitCallback(ExtraFunc.CybranAgentDestroyed, 'OnKilled')
    ScenarioInfo.CMBEngi:AssignEngineerUnit(com)
    if Debug then LOG('Created Cybran Main Base, Support Base and extra extractors. Assigned Support Commander to Base.') end

    -------------------------------
    --DIALOG: Cybran Base detected.
    -------------------------------

    ScenarioFramework.SetPlayableArea('AREA_4', true)

    Tasks.Objective_5()
    ScenarioInfo.Ob5:AddResultCallback(function()
        LOG('Objective 5 Completed. Mission success!')

        -------------------
        --DIALOG: Victory--
        --CUTSCENE: Victory
        -------------------
    end)
    if Debug then LOG('Created Objective 5 and ResultCallback.') end

    ---------------------------------------
    --DIALOG: Cybran Support Base detected.
    ---------------------------------------

    Tasks.Objective_5Sec1()
    ScenarioInfo.Ob5Sec1:AddResultCallback(function()
        ---------------------------------
        --DIALOG: Support Base destroyed.
        ---------------------------------
    end)
    if Debug then LOG('Created Objective 5 Secondary 1 and ResultCallback.') end

    ScenarioFramework.CreateTimerTrigger(function()
        -------------------------------------
        --DIALOG: Undefended Mass extractors.
        -------------------------------------
    end, 120)
    if Debug then LOG('Created TimerTrigger for dialog.') end
end


--============================
--==Set Difficulty to Medium==
--============================
--[[
Operation 1: Build 2 T1 Mass Extractors, 4 T1 PGens, 1 T1 Land Factory.
-Medium: Static Objective. No Opposition. UCap 100.
--]]
function Ob1_Med()
    ScenarioInfo.MissionNumber = 1
    LOG('Mission Number: '.. ScenarioInfo.MissionNumber)
    LOG('Begin Objective 1.')

    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb1103 + categories.ueb1101 + categories.ueb0101) --Allow T1 Mass Extractor, PGen and Land Factory
    if Debug then LOG('Added ueb1103, ueb1101, ueb0101 to build list.') end

    ExtraFunc.SpawnPlayerCommanders()
    ScenarioInfo.Player1CDR:AddUnitCallback(ExtraFunc.Player1Kill, 'OnKilled')
    if Debug then LOG('Spawned Commander and added death callback to fail the operation.') end

    -------------------------------------
    --Dialog: Build a base instructions.
    -------------------------------------

    Tasks.Objective_1()
    ScenarioInfo.Ob1Group = Objectives.CreateGroup('Ob1Group_Complete', function()
        LOG('All Objectives for Mission 1 Complete. Starting Objective 2.')

        ---------------------------------------------
        --DIALOG: Base built, uploading PD and walls.
        ---------------------------------------------

        ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb2101 + categories.ueb5101) --Allow T1 PD, Walls
        if Debug then LOG('Added ueb2101 and ueb5101 to build list.') end

        --Ob2_Med()
    end)
    ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1)
    ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1a)
    ScenarioInfo.Ob1Group:AddObjective(ScenarioInfo.Ob1b)
    if Debug then LOG('Created Objective 1, 1a, 1b and added to objective group.') end
end

