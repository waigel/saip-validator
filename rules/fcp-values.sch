<?xml version="1.0" encoding="UTF-8"?>
<!--
  The form of two FCP values, clause 8.3.2.

  Both rules here come from an audit of the specification's "shall" sentences
  rather than from reading a table, and both needed a detour before they could
  be written honestly.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.3.2: "The 'pinStatusTemplateDO' shall contain only a list of PIN Key
    Reference values coded according to table 9.3 of ETSI TS 102 221 ... It shall
    not contain the full data object as defined in ETSI TS 102 221 (e.g.,
    '01810A'H as a typical value for an ADF_USIM)."

    Read alone that sentence looks like it forbids '01810A', which would
    contradict Annex A, where Note 2 gives exactly '01810A' as the *default
    value* for an ADF USIM. The specification's own worked example settles it.
    In the sample profile the value is written

        pinStatusTemplateDO '01810A'H          C6 03 01810A

    so 'C6' is the tag and '03' the length that the encoder adds, and '01810A'
    is the bare list of key references. The "full data object" is therefore the
    tag-length-value form, and the mistake this rule catches is a profile that
    puts the wrapper inside the OCTET STRING instead of just its content.

    Checking the leading tag is all this can do without table 9.3 itself, which
    is in a document not in hand: the individual references are not validated,
    only that the value is not the wrapped form. 'C6' is not a key reference in
    any of the values this specification shows, so the test cannot collide with
    a legitimate list.
  -->
  <sch:pattern id="pin-status-template-form">
    <sch:rule context="/ProfilePackage//pinStatusTemplateDO">
      <sch:assert id="SAIP-FCP-14" role="error" see="saip-3.4.1#8.3.2"
                  test="not(starts-with(translate(normalize-space(.), ' ', ''), 'C6'))">
        pinStatusTemplateDO shall carry only the list of PIN key references, not
        the full 'C6' data object that wraps it.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.3.2 on BER-TLV files: "the list of TLVs defined shall be part of one or
    more 'fillFileContent' parameters with these constraints: All TLVs shall be
    concatenated. 'fillFileOffset' shall not be used."

    Which files are BER-TLV is not stated as a flag, but the same clause says
    "The parameters 'maximumFileSize' and 'fileDetails' are dedicated to BER-TLV",
    so either one being present identifies the file. Deciding it from byte 1 of
    the fileDescriptor would be exact but needs ETSI TS 102 222.

    No profile in the corpus carries either parameter, so this rule rests on the
    clause and its counter-example alone, with no published profile exercising
    it. That is worth knowing when reading a clean corpus run.
  -->
  <sch:pattern id="bertlv-no-offset">
    <sch:rule context="/ProfilePackage//*[fileDescriptor/proprietaryEFInfo/maximumFileSize
                                          or fileDescriptor/proprietaryEFInfo/fileDetails]">
      <sch:assert id="SAIP-FCP-15" role="error" see="saip-3.4.1#8.3.2"
                  test="not(fillFileOffset)">
        A BER-TLV file shall carry its TLVs in fillFileContent alone, so
        fillFileOffset shall not be used.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
