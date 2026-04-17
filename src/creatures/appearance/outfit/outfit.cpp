/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/appearance/outfit/outfit.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lib/di/container.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"

namespace {
	constexpr float DEFAULT_OUTFIT_HP_PERCENT = 1.0f;
	constexpr float DEFAULT_OUTFIT_MANA_PERCENT = 1.0f;
	constexpr int32_t DEFAULT_OUTFIT_CAPACITY_BONUS = 50;

	bool outfitHasPassiveBonus(const std::shared_ptr<Outfit> &outfit) {
		if (!outfit) {
			return false;
		}

		if (outfit->speed != 0 || outfit->attackSpeed != 0 || outfit->regeneration || outfit->manaShield || outfit->invisible) {
			return true;
		}

		if (outfit->lifeLeechChance > 0 || outfit->lifeLeechAmount > 0 || outfit->manaLeechChance > 0 || outfit->manaLeechAmount > 0 || outfit->criticalChance > 0 || outfit->criticalDamage > 0 || outfit->experienceRate > 0.0) {
			return true;
		}

		for (int32_t statValue : outfit->stats) {
			if (statValue != 0) {
				return true;
			}
		}

		for (float statPctValue : outfit->statsPercent) {
			if (statPctValue != 0.0f) {
				return true;
			}
		}

		for (int32_t skillValue : outfit->skills) {
			if (skillValue != 0) {
				return true;
			}
		}

		return false;
	}

	void ensureOutfitProvidesBonus(const std::shared_ptr<Outfit> &outfit) {
		if (!outfit || outfitHasPassiveBonus(outfit)) {
			return;
		}

		outfit->statsPercent[STAT_MAXHITPOINTS] += DEFAULT_OUTFIT_HP_PERCENT;
		outfit->statsPercent[STAT_MAXMANAPOINTS] += DEFAULT_OUTFIT_MANA_PERCENT;
		outfit->stats[STAT_CAPACITY] += DEFAULT_OUTFIT_CAPACITY_BONUS * 100;
	}
} // namespace

std::vector<std::shared_ptr<Outfit>> outfits[PLAYERSEX_LAST + 1];

Outfits &Outfits::getInstance() {
	return inject<Outfits>();
}

bool Outfits::reload() {
	for (auto &outfitsVector : outfits) {
		outfitsVector.clear();
	}
	return loadFromXml();
}

bool Outfits::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/outfits.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto outfitNode : doc.child("outfits").children()) {
		pugi::xml_attribute attr;
		if ((attr = outfitNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = outfitNode.attribute("type"))) {
			g_logger().warn("[Outfits::loadFromXml] - Missing outfit type");
			continue;
		}

		auto type = pugi::cast<uint16_t>(attr.value());
		if (type > PLAYERSEX_LAST) {
			g_logger().warn("[Outfits::loadFromXml] - Invalid outfit type {}", type);
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = outfitNode.attribute("looktype");
		if (!lookTypeAttribute) {
			g_logger().warn("[Outfits::loadFromXml] - Missing looktype on outfit");
			continue;
		}

		if (auto lookType = pugi::cast<uint16_t>(lookTypeAttribute.value());
		    g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && lookType != 0
		    && !g_game().isLookTypeRegistered(lookType)) {
			g_logger().warn("[Outfits::loadFromXml] An unregistered creature looktype type with id '{}' was loaded anyway.", lookType);
		}

		auto outfit = std::make_shared<Outfit>(
			outfitNode.attribute("name").as_string(),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			outfitNode.attribute("premium").as_bool(),
			outfitNode.attribute("unlocked").as_bool(true),
			outfitNode.attribute("from").as_string()
		);

		// Bonus attributes from XML
		if (auto expRateAttr = outfitNode.attribute("experienceRate")) {
			outfit->experienceRate = expRateAttr.as_double();
		}

		outfit->manaShield = outfitNode.attribute("manaShield").as_bool() || outfitNode.attribute("manashield").as_bool();
		outfit->invisible = outfitNode.attribute("invisible").as_bool();
		outfit->speed = outfitNode.attribute("speed").as_int();
		outfit->attackSpeed = outfitNode.attribute("attackSpeed").as_int() || outfitNode.attribute("attackspeed").as_int();

		if (auto healthGainAttr = outfitNode.attribute("healthGain")) {
			outfit->healthGain = healthGainAttr.as_int();
			outfit->regeneration = true;
		}
		if (auto healthTicksAttr = outfitNode.attribute("healthTicks")) {
			outfit->healthTicks = healthTicksAttr.as_int();
			outfit->regeneration = true;
		}
		if (auto manaGainAttr = outfitNode.attribute("manaGain")) {
			outfit->manaGain = manaGainAttr.as_int();
			outfit->regeneration = true;
		}
		if (auto manaTicksAttr = outfitNode.attribute("manaTicks")) {
			outfit->manaTicks = manaTicksAttr.as_int();
			outfit->regeneration = true;
		}

		// Skills
		if (auto skillsNode = outfitNode.child("skills")) {
			for (auto skillNode : skillsNode.children()) {
				std::string skillName = skillNode.name();
				int32_t skillValue = skillNode.attribute("value").as_int();

				if (skillName == "fist") {
					outfit->skills[SKILL_FIST] += skillValue;
				} else if (skillName == "club") {
					outfit->skills[SKILL_CLUB] += skillValue;
				} else if (skillName == "axe") {
					outfit->skills[SKILL_AXE] += skillValue;
				} else if (skillName == "sword") {
					outfit->skills[SKILL_SWORD] += skillValue;
				} else if (skillName == "distance" || skillName == "dist") {
					outfit->skills[SKILL_DISTANCE] += skillValue;
				} else if (skillName == "shielding" || skillName == "shield") {
					outfit->skills[SKILL_SHIELD] = skillValue;
				} else if (skillName == "fishing" || skillName == "fish") {
					outfit->skills[SKILL_FISHING] += skillValue;
				} else if (skillName == "melee") {
					outfit->skills[SKILL_FIST] += skillValue;
					outfit->skills[SKILL_CLUB] += skillValue;
					outfit->skills[SKILL_SWORD] += skillValue;
					outfit->skills[SKILL_AXE] += skillValue;
				} else if (skillName == "weapon" || skillName == "weapons") {
					outfit->skills[SKILL_CLUB] += skillValue;
					outfit->skills[SKILL_SWORD] += skillValue;
					outfit->skills[SKILL_AXE] += skillValue;
					outfit->skills[SKILL_DISTANCE] += skillValue;
				}
			}
		}

		// Stats
		if (auto statsNode = outfitNode.child("stats")) {
			for (auto statNode : statsNode.children()) {
				std::string statName = statNode.name();

				if (statName == "maxHealth" || statName == "maxhealth") {
					outfit->statsPercent[STAT_MAXHITPOINTS] += statNode.attribute("value").as_float();
				} else if (statName == "maxMana" || statName == "maxmana") {
					outfit->statsPercent[STAT_MAXMANAPOINTS] += statNode.attribute("value").as_float();
				} else if (statName == "cap" || statName == "capacity") {
					outfit->stats[STAT_CAPACITY] += statNode.attribute("value").as_int() * 100;
				} else if (statName == "magLevel" || statName == "magicLevel" || statName == "magiclevel" || statName == "ml") {
					outfit->stats[STAT_MAGICPOINTS] += statNode.attribute("value").as_int();
				}
			}
		}

		// Imbuing-style bonuses
		if (auto imbuingNode = outfitNode.child("imbuing")) {
			for (auto imbuing : imbuingNode.children()) {
				std::string imbuingName = imbuing.name();
				double imbuingValue = imbuing.attribute("value").as_double() * 100.0;

				if (imbuingName == "lifeLeechChance" || imbuingName == "lifeleechchance") {
					outfit->lifeLeechChance += imbuingValue;
				} else if (imbuingName == "lifeleechAmount" || imbuingName == "lifeleechamount") {
					outfit->lifeLeechAmount += imbuingValue;
				} else if (imbuingName == "manaLeechChance" || imbuingName == "manaleechchance") {
					outfit->manaLeechChance += imbuingValue;
				} else if (imbuingName == "manaLeechAmount" || imbuingName == "manaleechamount") {
					outfit->manaLeechAmount += imbuingValue;
				} else if (imbuingName == "criticalChance" || imbuingName == "criticalchance") {
					outfit->criticalChance += imbuingValue;
				} else if (imbuingName == "criticalDamage" || imbuingName == "criticaldamage") {
					outfit->criticalDamage += imbuingValue;
				}
			}
		}

		ensureOutfitProvidesBonus(outfit);
		outfits[type].emplace_back(outfit);
	}

	for (uint8_t sex = PLAYERSEX_FEMALE; sex <= PLAYERSEX_LAST; ++sex) {
		outfits[sex].shrink_to_fit();
	}
	return true;
}

std::shared_ptr<Outfit> Outfits::getOutfitByLookType(const std::shared_ptr<const Player> &player, uint16_t lookType, bool isOppositeOutfit) const {
	if (!player) {
		g_logger().error("[{}] - Player not found", __FUNCTION__);
		return nullptr;
	}

	auto sex = player->getSex();
	if (sex != PLAYERSEX_FEMALE && sex != PLAYERSEX_MALE) {
		g_logger().error("[{}] - Sex invalid or player: {}", __FUNCTION__, player->getName());
		return nullptr;
	}

	if (isOppositeOutfit) {
		sex = (sex == PLAYERSEX_MALE) ? PLAYERSEX_FEMALE : PLAYERSEX_MALE;
	}

	auto it = std::ranges::find_if(outfits[sex], [&lookType](const auto &outfit) {
		return outfit->lookType == lookType;
	});

	if (it != outfits[sex].end()) {
		return *it;
	}
	return nullptr;
}

const std::vector<std::shared_ptr<Outfit>> &Outfits::getOutfits(PlayerSex_t sex) const {
	return outfits[sex];
}

std::shared_ptr<Outfit> Outfits::getOutfitByName(PlayerSex_t sex, const std::string &name) const {
	for (const auto &outfit : outfits[sex]) {
		if (outfit->name == name) {
			return outfit;
		}
	}

	return nullptr;
}
