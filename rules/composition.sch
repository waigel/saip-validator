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
