# Responsible Skill Development

A small collection of notes and a paste-ready snippet proposing a **Code of Practice for Responsible AI Skill Development** — aimed at developers building Claude / agentic-AI skills that interact with the open web.

## Why this exists

Skills are extraordinarily powerful primitives for agentic AI. In the course of building skills that help ordinary, white-hat internet users automate routine interactions with websites — logging in, navigating multi-step flows, dealing with anti-bot measures, occasionally solving CAPTCHAs — skill developers inevitably accumulate detailed knowledge about a site's authentication posture, fragile selectors, and bypasses for friction surfaces.

The same knowledge that makes a skill useful to a legitimate user makes it useful to a bad actor.

This repo proposes lightweight conventions that let skill authors keep building useful tooling **without inadvertently publishing a roadmap for abuse**.

## Contents

- [`code-of-practice.md`](./code-of-practice.md) — the proposed best-practice list
- [`snippet.md`](./snippet.md) — a short, paste-ready snippet for skill READMEs / contributor docs
- [`notes/`](./notes/) — supporting notes and rationale

## Status

Draft / discussion. Suggestions and PRs welcome.

## License

MIT
