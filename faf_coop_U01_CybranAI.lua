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
end

function Cybran_Outpost_Wave()
    local cooldown = {25,15,10}

    ScenarioInfo.COBWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', {3, 5, 8}},
        },
        baseHandle = ScenarioInfo.COBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 100,
        radius = 40,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = cooldown[Difficulty],
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'GrowthFormation',
            TargetType = 'cluster',
        },
        builderTag = 'COBWave',
        mode = 1,
    })
end

function Cybran_Outpost_Raid()
    ScenarioInfo.COBRaid = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0106', {0,2,4}},
        },
        baseHandle = ScenarioInfo.COBEngi,
        difficulty = Difficulty,
        wantFactories = 1,
        priority = 125,
        radius = 40,
        rallyMarker = 'Cybran_Outpost_Rally2',
        waveCooldown = 30,
        attackFn = plaAtk.RaidAttack,
        attackData = {
            TargetType = 'SMT',
            Formation = 'GrowthFormation',
        },
        builderTag = 'COBRaid',
        mode = 2,
        mode2LossThreshold = 0.5,
    })
end

function Cybran_Outpost_BigWave()
    ScenarioInfo.COBBigWave = BuildMgr.Start({
        brain = ArmyBrains[ScenarioInfo.Cybran],
        baseMarker = 'Cybran_Outpost_Zone',
        domain = 'LAND',
        composition = {
            {'url0107', {0,0,10}},
            {'url0103', {0,0,4}},
        },
        baseHandle = ScenarioInfo.COBEngi,
        difficulty = Difficulty,
        wantFactories = 2,
        priority = 150,
        radius = 40,
        rallyMarker = 'Cybran_Outpost_Rally1',
        waveCooldown = 120,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Formation = 'AttackFormation',
            TargetType = 'concentration',
        },
        builderTag = 'COBBigWave',
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
end

-- =======================================COMBAT=============================================
-- Cybran Scout harassment waves in AREA_1
function AREA1_CybranScoutAttack(waveSize, wavecount, cooldown)
    ScenarioInfo.CybranScoutAttack_East = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA1_SPAWN_EAST_1', 'AREA1_SPAWN_EAST_2', 'AREA1_SPAWN_EAST_3'},
        composition = {
            {'url0106', waveSize, 0},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            TargetType = 'closest',
            Formation = 'NoFormation',
        },
        waveCooldown = cooldown[Difficulty],
        mode = 3,
        mode3WaveCount = wavecount[Difficulty],
        spawnerTag = 'AREA1_CSA_East',
        spawnSpread = 2,
    }

    if ScenarioInfo.Coop then
        ScenarioInfo.CybranScoutAttack_West = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA1_SPAWN_WEST_1', 'AREA1_SPAWN_WEST_2', 'AREA1_SPAWN_WEST_3'},
        composition = {
            {'url0106', waveSize, 0},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            TargetType = 'closest',
            Formation = 'NoFormation',
        },
        waveCooldown = cooldown[Difficulty],
        mode = 3,
        mode3WaveCount = wavecount[Difficulty],
        spawnerTag = 'AREA1_CSA_West',
        spawnSpread = 2,
    }
    end
end

--Cybran Large attack wave in AREA_1
function AREA1_CybranAttackPlatoon()
    local spawnPoint = ScenarioUtils.MarkerToPosition('AREA1_SPAWN_MID_1')
    local unitList = {'url0106', 'url0107'}
    local waveSize = {5,8,12}

    if ScenarioInfo.Coop then
        waveSize = {10,16,24}
    end

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

--AREA_2 Cybran Spawn attacks
function AREA2_CybranRaidPlatoon()
    ScenarioInfo.AREA2_Raid1 = SpawnMgr.Start{
        brain           = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker     = 'AREA2_SPAWN_MID_1',
        composition     = {
            {'url0106', {0,0,6}},
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
        mode2LossThreshold = 1,
        spawnerTag = 'AREA2RAID1',
        spawnSpread = 3,
    }
end

--AREA_3 Cybran Spawn attacks
function AREA3_CybranWaveAttacks()
    ScenarioInfo.AREA3_Wave1 = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'},
        composition = {
            {'url0107', {2,3,4}},
            {'url0106', {4,4,4}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.Player1, ScenarioInfo.Player2},
            Formation = 'AttackFormation',
        },
        waveCooldown = 15,
        mode = 1,
        spawnerTag = 'AREA3_Wave1',
        spawnSpread = 4,
    }

    if Difficulty == 2 then
        ScenarioInfo.AREA3_Wave2 = SpawnMgr.Start{
            brain = ArmyBrains[ScenarioInfo.Cybran],
            spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'},
            composition = {
                {'url0107', {0,4,6}},
                {'url0106', {0,6,6}},
            },
            difficulty = Difficulty,
            attackFn = plaAtk.WaveAttack,
            attackData = {
                Type = 'closest',
                TargetArmy = {ScenarioInfo.UEFOutpost},
                Formation = 'GrowthFormation',
            },
            waveCooldown = 60,
            mode = 1,
            spawnerTag = 'AREA3_Wave2',
            spawnSpread = 4,
        }
    end
end

function AREA3_CybranRaidAttacks()
    ScenarioInfo.AREA3_Raid1 = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER'},
        composition = {
            {'url0106', {4,4,0}},
            {'url0107', {0,0,4}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.RaidAttack,
        attackData = {
            Category = 'ECO',
            TargetArmy = {ScenarioInfo.Player1, ScenarioInfo.Player2},
            Formation = 'NoFormation',
        },
        waveCooldown = 30,
        mode = 1,
        spawnerTag = 'AREA3_Raid1',
        spawnSpread = 3,
    }
end

function AREA3_MassiveWaveAttack()
    ScenarioInfo.AREA3_MassiveAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_WEST', 'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'},
        composition = {
            {'url0107', {0,20,0}},
            {'url0103', {0,8,0}},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.UEFOutpost},
            Formation = 'AttackFormation',
        },
        waveCooldown = 30,
        mode = 2,
        mode2LossThreshold = 1,
        spawnerTag = 'AREA3_Massive',
        spawnSpread = 8,
    }
end

function AREA3_ProgressiveAttack(onComplete)
    ScenarioInfo.AREA3_ProgressiveAttack = SpawnMgr.Start{
        brain = ArmyBrains[ScenarioInfo.Cybran],
        spawnMarker = {'AREA3_SPAWNER_CENTER', 'AREA3_SPAWNER_EAST'},
        composition = {
            {'url0106', {0,0,5}, 1},
            {'url0107', {0,0,2}, 1},

            {'url0106', {0,0,2}, 3},
            {'url0107', {0,0,5}, 3},

            {'url0106', {0,0,3}, 5},
            {'url0107', {0,0,3}, 5},
            {'url0103', {0,0,2}, 5},

            {'url0107', {0,0,10}, 8},
            {'url0103', {0,0,5}, 8},
        },
        difficulty = Difficulty,
        attackFn = plaAtk.WaveAttack,
        attackData = {
            Type = 'cluster',
            TargetArmy = {ScenarioInfo.UEFOutpost},
            Formation = 'AttackFormation',
        },
        waveCooldown = 300,
        mode = 3,
        mode3WaveCount = 10,
        spawnerTag = 'AREA3_Progressive',
        spawnSpread = 8,
        onMode3Complete = onComplete,
    }
end

--AREA_3 attacks after Objective is captured
function AREA3_HoldingAttacks(stage)
    if stage == 1 then
        ScenarioInfo.AREA3_HoldingAttack1 = SpawnMgr.Start{
            brain = ArmyBrains[ScenarioInfo.Cybran],
            spawnMarker = 'AREA3_SPAWNER_EAST',
            composition = {
                {'url0106', {2,4,4}, 1},
            },
            difficulty = Difficulty,
            attackFn = plaAtk.HuntAttack,
            attackData = {
                Blueprints = {'uec1902'},
                Marker = 'AREA3_SPAWNER_EAST',
                Vulnerable = false,
            },
            waveCooldown = 300,
            mode = 4,
            mode4PlatoonCount = 10,
            spawnerTag = 'AREA3_Counter1',
            spawnSpread = 4,
        }
        return
    end
    if stage == 2 then
        ScenarioInfo.AREA3_HoldingAttack2 = SpawnMgr.Start{
            brain = ArmyBrains[ScenarioInfo.Cybran],
            spawnMarker = 'AREA3_SPAWNER_CENTER',
            composition = {
                {'url0107', {8,8,10}, 1},
            },
            difficulty = Difficulty,
            attackFn = plaAtk.HuntAttack,
            attackData = {
                Blueprints = {'uec1902'},
                Marker = 'AREA3_SPAWNER_CENTER',
                Vulnerable = false,
            },
            waveCooldown = 240,
            mode = 4,
            mode4PlatoonCount = 6,
            spawnerTag = 'AREA3_Counter2',
            spawnSpread = 4,
        }
        return
    end
    if stage == 3 then
        ScenarioInfo.AREA3_HoldingAttack3 = SpawnMgr.Start{
            brain = ArmyBrains[ScenarioInfo.Cybran],
            spawnMarker = 'AREA3_SPAWNER_WEST',
            composition = {
                {'url0103', {1,3,6}, 1},
            },
            difficulty = Difficulty,
            attackFn = plaAtk.HuntAttack,
            attackData = {
                Blueprints = {'uec1902'},
                Marker = 'AREA3_SPAWNER_WEST',
                Vulnerable = false,
            },
            waveCooldown = 120,
            mode = 4,
            mode4PlatoonCount = 4,
            spawnerTag = 'AREA3_Counter3',
            spawnSpread = 4,
        }
        return
    end
end