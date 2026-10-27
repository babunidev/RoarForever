# RoarForever — decisions and alternatives

**Author:** Babuni.dev

## Source-supported design choice

Sound restoration is optional and per-emote; 0.6 beta source/README describes addon-to-addon COMM and distance rules, with SoundKitID coverage explicitly requiring in-game verification.

Treat this as observable implementation design, not a recovered original approval. Revisit the existing CHANGELOG for real dated version changes.

## Unverified

Validate peer emote detection, duplicated text/COMM cases, distance cutoff and SoundKitIDs inside the actual Forever client.

## Recovered changes and boundaries

- **Voice restoration:** Built-in WoW audio is reused rather than bundling sounds. Options do not mute Blizzard's native sounds.
- **Configuration and inclusion:** A movable `/rf` menu exposes 22 selectable emote categories and previews; Skyborne and five-language support are documented in the release record.
- **0.6.0-beta communication:** COMM between addon users supplements text detection for non-users. The 0.10-second fallback reduces double playback when either event path arrives first.
- **Spatial behavior:** Audio is silent at 50 yards and beyond in a matching instance, and across mismatched instance IDs. In range, FileDataIDs can still play even with no verified SoundKitID mapping. Distinct smooth attenuation remains future verification.
- **Social compatibility:** Group `/train` COMM is deliberately suppressed to avoid duplicating native sound; faction calls use addon propagation when native group playback is absent.

These are grounded in implementation/release notes, not a reconstruction of unrecorded user approval. No new gameplay design decision is made by this documentation audit.
