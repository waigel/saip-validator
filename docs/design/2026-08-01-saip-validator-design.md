# A business-rule validator for eUICC profile packages — design

**Status:** agreed; first increment planned in
[../plans/2026-08-01-pipeline-and-first-rules.md](../plans/2026-08-01-pipeline-and-first-rules.md)
**Date:** 2026-08-01
**Normative reference:** TCA, *eUICC Profile Package: Interoperable Format
Technical Specification* (SAIP), version 3.4.1
**Related:** [asn1c-vn](https://github.com/waigel/asn1c-vn) (value notation
codec), [euicc-profile-tool](https://github.com/waigel/euicc-profile-tool) (`ept`,
the converter)

## The gap

A profile package can be well-formed and useless. Three layers decide whether it
is worth loading onto a card, and only the first two exist today:

| Layer | What it decides | Who checks it |
| --- | --- | --- |
| Structure | Is this a valid `ProfileElement` sequence at all — right members, right types | asn1c, from the ASN.1 module |
| Subtype constraints | `SIZE`, ranges, permitted alphabets | `asn1vn -C`, added 2026-08-01 |
| **Business rules** | One header and it comes first; the ICCID in the header matches EF-ICCID; every referenced file exists | **nobody** |

The third layer is not expressible in ASN.1. It is prose in the SAIP
specification, and prose is where this project starts.

The model is KoSIT's validator for XRechnung: XSD decides the structure, a
Schematron rule set decides the content, and the rule set — not the engine — is
the product. The same split applies here, with ASN.1 in the role of XSD.

## Scope

**In:** rules a profile can be judged against on its own. Composition of the PE
sequence, and cross-references within the profile.

**Out:** anything needing a second input. Matching against a specific eUICC's
capabilities, or against an operator's HSS, is a different question with a
different answer, and mixing the two would make "green" mean less than it says.
What this tool reports is *this profile is internally consistent*, never *this
profile will work*.

Also out: an engine. Schematron processors exist.

## Shape

```
profile.der
   │  ept -iber -oxer -p ProfileElement
   ▼
30 XER documents
   │  saip-wrap
   ▼
one <ProfilePackage> document
   │  Schematron (rules/)
   ▼
SVRL  ──►  readable report
```

Dependencies run one way: this repository uses `ept`, which uses `asn1c-vn`.
Neither of them learns about this one.

### The canonical view

`ept -oxer` emits one XER document per ProfileElement — 30 of them for a TS48
test profile, concatenated, with no enclosing element. XPath needs exactly one
root, so something has to wrap them:

```xml
<ProfilePackage>
  <ProfileElement><header>…</header></ProfileElement>
  <ProfileElement><mf>…</mf></ProfileElement>
  …
</ProfilePackage>
```

This is a format decision, not plumbing. Every rule is written against this view,
so its shape is frozen once rules exist: renaming the wrapper breaks all of them.
`saip-wrap` is the smallest thing that can produce it, and it belongs in this
repository rather than in `ept`, because it exists to serve these rules.

### What the XER actually looks like

Verified against a TS48 v7.0 profile rather than assumed:

- CHOICE alternatives become elements: `<ProfileElement><header>`, `<mf>`, `<usim>`
- ASN.1 identifiers survive intact, hyphens and all: `<major-version>`,
  `<eUICC-Mandatory-services>`
- a `NULL` member is an empty element, so presence is the test: `<usim></usim>`
- **OCTET STRING is space-separated hex pairs**: `<iccid>89 00 01 23 45 67 89 01 23 41</iccid>`
- list elements are named after their *type*, with an underscore:
  `<OBJECT_IDENTIFIER>2.23.143.1.2.1</OBJECT_IDENTIFIER>`

The hex encoding is the awkward one. A length test spelled inline becomes
`string-length(translate(iccid,' ','')) = 20`, which is easy to get wrong in the
fiftieth rule that needs it. A small XSLT function library — `saip:octets(node)`,
`saip:hex(node)` — carries that, and is tested once instead of in every rule.

## A rule

```xml
<sch:rule context="/ProfilePackage">
  <sch:assert id="SAIP-HDR-01" role="error" see="saip-3.4.1#8.2"
              test="count(ProfileElement/header) = 1">
    A profile package shall contain exactly one Profile Header.
  </sch:assert>
  <sch:assert id="SAIP-HDR-02" role="error" see="saip-3.4.1#8.2"
              test="ProfileElement[1]/header">
    The Profile Header shall be the first ProfileElement.
  </sch:assert>
</sch:rule>
```

- `@id` — stable identifier. Reports cite it, tests are named after it, and it
  does not change once published.
- `@see` — the clause the rule comes from. A rule without one is an opinion, and
  this project has no use for opinions. Schematron provides the attribute; if it
  proves unsuitable, an attribute in our own namespace replaces it.
- `@role` — `error` or `warning`. SAIP says "should" in places, and those must be
  reportable without failing a build.
- The text is a sentence in English, addressed to whoever has to fix the profile.

Everything in this repository is written in English: rule text, identifiers,
documentation, commit messages.

## Reporting

Two outputs from one run. SVRL is what Schematron produces anyway — per hit the
rule id, an XPath to the offending node, and the message. That is the archive
format and what a CI job consumes. The readable form is an XSLT over that SVRL,
never a second code path, so the two cannot drift:

```
profile.der: 2 errors, 1 warning, 47 of 118 rules evaluated

  SAIP-HDR-02  error    The Profile Header shall be the first ProfileElement.
               at       /ProfilePackage/ProfileElement[1]
               see      saip-3.4.1 §8.2
```

**The rule count is part of the report, not decoration.** A rule whose context
does not occur in this profile did not pass — it did not run. Without that
number, "0 errors" reads as "everything was checked", which is exactly the
misreading this project exists to prevent.

Exit codes: `0` clean, `1` at least one error, `2` usage. Warnings alone do not
change the code, or no "should" rule could ever be added without turning every
pipeline red; `--strict` promotes them.

## Testing

A rule set nobody has tested is worth as much as no rule set.

1. **A counter-example per rule.** Each rule needs a fixture that violates it and
   trips no other. Until a rule has been seen to fire, there is no evidence it
   can; a rule that cannot fire is indistinguishable from a rule that passes.
2. **TCA's reference ProfileElements must stay clean.** The 404 files published
   with the test specification are the regression net. A rule that flags them is
   either wrong or has found something real, and either way that is worth knowing
   the moment it happens.
3. **The four TS48 profiles likewise.**

Points 2 and 3 use corpora that are not vendored here — they belong to their
publishers — so the targets are pointed at a directory, the way `asn1c-vn` takes
`DERDIR` and `VNDIR`.

## Decisions taken since

The three questions this document left open were settled while planning the
first increment, each on a fact rather than a preference:

- **Processor: `lxml.isoschematron`.** ISO Schematron, emits SVRL with the rule
  id, role and location, needs no JVM, and lxml was already installed. The rules
  stay plain `.sch`, so another processor can consume them.
- **`saip-wrap` is a shell filter,** reading XER on standard input rather than
  invoking `ept`. `ept -oxer` emits no XML declaration, so wrapping is
  concatenation; keeping it a filter makes it testable without a profile.
- **Rule ids stay opaque,** with the clause in `@see` alone. Reports, tests and
  bug trackers cite ids, and a renumbered specification must not invalidate them.

One thing above did not survive contact. `lxml.isoschematron` binds XSLT 1.0,
which has no `xsl:function`, so the `saip:octets()` library described earlier
cannot be written that way yet. `sch:let` covers per-rule locals, and two rules
do not justify reaching for EXSLT. Revisit when a computation repeats across
files, and change this document at the same time.

## Non-goals

- Validating against a particular eUICC.
- Anything about Ki/OPc, the HSS, or whether the profile authenticates.
- Protecting or binding a profile package. That is the SM-DP+'s job and needs
  keys this project will never hold.
- Replacing `asn1vn -C`. Subtype constraints are the layer below; this one
  assumes they hold.
