local BattlePassDB = {}

-- Get current active season
function BattlePassDB.getCurrentSeason()
    local query = db.storeQuery("SELECT * FROM `battlepass_seasons` WHERE `active` = 1 ORDER BY `id` DESC LIMIT 1")
    if not query then
        return nil
    end

    local season = {
        id = result.getNumber(query, "id"),
        name = result.getString(query, "name"),
        release_date = result.getNumber(query, "release_date"),
        active = result.getNumber(query, "active") == 1,
        mount_id = result.getNumber(query, "mount_id")
    }

    result.free(query)
    return season
end

-- Get all available seasons
function BattlePassDB.getAllSeasons()
    local query = db.storeQuery("SELECT * FROM `battlepass_seasons` WHERE `active` = 1 ORDER BY `id` ASC")
    if not query then
        return {}
    end

    local seasons = {}
    repeat
        local season = {
            id = result.getNumber(query, "id"),
            name = result.getString(query, "name"),
            release_date = result.getNumber(query, "release_date"),
            active = result.getNumber(query, "active") == 1,
            mount_id = result.getNumber(query, "mount_id")
        }
        table.insert(seasons, season)
    until not result.next(query)

    result.free(query)
    return seasons
end

-- Get season by ID
function BattlePassDB.getSeasonById(seasonId)
    local query = db.storeQuery(string.format(
        "SELECT * FROM `battlepass_seasons` WHERE `id` = %d",
        seasonId
    ))
    if not query then
        return nil
    end

    local season = {
        id = result.getNumber(query, "id"),
        name = result.getString(query, "name"),
        release_date = result.getNumber(query, "release_date"),
        active = result.getNumber(query, "active") == 1,
        mount_id = result.getNumber(query, "mount_id")
    }

    result.free(query)
    return season
end

-- Get player's battle pass data for a specific season
function BattlePassDB.getPlayerBattlePass(playerId, seasonId)
    local query = db.storeQuery(string.format(
        "SELECT * FROM `player_battlepass` WHERE `player_id` = %d AND `season_id` = %d",
        playerId, seasonId
    ))

    if not query then
        return nil
    end

    local data = {
        player_id = result.getNumber(query, "player_id"),
        season_id = result.getNumber(query, "season_id"),
        activation_time = result.getNumber(query, "activation_time"),
        last_claim_time = result.getNumber(query, "last_claim_time"),
        claimed_days = result.getString(query, "claimed_days") or ""
    }

    -- Calculate claimed count
    if data.claimed_days ~= "" then
        local count = 0
        for _ in string.gmatch(data.claimed_days, "[^,]+") do
            count = count + 1
        end
        data.claimed_count = count
    else
        data.claimed_count = 0
    end

    result.free(query)
    return data
end

-- Activate battle pass for a player
function BattlePassDB.activateBattlePass(playerId, seasonId)
    local currentTime = os.time()
    local success = db.query(string.format(
        "INSERT INTO `player_battlepass` (`player_id`, `season_id`, `activation_time`, `last_claim_time`, `claimed_days`) VALUES (%d, %d, %d, 0, '')",
        playerId, seasonId, currentTime
    ))

    return success
end

-- Mark a day as claimed
function BattlePassDB.claimDay(playerId, seasonId, day)
    -- Get current claimed days
    local playerBP = BattlePassDB.getPlayerBattlePass(playerId, seasonId)
    if not playerBP then
        return false
    end

    -- Parse already claimed days into a set
    local claimedDaysSet = {}
    local claimedDaysList = {}

    if playerBP.claimed_days ~= "" then
        for d in string.gmatch(playerBP.claimed_days, "([^,]+)") do
            local dayNum = tonumber(d)
            if dayNum then
                claimedDaysSet[dayNum] = true
                table.insert(claimedDaysList, dayNum)
            end
        end
    end

    -- Check if already claimed
    if claimedDaysSet[day] then
        return false -- Already claimed
    end

    -- Add new day to the list
    table.insert(claimedDaysList, day)

    -- Sort the list to maintain order
    table.sort(claimedDaysList)

    -- Convert to comma-separated string
    local newClaimedDays = table.concat(claimedDaysList, ",")

    -- Update database
    local currentTime = os.time()
    local success = db.query(string.format(
        "UPDATE `player_battlepass` SET `claimed_days` = '%s', `last_claim_time` = %d WHERE `player_id` = %d AND `season_id` = %d",
        newClaimedDays, currentTime, playerId, seasonId
    ))

    return success
end

-- Get rewards for a season (from config, not database for Season 1)
-- This is a placeholder - Season 1 uses config.lua
function BattlePassDB.getSeasonRewards(seasonId)
    -- For Season 1, rewards are in config.lua
    -- Future seasons can be stored in database
    return nil
end

return BattlePassDB
