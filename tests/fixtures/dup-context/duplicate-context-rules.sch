<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
  <sch:pattern id="test-duplicate-context">
    <sch:rule context="/ProfilePackage">
      <sch:assert id="FIRST-RULE-01" role="error" see="none#0"
                  test="false()">First rule fires.</sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage">
      <sch:assert id="SECOND-RULE-01" role="error" see="none#0"
                  test="false()">Second rule never runs in same pattern.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
