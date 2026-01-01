version = 3 -- Lua Version. Dont touch this
ScenarioInfo = {
    name = "faf_coop_U01",
    description = "Mission 1 of 10",
    preview = '',
    map_version = 1,
    AdaptiveMap = true,
    type = 'campaign_coop',
    starts = true,
    size = {512, 512},
    reclaim = {28843.94, 0},
    map = '/maps/faf_coop_U01.v0001/faf_coop_U01.scmap',
    save = '/maps/faf_coop_U01.v0001/faf_coop_U01_save.lua',
    script = '/maps/faf_coop_U01.v0001/faf_coop_U01_script.lua',
    norushradius = 40,
    Configurations = {
        ['standard'] = {
            teams = {
                {
                    name = 'FFA',
                    armies = {'Player1', 'UEFOutpost', 'Cybran', 'Player2'}
                },
            },
            customprops = {
                ['ExtraArmies'] = STRING( 'ARMY_17 NEUTRAL_CIVILIAN' ),
            },
        },
    },
}
