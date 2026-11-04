# RoarForever — architecture

**Author:** Babuni.dev

RoarForever.lua with Options.lua and Locales.lua provides emote and sound handling, settings/preview UI, options persistence and localizations; test_addon.py and an existing CHANGELOG document ongoing releases.

Source inspection establishes file and code design, not live-client verification.

## 0.6.x architecture

The TOC loads `Locales.lua`, `RoarForever.lua` and `Options.lua` and declares saved `RoarForeverDB` settings. The runtime maps 22 voice-emote categories to built-in FileDataIDs for races, sexes and Skyborne; the option panel offers a per-category switch and sound preview; localization data contains official-pattern emote templates rather than generic guessed keywords.

The 0.6.x COMM payload records emote, voice key, event and optional position/instance. The receiver favors peer packets where available, with a **0.10s** text fallback and deduplication in both arrival orders. A same-instance distance of **50 yards or greater** produces silence; mismatched instance IDs also suppress audio. Missing position permits full fallback. In-range FileDataID playback remains available while verified SoundKitIDs are missing, so *smooth volume attenuation is not yet confirmed*. Group train COMM is suppressed where the game already handles group train sounds.

Treat full two-part Forever player names as identity, avoiding invented realm-suffix concerns. `test_addon.py` tests a simulated environment; the 0.6.1-beta suite passed 593 translated template cases across seven locale variants together with menu/settings/preview/train/faction/Skyborne/COMM-distance/identity/detection regressions. Real sound playback, audio channel/mix, positioning, networking and client compatibility still require live game verification. Version 0.6.1-beta also reports outgoing addon-message result codes through `/rf debugcomm`; this improves diagnostics without changing the COMM protocol.

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.
