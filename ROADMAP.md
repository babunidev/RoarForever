# RoarForever — roadmap

**Author:** Babuni.dev

## Current state

The current release candidate is **0.6.3-beta** for World of Warcraft: Forever 1.60.1 / Interface 16001. It adds the live dungeon secret-identity fix and COMM/text `/roar` deduplication on top of the runtime-only packaging from 0.6.2-beta. The public tag is approved but remains gated on the updated regression suite passing on the exact release commit.

## Unverified points

Validate peer emote detection, duplicated text/COMM cases, distance cutoff, UI behavior and SoundKitIDs inside the actual Forever release client.

## Acceptance and provenance ledger — 2026-10-27

- [x] Consolidate 0.6.0-beta behavior and prior release evidence in the design, architecture and narrative history.
- [x] Add audio/content provenance and explicit human–AI attribution documents.
- [ ] Test COMM-first and chat-first duplicates with two Forever clients using full two-part names and local sender state.
- [ ] Verify 50-yard distance behavior, mismatched instance IDs, absent position fallbacks and FileDataID in-range playback.
- [ ] Determine actual SoundKitIDs through client verification before documenting smooth attenuation as implemented.
- [ ] Test group `/train`, faction cries, previews, settings persistence, language templates, Skyborne voice mappings and chat silence toggles.
- [x] Run the repository's simulated Lua tests and preserve exact output; 593 translated template cases, 7 locale variants, menu/settings/preview/train/faction/Skyborne/COMM-distance/identity/detection regressions passed on 2026-11-04. Real audio, networking and UI remain live-client tests.
- [x] Publish the approved annotated `v0.6.1-beta` tag from commit `4064b9ffc43d14e27f6c74a07705139156e999f3`.
- [x] Confirm CurseForge detected `v0.6.1-beta` as a **Beta** for Forever **1.60.1**.
- [ ] Confirm CurseForge changes from **Processing** to **Approved** and verify the downloadable package contents.
- [ ] Run launch-client multiplayer/audio/UI verification and record results separately from automated tests.
- [x] Diagnose the first live dungeon secret-value failure from `UnitName`/`UnitFullName` identity matching.
- [x] Guard unit name/GUID/race/sex identity values and remove arbitrary-unit queries from self/group classification.
- [x] Run `python tests/test_addon.py` with the new secret-identity regression cases; 593 translated template cases, 7 locale variants, and all existing regressions including secret-identity guards passed on 2026-11-05.
- [ ] Reproduce the original dungeon scenario with an identity-restricted target and confirm no Lua error.
- [x] Audit suspected group `/roar` double playback and identify COMM/text correlation mismatch caused by `CHAT_MSG_ADDON` lacking a sender GUID.
- [x] Correlate COMM and text fallback by normalized sender name and make the simulator model the real Forever addon-message payload.
- [ ] Run `python tests/test_addon.py` with the COMM/text sender-correlation regression.
- [x] Approve `0.6.3-beta` for public release after the exact release commit passes the updated automated suite.
- [ ] Create and push annotated tag `v0.6.3-beta` on the tested release commit.
- [ ] Confirm CurseForge publishes `v0.6.3-beta` as Beta / Forever 1.60.1 and verify the runtime-only ZIP contents.
- [ ] Retest `/roar` in a party/instance. If one addon playback still overlaps a native roar, verify the native group behavior separately before changing the established group-roar design.
- [x] Restrict future CurseForge packages to runtime files only.
- [x] Publish annotated tag `v0.6.2-beta` on commit `028af0ce4980ef232bb9af8177e5ca1444c19f40` as the packaging-correction release.
- [ ] Confirm CurseForge processes `v0.6.2-beta` as Beta / Forever 1.60.1 and verify the downloadable archive contains only the four runtime files.

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](docs/EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.
