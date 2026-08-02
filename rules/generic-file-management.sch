<?xml version="1.0" encoding="UTF-8"?>
<!--
  Minimum parameters for file creation without a template, clause 8.3.5.

  This table is easy to confuse with the one in 8.3.3, and the two disagree on
  purpose. 8.3.3 governs an FCP that *modifies* a template, where the template
  already supplies a value and the FCP overrides it; there fileDescriptor is
  forbidden for a DF. 8.3.5 governs an FCP that *creates* a file from nothing,
  where there is no template to fall back on; there fileDescriptor is mandatory
  for a DF. The clause says why: "Since all parameters (except
  securityAttributesReferenced) for the Fcp type are optional the minimum
  parameters must be provided for generic File Creation".

  The two rule sets must therefore never see each other's nodes, and they do
  not. fcp-context.sch and fcp-mandatory.sch anchor on the named file elements
  of the template PEs, ef-*, df-*, mf and adf-*; everything here anchors under
  PE-GenericFileManagement, whose FileManagement is the schema's only user of
  createFCP.

  The discriminators below are the ones this specification states outright: 8.3.2
  says dfName "Only applies for ADFs", and linkPath is M for both link columns
  and F for all three others, so its presence identifies a link. efFileSize is
  M for Create EF and F everywhere else, which identifies an independent EF.

  Table 11.5 of ETSI TS 102 221 offers a second, exact discriminator through the
  File Descriptor byte. The rules above are left on the SAIP-stated ones, which
  the corpus has exercised; the byte is used only where nothing else could serve,
  in SAIP-GFM-08 below.

  Across the four published profiles this is 58, 58, 54 and 54 createFCP nodes,
  in four distinct shapes, every one of them satisfying every rule here. None of
  them creates an ADF this way, so SAIP-GFM-04 and 05 rest on the table alone.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    fileID and securityAttributesReferenced are M in all five columns.
    fileDescriptor is M in all five too, though for the two link columns it
    carries a Note saying the value is taken from the source file and the one in
    the FCP "shall be ignored". Ignored is not the same as absent, the cell
    still reads M, and all 32 links in the corpus provide it.
  -->
  <sch:pattern id="gfm-mandatory">
    <sch:rule context="/ProfilePackage/ProfileElement/genericFileManagement//createFCP">
      <sch:assert id="SAIP-GFM-01" role="error" see="saip-3.4.1#8.3.5"
                  test="fileID">
        An FCP creating a file without a template shall carry a fileID.
      </sch:assert>

      <sch:assert id="SAIP-GFM-02" role="error" see="saip-3.4.1#8.3.5"
                  test="securityAttributesReferenced">
        An FCP creating a file without a template shall carry
        securityAttributesReferenced.
      </sch:assert>

      <sch:assert id="SAIP-GFM-03" role="error" see="saip-3.4.1#8.3.5"
                  test="fileDescriptor">
        An FCP creating a file without a template shall carry a fileDescriptor.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="gfm-adf">
    <sch:rule context="/ProfilePackage/ProfileElement/genericFileManagement//createFCP[dfName]">
      <sch:assert id="SAIP-GFM-04" role="error" see="saip-3.4.1#8.3.5"
                  test="pinStatusTemplateDO">
        An FCP creating an ADF shall carry a pinStatusTemplateDO.
      </sch:assert>

      <sch:assert id="SAIP-GFM-05" role="error" see="saip-3.4.1#8.3.5"
                  test="not(efFileSize or shortEFID or proprietaryEFInfo or linkPath)">
        efFileSize, shortEFID, proprietaryEFInfo and linkPath are forbidden in
        an FCP creating an ADF.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    shortEFID is F for a DF Link but C for an EF Link, so the two have to be told
    apart before it can be judged. Nothing SAIP states does that, which is why
    the rule was missing; Table 11.5 of TS 102 221 does, through the File
    Descriptor byte, where the type bits 111 with structure bits 000 mean a DF or
    ADF. That is byte '38' or '78' once the free shareable bit is allowed for.

    Every link in the corpus is an EF link, so SAIP-GFM-08 fires on none of them.
  -->
  <sch:pattern id="gfm-link">
    <sch:rule context="/ProfilePackage/ProfileElement/genericFileManagement//createFCP[linkPath]">
      <sch:assert id="SAIP-GFM-06" role="error" see="saip-3.4.1#8.3.5"
                  test="not(dfName or efFileSize or pinStatusTemplateDO)">
        dfName, efFileSize and pinStatusTemplateDO are forbidden in an FCP
        creating a link.
      </sch:assert>

      <sch:assert id="SAIP-GFM-08" role="error" see="saip-3.4.1#8.3.5"
                  test="not(contains(' 38 78 ',
                              concat(' ', substring(translate(normalize-space(fileDescriptor),
                                                              'abcdef ', 'ABCDEF'), 1, 2), ' ')))
                        or not(shortEFID)">
        shortEFID is forbidden in an FCP creating a DF link.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="gfm-ef">
    <sch:rule context="/ProfilePackage/ProfileElement/genericFileManagement//createFCP[efFileSize]">
      <sch:assert id="SAIP-GFM-07" role="error" see="saip-3.4.1#8.3.5"
                  test="not(dfName or pinStatusTemplateDO)">
        dfName and pinStatusTemplateDO are forbidden in an FCP creating an EF.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
