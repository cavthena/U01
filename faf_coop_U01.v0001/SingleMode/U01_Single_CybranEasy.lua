local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local BuildMgr = import('/maps/faf_coop_U01.v0001/manager_UnitBuilder.lua')
local SpawnMgr = import('/maps/faf_coop_U01.v0001/manager_UnitSpawner.lua')
local EngiMgr = import('/maps/faf_coop_U01.v0001/manager_BaseEngineer.lua')
local plaAtk = import('/maps/faf_coop_U01.v0001/platoon_AttackFunctions.lua')

--Locals
local Difficulty = ScenarioInfo.Options.Difficulty

-- =======================================BASES============================================
-------------------------------------
--Cybran Outpost Base (COB)
-------------------------------------
function Cybran_Outpost_AI()
    ScenarioInfo.COBEngi = EngiMgr.Start({
        brain            = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker       = 'Cybran_Outpost_Zone',
        baseTag          = 'COBBase',    
        radius           = 25,
        structGroups     = {'Cybran_Outpost_Main_D'..Difficulty, 'Cybran_Outpost_Def_D'.. Difficulty},
        engineers        = {
            T1 = 1, 
            T2 = 0, 
            T3 = 0, 
            SCU = 0},
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1.5, ASSIST = 1, EXP = 0},
        },
    })

    ScenarioInfo.COBWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', 4},
        },
        baseHandle = ScenarioInfo.COBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 150,
        radius = 25,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = 50,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'AttackFormation',
            TargetType = 'cluster',
            RandomizeRoute = false,
        },
        builderTag = 'COBWave',
        mode = 1,
    })

    ScenarioInfo.COBArtyWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0103', 1},
        },
        baseHandle = ScenarioInfo.COBEngi,
        wantFactories = 1,
        priority = 150,
        radius = 25,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = 70,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'AttackFormation',
            TargetType = 'cluster',
            RandomizeRoute = false,
        },
        builderTag = 'COBArtyWave',
        mode = 1,
    })
end

--------------------
--Cybran Main Base
--------------------
function Cybran_MainBase_AI()
    ScenarioInfo.CMBEngi = EngiMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        baseTag = 'CMBBase',
        radius = 32,
        structGroups = {'Cybran_MainBase_Main_D'..Difficulty, 'Cybran_MainBase_Def_D'..Difficulty},
        engineers = {
            T1 = 3,
            T2 = 0,
            T3 = 0,
            SCU = 0,
        },
        difficulty = Difficulty,
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1.5, ASSIST = 1, EXP = 0},
        },
    })

    ScenarioInfo.CMBWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', 8},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        difficulty = Difficulty,
        wantFactories = 3,
        priority = 150,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = 30,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        builderTag = 'CMBWave',
        mode = 1,
    })

    ScenarioInfo.CMBArty = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0103', 4},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 150,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = 30,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        builderTag = 'CMBArty',
        mode = 1,
    })
end

-------------------
--Support Airbase
-------------------
function Cybran_SupportAirBase_AI()
    ScenarioInfo.CSABEngi = EngiMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        baseTag = 'CSABBase',
        radius = 30,
        structGroups = {'Cybran_SupportBase_Main_D'..Difficulty, 'Cybran_SupportBase_Def_D'..Difficulty},
        engineers = {
            T1 = 1,
            T2 = 0,
            T3 = 0,
            SCU = 0,
        },
        difficulty = Difficulty,
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1, ASSIST = 1.5, EXP = 0},
        },
    })

    ScenarioInfo.CSABBomb = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0103', 1},
        },
        baseHandle = ScenarioInfo.CSABEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 50,
        radius = 30,
        rallyMarker = 'Cybran_Airbase_Rally1',
        waveCooldown = 120,
        attackFn = plaAtk.RaidAttack,
        attackData = {
            Category = 'ECO',
            IntelOnly = false,
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            AvoidDef = true,
            RandomizeRoute = false,
        },
        builderTag = 'CSABBomb',
        mode = 2,
        mode2LossThreshold = 0.5,
    })

    ScenarioInfo.CSABInt = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0102', 2},
        },
        baseHandle = ScenarioInfo.CSABEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 100,
        radius = 30,
        rallyMarker = 'Cybran_Airbase_Rally1',
        waveCooldown = 60,
        attackFn = plaAtk.HuntAttack,
        attackData = {
            TargetCategories = {categories.AIR - categories.STRUCTURE},
            Marker = 'Cybran_Airbase_Zone',
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        builderTag = 'CSABInt',
        mode = 2,
        mode2LossThreshold = 0.5,
    })

    ScenarioInfo.CSABScout = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0101', 2},
        },
        baseHandle = ScenarioInfo.CSABEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 120,
        radius = 30,
        rallyMarker = 'Cybran_Airbase_Rally1',
        waveCooldown = 30,
        attackFn = plaAtk.ScoutAttack,
        attackData = {},
        builderTag = 'CSABScout',
        mode = 2,
        mode2LossThreshold = 0.5,
    })
end

-- =======================================COMBAT=============================================
-- AREA_1 ATTACKS --
function AREA1_CybranScoutAttack()
    ScenarioInfo.CybranScoutAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA1_SPAWN_EAST_1', 'AREA1_SPAWN_EAST_2', 'AREA1_SPAWN_EAST_3'},
        composition = {
            {'url0106', 2},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            TargetType = 'closest',
            Formation = 'NoFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 60,
        mode = 4,
        mode4PlatoonCount = 6,
        spawnerTag = 'AREA1_CSA_East',
        spawnSpread = 2,
    }
end

function AREA1_CybranAttackPlatoon()
    local spawnPoint = ScenarioUtils.MarkerToPosition('AREA1_SPAWN_EAST_3')
    local unitList = {'url0106', 'url0107'}
    local waveSize = 8

    --Spawn Units
    local units = {}
    for i = 1, waveSize do
        local unitID = unitList[Random(1, table.getn(unitList))]
        local unit = CreateUnitHPR(unitID, ScenarioInfo.Cybran, spawnPoint[1], spawnPoint[2], spawnPoint[3], 0, 0, 0)
        if unit then
            table.insert(units, unit)
        end
    end

    --Create platoon
    local platoon = ArmyBrains[ScenarioInfo.Cybran]:MakePlatoon('', '')
    ArmyBrains[ScenarioInfo.Cybran]:AssignUnitsToPlatoon(platoon, units, 'Attack', 'GrowthFormation')
    platoon:ForkAIThread(plaAtk.WaveAttack, {
        Formation = 'AttackFormation',
        TargetType = 'cluster',
        RandomizeRoute = false,
    })

    return platoon
end

-- AREA_3 ATTACKS --
function AREA3_CybranWaveAttacks()
    ScenarioInfo.AREA3_Wave1 = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'},
        composition = {
            {'url0107', 4},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 30,
        mode = 2,
        mode2LossThreshold = 0.75,
        spawnerTag = 'AREA3_Wave1',
        spawnSpread = 4,
    }

    ScenarioInfo.AREA3_WaveArty = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'},
        composition = {
            {'url0103', 2},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 60,
        mode = 2,
        mode2LossThreshold = 1,
        spawnerTag = 'AREA3_WaveArty',
        spawnSpread = 4,
    }
end

--AREA_3 attacks after Objective is captured
function AREA3_HoldingAttack()
    ScenarioInfo.AREA3_HoldingAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'},
        composition = {
            {'url0107', 10},
            {'url0103', 4},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.HuntAttack,
        attackData = {
            Blueprints = {'uec9901'},
            Marker = 'AREA3_SPAWNER_CENTER',
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 300,
        mode = 4,
        mode4PlatoonCount = 5,
        spawnerTag = 'AREA3_HoldingAttack',
        spawnSpread = 5,
    }
end