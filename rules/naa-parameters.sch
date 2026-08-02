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

  The two clauses disagree about which NAAs take AKA parameters, and this rule
  takes their union rather than picking a side. 8.4.1 lists "PE-AKAParameter (if
  <NAA> = USIM, ISIM or SSIM)", omitting CSIM; 8.4.2's usage rule writes "(e.g.,
  USIM, ISIM or CSIM using Milenage)", omitting SSIM but hedging with "e.g.".
  8.1.3 settles that SSIM belongs, since it says PE-AKAParameter is what an SSIM
  uses "If EAP-AKA' authentication is required". A union cannot reject a profile
  either clause permits, which is the safe direction for a disagreement between
  two normative sentences.

  The published corpus places akaParameter after usim and after isim,
  cdmaParameter after csim, and satisfies every rule here.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="naa-parameter-order">
    <sch:rule context="/ProfilePackage/ProfileElement/akaParameter">
      <sch:assert id="SAIP-NAA-01" role="error" see="saip-3.4.1#8.4.1"
                  test="../preceding-sibling::ProfileElement/usim
                        or ../preceding-sibling::ProfileElement/isim
                        or ../preceding-sibling::ProfileElement/csim
                        or ../preceding-sibling::ProfileElement/ssim">
        PE-AKAParameter shall come after the creation of a NAA.
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

  <!--
    8.1.3: "Only one occurrence of either PE-SSIM-EAPTLSParameters or
    PE-AKAParameter shall be provided per SSIM." Per SSIM, not per package, so
    counting across the package would reject a profile with two SSIMs.

    The scope is expressed positionally, the same way the PIN context is: two
    parameter PEs belong to the same NAA when the nearest NAA-creating PE before
    each is the same node, which generate-id compares.
  -->
  <sch:pattern id="ssim-one-authentication-pe">
    <sch:rule context="/ProfilePackage/ProfileElement[akaParameter or ssimEapTLSParameters]">
      <sch:let name="naa"
               value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-NAA-05" role="error" see="saip-3.4.1#8.1.3"
                  test="not($naa/ssim)
                        or not(preceding-sibling::ProfileElement[
                                 akaParameter or ssimEapTLSParameters][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1])
                                 = generate-id($naa)])">
        Only one of PE-SSIM-EAPTLSParameters or PE-AKAParameter shall be
        provided per SSIM.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
