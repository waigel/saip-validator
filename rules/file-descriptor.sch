<?xml version="1.0" encoding="UTF-8"?>
<!--
  File control parameters against ETSI TS 102 222, the document SAIP delegates
  their coding to.

  This file exists because those documents became available. TS 102 222 defines
  everything around the File Descriptor byte but not the byte itself; both of its
  tables defer with "The File Descriptor Byte shall be coded as defined in ETSI
  TS 102 221", and Table 11.5 of that document supplies it.

  Every rule here holds across the 984 file descriptors in the published
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
      <sch:let name="h" value="translate(normalize-space(.), 'abcdef ', 'ABCDEF')"/>

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
      <sch:let name="h" value="translate(normalize-space(.), 'abcdef ', 'ABCDEF')"/>

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

  <!--
    Table 11.5 of TS 102 221 enumerates the File Descriptor byte. Bit b8 set is
    RFU outright. Below it, bits b6 to b4 give the file type and b3 to b1 the EF
    structure, and most combinations of the two are marked RFU: a working or
    internal EF, types 000 and 001, may be structureless, transparent, linear
    fixed or cyclic; type 111 is a DF or ADF when the structure bits are 000 and
    a BER-TLV EF when they are 001; types 010 to 110 are reserved throughout.

    Bit b7, shareable or not, is free, so each defined coding appears twice, with
    and without '40'. Twenty values in all, which is short enough to test by
    containment rather than by taking the byte apart.

    The corpus uses five of them: '41' transparent, '42' linear fixed, '46'
    cyclic, '78' DF or ADF, and '79' BER-TLV.
  -->
  <sch:pattern id="file-descriptor-coding">
    <sch:let name="defined" value="' 00 01 02 06 08 09 0A 0E 38 39 40 41 42 46 48 49 4A 4E 78 79 '"/>

    <sch:rule context="/ProfilePackage//fileDescriptor[not(*)][normalize-space(.) != '']">
      <sch:let name="b1" value="substring(translate(normalize-space(.), 'abcdef ', 'ABCDEF'), 1, 2)"/>

      <sch:assert id="SAIP-FD-08" role="error" see="ts-102-221#11.1.1.4.3"
                  test="contains($defined, concat(' ', $b1, ' '))">
        The File Descriptor byte shall be one of the codings defined in Table
        11.5; the rest of the range is reserved.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    TS 102 222 makes the record length conditional, "Mandatory for linear fixed
    and cyclic files, otherwise it is not applicable", and TS 102 221 says the
    same from the reading side. So the four-byte form and a record structure
    imply one another, and either without the other is an error.

    The structure is bits b3 to b1, which are the low three bits of the last hex
    digit of the byte: digits 2 and A carry linear fixed, 6 and E carry cyclic.

    In the corpus the correspondence is exact, 616 two-byte descriptors with no
    record structure and 368 four-byte ones with it, links included.
  -->
  <sch:pattern id="record-length-presence">
    <sch:rule context="/ProfilePackage//fileDescriptor[not(*)][normalize-space(.) != '']">
      <sch:let name="h" value="translate(normalize-space(.), 'abcdef ', 'ABCDEF')"/>
      <sch:let name="rec" value="contains(' 2 6 A E ', concat(' ', substring($h, 2, 1), ' '))"/>

      <sch:assert id="SAIP-FD-09" role="error" see="ts-102-222#6.3.2.2.2"
                  test="(string-length($h) = 8 and $rec)
                        or (string-length($h) = 4 and not($rec))">
        A record length shall be present for a linear fixed or cyclic file and
        absent for every other structure.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
