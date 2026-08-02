<?xml version="1.0" encoding="UTF-8"?>
<!--
  Dependencies on the MF, and the PIN context.

  Both were set aside earlier as needing a model of where a context begins. They
  do not: XPath's reverse axes number backwards from the context node, so
  preceding-sibling::X[1] is the nearest preceding X, which is exactly what
  "created by the previous PE" means.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.1 lists these as coming "after the creation of the MF". The MF has three
    possible origins. Two are in the same clause: PE-MF, or "if this PE is not
    used, the MF shall be created as the first element of the file system using
    the PE-GenericFileManagement". The third is PE-IoT, because 7.5 forbids PE-MF
    in an IoT Minimal Profile and gives PE-IoT the job of creating the file
    system there. Leaving it out made the rule reject a legitimate IoT profile,
    which the counter-example for SAIP-IOT-02 caught immediately.
  -->
  <sch:pattern id="after-mf">
    <sch:rule context="/ProfilePackage/ProfileElement/cd">
      <sch:assert id="SAIP-ORD-11" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/mf
                        or ../preceding-sibling::ProfileElement/genericFileManagement
                        or ../preceding-sibling::ProfileElement/iot">
        PE-CD shall come after the creation of the file system root, by PE-MF,
        PE-GenericFileManagement or PE-IoT.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/telecom">
      <sch:assert id="SAIP-ORD-12" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/mf
                        or ../preceding-sibling::ProfileElement/genericFileManagement
                        or ../preceding-sibling::ProfileElement/iot">
        PE-TELECOM shall come after the creation of the file system root, by PE-MF,
        PE-GenericFileManagement or PE-IoT.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/usim">
      <sch:assert id="SAIP-ORD-13" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/mf
                        or ../preceding-sibling::ProfileElement/genericFileManagement
                        or ../preceding-sibling::ProfileElement/iot">
        PE-USIM shall come after the creation of the file system root, by PE-MF,
        PE-GenericFileManagement or PE-IoT.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/isim">
      <sch:assert id="SAIP-ORD-14" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/mf
                        or ../preceding-sibling::ProfileElement/genericFileManagement
                        or ../preceding-sibling::ProfileElement/iot">
        PE-ISIM shall come after the creation of the file system root, by PE-MF,
        PE-GenericFileManagement or PE-IoT.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/csim">
      <sch:assert id="SAIP-ORD-15" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/mf
                        or ../preceding-sibling::ProfileElement/genericFileManagement
                        or ../preceding-sibling::ProfileElement/iot">
        PE-CSIM shall come after the creation of the file system root, by PE-MF,
        PE-GenericFileManagement or PE-IoT.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/ssim">
      <sch:assert id="SAIP-ORD-16" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/mf
                        or ../preceding-sibling::ProfileElement/genericFileManagement
                        or ../preceding-sibling::ProfileElement/iot">
        PE-SSIM shall come after the creation of the file system root, by PE-MF,
        PE-GenericFileManagement or PE-IoT.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.1: "The 'PIN Context' is fixed by the first ADF/DF created by the previous
    PE which contains an ADF/DF using PE-Template or PE-Generic File Management."
    So the context of a PE-PINCodes is decided by the nearest file-system PE
    before it: the MF means global references, anything else means local ones.

    8.5.1 then says which references each context admits: "Within the PE-PINCodes
    sent in the context of the MF only global PIN key references shall be used.
    For PINs in any ADF/DF only local PINs shall be defined."

    A PE-PINCodes with no file-system PE before it has no context to judge, and
    neither rule applies to it.
  -->
  <sch:pattern id="pin-context">
    <sch:rule context="/ProfilePackage/ProfileElement/pinCodes/pinCodes/pinconfig/PINConfiguration">
      <sch:let name="context-pe"
               value="ancestor::ProfileElement/preceding-sibling::ProfileElement[mf or cd or telecom or usim or opt-usim or isim or opt-isim or csim or opt-csim or phonebook or gsm-access or df-5gs or df-saip or df-snpn or df-5gprose or eap or iot or opt-iot or ssim or genericFileManagement][1]"/>

      <sch:assert id="SAIP-PIN-05" role="error" see="saip-3.4.1#8.5.1"
                  test="not($context-pe/mf)
                        or not(keyReference &gt;= 129 and keyReference &lt;= 136)">
        A PE-PINCodes in the context of the MF shall use global PIN references
        only.
      </sch:assert>

      <sch:assert id="SAIP-PIN-06" role="error" see="saip-3.4.1#8.5.1"
                  test="not($context-pe) or $context-pe/mf
                        or (keyReference &gt;= 129 and keyReference &lt;= 136)">
        A PE-PINCodes in the context of a DF or ADF shall define local PINs
        only, that is secondPINAppl1 to secondPINAppl8.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.5.1: "The use of this PE shall be unique for one 'PIN Context'." Unique per
    context, not per package, so counting PE-PINCodes across the profile would
    reject a legitimate one: the corpus has five, each in a different context.

    Two PE-PINCodes share a context when the nearest file-system PE before each
    is the same node, which is what generate-id compares. The context node set
    is the same one SAIP-PIN-05 and 06 use.
  -->
  <sch:pattern id="pin-codes-once-per-context">
    <sch:rule context="/ProfilePackage/ProfileElement[pinCodes]">
      <sch:let name="ctx" value="preceding-sibling::ProfileElement[mf or cd or telecom
                                   or usim or opt-usim or isim or opt-isim or csim
                                   or opt-csim or phonebook or gsm-access or df-5gs
                                   or df-saip or df-snpn or df-5gprose or eap or iot
                                   or opt-iot or ssim or genericFileManagement][1]"/>

      <sch:assert id="SAIP-PIN-07" role="error" see="saip-3.4.1#8.5.1"
                  test="not($ctx) or not(preceding-sibling::ProfileElement[pinCodes][
                          generate-id(preceding-sibling::ProfileElement[mf or cd or telecom
                            or usim or opt-usim or isim or opt-isim or csim
                            or opt-csim or phonebook or gsm-access or df-5gs
                            or df-saip or df-snpn or df-5gprose or eap or iot
                            or opt-iot or ssim or genericFileManagement][1])
                          = generate-id($ctx)])">
        Only one PE-PINCodes shall be used for one PIN context.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
