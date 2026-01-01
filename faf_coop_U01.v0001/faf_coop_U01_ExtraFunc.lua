-- ================================EXTRA FUNCTIONS=================================
-- For use in faf_coop_U01.v0001
--Created by Ruanuku/Cavthena

local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

--Spawn in Commanders
function SpawnPlayerCommanders()
    if ScenarioInfo.Coop then
        ScenarioInfo.Player1CDR = ScenarioUtils.CreateArmyUnit('Player1', 'Player1_CDR')
        ScenarioInfo.Player1CDR:PlayCommanderWarpInEffect()
        ScenarioInfo.Player1CDR:SetCustomName(ArmyBrains[ScenarioInfo.Player1].Nickname)

        ScenarioInfo.Player2CDR = ScenarioUtils.CreateArmyUnit('Player2', 'Player2_CDR')
        ScenarioInfo.Player2CDR:PlayCommanderWarpInEffect()
        ScenarioInfo.Player2CDR:SetCustomName(ArmyBrains[ScenarioInfo.Player2].Nickname)
    else
        ScenarioInfo.Player1CDR = ScenarioUtils.CreateArmyUnit('Player1', 'Player1_CDR')
        ScenarioInfo.Player1CDR:PlayCommanderWarpInEffect()
        ScenarioInfo.Player1CDR:SetCustomName(ArmyBrains[ScenarioInfo.Player1].Nickname)
    end
end

--Create Area from Two Markers.
function AreaFromMarkers(areaName, markerA, markerB)
    local p1 = ScenarioUtils.MarkerToPosition(markerA)
    local p2 = ScenarioUtils.MarkerToPosition(markerB)

    local minX = math.min(p1[1], p2[1])
    local minZ = math.min(p1[3], p2[3])
    local maxX = math.max(p1[1], p2[1])
    local maxZ = math.max(p1[3], p2[3])

    Scenario.Areas = Scenario.Areas or {}
    Scenario.Areas[areaName] = {
        type = 'Rect',
        rectangle = {minX, minZ, maxX, maxZ},
    }

    return areaName
end

-- Watch for PD Turrets
local DTT = false
function DetectTurretThread()
    if not DTT then
        DTT = true
        ---------------------
        --DIALOG: PD detected
        ---------------------
    end
end

-- Watch for Air Units
local DAT = false
function DetectAirThread()
    if not DAT then
        DAT = true
        ----------------------
        --DIALOG: Air Detected
        ----------------------

        ScenarioFramework.RemoveRestrictionForAllHumans(categories.ueb0102 + categories.uea0102 + categories.uea0101)
    end
end

function CybranAgentDestroyed()
    ------------------
    --DIALOG: Good job
    ------------------
end

------------------------------------------
--Failure Functions------------------------
------------------------------------------
function ComsDestroyed()
    LOG('Communication Center Destroyed. Mission Failed!')
end

function Player1Kill()
    LOG('Player 1 Commander Destroyed. Mission Failed!')
end

function Player2Kill()
    LOG('Player 2 Commander Destroyed. Mission Failed!')
end