/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/appearance/mounts/mounts.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"

namespace {
	constexpr float DEFAULT_MOUNT_HP_PERCENT = 1.0f;
	constexpr float DEFAULT_MOUNT_MANA_PERCENT = 1.0f;

	bool mountHasPassiveBonus(const std::shared_ptr<Mount> &mount) {
		if (!mount) {
			return false;
		}

		if (mount->attackSpeed != 0 || mount->regeneration || mount->manaShield || mount->invisible) {
			return true;
		}

		if (mount->lifeLeechChance > 0 || mount->lifeLeechAmount > 0 || mount->manaLeechChance > 0 || mount->manaLeechAmount > 0 || mount->criticalChance > 0 || mount->criticalDamage > 0 || mount->experienceRate > 0.0) {
			return true;
		}

		for (int32_t skillValue : mount->skills) {
			if (skillValue != 0) {
				return true;
			}
		}

		for (int32_t statValue : mount->stats) {
			if (statValue != 0) {
				return true;
			}
		}

		for (float statPctValue : mount->statsPercent) {
			if (statPctValue != 0.0f) {
				return true;
			}
		}

		return false;
	}

	void ensureMountProvidesBonus(const std::shared_ptr<Mount> &mount) {
		if (!mount || mountHasPassiveBonus(mount)) {
			return;
		}

		mount->statsPercent[STAT_MAXHITPOINTS] += DEFAULT_MOUNT_HP_PERCENT;
		mount->statsPercent[STAT_MAXMANAPOINTS] += DEFAULT_MOUNT_MANA_PERCENT;
	}
} // namespace

bool Mounts::reload() {
	mounts.clear();
	return loadFromXml();
}

bool Mounts::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/mounts.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto mountNode : doc.child("mounts").children()) {
		auto lookType = pugi::cast<uint16_t>(mountNode.attribute("clientid").value());
		if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && lookType != 0 && !g_game().isLookTypeRegistered(lookType)) {
			g_logger().warn("{} - An unregistered creature mount with id '{}' was blocked to prevent client crash.", __FUNCTION__, lookType);
			continue;
		}

		auto mount = std::make_shared<Mount>(
			static_cast<uint8_t>(pugi::cast<uint16_t>(mountNode.attribute("id").value())),
			lookType,
			mountNode.attribute("name").as_string(),
			pugi::cast<int32_t>(mountNode.attribute("speed").value()),
			mountNode.attribute("premium").as_bool(),
			mountNode.attribute("type").as_string()
		);

		// Bonus attributes
		mount->manaShield = mountNode.attribute("manashield").as_bool() || mountNode.attribute("manaShield").as_bool();
		mount->invisible = mountNode.attribute("invisible").as_bool();
		mount->attackSpeed = mountNode.attribute("attackSpeed").as_int() || mountNode.attribute("attackspeed").as_int();

		if (auto healthGainAttr = mountNode.attribute("healthGain")) {
			mount->healthGain = healthGainAttr.as_int();
			mount->regeneration = true;
		}
		if (auto healthTicksAttr = mountNode.attribute("healthTicks")) {
			mount->healthTicks = healthTicksAttr.as_int();
			mount->regeneration = true;
		}
		if (auto manaGainAttr = mountNode.attribute("manaGain")) {
			mount->manaGain = manaGainAttr.as_int();
			mount->regeneration = true;
		}
		if (auto manaTicksAttr = mountNode.attribute("manaTicks")) {
			mount->manaTicks = manaTicksAttr.as_int();
			mount->regeneration = true;
		}

		// Skills
		if (auto skillsNode = mountNode.child("skills")) {
			for (auto skillNode : skillsNode.children()) {
				std::string skillName = skillNode.name();
				int32_t skillValue = skillNode.attribute("value").as_int();

				if (skillName == "fist") {
					mount->skills[SKILL_FIST] += skillValue;
				} else if (skillName == "club") {
					mount->skills[SKILL_CLUB] += skillValue;
				} else if (skillName == "axe") {
					mount->skills[SKILL_AXE] += skillValue;
				} else if (skillName == "sword") {
					mount->skills[SKILL_SWORD] += skillValue;
				} else if (skillName == "distance" || skillName == "dist") {
					mount->skills[SKILL_DISTANCE] += skillValue;
				} else if (skillName == "shielding" || skillName == "shield") {
					mount->skills[SKILL_SHIELD] = skillValue;
				} else if (skillName == "fishing" || skillName == "fish") {
					mount->skills[SKILL_FISHING] += skillValue;
				} else if (skillName == "melee") {
					mount->skills[SKILL_FIST] += skillValue;
					mount->skills[SKILL_CLUB] += skillValue;
					mount->skills[SKILL_SWORD] += skillValue;
					mount->skills[SKILL_AXE] += skillValue;
				} else if (skillName == "weapon" || skillName == "weapons") {
					mount->skills[SKILL_CLUB] += skillValue;
					mount->skills[SKILL_SWORD] += skillValue;
					mount->skills[SKILL_AXE] += skillValue;
					mount->skills[SKILL_DISTANCE] += skillValue;
				}
			}
		}

		// Stats
		if (auto statsNode = mountNode.child("stats")) {
			for (auto statNode : statsNode.children()) {
				std::string statName = statNode.name();

				if (statName == "maxHealth" || statName == "maxhealth") {
					mount->statsPercent[STAT_MAXHITPOINTS] += statNode.attribute("value").as_float();
				} else if (statName == "maxMana" || statName == "maxmana") {
					mount->statsPercent[STAT_MAXMANAPOINTS] += statNode.attribute("value").as_float();
				} else if (statName == "cap" || statName == "capacity") {
					mount->stats[STAT_CAPACITY] += statNode.attribute("value").as_int() * 100;
				} else if (statName == "magLevel" || statName == "magicLevel" || statName == "magiclevel" || statName == "ml") {
					mount->stats[STAT_MAGICPOINTS] += statNode.attribute("value").as_int();
				}
			}
		}

		// Imbuing-style bonuses
		if (auto imbuingNode = mountNode.child("imbuing")) {
			for (auto imbuing : imbuingNode.children()) {
				std::string imbuingName = imbuing.name();
				double imbuingValue = imbuing.attribute("value").as_double() * 100.0;

				if (imbuingName == "lifeLeechChance" || imbuingName == "lifeleechchance") {
					mount->lifeLeechChance += imbuingValue;
				} else if (imbuingName == "lifeleechAmount" || imbuingName == "lifeleechamount") {
					mount->lifeLeechAmount += imbuingValue;
				} else if (imbuingName == "manaLeechChance" || imbuingName == "manaleechchance") {
					mount->manaLeechChance += imbuingValue;
				} else if (imbuingName == "manaLeechAmount" || imbuingName == "manaleechamount") {
					mount->manaLeechAmount += imbuingValue;
				} else if (imbuingName == "criticalChance" || imbuingName == "criticalchance") {
					mount->criticalChance += imbuingValue;
				} else if (imbuingName == "criticalDamage" || imbuingName == "criticaldamage") {
					mount->criticalDamage += imbuingValue;
				}
			}
		}

		if (auto expRateAttr = mountNode.attribute("experienceRate")) {
			mount->experienceRate = expRateAttr.as_double();
		}

		ensureMountProvidesBonus(mount);
		mounts.insert(mount);
	}
	return true;
}

std::shared_ptr<Mount> Mounts::getMountByID(uint8_t id) {
	auto it = std::find_if(mounts.begin(), mounts.end(), [id](const std::shared_ptr<Mount> &mount) {
		return mount->id == id;
	});

	return it != mounts.end() ? *it : nullptr;
}

std::shared_ptr<Mount> Mounts::getMountByName(const std::string &name) {
	auto mountName = name.c_str();
	auto it = std::find_if(mounts.begin(), mounts.end(), [mountName](const std::shared_ptr<Mount> &mount) {
		return strcasecmp(mountName, mount->name.c_str()) == 0;
	});

	return it != mounts.end() ? *it : nullptr;
}

std::shared_ptr<Mount> Mounts::getMountByClientID(uint16_t clientId) {
	auto it = std::find_if(mounts.begin(), mounts.end(), [clientId](const std::shared_ptr<Mount> &mount) {
		return mount->clientId == clientId;
	});

	return it != mounts.end() ? *it : nullptr;
}
