<?xml version="1.0" encoding="UTF-8"?>
<!--
  RFM parameters, clause 8.8.

  8.8's usage rule says a PE-RFM comes "after the PE containing the SD and the PE
  containing the ADF". The SD half is SAIP-SD-01, and the ADF half is SAIP-RFM-02
  below.

  Tying an RFM to *its own* ADF remains out of reach, and that is the stronger
  rule this file does not have: a PE-USIM creates its ADF from a template, so
  that ADF's AID never appears in the document, and matching instanceAID against
  it would need the template definitions modelled.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    The weaker half that is checkable: some ADF precedes. The guard matters. A
    package whose RFM addresses the MF-level file system need contain no ADF at
    all, and demanding one would reject it, so the rule applies only where the
    package defines an ADF and the RFM has therefore been placed wrongly rather
    than legitimately without one.
  -->
  <sch:pattern id="rfm-after-adf">
    <sch:rule context="/ProfilePackage/ProfileElement/rfm">
      <sch:let name="adfs" value="/ProfilePackage/ProfileElement/usim
                                  | /ProfilePackage/ProfileElement/isim
                                  | /ProfilePackage/ProfileElement/csim
                                  | /ProfilePackage/ProfileElement/ssim"/>

      <sch:assert id="SAIP-RFM-02" role="error" see="saip-3.4.1#8.8"
                  test="not($adfs)
                        or ../preceding-sibling::ProfileElement/usim
                        or ../preceding-sibling::ProfileElement/isim
                        or ../preceding-sibling::ProfileElement/csim
                        or ../preceding-sibling::ProfileElement/ssim">
        PE-RFM shall come after the PE containing the ADF.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.8: "In case tarList is not available the TAR value defined within bytes
    13-15 of the instanceAID shall be used", and "if absent (i.e., no tarList is
    provided and the TAR value is not defined within the instanceAID), the RFM
    instance cannot be addressed via protocols that require TAR address (e.g.,
    SCP80)".

    That is a consequence the specification describes, not a prohibition it
    makes, so this is a warning. An instance whose AID is shorter than fifteen
    bytes has no bytes 13 to 15 to fall back on.

    The AID arrives as space-separated hex pairs, so fifteen bytes is 44
    characters.
  -->
  <sch:pattern id="rfm-tar">
    <sch:rule context="/ProfilePackage/ProfileElement/rfm[not(tarList)]">
      <sch:assert id="SAIP-RFM-01" role="warning" see="saip-3.4.1#8.8"
                  test="string-length(normalize-space(instanceAID)) &gt;= 44">
        This RFM instance provides no tarList and its instanceAID is too short
        to carry a TAR in bytes 13 to 15, so it cannot be addressed over
        protocols that require one.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
