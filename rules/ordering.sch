<?xml version="1.0" encoding="UTF-8"?>
<!--
  Ordering and cardinality, from clause 8.1: "It is important that PEs are sent
  in an order which do not create unresolved dependencies. The following rules
  shall be considered by the Profile Creator."

  Only the unambiguous dependencies are here: those naming exactly one
  antecedent PE. The clause also says several PEs "shall come after the creation
  of the MF", but the MF may be created either by PE-MF or by
  PE-GenericFileManagement, so those need a second antecedent and are handled
  separately.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="pe-ordering">
    <sch:rule context="/ProfilePackage/ProfileElement/opt-usim">
      <sch:assert id="SAIP-ORD-01" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/usim">
        PE-OPT-USIM shall come after the creation of an ADF USIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/opt-isim">
      <sch:assert id="SAIP-ORD-02" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/isim">
        PE-OPT-ISIM shall come after the creation of an ADF ISIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/opt-csim">
      <sch:assert id="SAIP-ORD-03" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/csim">
        PE-OPT-CSIM shall come after the creation of an ADF CSIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/gsm-access">
      <sch:assert id="SAIP-ORD-04" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/usim">
        PE-GSM-ACCESS shall come after the creation of an ADF USIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/phonebook">
      <sch:assert id="SAIP-ORD-05" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/usim">
        PE-PHONEBOOK shall come after the creation of an ADF USIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/df-5gs">
      <sch:assert id="SAIP-ORD-06" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/usim">
        PE-DF-5GS shall come after the creation of an ADF USIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/df-saip">
      <sch:assert id="SAIP-ORD-07" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/usim">
        PE-DF-SAIP shall come after the creation of an ADF USIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/df-snpn">
      <sch:assert id="SAIP-ORD-08" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/usim">
        PE-DF-SNPN shall come after the creation of an ADF USIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/df-5gprose">
      <sch:assert id="SAIP-ORD-09" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/usim">
        PE-DF-5GPROSE shall come after the creation of an ADF USIM.
      </sch:assert>
    </sch:rule>
    <sch:rule context="/ProfilePackage/ProfileElement/opt-iot">
      <sch:assert id="SAIP-ORD-10" role="error" see="saip-3.4.1#8.1"
                  test="../preceding-sibling::ProfileElement/iot">
        PE-OPT-IOT shall come after the creation of PE-IoT.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="pe-cardinality">
    <sch:rule context="/ProfilePackage">
      <sch:assert id="SAIP-CARD-01" role="error" see="saip-3.4.1#8.1"
                  test="count(ProfileElement/mf) &lt;= 1">
        PE-MF may be provided at most once in a profile package.
      </sch:assert>
      <sch:assert id="SAIP-CARD-02" role="error" see="saip-3.4.1#8.1"
                  test="count(ProfileElement/iot) &lt;= 1">
        PE-IoT may be provided at most once in a profile package.
      </sch:assert>
      <sch:assert id="SAIP-CARD-03" role="error" see="saip-3.4.1#8.1"
                  test="count(ProfileElement/pukCodes) &lt;= 1">
        PE-PUKCodes may be provided at most once in a profile package.
      </sch:assert>

      <!--
        8.3.4.2 and 8.3.4.3: "This PE may be used only once after the creation of
        the MF". Both are anchored to the MF, and the MF is itself once per
        package by SAIP-CARD-01, so once-after-the-MF is once per package.
      -->
      <sch:assert id="SAIP-CARD-04" role="error" see="saip-3.4.1#8.3.4.2"
                  test="count(ProfileElement/cd) &lt;= 1">
        PE-CD may be provided at most once in a profile package.
      </sch:assert>

      <sch:assert id="SAIP-CARD-05" role="error" see="saip-3.4.1#8.3.4.3"
                  test="count(ProfileElement/telecom) &lt;= 1">
        PE-TELECOM may be provided at most once in a profile package.
      </sch:assert>

      <!-- 8.3.4.8.2: "This PE may be used only once after the PE-IoT", and
           PE-IoT is once per package by SAIP-CARD-02. -->
      <sch:assert id="SAIP-CARD-06" role="error" see="saip-3.4.1#8.3.4.8.2"
                  test="count(ProfileElement/opt-iot) &lt;= 1">
        PE-OPT-IoT may be provided at most once in a profile package.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    Thirteen further "only once" usage rules are deliberately absent, because
    they are not package-level. PE-PHONEBOOK, PE-GSM-ACCESS and the four DF PEs
    read "only once in the context of a USIM ADF"; the opt-* PEs read "once for
    each USIM / ISIM / CSIM application"; PE-EAP reads "once for each EAP
    method"; the NAA parameter PEs read "once after the creation of a NAA". A
    profile with two USIMs may legitimately carry two PE-DF-5GS, so counting
    those across the package would reject valid profiles. Checking them needs a
    per-ADF scope, which is the modelling contexts.sch approximates positionally
    and does not yet do by count.
  -->

</sch:schema>
