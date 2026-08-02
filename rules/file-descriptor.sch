<?xml version="1.0" encoding="UTF-8"?>
<!--
  File control parameters against ETSI TS 102 222, the document SAIP delegates
  their coding to.

  This file exists because that document became available. It does not do what
  was expected of it: SAIP's file classification hangs on byte 1 of the File
  Descriptor, and TS 102 222 does not define that byte either. Both of its
  tables say "The File Descriptor Byte shall be coded as defined in ETSI TS 102
  221", so the ADF/DF/EF discrimination noted in generic-file-management.sch is
  still open, and still for the same kind of reason, one document further along.

  What it does define is everything around that byte, and those are the rules
  below. All seven hold across the 984 file descriptors in the published
  profiles, which is the widest evidence any rule in this project has.

  Byte values are matched on hex digits rather than arithmetic. XPath 1.0 has no
  bitwise operators, but a constraint on the low bits of a byte is a constraint
  on its last hex digit, which substring can read directly.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    Table 3 gives the File Descriptor of a DF or ADF length '02'; Table 4 gives an
    EF's length "'02' or '04'", the longer form carrying the record length of a
    linear fixed or cyclic file. Three bytes is not a case in either table, though
    SAIP's own module admits it: the field is declared OCTET STRING (SIZE(2..4)),
    so this rule is tighter than the ASN.1 and catches what the ASN.1 lets past.

    The context excludes elements with children, because SAIP names the CHOICE
    alternative that carries a whole Fcp "fileDescriptor" as well, and only the
    octet string is meant here.
  -->
  <sch:pattern id="file-descriptor-length">
    <sch:rule context="/ProfilePackage//fileDescriptor[not(*)]">
      <sch:let name="h" value="translate(normalize-space(.), ' ', '')"/>

      <sch:assert id="SAIP-FD-01" role="error" see="ts-102-222#6.3.2.2"
                  test="string-length($h) = 4 or string-length($h) = 8">
        A File Descriptor shall be two bytes, or four when it carries the record
        length of a linear fixed or cyclic file.
      </sch:assert>

      <!--
        Both tables fix the second byte: "The data coding byte can be used
        differently according to ISO/IEC 7816-4. For the present document, the
        value '21' (proprietary) shall be used and shall not be interpreted by
        the UICC."
      -->
      <sch:assert id="SAIP-FD-02" role="error" see="ts-102-222#6.3.2.2"
                  test="substring($h, 3, 2) = '21'">
        The data coding byte of a File Descriptor shall be '21'.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    Table 4, tag '88': "The Short File Identifier is coded from bits b8 to b4.
    Bits b3,b2,b1 = 000." Three low bits clear means the last hex digit is 0 or 8.
  -->
  <sch:pattern id="short-efid-coding">
    <sch:rule context="/ProfilePackage//shortEFID[normalize-space(.) != '']">
      <sch:let name="h" value="translate(normalize-space(.), ' abcdef', 'ABCDEF')"/>

      <sch:assert id="SAIP-FD-03" role="error" see="ts-102-222#6.3.2.2.2"
                  test="substring($h, string-length($h)) = '0'
                        or substring($h, string-length($h)) = '8'">
        A Short File Identifier is coded in bits b8 to b4, so its three low bits
        shall be zero.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    Table 5 lists every defined Special File Information byte, and in all four
    rows bits b6 to b1 are zero; anything else is marked RFU. Six low bits clear
    means the last hex digit is 0 and the first is one of 0, 4, 8 or C.
  -->
  <sch:pattern id="special-file-information">
    <sch:rule context="/ProfilePackage//specialFileInformation[normalize-space(.) != '']">
      <sch:let name="h" value="translate(normalize-space(.), ' abcdef', 'ABCDEF')"/>

      <sch:assert id="SAIP-FD-04" role="error" see="ts-102-222#6.3.2.2.2"
                  test="substring($h, 2, 1) = '0'
                        and (substring($h, 1, 1) = '0' or substring($h, 1, 1) = '4'
                             or substring($h, 1, 1) = '8' or substring($h, 1, 1) = 'C')">
        Only bits b8 and b7 of the Special File Information are defined; the
        remaining bits are reserved and shall be zero.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    Table 4a, Note 1: "Tag 'C1' and Tag 'C2' shall not be both present within the
    same command. Tag 'C1' and 'C2' are not applicable in case of BER TLV
    structured EF." Note 3: tag '84', the File Details, "shall only be present
    for BER TLV structured EFs, for which it is mandatory". Note 2 says the same
    of tag '86', the Maximum File Size, except that it is optional there, so its
    presence identifies a BER-TLV file and its absence proves nothing.

    SAIP states the first of these itself, in the comment above ProprietaryInfo:
    "only one of the parameters may be present".
  -->
  <sch:pattern id="proprietary-info-consistency">
    <sch:rule context="/ProfilePackage//proprietaryEFInfo">
      <sch:assert id="SAIP-FD-05" role="error" see="ts-102-222#6.3.2.2.2"
                  test="not(fillPattern and repeatPattern)">
        A filling pattern and a repeat pattern shall not both be present.
      </sch:assert>

      <sch:assert id="SAIP-FD-06" role="error" see="ts-102-222#6.3.2.2.2"
                  test="not(maximumFileSize) or fileDetails">
        A BER-TLV structured EF shall carry the File Details.
      </sch:assert>

      <sch:assert id="SAIP-FD-07" role="error" see="ts-102-222#6.3.2.2.2"
                  test="not(maximumFileSize) or not(fillPattern or repeatPattern)">
        Filling and repeat patterns do not apply to a BER-TLV structured EF.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
