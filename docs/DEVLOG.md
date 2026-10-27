# RoarForever — development history

**Author:** Babuni.dev

## Retrospective review — 2026-10-26

A sound-restoration and voiced-emote companion for World of Warcraft: Forever, using game-bundled race/sex-specific voice assets. The source implements this direction through RoarForever.lua with Options.lua and Locales.lua provides emote and sound handling, settings/preview UI, options persistence and localizations; test_addon.py and an existing CHANGELOG document ongoing releases. Sound restoration is optional and per-emote; 0.6 beta source/README describes addon-to-addon COMM and distance rules, with SoundKitID coverage explicitly requiring in-game verification.

The README and CHANGELOG preserve more detailed functional and version context. This entry does not invent earlier discussion, or imply the present audit tested the addon. Babuni.dev remains the author; AI created a source-grounded narrative and structure around the existing work. Validate peer emote detection, duplicated text/COMM cases, distance cutoff and SoundKitIDs inside the actual Forever client.

## 2026-10-27 — Audit #33: from a missing roar to audible company

RoarForever began with a characterful inconvenience: a voiced emote should be heard by those around the player, yet the Forever client could leave the moment silent. Babuni.dev's creative direction was to restore the personality already encoded in the game's own voices without shipping an alternate sound library. The standalone addon then grew into a configurable set of emote categories, presentation controls and more complete race/sex voice coverage, with separate localization templates.

The 0.6.0-beta record introduced a second social layer: when nearby players also run the addon, a small COMM packet can identify the emote and position. A short fallback keeps visible emote chat as a source when that packet never arrives. Keeping those paths from double-playing, suppressing group trains already handled natively, and choosing how to behave without position data were distinct engineering problems. The 50-yard rule currently proves a desired boundary in source; true volume falloff still needs verified SoundKitIDs in the game.

**Babuni.dev direction:** more expressive encounters using existing game audio. **AI contribution:** technical design and documentation where evidenced, plus this narrative consolidation. **Iteration:** moving from chat-only inference to COMM and distance handling without claiming universal audio coverage. **Verification:** Source and changelog inspected; no game-client sound, network, latency, or cross-player test executed in this audit.
