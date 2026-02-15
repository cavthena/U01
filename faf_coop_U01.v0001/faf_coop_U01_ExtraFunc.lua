-- ================================EXTRA FUNCTIONS=================================
-- For use in faf_coop_U01.v0001
--Created by Ruanuku/Cavthena

local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local Cinematics = import('/lua/cinematics.lua')

local OpStrings = import('/maps/faf_coop_U01.v0001/SingleMode/U01_Single_Strings.lua')

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

--Create Rect from Two Markers.
function RectFromTwoMarkers(markerA, markerB)
    local p1 = ScenarioUtils.MarkerToPosition(markerA)
    local p2 = ScenarioUtils.MarkerToPosition(markerB)

    local x0 = math.min(p1[1], p2[1])
    local x1 = math.max(p1[1], p2[1])
    local z0 = math.min(p1[3], p2[3])
    local z1 = math.max(p1[3], p2[3])

    return Rect(x0, z0, x1, z1)
end

--Check for destroyed units.
function AreaAmountDestroyed(brain, rect, fraction, cats)

    local function CountAlive()
        local units = GetUnitsInRect(rect) or {}
        local army = brain:GetArmyIndex()
        local count = 0

        for _, u in units do
            if u and (not u.Dead) and (u:GetArmy() == army) and EntityCategoryContains(cats, u) then
                count = count + 1
            end
        end

        return count
    end

    local total = CountAlive()
    local threshold = total * fraction

    while true do
        WaitSeconds(0.5)

        local alive = CountAlive()
        local diff = total - alive

        if diff >= threshold then
            return true
        end
    end
end

------------------------------------------
--Failure Functions------------------------
------------------------------------------
function ComsDestroyed(Target, NoComs)
    ForkThread(function()
        LockInput()
    
        ScenarioFramework.FlushDialogueQueue()
        ScenarioFramework.PauseUnitDeath(target)
        ScenarioFramework.CDRDeathNISCamera(target)
        
        if not NoComs then
            ScenarioFramework.Dialogue(OpStrings.OpComsDeath, function()
                OperationFailed()
            end, true, nil)
        else
            WaitSeconds(3)
            OperationFailed()
        end
    end)
end

function CommanderDestroyed(commander, NoComs)
    ForkThread(function()
        LockInput()

        ScenarioFramework.FlushDialogueQueue()

        if not NoComs then ScenarioFramework.Dialogue(OpStrings.OpDeath, nil, true, nil) end
        ScenarioFramework.CDRDeathNISCamera(commander)
        WaitSeconds(3)
        OperationFailed()
    end)
end

--------------------------------------------
--End Game Functions------------------------
--------------------------------------------
function OperationFailed()
    ForkThread(function()
        LOG('Operation Ended!')

        for _, o in ScenarioInfo.AssignedObjectives do
            if (o and o.Active) then
                o:ManualResult(false)
            end
        end

        WaitSeconds(1)
        UnlockInput()
        ScenarioFramework.EndOperation(false, true, true)
    end)
end

function OperationComplete()
    ForkThread(function()
        LOG('Operation Complete!')

        for _, o in ScenarioInfo.AssignedObjectives do
            if (o and o.Active) then
                o:ManualResult(false)
            end
        end

        WaitSeconds(1)
        UnlockInput()
        ScenarioFramework.EndOperation(true, true, true)
    end)
end

---------------------------------------------------
--Cinematic Functions------------------------------
---------------------------------------------------