local movcastle = MoveEvent()
function movcastle.onStepIn(creature, item, position, fromPosition)
  local player = creature:getPlayer()
  if not player then
    return true
  end

  local guild = player:getGuild()
  if not guild and not player:getGroup():getAccess() then
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need a guild to enter the Castle.")
    player:teleportTo(fromPosition)
    return true
  end

  if player:getLevel() < Castle.config.join.minLevel and not player:getGroup():getAccess() then
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level " .. Castle.config.join.minLevel .. " to enter the Castle.")
    player:teleportTo(fromPosition)
    return true
  end

  return true
end

movcastle:type("stepin")
movcastle:aid(38133)
movcastle:register()

local movexitcastle = MoveEvent()
function movexitcastle.onStepIn(creature, item, position, fromPosition)
  local player = creature:getPlayer()
  if not player then
    return true
  end

  player:teleportTo(Position(1000, 1000, 7))

  return true
end

movexitcastle:type("stepin")
movexitcastle:aid(38134)
movexitcastle:register()

ThronePointsEvents = {} -- [playerGuid] = eventId
ThroneAgonyEvents = {} -- [playerGuid] = eventId

local function addThronePointsTick(playerGuid)
  local player = Player(playerGuid)
  if not player then
    ThronePointsEvents[playerGuid] = nil
    return
  end

  local guild = player:getGuild()
  if not guild then
    ThronePointsEvents[playerGuid] = nil
    return
  end

  -- Stop if player is no longer on the throne tile
  local tile = Tile(player:getPosition())
  local onThrone = false
  if tile then
    local items = tile:getItems()
    if items then
      for i = 1, #items do
        if items[i]:getActionId() == 32231 then
          onThrone = true
          break
        end
      end
    end
  end
  if not onThrone then
    ThronePointsEvents[playerGuid] = nil
    return
  end

  local guildId = guild:getId()
  if not Castle.guildsPoints[guildId] then
    Castle.guildsPoints[guildId] = 0
  end
  Castle.guildsPoints[guildId] = Castle.guildsPoints[guildId] + 1000

  ThronePointsEvents[playerGuid] = addEvent(addThronePointsTick, Castle.config.timeThroneTick * 1000, playerGuid)
end

local function throneAgonyTick(playerGuid)
  local player = Player(playerGuid)
  if not player then
    ThroneAgonyEvents[playerGuid] = nil
    return
  end

  -- Stop if player is no longer on the throne tile
  local tile = Tile(player:getPosition())
  local onThrone = false
  if tile then
    local items = tile:getItems()
    if items then
      for i = 1, #items do
        if items[i]:getActionId() == 32231 then
          onThrone = true
          break
        end
      end
    end
  end
  if not onThrone then
    ThroneAgonyEvents[playerGuid] = nil
    return
  end

  local damage = math.ceil(player:getMaxHealth() * (Castle.config.throne.agonyPercent / 100))
  doTargetCombatHealth(0, player, COMBAT_AGONYDAMAGE, -damage, -damage, CONST_ME_AGONY)

  ThroneAgonyEvents[playerGuid] = addEvent(throneAgonyTick, Castle.config.throne.agonyTickInterval, playerGuid)
end

local thronePontuation = MoveEvent()
thronePontuation:type("stepin")

function thronePontuation.onStepIn(creature, item, position, fromPosition)
  local player = creature:getPlayer()
  if not player then
    return false
  end

  local guild = player:getGuild()
  if not guild then
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need a guild to capture the throne.")
    return false
  end

  local guid = player:getGuid()

  if ThronePointsEvents[guid] then
    stopEvent(ThronePointsEvents[guid])
  end
  ThronePointsEvents[guid] = addEvent(addThronePointsTick, Castle.config.timeThroneTick * 1000, guid)

  if ThroneAgonyEvents[guid] then
    stopEvent(ThroneAgonyEvents[guid])
  end
  ThroneAgonyEvents[guid] = addEvent(throneAgonyTick, Castle.config.throne.agonyTickInterval, guid)
  return true
end

thronePontuation:aid(32231)
thronePontuation:register()

local thronePontuationOut = MoveEvent()
thronePontuationOut:type("stepout")

function thronePontuationOut.onStepOut(creature, item, position, fromPosition)
  local player = creature:getPlayer()
  if not player then
    return false
  end

  local guid = player:getGuid()
  if ThronePointsEvents[guid] then
    stopEvent(ThronePointsEvents[guid])
    ThronePointsEvents[guid] = nil
  end
  if ThroneAgonyEvents[guid] then
    stopEvent(ThroneAgonyEvents[guid])
    ThroneAgonyEvents[guid] = nil
  end
  return true
end

thronePontuationOut:aid(32231)
thronePontuationOut:register()
