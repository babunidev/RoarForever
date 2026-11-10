# RoarForever — roadmap

**Author:** Babuni.dev

## Current state

Published tag **v0.6.6-beta** points to `01d0059485dc62e81e8600de740631e65edd7188` and disables RoarForever inside battlegrounds. **0.6.7-beta** restores Skyborne `/roar` for your own character, party and raid members, and nearby players. The install package remains the four runtime files only. A live Sky Elf listen is still pending.

## Live acceptance checklist

- [ ] Solo, party and raid: self roar and another member's roar play once, including Skyborne.
- [ ] Train remains native for self/group; nearby outsiders restore its announcement once.
- [ ] Faction cries play once from slash and direct DoEmote macro, including own echoed chat; group listeners hear one voice.
- [x] Battleground: live testing after the hard-disable produced no addon errors or protected-action reports.
- [x] Leave the battleground and confirm the previous saved enabled state resumes automatically.
- [x] Rerun Lua 5.1 simulations and confirm `battleground hard-disable` in the PASS line. Confirmed on 2026-11-11.
- [x] Approve `0.6.6-beta` for public release after the exact release commit passes the updated automated suite.
- [x] Create and push annotated tag `v0.6.6-beta` on commit `01d0059485dc62e81e8600de740631e65edd7188`.
- [ ] Confirm CurseForge publishes `v0.6.6-beta` as Beta / Forever 1.60.1 and verify runtime-only package contents.
- [x] Restore Skyborne `/roar` for self, group, and nearby players in 0.6.7-beta.
- [x] Publish annotated tag `v0.6.7-beta` with a GitHub release asset that contains only the four runtime files.
- [ ] Confirm CurseForge publishes `v0.6.7-beta` as Beta / Forever 1.60.1 and verify the downloadable archive contains only those four files.
- [ ] Repeat an emote: it replaces that speaker's voice; two different speakers can overlap.
- [ ] Move beyond chat delivery range; remote restoration stops. Check indoors and restricted maps.
- [ ] Disable announcements: custom local voices remain, remote restoration has no announcement trigger.
- [ ] Test peers running the previous addon version, options, previews, and reloading saved settings.
- [x] Lua 5.1 simulations: 593 translated templates, seven locales, group/native rules, old-packet timing immunity, speaker state cap/idle expiry, UI and identity guards.

## Historical acceptance ledger

The entries below record earlier COMM/distance development and are superseded where they conflict with the current chat-only behavior.

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
- [x] Run `python tests/test_addon.py` on 0.6.4 development with COMM/text sender correlation, logical-sender playback dedupe, secret-identity guards, and restored group-roar regressions; all 593 translated template cases, 7 locale variants, and the full regression suite passed on 2026-11-05.
- [x] Approve `0.6.3-beta` for public release.
- [x] Publish annotated tag `v0.6.3-beta` on commit `6efb00416469e0a99a4122099d39da744d7a6470`.
- [ ] Confirm CurseForge publishes `v0.6.3-beta` as Beta / Forever 1.60.1 and verify the runtime-only ZIP contents.
- [x] Test the native-group-roar hypothesis with RoarForever disabled; Forever produced no group `/roar` sound, rejecting that hypothesis.
- [x] Restore addon group `/roar` playback and keep it as core RoarForever behavior.
- [x] Stabilize the playback duplicate identity across name-only COMM and name+GUID text events.
- [x] Add `/rf debugplay` to trace each actual addon sound call and source path.
- [x] Identify the group-only timing flaw where duplicate COMM channel copies were discarded before refreshing COMM/text fallback suppression.
- [x] Refresh/cancel COMM/text fallback state before event-ID dedupe so delayed PARTY/RAID/INSTANCE copies extend suppression without replaying audio.
- [x] Add a regression for SAY → delayed PARTY duplicate → late text-emote delivery of the same roar.
- [x] Identify the common `/roar` + `/fta` group-only path: this client's own PARTY/RAID COMM packet can echo back and be mistaken for another player when sender-name formatting differs.
- [x] Suppress exact recently-sent local COMM payloads before identity matching, fallback correlation, or playback.
- [x] Bound and expire the local COMM echo cache.
- [x] Add regressions that feed outbound grouped `/roar` and `/fta` packets back through `CHAT_MSG_ADDON` with deliberately mismatched sender display text.
- [x] Rerun `python tests/test_addon.py` with local group COMM self-echo suppression coverage; full suite passed before tagging on 2026-11-05.
- [x] Rerun `python tests/test_addon.py` with the delayed group-channel dedupe regression; all 593 translated template cases, 7 locale variants, and the full suite including delayed group-channel dedupe passed on 2026-11-05.
- [x] Run `python tests/test_addon.py` on the corrected 0.6.4 development state; PASS confirmed on 2026-11-05.
- [x] Live grouped `/roar` and faction-cry retest confirmed the self-echo fix stopped the duplicate playback.
- [x] Publish annotated tag `v0.6.4-beta` on tested commit `8c98e630f09bbe68cf6abeaebd7f2118a44f6274`.
- [ ] Confirm CurseForge publishes `v0.6.4-beta` as Beta / Forever 1.60.1 and verify the runtime-only ZIP contents.
- [x] Restrict future CurseForge packages to runtime files only.
- [x] Publish annotated tag `v0.6.2-beta` on commit `028af0ce4980ef232bb9af8177e5ca1444c19f40` as the packaging-correction release.
- [ ] Confirm CurseForge processes `v0.6.2-beta` as Beta / Forever 1.60.1 and verify the downloadable archive contains only the four runtime files.

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](docs/EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.
