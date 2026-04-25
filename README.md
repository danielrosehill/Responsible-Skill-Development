![Banner](./assets/banner.png)

# Responsible Skill Development

A voluntary code of practice for developers building Claude / agentic-AI skills that interact with the open web — aimed at separating the **runtime information** a skill needs to execute from the **research information** an author accumulates about a target site's defensive posture.

Version 0.1 (Draft) · MIT.

---

## The problem

Skills — instruction-text units that direct a general-purpose model to perform a defined task, often with browser or HTTP tool access — have a dual-use property that is not yet routinely accounted for in how they are published.

A skill that automates interaction with a third-party website typically encodes two distinct kinds of information:

1. **Runtime information.** The code, selectors, request shapes, and instruction text required for the skill to execute. This must be present in the published artefact; otherwise the skill does not run.
2. **Research information.** The author's accumulated understanding of *how the target site defends itself* — which headers it inspects, which fingerprints it checks, which timing windows trigger interstitials, the conditions under which a CAPTCHA is or is not presented, observed rate-limit thresholds, the tree of challenges encountered during development. This is typically not required at runtime — the runtime negotiates with these surfaces, but does not need to *describe* them.

The two are usually colocated during development. They diverge in their distribution properties: runtime information is necessary for the skill's legitimate users; research information disproportionately advantages an attacker, because it shortens reconnaissance.

The publication problem is that, by default, both ship together. READMEs narrate which defensive mechanism the skill negotiates with; code comments explain which header is required and why; commit messages reference the bypass; captured HAR files end up in `fixtures/`. The skill is not made more useful to legitimate users by any of this. It is made more useful to someone forking it for a use the author did not intend.

## The proposal

Six commitments, voluntary and non-binding, that separate the two kinds of information at the workspace boundary.

### 1. Two workspaces per skill

A private **development workspace** holds the unfiltered research artefacts: HAR files, payload captures, fingerprint observations, threshold notes, challenge trees, probing scripts. A public **published workspace** holds only what is needed at runtime. The skill remains executable from the published workspace; the research residue does not propagate into it.

### 2. Sanitised published documentation

Five filters applied to anything entering the published workspace:

- **Auth-narration filter.** Reject prose that explains *which* defensive mechanism the target site uses or *how* the skill negotiates with it.
- **Bypass-framing filter.** Reframe content described as "defeating defence X" to instead describe the user-side outcome.
- **Dev-comment filter.** Strip code comments that narrate site defences. Replace with comments describing what the *code* does, or remove.
- **Naming filter.** Rename functions, variables, and files whose names gratuitously expose defensive internals (`solve_recaptcha_v2_audio_challenge` → `complete_verification`).
- **Fixture filter.** Scrub anti-bot signal data from test fixtures that isn't strictly required for the assertion.

Heuristic for borderline cases: *would this still make sense if the target site were anonymised?* If anonymising guts the meaning, the content is too defence-specific for the published workspace.

### 3. "What" over "how" in user-facing documentation

User-facing documentation describes the outcome, the inputs, and the limits. It does not read like a security write-up of the target's defensive model.

### 4. Anti-bot research is sensitive

Fingerprint observations, rate-limit thresholds, challenge trees, and timing-attack windows are kept in the development workspace. Not pasted into public issues, PR descriptions, or commit messages. Not committed to public branches, even temporarily. Not included in agent session transcripts that may be published.

### 5. White-hat default

Where a design decision branches between helping the skill's own user and a more general capability that also lowers the bar for abuse, prefer the former unless the use case explicitly justifies the latter. A skill that logs in on behalf of its own user is a different artefact from a skill that accepts an arbitrary credential list as input.

### 6. Publication is optional

Evaluate before publishing: does the published form materially advantage an attacker, and is the legitimate-user benefit large enough to outweigh that? "We built it, therefore we publish it" is not the default.

## Operational checklist

The agent-readable version of the Code includes a nine-item checklist intended to be runnable against a diff before commit / push / publish:

```
[ ] No raw payload captures (HAR, fixtures with auth headers, CAPTCHA flow screenshots) in the diff.
[ ] No prose narrates the target site's defensive mechanisms.
[ ] No code comments narrate the target site's defensive mechanisms.
[ ] No function/file/variable names gratuitously expose defensive internals.
[ ] No bypasses framed as bypasses; outcomes are framed user-side.
[ ] Test fixtures scrubbed of unnecessary anti-bot signal data.
[ ] Anti-bot research notes (thresholds, fingerprint maps, challenge trees) not in the diff.
[ ] White-hat-default rule considered for any new input surface.
[ ] Publish-or-not question considered, not skipped.
```

The checklist is structured for application by an AI agent reviewing its own output prior to publication, which is the realistic operating mode given that skills are increasingly authored with agent assistance.

## What the Code does not do

It is voluntary and self-attested. It does not certify, audit, or register adopters. It does not address responsible disclosure when an author discovers an outright security flaw (as opposed to a negotiable defensive surface) — those cases have separate, established norms. It does not address legality: terms-of-service compliance, computer-misuse legislation, and data-protection regimes remain the author's responsibility.

It is layered on top of normal good engineering practice (no committing secrets, no shipping known-vulnerable dependencies), not in place of it.

## Adoption

Adoption is signalled with a one-line reference in the published artefact's documentation, optionally pinned to a Code version. A machine-readable marker file (`.responsible-skill-development.yaml`) is suggested for tooling that wants to detect adoption programmatically.

### Paste-ready snippet

Drop this into a skill's README, CONTRIBUTING file, or plugin docs to signal adoption:

```markdown
## Responsible Skill Development

This skill follows the [Responsible Skill Development](https://github.com/danielrosehill/Responsible-Skill-Development) code of practice:

- **Development and publication workspaces are decoupled.** Captured payloads, auth-challenge maps, and anti-bot research live in a private development workspace and are deliberately omitted from this published version.
- **Documentation is sanitised.** The skill's runtime behaviour is necessarily visible in the code, but we avoid narrating the target site's authentication posture, fingerprinting checks, or defensive surfaces in user-facing docs — the more specifically these are documented, the easier the skill is to reverse-engineer for misuse.
- **User-facing docs describe outcomes, not bypasses.** The README explains what the skill does for a legitimate user, not how it negotiates with each defensive mechanism.

If you're forking or contributing, please preserve these conventions.
```

Short form, for tight READMEs:

```markdown
> This skill follows the [Responsible Skill Development](https://github.com/danielrosehill/Responsible-Skill-Development) code of practice: development artefacts (captured payloads, auth-challenge maps, anti-bot research) are kept in a private workspace and omitted from this published version, and user-facing documentation deliberately avoids narrating the target site's authentication posture.
```

## Repository contents

- [`code-of-practice.md`](./code-of-practice.md) — the canonical text of the Code
- [`agent-readable/code-of-practice.agent.md`](./agent-readable/code-of-practice.agent.md) — agent-readable rendering for automated review
- [`snippet.md`](./snippet.md) — paste-ready snippets for skill READMEs and contributor docs
- [`commands/`](./commands/) — Claude Code slash-command definitions for redaction review
- [`notes/`](./notes/) — supporting notes and rationale
- [`drafts/blog/`](./drafts/blog/) — long-form write-up

## Further reading

- Blog post: [A voluntary code of practice for responsible AI skill development](https://huggingface.co/blog/danielrosehill/responsible-agent-skill-dev) on Hugging Face

## Status

Draft / discussion. Refinements via pull request or issue.

## License

MIT
