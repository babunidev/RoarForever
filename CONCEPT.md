# RoarForever — concept

**Author:** Babuni.dev

A sound-restoration and voiced-emote companion for World of Warcraft: Forever, using game-bundled race/sex-specific voice assets.

## Design qualities

Sound restoration is optional and per-emote; 0.6 beta source/README describes addon-to-addon COMM and distance rules, with SoundKitID coverage explicitly requiring in-game verification.

This is an evidence-based summary of README, code and existing development notes.

## From individual voices to shared presence

RoarForever started with a small expressive problem: missing playback made voiced emotes feel silent. The user-directed design is to restore built-in sounds, not ship replacement sound packs. Later revisions expanded to multiple sound categories, faction cries and train playback, plus a per-emote menu with previews and settings.

The 0.6.0-beta direction addresses social distance between addon users: COMM adds sender position when available; listeners suppress playback outside a 50-yard world-space boundary, while a brief chat fallback still supports players without the addon. The planned SoundKitID layer for continuous attenuation is distinct from already implemented out-of-range silence.

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](docs/EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.
