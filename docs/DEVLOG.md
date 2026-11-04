# RoarForever — development history

**Author:** Babuni.dev

## Retrospective review — 2026-10-26

A sound-restoration and voiced-emote companion for World of Warcraft: Forever, using game-bundled race/sex-specific voice assets. The source implements this direction through RoarForever.lua with Options.lua and Locales.lua provides emote and sound handling, settings/preview UI, options persistence and localizations; test_addon.py and an existing CHANGELOG document ongoing releases. Sound restoration is optional and per-emote; 0.6 beta source/README describes addon-to-addon COMM and distance rules, with SoundKitID coverage explicitly requiring in-game verification.

The README and CHANGELOG preserve more detailed functional and version context. This entry does not invent earlier discussion or imply the present audit tested the addon. The creative direction and authorship remain mine; AI created a source-grounded narrative and structure around the existing work. Peer emote detection, duplicated text/COMM cases, distance cutoff and SoundKitIDs still require validation inside the actual Forever client.

## 2026-10-27 — Audit #33: from a missing roar to audible company

RoarForever began with a characterful inconvenience: a voiced emote should be heard by those around the player, yet the Forever client could leave the moment silent. The direction I wanted was to restore the personality already encoded in the game's own voices without shipping an alternate sound library. From there, the standalone addon grew into a configurable set of emote categories, presentation controls and more complete race/sex voice coverage, with separate localization templates.

For 0.6.0-beta, the idea expanded into a second social layer: when nearby players also run the addon, a small COMM packet can identify the emote and position. A short fallback keeps visible emote chat as a source when that packet never arrives. My AI assistant helped design and implement the communication, deduplication and distance-handling approach while preserving the existing FileDataID fallback. The 50-yard rule establishes the intended audible boundary in source; true volume falloff still needs verified SoundKitIDs in the game.

**Creative direction:** mine. **AI contribution:** technical design, implementation support and documentation where evidenced. **Iteration:** moving from chat-only inference to COMM and distance handling without claiming universal audio coverage. **Verification:** source and changelog inspected; no game-client sound, network, latency or cross-player test was executed in this audit.

## 1 November 2026 — keeping the two Forever addons distinct

Looking across the older ROAR and Buxbrew projects, I wanted this audio-restoration work to retain its own place in the history. **Roar Forever** aims to make voiced emotes audible, while **Flourish Forever** decides when a selected ability may create an emote; the names are similar, but their triggers and responsibilities differ. My AI assistant compared the present sources and added this context to [the full history](EMOTE_FAMILY_HISTORY.md), while preserving the separate origin in Roar Sound Effects. No new playback verification or code changes were made in this documentation pass.

## 4 November 2026 — preparing Roar Forever for the live client

With Forever leaving beta, the release-facing setup needed to match the live game without changing sound data that had not been reverified. The installation path now points to the live `_forever_` client, compatibility wording targets Forever 1.60.1 / Interface 16001, and `/rf debugcomm` reports outgoing addon-message result codes so throttling or communication lockdown can be diagnosed during multiplayer tests.

As part of this pass, my AI assistant compared the current repository against the latest Forever addon/API notes and implemented the diagnostics and documentation changes I accepted. Existing FileDataID mappings, COMM protocol behavior, distance gating and the empty SoundKit mapping layer were deliberately left unchanged; launch-client multiplayer and audio behavior still require in-game verification.

## 4 November 2026 — 0.6.1-beta publication

With the live Forever client about to open, I approved 0.6.1-beta as a deliberately cautious beta rather than waiting for an in-game test that was not yet possible. The automated Lua regression suite passed 593 translated template cases across seven locale variants together with menu, settings, preview, train, faction-cry, Skyborne, COMM-distance, identity and detection regressions.

My AI assistant prepared the release documentation and diagnostics, while the final publication decision and tag approval were mine. The annotated `v0.6.1-beta` tag was pushed on commit `4064b9ffc43d14e27f6c74a07705139156e999f3`. CurseForge detected it as a **Beta** for Forever **1.60.1** and entered **Processing**. That confirms the tag-triggered packaging path reached CurseForge, but it is not yet evidence of an approved public file or successful live-client behavior.

The release notes explicitly preserve `v0.5.7-beta` as the pre-0.6 fallback if launch-day problems appear. Live multiplayer COMM, actual audio behavior, UI behavior and SoundKit-based attenuation remain unverified until the release client can be tested.

