<?xml version="1.0" encoding="UTF-8"?>
<!--
  Application loading and installation, clause 8.7.

  Neither rule here fires on the four published profiles: none of them extradites
  an application. That is what the "N of M assertions evaluated" line in the
  report exists to say, and it is why a clean corpus run is evidence of no false
  positives rather than of coverage.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <!--
    8.7.3: "For the MNO-SD instance, no value shall be provided for the
    extraditeSecurityDomainAID parameter: the MNO-SD shall be associated with
    itself and shall not be subject to extradition."

    8.6.2 fixes which one the MNO-SD is: the first security domain in the
    package.
  -->
  <sch:pattern id="mno-sd-extradition">
    <sch:rule context="/ProfilePackage/ProfileElement/securityDomain/instance/extraditeSecurityDomainAID">
      <sch:assert id="SAIP-APP-01" role="error" see="saip-3.4.1#8.7.3"
                  test="../../../preceding-sibling::ProfileElement/securityDomain">
        The MNO-SD shall be associated with itself, so its instance shall carry
        no extraditeSecurityDomainAID.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    8.7.3: "An application (or SD) shall only be associated to an SD in Life
    Cycle State PERSONALIZED." PERSONALIZED is '0F' in the Security Domain Life
    Cycle Coding of GlobalPlatform's Table 11-5.

    The condition is guarded on the named security domain being defined in this
    package: a profile may legitimately extradite to a domain that already
    exists on the card, and this validator sees only the package. Where the
    domain is present, its state is checkable, and an absent lifeCycleState
    means the '07' SELECTABLE default rather than PERSONALIZED.
  -->
  <sch:pattern id="extradition-target-state">
    <sch:rule context="/ProfilePackage/ProfileElement//extraditeSecurityDomainAID">
      <sch:let name="target"
               value="/ProfilePackage/ProfileElement/securityDomain/instance[
                        normalize-space(instanceAID) = normalize-space(current())]"/>

      <sch:assert id="SAIP-APP-02" role="error" see="saip-3.4.1#8.7.3"
                  test="not($target) or normalize-space($target/lifeCycleState) = '0F'">
        A security domain named for extradition and defined in this package
        shall be in Life Cycle State PERSONALIZED.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
