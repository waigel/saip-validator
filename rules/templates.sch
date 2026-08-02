<?xml version="1.0" encoding="UTF-8"?>
<!--
  Template identifiers, against the assigned list.

  Annex B is normative and enumerates every OID this specification assigns under
  the Trusted Connectivity Alliance branch. A templateID outside it names a
  template that does not exist, which the eUICC cannot resolve.

  The list is transcribed from Annex B of version 3.4.1 and is therefore
  version-bound: a later specification assigns more OIDs, and this rule will
  reject them until the list is extended. Rejecting an unknown template is the
  intended failure; passing one silently would be worse. It does mean this file
  needs revisiting with each new specification version.

  XPath 1.0 has no sequence membership, so the list is a delimited string and the
  test is a containment check. The delimiters matter: without them 2.23.143.1.2.1
  would also match inside 2.23.143.1.2.13.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="template-oids">
    <sch:let name="assigned" value="' 2.23.143.1.2.1 2.23.143.1.2.2 2.23.143.1.2.3 2.23.143.1.2.3.2 2.23.143.1.2.3.3 2.23.143.1.2.4 2.23.143.1.2.4.2 2.23.143.1.2.5 2.23.143.1.2.5.2 2.23.143.1.2.5.3 2.23.143.1.2.5.4 2.23.143.1.2.6 2.23.143.1.2.7 2.23.143.1.2.8 2.23.143.1.2.9 2.23.143.1.2.9.2 2.23.143.1.2.9.3 2.23.143.1.2.10 2.23.143.1.2.10.2 2.23.143.1.2.11 2.23.143.1.2.11.2 2.23.143.1.2.12 2.23.143.1.2.13 2.23.143.1.2.13.2 2.23.143.1.2.13.3 2.23.143.1.2.13.4 2.23.143.1.2.14 2.23.143.1.2.15 2.23.143.1.2.15.2 2.23.143.1.2.16 2.23.143.1.2.16.2 2.23.143.1.2.17 2.23.143.1.2.18 2.23.143.1.2.19 '"/>

    <sch:rule context="/ProfilePackage//templateID">
      <sch:assert id="SAIP-TPL-01" role="error" see="saip-3.4.1#Annex-B"
                  test="contains($assigned, concat(' ', normalize-space(.), ' '))">
        A templateID shall be one of the OIDs assigned in Annex B.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
