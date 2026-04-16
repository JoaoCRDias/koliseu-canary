-- Core API functions implemented in Lua
dofile(DATA_DIRECTORY .. "/lib/core/load.lua")

-- Quests library
dofile(DATA_DIRECTORY .. "/lib/quests/quest.lua")

-- Tables library
dofile(DATA_DIRECTORY .. "/lib/tables/load.lua")

dofile(DATA_DIRECTORY .. "/lib/custom/second-floor-quests.lua")

dofile(DATA_DIRECTORY .. '/scripts/magic_roulette/roulette.lua')
dofile(DATA_DIRECTORY .. '/lib/custom/simple_crafting_system.lua')
dofile(DATA_DIRECTORY .. '/lib/custom/remove_frags.lua')
dofile(DATA_DIRECTORY .. '/lib/task_system/task_lib.lua')
dofile(DATA_DIRECTORY .. '/lib/linked_task_system/linked_task_lib.lua')
dofile(DATA_DIRECTORY .. '/lib/custom/channel_logger.lua')

-- Events library
dofile(DATA_DIRECTORY .. '/lib/events/castle_war.lua')
