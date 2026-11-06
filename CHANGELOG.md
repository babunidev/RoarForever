# Roar Forever — Changelog

Release notes for the standalone player voice-emote sound addon.

## 0.6.6-beta — development

- Disable RoarForever runtime behavior entirely inside battleground instances (`IsInInstance()` type `"pvp"`). Chat restoration, previews, `/rf test`, raw ID playback, `/train`, faction-cry slashes, announcements, and DoEmote-hook reactions are suppressed there; entering a battleground also stops any restored sound already playing.
- Preserve the user's saved enabled/disabled setting while suppressed so normal behavior resumes automatically after leaving the battleground.
- Added regression coverage for the battleground hard-disable and automatic restoration after returning to a non-PvP instance context. Live battleground testing now confirms the addon produces no errors there; updated automated execution remains pending.
- Fixed a live battleground `ADDON_ACTION_BLOCKED` error from `/fta`/`/fth`: addon faction-cry slash commands no longer call `DoEmote`, which Forever can route into protected `PerformEmote()`. They now own only the restored voice and custom announcement; direct player/macro `DoEmote` calls remain observation-only through the hook.
- Added regression coverage that faction slash commands never invoke `DoEmote`, including when that function would fail or be protected.
- Live battleground retesting after the hard-disable reports no errors. Updated automated regression execution remains pending.

## 0.6.5-beta — 2026-11-06

> **Publication:** annotated tag `v0.6.5-beta` points to commit `aa2c73445838460f58af53d0f07239e213d0d828`. The later battleground protected-action fix is not part of this immutable tag.

- Removed COMM transmission, reception, distance checks, and delayed text fallbacks. Received chat emotes became the sole remote trigger, eliminating late-packet double playback, split COMM/text speaker identities, and identical-payload echo collisions.
- Preserved native self/group exclusions, restored group roar, Skyborne exceptions, faction cries, previews, localization, and settings. Silent custom announcements no longer provide remote restoration.
- Replaced accumulating event/cooldown/handle maps with one bounded 128-speaker store, pruned every five seconds after 60 seconds idle. Eviction stops the stored handle.
- Guarded faction slash/hook reentrancy explicitly and allowed congratulations involving names containing “ding.”
- Removed obsolete COMM/position/SoundKit diagnostics; retained `/rf debugplay`.
- Babuni directed the reliability-first simplification. AI implemented the changes and regression coverage. Mocked Lua 5.1 tests passed before publication; Babuni reported the simplified version seemed to be working well after testing, while individual checklist scenarios remained separately tracked.

## 0.6.4-beta — 2026-11-05

> **Publication:** annotated tag `v0.6.4-beta` was pushed on tested commit `8c98e630f09bbe68cf6abeaebd7f2118a44f6274`. The full local regression suite passed before tagging, including self-echo suppression. CurseForge publication is not yet confirmed.
- Reverted the proposed group-roar suppression after a direct live check with RoarForever disabled confirmed that Forever itself does **not** play the missing group `/roar` sound. Group roar restoration remains core addon behavior.
- Stabilized the playback duplicate key so COMM events (sender name only) and text-emote events (sender name + GUID) identify the same logical speaker.
- Fixed a group-only delayed duplicate path: later SAY/PARTY/RAID/INSTANCE copies of the same COMM event now refresh COMM/text fallback suppression before event-ID dedupe discards their audio playback. This prevents a late text-emote event from replaying a roar after the original 0.35-second COMM window expires.
- Fixed a second group-only path affecting the local player: PARTY/RAID/INSTANCE addon channels can echo this client's own outbound COMM packet back through `CHAT_MSG_ADDON`. RoarForever now remembers exact recently-sent payloads and discards those local echoes before identity matching or playback, so `/roar` and faction cries cannot be replayed as if they came from another player when sender-name formatting differs.
- The local-echo cache is short-lived and pruned on send; it does not change other players' COMM handling or intentional repeat timing.
- Added a regression reproducing SAY → delayed PARTY duplicate → later text-emote delivery for one event ID; the updated suite passed on 2026-11-05.
- Added `/rf debugplay`, which reports every actual RoarForever FileDataID playback with its source path (`COMM`, `TEXT`, or `SELF_TEXT`) for live duplicate diagnosis.
- Restored grouped-roar regression expectations and added coverage that name-only COMM and name+GUID text events share the same playback cooldown identity.
- `python tests/test_addon.py` passed on 2026-11-05 with 593 translated template cases, 7 locale variants, and the full regression suite including group roar restoration, COMM/text sender correlation, delayed group-channel dedupe, logical-sender playback dedupe, and secret-identity guards. A live grouped-roar retest remains pending.

## 0.6.3-beta — 2026-11-05

> **Publication:** annotated tag `v0.6.3-beta` was published on commit `6efb00416469e0a99a4122099d39da744d7a6470`. This release contains the secret-identity and COMM/text correlation fixes; it does not contain the later native group-roar suppression change.

- Fixed a second `/roar` playback path when COMM and `CHAT_MSG_TEXT_EMOTE` represented the same emote with different identity shapes: Forever's `CHAT_MSG_ADDON` provides a sender name but no sender GUID, while text-emote events provide a GUID. Short-lived COMM/text correlation now keys by normalized sender name so both arrival orders deduplicate correctly.
- Corrected the test harness to model Forever's real `CHAT_MSG_ADDON` payload without an invented sender GUID. The updated regression suite must pass on the release commit before the public tag is pushed.
- Fixed a live Forever dungeon error where identity-restricted `target`/focus/mouseover unit names could be returned as secret strings and then compared by RoarForever.
- Added secret-value guards for unit names, GUIDs, race and sex before comparisons, string operations or speaker-key use.
- Self detection now queries only the `player` unit, and group detection scans only party/raid units before any arbitrary-unit voice fallback. Secret arbitrary identities are skipped rather than inspected.
- Added simulated regression coverage for secret-identity guards. `python tests/test_addon.py` passed on 2026-11-05 with 593 translated template cases, 7 locale variants, and the full regression suite including secret-identity guards. The simulator cannot create Blizzard-tagged secret Lua values, so the fix still requires a live restricted-map retest.

## 0.6.2-beta — 2026-11-04

> **Packaging-only beta:** no addon runtime behavior changed from 0.6.1-beta. This release replaces the oversized install archive with a runtime-only package.

> **Publication status:** Babuni approved the public beta and annotated tag `v0.6.2-beta` was pushed on commit `028af0ce4980ef232bb9af8177e5ca1444c19f40`. CurseForge publication and final archive contents are not recorded as confirmed until the new file is publicly visible and inspected.

- Slimmed CurseForge packages to the four files WoW needs at runtime: `RoarForever.toc`, `Locales.lua`, `RoarForever.lua`, and `Options.lua`.
- Excluded project instructions, README/roadmap/concept files, changelog file, `docs/`, and `tests/` from the install archive. CurseForge still reads `CHANGELOG.md` as the manual release changelog.
- Live Forever release-client gameplay/audio verification remains pending; this packaging correction does not change the verification status of the 0.6.x runtime.

## 0.6.1-beta — 2026-11-04

> **Beta status:** Automated Lua regression tests pass, but this build has not yet been tested in the live Forever release client because the game was not available for that test before publication. If 0.6.1-beta causes launch-day problems, use `v0.5.7-beta` from the CurseForge Files page while the live-client issue is investigated.

> **Publication status:** Babuni explicitly approved the public beta. Annotated tag `v0.6.1-beta` was pushed on commit `4064b9ffc43d14e27f6c74a07705139156e999f3`. CurseForge detected it as a **Beta** for Forever **1.60.1** and entered **Processing**. This records publication state only; it does not count as live-client verification or final CurseForge approval.

- Updated installation and compatibility guidance for the live World of Warcraft: Forever 1.60.1 client (`_forever_`, Interface 16001) instead of the former beta folder.
- `/rf debugcomm` now reports outgoing `SendAddonMessage` result codes as well as received packets, making throttling, invalid channels, communication lockdown, and other send failures visible during launch testing.
- Documented Forever's restriction on outgoing addon messages for trial/veteran accounts and kept the existing text-emote fallback where the client supplies one.
- Kept all verified FileDataID mappings, COMM protocol behavior, 50-yard distance gating, and empty SoundKit table unchanged; no unverified launch sound mappings were added.

## 0.6.0-beta — 2026-10-22

- Added addon-to-addon communication for `/roar`, `/train`, `/forthehorde`, and `/forthealliance` so two Roar Forever users can share restored emotes without relying on visible chat alone.
- Emote packets include the sender’s outdoor position when available. Receivers apply distance-aware restored emote audio: same-world distance ≥50 yards is silent (even before SoundKit mappings exist); within range an empty SoundKit table still falls back to FileDataID; missing position uses normal full-volume fallback; a different instance ID stays silent.
- Text-emote detection remains for players without the addon. A short 0.10s fallback waits for a matching COMM packet so the two paths do not double-play either order.
- Group `/train` still leaves native party/raid train audio to the game (no COMM double). Faction cries may use COMM in groups because Forever has no native playback.
- Debug helpers: `/rf debugcomm`, `/rf debugpos`, `/rf soundkit <ID> [volume]`, `/rf voltest <ID>` (candidate SoundKit testers, not a mapping discovery tool). Verified SoundKitIDs can be dropped into `voiceSoundKits` later for true attenuation.
- Per-speaker voice restart: the same player spamming or switching restored emotes stops only their own previous line and starts the new one. Different players’ restored voices play in parallel. Options preview still stops the previous preview sample when you click another.

## 0.5.7-beta — 2026-10-12

- Clarified the options note: Roar Forever restores built-in World of Warcraft voice-emote sounds; it does not add or bundle audio.
- Restored voices no longer overlap: starting a new restored voice stops the previous one.
- Lowered the restored-emote duplicate cooldown from 0.30s to 0.07s so rapid repeats can restart sooner.

## 0.5.6-beta — 2026-10-12

- Fixed "Interface action failed because of an AddOn" on `/train` and faction cries. Restored the working `C_ChatInfo.SendChatMessage` path and send the custom `/e` line immediately on the slash/keybind call stack instead of after `C_Timer.After`, which Forever treats as an automated chat action.
- Kept the 0.5.5 faction-cry fix: `/forthehorde` and `/forthealliance` still announce from the slash command even when `DoEmote` is a no-op.

## 0.5.5-beta — 2026-10-12

- Fixed faction-cry chat announcements so `/forthehorde` and `/forthealliance` send their distinctive `/e` line from the slash command even when `DoEmote` does nothing. A follow-up 0.5.6 fix restored the safe chat API path after `/train` broke.

## 0.5.4-beta — 2026-10-12

- Restores the missing `/forthehorde` and `/forthealliance` faction cries using the original race/sex-specific voice assets contained in the World of Warcraft Forever client.
- Added `/forthealliance` (alias `/fta`) for Alliance characters, with the same announcement, multiplayer, group/raid, options, and `/rf test` support as `/forthehorde` / `/fth`.
- Verified Alliance voices for Human, Dwarf, Gnome, and Night Elf (male and female). No Skyborne faction-cry line was found for either faction.
- Shared faction-emote handling for both cries. Forever still has no native emote tokens, so the cheer animation may be missing until Blizzard wires them; the addon keeps calling `DoEmote("FORTHEHORDE")` and `DoEmote("FORTHEALLIANCE")` for forward compatibility.

## 0.5.3-beta — 2026-10-12

- Added `/forthehorde` (alias `/fth`) for Horde characters. Forever still has the race/sex “For the Horde!” voice files, but does not wire the emote, so Roar Forever plays them and sends a distinctive chat line other Roar Forever users can hear.
- Verified Orc, Tauren, Troll, and Undead male/female FileDataIDs in the Forever client. No Skyborne for-horde line was found yet.
- Forever’s EmotesText has no `FORTHEHORDE` token yet, so the native cheer animation may not play until Blizzard wires it. The addon keeps calling `DoEmote("FORTHEHORDE")` so a future client build can pick it up automatically.

## 0.5.2-beta — 2026-10-11

- Skyborne already have a client `/roar`. Roar Forever no longer double-plays roar for yourself or for Skyborne group members. Other races still get the addon roar there. Nearby non-grouped Skyborne roars are still restored.

## 0.5.1-beta — 2026-10-07

- Stopped group-member `/train` from playing twice. Like the other non-roar voices, train is left to the game in a party or raid.

## 0.5.0-beta — 2026-10-07

- Added a movable Warcraft-style options window, opened with `/rf` or `/rf config`.
- Added individual switches for all 20 supported emote categories. Aliases share one switch.
- Added speaker buttons that preview a random mapped sound across all races and genders, including the full joke and flirt pools. Previews work with automatic playback disabled and never send chat messages.
- Added a separate switch for the `/train` chat announcement. Turning it off leaves the native train emote available.
- Bundled English, German, French, Spanish, and Russian emote detection and menu labels; English GB and Spanish MX use their corresponding language packs.
- Replaced broad keyword detection with full client-message templates from Forever build 1.60.1.70009. Custom emote chat is accepted only for the exact train announcement.
- Fixed player identity checks so a different GUID cannot be mistaken for the local player or a group member just because names match.
- Kept the existing congratulations `ding` exclusion unchanged.
- Settings use the existing account-wide `RoarForeverDB`; prior on/off settings are preserved and new switches default to on.

Validation: Lua 5.1 checks cover 593 localized template cases and options, previews, train announcements, saved-option loading, and identity regressions. Actual translated-client behavior and UI appearance still require in-game validation.

## 0.4.7 — 2026-09-30

- Fixed a Lua error that could fire when a party or raid member used a voiced emote such as `/oom`.

## 0.4.6 — 2026-09-26

- `/train` now sends "blows a train whistle. Choo choo!" so other people using Roar Forever can hear it, including in a party or raid.
- Restored the `/whistle` sound for nearby players.

## 0.4.5 — 2026-09-26

- Restored nearby-player voices for `/cry`, `/congrats` / `/congratulate`, and `/followme`.

## 0.4.4 — 2026-09-26

- Restored nearby-player voices for `/oom`, `/sigh`, and `/charge`.

## 0.4.3 — 2026-09-26

- Restored nearby-player voices for `/healme`, `/rasp`, and `/flirt`.
- In a party or raid, only `/roar` is restored. The other voices are left to the game.
- `/rf off` turns Roar Forever off. `/rf on` turns it back on.

## 0.4.2 — 2026-09-25

- Restored nearby-player voices for `/flee` and `/retreat`. Both use the flee voice.
- Restored nearby-player voices for `/welcome`.
- Restored nearby-player voices for `/yes` and `/no`.

## 0.4.1 — 2026-09-25

- Added Skyborne voices for roar, cheer, laugh, and joke.
- `/joke` and `/silly` now pick a random line from that character's full set of joke lines.
- `/moo` stays Tauren-only.

## 0.4.0 — 2026-09-25

- Expanded Roar Forever beyond `/roar` to other missing player voice emotes.
- Added nearby-player voices for `/cheer`, `/laugh` / `/lol`, `/joke` / `/silly`, and Tauren `/moo`.
- Your own normal voiced emotes are left to the client. `/roar` still plays for you as well.
- `/rf test` can try roar, cheer, laugh, joke, and moo. `/rf status` lists the voices mapped for your character.
- `/train` is not restored. Forever does not announce another player's train emote.

## 0.3.0 — 2026-09-20

- Published Roar Forever as a standalone sound-only addon.
- Retained racial voice playback for detected `/roar` emotes and the short duplicate-playback cooldown.
- Included sound testing and status commands: `/rf test`, `/rf status`, and `/rf id <FileDataID>`.
- Reduced the install package to two runtime files: `RoarForever.toc` and `RoarForever.lua`.
- Removed ability-triggered emotes, their configuration window, saved profiles, and recovery setup from the public addon.
- Requires no saved settings, directory links, or account-specific configuration.

Earlier combined-addon development is outside the scope of this standalone changelog and remains available in repository history.

## Documentation-only audit #33 — 2026-10-27

- Added separate interaction-design, audio/content provenance and AI-collaboration documents; expanded project concept, architecture, decisions, roadmap and historical journal.
- Distinguished 0.6.0-beta distance-based silence and fallback sound playback from future SoundKitID volume attenuation.
- Preserved addon Lua, TOC, tests and audio references; no live-client test or sound mapping verification performed.

## 2026-11-01 — expressive-addon family history

- Documented Roar Forever as a client-voice restoration branch, separate from the trigger-based Flourish Forever addon.
- Linked [the verified family timeline](docs/EMOTE_FAMILY_HISTORY.md); no runtime changes or in-game tests.
