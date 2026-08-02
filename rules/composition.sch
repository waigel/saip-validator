<?xml version="1.0" encoding="UTF-8"?>
<!--
  Composition of the ProfileElement sequence: which elements a package holds,
  in what order, and which combinations the specification forbids.

  Rule ids are opaque on purpose: the clause lives in @see alone, so a
  renumbering of the specification cannot invalidate an id that reports,
  tests and bug trackers already cite.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="profile-header">
    <sch:rule context="/ProfilePackage">
      <sch:let name="headers" value="count(ProfileElement/header)"/>

      <sch:assert id="SAIP-HDR-01" role="error" see="saip-3.4.1#8.2.1"
                  test="$headers = 1">
        A profile package shall contain exactly one Profile Header.
      </sch:assert>

      <sch:assert id="SAIP-HDR-02" role="error" see="saip-3.4.1#8.2.1"
                  test="not($headers = 1) or ProfileElement[1]/header">
        The Profile Header shall be the first ProfileElement.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.10 says the end PE "shall be used as the last element of the Profile
    Package", which carries both a presence and a position requirement. They
    are separate assertions because they fail for different reasons, and a
    reader fixing one should not be told about the other.
  -->
  <sch:pattern id="profile-end">
    <sch:rule context="/ProfilePackage">
      <sch:let name="ends" value="count(ProfileElement/end)"/>

      <sch:assert id="SAIP-END-01" role="error" see="saip-3.4.1#8.10"
                  test="$ends = 1">
        A profile package shall contain exactly one PE-End.
      </sch:assert>

      <sch:assert id="SAIP-END-02" role="error" see="saip-3.4.1#8.10"
                  test="not($ends = 1) or ProfileElement[last()]/end">
        The PE-End shall be the last ProfileElement.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.1.3: "The identification field shall be unique and is used to identify a
    PE within the Profile." The context sits on the offending element, so the
    report points at it rather than at the package as a whole.

    The Profile Header carries no PE header and therefore no identification; it
    is simply absent from this rule's context, which is correct. The only other
    identification in the schema belongs to PEStatus, an eUICC *response*, which
    never appears inside a profile package.
  -->
  <sch:pattern id="pe-identification">
    <sch:rule context="/ProfilePackage/ProfileElement//identification">
      <sch:assert id="SAIP-PEID-01" role="error" see="saip-3.4.1#8.1.3"
                  test="not(. = preceding::identification)">
        The identification of a ProfileElement shall be unique within the
        profile package.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    7.4 and 7.5 describe two package types, told apart by whether the Profile
    Header carries iotOptions, and each forbids what belongs to the other.
  -->
  <sch:pattern id="package-type">
    <sch:rule context="/ProfilePackage">
      <sch:let name="iot" value="count(ProfileElement/header/iotOptions)"/>

      <sch:assert id="SAIP-IOT-01" role="error" see="saip-3.4.1#7.4"
                  test="$iot &gt; 0 or not(ProfileElement/iot or ProfileElement/opt-iot)">
        A Full Profile Package, whose header carries no iotOptions, shall
        contain neither PE-IoT nor PE-OPT-IoT.
      </sch:assert>

      <sch:assert id="SAIP-IOT-02" role="error" see="saip-3.4.1#7.5"
                  test="$iot = 0 or ProfileElement/iot">
        An IoT Minimal Profile Package, whose header carries iotOptions, shall
        define its file system using at least one PE-IoT.
      </sch:assert>

      <sch:assert id="SAIP-IOT-03" role="error" see="saip-3.4.1#7.5"
                  test="$iot = 0 or not(ProfileElement/mf)">
        An IoT Minimal Profile Package shall not contain a PE-MF.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
