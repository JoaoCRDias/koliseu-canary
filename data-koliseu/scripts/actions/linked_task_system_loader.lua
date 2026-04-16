--[[
	Linked Task System Loader
	Loads all linked task system files from lib/linked_task_system
	The library (linked_task_lib.lua) is already loaded via lib.lua
]]

-- Load totem action (registers action IDs)
dofile(DATA_DIRECTORY .. '/lib/linked_task_system/linked_task_action.lua')

-- Load kill tracking creature event
dofile(DATA_DIRECTORY .. '/lib/linked_task_system/linked_task_creaturescript.lua')

-- Load startup event (registers monster types)
dofile(DATA_DIRECTORY .. '/lib/linked_task_system/linked_task_globalevent.lua')
