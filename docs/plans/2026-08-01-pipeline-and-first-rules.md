# Pipeline and first rules — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn a profile package into one XML document, run an ISO Schematron
rule set over it, and report the result — with two real rules that are shown to
fire and a corpus that proves they do not fire on valid profiles.

**Architecture:** `ept -oxer` already emits one XER document per ProfileElement.
`saip-wrap` reads those on standard input and wraps them into a single
`<ProfilePackage>`, which is the view every rule is written against.
`saip-validate` runs the `.sch` files over that document with
`lxml.isoschematron`, and turns the SVRL into a readable report. The rules are
plain ISO Schematron, so another processor can consume them.

**Tech stack:** POSIX shell, Python 3 with lxml (6.1.1 present), ISO Schematron.

## Global constraints

- Everything written for a reader is **English**: rule text, identifiers,
  documentation, commit messages, test names.
- Rule ids are **opaque** — `SAIP-HDR-01`, not `SAIP-8.2-01`. The clause lives in
  `@see` alone, because a specification renumbering must not invalidate ids.
- Every rule carries `@id`, `@role` (`error` or `warning`) and `@see`. A rule
  without `@see` is an opinion; reject it in review.
- Every rule ships with a fixture that makes it fire. A rule never seen to fire
  is indistinguishable from one that cannot.
- No corpus is vendored. TCA's ProfileElements and the TS48 profiles belong to
  their publishers; targets are pointed at a directory.
- Python 3.9 or later, standard library plus lxml. No other dependency.

## Facts this plan relies on

Measured, not assumed — re-check if the toolchain changes:

- `ept -iber -oxer -p ProfileElement <profile.der>` emits **no `<?xml?>`
  declaration**, so wrapping is concatenation. A TS48 profile yields 30 root
  elements.
- OCTET STRING appears as space-separated hex pairs:
  `<iccid>89 00 01 23 45 67 89 01 23 41</iccid>`.
- A `NULL` member is an empty element: `<usim></usim>`.
- SVRL from `lxml.isoschematron` carries `svrl:fired-rule`, `svrl:failed-assert`
  with `@id`, `@role`, `@location`, and a `svrl:text` child.
- `@location` is the **rule context**, not the failing child. Write the rule
  context at the node being judged so the location is useful.

## File structure

| File | Responsibility |
| --- | --- |
| `bin/saip-wrap` | XER on stdin → one `<ProfilePackage>` document on stdout. Nothing else. |
| `bin/saip-validate` | Run a rule directory over a wrapped document; emit SVRL and a readable report; set the exit code. |
| `rules/composition.sch` | Rules about the shape of the PE sequence. |
| `tests/run-tests` | Test driver: every fixture, every expectation. |
| `tests/fixtures/*.xml` | Wrapped documents, one per case, each named for the rule it must trip. |
| `tests/expected/*.txt` | The rule ids a fixture must produce, one per line. |

`saip-wrap` deliberately does not invoke `ept`: keeping it a filter makes it
testable without a profile and composable with anything that produces XER.

---

### Task 1: saip-wrap

**Files:**
- Create: `bin/saip-wrap`
- Create: `tests/run-tests`
- Create: `tests/fixtures/two-elements.xer`

**Interfaces:**
- Consumes: nothing.
- Produces: `bin/saip-wrap`, a filter — XER concatenation on stdin, a single
  `<ProfilePackage>` document on stdout. Exit 0 on success, 2 on empty input.

- [ ] **Step 1: Write the failing test**

Create `tests/fixtures/two-elements.xer`:

```xml
<ProfileElement>
    <header>
        <iccid>89 00 01 23 45 67 89 01 23 41</iccid>
    </header>
</ProfileElement>
<ProfileElement>
    <mf></mf>
</ProfileElement>
```

Create `tests/run-tests`:

```sh
#!/bin/sh
# Test driver. Every check prints one line; a failure sets the exit code.
set -u
here=$(dirname "$0")
root=$(cd "$here/.." && pwd)
fail=0

check() {
    name=$1; expected=$2; actual=$3
    if [ "$expected" = "$actual" ]; then
        echo "ok   $name"
    else
        echo "FAIL $name"
        echo "     expected: $expected"
        echo "     actual:   $actual"
        fail=1
    fi
}

# --- saip-wrap ---------------------------------------------------------------

wrapped=$("$root/bin/saip-wrap" < "$root/tests/fixtures/two-elements.xer")

check "wrap: one root element" 1 \
    "$(printf '%s' "$wrapped" | grep -c '<ProfilePackage>')"
check "wrap: both elements kept" 2 \
    "$(printf '%s' "$wrapped" | grep -c '<ProfileElement>')"
check "wrap: closes the root" 1 \
    "$(printf '%s' "$wrapped" | grep -c '</ProfilePackage>')"
check "wrap: output is well-formed" 0 \
    "$(printf '%s' "$wrapped" | python3 -c 'import sys,xml.dom.minidom as m; m.parseString(sys.stdin.read())' >/dev/null 2>&1; echo $?)"

printf '' | "$root/bin/saip-wrap" >/dev/null 2>&1
check "wrap: empty input is an error" 2 "$?"

exit $fail
```

```bash
chmod +x tests/run-tests
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `./tests/run-tests`
Expected: FAIL, because `bin/saip-wrap` does not exist yet.

- [ ] **Step 3: Write the minimal implementation**

Create `bin/saip-wrap`:

```sh
#!/bin/sh
# XER on stdin, one XML document on stdout.
#
# `ept -oxer` emits one XER document per ProfileElement with no enclosing
# element and no XML declaration, so a profile package arrives here as a
# concatenation. XPath needs exactly one root, so this supplies it.
#
# The element name is part of the interface: every rule is written against
# /ProfilePackage, and renaming it breaks all of them.
set -eu

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
cat > "$tmp"

if [ ! -s "$tmp" ]; then
    echo "saip-wrap: no input on stdin" >&2
    exit 2
fi

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<ProfilePackage>'
cat "$tmp"
echo '</ProfilePackage>'
```

```bash
chmod +x bin/saip-wrap
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `./tests/run-tests`
Expected: five `ok` lines, exit 0.

- [ ] **Step 5: Commit**

```bash
git add bin/saip-wrap tests/run-tests tests/fixtures/two-elements.xer
git commit -m "feat: saip-wrap, the canonical single-document view"
```

---

### Task 2: saip-validate

**Files:**
- Create: `bin/saip-validate`
- Create: `tests/fixtures/minimal-rules.sch`
- Create: `tests/fixtures/trips-one-rule.xml`
- Modify: `tests/run-tests` — append the section shown below

**Interfaces:**
- Consumes: the `<ProfilePackage>` document Task 1 produces.
- Produces: `bin/saip-validate [--strict] [--svrl FILE] <rules-dir> <document.xml>`.
  Writes a readable report to stdout, optionally the raw SVRL to `--svrl`.
  Exit 0 clean, 1 at least one error (with `--strict`, also on a warning),
  2 usage or input error.

- [ ] **Step 1: Write the failing test**

Create `tests/fixtures/minimal-rules.sch`:

```xml
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
  <sch:pattern id="test-only">
    <sch:rule context="/ProfilePackage">
      <sch:assert id="TEST-ERR-01" role="error" see="none#0"
                  test="false()">This assertion always fails.</sch:assert>
      <sch:assert id="TEST-WARN-01" role="warning" see="none#0"
                  test="false()">This warning always fires.</sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/NeverPresent">
      <sch:assert id="TEST-NEVER-01" role="error" see="none#0"
                  test="false()">This rule never runs.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
```

Create `tests/fixtures/trips-one-rule.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ProfilePackage><ProfileElement><mf></mf></ProfileElement></ProfilePackage>
```

Append to `tests/run-tests`, before the final `exit $fail`:

```sh
# --- saip-validate -----------------------------------------------------------

out=$("$root/bin/saip-validate" "$root/tests/fixtures" \
      "$root/tests/fixtures/trips-one-rule.xml" 2>&1)
rc=$?

check "validate: exit 1 when an error fires" 1 "$rc"
check "validate: names the failing rule" 1 "$(printf '%s' "$out" | grep -c 'TEST-ERR-01')"
check "validate: names the warning" 1 "$(printf '%s' "$out" | grep -c 'TEST-WARN-01')"
check "validate: counts one error" 1 \
    "$(printf '%s' "$out" | grep -c '1 error, 1 warning')"
check "validate: reports rules evaluated, not total" 1 \
    "$(printf '%s' "$out" | grep -c '2 of 3 rules evaluated')"
check "validate: says nothing about the rule that did not run" 0 \
    "$(printf '%s' "$out" | grep -c 'TEST-NEVER-01')"

"$root/bin/saip-validate" --svrl /dev/null "$root/tests/fixtures" \
    "$root/tests/fixtures/trips-one-rule.xml" >/dev/null 2>&1
check "validate: --svrl is accepted" 1 "$?"

"$root/bin/saip-validate" "$root/tests/fixtures" /nonexistent.xml >/dev/null 2>&1
check "validate: missing input is a usage error" 2 "$?"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `./tests/run-tests`
Expected: the `saip-validate` checks fail; `bin/saip-validate` does not exist.

- [ ] **Step 3: Write the minimal implementation**

Create `bin/saip-validate`:

```python
#!/usr/bin/env python3
"""Run an ISO Schematron rule set over a wrapped profile package.

The rules are plain Schematron, so any ISO Schematron processor can consume
them; lxml's is used here because it needs no JVM and is already a dependency
of nothing else.

Two outputs from one run: the SVRL the processor produces, which is the archive
format, and a readable summary derived from that same SVRL rather than from a
second pass -- so the two cannot drift apart.
"""
import sys
from pathlib import Path

from lxml import etree, isoschematron

SVRL = "{http://purl.oclc.org/dsdl/svrl}"
SCH = "{http://purl.oclc.org/dsdl/schematron}"


def usage(prog):
    print(
        f"usage: {prog} [--strict] [--svrl FILE] <rules-dir> <document.xml>\n"
        "\n"
        "  --strict     treat warnings as errors\n"
        "  --svrl FILE  also write the raw SVRL there\n",
        file=sys.stderr,
    )
    return 2


def load_rules(rules_dir):
    """Every .sch in the directory, merged into one schema.

    Merging keeps rule ids in one namespace, which is what the report cites,
    and lets the rules be split into files by subject rather than by run.
    """
    files = sorted(Path(rules_dir).glob("*.sch"))
    if not files:
        raise FileNotFoundError(f"no .sch files in {rules_dir}")

    merged = etree.Element(f"{SCH}schema", queryBinding="xslt")
    for f in files:
        for child in etree.parse(str(f)).getroot():
            merged.append(child)
    return merged


def assert_index(schema):
    """Map each rule context to the assert ids it holds.

    An assert counts as evaluated when its rule fired. Schematron reports fired
    rules, not fired asserts, so the association has to come from the schema.
    """
    index = {}
    for rule in schema.iter(f"{SCH}rule"):
        ids = [
            a.get("id")
            for a in rule
            if a.tag in (f"{SCH}assert", f"{SCH}report") and a.get("id")
        ]
        index.setdefault(rule.get("context"), []).extend(ids)
    return index


def main(argv):
    strict = False
    svrl_path = None
    args = []

    i = 1
    while i < len(argv):
        if argv[i] == "--strict":
            strict = True
        elif argv[i] == "--svrl" and i + 1 < len(argv):
            i += 1
            svrl_path = argv[i]
        elif argv[i].startswith("-"):
            return usage(argv[0])
        else:
            args.append(argv[i])
        i += 1

    if len(args) != 2:
        return usage(argv[0])
    rules_dir, doc_path = args

    try:
        schema = load_rules(rules_dir)
        document = etree.parse(doc_path)
    except (OSError, etree.XMLSyntaxError) as exc:
        print(f"{argv[0]}: {exc}", file=sys.stderr)
        return 2

    validator = isoschematron.Schematron(schema, store_report=True)
    validator.validate(document)
    report = validator.validation_report

    if svrl_path:
        with open(svrl_path, "wb") as fh:
            fh.write(etree.tostring(report, pretty_print=True))

    index = assert_index(schema)
    total = sum(len(v) for v in index.values())
    fired = {r.get("context") for r in report.iter(f"{SVRL}fired-rule")}
    evaluated = sum(len(ids) for ctx, ids in index.items() if ctx in fired)

    errors = warnings = 0
    lines = []
    for hit in report.iter(f"{SVRL}failed-assert", f"{SVRL}successful-report"):
        role = hit.get("role") or "error"
        if role == "warning":
            warnings += 1
        else:
            errors += 1
        text = (hit.findtext(f"{SVRL}text") or "").strip()
        lines.append(
            f"\n  {hit.get('id'):<12} {role:<8} {text}\n"
            f"  {'':<12} at       {hit.get('location')}\n"
            f"  {'':<12} see      {hit.get('see') or '-'}"
        )

    # The count of rules that ran belongs in the headline: a rule whose context
    # is absent from this profile did not pass, it did not run, and "0 errors"
    # otherwise reads as "everything was checked".
    print(
        f"{doc_path}: {errors} error{'s' if errors != 1 else ''}, "
        f"{warnings} warning{'s' if warnings != 1 else ''}, "
        f"{evaluated} of {total} rules evaluated"
    )
    for line in lines:
        print(line)

    if errors or (strict and warnings):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
```

```bash
chmod +x bin/saip-validate
```

Note: SVRL puts `@see` on the assert only if the processor copies it. If the
attribute is absent from the SVRL, the report prints `-`; Task 3 checks whether
it survives and, if it does not, the runner reads it from the schema by rule id
instead. Do not leave the citation out of the report.

- [ ] **Step 4: Run the test to verify it passes**

Run: `./tests/run-tests`
Expected: every check `ok`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add bin/saip-validate tests/run-tests tests/fixtures/minimal-rules.sch \
        tests/fixtures/trips-one-rule.xml
git commit -m "feat: saip-validate, SVRL plus a readable report"
```

---

### Task 3: The first composition rules

**Files:**
- Create: `rules/composition.sch`
- Create: `tests/fixtures/no-header.xml`
- Create: `tests/fixtures/two-headers.xml`
- Create: `tests/fixtures/header-not-first.xml`
- Create: `tests/fixtures/valid-minimal.xml`
- Modify: `tests/run-tests` — append the section shown below

**Interfaces:**
- Consumes: `bin/saip-validate` from Task 2.
- Produces: `rules/composition.sch`, holding `SAIP-HDR-01` and `SAIP-HDR-02`.

- [ ] **Step 1: Write the failing test**

Create the four fixtures.

`tests/fixtures/no-header.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ProfilePackage><ProfileElement><mf></mf></ProfileElement></ProfilePackage>
```

`tests/fixtures/two-headers.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ProfilePackage>
  <ProfileElement><header><iccid>89 00</iccid></header></ProfileElement>
  <ProfileElement><header><iccid>89 01</iccid></header></ProfileElement>
</ProfilePackage>
```

`tests/fixtures/header-not-first.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ProfilePackage>
  <ProfileElement><mf></mf></ProfileElement>
  <ProfileElement><header><iccid>89 00</iccid></header></ProfileElement>
</ProfilePackage>
```

`tests/fixtures/valid-minimal.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ProfilePackage>
  <ProfileElement><header><iccid>89 00</iccid></header></ProfileElement>
  <ProfileElement><mf></mf></ProfileElement>
</ProfilePackage>
```

Append to `tests/run-tests`, before the final `exit $fail`:

```sh
# --- composition rules -------------------------------------------------------
#
# Each fixture must trip exactly the rule it is named for. A rule never seen to
# fire is indistinguishable from one that cannot.

fires() {
    fixture=$1; rule=$2
    got=$("$root/bin/saip-validate" "$root/rules" \
          "$root/tests/fixtures/$fixture" 2>&1 | grep -c "$rule")
    check "rules: $fixture trips $rule" 1 "$got"
}

fires no-header.xml        SAIP-HDR-01
fires two-headers.xml      SAIP-HDR-01
fires header-not-first.xml SAIP-HDR-02

"$root/bin/saip-validate" "$root/rules" \
    "$root/tests/fixtures/valid-minimal.xml" >/dev/null 2>&1
check "rules: a valid package is clean" 0 "$?"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `./tests/run-tests`
Expected: the three `fires` checks fail; `rules/` holds no `.sch` yet, so
`saip-validate` exits 2 and prints nothing matching.

- [ ] **Step 3: Write the minimal implementation**

Create `rules/composition.sch`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Composition of the ProfileElement sequence.

  Rule ids are opaque on purpose: the clause lives in @see alone, so a
  renumbering of the specification cannot invalidate an id that reports,
  tests and bug trackers already cite.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="profile-header">
    <sch:rule context="/ProfilePackage">
      <sch:let name="headers" value="count(ProfileElement/header)"/>

      <sch:assert id="SAIP-HDR-01" role="error" see="saip-3.4.1#8.2"
                  test="$headers = 1">
        A profile package shall contain exactly one Profile Header.
      </sch:assert>

      <sch:assert id="SAIP-HDR-02" role="error" see="saip-3.4.1#8.2"
                  test="not($headers = 1) or ProfileElement[1]/header">
        The Profile Header shall be the first ProfileElement.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
```

`SAIP-HDR-02` is guarded by `not($headers = 1)` so that a package with no header
reports only the missing header, not two complaints about the same fault.

- [ ] **Step 4: Run the test to verify it passes**

Run: `./tests/run-tests`
Expected: every check `ok`, exit 0.

Then confirm the citation survives into the report:

Run: `./bin/saip-validate rules tests/fixtures/no-header.xml`
Expected: the `see` line reads `saip-3.4.1#8.2`, not `-`. If it reads `-`, the
processor did not copy `@see` into the SVRL; in that case extend
`assert_index()` in `bin/saip-validate` to record `id → see` from the schema and
look the citation up there. Re-run the tests afterwards.

- [ ] **Step 5: Commit**

```bash
git add rules/composition.sch tests/fixtures/*.xml tests/run-tests
git commit -m "feat: the first two composition rules, with counter-examples"
```

---

### Task 4: Corpus regression

**Files:**
- Create: `tests/run-corpus`
- Modify: `README.md` — add the "Testing" section shown in Task 5

**Interfaces:**
- Consumes: `bin/saip-wrap`, `bin/saip-validate`, `rules/`.
- Produces: `tests/run-corpus <dir-with-der-profiles>`, exit 0 when every profile
  in the directory is clean.

- [ ] **Step 1: Write the failing test**

Create `tests/run-corpus`:

```sh
#!/bin/sh
# Every profile in a directory must pass every rule.
#
# The corpus is not in this repository -- those files belong to their
# publishers -- so the directory is named on the command line, the way
# asn1c-vn takes DERDIR.
#
# A rule that flags published reference material is either wrong or has found
# something real. Both are worth knowing the moment they happen, and neither is
# visible without this run.
set -u
here=$(dirname "$0")
root=$(cd "$here/.." && pwd)
: "${EPT:=ept}"

if [ $# -ne 1 ]; then
    echo "usage: $0 <dir-with-*.der>" >&2
    echo "  EPT=<path> overrides the converter, default 'ept'" >&2
    exit 2
fi

command -v "$EPT" >/dev/null 2>&1 || {
    echo "$0: '$EPT' not on PATH; set EPT=<path to ept>" >&2
    exit 2
}

found=0
bad=0
for der in "$1"/*.der; do
    [ -f "$der" ] || continue
    found=$((found + 1))
    if "$EPT" -iber -oxer -p ProfileElement "$der" 2>/dev/null \
        | "$root/bin/saip-wrap" \
        | "$root/bin/saip-validate" "$root/rules" /dev/stdin > /tmp/saip-corpus.$$ 2>&1
    then
        echo "ok   $(basename "$der")"
    else
        echo "FAIL $(basename "$der")"
        sed 's/^/     /' /tmp/saip-corpus.$$
        bad=$((bad + 1))
    fi
    rm -f /tmp/saip-corpus.$$
done

if [ "$found" -eq 0 ]; then
    echo "$0: no *.der in $1" >&2
    exit 2
fi
echo "$((found - bad)) of $found profile(s) clean"
[ "$bad" -eq 0 ]
```

```bash
chmod +x tests/run-corpus
```

- [ ] **Step 2: Run it to verify it reports usefully**

Run: `./tests/run-corpus /nonexistent`
Expected: exit 2, "no *.der in /nonexistent".

Run: `EPT=../euicc-profile-tool/ept ./tests/run-corpus ../euicc-profile-tool/testdata`
Expected: four `ok` lines and "4 of 4 profile(s) clean". If a profile is flagged,
stop and decide which of the two cases it is before changing anything: the rule
is wrong, or the rule is right and the profile has a real fault. Record the
answer in the commit message.

- [ ] **Step 3: Commit**

```bash
git add tests/run-corpus
git commit -m "test: published profiles must stay clean under the rule set"
```

---

### Task 5: README

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Replace the "Status" section**

Replace the existing "## Status" section with:

```markdown
## Using it

```sh
ept -iber -oxer -p ProfileElement profile.der | ./bin/saip-wrap > profile.xml
./bin/saip-validate rules profile.xml
```

```
profile.xml: 1 error, 0 warnings, 2 of 2 rules evaluated

  SAIP-HDR-02  error    The Profile Header shall be the first ProfileElement.
               at       /ProfilePackage
               see      saip-3.4.1#8.2
```

`--svrl FILE` writes the raw SVRL alongside, which is the format to archive and
to feed a CI job. `--strict` makes warnings fail too. Exit codes: `0` clean, `1`
an error, `2` usage.

**The rule count is not decoration.** A rule whose context does not occur in a
profile did not pass — it did not run. Without that number, "0 errors" reads as
"everything was checked".

## Testing

```sh
./tests/run-tests                      # the rules, against their counter-examples
./tests/run-corpus <dir-with-*.der>    # published profiles must stay clean
```

Every rule ships with a fixture that makes it fire, because a rule never seen to
fire is indistinguishable from one that cannot. `run-corpus` is the other half:
the rule set must leave valid profiles alone, and the only honest evidence for
that is profiles somebody else published.

## Status

Two composition rules. The pipeline and the test harness are in place, so
further rules are additions to `rules/` plus their counter-examples.
```

- [ ] **Step 2: Verify the commands in the README actually work**

Run each command block exactly as written, from the repository root.
Expected: the output matches what the README shows. Fix the README, not the
memory of it, if they differ.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: how to run it, and what the rule count means"
```

---

## Self-review

**Spec coverage.** Design §Shape → Task 1 (`saip-wrap`, canonical view) and
Task 2 (runner). §"A rule" → Task 3, with `@id`, `@role`, `@see` and English
text all exercised. §Reporting → Task 2: SVRL, readable form derived from it,
exit codes, and the rules-evaluated count, each with a check. §Testing → Task 3
(counter-example per rule) and Task 4 (published corpora). §"Open questions" →
all three now decided and recorded above: `lxml.isoschematron` because it needs
no JVM and is present; `saip-wrap` as a shell filter because `ept` emits no XML
declaration; opaque ids with the clause in `@see`.

**Deviation from the design.** The design proposed an XSLT function library for
`saip:octets()`. `lxml.isoschematron` binds XSLT 1.0, which has no
`xsl:function`, and two rules do not justify EXSLT. `sch:let` covers per-rule
locals. Revisit when a computation is repeated across files; update the design
document then rather than letting the two drift.

**Not covered here, deliberately.** Cross-reference rules — the ICCID in the
header against EF-ICCID, file references resolving — are the larger half of the
scope and belong in the next plan, once this pipeline is proven. The `@see`
values point at `saip-3.4.1#8.2`, which is the clause for the header; every rule
added later needs its own clause read from the specification, not guessed.
