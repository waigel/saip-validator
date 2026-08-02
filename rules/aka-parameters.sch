<?xml version="1.0" encoding="UTF-8"?>
<!--
  Key material sizes for AKA authentication, clause 8.4.2.

  These are the first rules in this project that check the size of a value
  rather than its presence or its position, and they are the kind an ASN.1
  SIZE constraint would normally carry. It does not: the module declares "key
  OCTET STRING" with no bound, because the bound depends on a sibling field,
  algorithmID. That is exactly the sort of rule that has to live here.

  Sizes are counted in hex digits after the spaces are removed, so 16 bytes is
  32 digits and 32 bytes is 64.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.4.2: "The 'key' OBJECT STRING shall have a length of 16 bytes in case of
    the Milenage or usim-test-algorithm and 16 or 32 bytes in case of the TUAK
    algorithm." algorithmID names them: milenage(1), tuak(2),
    usim-test-algorithm(3).
  -->
  <sch:pattern id="aka-key-size">
    <sch:rule context="/ProfilePackage//algoParameter[key]">
      <sch:let name="k" value="string-length(translate(normalize-space(key), ' ', ''))"/>

      <sch:assert id="SAIP-AKA-01" role="error" see="saip-3.4.1#8.4.2"
                  test="not(algorithmID = 1 or algorithmID = 3) or $k = 32">
        The key for Milenage or the usim-test-algorithm shall be 16 bytes.
      </sch:assert>

      <sch:assert id="SAIP-AKA-02" role="error" see="saip-3.4.1#8.4.2"
                  test="not(algorithmID = 2) or $k = 32 or $k = 64">
        The key for TUAK shall be 16 or 32 bytes.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.4.2: "The 'opc' OBJECT STRING shall have a size of 16 bytes in case of the
    Milenage and 32 bytes in case of the TUAK algorithm."

    Only those two. The module's comment says opc is "ignored in case of
    usim-test-algorithm", and the sentence above says nothing about its size
    there, so algorithmID 3 is left alone. A published profile in the corpus
    uses algorithmID 3 with a 16-byte opc, which no rule here should touch.
  -->
  <sch:pattern id="aka-opc-size">
    <sch:rule context="/ProfilePackage//algoParameter[opc]">
      <sch:let name="o" value="string-length(translate(normalize-space(opc), ' ', ''))"/>

      <sch:assert id="SAIP-AKA-03" role="error" see="saip-3.4.1#8.4.2"
                  test="not(algorithmID = 1) or $o = 32">
        The OPc for Milenage shall be 16 bytes.
      </sch:assert>

      <sch:assert id="SAIP-AKA-04" role="error" see="saip-3.4.1#8.4.2"
                  test="not(algorithmID = 2) or $o = 64">
        The TOPc for TUAK shall be 32 bytes.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.4.2, and the module comment above the field itself: "The following
    parameters may be used only in the context of SSIM", restated in prose as
    "'ssimParameters' shall be provided only in the context of SSIM".

    Context is positional here, as it is for the PIN context and for
    SAIP-NAA-05: the nearest NAA-creating PE before this one decides it.
  -->
  <sch:pattern id="ssim-parameters-context">
    <sch:rule context="/ProfilePackage/ProfileElement[.//ssimParameters]">
      <sch:assert id="SAIP-AKA-05" role="error" see="saip-3.4.1#8.4.2"
                  test="preceding-sibling::ProfileElement[
                          usim or isim or csim or ssim][1]/ssim">
        ssimParameters shall be provided only in the context of an SSIM.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
