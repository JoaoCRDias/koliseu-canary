/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once
#include "creatures/creatures_definitions.hpp"

enum PlayerSex_t : uint8_t;
class Player;

struct OutfitEntry {
	constexpr explicit OutfitEntry(uint16_t initLookType, uint8_t initAddons) :
		lookType(initLookType), addons(initAddons) { }

	uint16_t lookType;
	uint8_t addons;
};

struct Outfit {
	Outfit(std::string initName, uint16_t initLookType, bool initPremium, bool initUnlocked, std::string initFrom) :
		name(std::move(initName)), lookType(initLookType), premium(initPremium), unlocked(initUnlocked), from(std::move(initFrom)) {
		std::memset(skills, 0, sizeof(skills));
		std::memset(stats, 0, sizeof(stats));
		std::memset(statsPercent, 0, sizeof(statsPercent));
	}

	std::string name;
	std::string from;

	bool premium = false;
	bool unlocked = false;
	bool manaShield = false;
	bool invisible = false;
	bool regeneration = false;

	uint16_t lookType = 0;

	int32_t speed = 0;
	int32_t attackSpeed = 0;
	int32_t healthGain = 0;
	int32_t healthTicks = 0;
	int32_t manaGain = 0;
	int32_t manaTicks = 0;

	double lifeLeechChance = 0;
	double lifeLeechAmount = 0;
	double manaLeechChance = 0;
	double manaLeechAmount = 0;
	double criticalChance = 0;
	double criticalDamage = 0;
	double experienceRate = 0.0;

	int32_t skills[SKILL_LAST + 1] = { 0 };
	int32_t stats[STAT_LAST + 1] = { 0 };
	float statsPercent[STAT_LAST + 1] = { 0 };
};

struct ProtocolOutfit {
	ProtocolOutfit(const std::string &initName, uint16_t initLookType, uint8_t initAddons) :
		name(initName), lookType(initLookType), addons(initAddons) { }

	const std::string &name;
	uint16_t lookType;
	uint8_t addons;
};

class Outfits {
public:
	static Outfits &getInstance();

	bool reload();
	bool loadFromXml();

	[[nodiscard]] std::shared_ptr<Outfit> getOutfitByLookType(const std::shared_ptr<const Player> &player, uint16_t lookType, bool isOppositeOutfit = false) const;
	[[nodiscard]] const std::vector<std::shared_ptr<Outfit>> &getOutfits(PlayerSex_t sex) const;

	std::shared_ptr<Outfit> getOutfitByName(PlayerSex_t sex, const std::string &name) const;
};
