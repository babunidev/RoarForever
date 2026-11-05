# RoarForever — agent instructions

**Human creative:** Babuni

Maintain current README and existing CHANGELOG. Preserve the intended artistic and technical behavior, client constraints, and third-party credits. Original direction is Babuni's; record AI proposals and implementations separately. Never turn proposed or untested behavior into confirmed results.

## Audit #33 documentation constraints

Keep the original release history as source evidence. Distinguish code-supported behavior (COMM/text fallback and distance-based *silence*) from unverified SoundKitID mappings and real attenuation. Treat Forever player identity as a full first-name and surname, not realm-qualified names. Credit Babuni for creative direction, AI for supported technical contributions, and client audio to its actual provider. Do not claim live test success from mocked WoW API tests.

Forever restricted maps can return **secret** unit identity values. Never compare, index, normalize, or use a potentially secret name/GUID/race/sex value as a table key before checking `issecretvalue`. Prefer player/party/raid identity tokens over arbitrary target/focus/mouseover identity when determining self or group membership; if identity is secret, skip that lookup rather than trying to recover it.

## Cross-project source boundaries

Consult [the expressive-addon family history](docs/EMOTE_FAMILY_HISTORY.md) for other ROAR and Flourish projects. Roar Forever restores existing sound for emotes; it does not pick action-bar emotes or trigger them on successful casts. Keep the voice-restoration history distinct from Roar Guild's player-editable token registry, and never imply untested audio features were verified.

## Repository-local documentation standard

Before writing or changing project documentation, read [docs/DOCUMENTATION.md](docs/DOCUMENTATION.md). These rules travel with this repository and do not depend on the babuni.dev ChatGPT Project. Preserve all project-specific technical, creative, canon, safety, licensing, and historical rules in this file; follow the linked standard for public first-person narrative, human–AI attribution, concise development journals, decision records, and evidence-based verification. **Babuni** is the human creative; **babuni.dev** is the website/portfolio, not the person. Preserve third-party credits and historical legal notices. References above to a dated “documentation-only audit” describe that past task, not a permanent ban on later authorized implementation.
