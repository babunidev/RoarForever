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

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.

## 4 November 2026 — release 0.6.1-beta before live-client testing

**Decision:** publish `0.6.1-beta` as a clearly marked beta once automated regression tests passed, even though the live Forever release client was not yet available for in-game verification.

**Reasoning:** the release-facing changes were narrow, the automated suite covered the existing behavior and the only new runtime change since 0.6.0-beta was outgoing COMM result diagnostics. Waiting would have prevented users from receiving the updated Forever release-path/compatibility build at launch. The release notes therefore state the verification boundary explicitly and preserve `v0.5.7-beta` as the pre-0.6 fallback.

**Publication:** Babuni explicitly authorized the public tag. The annotated `v0.6.1-beta` tag points to commit `4064b9ffc43d14e27f6c74a07705139156e999f3`. CurseForge detected it as a Beta for Forever 1.60.1 and entered Processing.

**Still unverified:** live multiplayer COMM, real audio playback, UI behavior, 50-yard behavior in the release client and SoundKit-based attenuation.

## 4 November 2026 — keep public packages runtime-only

**Decision:** CurseForge install archives should contain only the files required by WoW at runtime. Development documentation remains in GitHub but is excluded through `.pkgmeta`.

**Reasoning:** README, roadmap, project instructions, development history and portfolio-oriented documentation are useful in the repository but add no value inside a player's AddOns folder. Version 0.6.2-beta is therefore a packaging-only follow-up to 0.6.1-beta; no Lua behavior was changed for this correction.

**Release verification:** `v0.6.2-beta` was explicitly approved and published as an annotated tag on commit `028af0ce4980ef232bb9af8177e5ca1444c19f40`. The three Lua runtime files match `v0.6.1-beta` byte-for-byte. Final CurseForge package visibility and archive-content inspection remain separate pending checks.

## 5 November 2026 — skip secret unit identity instead of probing it

**Problem:** a live dungeon run produced a Lua error when `UnitFullName("target")` returned a secret string and RoarForever compared it with a normal sender name.

**Decision:** treat inaccessible identity as unavailable data. RoarForever checks secret names, GUIDs, race and sex before using them and skips the affected lookup instead of wrapping forbidden comparisons in `pcall` or trying alternate APIs to recover the same restricted identity.

**Reasoning:** Forever deliberately protects non-group unit identity on restricted maps. The addon only needs reliable identity for self/group duplicate suppression and for optional voice lookup. Self checks therefore use only `player`; group checks use only party/raid tokens; arbitrary target/focus/mouseover identity is a best-effort fallback and may be ignored when secret.

**Verification boundary:** the implementation is source-reviewed against Forever's secret-value API rules and simulated guard cases were added. A real restricted-map retest is still required because the local Lua simulator cannot create Blizzard-tagged secret values.

## 5 November 2026 — release 0.6.3-beta after exact-commit regression pass

**Decision:** publish the dungeon secret-identity fix and COMM/text roar deduplication together as `0.6.3-beta`.

**Reasoning:** both issues affect live Forever multiplayer behavior and are narrow compatibility fixes. The public package should replace 0.6.2-beta rather than leave users on a known restricted-map error and a confirmed duplicate-restoration path.

**Release gate:** Babuni explicitly approved the public beta. The annotated tag may be pushed only after `python tests/test_addon.py` passes on the exact release-preparation commit. Live dungeon and group-listening checks remain separate evidence and are not prerequisites for labeling this build as beta.

**Packaging:** retain the 0.6.2 runtime-only `.pkgmeta` policy; no development documentation or tests belong in the player ZIP.

