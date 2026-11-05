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

## Secret-identity dungeon fix — 5 November 2026

**Babuni:** supplied the first live dungeon error and approved fixing the underlying Forever compatibility problem rather than applying a narrow line-level workaround.

**AI contribution:** traced the stack to name-based sender matching, checked current Forever secret-value behavior for unit names/GUIDs/race/sex, implemented guarded identity helpers, narrowed self/group classification to accessible unit tokens, added simulated regression coverage, and updated repository documentation.

**Verification boundary:** the reported error itself is live-client evidence. The fix is implemented in development main, and `python tests/test_addon.py` passed on 5 November 2026 with the new secret-identity guard coverage. A live dungeon retest remains pending because the simulator cannot reproduce Blizzard-tagged secret values; no public follow-up version has been authorized or tagged.

## Group roar deduplication investigation — 5 November 2026

**Babuni:** reported that `/roar` sounded doubled while grouped and asked for the cause to be checked rather than assuming the existing dedupe was sufficient.

**AI contribution:** audited the COMM, text fallback and native-group suppression paths; verified the documented event payload difference between `CHAT_MSG_ADDON` and `CHAT_MSG_TEXT_EMOTE`; identified the name-versus-GUID correlation mismatch; implemented name-based short-window correlation; corrected the simulator to remove the invented addon-message GUID; and updated repository documentation.

**Verification boundary:** the source-level duplicate path is confirmed and fixed in development main. The updated automated regression suite and a live grouped-roar retest remain pending. Native group-roar overlap remains a separate unverified possibility and was not silently changed.

## 0.6.3-beta release preparation — 5 November 2026

**Babuni:** approved publishing the secret-identity and roar-deduplication fixes together as `0.6.3-beta` and authorized the public release once the exact release commit passes the updated automated suite.

**AI contribution:** prepared version metadata and release notes, preserved the runtime-only packaging policy, documented the release gate and verification boundaries, and audited the release scope against `v0.6.2-beta`.

**Verification boundary:** the secret-identity regression suite passed before release preparation. The final updated suite including COMM/text sender correlation still has to pass on the exact release commit before the tag is pushed. Live dungeon/group behavior remains separate beta verification.

## Native group-roar overlap fix — 5 November 2026

**Babuni:** reported that grouped `/roar` still sounded doubled after the COMM/text correlation fix and asked for the behavior to be checked again before release.

**AI contribution:** re-audited all grouped roar playback paths, separated addon deduplication from native-client overlap, checked current community evidence for native grouped voiced emotes, removed the legacy group-roar restoration exception, updated regression expectations, and corrected the release history after discovering that `v0.6.3-beta` had already been published.

**Verification boundary:** the remaining source-level native/addon overlap is removed in 0.6.4-beta development. The updated automated suite and a live party/instance retest remain pending. Published tag `v0.6.3-beta` points to commit `6efb00416469e0a99a4122099d39da744d7a6470` and does not contain this later group-roar suppression change.

