<?xml version="1.0" encoding="UTF-8"?>
<!--
  PIN and PUK codes, clause 8.5.

  The first rule here is the project's first genuine cross-reference: a PIN may
  name the PUK that unblocks it, and that PUK has to exist. Everything before
  this point judged a profile element on its own.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.5.1: "In case a PUKKeyReferenceValue is defined the related
    PUKKeyReferenceValue shall exist within the PE-PUKCodes list."

    The reference is by value, and a PE-PUKCodes may sit anywhere in the package,
    so the comparison is against every PUK key reference in the document. XPath
    compares a node against a node-set as "equals any of them", which is exactly
    the membership test wanted.
  -->
  <sch:pattern id="pin-unblocking-reference">
    <sch:rule context="/ProfilePackage/ProfileElement/pinCodes//unblockingPINReference">
      <sch:assert id="SAIP-PIN-01" role="error" see="saip-3.4.1#8.5.1"
                  test=". = /ProfilePackage/ProfileElement/pukCodes/pukCodes/PUKConfiguration/keyReference">
        The PUK named by unblockingPINReference shall be defined in a
        PE-PUKCodes.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.5.1: "For every value defined in PINKeyReferenceValue only one entry may
    be included per PE-PINCodes."
  -->
  <sch:pattern id="pin-key-uniqueness">
    <sch:rule context="/ProfilePackage/ProfileElement/pinCodes/pinCodes/pinconfig/PINConfiguration">
      <sch:assert id="SAIP-PIN-02" role="error" see="saip-3.4.1#8.5.1"
                  test="not(keyReference = preceding-sibling::PINConfiguration/keyReference)">
        A PIN key reference shall appear at most once within one PE-PINCodes.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.5.2: "Any PUKKeyReferenceValue shall only be defined once within
    PE-PUKCodes."
  -->
  <sch:pattern id="puk-key-uniqueness">
    <sch:rule context="/ProfilePackage/ProfileElement/pukCodes/pukCodes/PUKConfiguration">
      <sch:assert id="SAIP-PUK-01" role="error" see="saip-3.4.1#8.5.2"
                  test="not(keyReference = preceding-sibling::PUKConfiguration/keyReference)">
        A PUK key reference shall be defined at most once within PE-PUKCodes.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.5.1 and 8.5.2: "If the RetryNumLeft is greater than MaxNumOfAttemps then
    the behaviour of the eUICC is undefined." Undefined behaviour is not a
    prohibition, so this is a warning: the specification declines to forbid it
    and this project does not get to forbid it either.

    The byte packs both counts: max attempts in the high nibble, retries left in
    the low one.
  -->
  <sch:pattern id="retry-counts">
    <sch:rule context="/ProfilePackage/ProfileElement/*/*//maxNumOfAttemps-retryNumLeft">
      <sch:assert id="SAIP-PIN-03" role="warning" see="saip-3.4.1#8.5.1"
                  test=". mod 16 &lt;= floor(. div 16)">
        Retries left exceed the maximum number of attempts, which leaves the
        eUICC's behaviour undefined.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
