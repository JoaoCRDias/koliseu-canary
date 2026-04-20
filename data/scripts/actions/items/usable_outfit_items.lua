local outfitConfig = {
	[60137] = { female = 3089, male = 3089, addon = 3, effect = CONST_ME_BLUE_GHOST, orangeText = "You can use the Verdant Mage Outfit now!" },
	[60138] = { female = 3090, male = 3090, addon = 3, effect = CONST_ME_BLUE_GHOST, orangeText = "You can use the Verdant Assassin Outfit now!" },
	[60532] = { female = 3120, male = 3121, addon = 3, effect = CONST_ME_BLUE_GHOST, orangeText = "You can use the Baldur Reaper Outfit now!" },
	[52664] = { female = 7247, male = 7246, addon = 3, effect = CONST_ME_BLUE_GHOST, orangeText = "You can use the Survivor Outfit now!" },
	[60391] = { female = 3095, male = 3096, addon = 3, effect = CONST_ME_BLUE_GHOST, orangeText = "You can use the Castle Warlord Outfit now!" },

	-- Roulette Exclusive Outfits
	[60625] = { female = 3126, male = 3126, addon = 3, effect = CONST_ME_FIREWORK_YELLOW },
	[60622] = { female = 3127, male = 3127, addon = 3, effect = CONST_ME_FIREWORK_YELLOW },
	[60623] = { female = 3128, male = 3128, addon = 3, effect = CONST_ME_FIREWORK_YELLOW },
	[60624] = { female = 3129, male = 3129, addon = 3, effect = CONST_ME_FIREWORK_YELLOW },
	[9586] = { female = 3164, male = 3165, addon = 3, effect = CONST_ME_FIREWORK_YELLOW },
}

local usableOutfitItems = Action()

function usableOutfitItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:isPremium() then
		player:sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
		return true
	end

	local outfitInfo = outfitConfig[item.itemid]
	local looktype = player:getSex() == PLAYERSEX_FEMALE and outfitInfo.female or outfitInfo.male

	-- Verifica se já possui o outfit com o addon
	if player:hasOutfit(looktype, outfitInfo.addon) then
		player:sendCancelMessage("You already own this outfit part.")
		return true
	end

	-- Adiciona o outfit para ambos os sexos
	player:addOutfit(outfitInfo.female)
	player:addOutfit(outfitInfo.male)

	-- Adiciona o addon se especificado
	if outfitInfo.addon then
		player:addOutfitAddon(outfitInfo.female, outfitInfo.addon)
		player:addOutfitAddon(outfitInfo.male, outfitInfo.addon)
	end

	-- Efeitos visuais e mensagens
	player:getPosition():sendMagicEffect(outfitInfo.effect or CONST_ME_GIFT_WRAPS)
	if outfitInfo.orangeText then
		player:say(outfitInfo.orangeText, TALKTYPE_MONSTER_SAY)
	elseif outfitInfo.whiteText then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, outfitInfo.whiteText)
	end

	-- Adiciona achievement se tiver todos os addons
	if outfitInfo.achievement and player:hasOutfit(looktype, 3) then
		player:addAchievement(outfitInfo.achievement)
	end

	item:remove(1)
	return true
end

for itemId, _ in pairs(outfitConfig) do
	usableOutfitItems:id(itemId)
end

usableOutfitItems:register()
