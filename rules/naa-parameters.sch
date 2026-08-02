<?xml version="1.0" encoding="UTF-8"?>
<!--
  Where the NAA parameter PEs may appear, clause 8.4.1.

  These rules exist because of an audit rather than a reading. Every PE
  definition in clause 8 ends with a "Usage rules" paragraph, and extracting all
  31 of them and diffing against the contexts already asserted showed that the
  NAA parameter PEs and PE-EAP had no rule at all. Clause 8.4.1 states the
  dependency plainly: an NAA "is implicitly installed in the context of the
  creation of the NAA file structure and includes the following PE provided
  subsequent to the PEs describing its file system".

  Which NAA each PE belongs to is not decidable from position, so, as with
  SAIP-SD-01 and SAIP-SD-02, these assert only what is: an NAA of the right kind
  precedes. PE-AKAParameter names three, "This PE shall be used once after the
  creation of a NAA using Milenage or TUAK authentication algorithm (e.g., USIM,
  ISIM or CSIM)"; PE-CDMAParameter names CAVE and CSIM; PE-SSIM-EAPTLSParameters
  names SSIM alone.

  The published corpus places akaParameter after usim and after isim,
  cdmaParameter after csim, and satisfies every rule here.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="naa-parameter-order">
    <sch:rule context="/ProfilePackage/ProfileElement/akaParameter">
      <sch:assert id="SAIP-NAA-01" role="error" see="saip-3.4.1#8.4.2"
                  test="../preceding-sibling::ProfileElement/usim
                        or ../preceding-sibling::ProfileElement/isim
                        or ../preceding-sibling::ProfileElement/csim">
        PE-AKAParameter shall come after the creation of a USIM, ISIM or CSIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement/cdmaParameter">
      <sch:assert id="SAIP-NAA-02" role="error" see="saip-3.4.1#8.4.3"
                  test="../preceding-sibling::ProfileElement/csim">
        PE-CDMAParameter shall come after the creation of a CSIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement/ssimEapTLSParameters">
      <sch:assert id="SAIP-NAA-03" role="error" see="saip-3.4.1#8.4.4"
                  test="../preceding-sibling::ProfileElement/ssim">
        PE-SSIM-EAPTLSParameters shall come after the creation of a SSIM.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    PE-EAP: "This PE can be used once for each EAP method supported by an
    application providing Extensible Authentication Protocol after the creation
    of the ADF." Which ADF is not stated, so any of the four that create one
    satisfies this.
  -->
  <sch:pattern id="eap-order">
    <sch:rule context="/ProfilePackage/ProfileElement/eap">
      <sch:assert id="SAIP-NAA-04" role="error" see="saip-3.4.1#8.3.4.7"
                  test="../preceding-sibling::ProfileElement/usim
                        or ../preceding-sibling::ProfileElement/isim
                        or ../preceding-sibling::ProfileElement/csim
                        or ../preceding-sibling::ProfileElement/ssim">
        PE-EAP shall come after the creation of an ADF.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
