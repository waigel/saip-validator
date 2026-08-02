<?xml version="1.0" encoding="UTF-8"?>
<!--
  Parameters forbidden in an FCP by the context it appears in, clause 8.3.3.

  The table there marks each parameter M, O, C or F per context, and F is
  unambiguous: "These parameters shall not be provided within the FCP since they
  are invalid within the respective context."

  Which context an FCP is in comes from the name of the element carrying it. The
  schema is consistent about this: ef-* is an EF, df-* and mf are DFs, adf-* is
  an ADF. Counted over a published profile that is 190 EFs, 8 DFs and 3 ADFs, and
  none of them violates an F cell, so these rules start from a corpus that
  already satisfies them.

  Only the F cells are here. M and C both mean "may or must be provided" in
  circumstances this view cannot always distinguish, and a rule that guessed
  between them would be inventing a requirement.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="fcp-forbidden">

    <sch:rule context="/ProfilePackage//*[starts-with(local-name(), 'ef-')]/fileDescriptor">
      <sch:assert id="SAIP-FCP-01" role="error" see="saip-3.4.1#8.3.3"
                  test="not(pinStatusTemplateDO)">
        pinStatusTemplateDO is forbidden in the FCP of an EF.
      </sch:assert>
      <sch:assert id="SAIP-FCP-02" role="error" see="saip-3.4.1#8.3.3"
                  test="not(dfName)">
        dfName is forbidden in the FCP of an EF.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage//*[starts-with(local-name(), 'df-')
                                          or local-name() = 'mf']/fileDescriptor">
      <sch:assert id="SAIP-FCP-03" role="error" see="saip-3.4.1#8.3.3"
                  test="not(shortEFID)">
        shortEFID is forbidden in the FCP of a DF.
      </sch:assert>
      <sch:assert id="SAIP-FCP-04" role="error" see="saip-3.4.1#8.3.3"
                  test="not(efFileSize)">
        efFileSize is forbidden in the FCP of a DF.
      </sch:assert>
      <sch:assert id="SAIP-FCP-05" role="error" see="saip-3.4.1#8.3.3"
                  test="not(proprietaryEFInfo)">
        proprietaryEFInfo is forbidden in the FCP of a DF.
      </sch:assert>
      <sch:assert id="SAIP-FCP-06" role="error" see="saip-3.4.1#8.3.3"
                  test="not(dfName)">
        dfName is forbidden in the FCP of a DF.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage//*[starts-with(local-name(), 'adf-')]/fileDescriptor">
      <sch:assert id="SAIP-FCP-07" role="error" see="saip-3.4.1#8.3.3"
                  test="not(shortEFID)">
        shortEFID is forbidden in the FCP of an ADF.
      </sch:assert>
      <sch:assert id="SAIP-FCP-08" role="error" see="saip-3.4.1#8.3.3"
                  test="not(efFileSize)">
        efFileSize is forbidden in the FCP of an ADF.
      </sch:assert>
      <sch:assert id="SAIP-FCP-09" role="error" see="saip-3.4.1#8.3.3"
                  test="not(proprietaryEFInfo)">
        proprietaryEFInfo is forbidden in the FCP of an ADF.
      </sch:assert>
    </sch:rule>

  </sch:pattern>

</sch:schema>
