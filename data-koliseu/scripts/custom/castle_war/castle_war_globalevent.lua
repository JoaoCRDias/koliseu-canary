local config = {
	days = { 3, 5, 7 }, -- 1 = Sunday, 2 = Monday, ..., 4 = Wednesday
	hour = 20, -- 24h format
	minutes = 00 -- 0-59
}

local function isCastleWarTime(cfg)
	local date = os.date("*t")
	return isInArray(cfg.days, date.wday) and date.hour == cfg.hour and date.min == cfg.minutes
end

local CastleWarOn = GlobalEvent("CastleWarOn")
function CastleWarOn.onThink(interval)
	if isCastleWarTime(config) and not Castle.opened then
		Castle:load()
	end
	return true
end

CastleWarOn:interval(60 * 1000)
CastleWarOn:register()
