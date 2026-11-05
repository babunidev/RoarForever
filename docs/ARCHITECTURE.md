# RoarForever — architecture

**Author:** Babuni.dev

RoarForever.lua with Options.lua and Locales.lua provides emote and sound handling, settings/preview UI, options persistence and localizations; test_addon.py and an existing CHANGELOG document ongoing releases.

Source inspection establishes file and code design, not live-client verification.

## 0.6.x architecture

The TOC loads `Locales.lua`, `RoarForever.lua` and `Options.lua` and declares saved `RoarForeverDB` settings. The runtime maps 22 voice-emote categories to built-in FileDataIDs for races, sexes and Skyborne; the option panel offers a per-category switch and sound preview; localization data contains official-pattern emote templates rather than generic guessed keywords.

The 0.6.x COMM payload records emote, voice key, event and optional position/instance. The receiver favors peer packets where available, with a **0.10s** text fallback and deduplication in both arrival orders. A same-instance distance of **50 yards or greater** produces silence; mismatched instance IDs also suppress audio. Missing position permits full fallback. In-range FileDataID playback remains available while verified SoundKitIDs are missing, so *smooth volume attenuation is not yet confirmed*. Group train COMM is suppressed where the game already handles group train sounds.

Treat full two-part Forever player names as identity, avoiding invented realm-suffix concerns. `test_addon.py` tests a simulated environment; the 0.6.1-beta suite passed 593 translated template cases across seven locale variants together with menu/settings/preview/train/faction/Skyborne/COMM-distance/identity/detection regressions. Real sound playback, audio channel/mix, positioning, networking and client compatibility still require live game verification. Version 0.6.1-beta also reports outgoing addon-message result codes through `/rf debugcomm`; this improves diagnostics without changing the COMM protocol.

### Secret-aware unit identity

Forever restricted maps can return secret values from unit identity APIs. Development main routes `UnitName`/`UnitFullName` and `UnitGUID` through guarded helpers and checks race/sex values before constructing voice keys. Self classification reads only the `player` unit; group classification scans party/raid tokens only. `target`, `mouseover`, and `focus` remain optional voice-key fallbacks, but secret identities are discarded before comparison or string/table operations. This preserves accessible player/group behavior without attempting to bypass Forever's restrictions.

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.

### COMM/text sender correlation

Forever's `CHAT_MSG_ADDON` event provides the sender name but no sender GUID, whereas `CHAT_MSG_TEXT_EMOTE` includes the sender GUID. Event-ID deduplication handles repeated SAY/PARTY/RAID copies of one COMM packet, but COMM-versus-text correlation must not use GUID-preferred identity keys because the two events expose different identity fields. Development main therefore correlates the brief COMM/text fallback window by normalized sender name. GUID-aware identity remains available for self/group classification and voice lookup where the event actually supplies it.

### Group roar boundary and duplicate diagnostics

A direct live test with RoarForever disabled confirmed that Forever does not provide the missing group `/roar` sound. Group `/roar` therefore remains an intentional RoarForever restoration path; only grouped `/train` keeps its established native-client suppression.

COMM and text-emote events expose different identity shapes, so both short-window correlation and playback cooldown identity use the normalized sender name when available. Development 0.6.4 also exposes `/rf debugplay`, which reports each actual FileDataID playback and whether it came from COMM, text fallback, or self-text handling. This lets live testing distinguish duplicate addon calls from a single sound call whose asset or client playback sounds layered.

