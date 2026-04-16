--[[
	Task System Loader
	Loads all task system files from lib/task_system
]]

-- Load task library first
dofile(DATA_DIRECTORY .. '/lib/task_system/task_lib.lua')

-- Load task action (registers the item action)
dofile(DATA_DIRECTORY .. '/lib/task_system/task_action.lua')

-- Load task creaturescript
dofile(DATA_DIRECTORY .. '/lib/task_system/task_creaturescript.lua')

-- Load task globalevent
dofile(DATA_DIRECTORY .. '/lib/task_system/task_globalevent.lua')
