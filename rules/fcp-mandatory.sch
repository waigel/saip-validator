<?xml version="1.0" encoding="UTF-8"?>
<!--
  Parameters an FCP must carry for its context, clause 8.3.3.

  Its companion file fcp-context.sch takes the F cells of the same table. This
  one takes the cells marked "M/C (See Note 4)", where Note 4 resolves the
  ambiguity that kept the M and C cells out of that file: "These parameters are
  mandatory for Full Profiles and conditional for IoT Minimal Profiles."

  So for a Full Profile these are plain obligations, and every rule here is
  guarded on the package being one. The guard uses the same discriminator as
  SAIP-IOT-01 in composition.sch, the Profile Header's iotOptions, rather than
  inventing a second way to tell the two package types apart.

  Annex A states the ADF obligation a second time and from the other side: the
  Parameters column of ADF USIM, ADF ISIM, ADF CSIM and ADF SSIM reads "AID,
  Temporary FID, pinStatusTemplateDO". Those name the same three fields. 8.3.2
  says which is which: dfName is the AID and carries the note "Only applies for
  ADFs", and fileID "is a temporary value (named temporary file ID in this
  document)". SAIP-TPP-01 checks the pinStatusTemplateDO of that triple from the
  template side; the AID and Temporary FID are checked here.

  All four published profiles are Full Profiles and satisfy every rule below:
  3 ADFs and 8 DFs each, none missing any of these fields.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">

  <sch:pattern id="fcp-mandatory-adf">
    <sch:rule context="/ProfilePackage//*[starts-with(local-name(), 'adf-')]/fileDescriptor">
      <sch:let name="full" value="not(/ProfilePackage/ProfileElement/header/iotOptions)"/>

      <sch:assert id="SAIP-FCP-10" role="error" see="saip-3.4.1#8.3.3"
                  test="not($full) or fileID">
        The FCP of an ADF in a Full Profile shall carry a fileID, the temporary
        file ID that Annex A calls the Temporary FID.
      </sch:assert>

      <sch:assert id="SAIP-FCP-11" role="error" see="saip-3.4.1#8.3.3"
                  test="not($full) or dfName">
        The FCP of an ADF in a Full Profile shall carry a dfName, the AID.
      </sch:assert>

      <sch:assert id="SAIP-FCP-12" role="error" see="saip-3.4.1#8.3.3"
                  test="not($full) or pinStatusTemplateDO">
        The FCP of an ADF in a Full Profile shall carry a pinStatusTemplateDO.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!--
    The DF column marks only pinStatusTemplateDO with Note 4. fileID is a plain
    C there, which the table's own legend says "may always be provided", so it
    is not asserted.
  -->
  <sch:pattern id="fcp-mandatory-df">
    <sch:rule context="/ProfilePackage//*[starts-with(local-name(), 'df-')
                                          or local-name() = 'mf']/fileDescriptor">
      <sch:assert id="SAIP-FCP-13" role="error" see="saip-3.4.1#8.3.3"
                  test="/ProfilePackage/ProfileElement/header/iotOptions
                        or pinStatusTemplateDO">
        The FCP of a DF in a Full Profile shall carry a pinStatusTemplateDO.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
