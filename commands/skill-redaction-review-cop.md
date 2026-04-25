---
description: Review a skill or plugin for unnecessarily detailed authentication-posture documentation and propose redactions, in line with the Voluntary Code of Practice for Responsible AI Skill Development.
argument-hint: <path-to-skill-or-plugin-dir>
---

# Skill / Plugin Redaction Review (Code-of-Practice aligned)

You are auditing a skill or plugin against the **[Voluntary Code of Practice for Responsible AI Skill Development](https://github.com/danielrosehill/Responsible-Skill-Development)** (the "Code"). The target is `$ARGUMENTS` — a path to either a single skill directory or a whole plugin repository.

The agent-readable rendering of the Code, with explicit RULE numbering and the operational checklist, is the authoritative reference for this review:

> https://github.com/danielrosehill/Responsible-Skill-Development/blob/main/agent-readable/code-of-practice.agent.md

If the audited repo has a local copy of that file, prefer the local copy.

## Goal

Identify content in the published artefact that violates the Code's commitments — particularly **RULE-2 (DOC-SANITISATION)**, **RULE-3 (WHAT-OVER-HOW)**, **RULE-4 (ANTI-BOT-RESEARCH-IS-SENSITIVE)**, and **RULE-1 (WORKSPACE-DECOUPLING)** where research residue has leaked into the published workspace. Map every finding back to the specific rule it implicates.

## Scope of audit

Audit ALL of the following inside the target path:

- `SKILL.md`, `README.md`, and any other markdown documentation
- Code comments inside scripts, especially block comments and TODOs
- Function, file, and variable names (RULE-2 FILTER-NAMING)
- Test fixtures (`fixtures/`, `data/`, `captures/`, `*.json`, `*.har`) (RULE-2 FILTER-FIXTURES)
- Commit messages on the most recent ~20 commits (`git log --oneline -20`)
- Any `notes/`, `docs/`, `dev/`, or `research/` subdirectory — research-residue belongs in DEV-WORKSPACE per RULE-1, not the published artefact

## Categories — mapped to the Code

The Code's RULE-2 enumerates five filters. Use them as the finding taxonomy:

1. **FILTER-AUTH-NARRATION (RULE-2.1)** — prose explaining *which* defensive mechanism the target site uses or *how* the skill negotiates with it.
2. **FILTER-BYPASS-FRAMING (RULE-2.2)** — content framed as defeating a defence rather than achieving a user outcome.
3. **FILTER-DEV-COMMENTS (RULE-2.3)** — code comments narrating site defences rather than what the code does.
4. **FILTER-NAMING (RULE-2.4)** — identifiers that gratuitously expose defensive internals.
5. **FILTER-FIXTURES (RULE-2.5)** — test fixtures with unscrubbed anti-bot signal data not required for the assertion.

In addition, flag:

6. **RULE-4 violations** — anti-bot research artefacts (HAR files, fingerprint maps, challenge trees, rate-limit threshold values, timing-attack windows) that should be in DEV-WORKSPACE.
7. **RULE-1 violations** — research-residue subdirectories (`notes/`, `dev/`, `research/`) that appear to have been published when they should have stayed private.
8. **RULE-3 violations** — documentation written in the style of a security write-up of the target site rather than a description of user outcomes.

## Heuristic (from the Code)

> *Would this paragraph / comment / name still make sense if the target site were anonymised to `<TargetSite>`?* If anonymising would gut the meaning, the content is too defence-specific for the published workspace.

## Procedure

1. **Classify the target.** Determine whether `$ARGUMENTS` is a single skill or a whole plugin. State which SCOPE-TRIGGERS from the Code apply (TRIGGER-1..5) and confirm the Code is in scope. If none apply, report that and stop.
2. **Run RULE-2 filters in order** — sweep documentation, code comments, names, and fixtures. Record each finding with: file path, line range, rule citation, verbatim excerpt (kept short), and proposed remediation.
3. **Check RULE-1 leakage** — list any `notes/`, `dev/`, `research/`, or similarly-named subdirectory in the published target. For each, classify contents as RUNTIME-NECESSARY or RESEARCH-RESIDUE.
4. **Check RULE-4 sensitivity** — list any captured HAR/fingerprint/challenge-tree/threshold artefacts in the published target.
5. **Run the Code's operational checklist** (CHECK-1..9 from the agent-readable Code) against the target. Mark each pass/fail.
6. **Produce a report** in this structure:

```
# Redaction Review: <target>
# Code: Voluntary Code of Practice for Responsible AI Skill Development v0.1

## Scope
- SCOPE-TRIGGERS in effect: <list>
- Audited paths: <list>

## Operational checklist (CHECK-1..9)
- [ ] CHECK-1 ... — pass | fail (<short reason if fail>)
- [ ] CHECK-2 ... — ...
- ...

## Findings by rule

### RULE-2.1 FILTER-AUTH-NARRATION
- <file>:<lines> — "<excerpt>" → REWRITE / DELETE / MOVE — <suggested replacement or rationale>

### RULE-2.2 FILTER-BYPASS-FRAMING
- ...

### RULE-2.3 FILTER-DEV-COMMENTS
- ...

### RULE-2.4 FILTER-NAMING
- ...

### RULE-2.5 FILTER-FIXTURES
- ...

### RULE-4 ANTI-BOT-RESEARCH-IS-SENSITIVE
- ...

### RULE-1 WORKSPACE-DECOUPLING (research-residue leakage)
- ...

### RULE-3 WHAT-OVER-HOW
- ...

## Adoption signal
- Is the target signalling adoption of the Code (`.responsible-skill-development.yaml` at root, or README reference)? <yes/no>
- If yes, version pinned: <value>
- If no and findings are clean, recommend adopting the Code and adding the marker.

## Patch plan
If the user confirms, propose concrete file edits as a checklist. Do NOT apply edits without explicit confirmation.
```

## Important constraints

- **Do not edit files in this pass.** Produce the report only. Apply edits only after the user reviews and confirms.
- **Cite the rule for every finding.** This is the value-add of the Code-aligned variant — every redaction recommendation must be traceable to a specific rule.
- **Do not over-redact runtime-necessary content.** The Code explicitly allows that skills must remain executable; runtime-necessary code and identifiers stay. Comments and prose narrating defences go.
- **Preserve user-facing content** (Hebrew labels, output schemas, UI quirks the user encounters). These are user-side, not defensive-internals.
- **If a finding is genuinely borderline**, surface it under a `## Borderline` section and let the user decide rather than redacting unilaterally.
