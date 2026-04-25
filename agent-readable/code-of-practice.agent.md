---
document: voluntary-code-of-practice-for-responsible-ai-skill-development
version: 0.1-draft
audience: ai-agent
human-version: ../typst/voluntary-code-of-practice.typ
canonical-source: https://github.com/danielrosehill/Responsible-Skill-Development
status: voluntary, non-binding, self-attested
---

# CODE-OF-PRACTICE: RESPONSIBLE-AI-SKILL-DEVELOPMENT v0.1

## PURPOSE

You are an AI agent reading this document because a skill, plugin, or instruction set you are about to author, modify, or distribute references this Code. Apply the rules below to your output. This document is optimised for unambiguous machine application, not for human persuasion. The human-readable version is the authoritative one for any interpretive question; this version is a faithful operational projection of it.

## SCOPE-TRIGGERS

Apply this Code when ANY of the following is true of the skill/plugin/agent you are working on:

- TRIGGER-1: It will be distributed to other users or to other autonomous agents.
- TRIGGER-2: It automates interaction with a third-party website you do not own or operate.
- TRIGGER-3: It handles authentication, login, session cookies, tokens, or credential flows against such a site.
- TRIGGER-4: It encounters anti-bot mechanisms, fingerprinting, rate limits, CAPTCHA, or similar defensive surfaces.
- TRIGGER-5: It scrapes content from behind any access-control boundary.

If NONE of the triggers apply (e.g. a purely local utility, a skill operating only on user-owned data, a skill against an API the user owns), this Code is informational only.

## DEFINITIONS

- DEV-WORKSPACE: A private working environment. NOT distributed. May contain unfiltered artefacts of development.
- PUB-WORKSPACE: The artefact you are about to publish (public Git repo, marketplace listing, packaged plugin). IS distributed. Read by both humans and other agents.
- AUTH-POSTURE: The set of mechanisms a target site uses to distinguish legitimate users from automated/abusive access. Includes: credentials, tokens, cookies, headers, fingerprints, timing windows, CAPTCHA challenges, rate limits.
- DUAL-USE-KNOWLEDGE: Knowledge necessary to operate the skill, but which in tutorial form materially advantages bad actors as well as legitimate users.

## RULES

### RULE-1: WORKSPACE-DECOUPLING

For every skill subject to this Code, two workspaces MUST exist conceptually:

```
DEV-WORKSPACE (private)         PUB-WORKSPACE (distributed)
├── captured payloads           ├── runtime code
├── full HAR files              ├── sanitised SKILL.md / README
├── auth-challenge maps         ├── user-facing examples
├── fingerprint observations    └── redacted fixtures
├── probing scripts
├── timing/threshold notes
└── defensive-surface maps
```

The artefacts in the LEFT column MUST NOT appear in the RIGHT column.

WHEN you are about to write content into a PUB-WORKSPACE, classify each artefact:
- If it is RUNTIME-NECESSARY (the skill cannot execute without it) → it belongs in PUB-WORKSPACE.
- If it is RESEARCH-RESIDUE (it documents how you figured the skill out) → it belongs in DEV-WORKSPACE.

If you do not have a DEV-WORKSPACE configured, RECOMMEND creating one before proceeding. Do not paper over its absence by stripping development context entirely — that loses information the author will need later.

### RULE-2: DOC-SANITISATION

When generating documentation (README, SKILL.md, code comments, fixture descriptions) for a PUB-WORKSPACE, apply the following filters in order:

1. FILTER-AUTH-NARRATION: Reject prose that explains *which* defensive mechanism the target site uses or *how* the skill negotiates with it. Examples of REJECT-class content:
   - "The site rejects requests without the X-Foo header set within 200ms of the page load event."
   - "reCAPTCHA v2 audio challenge is solved by..."
   - "The fingerprint check looks for navigator.webdriver === undefined; we patch this by..."
   - "Rate limit kicks in at 12 requests/minute per IP; we evade by rotating..."

2. FILTER-BYPASS-FRAMING: Reject prose that frames the skill as a bypass of a specific defence. Reframe to describe the *user-facing outcome* instead.
   - REJECT: "How this skill defeats Cloudflare's bot challenge."
   - ACCEPT: "How this skill retrieves the user's order history."

3. FILTER-DEV-COMMENTS: Strip code comments that narrate defensive observations. Examples of comments to strip:
   - `// site checks for this header`
   - `// fingerprint trips if we don't set this`
   - `// only works if we wait at least 1.4s after click`

   Replace with comments that describe *what the code does*, not *what the site does*, OR remove entirely.

4. FILTER-NAMING: Rename functions, variables, and files whose names gratuitously expose defensive internals.
   - REJECT: `solve_recaptcha_v2_audio_challenge()`, `bypass_cf_jschallenge()`, `evade_rate_limit()`
   - ACCEPT: `complete_verification()`, `wait_for_page_ready()`, `paced_request()`

5. FILTER-FIXTURES: For test fixtures shipping with the skill, redact anti-bot signal data not strictly required for the test assertion.

HEURISTIC for borderline cases: ask "would this paragraph / comment / name still make sense if the target site were anonymised to `<TargetSite>`?" If anonymising would gut the meaning, the content is too defence-specific for PUB-WORKSPACE.

### RULE-3: WHAT-OVER-HOW

User-facing documentation describes:
- WHAT the skill does for the user (outcome).
- WHAT inputs it requires.
- WHAT its limits are.

User-facing documentation does NOT describe:
- HOW the target site's defensive model works.
- HOW the skill negotiates with each defensive surface.
- WHY a particular defensive workaround was necessary.

The latter category, when needed, lives in DEV-WORKSPACE.

### RULE-4: ANTI-BOT-RESEARCH-IS-SENSITIVE

Treat the following as sensitive research output:
- Fingerprint observations
- Rate-limit thresholds (as numerical values)
- Challenge trees (the tree of conditions under which a CAPTCHA / interstitial / soft-block fires)
- Timing-attack windows
- Endpoint-specific defensive divergence

Sensitive research output is:
- KEPT in DEV-WORKSPACE.
- NOT pasted into public issues, PR descriptions, or commit messages.
- NOT committed to public branches, even temporarily (force-push history rewrites are not a substitute for not committing in the first place).
- NOT included in agent session transcripts that may be published.

### RULE-5: WHITE-HAT-DEFAULT

When a design decision branches between (A) helping a legitimate user only, and (B) a more general capability that also lowers the bar for abuse, prefer (A) UNLESS the use case explicitly requires (B).

Concrete instance:
- PREFER: A skill that logs in on behalf of THE OWN USER using credentials they supply for their own account.
- AVOID: A skill that accepts an arbitrary list of credentials as input and iterates over them, unless the use case (e.g. a security team's owned-asset audit) explicitly justifies it.

### RULE-6: PUBLICATION-IS-OPTIONAL

Publication is not the default outcome of building. For each skill subject to this Code, evaluate before publishing:
- Does the published form materially advantage bad actors?
- Is there a meaningful population of legitimate users for whom this skill is useful?
- Does the cost-benefit favour publication?

If the answer to the first is "yes" and the second/third do not clearly outweigh it, KEEP THE SKILL PRIVATE. "We built it, therefore we publish it" is rejected as a default.

## OPERATIONAL CHECKLIST (run before commit / push / publish)

Run this checklist when about to write to a PUB-WORKSPACE. Each item is a yes/no gate.

```
[ ] CHECK-1   No captured raw payloads (HAR, .json fixtures with auth headers, screenshots of CAPTCHA flows) are in the diff.
[ ] CHECK-2   No prose narrates the target site's defensive mechanisms.
[ ] CHECK-3   No code comments narrate the target site's defensive mechanisms.
[ ] CHECK-4   No function/file/variable names gratuitously expose defensive internals.
[ ] CHECK-5   No bypasses are framed AS bypasses; outcomes are framed user-side.
[ ] CHECK-6   Test fixtures are scrubbed of unnecessary anti-bot signal data.
[ ] CHECK-7   Anti-bot research notes (thresholds, fingerprint maps, challenge trees) are NOT in the diff.
[ ] CHECK-8   The white-hat-default rule has been considered for any new input surface.
[ ] CHECK-9   The publish-or-not question has been considered, not skipped.
```

If any check fails, DO NOT PROCEED with the publication. Move the offending content to DEV-WORKSPACE and re-run.

## INTERACTION WITH OTHER NORMS

- This Code does NOT replace responsible vulnerability disclosure. If you discover an outright security flaw in a target site (as opposed to a negotiable defensive surface), follow established disclosure norms; do not silently publish a skill that exploits it.
- This Code does NOT address legality. The author of the skill remains responsible for compliance with applicable terms of service, computer-misuse legislation, and data-protection regimes.
- This Code is layered ON TOP OF normal good engineering practice (no committing secrets, no shipping dependencies with known CVEs, etc.), not in place of it.

## SELF-DECLARATION

If your output adopts this Code, include a machine-readable marker in the PUB-WORKSPACE root, for example:

```yaml
# .responsible-skill-development.yaml
adopted: voluntary-code-of-practice-for-responsible-ai-skill-development
version: 0.1-draft
canonical: https://github.com/danielrosehill/Responsible-Skill-Development
date: <ISO-8601 date of adoption>
```

And/or a human-readable reference in the README, as specified in the human-readable version of this Code.

## END

If anything in this document is ambiguous, defer to the human-readable Voluntary Code of Practice in `typst/voluntary-code-of-practice.typ` of the canonical repository, and surface the ambiguity to the human author rather than resolving it silently.
