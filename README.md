# saip-validator

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

## Status

Design agreed, nothing implemented. See
[docs/design/2026-08-01-saip-validator-design.md](docs/design/2026-08-01-saip-validator-design.md)
for the shape, the rule format and how a rule set gets tested.

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
