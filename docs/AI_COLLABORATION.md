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

## Group-roar second-pass investigation — 5 November 2026

**Babuni:** directly falsified the native-group-roar hypothesis by disabling RoarForever and confirming that Forever produced no group roar sound. Group roar restoration was reaffirmed as core addon behavior.

**AI contribution:** reverted the mistaken group suppression, traced the failing automated assertion to the expected group-restoration behavior, unified the playback cooldown identity with COMM/text correlation, added `/rf debugplay` for source-labelled sound-call tracing, restored the corresponding regression expectations, and corrected the repository history.

**Verification boundary:** the native-overlap explanation is rejected by live evidence. The corrected 0.6.4 automated suite passed on 5 November 2026, including group roar restoration, COMM/text sender correlation, logical-sender playback dedupe and secret-identity guards. A live `/rf debugplay` trace remains required before the remaining audible double can be attributed to a specific addon path or audio behavior.

## Delayed group-channel duplicate fix — 5 November 2026

**Babuni:** clarified that the audible duplicate appeared group-specific and directed the investigation toward whether grouped roar restoration itself was being processed twice rather than changing intended behavior.

**AI contribution:** audited the group-only transport difference, identified that one logical roar is broadcast on multiple addon channels while grouped, traced the early event-ID dedupe return that failed to refresh COMM/text suppression, moved fallback correlation ahead of event-ID dedupe, and added a delayed SAY/PARTY/text regression reproducing the timing window.

**Verification boundary:** the source-level timing flaw is fixed in 0.6.4 development. The updated automated suite passed on 5 November 2026, including delayed group-channel dedupe. A live group retest remains required before the audible duplicate is considered resolved in-game.

## Local group COMM self-echo fix — 5 November 2026

**Babuni:** clarified that the double affected both self `/roar` and self `/fta` only while grouped and asked for the duplicate to be stopped without changing intended roar behavior.

**AI contribution:** compared the two local playback paths, isolated grouped COMM as their common second path, identified sender-name mismatch as a way an echoed local packet could bypass self suppression, implemented exact recent-outbound-payload rejection with bounded expiry, and added grouped roar/faction-cry self-echo regressions using mismatched sender display text.

**Verification boundary:** implementation and regression coverage are present in 0.6.4 development. The updated automated suite and live grouped playback still need verification.

## 0.6.4-beta publication — 5 November 2026

**Babuni:** live-tested the grouped self-echo correction, confirmed the duplicate playback was resolved, ran the final regression suite, and explicitly approved and pushed the `v0.6.4-beta` public tag.

**AI contribution:** traced the local group COMM self-echo path, implemented exact recent-payload suppression and bounded expiry, added regression coverage for self `/roar` and faction cries, maintained release documentation, and verified the published GitHub tag points to the tested commit.

**Verification boundary:** GitHub confirms annotated tag `v0.6.4-beta` targets commit `8c98e630f09bbe68cf6abeaebd7f2118a44f6274`. CurseForge publication and generated ZIP contents remain separately unconfirmed.

## Battleground protected faction-slash fix — 6 November 2026

**Babuni:** supplied the live battleground `ADDON_ACTION_BLOCKED` stack showing RoarForever reaching protected `PerformEmote()` from `/fta`.

**AI contribution:** matched the stack to the current 0.6.5 faction slash handler, verified the Forever restricted-action model, removed addon-initiated faction `DoEmote` calls while preserving local voice/announcement and direct-call observation, and added regression coverage proving faction slashes leave `DoEmote` untouched.

**Version and verification boundary:** `v0.6.5-beta` was already published on commit `aa2c73445838460f58af53d0f07239e213d0d828`, so this source fix belongs to 0.6.6-beta development. The live failure is confirmed evidence for the diagnosis; updated automated and live battleground verification are pending.

