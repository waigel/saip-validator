<?xml version="1.0" encoding="UTF-8"?>
<!--
  PIN references named by a pinStatusTemplateDO, clause 8.1.3.

  These two were listed for a while as "checkable, but not checked", on the
  grounds that the references are packed as bytes in an octet string while
  PE-PINCodes gives a decimal keyReference, and XPath 1.0 has no hex-to-decimal
  function. That was the wrong way round. The conversion only has to go one way,
  and the set of values is closed: PINKeyReferenceValue in clause 8.5.1 is an
  INTEGER with 26 named values, so each decimal has a known two-digit hex form
  and the rule can be written as a fixed conjunction over them.

  Only the values the specification classifies are covered. It names the local
  PINs exactly, "secondPINAppl1 - secondPINAppl8", so 129 to 136 are local and 1
  to 8 with 10 to 14 are global. The administrative keys adm6 to adm10, 138 to
  142, are in neither sentence and are left alone rather than guessed at.

  Byte matching is done on the space-delimited form the encoder produces, with
  the delimiters supplied so that '01' cannot match inside another byte pair. If
  some other encoder were to emit the octets unspaced, these rules would stop
  matching rather than start misfiring, which is the safe direction to fail.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.1.3: "All the Global PINs referenced by a 'pinStatusTemplateDO' shall be
    defined in the 'PIN Context' of the MF." The MF's PIN context is the same one
    SAIP-PIN-05 uses: a PE-PINCodes whose nearest preceding file-system PE is the
    MF.
  -->
  <sch:pattern id="pin-status-global-refs">
    <sch:rule context="/ProfilePackage//pinStatusTemplateDO">
      <sch:let name="d" value="concat(' ', translate(normalize-space(.), 'abcdef', 'ABCDEF'), ' ')"/>
      <sch:let name="mfrefs"
               value="/ProfilePackage/ProfileElement[pinCodes][
                        preceding-sibling::ProfileElement[mf or cd or telecom or usim or opt-usim or isim or opt-isim or csim or opt-csim or phonebook or gsm-access or df-5gs or df-saip or df-snpn or df-5gprose or eap or iot or opt-iot or ssim or genericFileManagement][1]/mf
                      ]//PINConfiguration/keyReference"/>

      <sch:assert id="SAIP-PIN-08" role="error" see="saip-3.4.1#8.1.3"
                  test="(not(contains($d, ' 01 ')) or $mfrefs = 1)
                        and (not(contains($d, ' 02 ')) or $mfrefs = 2)
                        and (not(contains($d, ' 03 ')) or $mfrefs = 3)
                        and (not(contains($d, ' 04 ')) or $mfrefs = 4)
                        and (not(contains($d, ' 05 ')) or $mfrefs = 5)
                        and (not(contains($d, ' 06 ')) or $mfrefs = 6)
                        and (not(contains($d, ' 07 ')) or $mfrefs = 7)
                        and (not(contains($d, ' 08 ')) or $mfrefs = 8)
                        and (not(contains($d, ' 0A ')) or $mfrefs = 10)
                        and (not(contains($d, ' 0B ')) or $mfrefs = 11)
                        and (not(contains($d, ' 0C ')) or $mfrefs = 12)
                        and (not(contains($d, ' 0D ')) or $mfrefs = 13)
                        and (not(contains($d, ' 0E ')) or $mfrefs = 14)">
        Every global PIN referenced by a pinStatusTemplateDO shall be defined in
        a PE-PINCodes in the PIN context of the MF.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.1.3: "All the Local PINs referenced by a 'pinStatusTemplateDO' shall either
    be defined in a parent ADF or DF or created in a following PE-PINCodes."

    Which parent is a question this view cannot answer, so the rule checks the
    necessary condition both branches share: the PIN is defined somewhere in the
    package. A local PIN named by a file and defined by nobody is the error this
    catches; one defined in the wrong place is not.
  -->
  <sch:pattern id="pin-status-local-refs">
    <sch:rule context="/ProfilePackage//pinStatusTemplateDO">
      <sch:let name="d" value="concat(' ', translate(normalize-space(.), 'abcdef', 'ABCDEF'), ' ')"/>
      <sch:let name="allrefs"
               value="/ProfilePackage/ProfileElement/pinCodes//PINConfiguration/keyReference"/>

      <sch:assert id="SAIP-PIN-09" role="error" see="saip-3.4.1#8.1.3"
                  test="(not(contains($d, ' 81 ')) or $allrefs = 129)
                        and (not(contains($d, ' 82 ')) or $allrefs = 130)
                        and (not(contains($d, ' 83 ')) or $allrefs = 131)
                        and (not(contains($d, ' 84 ')) or $allrefs = 132)
                        and (not(contains($d, ' 85 ')) or $allrefs = 133)
                        and (not(contains($d, ' 86 ')) or $allrefs = 134)
                        and (not(contains($d, ' 87 ')) or $allrefs = 135)
                        and (not(contains($d, ' 88 ')) or $allrefs = 136)">
        Every local PIN referenced by a pinStatusTemplateDO shall be defined by a
        PE-PINCodes.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
