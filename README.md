# saip-validator

[![ci](https://github.com/waigel/saip-validator/actions/workflows/ci.yml/badge.svg)](https://github.com/waigel/saip-validator/actions/workflows/ci.yml)

Business-rule validation for **eUICC profile packages** in the Trusted
Connectivity Alliance's *eUICC Profile Package: Interoperable Format* (SAIP).

A profile package can be well-formed and still useless. Its structure is decided
by the ASN.1 module, and its `SIZE` and range constraints by
[`asn1vn -C`](https://github.com/waigel/asn1c-vn). What neither can decide is
whether the profile makes sense: that there is exactly one header and it comes
first, that the ICCID in the header matches the one in EF-ICCID, that every file
a record points at exists. Those rules are prose in the specification, and until
now nothing checked them.

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
profile.xml: 0 errors, 0 warnings, 2 of 2 assertions evaluated
```

### Failing profile

A profile whose header is not first:

```sh
./bin/saip-validate rules tests/fixtures/header-not-first.xml
```

```
tests/fixtures/header-not-first.xml: 1 error, 0 warnings, 2 of 2 assertions evaluated

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

Two composition rules. The pipeline and the test harness are in place, so
further rules are additions to `rules/` plus their counter-examples.

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
