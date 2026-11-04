# RoarForever — roadmap

**Author:** Babuni.dev

## Current state

The current development line is **0.6.1-beta** for World of Warcraft: Forever 1.60.1 / Interface 16001. Automated Lua regression tests pass. The annotated `v0.6.1-beta` tag has been pushed and CurseForge detected it as a Beta for Forever 1.60.1; live-client gameplay/audio verification is still pending.

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

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](docs/EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.
