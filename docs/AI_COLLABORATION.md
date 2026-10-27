# RoarForever — Human–AI Collaboration and Provenance

**Author and creative direction:** Babuni.dev

## Project direction

Babuni.dev wanted voices and emotes to make the shared world feel more alive, restoring missing character sounds without installing custom audio. The user-directed project evolved through support for `/roar`, `/train`, faction battle cries, multiple language templates, interface controls, player-specific voice handling and distance-aware playback among addon users.

## Engineering and iteration

The release record shows a transition from simple detection and client playback to addon-to-addon communications for 0.6.0-beta. The assistant's technical contributions and implementation should be attributed as such where the recorded source and conversations support them. Neither an AI-generated alternative nor a partial implementation becomes an approved creative decision merely because code exists.

The two-part first-name/surname identity model in Forever should be preserved in discussion of per-speaker deduplication and cooldowns. Treat names as the game's player identity model, not as cross-realm identifiers.

## Audit #33 — 27 October 2026

**User direction:** Continue the numbered GitHub documentation consolidation with RoarForever, without changing addon code. **AI contribution:** Review the 0.6.0-beta TOC, runtime, options, localization and release notes; fill missing design/content/collaboration documents and make implementation boundaries explicit. **Historical iteration:** COMM-first/text-first deduplication, group train suppression, unavailable verified SoundKitIDs and fallback sound behavior. **Verification:** Repository source review and documentation commits only; no live group test, client playback or sound-distance trial.
