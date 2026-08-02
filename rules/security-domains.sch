<?xml version="1.0" encoding="UTF-8"?>
<!--
  Security domains, clause 8.6.

  Two of these rules turn on which security domain is the MNO-SD. 8.6.2 settles
  that without ambiguity: "The first SD within the sequence of the Profile
  Package shall be categorized as the MNO-SD by definition." So the MNO-SD is
  positional, and a rule can name it by position rather than by inspecting
  privileges.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.6.2: the MNO-SD "shall be installed before any other SD, before any RFM
    Parameters are set or before any applications are created". Clause 8.1
    states the same from the other side: PE-RFM "shall be provided after the
    creation of the SDs", PE-Application "after the creation of the SD the
    application will be associated to".

    Which SD an application belongs to is not decidable from position alone, so
    these assert only what is: some security domain precedes.
  -->
  <sch:pattern id="sd-before-dependents">
    <sch:rule context="/ProfilePackage/ProfileElement/rfm">
      <sch:assert id="SAIP-SD-01" role="error" see="saip-3.4.1#8.6.2"
                  test="../preceding-sibling::ProfileElement/securityDomain">
        PE-RFM shall come after the creation of a security domain.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement/application">
      <sch:assert id="SAIP-SD-02" role="error" see="saip-3.4.1#8.6.2"
                  test="../preceding-sibling::ProfileElement/securityDomain">
        PE-Application shall come after the creation of a security domain.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.6.3: "Each key to be personalised must be listed only once. This means
    there shall be no keys with same keyIdentifier and keyVersionNumber listed
    twice." The pair is what must be unique, not either half.
  -->
  <sch:pattern id="key-uniqueness">
    <sch:rule context="/ProfilePackage/ProfileElement//keyList/KeyObject">
      <sch:assert id="SAIP-SD-03" role="error" see="saip-3.4.1#8.6.3"
                  test="not(preceding-sibling::KeyObject[
                              keyIdentifier = current()/keyIdentifier
                              and keyVersionNumber = current()/keyVersionNumber])">
        No two keys in one key list shall share a keyIdentifier and
        keyVersionNumber.
      </sch:assert>
    </sch:rule>

    <!--
      8.6.3: "Each keyCompontents shall be specified only once per key (e.g.,
      including two times the same keyType within one KeyObject will lead to an
      error)."
    -->
    <sch:rule context="/ProfilePackage/ProfileElement//KeyObject/keyCompontents/SEQUENCE">
      <sch:assert id="SAIP-SD-04" role="error" see="saip-3.4.1#8.6.3"
                  test="not(keyType = preceding-sibling::SEQUENCE/keyType)">
        A key component type shall be specified at most once per key.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.6.6 and 8.6.7 each grant a parameter to the MNO-SD alone: "Only the
    PE-SecurityDomain that instantiates the MNO-SD may include the
    openPersoData parameter, this parameter is forbidden for the other Security
    Domains", and the same sentence for catTpParameters. Combined with 8.6.2's
    definition of the MNO-SD as the first SD, the test is positional.
  -->
  <sch:pattern id="mno-sd-only-parameters">
    <sch:rule context="/ProfilePackage/ProfileElement/securityDomain[openPersoData]">
      <sch:assert id="SAIP-SD-05" role="error" see="saip-3.4.1#8.6.6"
                  test="not(../preceding-sibling::ProfileElement/securityDomain)">
        openPersoData is permitted only in the security domain that
        instantiates the MNO-SD, which is the first one in the package.
      </sch:assert>
    </sch:rule>

    <sch:rule context="/ProfilePackage/ProfileElement/securityDomain[catTpParameters]">
      <sch:assert id="SAIP-SD-06" role="error" see="saip-3.4.1#8.6.7"
                  test="not(../preceding-sibling::ProfileElement/securityDomain)">
        catTpParameters are permitted only in the security domain that
        instantiates the MNO-SD, which is the first one in the package.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
