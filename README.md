# Roar Forever

Roar Forever restores missing character voice sounds when players use emotes in **World of Warcraft Forever**. It uses voice files already present in the game client—no additional voice pack is required.

**Creative direction:** Babuni · **Target:** Forever 1.60.1, Interface `16001` · **Settings:** account-wide `RoarForeverDB`

## What you hear

The addon listens for supported emotes and plays the corresponding character voice when Forever does not reliably play it. It covers `/roar`, `/cheer`, `/laugh`, `/joke`, `/train`, the faction cries and a range of other familiar calls.

Most standard emotes work when another player uses them, even if that player does not have Roar Forever installed. Custom train and faction cries rely on a recognizable optional chat announcement for other addon users to hear them.

The audio is **local**. It does not send addon packets, and the current chat-driven design lets the game determine which nearby emotes reach your client. It does not promise simulated distance-based volume fading or sound from players whose chat event is unavailable.

See the [complete emote list and behavior](docs/EMOTE_REFERENCE.md).

## Install

1. Extract the available `RoarForever.zip` into `World of Warcraft/_forever_/Interface/AddOns/`.
2. Make sure the `RoarForever` directory contains `RoarForever.toc`, `Locales.lua`, `RoarForever.lua` and `Options.lua`.
3. Restart the game and enable the addon.

No external library, account-specific folder link or separate language download is required.

## Controls

Type `/rf` or `/rf config` to open the movable options window. From there, enable or disable categories, preview their voices, and choose whether train and faction cries include an announcement.

| Command | Use |
| --- | --- |
| `/rf on` / `/rf off` | Enable or disable restored playback |
| `/rf test` | Test your character's mapped roar |
| `/rf test <emote>` | Preview another mapped emote |
| `/rf status` | Show voice and enabled settings |
| `/rf debugplay` | Toggle playback diagnostics |
| `/fth` / `/fta` | Horde / Alliance faction cries |

`/roarforever` also works in place of `/rf`. For the FileDataID test command and every supported alias, see the [full reference](docs/EMOTE_REFERENCE.md).

## Version and verification

The existing documentation describes multiple beta milestones through a **0.6.6-beta release candidate**, including the shift from addon COMM messages to received chat events as remote triggers. Individual tags, client tests and CurseForge publication did not all happen together.

A battleground safeguard was tested live: Roar Forever disables itself in battleground instances to avoid protected-action failures and resumes outside them. This result does not mean that every sound, race, language or instance has been fully tested.

For authoritative historical dates and versions, consult [CHANGELOG.md](CHANGELOG.md), [the technical reference](docs/EMOTE_REFERENCE.md) and the [development journal](docs/DEVLOG.md). Do not treat a prepared candidate or Git tag as proof of a CurseForge release.

## Development and documentation

Run `python tests/test_addon.py` with the `lupa` package available to execute the Lua-mock checks. These are simulated WoW API tests, not confirmation of actual in-game audio or settings persistence.

| Topic | Read |
| --- | --- |
| Scope and design | [Concept](CONCEPT.md) · [Design](docs/DESIGN.md) |
| Behavior and compatibility | [Emote reference](docs/EMOTE_REFERENCE.md) · [Architecture](docs/ARCHITECTURE.md) |
| Progress and decisions | [Roadmap](ROADMAP.md) · [Changelog](CHANGELOG.md) · [Decisions](docs/DECISIONS.md) |
| Origins and creative lineage | [Development journal](docs/DEVLOG.md) · [Emote project history](docs/EMOTE_FAMILY_HISTORY.md) |
| Contributor instructions | [AGENTS.md](AGENTS.md) · [Documentation standard](docs/DOCUMENTATION.md) |

Roar Forever concerns voice restoration; it is not the ability-triggered expression addon **Flourish Forever**. Their shared creative history does not make their mechanics interchangeable.
