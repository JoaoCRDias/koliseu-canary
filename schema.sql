-- Table structure `server_config`
CREATE TABLE IF NOT EXISTS `server_config` (
    `config` varchar(50) NOT NULL,
    `value` varchar(256) NOT NULL DEFAULT '',
    CONSTRAINT `server_config_pk` PRIMARY KEY (`config`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `server_config` (`config`, `value`) VALUES ('db_version', '1'), ('motd_hash', ''), ('motd_num', '0'), ('players_record', '0');

-- Table structure `accounts`
CREATE TABLE IF NOT EXISTS `accounts` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` varchar(32) NOT NULL,
    `password` TEXT NOT NULL,
    `email` varchar(255) NOT NULL DEFAULT '',
    `premdays` int(11) NOT NULL DEFAULT '0',
    `premdays_purchased` int(11) NOT NULL DEFAULT '0',
    `lastday` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `type` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
    `coins` int(12) UNSIGNED NOT NULL DEFAULT '0',
    `coins_transferable` int(12) UNSIGNED NOT NULL DEFAULT '0',
    `tournament_coins` int(12) UNSIGNED NOT NULL DEFAULT '0',
    `creation` int(11) UNSIGNED NOT NULL DEFAULT '0',
    `recovery_key` varchar(128) DEFAULT NULL,
    `totp_secret` varchar(64) DEFAULT NULL,
    `totp_enabled` tinyint(1) NOT NULL DEFAULT '0',
    `recruiter` INT(6) DEFAULT 0,
    `house_bid_id` int(11) NOT NULL DEFAULT '0',
    CONSTRAINT `accounts_pk` PRIMARY KEY (`id`),
    CONSTRAINT `accounts_unique` UNIQUE (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `coins_transactions`
CREATE TABLE IF NOT EXISTS `coins_transactions` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` int(11) UNSIGNED NOT NULL,
    `type` tinyint(1) UNSIGNED NOT NULL,
    `coin_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
    `amount` int(12) UNSIGNED NOT NULL,
    `description` varchar(3500) NOT NULL,
    `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP,
    INDEX `account_id` (`account_id`),
    INDEX `idx_coins_transactions_account_time` (`account_id`, `timestamp`),
    CONSTRAINT `coins_transactions_pk` PRIMARY KEY (`id`),
    CONSTRAINT `coins_transactions_account_fk`
    FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `players`
CREATE TABLE IF NOT EXISTS `players` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `group_id` int(11) NOT NULL DEFAULT '1',
    `account_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
    `level` int(11) NOT NULL DEFAULT '1',
    `vocation` int(11) NOT NULL DEFAULT '0',
    `health` int(11) NOT NULL DEFAULT '150',
    `healthmax` int(11) NOT NULL DEFAULT '150',
    `experience` bigint(20) NOT NULL DEFAULT '0',
    `lookbody` int(11) NOT NULL DEFAULT '0',
    `lookfeet` int(11) NOT NULL DEFAULT '0',
    `lookhead` int(11) NOT NULL DEFAULT '0',
    `looklegs` int(11) NOT NULL DEFAULT '0',
    `looktype` int(11) NOT NULL DEFAULT '136',
    `lookaddons` int(11) NOT NULL DEFAULT '0',
    `maglevel` int(11) NOT NULL DEFAULT '0',
    `mana` int(11) NOT NULL DEFAULT '0',
    `manamax` int(11) NOT NULL DEFAULT '0',
    `manaspent` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `soul` int(10) UNSIGNED NOT NULL DEFAULT '100',
    `town_id` int(11) NOT NULL DEFAULT '1',
    `posx` int(11) NOT NULL DEFAULT '0',
    `posy` int(11) NOT NULL DEFAULT '0',
    `posz` int(11) NOT NULL DEFAULT '0',
    `conditions` mediumblob NOT NULL,
    `cap` int(11) NOT NULL DEFAULT '0',
    `sex` int(11) NOT NULL DEFAULT '0',
    `pronoun` int(11) NOT NULL DEFAULT '0',
    `lastlogin` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `lastip` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `save` tinyint(1) NOT NULL DEFAULT '1',
    `skull` tinyint(1) NOT NULL DEFAULT '0',
    `skulltime` bigint(20) NOT NULL DEFAULT '0',
    `lastlogout` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `blessings` tinyint(2) NOT NULL DEFAULT '0',
    `blessings1` tinyint(4) NOT NULL DEFAULT '0',
    `blessings2` tinyint(4) NOT NULL DEFAULT '0',
    `blessings3` tinyint(4) NOT NULL DEFAULT '0',
    `blessings4` tinyint(4) NOT NULL DEFAULT '0',
    `blessings5` tinyint(4) NOT NULL DEFAULT '0',
    `blessings6` tinyint(4) NOT NULL DEFAULT '0',
    `blessings7` tinyint(4) NOT NULL DEFAULT '0',
    `blessings8` tinyint(4) NOT NULL DEFAULT '0',
    `onlinetime` int(11) NOT NULL DEFAULT '0',
    `deletion` bigint(15) NOT NULL DEFAULT '0',
    `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `offlinetraining_time` smallint(5) UNSIGNED NOT NULL DEFAULT '43200',
    `offlinetraining_skill` tinyint(2) NOT NULL DEFAULT '-1',
    `stamina` smallint(5) UNSIGNED NOT NULL DEFAULT '2520',
    `skill_fist` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_fist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_club` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_club_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_sword` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_sword_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_axe` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_axe_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_dist` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_dist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_shielding` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_shielding_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_fishing` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_fishing_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_critical_hit_chance` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `skill_critical_hit_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_critical_hit_damage` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `skill_critical_hit_damage_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_life_leech_chance` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `skill_life_leech_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_life_leech_amount` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `skill_life_leech_amount_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_mana_leech_chance` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `skill_mana_leech_chance_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_mana_leech_amount` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `skill_mana_leech_amount_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_attack_speed` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_attack_speed_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_mining` int(10) UNSIGNED NOT NULL DEFAULT '10',
    `skill_mining_tries` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_criticalhit_chance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_criticalhit_damage` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_lifeleech_chance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_lifeleech_amount` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_manaleech_chance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `skill_manaleech_amount` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `manashield` INT UNSIGNED NOT NULL DEFAULT '0',
    `max_manashield` INT UNSIGNED NOT NULL DEFAULT '0',
    `xpboost_stamina` smallint(5) UNSIGNED DEFAULT NULL,
    `xpboost_value` tinyint(4) UNSIGNED DEFAULT NULL,
    `marriage_status` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `marriage_spouse` int(11) NOT NULL DEFAULT '-1',
    `bonus_rerolls` bigint(21) NOT NULL DEFAULT '0',
    `prey_wildcard` bigint(21) NOT NULL DEFAULT '0',
    `task_points` bigint(21) NOT NULL DEFAULT '0',
    `quickloot_fallback` tinyint(1) DEFAULT '0',
    `lookmountbody` tinyint(3) unsigned NOT NULL DEFAULT '0',
    `lookmountfeet` tinyint(3) unsigned NOT NULL DEFAULT '0',
    `lookmounthead` tinyint(3) unsigned NOT NULL DEFAULT '0',
    `lookmountlegs` tinyint(3) unsigned NOT NULL DEFAULT '0',
    `currentmount` smallint(5) unsigned NOT NULL DEFAULT '0',
    `lookfamiliarstype` int(11) unsigned NOT NULL DEFAULT '0',
    `isreward` tinyint(1) NOT NULL DEFAULT '1',
    `istutorial` tinyint(1) NOT NULL DEFAULT '0',
    `forge_dusts` bigint(21) NOT NULL DEFAULT '0',
    `forge_dust_level` bigint(21) NOT NULL DEFAULT '100',
    `randomize_mount` tinyint(1) NOT NULL DEFAULT '0',
    `boss_points` int NOT NULL DEFAULT '0',
    `loyalty_points` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `animus_mastery` mediumblob DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `virtue` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `harmony` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `weapon_proficiencies` mediumblob DEFAULT NULL,
    INDEX `account_id` (`account_id`),
    INDEX `vocation` (`vocation`),
    CONSTRAINT `players_pk` PRIMARY KEY (`id`),
    CONSTRAINT `players_unique` UNIQUE (`name`),
    CONSTRAINT `players_account_fk`
    FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `account_bans`
CREATE TABLE IF NOT EXISTS `account_bans` (
    `account_id` int(11) UNSIGNED NOT NULL,
    `reason` varchar(255) NOT NULL,
    `banned_at` bigint(20) NOT NULL,
    `expires_at` bigint(20) NOT NULL,
    `banned_by` int(11) NOT NULL,
    INDEX `banned_by` (`banned_by`),
    CONSTRAINT `account_bans_pk` PRIMARY KEY (`account_id`),
    CONSTRAINT `account_bans_account_fk`
    FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `account_bans_player_fk`
    FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `account_ban_history`
CREATE TABLE IF NOT EXISTS `account_ban_history` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `account_id` int(11) UNSIGNED NOT NULL,
    `reason` varchar(255) NOT NULL,
    `banned_at` bigint(20) NOT NULL,
    `expired_at` bigint(20) NOT NULL,
    `banned_by` int(11) NOT NULL,
    INDEX `account_id` (`account_id`),
    INDEX `banned_by` (`banned_by`),
    CONSTRAINT `account_bans_history_account_fk`
    FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `account_bans_history_player_fk`
    FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `account_ban_history_pk` PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `account_viplist`
CREATE TABLE IF NOT EXISTS `account_viplist` (
    `account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose viplist entry it is',
    `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
    `description` varchar(128) NOT NULL DEFAULT '',
    `icon` tinyint(2) UNSIGNED NOT NULL DEFAULT '0',
    `notify` tinyint(1) NOT NULL DEFAULT '0',
    INDEX `account_id` (`account_id`),
    INDEX `player_id` (`player_id`),
    CONSTRAINT `account_viplist_unique` UNIQUE (`account_id`, `player_id`),
    CONSTRAINT `account_viplist_account_fk`
    FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
    ON DELETE CASCADE,
    CONSTRAINT `account_viplist_player_fk`
    FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `account_vipgroup`
CREATE TABLE IF NOT EXISTS `account_vipgroups` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose vip group entry it is',
    `name` varchar(128) NOT NULL,
    `customizable` BOOLEAN NOT NULL DEFAULT '1',
    CONSTRAINT `account_vipgroups_pk` PRIMARY KEY (`id`),
    CONSTRAINT `account_vipgroups_accounts_fk`
        FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Trigger
--
DELIMITER //
CREATE TRIGGER `oncreate_accounts` AFTER INSERT ON `accounts` FOR EACH ROW BEGIN
    INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Enemies', 0);
    INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Friends', 0);
    INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Trading Partner', 0);
END//
DELIMITER ;

-- Table structure `account_vipgrouplist`
CREATE TABLE IF NOT EXISTS `account_vipgrouplist` (
    `account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose viplist entry it is',
    `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
    `vipgroup_id` int(11) UNSIGNED NOT NULL COMMENT 'id of vip group that player belongs',
    INDEX `account_id` (`account_id`),
    INDEX `player_id` (`player_id`),
    INDEX `vipgroup_id` (`vipgroup_id`),
    CONSTRAINT `account_vipgrouplist_unique` UNIQUE (`account_id`, `player_id`, `vipgroup_id`),
    CONSTRAINT `account_vipgrouplist_player_fk`
    FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
    ON DELETE CASCADE,
    CONSTRAINT `account_vipgrouplist_vipgroup_fk`
    FOREIGN KEY (`vipgroup_id`) REFERENCES `account_vipgroups` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `boosted_boss`
CREATE TABLE IF NOT EXISTS `boosted_boss` (
    `boostname` TEXT,
    `date` varchar(250) NOT NULL DEFAULT '',
    `raceid` varchar(250) NOT NULL DEFAULT '',
    `looktypeEx` int(11) NOT NULL DEFAULT 0,
    `looktype` int(11) NOT NULL DEFAULT 136,
    `lookfeet` int(11) NOT NULL DEFAULT 0,
    `looklegs` int(11) NOT NULL DEFAULT 0,
    `lookhead` int(11) NOT NULL DEFAULT 0,
    `lookbody` int(11) NOT NULL DEFAULT 0,
    `lookaddons` int(11) NOT NULL DEFAULT 0,
    `lookmount` int(11) DEFAULT 0,
    PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `boosted_boss` (`boostname`, `date`, `raceid`) VALUES ('default', '1', '0') ON DUPLICATE KEY UPDATE `date` = `date`;

-- Table structure `boosted_creature`
CREATE TABLE IF NOT EXISTS `boosted_creature` (
    `boostname` TEXT,
    `date` varchar(250) NOT NULL DEFAULT '',
    `raceid` varchar(250) NOT NULL DEFAULT '',
    `looktype` int(11) NOT NULL DEFAULT 136,
    `lookfeet` int(11) NOT NULL DEFAULT 0,
    `looklegs` int(11) NOT NULL DEFAULT 0,
    `lookhead` int(11) NOT NULL DEFAULT 0,
    `lookbody` int(11) NOT NULL DEFAULT 0,
    `lookaddons` int(11) NOT NULL DEFAULT 0,
    `lookmount` int(11) DEFAULT 0,
    PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `boosted_creature` (`boostname`, `date`, `raceid`) VALUES ('default', '1', '0') ON DUPLICATE KEY UPDATE `date` = `date`;

-- Table structure `player_oldnames`
CREATE TABLE IF NOT EXISTS `player_oldnames` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`player_id` int(11) NOT NULL,
	`former_name` varchar(255) NOT NULL DEFAULT '',
	`name` varchar(255) NOT NULL,
	`old_name` varchar(255) NOT NULL,
	`date` int(11) NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `player_id_index` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Tabble Structure `daily_reward_history`
CREATE TABLE IF NOT EXISTS `daily_reward_history` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `daystreak` smallint(2) NOT NULL DEFAULT 0,
    `player_id` int(11) NOT NULL,
    `timestamp` int(11) NOT NULL,
    `description` varchar(255) DEFAULT NULL,
    INDEX `player_id` (`player_id`),
    CONSTRAINT `daily_reward_history_pk` PRIMARY KEY (`id`),
    CONSTRAINT `daily_reward_history_player_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Tabble Structure `forge_history`
CREATE TABLE IF NOT EXISTS `forge_history` (
    `id` int NOT NULL AUTO_INCREMENT,
    `player_id` int NOT NULL,
    `action_type` int NOT NULL DEFAULT '0',
    `description` text NOT NULL,
    `is_success` tinyint NOT NULL DEFAULT '0',
    `bonus` tinyint NOT NULL DEFAULT '0',
    `done_at` bigint NOT NULL,
    `done_at_date` datetime DEFAULT NOW(),
    `cost` bigint UNSIGNED NOT NULL DEFAULT '0',
    `gained` bigint UNSIGNED NOT NULL DEFAULT '0',
    INDEX `idx_forge_history_player_id` (`player_id`),
    CONSTRAINT `forge_history_pk` PRIMARY KEY (`id`),
    FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `global_storage`
CREATE TABLE IF NOT EXISTS `global_storage` (
    `key` varchar(32) NOT NULL,
    `value` text NOT NULL,
    CONSTRAINT `global_storage_unique` UNIQUE (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `guilds`
CREATE TABLE IF NOT EXISTS `guilds` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `level` int(11) NOT NULL DEFAULT '1',
    `name` varchar(255) NOT NULL,
    `ownerid` int(11) NOT NULL,
    `logoUrl` VARCHAR(255) DEFAULT NULL,
    `creationdata` int(11) NOT NULL,
    `motd` varchar(255) NOT NULL DEFAULT '',
    `residence` int(11) NOT NULL DEFAULT '0',
    `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `points` int(11) NOT NULL DEFAULT '0',
    CONSTRAINT `guilds_pk` PRIMARY KEY (`id`),
    CONSTRAINT `guilds_name_unique` UNIQUE (`name`),
    CONSTRAINT `guilds_owner_unique` UNIQUE (`ownerid`),
    CONSTRAINT `guilds_ownerid_fk`
        FOREIGN KEY (`ownerid`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `guild_wars`
CREATE TABLE IF NOT EXISTS `guild_wars` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `guild1` int(11) NOT NULL DEFAULT '0',
    `guild2` int(11) NOT NULL DEFAULT '0',
    `name1` varchar(255) NOT NULL,
    `name2` varchar(255) NOT NULL,
    `status` tinyint(2) UNSIGNED NOT NULL DEFAULT '0',
    `started` bigint(15) NOT NULL DEFAULT '0',
    `ended` bigint(15) NOT NULL DEFAULT '0',
    `frags_limit` smallint(4) UNSIGNED NOT NULL DEFAULT '0',
    `payment` bigint(13) UNSIGNED NOT NULL DEFAULT '0',
    `duration_days` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
    INDEX `guild1` (`guild1`),
    INDEX `guild2` (`guild2`),
    INDEX `idx_guild_wars_guild1_status` (`guild1`, `status`),
    INDEX `idx_guild_wars_guild2_status` (`guild2`, `status`),
    CONSTRAINT `guild_wars_pk` PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `guildwar_kills`
CREATE TABLE IF NOT EXISTS `guildwar_kills` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `killer` varchar(50) NOT NULL,
    `target` varchar(50) NOT NULL,
    `killerguild` int(11) NOT NULL DEFAULT '0',
    `targetguild` int(11) NOT NULL DEFAULT '0',
    `warid` int(11) NOT NULL DEFAULT '0',
    `time` bigint(15) NOT NULL,
    INDEX `warid` (`warid`),
    CONSTRAINT `guildwar_kills_pk` PRIMARY KEY (`id`),
    CONSTRAINT `guildwar_kills_warid_fk`
        FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `guild_invites`
CREATE TABLE IF NOT EXISTS `guild_invites` (
    `player_id` int(11) NOT NULL DEFAULT '0',
    `guild_id` int(11) NOT NULL DEFAULT '0',
    `date` int(11) NOT NULL,
    INDEX `guild_id` (`guild_id`),
    CONSTRAINT `guild_invites_pk` PRIMARY KEY (`player_id`, `guild_id`),
    CONSTRAINT `guild_invites_player_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE,
    CONSTRAINT `guild_invites_guild_fk`
        FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `guild_ranks`
CREATE TABLE IF NOT EXISTS `guild_ranks` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `guild_id` int(11) NOT NULL COMMENT 'guild',
    `name` varchar(255) NOT NULL COMMENT 'rank name',
    `level` int(11) NOT NULL COMMENT 'rank level - leader, vice, member, maybe something else',
    INDEX `guild_id` (`guild_id`),
    INDEX `idx_guild_ranks_guild_level` (`guild_id`, `level`),
    CONSTRAINT `guild_ranks_pk` PRIMARY KEY (`id`),
    CONSTRAINT `guild_ranks_fk`
        FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Trigger
--
DELIMITER //
CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds` FOR EACH ROW BEGIN
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('The Leader', 3, NEW.`id`);
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Vice-Leader', 2, NEW.`id`);
    INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Member', 1, NEW.`id`);
END//
DELIMITER ;

-- Table structure `guild_membership`
CREATE TABLE IF NOT EXISTS `guild_membership` (
    `player_id` int(11) NOT NULL,
    `guild_id` int(11) NOT NULL,
    `rank_id` int(11) NOT NULL,
    `nick` varchar(50) NOT NULL DEFAULT '',
    INDEX `guild_id` (`guild_id`),
    INDEX `rank_id` (`rank_id`),
    CONSTRAINT `guild_membership_pk` PRIMARY KEY (`player_id`),
    CONSTRAINT `guild_membership_player_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `guild_membership_guild_fk`
        FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `guild_membership_rank_fk`
        FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `houses`
CREATE TABLE IF NOT EXISTS `houses` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `owner` int(11) NOT NULL,
    `new_owner` int(11) NOT NULL DEFAULT '-1',
    `paid` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `warnings` int(11) NOT NULL DEFAULT '0',
    `name` varchar(255) NOT NULL,
    `rent` int(11) NOT NULL DEFAULT '0',
    `town_id` int(11) NOT NULL DEFAULT '0',
    `size` int(11) NOT NULL DEFAULT '0',
    `guildid` int(11),
    `beds` int(11) NOT NULL DEFAULT '0',
    `bidder` int(11) NOT NULL DEFAULT '0',
    `bidder_name` varchar(255) NOT NULL DEFAULT '',
    `highest_bid` int(11) NOT NULL DEFAULT '0',
    `internal_bid` int(11) NOT NULL DEFAULT '0',
    `bid_end_date` int(11) NOT NULL DEFAULT '0',
    `state` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
    `transfer_status` tinyint(1) DEFAULT '0',
    INDEX `owner` (`owner`),
    INDEX `town_id` (`town_id`),
    CONSTRAINT `houses_pk` PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- trigger
--
DELIMITER //
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END//
DELIMITER ;

-- Table structure `house_lists`
CREATE TABLE IF NOT EXISTS `house_lists` (
  `house_id` int NOT NULL,
  `listid` int NOT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `list` text NOT NULL,
  PRIMARY KEY (`house_id`, `listid`),
  KEY `house_id_index` (`house_id`),
  KEY `version` (`version`),
  CONSTRAINT `houses_list_house_fk` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Table structure `ip_bans`
CREATE TABLE IF NOT EXISTS `ip_bans` (
    `ip` int(11) NOT NULL,
    `reason` varchar(255) NOT NULL,
    `banned_at` bigint(20) NOT NULL,
    `expires_at` bigint(20) NOT NULL,
    `banned_by` int(11) NOT NULL,
    INDEX `banned_by` (`banned_by`),
    CONSTRAINT `ip_bans_pk` PRIMARY KEY (`ip`),
    CONSTRAINT `ip_bans_players_fk`
        FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `market_history`
CREATE TABLE IF NOT EXISTS `market_history` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `player_id` int(11) NOT NULL,
    `sale` tinyint(1) NOT NULL DEFAULT '0',
    `itemtype` int(10) UNSIGNED NOT NULL,
    `amount` smallint(5) UNSIGNED NOT NULL,
    `price` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `expires_at` bigint(20) UNSIGNED NOT NULL,
    `inserted` bigint(20) UNSIGNED NOT NULL,
    `state` tinyint(1) UNSIGNED NOT NULL,
    `tier` tinyint UNSIGNED NOT NULL DEFAULT '0',
    INDEX `player_id` (`player_id`,`sale`),
    CONSTRAINT `market_history_pk` PRIMARY KEY (`id`),
    CONSTRAINT `market_history_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `market_offers`
CREATE TABLE IF NOT EXISTS `market_offers` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `player_id` int(11) NOT NULL,
    `sale` tinyint(1) NOT NULL DEFAULT '0',
    `itemtype` int(10) UNSIGNED NOT NULL,
    `amount` smallint(5) UNSIGNED NOT NULL,
    `created` bigint(20) UNSIGNED NOT NULL,
    `anonymous` tinyint(1) NOT NULL DEFAULT '0',
    `price` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `tier` tinyint UNSIGNED NOT NULL DEFAULT '0',
    INDEX `sale` (`sale`,`itemtype`,`tier`),
    INDEX `created` (`created`),
    INDEX `player_id` (`player_id`),
    CONSTRAINT `market_offers_pk` PRIMARY KEY (`id`),
    CONSTRAINT `market_offers_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `players_online`
CREATE TABLE IF NOT EXISTS `players_online` (
    `player_id` int(11) NOT NULL,
    CONSTRAINT `players_online_pk` PRIMARY KEY (`player_id`),
    CONSTRAINT `players_online_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- Table structure `player_charm`
CREATE TABLE IF NOT EXISTS `player_charms` (
    `player_id` int(11) NOT NULL,
    `charm_points` int(10) UNSIGNED NOT NULL DEFAULT 0,
    `minor_charm_echoes` int(10) UNSIGNED NOT NULL DEFAULT 0,
    `max_charm_points` int(10) UNSIGNED NOT NULL DEFAULT 0,
    `max_minor_charm_echoes` int(10) UNSIGNED NOT NULL DEFAULT 0,
    `charm_expansion` BOOLEAN NOT NULL DEFAULT FALSE,
    `UsedRunesBit` INT NOT NULL DEFAULT '0',
    `UnlockedRunesBit` INT NOT NULL DEFAULT '0',
    `charms` BLOB NULL,
    `tracker_list` BLOB NULL,
    UNIQUE INDEX `idx_player_charms_player_id` (`player_id`),
    CONSTRAINT `player_charms_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_statements`
CREATE TABLE IF NOT EXISTS `player_statements` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`player_id` INT NOT NULL,
	`receiver` TEXT NOT NULL,
	`channel_id` INT NOT NULL DEFAULT 0,
	`text` VARCHAR (255) NOT NULL,
	`date` BIGINT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`), KEY (`player_id`), KEY (`channel_id`),
	FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_deaths`
CREATE TABLE IF NOT EXISTS `player_deaths` (
    `player_id` int(11) NOT NULL,
    `time` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `level` int(11) NOT NULL DEFAULT '1',
    `killed_by` varchar(255) NOT NULL,
    `is_player` tinyint(1) NOT NULL DEFAULT '1',
    `mostdamage_by` varchar(100) NOT NULL,
    `mostdamage_is_player` tinyint(1) NOT NULL DEFAULT '0',
    `unjustified` tinyint(1) NOT NULL DEFAULT '0',
    `mostdamage_unjustified` tinyint(1) NOT NULL DEFAULT '0',
    `position` varchar(30) NOT NULL DEFAULT '',
    `exp_loss` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `has_blessings` tinyint(1) NOT NULL DEFAULT '0',
    `blessings_count` tinyint(4) NOT NULL DEFAULT '0',
    `participants` TEXT NOT NULL,
    INDEX `player_id` (`player_id`),
    INDEX `idx_player_deaths_player_time` (`player_id`, `time`),
    INDEX `killed_by` (`killed_by`),
    INDEX `mostdamage_by` (`mostdamage_by`),
    CONSTRAINT `player_deaths_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_depotitems`
CREATE TABLE IF NOT EXISTS `player_depotitems` (
    `player_id` int(11) NOT NULL,
    `sid` int(11) NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
    `pid` int(11) NOT NULL DEFAULT '0',
    `itemtype` int(11) NOT NULL DEFAULT '0',
    `count` int(11) NOT NULL DEFAULT '0',
    `attributes` blob NOT NULL,
    CONSTRAINT `player_depotitems_unique` UNIQUE (`player_id`, `sid`),
    CONSTRAINT `player_depotitems_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_hirelings`
CREATE TABLE IF NOT EXISTS `player_hirelings` (
    `id` INT NOT NULL PRIMARY KEY auto_increment,
    `player_id` INT NOT NULL,
    `name` varchar(255),
    `active` tinyint unsigned NOT NULL DEFAULT '0',
    `sex` tinyint unsigned NOT NULL DEFAULT '0',
    `posx` int(11) NOT NULL DEFAULT '0',
    `posy` int(11) NOT NULL DEFAULT '0',
    `posz` int(11) NOT NULL DEFAULT '0',
    `lookbody` int(11) NOT NULL DEFAULT '0',
    `lookfeet` int(11) NOT NULL DEFAULT '0',
    `lookhead` int(11) NOT NULL DEFAULT '0',
    `looklegs` int(11) NOT NULL DEFAULT '0',
    `looktype` int(11) NOT NULL DEFAULT '136',
        FOREIGN KEY(`player_id`) REFERENCES `players`(`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_inboxitems`
CREATE TABLE IF NOT EXISTS `player_inboxitems` (
    `player_id` int(11) NOT NULL,
    `sid` int(11) NOT NULL,
    `pid` int(11) NOT NULL DEFAULT '0',
    `itemtype` int(11) NOT NULL DEFAULT '0',
    `count` int(11) NOT NULL DEFAULT '0',
    `attributes` blob NOT NULL,
    CONSTRAINT `player_inboxitems_unique` UNIQUE (`player_id`, `sid`),
    CONSTRAINT `player_inboxitems_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_items`
CREATE TABLE IF NOT EXISTS `player_items` (
    `player_id` int(11) NOT NULL DEFAULT '0',
    `pid` int(11) NOT NULL DEFAULT '0',
    `sid` int(11) NOT NULL DEFAULT '0',
    `itemtype` int(11) NOT NULL DEFAULT '0',
    `count` int(11) NOT NULL DEFAULT '0',
    `attributes` blob NOT NULL,
    INDEX `player_id` (`player_id`),
    INDEX `sid` (`sid`),
    CONSTRAINT `player_items_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE,
    CONSTRAINT `player_items_pk`
        PRIMARY KEY (`player_id`, `pid`, `sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_wheeldata`
CREATE TABLE IF NOT EXISTS `player_wheeldata` (
	`player_id` int(11) NOT NULL,
	`slot` blob NOT NULL,
	INDEX `player_id` (`player_id`),
	CONSTRAINT `player_wheeldata_players_fk`
		FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
		ON DELETE CASCADE,
  CONSTRAINT `player_wheeldata_pk`
      PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_kills`
CREATE TABLE IF NOT EXISTS `player_kills` (
    `player_id` int(11) NOT NULL,
    `time` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
    `target` int(11) NOT NULL,
    `unavenged` tinyint(1) NOT NULL DEFAULT '0',
    CONSTRAINT `player_kills_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_namelocks`
CREATE TABLE IF NOT EXISTS `player_namelocks` (
    `player_id` int(11) NOT NULL,
    `reason` varchar(255) NOT NULL,
    `namelocked_at` bigint(20) NOT NULL,
    `namelocked_by` int(11) NOT NULL,
    INDEX `namelocked_by` (`namelocked_by`),
    CONSTRAINT `player_namelocks_unique` UNIQUE (`player_id`),
    CONSTRAINT `player_namelocks_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `player_namelocks_players2_fk`
        FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_prey`
CREATE TABLE IF NOT EXISTS `player_prey` (
    `player_id` int(11) NOT NULL,
    `slot` tinyint(1) NOT NULL,
    `state` tinyint(1) NOT NULL,
    `raceid` varchar(250) NOT NULL,
    `option` tinyint(1) NOT NULL,
    `bonus_type` tinyint(1) NOT NULL,
    `bonus_rarity` tinyint(1) NOT NULL,
    `bonus_percentage` varchar(250) NOT NULL,
    `bonus_time` varchar(250) NOT NULL,
    `free_reroll` bigint(20) NOT NULL,
    `monster_list` BLOB NULL,
    CONSTRAINT `player_prey_pk` PRIMARY KEY (`player_id`, `slot`),
    CONSTRAINT `player_prey_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_taskhunt`
CREATE TABLE IF NOT EXISTS `player_taskhunt` (
    `player_id` int(11) NOT NULL,
    `slot` tinyint(1) NOT NULL,
    `state` tinyint(1) NOT NULL,
    `raceid` varchar(250) NOT NULL,
    `upgrade` tinyint(1) NOT NULL,
    `rarity` tinyint(1) NOT NULL,
    `kills` varchar(250) NOT NULL,
    `disabled_time` bigint(20) NOT NULL,
    `free_reroll` bigint(20) NOT NULL,
    `monster_list` BLOB NULL,
    CONSTRAINT `player_taskhunt_pk` PRIMARY KEY (`player_id`, `slot`),
    CONSTRAINT `player_taskhunt_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_bosstiary`
CREATE TABLE IF NOT EXISTS `player_bosstiary` (
    `player_id` int NOT NULL,
    `bossIdSlotOne` int NOT NULL DEFAULT 0,
    `bossIdSlotTwo` int NOT NULL DEFAULT 0,
    `removeTimes` int NOT NULL DEFAULT 1,
    `tracker` blob NOT NULL,
    INDEX `idx_player_bosstiary_slot1` (`bossIdSlotOne`),
    INDEX `idx_player_bosstiary_slot2` (`bossIdSlotTwo`),
    CONSTRAINT `player_bosstiary_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_rewards`
CREATE TABLE IF NOT EXISTS `player_rewards` (
    `player_id` int(11) NOT NULL,
    `sid` int(11) NOT NULL,
    `pid` int(11) NOT NULL DEFAULT '0',
    `itemtype` int(11) NOT NULL DEFAULT '0',
    `count` int(11) NOT NULL DEFAULT '0',
    `attributes` blob NOT NULL,
    CONSTRAINT `player_rewards_unique` UNIQUE (`player_id`, `sid`),
    CONSTRAINT `player_rewards_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_spells`
CREATE TABLE IF NOT EXISTS `player_spells` (
    `player_id` int(11) NOT NULL,
    `name` varchar(255) NOT NULL,
    INDEX `player_id` (`player_id`),
    CONSTRAINT `player_spells_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE,
    CONSTRAINT `player_spells_pk` PRIMARY KEY (`player_id`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_stash`
CREATE TABLE IF NOT EXISTS `player_stash` (
    `player_id` INT(16) NOT NULL,
    `item_id` INT(16) NOT NULL,
    `item_count` INT(32) NOT NULL,
    CONSTRAINT `player_stash_pk` PRIMARY KEY (`player_id`, `item_id`),
    CONSTRAINT `player_stash_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_storage`
CREATE TABLE IF NOT EXISTS `player_storage` (
    `player_id` int(11) NOT NULL DEFAULT '0',
    `key` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `value` int(11) NOT NULL DEFAULT '0',
    CONSTRAINT `player_storage_pk` PRIMARY KEY (`player_id`, `key`),
    CONSTRAINT `player_storage_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `player_outfits`
CREATE TABLE IF NOT EXISTS `player_outfits` (
    `player_id` int(11) NOT NULL DEFAULT '0',
    `outfit_id` smallint(4) UNSIGNED NOT NULL DEFAULT '0',
    `addons` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
	CONSTRAINT `player_outfits_pk` PRIMARY KEY (`player_id`, `outfit_id`),
	CONSTRAINT `player_outfits_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players`(`id`)
		ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

-- Table structure `player_mounts`
CREATE TABLE IF NOT EXISTS `player_mounts` (
    `player_id` int(11) NOT NULL DEFAULT '0',
    `mount_id` smallint(4) UNSIGNED NOT NULL DEFAULT '0',
	CONSTRAINT `player_mounts_pk` PRIMARY KEY (`player_id`, `mount_id`),
	CONSTRAINT `player_mounts_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players`(`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

-- Table structure `store_history`
CREATE TABLE IF NOT EXISTS `store_history` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `account_id` int(11) UNSIGNED NOT NULL,
    `mode` smallint(2) NOT NULL DEFAULT '0',
    `description` varchar(3500) NOT NULL,
    `coin_type` tinyint(1) NOT NULL DEFAULT '0',
    `coin_amount` int(12) NOT NULL,
    `time` bigint(20) UNSIGNED NOT NULL,
    `timestamp` int(11) NOT NULL DEFAULT '0',
    `coins` int(11) NOT NULL DEFAULT '0',
    INDEX `account_id` (`account_id`),
    INDEX `idx_store_history_account_coins` (`account_id`, `coin_amount`, `mode`),
    CONSTRAINT `store_history_pk` PRIMARY KEY (`id`),
    CONSTRAINT `store_history_account_fk`
    FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `tile_store`
CREATE TABLE IF NOT EXISTS `tile_store` (
    `house_id` int(11) NOT NULL,
    `data` longblob NOT NULL,
    INDEX `house_id` (`house_id`),
    CONSTRAINT `tile_store_account_fk`
        FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `towns`
CREATE TABLE IF NOT EXISTS `towns` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `posx` int NOT NULL DEFAULT '0',
    `posy` int NOT NULL DEFAULT '0',
    `posz` int NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

-- Table structure `account_sessions`
CREATE TABLE IF NOT EXISTS `account_sessions` (
  `id` VARCHAR(191) NOT NULL,
  `account_id` INTEGER UNSIGNED NOT NULL,
  `expires` BIGINT UNSIGNED NOT NULL,

  PRIMARY KEY (`id`),
  INDEX `idx_account_sessions_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure `kv_store`
CREATE TABLE IF NOT EXISTS `kv_store` (
  `key_name` varchar(191) NOT NULL,
  `timestamp` bigint NOT NULL,
  `value` longblob NOT NULL,
  PRIMARY KEY (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create Account god/god
INSERT IGNORE INTO `accounts`
(`id`, `name`, `email`, `password`, `type`) VALUES
(1, 'god', 'joaocrdias17+god@gmail.com', '21298df8a3277357ee55b01df9530b535cf08ec1', 5);

-- Create player on GOD account
-- Create sample characters (level 20, promoted vocations)
INSERT IGNORE INTO `players`
(`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `maglevel`, `mana`, `manamax`, `manaspent`, `town_id`, `conditions`, `cap`, `sex`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`) VALUES
(1, 'Rook Sample', 1, 1, 2, 0, 155, 155, 100, 113, 115, 95, 39, 128, 2, 60, 60, 5936, 1, '', 410, 1, 12, 155, 12, 155, 12, 155, 12, 93),
(2, 'Sorcerer Sample', 1, 1, 20, 5, 245, 245, 98800, 113, 115, 95, 39, 130, 0, 450, 450, 0, 1, '', 590, 1, 10, 0, 10, 0, 10, 0, 10, 0),
(3, 'Druid Sample', 1, 1, 20, 6, 245, 245, 98800, 113, 115, 95, 39, 144, 0, 450, 450, 0, 1, '', 590, 1, 10, 0, 10, 0, 10, 0, 10, 0),
(4, 'Paladin Sample', 1, 1, 20, 7, 305, 305, 98800, 113, 115, 95, 39, 129, 0, 270, 270, 0, 1, '', 710, 1, 10, 0, 10, 0, 10, 0, 10, 0),
(5, 'Knight Sample', 1, 1, 20, 8, 365, 365, 98800, 113, 115, 95, 39, 131, 0, 150, 150, 0, 1, '', 770, 1, 10, 0, 10, 0, 10, 0, 10, 0),
(6, 'Monk Sample', 1, 1, 20, 10, 305, 305, 98800, 113, 115, 95, 39, 1824, 0, 210, 210, 0, 1, '', 770, 1, 10, 0, 10, 0, 10, 0, 10, 0);

CREATE TABLE `roulette_plays` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `player_id` INT NOT NULL,
  `uuid` VARCHAR(255) NOT NULL,
  `reward_id` INT NOT NULL,
  `reward_count` INT NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0 = rolling | 1 = pending | 2 = delivered',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` BIGINT NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `roulette_plays_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `castle_war` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `guild_id` INT NOT NULL,
    `guild_name` VARCHAR(255) NOT NULL,
    `timestamp` BIGINT NOT NULL,
    `throne_points` INT NOT NULL DEFAULT 0,
    `active` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_guild_id` (`guild_id`),
    KEY `idx_active` (`active`),
    UNIQUE KEY `unique_active_guild` (`guild_id`, `active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `client_version` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `environment` ENUM('production', 'testServer') NOT NULL DEFAULT 'production',
  `client_type` ENUM('cip', 'otc') NOT NULL DEFAULT 'cip',
  `version` VARCHAR(50) NOT NULL,
  `download_url` VARCHAR(500) NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_env_type` (`environment`, `client_type`),
  INDEX `client_version_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default client versions
INSERT INTO `client_version` (`environment`, `client_type`, `version`, `download_url`, `is_active`) VALUES
  ('production', 'cip', '1.0.0', 'https://game.koliseuot.com.br/downloads/client-1.0.0.zip', 1),
  ('production', 'otc', '1.0.0', '', 1),
  ('testServer', 'cip', '1.0.0', '', 1),
  ('testServer', 'otc', '1.0.0', '', 1);

CREATE TABLE IF NOT EXISTS `gnome_arena_stats` (
    `player_id` int(11) NOT NULL,
    `best_wave` int(11) UNSIGNED NOT NULL DEFAULT 0,
    `last_play_ready_at` int(11) UNSIGNED NOT NULL DEFAULT 0,
    `total_runs` int(11) UNSIGNED NOT NULL DEFAULT 0,
    `total_waves` int(11) UNSIGNED NOT NULL DEFAULT 0,
    CONSTRAINT `gnome_arena_stats_pk` PRIMARY KEY (`player_id`),
    CONSTRAINT `gnome_arena_stats_player_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `battlepass_seasons` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `release_date` BIGINT NOT NULL,
  `active` TINYINT(1) DEFAULT 1,
  `mount_id` INT DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `player_battlepass` (
  `player_id` INT NOT NULL,
  `season_id` INT NOT NULL,
  `activation_time` BIGINT NOT NULL,
  `last_claim_time` BIGINT DEFAULT 0,
  `claimed_days` VARCHAR(255) DEFAULT '',
  PRIMARY KEY (`player_id`, `season_id`),
  FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`season_id`) REFERENCES `battlepass_seasons`(`id`) ON DELETE CASCADE,
  KEY `idx_season` (`season_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert Battle Pass Season 1
INSERT INTO `battlepass_seasons` (`id`, `name`, `release_date`, `active`, `mount_id`)
VALUES (1, 'Relic Hunter - Season 1', UNIX_TIMESTAMP(), 1, 255)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Insert Battle Pass Season 2
INSERT INTO `battlepass_seasons` (`id`, `name`, `release_date`, `active`, `mount_id`)
VALUES (2, 'Cosmic Wolfes - Season 2', UNIX_TIMESTAMP(), 1, NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Table structure `hunted_system`
CREATE TABLE IF NOT EXISTS `hunted_system` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `player_id` int(11) NOT NULL,
    `player_name` varchar(255) NOT NULL,
    `bounty` bigint(20) NOT NULL DEFAULT '0',
    `placed_by_id` int(11) NOT NULL,
    `placed_by_name` varchar(255) NOT NULL,
    `placed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `player_id` (`player_id`),
    KEY `bounty` (`bounty` DESC),
    CONSTRAINT `hunted_system_player_fk` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Cria a tabela de tokens de reset de senha
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` int(10) UNSIGNED NOT NULL,
  `token` varchar(128) NOT NULL,
  `expires_at` bigint(20) UNSIGNED NOT NULL,
  `created_at` bigint(20) UNSIGNED NOT NULL,
  `used_at` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_unique` (`token`),
  KEY `account_id` (`account_id`),
  KEY `expires_at` (`expires_at`),
  KEY `idx_cleanup` (`expires_at`, `used_at`),
  CONSTRAINT `password_reset_tokens_account_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `donations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` INT UNSIGNED NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `coins` INT UNSIGNED NOT NULL,
  `origin` VARCHAR(50) NOT NULL DEFAULT 'donation',
  `payment_method` VARCHAR(50) NOT NULL,
  `payment_id` VARCHAR(255) DEFAULT NULL,
  `status` VARCHAR(50) NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  `metadata` TEXT,
  `referral_code` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `donations_account_id` (`account_id`),
  KEY `donations_payment_id` (`payment_id`),
  KEY `donations_status` (`status`),
  KEY `donations_referral_code` (`referral_code`),
  KEY `donations_referral_status` (`referral_code`, `status`),
  CONSTRAINT `donations_account_fk`
    FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_login_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `ip` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `login_time` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `player_login_history_player_id` (`player_id`),
  KEY `player_login_history_ip` (`ip`),
  CONSTRAINT `player_login_history_player_fk`
    FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure `powergamers_snapshot`
-- Stores player experience at server save for the powergamers ranking
CREATE TABLE IF NOT EXISTS `powergamers_snapshot` (
  `player_id` int(11) NOT NULL,
  `experience` bigint(20) NOT NULL DEFAULT '0',
  `snapshot_time` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`),
  CONSTRAINT `powergamers_snapshot_player_fk`
    FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure `character_sales`
CREATE TABLE IF NOT EXISTS `character_sales` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `player_id` int(11) NOT NULL,
    `seller_account_id` int(11) UNSIGNED NOT NULL,
    `buyer_account_id` int(11) UNSIGNED DEFAULT NULL,
    `price` int(11) UNSIGNED NOT NULL,
    `fee` int(11) UNSIGNED NOT NULL,
    `status` varchar(20) NOT NULL DEFAULT 'active',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `sold_at` timestamp NULL DEFAULT NULL,
    `player_name` varchar(255) NOT NULL,
    `player_level` int(11) NOT NULL,
    `player_vocation` int(11) NOT NULL,
    `player_sex` int(11) NOT NULL,
    `player_looktype` int(11) NOT NULL,
    `player_lookbody` int(11) NOT NULL,
    `player_lookhead` int(11) NOT NULL,
    `player_looklegs` int(11) NOT NULL,
    `player_lookfeet` int(11) NOT NULL,
    `player_lookaddons` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `seller_account_id` (`seller_account_id`),
    KEY `buyer_account_id` (`buyer_account_id`),
    KEY `player_id` (`player_id`),
    KEY `status` (`status`),
    KEY `idx_character_sales_name_status` (`player_name`, `status`),
    CONSTRAINT `character_sales_player_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE,
    CONSTRAINT `character_sales_seller_fk`
        FOREIGN KEY (`seller_account_id`) REFERENCES `accounts` (`id`)
        ON DELETE CASCADE,
    CONSTRAINT `character_sales_buyer_fk`
        FOREIGN KEY (`buyer_account_id`) REFERENCES `accounts` (`id`)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `pending_email_changes` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` INT UNSIGNED NOT NULL,
    `new_email` VARCHAR(255) NOT NULL,
    `created_at` BIGINT UNSIGNED NOT NULL,
    `execute_at` BIGINT UNSIGNED NOT NULL,
    `executed_at` BIGINT UNSIGNED DEFAULT NULL,
    `cancelled_at` BIGINT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `account_id` (`account_id`),
    KEY `execute_at` (`execute_at`),
    CONSTRAINT `pending_email_changes_account_fk`
        FOREIGN KEY (`account_id`)
        REFERENCES `accounts` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `launcher_version` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `version` VARCHAR(32) NOT NULL,
  `notes` TEXT NULL,
  `pub_date` TIMESTAMP NOT NULL,
  `url` TEXT NOT NULL,
  `signature` TEXT NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create account_audit_log table for tracking all account-related actions
CREATE TABLE IF NOT EXISTS `account_audit_log` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` INT UNSIGNED NOT NULL,
  `action` VARCHAR(50) NOT NULL,
  `details` JSON DEFAULT NULL,
  `ip_address` VARCHAR(45) NOT NULL DEFAULT '0.0.0.0',
  `user_agent` VARCHAR(512) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_account_id` (`account_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_created_at` (`created_at`),
  CONSTRAINT `account_audit_log_account_fk`
    FOREIGN KEY (`account_id`)
    REFERENCES `accounts` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Winter Update 2025 / protocol 15.23: Task Board (bounty + weekly tasks).
CREATE TABLE IF NOT EXISTS `player_bounty_tasks` (
    `player_id` int NOT NULL,
    `state` tinyint NOT NULL DEFAULT 0,
    `difficulty` tinyint NOT NULL DEFAULT 0,
    `bounty_points` int NOT NULL DEFAULT 0,
    `reroll_tokens` tinyint NOT NULL DEFAULT 0,
    `free_reroll` bigint NOT NULL DEFAULT 0,
    `active_raceid` int NOT NULL DEFAULT 0,
    `active_kills` int NOT NULL DEFAULT 0,
    `active_required_kills` int NOT NULL DEFAULT 0,
    `active_reward_exp` int NOT NULL DEFAULT 0,
    `active_reward_points` tinyint NOT NULL DEFAULT 0,
    `active_task_grade` tinyint NOT NULL DEFAULT 0,
    `active_task_difficulty` tinyint NOT NULL DEFAULT 0,
    `talisman_damage_level` tinyint NOT NULL DEFAULT 0,
    `talisman_lifeleech_level` tinyint NOT NULL DEFAULT 0,
    `talisman_loot_level` tinyint NOT NULL DEFAULT 0,
    `talisman_bestiary_level` tinyint NOT NULL DEFAULT 0,
    `preferred_lists` BLOB NULL,
    `current_creatures_list` BLOB NULL,
    CONSTRAINT `player_bounty_tasks_pk` PRIMARY KEY (`player_id`),
    CONSTRAINT `player_bounty_tasks_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_weekly_tasks` (
    `player_id` int NOT NULL,
    `has_expansion` BOOLEAN NOT NULL DEFAULT FALSE,
    `difficulty` tinyint NOT NULL DEFAULT 0,
    `any_creature_total_kills` int NOT NULL DEFAULT 0,
    `any_creature_current_kills` int NOT NULL DEFAULT 0,
    `completed_kill_tasks` tinyint NOT NULL DEFAULT 0,
    `completed_delivery_tasks` tinyint NOT NULL DEFAULT 0,
    `kill_task_reward_exp` int NOT NULL DEFAULT 0,
    `delivery_task_reward_exp` int NOT NULL DEFAULT 0,
    `reward_hunting_points` int NOT NULL DEFAULT 0,
    `reward_soulseals` int NOT NULL DEFAULT 0,
    `soulseals_points` int NOT NULL DEFAULT 0,
    `needs_reward` tinyint NOT NULL DEFAULT 0,
    `weekly_progress_finished` tinyint NOT NULL DEFAULT 0,
    `kill_tasks` BLOB NULL,
    `delivery_tasks` BLOB NULL,
    CONSTRAINT `player_weekly_tasks_pk` PRIMARY KEY (`player_id`),
    CONSTRAINT `player_weekly_tasks_players_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

