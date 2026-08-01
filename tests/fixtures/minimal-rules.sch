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
