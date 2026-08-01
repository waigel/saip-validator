<?xml version="1.0" encoding="UTF-8"?>
<!--
  Counter-example for the @id requirement: an assert with no @id must reject
  the run, not crash the report formatter or vanish from the count.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
  <sch:pattern id="test-no-id">
    <sch:rule context="/ProfilePackage">
      <sch:assert role="error" see="none#0"
                  test="false()">An assert with no @id.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
