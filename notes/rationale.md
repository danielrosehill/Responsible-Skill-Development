# Rationale

Some scratch notes on why the conventions in `code-of-practice.md` are framed the way they are.

## Why "decouple workspaces" instead of "don't capture payloads"

Skill development genuinely benefits from capturing real payloads, real auth flows, real anti-bot challenges. Telling developers not to do this would cripple the work. The realistic ask is that the *artefacts* of that research stay in a private workspace and don't get carried into the public one by default.

This mirrors a long-standing convention in security research: the working notes and the published write-up are not the same artefact, and the former is held to a different distribution standard.

## Why "sanitise docs" instead of "obfuscate code"

Code obfuscation is a losing game against a determined reader, and it makes the skill harder for legitimate users (and the skill author themselves, six months later) to maintain. Documentation, by contrast, is genuinely optional — a skill needs working code, but it does not need a tutorial that walks a reader through the target site's defensive model. The win is in *not writing* the tutorial, not in scrambling the code.

## Why this matters more for skills than for traditional libraries

A skill is intended to be picked up and run by an autonomous agent on behalf of a user. That lowers the bar to misuse considerably compared to a traditional library, which at least requires a developer to integrate it into something. A well-documented skill that handles a site's auth flow can, in the wrong hands, be invoked at scale by an agent with very little additional engineering. The asymmetry between "effort to misuse" and "effort to build" is what makes the publication discipline matter.

## Open questions

- Where is the line between "documenting how the skill works" (legitimate, expected) and "documenting the target site's defenses" (the thing this practice argues against)? In practice, the line is judgement-based; the heuristic is *would this paragraph still make sense if the target site were anonymised?*
- How should this interact with disclosure norms when a skill author discovers an outright vulnerability (as opposed to a negotiable defensive surface) in the course of development?
- Should there be a recommended structure for the private development workspace itself — e.g., a `dev/` sibling repo convention?
