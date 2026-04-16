function Player.sendTakeScreenshot(self, screenshotType)
	local msg = NetworkMessage()
	msg:addByte(0x75)
	msg:addByte(screenshotType)

	msg:sendToPlayer(self)
	msg:delete()
end

local testeTalkaction = TalkAction("/teste")

function testeTalkaction.onSay(player, words, param)
	local params = param:split(",")

	local screenshotType = tonumber(params[1]) or 0

	player:sendTakeScreenshot(screenshotType)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "screenshotType: " .. screenshotType .. ".")

	return true
end

testeTalkaction:separator(" ")
testeTalkaction:groupType("god")
testeTalkaction:register()

function Player.sendTakeScreenshotUm(self, screenshotType, unknown)
	local msg = NetworkMessage()
	msg:addByte(0x75)
	msg:addByte(screenshotType)
	msg:addByte(unknown)

	msg:sendToPlayer(self)
	msg:delete()
end

local testeTalkactionUm = TalkAction("/testeum")

function testeTalkactionUm.onSay(player, words, param)
	local params = param:split(",")

	local screenshotType = tonumber(params[1]) or 0
	local unknown = tonumber(params[2]) or 0

	player:sendTakeScreenshotUm(screenshotType, unknown)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "screenshotType: " .. screenshotType .. ", unknown: " .. unknown .. ".")

	return true
end

testeTalkactionUm:separator(" ")
testeTalkactionUm:groupType("god")
testeTalkactionUm:register()

function Player.sendTakeScreenshotDois(self, screenshotType, unknown, skillId)
	local msg = NetworkMessage()
	msg:addByte(0x75)
	msg:addByte(screenshotType)
	msg:addByte(unknown)
	msg:addU16(skillId)

	msg:sendToPlayer(self)
	msg:delete()
end

local testeTalkactionDois = TalkAction("/testedois")

function testeTalkactionDois.onSay(player, words, param)
	local params = param:split(",")

	local screenshotType = tonumber(params[1]) or 0
	local unknown = tonumber(params[2]) or 0
	local skillId = tonumber(params[3]) or 0

	player:sendTakeScreenshotDois(screenshotType, unknown, skillId)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "screenshotType: " .. screenshotType .. ", unknown: " .. unknown .. ", skillId: " .. skillId .. ".")

	return true
end

testeTalkactionDois:separator(" ")
testeTalkactionDois:groupType("god")
testeTalkactionDois:register()

function Player.sendTakeScreenshotTres(self, screenshotType, unknown, raceId)
	local msg = NetworkMessage()
	msg:addByte(0x75)
	msg:addByte(screenshotType)
	msg:addU16(raceId)
	msg:addByte(unknown)

	msg:sendToPlayer(self)
	msg:delete()
end

local testeTalkactionTres= TalkAction("/testetres")

function testeTalkactionTres.onSay(player, words, param)
	local params = param:split(",")

	local screenshotType = tonumber(params[1]) or 0
	local raceId = tonumber(params[2]) or 0
	local unknown = tonumber(params[3]) or 0

	player:sendTakeScreenshotTres(screenshotType, unknown, raceId)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "screenshotType: " .. screenshotType .. ", unknown: " .. unknown .. ", raceId: " .. raceId .. ".")
	return true
end

testeTalkactionTres:separator(" ")
testeTalkactionTres:groupType("god")
testeTalkactionTres:register()
