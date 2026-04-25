# Snippet

A short, paste-ready block for skill READMEs, CONTRIBUTING files, or plugin docs. Drop it in to signal that the project follows ethical skill-development conventions.

---

## Markdown snippet

```markdown
## Ethical Skill Development

This skill follows the [Ethical Skill Development](https://github.com/danielrosehill/Ethical-Skill-Development) code of practice:

- **Development and publication workspaces are decoupled.** Captured payloads, auth-challenge maps, and anti-bot research live in a private development workspace and are deliberately omitted from this published version.
- **Documentation is sanitised.** The skill's runtime behaviour is necessarily visible in the code, but we avoid narrating the target site's authentication posture, fingerprinting checks, or defensive surfaces in user-facing docs — the more specifically these are documented, the easier the skill is to reverse-engineer for misuse.
- **User-facing docs describe outcomes, not bypasses.** The README explains what the skill does for a legitimate user, not how it negotiates with each defensive mechanism.

If you're forking or contributing, please preserve these conventions. See the [code of practice](https://github.com/danielrosehill/Ethical-Skill-Development/blob/main/code-of-practice.md) for the full list.
```

## Short form (for tight READMEs)

```markdown
> This skill follows the [Ethical Skill Development](https://github.com/danielrosehill/Ethical-Skill-Development) code of practice: development artefacts (captured payloads, auth-challenge maps, anti-bot research) are kept in a private workspace and omitted from this published version, and user-facing documentation deliberately avoids narrating the target site's authentication posture.
```
