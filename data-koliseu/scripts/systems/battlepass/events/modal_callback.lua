local callback = CreatureEvent("BattlePassWindowCallback")

function callback.onModalWindow(player, modalWindowId, buttonId, choiceId)
    -- Verificar se é o modal do Battle Pass
    if modalWindowId ~= 1000 then
        return true
    end

    -- Botão Close
    if buttonId == 101 then
        player:setStorageValue(Storage.BattlePass.WindowOpen, -1)
        return true
    end

    -- Botão Claim
    if buttonId == 100 then
        -- Verificar se selecionou um dia
        if choiceId == 0 or choiceId == 255 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Please select a reward first.")
            return true
        end

        -- Load modules (evita circular dependency)
        local BattlePassCore = dofile("data-crystal/scripts/systems/battlepass/core.lua")
        local BattlePassWindow = dofile("data-crystal/scripts/systems/battlepass/window.lua")

        local day = choiceId

        -- Get the season the player is viewing from storage
        local viewingSeasonId = player:getStorageValue(Storage.BattlePass.WindowOpen)
        if not viewingSeasonId or viewingSeasonId <= 0 then
            viewingSeasonId = nil
        end

        -- Tentar coletar recompensa
        local success, message = BattlePassCore.claimReward(player, day, viewingSeasonId)

        if success then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reward claimed successfully!")
            player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)

            -- Reabrir janela atualizada using the same season
            local BattlePassDB = dofile("data-crystal/scripts/systems/battlepass/database.lua")
            local season = viewingSeasonId and BattlePassDB.getSeasonById(viewingSeasonId) or BattlePassCore.getCurrentSeason()
            if season then
                local playerBP = BattlePassCore.getPlayerBattlePass(player:getGuid(), season.id)
                if playerBP then
                    BattlePassWindow.open(player, season, playerBP)
                end
            end
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message or "Cannot claim this reward.")
        end
    end

    return true
end

callback:register()
