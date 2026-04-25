# A Suggested Code of Practice for Responsible AI Skill Development

Skills designed to help ordinary users work with websites — handling logins, navigating anti-bot friction, occasionally working through CAPTCHAs — necessarily encode knowledge about how those sites defend themselves. That knowledge is dual-use. The practices below aim to preserve the legitimate utility of a skill while reducing the surface area available to bad actors who might fork, study, or reverse-engineer it.

## 1. Decouple development workspaces from published workspaces

Maintain **two** workspaces per skill:

- **Private development workspace** — may contain unfiltered captured payloads, full HAR files, detailed maps of authentication challenges, anti-bot fingerprints observed in the wild, internal notes on what triggered which defense, scratch scripts used to probe the surface, and similar artefacts. This workspace stays private.
- **Public / published workspace** — contains only what a user needs to *run* the skill. The captured payloads, the auth challenge maps, and the probing notes are deliberately **omitted**.

The skill can still function in public form because skills must, by their nature, be executable — but the **knowledge accumulated during development** is not the same as the **code required at runtime**, and the two should be separated.

## 2. Sanitise skills before publication

Skills can't hide what they do at runtime — the code is the code, and a determined reader can always study it. That's fine and unavoidable. What we *can* control is how much **gratuitous detail** we publish *around* the code.

Concretely:

- **Minimise auth-posture documentation.** Don't write a tutorial-style README explaining exactly which header, cookie, fingerprint, or timing window the target site checks, or precisely how the skill negotiates with each one. The skill needs to do these things; the README does not need to narrate them.
- **Avoid documenting bypasses as bypasses.** Describe what the skill accomplishes for the user, not the defensive mechanism it sidesteps.
- **Strip development comments.** Comments like `// the site rejects requests without X-Foo header set to <value> within 200ms of <event>` belong in the private workspace, not the published one.
- **Generalise variable and function names** where overly specific names ("`solve_recaptcha_v2_audio_challenge`") give away more than the runtime requires.
- **Redact captured fixtures.** If example payloads or fixtures ship with the skill for testing, scrub them of anti-bot signal data that isn't needed for the test to pass.

The principle: **the more specifically authentication posture is documented, the easier it is for the skill to be reverse-engineered for misuse.**

## 3. Prefer "what" over "how" in user-facing docs

User-facing documentation should describe the *outcome* the skill produces, the inputs it needs, and its limits. It does not need to read like a write-up of the target site's security model.

## 4. Treat anti-bot research as sensitive

Notes accumulated while reverse-engineering a site's defenses (fingerprint observations, rate-limit thresholds, challenge trees) should be handled with the same care as any sensitive research output: kept in the private workspace, not pasted into issues, not committed to public branches, not shared in public chat logs of agent sessions.

## 5. Default to the white-hat user

When a design decision could be made in a way that helps a legitimate user but also lowers the bar for abuse, prefer the option that helps the legitimate user *only*. For example: a skill that logs in on behalf of its own user is a different artefact from a skill that takes an arbitrary credential list as input. Prefer the former where the use case allows.

## 6. Be willing not to publish

Some skills, on reflection, should remain private to the developer or their organisation. "We built it, therefore we publish it" is not a default worth preserving when the published form materially advantages bad actors.

---

These are suggestions, not rules. They're meant as a starting point for a community norm among skill developers — refine, argue with, and adapt as the ecosystem matures.
