local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local BuildMgr = import('/maps/faf_coop_U01.v0001/manager_UnitBuilder.lua')
local SpawnMgr = import('/maps/faf_coop_U01.v0001/manager_UnitSpawner.lua')
local EngiMgr = import('/maps/faf_coop_U01.v0001/manager_BaseEngineer.lua')
local plaAtk = import('/maps/faf_coop_U01.v0001/platoon_AttackFunctions.lua')

--Locals
local Difficulty = ScenarioInfo.Options.Difficulty

-- =====================BASES================================================
---------------------------
--Cyrban Outpost Base (COB)
---------------------------
function Cybran_Outpost_AI()
    ScenarioInfo.COBEngi = EngiMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        baseTag = 'COBBase',
        radius = 25,
        structGroups = {'Cybran_Outpost_Main_D'..Difficulty, 'Cybran_Outpost_Def_D'.. Difficulty},
        engineers = {
            T1 = 2,
            T2 = 0,
            T3 = 0,
            SCU = 0,
        },
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
        wantFactories = 2,
        priority = 150,
        radius = 25,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = 45,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'AttackFormation',
            TargetType = 'cluster',
            RandomizeRoute = true,
        },
        builderTag = 'COBWave',
        mode = 1,
        escalationPercent = 0.25,
        escalationFrequency = 2,
    })

    ScenarioInfo.COBArtyWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0103', 2},
        },
        baseHandle = ScenarioInfo.COBEngi,
        wantFactories = 1,
        priority = 150,
        radius = 25,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = 50,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'AttackFormation',
            TargetType = 'cluster',
            RandomizeRoute = true,
        },
        builderTag = 'COBArtyWave',
        mode = 1,
        escalationPercent = 0.25,
        escalationFrequency = 4,
    })
end

--------------------------------
--Cybran Main Base--------------
--------------------------------
function Cybran_MainBase_AI()
    ScenarioInfo.CMBEngi = EngiMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        baseTag = 'CMBBase',
        radius = 32,
        structGroups = {'Cybran_MainBase_Main_D'..Difficulty, 'Cybran_MainBase_Def_D'..Difficulty},
        engineers = {
            T1 = 6,
            T2 = 0,
            T3 = 0,
            SCU = 0,
        },
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1.5, ASSIST = 1, EXP = 0},
        },
    })

    ScenarioInfo.CMBRush = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', 4},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        wantFactories = 1,
        priority = 50,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = 20,
        attackFn = plaAtk.HuntAttack,
        attackData = {
            TargetCategories = {categories.LAND - categories.STRUCTURE},
            Marker = 'Cybran_MainBase_Rally1',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        builderTag = 'CMBRush',
        mode = 1,
    })

    ScenarioInfo.CMBWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', 6},
            {'url0106', 2},
            {'url0101', 1},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        wantFactories = 3,
        priority = 150,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = 60,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = true,
        },
        builderTag = 'CMBWave',
        mode = 1,
        escalationPercent = 0.25,
        escalationFrequency = 4,
    })

    ScenarioInfo.CMBArty = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0103', 3},
            {'url0101', 1},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        wantFactories = 1,
        priority = 120,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = 60,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            Bombard = true,
            RandomizeRoute = true,
        },
        builderTag = 'CMBArty',
        mode = 1,
        escalationPercent = 0.15,
        escalationFrequency = 6,
    })

    ScenarioInfo.CMBPatrol = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', 2},
            {'url0106', 4},
            {'url0104', 2},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        wantFactories = 1,
        priority = 100,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = 60,
        attackFn = plaAtk.AreaPatrol,
        attackData = {
            Chain = 'Cyrban_MainBase_Patrol',
            Continuous = false,
            Formation = 'AttackFormation',
        },
        builderTag = 'CMBPatrol',
        mode = 2,
        mode2LossThreshold = 1,
    })
end

--------------------------------
--Cybran Air Base---------------
--------------------------------
function Cybran_SupportAirBase_AI()
    ScenarioInfo.CSABEngi = EngiMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        baseTag = 'CSABBase',
        radius = 30,
        structGroups = {'Cybran_SupportBase_Main_D'..Difficulty, 'Cybran_SupportBase_Def_D'..Difficulty},
        engineers = {
            T1 = 2,
            T2 = 0,
            T3 = 0,
            SCU = 0,
        },
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1, ASSIST = 1.5, EXP = 0}
        },
    })

    ScenarioInfo.CSABScout = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0101', 4},
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

    ScenarioInfo.CSABInt = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0102', 4},
        },
        baseHandle = ScenarioInfo.CSABEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 150,
        radius = 30,
        rallyMarker = 'Cybran_Airbase_Rally1',
        waveCooldown = 30,
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
        escalationPercent = 0.25,
        escalationFrequency = 2,
    })

    ScenarioInfo.CSABBomb = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0103', 3},
        },
        baseHandle = ScenarioInfo.CSABEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 100,
        radius = 30,
        rallyMarker = 'Cybran_Airbase_Rally1',
        waveCooldown = 150,
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
        mode = 1,
        escalationPercent = 0.15,
        escalationFrequency = 3,
    })
end

-- ========================COMBAT============================================
function AREA1_CybranScoutAttack()
    ScenarioInfo.CybranScoutAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA1_SPAWN_EAST_1', 'AREA1_SPAWN_EAST_2', 'AREA1_SPAWN_EAST_3'},
        composition = {
            {'url0106', 2},
        },
        attackFn = plaAtk.WaveAttack,
        attackData = {
            TargetType = 'closest',
            Formation = 'NoFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 60,
        mode = 4,
        mode4PlatoonCount = 20,
        spawnerTag = 'AREA1_CSA_East',
        spawnSpread = 2,
    }
end

function AREA1_CybranAttackPlatoon()
    local spawnPoint = ScenarioUtils.MarkerToPosition('AREA1_SPAWN_EAST_3')
    local unitList = {'url0106', 'url0107'}
    local waveSize = 16

    local units = {}
    for i = 1, waveSize do
        local unitID = unitList[Random(1, table.getn(unitList))]
        local unit = CreateUnitHPR(unitID, ScenarioInfo.Cybran, spawnPoint[1], spawnPoint[2], spawnPoint[3], 0, 0, 0)
        if unit then
            table.insert(units, unit)
        end
    end

    local platoon = ArmyBrains[ScenarioInfo.Cybran]:MakePlatoon('', '')
    ArmyBrains[ScenarioInfo.Cybran]:AssignUnitsToPlatoon(platoon, units, 'Attack', 'GrowthFormation')
    platoon:ForkAIThread(plaAtk.WaveAttack, {
        Formation = 'AttackFormation',
        TargetType = 'cluser',
        RandomizeRoute = false,
    })

    return platoon
end

function AREA3_CybranWaveAttacks(markers)
    ScenarioInfo.AREA3_Wave1 = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = markers,
        composition = {
            {'url0107', 6},
        },
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = true,
        },
        waveCooldown = 70,
        mode = 1,
        spawnerTag = 'AREA3_Wave1',
        spawnSpread = 4,
        escalationPercent = 0.10,
        escalationFrequency = 2,
    }

    ScenarioInfo.AREA3_WaveArty = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = markers,
        composition = {
            {'url0103', 3},
        },
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = true,
        },
        waveCooldown = 85,
        mode = 1,
        spawnerTag = 'AREA3_WaveArty',
        spawnSpread = 4,
    }
end

function AREA3_CybranRaidAttacks(markers)
    ScenarioInfo.AREA3_Raid = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = markers,
        composition = {
            {'url0107', 8},
            {'url0103', 1},
        },
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'closest',
            TargetArmy = {ScenarioInfo.UEFOutpost},
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 100,
        mode = 2,
        mode2LossThreshold = 0.75,
        spawnerTag = 'AREA3_OutpostRaid',
        spawnSpread = 4,
        escalationPercent = 0.15,
        escalationFrequency = 3,
    }
end

function AREA3_HoldingAttack(markersWave, markersKill)
    ScenarioInfo.AREA3_HoldingWave = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = markersWave,
        composition = {
            {'url0107', 4},
            {'url0103', 2},
        },
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'value',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 60,
        mode = 1,
        spawnerTag = "AREA3_HoldingWave",
        spawnSpread = 6,
        escalationPercent = 0.25,
        escalationFrequency = 5,
    }

    ScenarioInfo.AREA3_HoldingKill = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = markersKill,
        composition = {
            {'url0107', 6},
            {'url0103', 2},
        },
        attackFn = plaAtk.HuntAttack,
        attackData = {
            Blueprints = {'uec9901'},
            Marker = 'AREA3_SPAWNER_CENTER',
            Formation = 'AttackFormation',
            RandomizeRoute = false,
        },
        waveCooldown = 300,
        mode = 4,
        mode4PlatoonCount = 12,
        spawnerTag = 'AREA3_HoldingKill',
        spawnSpread = 6,
        escalationPercent = 0.25,
        escalationFrequency = 3,
    }
end