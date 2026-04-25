---
description: Review a skill or plugin for unnecessarily detailed authentication-posture documentation and propose redactions. Generic version — does not reference any external code of practice.
argument-hint: <path-to-skill-or-plugin-dir>
---

# Skill / Plugin Redaction Review

You are auditing a skill or plugin **for inadvertently published dual-use detail**. The target is `$ARGUMENTS` — a path to either a single skill directory (`skills/<name>/`) or a whole plugin repository.

## Goal

Identify content in the published artefact that documents the **target site's defensive posture** in more detail than the skill needs at runtime. Such content makes the skill easier to reverse-engineer for misuse without making it more useful to legitimate users. Propose redactions; do not redact silently.

## Scope of audit

Audit ALL of the following inside the target path:

- `SKILL.md`, `README.md`, and any other markdown documentation
- Code comments inside scripts, especially block comments and TODOs
- Function, file, and variable names
- Test fixtures (`fixtures/`, `data/`, `captures/`, `*.json`, `*.har`)
- Commit messages on the most recent ~20 commits (`git log --oneline -20`)
- Any `notes/`, `docs/`, `dev/`, or `research/` subdirectory that may have been published by accident

## What to flag (REJECT-class content)

Flag any of the following as candidates for redaction:

1. **Authentication-narration prose** — text explaining *which* defensive mechanism the target site uses or *how* the skill negotiates with it. Examples:
   - "The site rejects requests without `X-Foo` header set within 200ms of the page load event."
   - "reCAPTCHA v2 audio challenge is solved by routing to..."
   - "Fingerprint check looks for `navigator.webdriver === undefined`; we patch this by..."
   - "Rate limit kicks in at 12 requests/minute per IP."

2. **Bypass framing** — content framed as defeating a defence rather than achieving a user outcome.
   - REJECT: "How this skill defeats Cloudflare's bot challenge."
   - ACCEPT: "How this skill retrieves the user's order history."

3. **Development comments narrating site defences** — code comments like:
   - `// site checks for this header`
   - `// fingerprint trips if we don't set this`
   - `// only works if we wait at least 1.4s after click`

4. **Defence-exposing names** — identifiers that gratuitously expose internals.
   - REJECT: `solve_recaptcha_v2_audio_challenge()`, `bypass_cf_jschallenge()`, `evade_rate_limit()`
   - ACCEPT: `complete_verification()`, `wait_for_page_ready()`, `paced_request()`

5. **Anti-bot research artefacts in published form** — captured HAR files, fingerprint maps, challenge trees, rate-limit thresholds (as numerical values), timing-attack windows. These belong in a private development workspace, not the published repo.

6. **Test fixtures with unscrubbed defence signal** — fixtures whose payloads contain anti-bot signal data that isn't required for the test assertion.

## Heuristic for borderline cases

Ask: *would this paragraph / comment / name still make sense if the target site were anonymised to `<TargetSite>`?* If anonymising would gut the meaning, it is too defence-specific to remain in the published artefact.

## Procedure

1. **Classify the target.** Determine whether `$ARGUMENTS` is a single skill or a whole plugin. List what you'll audit.
2. **Sweep documentation.** Read every `*.md` in scope. For each finding, record: file path, line range, category (1–6 above), the offending excerpt (verbatim, short), and a one-line suggested redaction or replacement.
3. **Sweep code.** Grep for comment patterns suggestive of category 3 (e.g. `# site`, `// fingerprint`, `# bot`, `// captcha`, `# rate`, `// timing`). Read function and file names and flag category 4 hits.
4. **Sweep fixtures.** List fixture files; for each, decide whether its inclusion is RUNTIME-NECESSARY or RESEARCH-RESIDUE.
5. **Check commit history.** Look at the last 20 commit messages for accidental disclosure (e.g. "fix bypass for X's anti-bot check").
6. **Produce a report** with the following structure:

```
# Redaction Review: <target>

## Summary
- Documentation findings: <n>
- Code-comment findings: <n>
- Naming findings: <n>
- Fixture findings: <n>
- Commit-message findings: <n>

## Findings

### Category 1: Authentication-narration prose
- <file>:<lines> — <excerpt> → suggested redaction: <text or DELETE>

### Category 2: Bypass framing
- ...

### Category 3: Development comments
- ...

### Category 4: Defence-exposing names
- ...

### Category 5: Research artefacts
- ...

### Category 6: Test fixtures
- ...

## Recommended action

For each finding, one of:
- DELETE (remove entirely from published artefact)
- REWRITE (replace with user-outcome framing — proposed text inline)
- MOVE (relocate to a private development workspace; do not delete the knowledge, just unpublish it)
- KEEP (false positive on review)

## Patch plan

If the user confirms, propose the concrete file edits as a checklist. Do NOT apply edits without explicit confirmation.
```

## Important constraints

- **Do not edit files in this pass.** Produce the report only. Apply edits only after the user reviews and confirms.
- **Do not over-redact runtime-necessary content.** The skill must remain executable. If a comment or name is load-bearing (the code wouldn't work without it being explicit), flag it but recommend KEEP or REWRITE rather than DELETE.
- **Do not invent findings.** If a category has zero findings, say so explicitly — do not pad.
- **Preserve Hebrew labels, output schemas, UI quirks the user faces, and other user-side content.** These are not defensive-internals; they are user-facing documentation and stay.
