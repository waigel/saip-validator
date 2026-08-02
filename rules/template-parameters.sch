<?xml version="1.0" encoding="UTF-8"?>
<!--
  Parameters a profile must supply when it references a template.

  Annex A's tables describe what a template *provides*, not what a profile must
  contain: 9.1 says "only the differences between the content and parameters of
  the files required for a specific Profile, and the content and parameters
  provided by these templates, need to be included in the Profile Package". So a
  rule demanding that a profile list a template's files would be wrong.

  One column is a profile-side obligation. 9.1 defines Parameters as "the
  parameters that shall be provided by the Profile Creator when referencing the
  template in the Profile Package". Every DF row of every template read so far
  names pinStatusTemplateDO there.

  Every table in Annex A has now been read, and reading them rather than
  assuming the pattern was worth it three times.

  The "not created by default" EF-list templates, such as 9.5.2 Optional USIM
  EFs, 9.6.2 Optional ISIM EFs and 9.7.2 Optional CSIM EFs, have no root row and
  no Parameters entry at all. They require nothing.

  The IoT templates, 9.10.1 and 9.10.2, name pinStatusTemplateDO in a note as a
  *default value* rather than in the Parameters column as an obligation: "The
  default value of pinStatusTemplateDO is '010A'". A profile need not supply it,
  so they are absent from the list too.

  The ADF templates ask for more than the DF ones. ADF USIM, ADF ISIM, ADF CSIM
  and ADF SSIM all read "AID, Temporary FID, pinStatusTemplateDO", and DF EAP
  reads "FID, pinStatusTemplateDO". This rule checks the part they share, keyed
  on the templateID. The AID and the Temporary FID are checked from the other
  direction, by SAIP-FCP-11 and SAIP-FCP-10 in fcp-mandatory.sch: 8.3.3 marks
  dfName and fileID mandatory in the FCP of an ADF, and 8.3.2 identifies dfName
  as the AID and fileID as the temporary file ID.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="template-parameters">
    <sch:let name="needs-pin-status"
             value="' 2.23.143.1.2.1 2.23.143.1.2.2 2.23.143.1.2.3 2.23.143.1.2.3.2 2.23.143.1.2.3.3 2.23.143.1.2.4 2.23.143.1.2.4.2 2.23.143.1.2.6 2.23.143.1.2.7 2.23.143.1.2.8 2.23.143.1.2.10 2.23.143.1.2.10.2 2.23.143.1.2.12 2.23.143.1.2.13 2.23.143.1.2.13.2 2.23.143.1.2.13.3 2.23.143.1.2.13.4 2.23.143.1.2.14 2.23.143.1.2.15 2.23.143.1.2.15.2 2.23.143.1.2.16 2.23.143.1.2.16.2 2.23.143.1.2.19 '"/>

    <sch:rule context="/ProfilePackage/ProfileElement/*[templateID]">
      <sch:assert id="SAIP-TPP-01" role="error" see="saip-3.4.1#9.1"
                  test="not(contains($needs-pin-status,
                                     concat(' ', normalize-space(templateID), ' ')))
                        or .//pinStatusTemplateDO">
        A ProfileElement referencing this template shall provide the
        pinStatusTemplateDO its Parameters column requires.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
