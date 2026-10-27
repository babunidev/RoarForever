# RoarForever — concept

**Author:** Babuni.dev

A sound-restoration and voiced-emote companion for World of Warcraft: Forever, using game-bundled race/sex-specific voice assets.

## Design qualities

Sound restoration is optional and per-emote; 0.6 beta source/README describes addon-to-addon COMM and distance rules, with SoundKitID coverage explicitly requiring in-game verification.

This is an evidence-based summary of README, code and existing development notes.

## From individual voices to shared presence

RoarForever started with a small expressive problem: missing playback made voiced emotes feel silent. The user-directed design is to restore built-in sounds, not ship replacement sound packs. Later revisions expanded to multiple sound categories, faction cries and train playback, plus a per-emote menu with previews and settings.

The 0.6.0-beta direction addresses social distance between addon users: COMM adds sender position when available; listeners suppress playback outside a 50-yard world-space boundary, while a brief chat fallback still supports players without the addon. The planned SoundKitID layer for continuous attenuation is distinct from already implemented out-of-range silence.
