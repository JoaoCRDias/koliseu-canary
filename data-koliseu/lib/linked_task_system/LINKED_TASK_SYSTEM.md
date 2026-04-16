# Linked Task System

## Overview

A sequential, non-repeatable task system organized in 5 rooms (tiers). Players must complete tasks in order within each room, and complete all tasks in a room before unlocking the next. Completely separate from the daily task system.

Permanent bonuses (XP, Loot, Forge success) are awarded upon completing entire rooms, stacking across all rooms.

---

## How It Works

### Player Flow

1. Player enters one of 5 rooms via teleporters (Easy, Medium, Hard, Epic, Rampage)
2. Each room contains totems (one per task), arranged in order
3. Player clicks the first totem to accept the task
4. Player hunts the specified monsters until the kill count is reached
5. Player returns to the totem and clicks it to claim the reward
6. The next totem in sequence becomes available
7. After completing ALL tasks in a room, the room completion reward is granted
8. The next room is unlocked

### Rules

- Tasks must be completed in order (Task 1 before Task 2, etc.)
- Only one linked task can be active at a time
- Tasks are NOT repeatable (one-time only per character)
- Room N+1 requires completing ALL tasks in Room N
- Room 1 (Easy) is always accessible
- Players can check progress with `!linkedtask` or `!ltask`

---

## Architecture

### Files

| File | Purpose |
|------|---------|
| `data-crystal/lib/linked_task_system/linked_task_lib.lua` | Core library: configuration, room/task definitions, helper functions, reward system |
| `data-crystal/lib/linked_task_system/linked_task_action.lua` | Totem interaction handler (accept task, check progress, claim reward) |
| `data-crystal/lib/linked_task_system/linked_task_creaturescript.lua` | Monster death event - tracks kills for active task |
| `data-crystal/lib/linked_task_system/linked_task_globalevent.lua` | Startup event - registers kill tracking on all task monsters |
| `data-crystal/scripts/actions/linked_task_system_loader.lua` | Loader script (autoloaded by revscriptsys) |
| `data-crystal/scripts/talkactions/player/linked_task.lua` | `!linkedtask` command for progress checking |
| `data/events/scripts/player.lua` | XP bonus hook (in `onGainExperience`) |
| `data/libs/functions/player.lua` | Loot bonus hook (in `calculateLootFactor`) |
| `src/game/game.cpp` | Forge success bonus hook (in `playerForgeFuseItems`) |

### Loading Order

1. `lib.lua` loads `linked_task_lib.lua` (defines `LinkedTask` global table, builds lookup tables)
2. RevScriptSys autoloads `linked_task_system_loader.lua` which loads the action, creaturescript, and globalevent
3. On server startup, `LinkedTaskStartup` globalevent registers the `LinkedTaskKill` creature event on all task monster types

---

## Storage Layout

All storages are in the range **192000-192999**.

| Storage | Purpose |
|---------|---------|
| 192000 | Quest log marker |
| 192001 | Active room index (1-5) |
| 192002 | Active task global index |
| 192003 | Kill counter for active task |
| 192004 | Task status (0=none, 1=active, 2=kills complete) |
| 192010 | Permanent XP bonus (percentage, cumulative) |
| 192011 | Permanent Loot bonus (percentage, cumulative) |
| 192012 | Permanent Forge success bonus (flat %, cumulative) |
| 192100-192104 | Room completion flags (1 per room) |
| 192200-192499 | Individual task completion flags (1 per task) |

### Task Status Values

| Value | Meaning |
|-------|---------|
| 0 | No active task |
| 1 | Task active, hunting in progress |
| 2 | Kill requirement met, return to totem |
| 3 | Reward claimed (then resets to 0) |

---

## Action IDs (Totems)

Each totem on the map needs an **Action ID** assigned. The formula is:

```
Action ID = 57000 + Global Task Index
```

---

## Complete Task List

### Room 1: Easy (14 tasks)

| # | Global | Action ID | Task Name | Monsters | Kills | Rewards |
|---|--------|-----------|-----------|----------|-------|---------|
| 1 | 1 | 57001 | Minotaurs | Minotaur, Minotaur Archer, Minotaur Guard, Minotaur Mage | 500 | 500k exp |
| 2 | 2 | 57002 | Dwarves | Dwarf, Dwarf Guard, Dwarf Soldier, Dwarf Geomancer | 600 | 750k exp |
| 3 | 3 | 57003 | Cyclops | Cyclops, Cyclops Drone, Cyclops Smith | 800 | 1M exp, 1M gold |
| 4 | 4 | 57004 | Apes | Sibang, Kongra, Merlkin | 800 | 1.25M exp |
| 5 | 5 | 57005 | Vampires | Vampire, Vampire Bride, Vampire Viscount | 1,000 | 1.5M exp, 2M gold |
| 6 | 6 | 57006 | Ancient Scarab | Ancient Scarab | 1,200 | 1.75M exp, 1x Boosted Exercise Token |
| 7 | 7 | 57007 | Cults | Cult Enforcer, Cult Believer, Cult Scholar | 1,400 | 2M exp |
| 8 | 8 | 57008 | Undead | Putrid Mummy, Bonebeast | 1,600 | 2.25M exp, 1x Exercise Speed Improvement |
| 9 | 9 | 57009 | Knights | Hero, Vicious Squire, Renegade Knight | 1,800 | 2.5M exp, 3x Roulette Coin |
| 10 | 10 | 57010 | Dragons | Dragon, Dragon Lord, Dragon Lord Hatchling, Dragon Hatchling | 2,000 | 2.75M exp, 50x Addon Doll (store) |
| 11 | 11 | 57011 | Werecreatures | Werefox, Wereboar, Werebear, Werebadger | 2,200 | 3M exp, 50x Mount Doll (store) |
| 12 | 12 | 57012 | Spiders | Giant Spider, Tarantula | 2,400 | 3.25M exp, 3x Surprise Gem Bag |
| 13 | 13 | 57013 | Golems | Worker Golem, War Golem | 2,600 | 3.5M exp, 1x Bag You Desire |
| 14 | 14 | 57014 | Banshees | Banshee, Nightstalker | 2,600 | 3.75M exp, 1x Primal Bag |

**Total kills: 19,500** | **Room reward: +1% XP, +10 levels, 1x Bag You Covet**

---

### Room 2: Medium (27 tasks)

| # | Global | Action ID | Task Name | Monsters | Kills | Rewards |
|---|--------|-----------|-----------|----------|-------|---------|
| 1 | 15 | 57015 | Desert Warriors | Burning Gladiator, Priestess Of The Wild Sun, Black Sphinx Acolyte | 3,000 | 3.75M exp, 10M gold |
| 2 | 16 | 57016 | Carnivors | Spiky Carnivor, Lumbering Carnivor, Menacing Carnivor | 3,000 | 4M exp |
| 3 | 17 | 57017 | Summer Court | Crazed Summer Rearguard, Crazed Summer Vanguard, Insane Siren | 3,000 | 4.25M exp |
| 4 | 18 | 57018 | Winter Court | Crazed Winter Rearguard, Crazed Winter Vanguard, Soul-Broken Harbinger | 3,000 | 4.5M exp, 2x Epic/Medium/Basic Upgrade Stone |
| 5 | 19 | 57019 | Nightmares | Frazzlemaw, Guzzlemaw, Silencer | 3,500 | 4.75M exp |
| 6 | 20 | 57020 | Horrors | Choking Fear, Retching Horror | 3,500 | 5M exp, 50M gold |
| 7 | 21 | 57021 | Gazer Spectres | Gazer Spectre, Thanatursus | 3,500 | 5.25M exp |
| 8 | 22 | 57022 | Ripper Spectres | Arachnophobica, Ripper Spectre | 3,500 | 5.5M exp, 2x Common Training Chest |
| 9 | 23 | 57023 | Grimeleech | Grimeleech, Plaguesmith | 4,000 | 5.75M exp |
| 10 | 24 | 57024 | Vexclaw | Vexclaw, Hellhound | 4,000 | 6M exp, 100x Tainted Heart, 100x Darklight Heart |
| 11 | 25 | 57025 | Hellflayer | Hellflayer, Juggernaut | 4,000 | 6.25M exp |
| 12 | 26 | 57026 | Falcons | Falcon Paladin, Falcon Knight | 4,000 | 6.5M exp |
| 13 | 27 | 57027 | Deathlings | Deathling Spellsinger, Deathling Scout | 4,500 | 6.75M exp, 5x Prey Wildcard |
| 14 | 28 | 57028 | Asuras | Midnight Asura, Frost Flower Asura, Dawnfire Asura | 4,500 | 7M exp |
| 15 | 29 | 57029 | Undead Warriors | Undead Elite Gladiator, Skeleton Elite Warrior | 4,500 | 7.25M exp, 2x each Soul War Essence |
| 16 | 30 | 57030 | True Asuras | True Midnight Asura, True Frost Flower Asura, True Dawnfire Asura | 4,500 | 7.5M exp |
| 17 | 31 | 57031 | Lost Souls | Flimsy Lost Soul, Freakish Lost Soul, Mean Lost Soul | 5,000 | 7.75M exp |
| 18 | 32 | 57032 | Devourers | Streaked Devourer, Lavaworm, Lavafungus | 5,000 | 8M exp, 5x Mystery Bag |
| 19 | 33 | 57033 | Girtablilu | Venerable Girtablilu, Girtablilu Warrior | 5,000 | 8.25M exp |
| 20 | 34 | 57034 | Icecold Books | Icecold Book, Animated Feather, Squid Warden | 5,000 | 8.5M exp |
| 21 | 35 | 57035 | Burning Books | Burning Book, Rage Squid, Guardian Of Tales | 5,500 | 8.75M exp, 200x Addon Doll (store), 200x Mount Doll (store) |
| 22 | 36 | 57036 | Cursed Books | Cursed Book | 5,500 | 9M exp |
| 23 | 37 | 57037 | Energetic Books | Energetic Book, Energuardian Of Tales, Knowledge Elemental | 5,500 | 9.25M exp, 1x Premium Scroll |
| 24 | 38 | 57038 | Bulltaurs | Bulltaur Alchemist, Bulltaur Forgepriest, Bulltaur Brute | 5,500 | 9.5M exp |
| 25 | 39 | 57039 | Goannas | Adult Goanna, Young Goanna | 6,000 | 9.75M exp, 2x Tier Upgrader |
| 26 | 40 | 57040 | Underground Beasts | Cave Chimera, Varnished Diremaw, Tremendous Tyrant | 6,000 | 10M exp, 1x Earth Protector, 1x Holy Protector |
| 27 | 41 | 57041 | Wildlands | Carnivostrich, Liodile, Harpy | 6,000 | 10.25M exp, 1x Ice Protector, 1x Death Protector |
| 28 | 42 | 57042 | Cobras | Cobra Vizier, Cobra Scout, Cobra Assassin | 6,000 | 10.5M exp, 1x Fire Protector, 1x Energy Protector |

**Total kills: 123,500** | **Room reward: +2% XP, +1% Forge, +20 levels, 1x Starlight Power**

---

### Room 3: Hard (16 tasks)

| # | Global | Action ID | Task Name | Monsters | Kills | Rewards |
|---|--------|-----------|-----------|----------|-------|---------|
| 1 | 43 | 57043 | Infernal | Infernal Phantom, Infernal Demon, Brachiodemon | 7,000 | 8.5M exp, 10x Roulette Coin |
| 2 | 44 | 57044 | Rotting | Mould Phantom, Branchy Crawler, Rotten Golem | 7,000 | 8.75M exp |
| 3 | 45 | 57045 | Apparitions | Many Faces, Distorted Phantom, Paladin's/Knight's/Druid's/Sorcerer's Apparition | 8,000 | 9M exp, 5x Basic/Medium/Epic Upgrade Stone |
| 4 | 46 | 57046 | Sea Devils | Capricious Phantom, Bony Sea Devil, Turbulent Elemental | 8,000 | 9.25M exp |
| 5 | 47 | 57047 | Vibrant Phantoms | Vibrant Phantom, Cloak Of Terror, Courage Leech | 9,000 | 9.5M exp, 100M gold |
| 6 | 48 | 57048 | Prehistoric I | Mercurial Menace, Noxious Ripptor, Headpecker | 9,000 | 9.75M exp |
| 7 | 49 | 57049 | Prehistoric II | Gorerilla, Hulking Prehemoth, Emerald Tortoise, Sabretooth | 10,000 | 10M exp, 2x Common Training Chest |
| 8 | 50 | 57050 | Night Hunters | Sulphur Spouter, Sulphider, Nighthunter, Undertaker | 10,000 | 10.25M exp |
| 9 | 51 | 57051 | Carcasses | Oozing Carcass, Sopping Carcass, Rotten Man-Maggot, Meandering Mushroom | 11,000 | 10.5M exp, 3x Lesser/Normal/Greater Exp Potion |
| 10 | 52 | 57052 | Darklight | Darklight Matter, Walking Pillar, Darklight Source, Darklight Striker | 11,000 | 10.75M exp |
| 11 | 53 | 57053 | Corpses | Sopping Corpus, Oozing Corpus, Bloated Man-Maggot, Mycobiontic Beetle | 12,000 | 11M exp, 150M gold |
| 12 | 54 | 57054 | Pillars | Wandering Pillar, Darklight Construct, Darklight Emitter, Converter | 12,000 | 11.25M exp |
| 13 | 55 | 57055 | Cosmic I | Void Crawler, Rift Stalker, Astral Leech | 13,000 | 11.5M exp, 3x Prey Wildcard |
| 14 | 56 | 57056 | Cosmic II | Starfall Sentinel, Dimensional Shade, Nebula Weaver | 13,000 | 11.75M exp |
| 15 | 57 | 57057 | Cosmic III | Cosmic Warden, Entropy Devourer, Singularity Spawn | 14,000 | 12M exp |
| 16 | 58 | 57058 | Cosmic IV | Reality Fracture, Oblivion Herald, Event Horizon | 14,000 | 12.25M exp, 100x Cosmic Token |

**Total kills: 168,000** | **Room reward: +3% XP, +3% Loot, +2% Forge, +40 levels, 1x Bag of Cosmic Wishes**

---

### Room 4: Epic (20 tasks)

| # | Global | Action ID | Task Name | Monsters | Kills | Rewards |
|---|--------|-----------|-----------|----------|-------|---------|
| 1 | 59 | 57059 | Anomalies | Anomaly Man, Flaming Bastard, Remains of Chemical | 15,000 | 11.25M exp |
| 2 | 60 | 57060 | Executioners | Crushing Executioner, Bloodthirsty Executioner, Dark Executioner | 15,000 | 11.5M exp |
| 3 | 61 | 57061 | Necrotic | Bonecrusher Wight, Graveshroud Revenant, Necrotic Overlord | 15,000 | 11.75M exp, 200M gold |
| 4 | 62 | 57062 | Thunder | Voltspawn Herald, Arcsurge Conduit, Thundercore Titan | 15,000 | 12M exp |
| 5 | 63 | 57063 | Dragons | Bluehide Dragon, Stonehide Dragon, Darkhide Dragon | 15,000 | 12.25M exp, 1x Silver Plan of Craft |
| 6 | 64 | 57064 | Bone Fiends | Bonegrinder, Ancient Gozzler, Soulleecher | 17,000 | 12.5M exp |
| 7 | 65 | 57065 | Ancients | Shellbreaker Ancient, Ironshell Guardian, Mosscrag Colossus | 17,000 | 12.75M exp, 2x Tier Upgrader |
| 8 | 66 | 57066 | Infernal Punishers | Infernal Punisher, Wrathborn Fury, Blazefury Ravager | 17,000 | 13M exp |
| 9 | 67 | 57067 | Storm Dragons | Tempest Wing, Atrophied Wings, Shadowflame Dragon | 17,000 | 13.25M exp |
| 10 | 68 | 57068 | Dark Monarchs | Carrion Monarch, Demonic Soul, Demonic Beholder | 17,000 | 13.5M exp, 5x Epic/Medium/Basic Upgrade Stone |
| 11 | 69 | 57069 | Void Casters | Voidcaller Archon, Runeweaver Adept, Hexbound Sorcerer | 20,000 | 13.75M exp |
| 12 | 70 | 57070 | Pumpkins | Wailing Jack, Grim Gourd, Twisted Pumpkinling | 20,000 | 14M exp |
| 13 | 71 | 57071 | Sentinels | Prismatic Sentinel, Gemheart Warden, Shardborn Golem | 20,000 | 14.25M exp, 100x Cosmic Token |
| 14 | 72 | 57072 | Volcanic | Volcanic Destroyer, Cinder Behemoth, Magma Stalker | 20,000 | 14.5M exp |
| 15 | 73 | 57073 | Abyssal | Rattling Abyssal, Infernal Bonefiend, Bonefiend | 20,000 | 14.75M exp, 300M gold |
| 16 | 74 | 57074 | Sinspawn | Sinspawn, Shiny Dog, Reaper Apparition | 25,000 | 15M exp |
| 17 | 75 | 57075 | Gloomcasters | Lier, Gloomcaster Minister, Shiny Bald | 25,000 | 15.25M exp, 1x Golden Plan of Craft |
| 18 | 76 | 57076 | Deep Sea | Deepfang Predator, Abyssal Mauler, Tidalwrath Leviathan | 25,000 | 15.5M exp |
| 19 | 77 | 57077 | Assassins | Venomblade Assassin, Shadowstep Cutthroat, Nightfall Executioner | 25,000 | 15.75M exp |
| 20 | 78 | 57078 | Serpents | Serpentcrown Mystic, Nagascale Guardian, Coilfang Matriarch | 25,000 | 16M exp, 3x Common Training Chest |

**Total kills: 385,000** | **Room reward: +4% XP, +5% Loot, +3% Forge, +40 levels, 1x Bag of Your Dreams**

---

### Room 5: Rampage (9 tasks)

| # | Global | Action ID | Task Name | Monsters | Kills | Rewards |
|---|--------|-----------|-----------|----------|-------|---------|
| 1 | 79 | 57079 | Ogres I | Riftburn Ogre, Servant Of The Ogres, Doomcurrent Ogre | 30,000 | 14.75M exp, 500M gold |
| 2 | 80 | 57080 | Ogres II | Rotmaw Ogre, Baby Ogre, Stoneflesh Ogre | 30,000 | 15M exp |
| 3 | 81 | 57081 | Plague I | Venomrot Wraith, Pest Disperser, Blightbone Revenant | 30,000 | 15.25M exp, 300M gold |
| 4 | 82 | 57082 | Plague II | Plaguefiend Behemoth, Plaguefiend Bonelord, Dreadmaw Corruptor | 30,000 | 15.5M exp |
| 5 | 83 | 57083 | Pirates | Powder Gunner, Saltwater Corsair, Plunderer Captain | 30,000 | 15.75M exp, 300M gold |
| 6 | 84 | 57084 | Buccaneers | Crimson Buccaneer, Storm Conjurer, Frostpelt Marauder | 30,000 | 16M exp |
| 7 | 85 | 57085 | Mining Camp | Stonepick Digger, Runeshot Artillerist, Molten Forgemaster, Spelunker Sharpshooter, Ember Bombardier, Crossbow Rifleman | 30,000 | 16.25M exp, 300M gold |
| 8 | 86 | 57086 | Vault Keepers | Deeprock Berserker, Ironforge Grunt, Vault Guardian, Grudge Keeper | 30,000 | 16.5M exp |
| 9 | 87 | 57087 | Gloomcaster Elite | Gloomcaster President Spouse, Gloomcaster President, Alcohol Bottle | 30,000 | 16.75M exp |

**Total kills: 270,000** | **Room reward: +5% XP, +5% Loot, +4% Forge, +50 levels, 1x Bag of Your Dreams**

---

## Summary

### Kill Requirements Per Room

| Room | Tasks | Total Kills |
|------|-------|-------------|
| Easy | 14 | 19,500 |
| Medium | 27 | 123,500 |
| Hard | 16 | 168,000 |
| Epic | 20 | 385,000 |
| Rampage | 9 | 270,000 |
| **TOTAL** | **86** | **966,000** |

### Cumulative Room Rewards

| Room | XP Bonus | Loot Bonus | Forge Bonus | Levels | Special Items |
|------|----------|------------|-------------|--------|---------------|
| Easy | +1% | - | - | 10 | 1x Bag You Covet |
| Medium | +2% | - | +1% | 20 | 1x Starlight Power |
| Hard | +3% | +3% | +2% | 40 | 1x Bag of Cosmic Wishes |
| Epic | +4% | +5% | +3% | 40 | 1x Bag of Your Dreams |
| Rampage | +5% | +5% | +4% | 50 | 1x Bag of Your Dreams |
| **TOTAL** | **+15%** | **+13%** | **+10%** | **160** | |

### Where Bonuses Are Applied

- **XP Bonus**: Applied in `Player:onGainExperience()` (`data/events/scripts/player.lua`). Multiplies XP by `(1 + bonus/100)` before other boosts.
- **Loot Bonus**: Applied in `Player:calculateLootFactor()` (`data/libs/functions/player.lua`). Multiplies loot factor. Shows as "linked +N%" in loot messages.
- **Forge Bonus**: Applied in `Game::playerForgeFuseItems()` (`src/game/game.cpp`). Adds flat percentage to forge fusion success rate (reads storage 192012).

---

## Configuration Guide

### Adding a New Task

In `linked_task_lib.lua`, add an entry to the `tasks` array of the desired room:

```lua
{
    name = "My New Task",
    races = { "Monster Name 1", "Monster Name 2" },
    killsRequired = 5000, -- optional, overrides room default
    rewards = {
        { type = "experience", amount = 1000000 },
        { type = "item", id = 12345, count = 5 },
    },
},
```

**Important**: Monster names must match exactly (case-sensitive) with the monster type names registered in the server.

### Reward Types

| Type | Config Example | Description |
|------|---------------|-------------|
| `experience` | `{ type = "experience", amount = 500000 }` | Flat XP |
| `level` | `{ type = "level", amount = 50 }` | Gain N levels instantly |
| `gold` | `{ type = "gold", amount = 1000000 }` | Gold added to bank |
| `item` | `{ type = "item", id = 60129, count = 100 }` | Give items |
| `storeitem` | `{ type = "storeitem", id = 8778, count = 50 }` | Items to store inbox (non-movable) |
| `vocgem` | `{ type = "vocgem", count = 1 }` | Skill gem matching player vocation |
| `wheelgreatergem` | `{ type = "wheelgreatergem", count = 1 }` | Greater wheel gem matching vocation |
| `addon` | `{ type = "addon", looktype = 128, addon = 3 }` | Grant outfit addon |
| `mount` | `{ type = "mount", id = 5 }` | Grant mount |
| `bonus_xp` | `{ type = "bonus_xp", amount = 5 }` | +5% permanent XP |
| `bonus_loot` | `{ type = "bonus_loot", amount = 5 }` | +5% permanent loot chance |
| `bonus_forge` | `{ type = "bonus_forge", amount = 2 }` | +2% permanent forge success rate |

---

## Player Commands

| Command | Description |
|---------|-------------|
| `!linkedtask` | Show full progress: room status, active task, permanent bonuses |
| `!ltask` | Alias for `!linkedtask` |

---

## Progress Notifications

- **10% intervals**: Console message showing kills/total and percentage
- **100% complete**: Advance message telling player to return to totem + firework effect
- **Task accepted**: Advance message with task details, room info, and monster list
- **Reward claimed**: Holy damage effect at player position

---

## Technical Notes

### Performance

- Monster lookup table is built once on load (O(1) lookup by monster name)
- Action ID lookup is O(1) via pre-built table
- Kill tracking only checks the active task (no iteration over all tasks)
- Storage reads are cached by the engine per tick

### Interaction with Other Systems

- Does NOT interfere with the daily task system (separate storages, separate events)
- Permanent bonuses stack with all other bonus sources (VIP, prey, gems, etc.)
- Forge bonus is additive to the base + core success rate

### Rebuild Required

The C++ forge bonus change requires a server rebuild (`./recompile.sh`) to take effect. The Lua changes are hot-reloadable.

---

## Map Setup Checklist

1. Create 5 rooms with teleporters (one per tier)
2. Place totems in each room (one per task, in order)
3. Set Action IDs on totems (57001-57087, see tables above)
4. Ensure room access is gated (Room 1 open, others behind previous room's completion)
5. Test with a character by clicking first totem in Easy room
