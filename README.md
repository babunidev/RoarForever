# Roar Forever

**Author:** Babuni.dev

A lightweight player voice-emote sound fix for World of Warcraft: Forever.

> **0.6.4-beta:** tagged and pushed on tested commit `8c98e630f09bbe68cf6abeaebd7f2118a44f6274`. It fixes the group-only local COMM self-echo that could double `/roar` and faction-cry playback. CurseForge publication is still awaiting confirmation.

Roar Forever restores character voice sounds that Forever does not reliably play when nearby players use voiced emotes. It uses audio already included in the game client, so there are no bundled sound files. It works with default settings; `/rf` opens its options.

> **0.6.3-beta:** published tag for Forever 1.60.1 containing the restricted-map secret unit-identity fix and COMM/text `/roar` deduplication. A later grouped-roar overlap correction is not part of that tag.

> **0.6.5-beta:** published chat-driven release on commit `aa2c73445838460f58af53d0f07239e213d0d828`, replacing COMM/distance playback with received chat emotes as the sole remote trigger.

> **0.6.6-beta release candidate:** RoarForever is disabled entirely while inside battleground instances (`IsInInstance()` type `"pvp"`) after live protected-action failures there. Live testing confirms no addon errors in battlegrounds and normal behavior resumes after leaving. Babuni approved public beta publication; the tag is gated on the updated automated suite passing on the exact release commit.

## Options and previews

Open `/rf` or `/rf config` for a movable Warcraft-style menu. Toggle individual emote categories, enable or disable the addon, and choose whether restored emotes send their extra chat messages (`/train`, `/forthehorde`, `/forthealliance`). Aliases such as `/flee` and `/retreat` share one switch.

Each speaker button plays one randomly selected sound for that emote from all mapped races and genders. It does not use only your character's voice. Previews work even if that emote or the addon is switched off, never send chat, and stop the previous preview when you choose another.

These switches control which built-in game voice-emote sounds Roar Forever restores. They do not silence voices that WoW itself plays. In particular, turning off the chat announcement does not disable the native `/train` animation or voice.

## Restored emotes

- `/roar` — restored for your own character and other players.
- `/cheer` — restores the race/sex-specific cheer for other players.
- `/laugh` / `/lol` — restores the race/sex-specific laugh for other players.
- `/joke` / `/silly` — restores a random race/sex-specific joke voice line for other players, chosen from that voice's full joke set.
- `/moo` — restores the dedicated Tauren male/female moo for other players. Other races have no dedicated player-character moo voice file.
- `/flee` / `/retreat` — restores the flee voice for other players. Retreat uses the same voice as flee.
- `/welcome` — restores the race/sex-specific welcome for other players.
- `/yes` / `/no` — restores the race/sex-specific yes and no voices for other players.
- `/healme` — restores the race/sex-specific call for healing for other players.
- `/rasp` — restores the raspberry voice for other players. `/rude` uses the same line.
- `/flirt` — restores a random race/sex-specific flirt line for other players.
- `/oom` — restores the low-mana voice for other players.
- `/sigh` — restores the race/sex-specific sigh for other players.
- `/charge` — restores the race/sex-specific charge voice for other players.
- `/cry` — restores the race/sex-specific cry for other players.
- `/congrats` / `/congratulate` — restores a random congratulations line for other players.
- `/followme` — restores the follow-me voice for other players.
- `/whistle` — restores the whistle for other players.
- `/train` — Roar Forever takes over `/train`, plays the normal choo-choo, and can announce "blows a train whistle. Choo choo!" Other Roar Forever users restore train when they receive its chat announcement and the game does not already play it. In a party or raid, group-member train stays with the native client sound (no addon double).
- `/forthehorde` / `/fth` — Horde-only. Plays the race/sex “For the Horde!” voice and optional announce line. Other Roar Forever users hear it when they receive its chat announcement, including in a party or raid.
- `/forthealliance` / `/fta` — Alliance-only. Same behavior with the “For the Alliance!” voices. Forever does not currently wire either native faction-emote token, so the cheer animation may be missing until Blizzard adds it. Using the wrong faction’s command prints a short refusal. No Skyborne faction-cry recording was found in the client.

### Chat-driven playback

Received `CHAT_MSG_TEXT_EMOTE` and recognized custom `CHAT_MSG_EMOTE` lines are the sole remote sound triggers. The game controls delivery range; Roar Forever adds no distance calculation or attenuation. It neither sends nor receives addon packets, so old peers' SAY/PARTY/RAID copies cannot cause another sound. Hiding an emote in your chat-window settings is not an addon mute: receipt of the event is what matters.

Keep announcements enabled if you want nearby addon users to restore your train or faction cry. With announcements off, the local voice still works, but this addon supplies no remote restoration signal. Standard emotes do not require the sender to have this addon. Voice identity must be available through the event GUID or an accessible unit; inaccessible identities are skipped.

One tracked sound per speaker replaces that speaker's previous restored voice. Different speakers can overlap. State is capped at 128 speakers; the least recently active speaker is evicted at capacity. Every five seconds, records idle for at least 60 seconds are removed and their handles stopped. There is no network-event cache. Preview pools are finite and independent.

Roar Forever does not replay your own normal voiced emotes, because the client already plays those. `/roar` remains the self exception for races that have no client roar; Skyborne already have a native self roar and are left to the game. In a party or raid, most ordinary group voices are left to the client, but `/roar` remains restored by RoarForever because a live addon-off check confirmed Forever provides no group roar sound. Faction cries remain addon-driven because Forever does not natively wire them. Nearby players who are not in your group still get the restored set.

Someone who is not using Roar Forever can still `/train` without sending a line, so there is nothing for the addon to hear unless they use a distinctive announce. The same is true for faction cries without the distinctive chat line.

## Installation

1. Extract `RoarForever.zip` into `World of Warcraft\_forever_\Interface\AddOns`.
2. Check that the `RoarForever` folder contains `RoarForever.toc`, `Locales.lua`, `RoarForever.lua`, and `Options.lua`. Install all four files together.
3. Restart WoW and enable **Roar Forever** in the addon list.

Playback is local: another player does not need Roar Forever installed for you to hear a supported detected emote from them (except announced custom lines such as `/train` and the faction cries). Your on/off state, individual emote choices, and announcement choice are saved through the normal account-wide `RoarForeverDB`. No folder links or account-specific setup are used.

## Commands

| Command | Purpose |
|---|---|
| `/rf` or `/rf config` | Open or close the options window. |
| `/rf on` | Turn Roar Forever on. |
| `/rf off` | Turn Roar Forever off. |
| `/rf test` | Play your character's mapped roar sound. |
| `/rf test <emote>` | Test a mapped emote for your character, including `train`, `whistle`, `forthehorde`, and `forthealliance`. |
| `/forthehorde` or `/fth` | Horde faction cry (Roar Forever). |
| `/forthealliance` or `/fta` | Alliance faction cry (Roar Forever). |
| `/rf status` | Show whether the addon is on, your character voice, and the mapped emotes. |
| `/rf id <FileDataID>` | Test a specific FileDataID. |
| `/rf debugplay` | Toggle actual restored-sound playback tracing, including source path, speaker key, FileDataID, and sound handle. |

`/roarforever` can also be used in place of `/rf`.

## Compatibility

- Targets World of Warcraft: Forever 1.60.1, Interface `16001`.
- Includes male and female voice mappings for Dwarf, Gnome, Human, Night Elf, Orc, Tauren, Troll, Undead, and Skyborne characters.
- Bundled languages: English, German, French, Spanish, and Russian. The menu and standard emote detection follow your client language. `enGB` uses English and `esMX` uses the Spanish pack; unsupported client languages fall back to English labels/templates.
- Translated full-message templates were sourced from [Forever 1.60.1.70009 EmotesTextData](https://wago.tools/db2/EmotesTextData?build=1.60.1.70009). No separate CurseForge language downloads are needed. French grammatical prefixes and Russian declined names are accounted for; client updates can change wording, so release builds should be spot-checked in game.
- Custom `/train` and faction-cry announcements remain the same English lines in every locale so different-language addon users can recognize them.
- On restricted maps such as dungeons and raids, Forever can make non-group unit identity values secret. Development main checks `issecretvalue` before using unit names/GUIDs/race/sex and skips inaccessible identities instead of comparing them.
- Sound mappings use Blizzard FileDataIDs from the current wowdev community listfile.
- Gnome female `/roar` playback has been confirmed in-game. The new restored emotes should be treated as beta until they have been checked in the Forever client.

## Release notes

See [CHANGELOG.md](CHANGELOG.md).

## Development checks

Run `python tests/test_addon.py` with the `lupa` package installed (Lua 5.1 runtime). Tests are excluded from CurseForge packages. Automated checks use simulated WoW APIs; verify window layout, actual audio, and a logout/login settings cycle in the game before treating a beta release as fully validated.

## Development documentation

- [Concept](CONCEPT.md) · [Roadmap](ROADMAP.md) · [Changelog](CHANGELOG.md)
- [Architecture](docs/ARCHITECTURE.md) · [Design evidence](docs/DECISIONS.md) · [Development journal](docs/DEVLOG.md)
- [AI collaborator rules](AGENTS.md)

The journal distinguishes source-based reconstruction, author direction, AI assistance, and independently verified behavior.

## Documentation audit #33 — 27 October 2026

The current source declares **0.6.5-beta** (Interface 16001). Its historical documentation records the evolution from local missing-voice restoration to configured emote categories, multiplayer COMM, text fallback and distance-based suppression. These are separate from *verified volume attenuation*, which depends on verified SoundKitID mappings. The existing client audio is not authored by the addon.

Expanded portfolio documentation: [interaction design](docs/DESIGN.md), [content/audio provenance](docs/CONTENT.md), [architecture](docs/ARCHITECTURE.md), [decisions](docs/DECISIONS.md), [development history](docs/DEVLOG.md) and [human–AI collaboration](docs/AI_COLLABORATION.md). This audit is documentation-only; no client tests were run.

## The wider creative lineage

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry. The [cross-repository expressive-addon history](docs/EMOTE_FAMILY_HISTORY.md) distinguishes the older Roar Sound Effects experiment, action-emote generators, and Flourish Forever's successful-spellcast approach.
