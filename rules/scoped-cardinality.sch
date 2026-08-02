<?xml version="1.0" encoding="UTF-8"?>
<!--
  Once per ADF, not once per package, clause 8.1.3 and the 8.3.4 usage rules.

  These were documented in ordering.sch as deliberately absent, because the
  obvious rule for them is wrong. "This PE may be used only once in the context
  of a USIM ADF" is not a statement about the package: a profile with two USIMs
  may legitimately carry two PE-DF-5GS, one per USIM, and counting them across
  the package would reject it.

  What was missing was a way to say "in the context of". The PIN context supplied
  it: two PEs share a context when the nearest NAA-creating PE before each is the
  same node, and generate-id compares nodes for identity. SAIP-NAA-05 and
  SAIP-PIN-07 use the same shape.

  PE-EAP is still absent. Its usage rule reads "once for each EAP method
  supported by an application", and the method is not visible in the package, so
  there is nothing to key the scope on.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="scoped-cardinality">
    <sch:rule context="/ProfilePackage/ProfileElement[phonebook]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-01" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/usim)
                        or not(preceding-sibling::ProfileElement[phonebook][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-PHONEBOOK shall be used only once in the context of one ADF USIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[gsm-access]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-02" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/usim)
                        or not(preceding-sibling::ProfileElement[gsm-access][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-GSM-ACCESS shall be used only once in the context of one ADF USIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[df-5gs]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-03" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/usim)
                        or not(preceding-sibling::ProfileElement[df-5gs][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-DF-5GS shall be used only once in the context of one ADF USIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[df-saip]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-04" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/usim)
                        or not(preceding-sibling::ProfileElement[df-saip][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-DF-SAIP shall be used only once in the context of one ADF USIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[df-snpn]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-05" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/usim)
                        or not(preceding-sibling::ProfileElement[df-snpn][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-DF-SNPN shall be used only once in the context of one ADF USIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[df-5gprose]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-06" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/usim)
                        or not(preceding-sibling::ProfileElement[df-5gprose][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-DF-5GPROSE shall be used only once in the context of one ADF USIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[opt-usim]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-07" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/usim)
                        or not(preceding-sibling::ProfileElement[opt-usim][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-OPT-USIM shall be used only once in the context of one ADF USIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[opt-isim]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-08" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/isim)
                        or not(preceding-sibling::ProfileElement[opt-isim][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-OPT-ISIM shall be used only once in the context of one ISIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[opt-csim]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-09" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/csim)
                        or not(preceding-sibling::ProfileElement[opt-csim][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-OPT-CSIM shall be used only once in the context of one CSIM.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement[cdmaParameter]">
      <sch:let name="scope" value="preceding-sibling::ProfileElement[usim or isim or csim or ssim][1]"/>

      <sch:assert id="SAIP-SCP-10" role="error" see="saip-3.4.1#8.1.3"
                  test="not($scope/csim)
                        or not(preceding-sibling::ProfileElement[cdmaParameter][
                                 generate-id(preceding-sibling::ProfileElement[
                                   usim or isim or csim or ssim][1]) = generate-id($scope)])">
        PE-CDMAParameter shall be used only once in the context of one CSIM.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
