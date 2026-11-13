# Roar Forever

Roar Forever restores missing character voice sounds when players use emotes in **World of Warcraft Forever**. It uses voice files already present in the game client—no additional voice pack is required.

**Creative direction:** Babuni · **Current release:** 0.6.8-beta · **Target:** Forever 1.60.1, Interface `16001` · **Settings:** account-wide `RoarForeverDB`

## What you hear

The addon listens for supported emotes and plays the corresponding character voice when Forever does not reliably play it. It covers `/roar`, `/hello`, `/bye`, `/cheer`, `/laugh`, `/joke`, `/train`, the faction cries and a range of other familiar calls.

`/roar` is restored for every race, including Sky Elves, whether the roar is yours, a party or raid member's, or a nearby player's. In bear form, dire bear form, cat form, ghost wolf, aquatic form, moonkin form, or travel form, a typed `/roar` sends one form line instead (`roars like a bear.`, `roars like a cat.`, `howls like a spirit wolf.`, `gurgles like a murloc.`, `hoots like a moonkin.`, or `roars like a cheetah.`) and plays that creature sound. Other Roar Forever users hear that sound from the line, including party and raid members. A macro or emote button that calls the roar emote directly still sends the normal roar sentence.

`/hello`, `/hi`, `/bye`, `/goodbye`, and `/farewell` play for nearby players who are not in your group. `/greet` and `/wave` have no voice files in this client, so they stay silent. Most other standard emotes follow that same nearby-player rule. Your own ordinary emotes, and those of your group, stay with the game.

Most standard emotes work when another player uses them, even if that player does not have Roar Forever installed. Custom train, faction cries, and form roars rely on a recognizable optional chat announcement for other addon users to hear them. Restored sounds, previews, and `/rf id` follow the dialog volume slider.

The audio is **local**. It does not send addon packets, and the current chat-driven design lets the game determine which nearby emotes reach your client. It does not promise simulated distance-based volume fading or sound from players whose chat event is unavailable. Inside a battleground the addon stays off and resumes after you leave.

See the [complete emote list and behavior](docs/EMOTE_REFERENCE.md).

## Install

Download `RoarForever.zip` from CurseForge or from the assets on the GitHub release. Do not install the GitHub source archive; that download is the development repository.

1. Extract `RoarForever.zip` into `World of Warcraft/_forever_/Interface/AddOns/`.
2. Make sure the `RoarForever` directory contains only `RoarForever.toc`, `Locales.lua`, `RoarForever.lua` and `Options.lua`.
3. Restart the game and enable the addon.

No external library, account-specific folder link or separate language download is required.

## Controls

Type `/rf` or `/rf config` to open the movable options window. From there, enable or disable categories, preview their voices, and choose whether train, faction cries, and form roars include an announcement. Hello, bye, bear roar, cat roar, spirit wolf, aquatic form, moonkin, and cheetah are ordinary rows in that list.

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

**0.6.8-beta** is the current release. It adds hello and bye, form roars, and dialog-slider volume. **0.6.7-beta** restores Sky Elf `/roar` for you and for other players. **0.6.6-beta** is the tagged battleground release on commit `01d0059485dc62e81e8600de740631e65edd7188`.

A battleground safeguard was tested live: Roar Forever disables itself in battleground instances to avoid protected-action failures and resumes outside them. This result does not mean that every sound, race, language or instance has been fully tested. A live listen with two Sky Elf characters is still pending.

For authoritative historical dates and versions, consult [CHANGELOG.md](CHANGELOG.md), [the technical reference](docs/EMOTE_REFERENCE.md) and the [development journal](docs/DEVLOG.md). A Git tag is not by itself proof that CurseForge has finished publishing the file.

## Development and documentation

Run `python tests/test_addon.py` with the `lupa` package available to execute the Lua-mock checks. These are simulated WoW API tests, not confirmation of actual in-game audio or settings persistence. Tests and these documents are excluded from the install archive.

| Topic | Read |
| --- | --- |
| Scope and design | [Concept](CONCEPT.md) · [Design](docs/DESIGN.md) |
| Behavior and compatibility | [Emote reference](docs/EMOTE_REFERENCE.md) · [Architecture](docs/ARCHITECTURE.md) |
| Progress and decisions | [Roadmap](ROADMAP.md) · [Changelog](CHANGELOG.md) · [Decisions](docs/DECISIONS.md) |
| Origins and creative lineage | [Development journal](docs/DEVLOG.md) · [Emote project history](docs/EMOTE_FAMILY_HISTORY.md) |
| Contributor instructions | [AGENTS.md](AGENTS.md) · [Documentation standard](docs/DOCUMENTATION.md) |

Roar Forever concerns voice restoration; it is not the ability-triggered expression addon **Flourish Forever**. Their shared creative history does not make their mechanics interchangeable.

## License

Original addon software is licensed under [MIT](LICENSE). Voices and audio are provided by the game client and are not redistributed or relicensed here.
