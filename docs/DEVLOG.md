# RoarForever — development history

**Author:** Babuni.dev

## Retrospective review — 2026-10-26

A sound-restoration and voiced-emote companion for World of Warcraft: Forever, using game-bundled race/sex-specific voice assets. The source implements this direction through RoarForever.lua with Options.lua and Locales.lua provides emote and sound handling, settings/preview UI, options persistence and localizations; test_addon.py and an existing CHANGELOG document ongoing releases. Sound restoration is optional and per-emote; 0.6 beta source/README describes addon-to-addon COMM and distance rules, with SoundKitID coverage explicitly requiring in-game verification.

The README and CHANGELOG preserve more detailed functional and version context. This entry does not invent earlier discussion or imply the present audit tested the addon. The creative direction and authorship remain mine; AI created a source-grounded narrative and structure around the existing work. Peer emote detection, duplicated text/COMM cases, distance cutoff and SoundKitIDs still require validation inside the actual Forever client.

## 2026-10-27 — Audit #33: from a missing roar to audible company

RoarForever began with a characterful inconvenience: a voiced emote should be heard by those around the player, yet the Forever client could leave the moment silent. The direction I wanted was to restore the personality already encoded in the game's own voices without shipping an alternate sound library. From there, the standalone addon grew into a configurable set of emote categories, presentation controls and more complete race/sex voice coverage, with separate localization templates.

For 0.6.0-beta, the idea expanded into a second social layer: when nearby players also run the addon, a small COMM packet can identify the emote and position. A short fallback keeps visible emote chat as a source when that packet never arrives. Technical design and implementation support from my AI assistant covered the communication, deduplication and distance-handling approach while preserving the existing FileDataID fallback. The 50-yard rule establishes the intended audible boundary in source; true volume falloff still needs verified SoundKitIDs in the game.

**Creative direction:** mine. **AI contribution:** technical design, implementation support and documentation where evidenced. **Iteration:** moving from chat-only inference to COMM and distance handling without claiming universal audio coverage. **Verification:** source and changelog inspected; no game-client sound, network, latency or cross-player test was executed in this audit.

## 1 November 2026 — keeping the two Forever addons distinct

Looking across the older ROAR and Buxbrew projects, I wanted this audio-restoration work to retain its own place in the history. **Roar Forever** aims to make voiced emotes audible, while **Flourish Forever** decides when a selected ability may create an emote; the names are similar, but their triggers and responsibilities differ. The present sources were compared with my AI assistant, which added this context to [the full history](EMOTE_FAMILY_HISTORY.md) while preserving the separate origin in Roar Sound Effects. No new playback verification or code changes were made in this documentation pass.

## 4 November 2026 — preparing Roar Forever for the live client

With Forever leaving beta, the release-facing setup needed to match the live game without changing sound data that had not been reverified. The installation path now points to the live `_forever_` client, compatibility wording targets Forever 1.60.1 / Interface 16001, and `/rf debugcomm` reports outgoing addon-message result codes so throttling or communication lockdown can be diagnosed during multiplayer tests.

As part of this pass, my AI assistant compared the current repository against the latest Forever addon/API notes and implemented the diagnostics and documentation changes I accepted. Existing FileDataID mappings, COMM protocol behavior, distance gating and the empty SoundKit mapping layer were deliberately left unchanged; launch-client multiplayer and audio behavior still require in-game verification.

## 4 November 2026 — 0.6.1-beta publication

With the live Forever client about to open, I approved 0.6.1-beta as a deliberately cautious beta rather than waiting for an in-game test that was not yet possible. The automated Lua regression suite passed 593 translated template cases across seven locale variants together with menu, settings, preview, train, faction-cry, Skyborne, COMM-distance, identity and detection regressions.

Release documentation and diagnostics were prepared with my AI assistant, while the final publication decision and tag approval were mine. The annotated `v0.6.1-beta` tag was pushed on commit `4064b9ffc43d14e27f6c74a07705139156e999f3`. CurseForge detected it as a **Beta** for Forever **1.60.1** and entered **Processing**. That confirms the tag-triggered packaging path reached CurseForge, but it is not yet evidence of an approved public file or successful live-client behavior.

The release notes explicitly preserve `v0.5.7-beta` as the pre-0.6 fallback if launch-day problems appear. Live multiplayer COMM, actual audio behavior, UI behavior and SoundKit-based attenuation remain unverified until the release client can be tested.

## 4 November 2026 — trimming the install package

After publishing 0.6.1-beta, I noticed the CurseForge archive was carrying repository documentation that players do not need to run the addon. The packaging rules had only excluded tests, so README, roadmap, project instructions and the documentation folder could travel with the install even though WoW ignores them.

The correction approved for 0.6.2-beta is deliberately narrow: keep the repository documentation intact for development and the babuni.dev portfolio, but exclude it from the CurseForge archive. The package now targets only `RoarForever.toc`, `Locales.lua`, `RoarForever.lua` and `Options.lua`. Runtime Lua behavior is unchanged from 0.6.1-beta, and live release-client verification remains pending.

## 4 November 2026 — publishing 0.6.2-beta

The packaging cleanup was released as `v0.6.2-beta` after confirming that `RoarForever.lua`, `Locales.lua` and `Options.lua` were byte-for-byte identical to `v0.6.1-beta`. Only package rules, version metadata and repository documentation changed, so this release does not introduce new addon runtime behavior.

Publication was explicitly approved by me. The annotated `v0.6.2-beta` tag points to commit `028af0ce4980ef232bb9af8177e5ca1444c19f40`. My AI assistant prepared and audited the packaging rules, version documentation and release comparison; the final tag was created and pushed from my local repository. CurseForge publication and the final downloadable archive remain separate verification steps until the new file is publicly visible and its contents can be inspected.

## 5 November 2026 — the first dungeon secret-value failure

A live dungeon run exposed something the simulated test environment could not reproduce: Forever returned the current target's name as a secret string, and RoarForever tried to compare that protected value while deciding whether an addon-message sender was me or someone in the group. The client stopped the comparison at the old `FindUnitBySender` path.

The fix I accepted follows Forever's restriction rather than trying to work around it. Unit names, GUIDs, race and sex are now checked for secrecy before RoarForever compares, normalizes or uses them as speaker identities. Self detection only inspects `player`, group detection only inspects party/raid units, and target/focus/mouseover are left as optional voice fallbacks that can simply fail when their identities are protected.

Technical tracing and implementation support from my AI assistant covered the stack analysis, current Forever secret-value predicates, the guarded identity layer and simulated regression cases. On 5 November 2026, `python tests/test_addon.py` passed with 593 translated template cases, seven locale variants, and the full regression suite including the new secret-identity guards. Those automated checks still cannot manufacture Blizzard's real secret-value tag, so the original dungeon case remains a required live retest before this fix is called in-game verified.

## 5 November 2026 — tracing the doubled group roar

While testing in a group, the roar sounded as though two copies were landing almost together. The existing COMM event-ID dedupe looked correct, so the next step was to compare the two event streams that represent the same emote. That exposed a mismatch the simulator had hidden: Forever's `CHAT_MSG_ADDON` supplies the sender name but no sender GUID, while `CHAT_MSG_TEXT_EMOTE` supplies a GUID.

RoarForever had preferred GUIDs when building the short-lived COMM/text fallback key. One logical roar could therefore be stored as a name-keyed COMM event and then fail to match the GUID-keyed text event, allowing the delayed text fallback to play a second copy roughly a tenth of a second later. The fix I accepted keeps identity-sensitive classification intact but correlates these two event streams by normalized sender name, which both provide.

The simulator was also corrected so addon messages no longer receive an invented GUID. Automated execution of that updated regression is still pending. If a live group retest still produces two simultaneous roars after this fix, the remaining candidate is native Forever group-roar audio overlapping one intentional addon restoration; that behavior must be verified separately before changing the established group-roar design.

## 5 November 2026 — preparing 0.6.3-beta

The two launch-day fixes now belong together in one beta: restricted dungeon identity can no longer be treated like ordinary Lua strings, and COMM/text roar deduplication now uses an identity field both Forever event paths actually share. After testing the dungeon fix successfully enough to continue and identifying the separate doubled-roar path, I approved 0.6.3-beta for public release.

Release preparation keeps the lean package introduced in 0.6.2-beta. My AI assistant updated the version, release notes, roadmap and provenance records and compared the release scope against the previous public tag. The annotated public tag remains deliberately uncreated until the complete updated regression suite passes on the exact release commit; live dungeon and grouped-roar listening remain separately documented beta verification.

## 5 November 2026 — removing the old group-roar exception

The first deduplication fix removed a genuine addon-versus-addon double path, but the grouped roar still sounded doubled in live play. Looking again at the playback rules exposed an older assumption: RoarForever deliberately restored `/roar` for party and raid members even though the client already owned most other grouped voices.

Current Forever behavior and player reports point the other way now. Grouped voiced emotes are audible natively, so keeping that exception can layer one addon roar over one client roar. The fix I accepted removes addon group-roar playback from both COMM and text restoration while leaving nearby non-grouped restoration and self-roar behavior intact.

Technical review and implementation support from my AI assistant covered the second-pass playback audit, regression updates and release-history correction. During that review, the `v0.6.3-beta` tag was found to have already been published on the earlier release-preparation commit, so the native group-roar correction could not truthfully be folded into that immutable tag. Development therefore advanced to 0.6.4-beta, with the complete updated test suite and grouped-roar live retest still pending.

## 5 November 2026 — testing the native-roar hypothesis

The native-overlap explanation did not survive a direct test. With RoarForever disabled, a grouped `/roar` produced no roar sound at all. That puts the central premise back where it belongs: group roar is missing from Forever and is precisely one of the sounds this addon must restore.

The temporary group-suppression implementation was therefore reverted before release. The failing automated test had independently caught the same design mistake by expecting a grouped friend's roar to add one restored sound. Rather than lengthening the intentionally short spam cooldown, the corrected 0.6.4 development code now uses the normalized sender identity consistently for both COMM/text correlation and the playback cooldown.

A new `/rf debugplay` trace records each actual FileDataID playback with its source path. Technical implementation and documentation corrections were handled with my AI assistant. The corrected automated suite then passed all 593 translated template cases, seven locale variants, and the full regression set including group roar restoration, COMM/text sender correlation, logical-sender playback dedupe and secret-identity guards. The remaining evidence needed is a live grouped roar trace showing whether the addon calls playback once or more than once.

## 5 November 2026 — the group-only timing gap

The useful clue was not merely that the roar sounded doubled, but that it seemed specific to being grouped. Outside a group, one COMM roar normally travels over SAY. Inside a group, the same logical event can also arrive through PARTY or RAID and sometimes INSTANCE_CHAT, all carrying the same event ID.

The event-ID dedupe itself was doing its job: later channel copies did not immediately play another sound. The timing gap sat beside it. Those later copies returned before refreshing the short COMM/text suppression timestamp, so a text-emote event arriving after the first packet's 0.35-second window could become eligible to restore the same roar again.

The fix I accepted moves fallback cancellation and recent-COMM refresh ahead of event-ID deduplication. Duplicate group-channel packets remain silent, but they keep the matching text fallback suppressed for the duration of the real multi-channel delivery. A regression now models SAY, a delayed PARTY copy and a later text-emote event for the same event ID. On 5 November 2026, the complete suite passed all 593 translated template cases, seven locale variants, and the full regression set including delayed group-channel dedupe. Live grouped-roar verification remains the final check for this fix.

