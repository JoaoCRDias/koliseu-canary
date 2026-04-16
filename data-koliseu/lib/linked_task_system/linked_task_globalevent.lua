--[[
	Linked Task System - Startup Registration
	Registers the LinkedTaskKill creature event on all monster types
	that are part of the linked task system.
]]

local linkedTaskStartup = GlobalEvent("LinkedTaskStartup")

function linkedTaskStartup.onStartup()
	local registered = 0
	local failed = 0
	local seen = {}

	for _, room in ipairs(LinkedTask.Rooms) do
		for _, task in ipairs(room.tasks) do
			for _, raceName in ipairs(task.races) do
				if not seen[raceName] then
					seen[raceName] = true
					local mType = MonsterType(raceName)
					if mType then
						mType:registerEvent("LinkedTaskKill")
						registered = registered + 1
					else
						print("[LinkedTask] WARNING: Monster type not found: " .. raceName)
						failed = failed + 1
					end
				end
			end
		end
	end

	print(string.format("[LinkedTask] Registered %d monster types for kill tracking (%d failed)", registered, failed))
end

linkedTaskStartup:register()
