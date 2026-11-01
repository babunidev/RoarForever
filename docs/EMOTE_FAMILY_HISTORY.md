# A history of expressive World of Warcraft addons

**Creative:** Babuni · **Retrospective compiled:** 1 November 2026  
**Scope:** Related projects and source-grounded milestones, not an assertion that every later repository directly forks the previous one.

Across these experiments, my interest has been in giving characters a little more life during ordinary play. The underlying action stayed with the player; emotes supplied personality, surprise or a shared guild ritual. The surviving repositories trace changes in trigger methods, writing, customization, community features and client targets. AI assisted with implementation and later documentation where recorded, while creative direction remained mine.

## Timeline of the action-emote family

| First visible milestone | Current repository (earlier name) | What changed |
| --- | --- | --- |
| **18 Aug 2025** | [Action Emotes #1](https://github.com/babunidev/ActionEmotes-1) (BuxbrewCharge) | First addon: one watched action slot and randomly selected native emotes; current pool 10, fixed 21-second cooldown. |
| **Aug 2025** | [Stealth Emotes](https://github.com/babunidev/StealthEmotes) (Amazin) | Rogue Stealth-button experiment made for my younger brother: 12 built-in emotes, adjustable chance and cooldown; the source monitors the slot, not Stealth itself. |
| **12 Sep 2025** | [Action Emotes #2](https://github.com/babunidev/ActionEmotes-2) (Buxbrew / MadAxeBuxbrew) | A different expressive branch: 215 authored text emotes sent through chat instead of game-native emote tokens. |
| **22 Nov 2025** | [Battle Emotes Legacy](https://github.com/babunidev/BattleEmotesLegacy) (roar / ROAR) | BuxbrewCharge-derived single-slot system with five fixed native battle emotes and adjustable chance/cooldown. |
| **23 Nov 2025** | [Battle Emotes](https://github.com/babunidev/BattleEmotes) (roarr / ROARR) | Nearly identical gameplay implementation to Legacy; the second repository's tutorial expands to seven steps. |
| **14 Dec 2025** | [Multi Action Emotes](https://github.com/babunidev/MultiActionEmotes) (ROARRunlimited) | Multiple numbered action-slot configurations, each with its own chance/cooldown; four fixed native emote tokens in current code. |
| **10 Jan 2026** | [Roar Guild Addon](https://github.com/babunidev/RoarGuildAddon) (RoarGuild) | Multiple triggers plus a player-extensible native-emote registry, per-character profiles and guild identity; later gained manual recruiting messages and Roarboard (Aug 2026). |
| **27 Apr 2026** | [Roar Guild Addon Wrath](https://github.com/babunidev/RoarGuildAddonWrath) (ROARemoteTrigger → EmoteTrigger; installed as ROARTrigger) | Wrath 3.3.5 port of the guild-addon emote features, including editable emote registry and manual recruiting text; excludes the later Roarboard. |
| **22 Oct 2026** | [Flourish Forever](https://github.com/babunidev/FlourishForever) | WoW Forever addon with a graphical spellbook selector, per-ability native-emote choices and successful-spellcast event triggers rather than action-slot presses. |

These dates are documented **commits or first visible source milestones**, not proof of when every idea was first imagined. The two Battle Emotes repositories are closely related snapshots, not evidence of two separate gameplay engines.

## What “how many emotes?” actually means

**Fixed built-in pools:** Action Emotes #1, Stealth Emotes, Battle Emotes Legacy, Battle Emotes and Multi Action Emotes have lists defined in Lua; **players cannot add to those lists with an in-game command in the current source**. Action Emotes #2 instead holds 215 fixed authored roleplay lines. In particular, the five and four battle tokens are not merely default entries in an unlimited player-editable registry.

**Player-extensible native-emote registry:** Roar Guild Addon and its Wrath port begin with **ROAR** at registry ID 1. `/rogu emote LAUGH` registers another token, `/rogu emote list` lists entries, and `/rogu emote1 <id>` assigns an ID to an instance. There is no small hardcoded registry cap, but a token must be supported by the game client to function, and practical limits apply. This is not the same as creating custom animation assets or writing arbitrary text emotes.

**Player-selectable client emotes:** Flourish Forever presents native emote tokens reported by its target client, selecting a set for each configured spell. A new spell starts with ROAR selected. This is a user-editable **selection** of existing client tokens, not unrestricted creation of arbitrary tokens.

**Trigger semantics:** The earlier addons react to `UseAction` presses, even if a spell fails. Flourish Forever instead responds to the player's `UNIT_SPELLCAST_SUCCEEDED` event, which means a reported completed cast, **not** necessarily a landed hit. Its unsuccessful chance roll does not consume the emote cooldown, unlike the older configured ROAR implementations.

## Related sound-restoration branch

Two other repositories share the goal of expressive character presence, **but are not action-triggered emote generators**:

- [Roar Sound Effects](https://github.com/babunidev/RoarSoundEffects) (originally ROARSounds; source from **19 Apr 2026**) responds to observed text emotes and restores native voice assets, beginning with /roar.
- [Roar Forever](https://github.com/babunidev/RoarForever) (WoW Forever) expands the restoration idea into more voiced emotes, client-specific detection, options, language handling and experimental addon communication/distance behavior.

The distinction matters: an action-emote addon *initiates an emote*; a sound-restoration addon *tries to play an appropriate existing voice for an emote*. Their goals complement one another, but neither guarantees integration with the other.

## Guild history and attribution

ROAR was also my guild, which shaped the identity of the later Roar Guild projects. In those sources, `/rogu invite` **sends a randomized recruitment message to a chat channel when invoked**; it does not send a game API invitation to a named player and is not present in the two early Battle Emotes repositories. Roarboard is specific to the later Vanilla guild-addon revision.

The chronology is a **retrospective synthesis** from source and Git documentation, supplemented by my recollections. It does not establish exact code-copy relationships for every pair, assign unrecorded human–AI design conversations, or claim in-game verification of every current build. No runtime changes are implied by this historical document.

## This repository's place

Roar Forever is the **WoW Forever voice-restoration project**, creatively related to Roar Sound Effects. It restores client-native voice playback for a growing set of recognized emotes and explores addon communication and distance-sensitive audio. It does **not** implement an action-slot or successful-spellcast emote generator; that latter behavior belongs to Flourish Forever. Its own mapping and voice-preview choices must not be confused with the Roar Guild editable emote registry.
