# RoarForever — architecture

**Author:** Babuni.dev

RoarForever.lua with Options.lua and Locales.lua provides emote and sound handling, settings/preview UI, options persistence and localizations; test_addon.py and an existing CHANGELOG document ongoing releases.

Source inspection establishes file and code design, not live-client verification.

## 0.6.0-beta architecture

The TOC loads `Locales.lua`, `RoarForever.lua` and `Options.lua` and declares saved `RoarForeverDB` settings. The runtime maps 22 voice-emote categories to built-in FileDataIDs for races, sexes and Skyborne; the option panel offers a per-category switch and sound preview; localization data contains official-pattern emote templates rather than generic guessed keywords.

The 0.6.0-beta COMM payload records emote, voice key, event and optional position/instance. The receiver favors peer packets where available, with a **0.10s** text fallback and deduplication in both arrival orders. A same-instance distance of **50 yards or greater** produces silence; mismatched instance IDs also suppress audio. Missing position permits full fallback. In-range FileDataID playback remains available while verified SoundKitIDs are missing, so *smooth volume attenuation is not yet confirmed*. Group train COMM is suppressed where the game already handles group train sounds.

Treat full two-part Forever player names as identity, avoiding invented realm-suffix concerns. `test_addon.py` tests a simulated environment; real sound playback, audio channel/mix, positioning and client compatibility require live game verification.
