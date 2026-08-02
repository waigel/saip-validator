# saip-validator

[![ci](https://github.com/waigel/saip-validator/actions/workflows/ci.yml/badge.svg)](https://github.com/waigel/saip-validator/actions/workflows/ci.yml)

Business-rule validation for **eUICC profile packages** in the Trusted
Connectivity Alliance's *eUICC Profile Package: Interoperable Format* (SAIP).

A profile package can be well-formed and still useless. Its structure is decided
by the ASN.1 module, and its `SIZE` and range constraints by
[`asn1vn -C`](https://github.com/waigel/asn1c-vn). What neither can decide is
whether the profile makes sense: that there is exactly one header and it comes
first, that a PIN names a PUK the package actually defines, that an RFM lands
after the security domain and ADF it depends on. Those rules are prose in the
specification, and until now nothing checked them.

This is the same split KoSIT draws for XRechnung — XSD for structure, Schematron
for content — with ASN.1 in the role of XSD. As there, **the rule set is the
product**; the engine already exists.

```
profile.der ──► ept -oxer ──► saip-wrap ──► Schematron ──► SVRL ──► report
```

## Using it

### Clean profile

A published test profile passes all rules:

```sh
ept -iber -oxer -p ProfileElement profile.der | ./bin/saip-wrap > profile.xml
./bin/saip-validate rules profile.xml
```

```
profile.xml: 0 errors, 0 warnings, 54 of 71 assertions evaluated
```

### Failing profile

A profile whose header is not first:

```sh
./bin/saip-validate rules tests/fixtures/header-not-first.xml
```

```
tests/fixtures/header-not-first.xml: 1 error, 0 warnings, 11 of 71 assertions evaluated

  SAIP-HDR-02  error    The Profile Header shall be the first ProfileElement.
               at       /ProfilePackage
               see      saip-3.4.1#8.2.1
```

`--svrl FILE` writes the raw SVRL alongside, which is the format to archive and
to feed a CI job. `--strict` makes warnings fail too. Exit codes: `0` clean, `1`
an error, `2` usage.

**The rule count is not decoration.** A rule whose context does not occur in a
profile did not pass — it did not run. Without that number, "0 errors" reads as
"everything was checked".

## Writing a rule

Every assertion carries three attributes, and the tool refuses a rule set that
omits any of them rather than half-checking it:

```xml
<sch:assert id="SAIP-HDR-01" role="error" see="saip-3.4.1#8.2.1"
            test="count(ProfileElement/header) = 1">
  A profile package shall contain exactly one Profile Header.
</sch:assert>
```

- `@id` is stable and opaque. Reports cite it and tests are named after it, so
  renumbering the specification must not invalidate it.
- `@see` is the clause the rule comes from. A rule without one is an opinion,
  and this project has no use for opinions.
- `@role` is `error` or `warning`. The specification says "should" in places.

A new rule also needs a fixture in `tests/fixtures/` that makes it fire, and its
id added to the expected set for that fixture. `tests/run-tests` fails if any
declared id is never tripped by any fixture — a rule never seen to fire is
indistinguishable from one that cannot.

## Testing

```sh
./tests/run-tests                      # the rules, against their counter-examples
EPT=<path-to-ept> ./tests/run-corpus <dir-with-*.der>    # published profiles must stay clean
```

Every rule ships with a fixture that makes it fire, because a rule never seen to
fire is indistinguishable from one that cannot. `run-corpus` is the other half:
the rule set must leave valid profiles alone, and the only honest evidence for
that is profiles somebody else published. The `EPT` variable names the converter
(`ept`), which is not assumed to be on the PATH.

## Status

74 rules across fourteen files, each citing the clause it comes from:

| File | Covers | Clauses |
| --- | --- | --- |
| `composition.sch` | one header first, one end last, unique PE identifications, Full versus IoT Minimal | 7.4, 7.5, 8.1.3, 8.2.1, 8.10 |
| `ordering.sch` | PE dependencies, and cardinality where it is package-level | 8.1, 8.3.4 |
| `templates.sch` | templateID against the assigned OIDs | Annex B |
| `template-parameters.sch` | parameters a referenced template obliges the profile to supply | 9.1 |
| `pin-puk.sch` | PIN and PUK key references, including the PUK a PIN names | 8.5.1, 8.5.2 |
| `pin-scope.sch` | one PIN context per PE, and the IoT header ICCID's padding | 8.2.1, 8.5.1 |
| `contexts.sch` | dependencies on the file system root, and which PIN context admits which reference | 8.1, 8.5.1 |
| `fcp-context.sch` | parameters an FCP may not carry in its context | 8.3.3 |
| `fcp-mandatory.sch` | parameters an FCP must carry, in a Full Profile | 8.3.3 |
| `generic-file-management.sch` | minimum parameters for file creation without a template | 8.3.5 |
| `security-domains.sch` | SD ordering, key uniqueness, MNO-SD-only parameters | 8.6.2, 8.6.3, 8.6.6, 8.6.7 |
| `applications.sch` | extradition: the MNO-SD is not extradited, targets are PERSONALIZED | 8.7.3 |
| `rfm.sch` | an RFM instance reachable over a TAR-based protocol, placed after an ADF | 8.8 |
| `naa-parameters.sch` | NAA parameter PEs and PE-EAP placed after the NAA they configure | 8.4.1, 8.3.4.7 |

**What is not covered.** Every normative table in Annex A has now been
transcribed, and clause 8's subsections have all been read. What remains
unchecked is unchecked for a stated reason rather than for want of reading.

Clause 8.9, non-standard content, carries no checkable requirement: it is by
definition proprietary. Clause 8.11 defines `PEStatus` and `EUICCResponse`,
which are what the eUICC sends *back* after installation; nothing there is an
obligation on a profile package, so it yields no rules.

Two gaps come from documents this project does not have. Classifying a file as
ADF, DF, EF or link would be exact if byte 1 of the `fileDescriptor` were
decoded per ETSI TS 102 222, which is referenced but not in hand; the rules in
`generic-file-management.sch` instead use the discriminators SAIP states
outright, which leaves `shortEFID` on a link unchecked because a DF Link forbids
it while an EF Link permits it. For the same reason `linkPath` targets are not
resolved.

Deciding *which* kind of PIN reference a given PE-PINCodes ought to hold is
caught only where the containing context makes it decidable; a package that uses
one consistent kind throughout passes regardless of whether that kind is right
for it.

Three further rules were deliberately rejected after reading the clause they
would have cited; see "Rules considered and rejected" in the design document.
The ICCID in the header is not compared against EF-ICCID because 8.2.1 says that
value "is not checked" and "is not used"; Annex A's file lists are not required
of a profile because 9.1 says only *differences* from the template need be
included; and PE-RFM cannot be tied to *its own* ADF because that ADF's AID is
supplied by the template and never appears in the package. SAIP-RFM-02 checks
the weaker half that is decidable, that some ADF precedes.

## Scope

Rules a profile can be judged against **on its own** — the composition of the
ProfileElement sequence, and cross-references within the profile.

Not in scope: anything needing a second input. Whether a given eUICC can host the
profile, and whether its keys match an operator's HSS, are different questions,
and answering them here would make a green result mean less than it says. What
this reports is *this profile is internally consistent*, never *this profile will
work*.

## Related

- [asn1c-vn](https://github.com/waigel/asn1c-vn) — ASN.1 value notation codec,
  and the subtype-constraint check one layer below this one
- [euicc-profile-tool](https://github.com/waigel/euicc-profile-tool) — `ept`,
  which produces the XER this reads

Dependencies run one way: this repository uses those two, neither uses this one.

## Licence

BSD 2-Clause. See [LICENSE](LICENSE).
