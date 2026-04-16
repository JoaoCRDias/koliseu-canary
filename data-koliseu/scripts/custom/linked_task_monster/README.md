# Raids Monster - Dynamic Looktype Changer

This monster automatically changes its appearance by cycling through a configured list of looktypes.

## Files

- `raids_monster.lua` - Monster definition
- `raids_looktype_changer.lua` - Script that handles the looktype changing
- `README.md` - This file

## How to Configure Looktypes

Open [raids_looktype_changer.lua](raids_looktype_changer.lua) and edit the `config` table:

### Change Interval

```lua
changeInterval = 5000, -- Time in milliseconds (5000 = 5 seconds)
```

### Add/Remove Looktypes

Edit the `looktypes` table to add or remove looktype IDs:

```lua
looktypes = {
    132, -- Male citizen
    136, -- Female citizen
    148, -- Dwarf
    160, -- Male mage
    3,   -- Dragon
    39,  -- Demon
    75,  -- Frost dragon
    78,  -- Ghastly dragon
    4,   -- Dragon lord
    202, -- Juggernaut
    258, -- Hellhound
    342, -- Grim reaper
    -- Add more looktype IDs here
},
```

### Use Item Appearances (lookTypeEx)

If you want to use item IDs instead of creature looktypes:

```lua
useLookTypeEx = true,

looktypes = {
    1551, -- Some item ID
    2195, -- Another item ID
    -- etc...
},
```

## How It Works

1. When the monster spawns, it starts with the default looktype (132)
2. Every `changeInterval` milliseconds, the onThink event triggers
3. The script cycles to the next looktype in the configured list
4. When it reaches the end of the list, it loops back to the first looktype
5. A teleport effect is shown each time the looktype changes

## Spawning the Monster

Add to your spawn XML file (e.g., `world-monster.xml`):

```xml
<monster centerx="X" centery="Y" centerz="Z" radius="1">
    <monster name="Raids" x="0" y="0" z="0" spawntime="30" />
</monster>
```

Replace X, Y, Z with your desired coordinates.
