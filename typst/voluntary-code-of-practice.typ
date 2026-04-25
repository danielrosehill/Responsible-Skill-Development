#set document(
  title: "Voluntary Code of Practice for Responsible AI Skill Development",
  author: "Daniel Rosehill",
)

#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  numbering: "1",
  number-align: center,
)

#set text(font: "New Computer Modern", size: 11pt, lang: "en")
#set par(justify: true, leading: 0.7em)

#show heading.where(level: 1): it => [
  #set text(size: 18pt, weight: "bold")
  #v(0.4em)
  #it.body
  #v(0.3em)
]

#show heading.where(level: 2): it => [
  #set text(size: 13pt, weight: "bold")
  #v(0.6em)
  #it.body
  #v(0.2em)
]

#show heading.where(level: 3): it => [
  #set text(size: 11pt, weight: "bold", style: "italic")
  #v(0.4em)
  #it.body
]

// ---------- Cover ----------

#align(center)[
  #v(2cm)
  #text(size: 22pt, weight: "bold")[
    A Voluntary Code of Practice
  ]

  #v(0.4em)

  #text(size: 16pt)[
    for Responsible AI Skill Development
  ]

  #v(2em)

  #text(size: 11pt, style: "italic")[
    A community proposal for skill authors building agentic-AI tooling \
    that interacts with the open web.
  ]

  #v(3cm)

  #text(size: 10pt)[
    Version 0.1 (Draft) #h(1em) · #h(1em) #datetime.today().display() \
    #link("https://github.com/danielrosehill/Responsible-Skill-Development")
  ]

  #v(1fr)

  #text(size: 9pt, fill: gray)[
    This document is a voluntary, non-binding code of practice. \
    It carries no legal force and confers no certification.
  ]
]

#pagebreak()

// ---------- Preamble ----------

= Preamble

Skills are an extraordinarily powerful primitive for agentic artificial intelligence. A modest amount of well-written instruction text, paired with a general-purpose language model and access to a browser or HTTP client, can automate interactions with websites at a level of fluency that until very recently required substantial bespoke engineering.

That same capability lowers the bar to misuse. The boundary between "a skill that helps an ordinary user navigate a frustrating website" and "a skill that lets a bad actor interact with that same website at scale" is narrower than it appears. The boundary is not principally in the runtime code — which must, by its nature, be executable — but in the *knowledge* accumulated during skill development: captured payloads, observed defensive surfaces, the precise shape of a site's anti-bot posture, the conditions under which a CAPTCHA is or is not presented.

This document proposes a small set of voluntary commitments that skill authors can adopt to preserve the legitimate utility of their work without inadvertently publishing a roadmap for abuse. It is offered as a starting point for community norms, not as a regulatory framework.

= Scope

This Code applies, on a voluntary basis, to authors of:

- Skills, plugins, and agent prompts intended to be distributed to other users or to autonomous agents;
- Tooling that automates interactions with third-party websites, especially those with authentication, anti-bot measures, or rate limits;
- Documentation, fixtures, and supporting artefacts published alongside such tooling.

It does not apply to private, single-user tooling that is never distributed, although authors are free to adopt it there as well.

= Definitions

#set terms(separator: " — ", indent: 1em, hanging-indent: 1em)

/ Skill: A unit of instruction text, optionally accompanied by code, that directs an AI agent to perform a defined task. May include the ability to invoke browser automation, HTTP clients, or other tools.

/ Development workspace: A private working environment in which a skill author conducts research, captures payloads, observes site behaviour, and develops the skill. Not distributed.

/ Published workspace: The artefact intended for distribution — typically a public Git repository, a marketplace listing, or a packaged plugin. Distributed to end users and to autonomous agents.

/ Authentication posture: The ensemble of mechanisms by which a target site distinguishes legitimate users from automated, abusive, or unauthorised access. Includes credentials, tokens, cookies, headers, fingerprints, timing, CAPTCHA challenges, and rate limits.

/ Dual-use knowledge: Knowledge that is necessary to operate a skill but that, if presented in tutorial form, materially advantages bad actors as well as legitimate users.

= The Commitments

The following commitments are offered for adoption by skill authors. Authors who adopt this Code may indicate so in their published documentation by referencing it directly.

== 1. Decouple development and published workspaces

Authors maintain two distinct workspaces per skill:

- A *private development workspace* containing the unfiltered artefacts of skill development: captured payloads, full HAR files, detailed maps of authentication challenges, anti-bot fingerprints observed in the wild, internal notes on what triggered which defensive surface, and probing scripts.
- A *public / published workspace* containing only what an end user or autonomous agent needs to *run* the skill at invocation time.

The development artefacts are deliberately omitted from the published form. The skill remains executable in published form because skills, by their nature, must be — but the accumulated *knowledge* of how the target site defends itself is not the same artefact as the *code* required at runtime, and the two are kept separate.

== 2. Sanitise published documentation

Skills cannot hide what they do at runtime, and authors do not attempt to. Code obfuscation is a losing game and harms maintainability for legitimate users. The discipline applies instead to *documentation around the code*:

- *Minimise authentication-posture documentation.* Do not write tutorial-style READMEs explaining exactly which header, cookie, fingerprint, or timing window the target site checks, or precisely how the skill negotiates with each defensive mechanism.
- *Avoid documenting bypasses as bypasses.* Describe what the skill accomplishes for the user, not the defensive mechanism it sidesteps.
- *Strip development comments.* Comments that narrate site defences belong in the development workspace, not the published one.
- *Generalise overly specific names.* Function and variable names that gratuitously expose defensive internals (e.g. `solve_recaptcha_v2_audio_challenge`) are renamed to describe the *user-facing* behaviour where possible.
- *Redact captured fixtures.* Test fixtures that ship with the skill are scrubbed of anti-bot signal data not needed for the test to pass.

The principle: the more specifically authentication posture is documented, the easier it is for the skill to be reverse-engineered for misuse.

== 3. Prefer "what" over "how" in user-facing documentation

User-facing documentation describes the *outcome* the skill produces, the inputs it requires, and its limits. It is not written in the style of a security write-up of the target site's defensive model. Authors apply the heuristic: *would this paragraph still make sense if the target site were anonymised?* If not, it likely belongs in the development workspace.

== 4. Treat anti-bot research as sensitive

Notes accumulated while reverse-engineering a site's defences — fingerprint observations, rate-limit thresholds, challenge trees, timing-attack windows — are handled with the same care as any sensitive research output:

- Kept in the private development workspace;
- Not pasted into public issues or pull-request descriptions;
- Not committed to public branches, even temporarily;
- Not shared in public chat logs of agent sessions.

== 5. Default to the white-hat user

Where a design decision could be made in a way that helps a legitimate user but also lowers the bar for abuse, authors prefer the option that helps the legitimate user *only*. For example: a skill that logs in on behalf of its own user is treated as a different artefact from a skill that takes an arbitrary credential list as input. Where the use case allows, the former is preferred.

== 6. Be willing not to publish

Some skills, on reflection, should remain private to the developer or their organisation. "We built it, therefore we publish it" is not a default worth preserving when the published form materially advantages bad actors. Authors reserve the right — and accept the responsibility — to keep certain skills unpublished.

= Adoption

Authors who voluntarily adopt this Code may signal so by including a short reference in their published documentation, for example:

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 3pt,
  width: 100%,
)[
  #set text(font: "DejaVu Sans Mono", size: 9pt)
  This skill follows the Voluntary Code of Practice for Responsible AI Skill Development \
  (#link("https://github.com/danielrosehill/Responsible-Skill-Development")).
]

Adoption is non-binding and self-attested. No certification, audit, or registration is implied or offered.

= Limitations

This Code is offered with several explicit limitations:

- It is *voluntary* and carries no legal force.
- It does not constitute legal, security, or compliance advice.
- It does not address the lawfulness of any particular skill — authors remain responsible for ensuring their work complies with applicable terms of service, computer-misuse legislation, and data-protection regimes.
- It does not address vulnerability disclosure when an author discovers an outright security flaw (as opposed to a negotiable defensive surface). Authors are encouraged to follow established responsible-disclosure norms in such cases.
- It is a starting point for discussion. Refinements and amendments are welcomed via the canonical repository.

= Versioning

This document is version *0.1 (Draft)*. Future revisions will be tracked in the canonical repository. Authors who reference the Code in their published work are encouraged to pin the version they adopted.

#v(2em)
#line(length: 100%, stroke: 0.4pt + gray)
#v(0.5em)

#text(size: 9pt, fill: gray)[
  Canonical source: #link("https://github.com/danielrosehill/Responsible-Skill-Development") \
  Companion machine-readable version for AI agents: `agent-readable/code-of-practice.agent.md` in the same repository.
]
