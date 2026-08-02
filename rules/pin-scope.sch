<?xml version="1.0" encoding="UTF-8"?>
<!--
  PIN scope, clause 8.5.1, and the IoT Minimal header ICCID, clause 8.2.1.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.5.1: "Within the PE-PINCodes sent in the context of the MF only global PIN
    key references shall be used. For PINs in any ADF/DF only local PINs shall be
    defined: secondPINAppl1 - secondPINAppl8."

    A PE-PINCodes belongs to exactly one PIN context, and each context admits
    only one of the two kinds. So whichever context this one is in, a mixture is
    wrong, and that is checkable without modelling where the context begins.
    Global references are pinAppl1 to pinAppl8 (1 to 8) and the administrative
    keys (10 to 14, 138 to 142); local ones are secondPINAppl1 to secondPINAppl8
    (129 to 136).

    Deciding *which* kind a given PE-PINCodes ought to hold needs the PIN context
    itself, which 8.1 fixes as "the first ADF/DF created by the previous PE".
    That is positional and modellable, and it is not modelled here.
  -->
  <sch:pattern id="pin-scope">
    <sch:rule context="/ProfilePackage/ProfileElement/pinCodes/pinCodes/pinconfig">
      <sch:let name="local" value="count(PINConfiguration[keyReference &gt;= 129
                                                         and keyReference &lt;= 136])"/>
      <sch:let name="global" value="count(PINConfiguration[keyReference &lt;= 14
                                                          or keyReference &gt;= 138])"/>

      <sch:assert id="SAIP-PIN-04" role="error" see="saip-3.4.1#8.5.1"
                  test="$local = 0 or $global = 0">
        One PE-PINCodes belongs to one PIN context, so it shall define either
        global PIN references or local ones, not both.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.2.1: "For IoT Minimal Profiles, the eUICC shall use this value as the
    default content for EF-ICCID. It shall be encoded non-swapped as per ITU
    E.118 representation and padded with 'F' if less digits are used (Example:
    8947010000123456784F)."

    Padding sits at the end by definition, so an 'F' followed by a digit is not
    padding and the value is not an E.118 representation. The check walks from
    the first 'F': everything after it must also be 'F'.

    This applies only to the IoT Minimal header, since the same clause says the
    Full Profile value "is not used by the eUICC".
  -->
  <sch:pattern id="iot-iccid-padding">
    <sch:rule context="/ProfilePackage/ProfileElement/header[iotOptions]/iccid">
      <sch:let name="d" value="translate(normalize-space(.), ' ', '')"/>

      <sch:assert id="SAIP-ICC-01" role="error" see="saip-3.4.1#8.2.1"
                  test="not(contains($d, 'F'))
                        or translate(substring($d,
                              string-length(substring-before($d, 'F')) + 1),
                              'F', '') = ''">
        The ICCID of an IoT Minimal Profile is an ITU E.118 representation
        padded with 'F', so any 'F' shall be trailing padding.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
