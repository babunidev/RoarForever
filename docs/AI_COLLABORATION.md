# RoarForever — Human–AI Collaboration and Provenance

**Human creative and direction:** Babuni

## Project direction

The creative direction from Babuni is to make voices and emotes give the shared world more life by restoring missing character sounds without installing custom audio. The project evolved through support for `/roar`, `/train`, faction battle cries, multiple language templates, interface controls, player-specific voice handling and distance-aware playback among addon users.

## Engineering and iteration

The release record shows a transition from simple detection and client playback to addon-to-addon communications for 0.6.0-beta. The assistant's technical contributions and implementation should be attributed as such where the recorded source and conversations support them. Neither an AI-generated alternative nor a partial implementation becomes an approved creative decision merely because code exists.

The two-part first-name/surname identity model in Forever should be preserved in discussion of per-speaker deduplication and cooldowns. Treat names as the game's player identity model, not as cross-realm identifiers.

## Audit #33 — 27 October 2026

**User direction:** Continue the numbered GitHub documentation consolidation with RoarForever, without changing addon code. **AI contribution:** Review the 0.6.0-beta TOC, runtime, options, localization and release notes; fill missing design/content/collaboration documents and make implementation boundaries explicit. **Historical iteration:** COMM-first/text-first deduplication, group train suppression, unavailable verified SoundKitIDs and fallback sound behavior. **Verification:** Repository source review and documentation commits only; no live group test, client playback or sound-distance trial.

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.

## 0.6.1-beta release collaboration — 4 November 2026

**Babuni:** approved the live-client release preparation, accepted the beta-risk posture, chose to publish before live in-game testing was possible, and explicitly authorized the `v0.6.1-beta` public tag.

**AI contribution:** reviewed current Forever release information and repository compatibility, implemented outgoing COMM result diagnostics, updated release-facing documentation, extended regression coverage, audited documentation against repository rules, and prepared the release state for tagging.

**Verification boundary:** the automated Lua suite passed. The annotated tag was pushed on the approved commit and CurseForge detected it as a Beta for Forever 1.60.1, but live-client gameplay/audio testing remained unavailable and CurseForge approval was not yet confirmed at the time of this record.

## 0.6.2-beta packaging release — 4 November 2026

**Babuni:** identified that player installs should not carry repository/portfolio documentation, approved the runtime-only packaging policy, approved version `0.6.2-beta`, and created/pushed the annotated public tag from the local repository.

**AI contribution:** audited the existing `.pkgmeta`, identified that only `tests/` was excluded, changed package exclusions so only the four runtime files remain in the install archive, updated release documentation, and compared the three Lua runtime files against `v0.6.1-beta` to confirm they were unchanged.

**Verification boundary:** GitHub confirms `v0.6.2-beta` points to commit `028af0ce4980ef232bb9af8177e5ca1444c19f40`. Runtime Lua equality was verified from repository blobs. CurseForge processing/public availability and the actual generated ZIP contents require separate confirmation; no new live-client gameplay test was performed for this packaging-only release.

