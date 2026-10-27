# RoarForever — Interaction and Audio Design

**Author:** Babuni.dev

RoarForever makes voiced character expression audible in World of Warcraft: Forever where the client omits expected playback. The aim is restoration and lively social expression, **not replacement audio**. Sounds are built into the client and are selected by emote and speaker race/sex where known.

The movable `/rf` options panel contains an overall enable control, a toggle for extra chat announcements, switches for 22 emote categories and a speaker-preview button for each category. Preview chooses an existing mapped voice variant, even when normal playback is disabled, and sends no chat. Aliases such as Flee/Retreat share settings. The panel must not imply that switching an emote off suppresses voices the native game plays.

The 0.6.0-beta distance design prefers a nearby player's COMM message when available, retaining chat-text detection for people without the addon. A 0.10-second text fallback prevents duplicate playback from both paths. Distances of 50 yards or more in a matching instance are silent; mismatched instance IDs are silent, while missing position permits full-volume fallback. FileDataID fallback remains audible in range until genuine SoundKitIDs support attenuation.

The design emphasizes ordinary character emotes, optional faction cries and train sounds without requiring each player to install replacement sound files. Multiplayer listening, actual volume attenuation, window interactions and the five language templates remain in-game verification subjects. See [development history](../CHANGELOG.md) and [architecture](ARCHITECTURE.md).
