# RoarForever — Voice, Localization and Source Provenance

**Author:** Babuni.dev

## Content model

`RoarForever.lua` contains race/sex voice-emote mappings to existing Blizzard FileDataIDs. The source mentions separate Skyborne mappings recovered for Forever build 1.60.1.70009; no custom recorded sounds are bundled. These mappings must not be described as newly composed or licensed original audio. The code supports 22 emote categories; additional emote aliases can share one category.

`Locales.lua` contains localized emote labels and full chat-emote matching templates, including five-language coverage described in the README. These are localization/detection data, distinct from sound files. `Options.lua` presents the user-facing settings and preview controls; the `.toc` declares the load order and persisted `RoarForeverDB` settings.

## Communications and testing

The 0.6.x record describes addon messages with an emote key, voice identity, unique event identifier and optional world position/instance, with a fallback path for text emotes. `test_addon.py` supplies simulated Lua/WoW API regression coverage. The 0.6.1-beta suite passed on 4 November 2026, but automated results must not be mistaken for verification on the live Forever release client.

## Portfolio publication

Use screenshots, debug output, diagrams and code excerpts with clear source versions. Distinguish Babuni's creative/social objective, AI assistance, existing Blizzard game audio and community-derived metadata. Do not package or republish game-client audio as project-owned samples.

## Related development history

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. See [the source-backed comparison](EMOTE_FAMILY_HISTORY.md) for the distinct mechanisms and shared creative direction.
