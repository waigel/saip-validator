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

  The OID list below covers only the templates whose tables have been read
  (9.2 MF, 9.3 DF CD, 9.4 DF TELECOM). Extending it means reading the table, not
  assuming the pattern holds: the same assumption applied to Annex A as a whole
  would have produced a rule that contradicts 9.1.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="template-parameters">
    <sch:let name="needs-pin-status"
             value="' 2.23.143.1.2.1 2.23.143.1.2.2 2.23.143.1.2.3 2.23.143.1.2.3.2 2.23.143.1.2.3.3 '"/>

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
