--AI and Testing Buffs.

local Buff = import('/lua/sim/Buff.lua')

--Testing Buff
BuffBlueprint{
    Name = 'Income_x2',
    DisplayName = 'Income_x2',
    BuffType = 'ECON_PROD',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        EnergyProduction = {Mult = 10.0},
        MassProduction = {Mult = 10.0},
        BuildRate = {Mult = 10.0}
    },
}

--AI Buff to allow competing with Player
BuffBlueprint{
    Name = 'AIEconBuff',
    DisplayName = 'AIEconBuff',
    BuffType = 'ECON_PROD',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        EnergyProduction = {Mult = 2.5},
        MassProduction = {Mult = 2.5},
    },
}

BuffBlueprint{
    Name = 'AIConBuff',
    DisplayName = 'AIConBuff',
    BuffType = 'ECON_PROD',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        BuildRate = {Mult = 2},
    },
}

BuffBlueprint{
    Name = 'AIFuelBuff',
    DisplayName = 'AIFuelBuff',
    BuffType = 'FUELRATIO',
    Stacks = 'REPLACE',
    Duration = -1,
    Value = 1,
    Affects = {},
}

-- ========================BUFF FUNCTIONS======================================
--AI Fuel Buff
function FuelAIBuff(armyIndex)
    local AIR_CATS = categories.AIR - categories.FACTORY

    while true do
        local brain = ArmyBrains[armyIndex]
        if brain then
            local units = brain:GetListOfUnits(AIR_CATS)
            for _, u in ipairs(units or {}) do
                if u and not u.Dead and EntityCategoryContains(AIR_CATS, u) then
                    if not Buff.HasBuff(u, 'AIFuelBuff') then
                        Buff.ApplyBuff(u, 'AIFuelBuff')
                    end
                end
            end
        end
        WaitSeconds(60)
    end
end

--AI income and build buff
function EnableAIBuff(armyIndex)
    local ECO_CATS = categories.MASSEXTRACTION + categories.MASSFABRICATION + categories.ENERGYPRODUCTION
    local BUILD_CATS = categories.ENGINEER + categories.FACTORY + categories.COMMAND + categories.SUBCOMMANDER

    while true do
        local brain = ArmyBrains[armyIndex]
        if brain then
            local units = brain:GetListOfUnits(ECO_CATS + BUILD_CATS)
            for _, u in ipairs(units or {}) do
                if u and not u.Dead and EntityCategoryContains(ECO_CATS, u) then
                    if not Buff.HasBuff(u, 'AIEconBuff') then
                        Buff.ApplyBuff(u, 'AIEconBuff')
                    end
                elseif u and not u.Dead and EntityCategoryContains(BUILD_CATS, u) then
                    if not Buff.HasBuff(u, 'AIConBuff') then
                        Buff.ApplyBuff(u, 'AIConBuff')
                    end
                end
            end
        end
        --ArmyBrains[armyIndex]:GiveResource('MASS', 1000)
        --ArmyBrains[armyIndex]:GiveResource('ENERGY', 20000)
        WaitSeconds(5)
    end
end

--Player Testing Buff
function EnableIncomeBuffForArmy(armyIndex)
    local ECO_CATS = categories.ENGINEER + categories.FACTORY + categories.COMMAND + categories.SUBCOMMANDER
                   + categories.MASSEXTRACTION + categories.MASSFABRICATION + categories.ENERGYPRODUCTION

    while true do
        local brain = ArmyBrains[armyIndex]
        if brain then
            local units = brain:GetListOfUnits(ECO_CATS, false)
            for _, u in units do
                if u and not u.Dead and EntityCategoryContains(ECO_CATS, u) then
                    if not Buff.HasBuff(u, 'Income_x2') then
                        Buff.ApplyBuff(u, 'Income_x2')
                    end
                end
            end
        end
        WaitSeconds(5)
    end
end