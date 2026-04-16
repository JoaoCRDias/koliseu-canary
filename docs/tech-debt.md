# Technical Debt

Running list of items we deliberately deferred. Each entry: **what**, **why deferred**, **risks if left**, **sketch of a better approach**.

---

## Chat statements log (`player_statements` table from koliseuot)

**What:** koliseuot persists every player chat message (say/whisper/yell/private/channel) into a `player_statements` table with `(player_id, receiver, channel_id, text, date)`. The write is synchronous on the dispatcher (`db.executeQuery`) in `Game::playerSay`, gated by `LOG_PLAYERS_STATEMENTS` config.

Purpose: audit log for moderation (proving insults, scams, spam) and forensics; the `LAST_INSERT_ID` is threaded back to report-player flows so a report can cite the exact message.

**Why deferred:** the straight port is expensive. At 200 online players talking 1 msg/s it becomes 200 synchronous DB inserts per second on the single-threaded dispatcher. Acceptable for small servers, but the koliseu-canary target (15.23 protocol, larger population) needs a better shape.

**Risks if left missing:**
- No evidence trail for bans / reports. Mods rely on player screenshots or webhooks, which miss context.
- No way to retroactively investigate scams or harassment after the fact.

**Sketch of a more robust approach** (pick one, don't do all):
1. **Async + batch**: `g_databaseTasks().execute()` with a buffered batch insert every N ms or M messages — amortizes the disk cost; worst case loses the last batch on crash.
2. **Separate store entirely**: ship chat to a Redis stream or a dedicated log daemon; DB only stores metadata, full text lives outside. Lets us keep retention short without touching the game DB.
3. **Sampling + report-on-demand**: only persist messages in the last N minutes in a ring buffer in memory; when a player gets reported, dump the relevant slice to DB. Cheap common case, full evidence only when needed.
4. **Webhook integration** (what canary already does elsewhere): pipe messages through a Discord/HTTP webhook for moderation channels; keep DB out of the hot path.

**Decision for now:** removed `player_statements` from the koliseuot→canary migration. The C++ call site doesn't exist in canary (no `savePlayerStatement`, no wiring in `playerSay`). Revisit when moderation tooling becomes a priority.

**Related files (koliseuot source, for reference when we revisit):**
- [koliseuot src/io/functions/iologindata_save_player.cpp:847](../../koliseuot/src/io/functions/iologindata_save_player.cpp) — `savePlayerStatement`
- [koliseuot src/game/game.cpp:7102](../../koliseuot/src/game/game.cpp) — call site in `playerSay`
- Config key: `LOG_PLAYERS_STATEMENTS`
