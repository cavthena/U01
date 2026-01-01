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
        radius           = 40,
        structGroups     = {'Cybran_Outpost_Main_D'..Difficulty, 'Cybran_Outpost_Def_D'.. Difficulty},
        engineers        = {
            T1 = {1,2,3}, 
            T2 = {0,0,0}, 
            T3 = {0,0,0}, 
            SCU = {0,0,0}},
        difficulty       = Difficulty,
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1.5, ASSIST = 1, EXP = 0},
        },
    })

    local cooldown = {25,15,10}

    ScenarioInfo.COBWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', {4, 6, 8}},
        },
        baseHandle = ScenarioInfo.COBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 150,
        radius = 40,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = cooldown[Difficulty],
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'AttackFormation',
            TargetType = 'cluster',
        },
        builderTag = 'COBWave',
        mode = 1,
    })

    ScenarioInfo.COBArtyWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0103', {0,2,4}},
        },
        baseHandle = ScenarioInfo.COBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 150,
        radius = 40,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = cooldown[Difficulty],
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'AttackFormation',
            TargetType = 'cluster',
        },
        builderTag = 'COBArtyWave',
        mode = 1,
    })
end

--------------------
--Cybran Main Base
--------------------
function Cybran_MainBase_AI(percent, frequency)
    ScenarioInfo.CMBEngi = EngiMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        baseTag = 'CMBBase',
        radius = 42,
        structGroups = {'Cybran_MainBase_Main_D'..Difficulty, 'Cybran_MainBase_Def_D'..Difficulty},
        engineers = {
            T1 = {3,5,6},
            T2 = {0,0,0},
            T3 = {0,0,0},
            SCU = {0,0,0},
        },
        difficulty = Difficulty,
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1.5, ASSIST = 1, EXP = 0},
        },
    })

    local wavecd = {30,20,15}
    ScenarioInfo.CMBWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', {10,14,18}},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        difficulty = Difficulty,
        wantFactories = 3,
        priority = 150,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = wavecd[Difficulty],
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
        },
        builderTag = 'CMBWave',
        mode = 1,
        escalationPercent = percent,
        escalationFrequency = frequency,
    })

    ScenarioInfo.CMBArty = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'LAND',
        composition = {
            {'url0103', {4,6,8}},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 150,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally1',
        waveCooldown = wavecd[Difficulty],
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
        },
        builderTag = 'CMBArty',
        mode = 1,
        escalationPercent = percent,
        escalationFrequency = frequency,
    })

    ScenarioInfo.CMBScout = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_MainBase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0101', {0,2,2}},
        },
        baseHandle = ScenarioInfo.CMBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 100,
        radius = 42,
        rallyMarker = 'Cybran_MainBase_Rally2',
        waveCooldown = wavecd[Difficulty],
        attackFn = plaAtk.ScoutAttack,
        attackData = {
            IntelOnly = true,
        },
        builderTag = 'CMBScout',
        mode = 2,
        mode2LossThreshold = 1,
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
            T1 = {1,2,4},
            T2 = {0,0,0},
            T3 = {0,0,0},
            SCU = {0,0,0},
        },
        difficulty = Difficulty,
        engineerFactoryPriority = 200,
        engineerFactoryCount = 1,
        tasks = {
            weights = {BUILD = 1, ASSIST = 1.5, EXP = 0},
        },
    })

    local bombcd = {60,30,20}
    ScenarioInfo.CSABBomb = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0103', {1,2,2}},
        },
        baseHandle = ScenarioInfo.CSABEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 50,
        radius = 30,
        rallyMarker = 'Cybran_Airbase_Rally1',
        waveCooldown = bombcd[Difficulty],
        attackFn = plaAtk.RaidAttack,
        attackData = {
            Category = 'ECO',
            IntelOnly = false,
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
            AvoidDef = true,
        },
        builderTag = 'CSABBomb',
        mode = 2,
        mode2LossThreshold = 0.5,
    })

    local intcd = {30,15,5}
    ScenarioInfo.CSABInt = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Airbase_Zone',
        domain = 'AIR',
        composition = {
            {'ura0102', {2,3,5}},
        },
        baseHandle = ScenarioInfo.CSABEngi,
        difficulty = Difficulty,
        wantFactories = 2,
        priority = 100,
        radius = 30,
        rallyMarker = 'Cybran_Airbase_Rally1',
        waveCooldown = intcd[Difficulty],
        attackFn = plaAtk.HuntAttack,
        attackData = {
            TargetCategories = {categories.AIR - categories.STRUCTURE},
            Marker = 'Cybran_Airbase_Zone',
            Formation = 'AttackFormation',
        },
        builderTag = 'CSABInt',
        mode = 2,
        mode2LossThreshold = 0.5,
    })
end

-- =======================================COMBAT=============================================
-- AREA_1 ATTACKS --
function AREA1_CybranScoutAttack(waveSize, platooncount, cooldown)
    ScenarioInfo.CybranScoutAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA1_SPAWN_EAST_1', 'AREA1_SPAWN_EAST_2', 'AREA1_SPAWN_EAST_3'},
        composition = {
            {'url0106', waveSize},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            TargetType = 'closest',
            Formation = 'NoFormation',
        },
        waveCooldown = cooldown,
        mode = 4,
        mode4PlatoonCount = platooncount,
        spawnerTag = 'AREA1_CSA_East',
        spawnSpread = 2,
    }
end

function AREA1_CybranAttackPlatoon(spawnmarker)
    local spawnPoint = ScenarioUtils.MarkerToPosition(spawnmarker)
    local unitList = {'url0106', 'url0107'}
    local waveSize = {5,8,12}

    --Wave Size
    local count
    if type(waveSize) == 'number' then
        count = math.max(1, waveSize)
    elseif type(waveSize) == 'table' then
        count = waveSize[Difficulty]
    else
        WARN('Unable to determine waveSize type.')
    end

    --Spawn Units
    local units = {}
    for i = 1, count do
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
    })

    return platoon
end

-- AREA_2 ATTACKS --
function AREA2_CybranRaidPlatoon()
    ScenarioInfo.AREA2_Raid1 = SpawnMgr.Start{
        brain           = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker     = {'AREA2_SPAWN_MID_1', 'AREA1_SPAWN_WEST_1'},
        composition     = {
            {'url0106', {0,4,6}},
        },
        difficulty      = Difficulty,
        attackFn        = plaAtk.RaidAttack,
        attackData      = {
            Formation = 'GrowthFormation',
            AvoidDef = true,
            TargetType = 'ECO',
        },
        waveCooldown = 30,
        mode = 2,
        mode2LossThreshold = 0.8,
        spawnerTag = 'AREA2RAID1',
        spawnSpread = 3,
    }
end

-- AREA_3 ATTACKS --
function AREA3_CybranWaveAttacks(wavecd, artycd, markers)
    ScenarioInfo.AREA3_Wave1 = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'},
        composition = {
            {'url0107', {4,5,6}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
        },
        waveCooldown = wavecd,
        mode = 1,
        spawnerTag = 'AREA3_Wave1',
        spawnSpread = 4,
    }

    ScenarioInfo.AREA3_WaveArty = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'},
        composition = {
            {'url0103', {2,3,5}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1},
            Formation = 'AttackFormation',
        },
        waveCooldown = artycd,
        mode = 1,
        spawnerTag = 'AREA3_WaveArty',
        spawnSpread = 4,
    }
end

function AREA3_OutpostAttacks()
    ScenarioInfo.AREA3_TargetAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'},
        composition = {
            {'url0107', {8,8,12}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'closest',
            TargetArmy = {ScenarioInfo.UEFOutpost},
            Formation = 'AttackFormation',
        },
        waveCooldown = 30,
        mode = 1,
        spawnerTag = 'AREA3_TargetAttack',
        spawnSpread = 4,
    }
end

function AREA3_MassiveWaveAttack()
    ScenarioInfo.AREA3_MassiveAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'},
        composition = {
            {'url0107', {0,0,20}},
            {'url0103', {0,0,10}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.UEFOutpost},
            Formation = 'AttackFormation',
        },
        waveCooldown = 60,
        mode = 1,
        mode2LossThreshold = 1,
        spawnerTag = 'AREA3_Massive',
        spawnSpread = 8,
    }
end

--AREA_3 attacks after Objective is captured
function AREA3_HoldingAttack()
    ScenarioInfo.AREA3_HoldingAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'},
        composition = {
            {'url0107', {10,0,0}},
            {'url0103', {4,0,0}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.HuntAttack,
        attackData = {
            Blueprints = {'uec1902'},
            Marker = 'AREA3_SPAWNER_CENTER',
            Formation = 'AttackFormation',
        },
        waveCooldown = 300,
        mode = 4,
        mode4PlatoonCount = 5,
        spawnerTag = 'AREA3_HoldingAttack',
        spawnSpread = 5,
    }
end

function AREA3_HoldingProgressive(count, percent, markers)
    ScenarioInfo.AREA3_HoldingProgressive = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = markers,
        composition = {
            {'url0107', {0,5,0}},
            {'url0103', {0,2,0}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.HuntAttack,
        attackData = {
            Blueprints = {'uec1902'},
            Marker = 'AREA3_SPAWNER_CENTER',
            Formation = 'AttackFormation',
        },
        waveCooldown = 300,
        mode = 4,
        mode4PlatoonCount = count,
        spawnerTag = 'AREA3_HoldingProgressive',
        spawnSpread = 5,
        escalationPercent = percent,
        escalationFrequency = 1,
    }
end