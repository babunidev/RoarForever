# RoarForever — Voice, Localization and Source Provenance

**Author:** Babuni.dev

## Content model

`RoarForever.lua` contains race/sex voice-emote mappings to existing Blizzard FileDataIDs. The source mentions separate Skyborne mappings recovered for Forever build 1.60.1.70009; no custom recorded sounds are bundled. These mappings must not be described as newly composed or licensed original audio. The code supports 22 emote categories; additional emote aliases can share one category.

`Locales.lua` contains localized emote labels and full chat-emote matching templates, including five-language coverage described in the README. These are localization/detection data, distinct from sound files. `Options.lua` presents the user-facing settings and preview controls; the `.toc` declares the load order and persisted `RoarForeverDB` settings.

## Communications and testing

The 0.6.0-beta record describes addon messages with an emote key, voice identity, unique event identifier and optional world position/instance, with a fallback path for text emotes. `test_addon.py` supplies simulated Lua/WoW API regression coverage; historical test claims must not be mistaken for verification on a live Forever client.

## Portfolio publication

Use screenshots, debug output, diagrams and code excerpts with clear source versions. Distinguish Babuni.dev's creative/social objective, AI assistance, existing Blizzard game audio and community-derived metadata. Do not package or republish game-client audio as project-owned samples.
