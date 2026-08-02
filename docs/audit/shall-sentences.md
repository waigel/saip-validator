# Every "shall" in the specification, and what became of it

This is the audit behind the claim that the rule set covers clause 7 through
clause 15. It exists because "I have read the specification" is not a checkable
statement and "the suite is green" says nothing about coverage.

Every sentence containing "shall" was extracted from *eUICC Profile Package:
Interoperable Format* v3.4.1, attributed to its clause, and given one of the
dispositions below. There are **265** of them and none is unaccounted for.

Nothing in this document is listed as checkable-but-unchecked. The two entries
that once were, the PIN references packed into a `pinStatusTemplateDO`, are now
SAIP-PIN-08 and SAIP-PIN-09. They had been set aside on the grounds that XPath
1.0 cannot convert hex to decimal, which was the wrong way round: the conversion
only has to run from the decimal `keyReference` to its hex form, and
PINKeyReferenceValue is a closed enumeration of 26 values, so the rule is a fixed
conjunction rather than a loop.

Two dispositions deserve care when reading. *Describes the eUICC* is the largest
group by far, and that is expected: most of clause 8.10 and 12.2 tells a card how
to respond, which no profile validator can or should enforce. *Not decidable from
the package* is where the honest limits are: the obligation is real and this tool
cannot see enough to judge it.

The extraction is mechanical, so a sentence split oddly by the PDF's line
breaking may appear truncated. The clause number is the anchor to go back to.

## Summary

| Disposition | Count |
| --- | ---: |
| Mapped to a rule | 71 |
| Not decidable from the package | 18 |
| Needs a referenced document | 19 |
| Describes the eUICC, not the package | 144 |
| Table legend | 9 |
| Descriptive | 4 |
| **Total** | **265** |

## Mapped to a rule (71)

Each of these is checked. The rule ids are the ones the report prints.

| Clause | Sentence | Rule |
| --- | --- | --- |
| 4.5.7.10 | */ mobileIPAuthenticationData OCTET STRING (SIZE (5..957)) OPTIONAL } -- ASN1STOP Usage rules: This PE shall be used once after the creation of a NAA using CAVE authentication algorithm (... | SAIP-NAA-02, SAIP-SCP-10 |
| 7.1 | An identification number shall be associated with every PE. | SAIP-PEID-02 |
| 7.4 | For Full Profiles, the Profile header shall not include the iotOptions. | SAIP-IOT-01 |
| 7.5 | For IoT Minimal Profiles, the Profile header shall include the iotOptions. | SAIP-IOT-02 |
| 7.5 | The file system shall be defined using, at least, the PE-IoT. | SAIP-IOT-02, SAIP-CARD-02 |
| 8.1.3 | The "identification" field shall be unique and is used to identify a PE within the Profile. | SAIP-PEID-01 |
| 8.1.3 | The following rules shall be considered by the Profile Creator: ProfileHeader Shall be the first element and provided once within a Profile download only. | SAIP-HDR-01, SAIP-HDR-02 |
| 8.1.3 | If this PE is not used, the MF shall be created as the first element of the file system using the "PE- GenericFileManagement" in a Full Profile. | SAIP-CARD-07 |
| 8.1.3 | PE-CD The use of this PE is optional and shall come after the creation of the MF. | SAIP-ORD-11 |
| 8.1.3 | PE-TELECOM The use of this PE is optional and shall come after the creation of the MF. | SAIP-ORD-12 |
| 8.1.3 | PE-USIM The use of this PE is optional and shall come after the creation of the MF. | SAIP-ORD-13 |
| 8.1.3 | PE-OPT-USIM The use of this PE is optional and shall come after the creation of an ADF USIM. | SAIP-ORD-01, SAIP-SCP-07 |
| 8.1.3 | PE-ISIM The use of this PE is optional and shall come after the creation of the MF. | SAIP-ORD-14 |
| 8.1.3 | PE-OPT-ISIM The use of this PE is optional and shall come after the creation of an ADF ISIM. | SAIP-ORD-02, SAIP-SCP-08 |
| 8.1.3 | PE-SSIM The use of this PE is optional and shall come after the creation of the MF. | SAIP-ORD-16 |
| 8.1.3 | PE-GSM-ACCESS The use of this PE is optional and shall come after the creation of an ADF USIM. | SAIP-ORD-04, SAIP-SCP-02 |
| 8.1.3 | PE-PHONEBOOK The use of this PE is optional and shall come after the creation of an ADF USIM. | SAIP-ORD-05, SAIP-SCP-01 |
| 8.1.3 | PE-DF-5GS The use of this PE is optional and shall come after the creation of an ADF USIM. | SAIP-ORD-06, SAIP-SCP-03 |
| 8.1.3 | PE-DF-SAIP The use of this PE is optional and shall come after the creation of an ADF USIM. | SAIP-ORD-07, SAIP-SCP-04 |
| 8.1.3 | PE-DF-SNPN The use of this PE is optional and shall come after the creation of an ADF USIM. | SAIP-ORD-08, SAIP-SCP-05 |
| 8.1.3 | PE-DF-5GPROSE The use of this PE is optional and shall come after the creation of an ADF USIM. | SAIP-ORD-09, SAIP-SCP-06 |
| 8.1.3 | PE-CSIM The use of this PE is optional and shall come after the creation of the MF. | SAIP-ORD-15 |
| 8.1.3 | Enabling trust in a connected future 18 PE-OPT-CSIM The use of this PE is optional and shall come after the creation of an ADF CSIM. | SAIP-ORD-03, SAIP-SCP-09 |
| 8.1.3 | PE-IoT Shall be provided once as the first element of the file system after the "ProfileHeader" in an IoT Minimal Profile and shall not be used in a Full Profile. | SAIP-IOT-02, SAIP-CARD-02 |
| 8.1.3 | PE-OPT-IoT The use of this PE is optional and shall come after PE-IoT. | SAIP-ORD-10 |
| 8.1.3 | PE-AKAParameter If this PE is provided, it shall be present in the context of the creation of a NAA filesystem. | SAIP-NAA-01 |
| 8.1.3 | In the context of the SSIM, only one occurrence of either PE-SSIM- EAPTLSParameters or PE-AKAParameter shall be provided. | SAIP-NAA-05 |
| 8.1.3 | PE-SSIM-EAPTLSParameters If this PE is provided, it shall be present in the context of the creation of an SSIM filesystem when EAP-TLS authentication is required. | SAIP-NAA-03 |
| 8.1.3 | Only one occurrence of either PE-SSIM-EAPTLSParameters or PE-AKAParameter shall be provided per SSIM. | SAIP-NAA-05 |
| 8.1.3 | PE-PINCodes PIN codes shall be created in the context according to their scope. | SAIP-PIN-05, SAIP-PIN-06 |
| 8.1.3 | PE-EAP The use of this PE is optional and shall come after creation of the ADF that supports the EAP feature. | SAIP-NAA-04 |
| 8.1.3 | PE-PINCode and "pinStatusTemplateDO" usage rules: • All the Global PINs referenced by a "pinStatusTemplateDO" shall be defined in the "PIN Context" of the MF. | SAIP-PIN-08 |
| 8.1.3 | • All the Local PINs referenced by a "pinStatusTemplateDO" shall either be defined in a parent ADF or DF or created in a following PE-PINCodes. | SAIP-PIN-09 |
| 8.2.1 | Usage rules: This PE shall be used once and shall be the first PE of the Profile Package. | SAIP-HDR-01, SAIP-HDR-02 |
| 8.3.1 | In that case, these values shall be provided in the Profile. | SAIP-TPP-01 |
| 8.3.2 | The "pinStatusTemplateDO" shall contain only a list of PIN Key Reference values coded according to table 9.3 of ETSI TS 102 221 [102 221] and used within the ADF/DF. | SAIP-FCP-14 |
| 8.3.2 | It shall not contain the full data object as defined in ETSI TS 102 221 [102 221] (e.g., '01810A'H as a typical value for an ADF_USIM). | SAIP-FCP-14 |
| 8.3.2 | For BER-TLV files, the list of TLVs defined shall be part of one or more "fillFileContent" parameters with these constraints: • All TLVs shall be concatenated. | SAIP-FCP-15 |
| 8.3.2 | "fillFileOffset" shall not be used. | SAIP-FCP-15 |
| 8.3.3 | F: Forbidden These parameters shall not be provided within the FCP since they are invalid within the respective context. | SAIP-FCP-01..09 |
| 8.3.4 | Usage rules: If this PE is required it shall be used only once in the context of a USIM ADF. | SAIP-SCP-01..06 |
| 8.3.4 | -- ASN1START PE-DF-SNPN ::= SEQUENCE { df-snpn-header PEHeader, templateID OBJECT IDENTIFIER, df-df-snpn File, ef-pws-snpn File OPTIONAL, ef-nid File OPTIONAL } -- ASN1STOP Usage rules: I... | SAIP-SCP-01..06 |
| 8.3.5 | F Forbidden This parameter shall not be provided within the respective context. | SAIP-GFM-05..07 |
| 8.3.5 | It shall be the first element of the file system creation in case it is used to create the MF instead of using PE-MF. | SAIP-CARD-07 |
| 8.4.2 | Key size: The "key" OBJECT STRING shall have a length of 16 bytes in case of the Milenage or usim-test-algorithm and 16 or 32 bytes in case of the TUAK algorithm. | SAIP-AKA-01, SAIP-AKA-02 |
| 8.4.2 | OPc size: The "opc" OBJECT STRING shall have a size of 16 bytes in case of the Milenage and 32 bytes in case of the TUAK algorithm. | SAIP-AKA-03, SAIP-AKA-04 |
| 8.4.2 | "ssimParameters" shall be provided only in the context of SSIM. | SAIP-AKA-05 |
| 8.4.2 | Enabling trust in a connected future 50 Usage rules: This PE shall be used once after the creation of a NAA using Milenage or TUAK authentication algorithm (e.g., USIM, ISIM or CSIM using... | SAIP-NAA-01 |
| 8.4.4 | Usage rules: This PE shall be used once after the creation of a SSIM NAA. | SAIP-NAA-03, SAIP-NAA-05 |
| 8.5.1 | Within the PE-PINCodes sent in the context of the MF only global PIN key references shall be used. | SAIP-PIN-05 |
| 8.5.1 | For PINs in any ADF/DF only local PINs shall be defined: secondPINAppl1 – secondPINAppl8. | SAIP-PIN-06 |
| 8.5.1 | In case a PUKKeyReferenceValue is defined the related PUKKeyReferenceValue shall exist within the PE-PUKCodes list. | SAIP-PIN-01 |
| 8.5.1 | The ADF/DF where the PIN will be created shall be the first ADF or DF created by the previous PE-Template or the previous PE-Generic File Management that contains an ADF/DF. | SAIP-PIN-05, SAIP-PIN-06 |
| 8.5.1 | The use of this PE shall be unique for one "PIN Context". | SAIP-PIN-07 |
| 8.5.1 | Exceptionally, for IoT Minimal Profile, the "PIN Context" after the use of PE IoT shall be set to ADF USIM instead of the MF. | SAIP-PIN-06 |
| 8.5.2 | This PE shall be used during the file system creation right after the creation of the MF in case of a Full Profile Package. | SAIP-PUK-02 |
| 8.5.2 | In case of an IoT Minimal Profile Package, if used, it shall be placed right after the Profile header. | SAIP-PUK-02 |
| 8.5.2 | The use of this PE shall be unique. | SAIP-CARD-03 |
| 8.5.2 | Usage rules: For Full Profiles, this PE shall be used only once in the Profile Package, right after the creation of the MF. | SAIP-PUK-02 |
| 8.6.2 | The MNO-SD shall be installed before any other SD, before any RFM Parameters are set or before any applications are created. | SAIP-SD-01, SAIP-SD-02 |
| 8.6.2 | The first SD within the sequence of the Profile Package shall be categorized as the MNO-SD by definition and shall be installed with the special MNO-SD privileges defined by the GSMA [GS ... | SAIP-SD-01, SAIP-SD-02 |
| 8.6.3 | This means there shall be no keys with same "keyIdentifier" and "keyVersionNumber" listed twice. | SAIP-SD-03 |
| 8.6.3 | Each "keyCompontents" shall be specified only once per key (e.g., including two times the same "keyType" within one "KeyObject" will lead to an error). | SAIP-SD-04 |
| 8.7.1 | Usage rules: This PE shall be used after the security domain to which the application instance is associated to is created by using PE-SecurityDomain. | SAIP-SD-02 |
| 8.7.3 | An application (or SD) shall only be associated to an SD in Life Cycle State PERSONALIZED. | SAIP-APP-02 |
| 8.7.3 | For the MNO-SD instance, no value shall be provided for the "extraditeSecurityDomainAID" parameter: the Enabling trust in a connected future 62 MNO-SD shall be associated with itself and ... | SAIP-APP-01 |
| 8.8 | "tarList" shall include at least one TAR if available. | SAIP-RFM-03 |
| 8.8 | In case "tarList" is not available the TAR value defined within bytes 13-15 of the "instanceAID" shall be used. | SAIP-RFM-01 |
| 8.10 | -- ASN1START PE-End ::= SEQUENCE { end-header PEHeader } -- ASN1STOP Usage rules: This PE shall be used as the last element of the Profile Package. | SAIP-END-01, SAIP-END-02 |
| 9.1 | • Parameters: Indicates the parameters that shall be provided by the Profile Creator when referencing the template in the Profile Package in addition to those listed in section 8.3.3. | SAIP-TPP-01, SAIP-FCP-10..13 |
| 11.2.4 | Only one method shall be present in a real Profile Package. | SAIP-CARD-07 |

## Not decidable from the package (18)

The obligation is real, but answering it needs something the package does not carry.

| Clause | Sentence | Note |
| --- | --- | --- |
| 3.2 | In any case, these words shall be considered by the Profile Creator to prevent interoperability issues and ensure the loading of a functional Profile. | not decidable from the package alone |
| 7.3 | Proprietary tags shall not be used inside the PEs defined in this specification, except inside "PE- NonStandard". | not decidable from the package alone |
| 7.5 | The Profile creator shall ensure to provide the modified references for all the files defined in non-IoT templates according to the pre-defined rules or the customized rules defined on th... | not decidable from the package alone |
| 8.1.3 | If EAP-AKA’ authentication is required, PE-AKAParameter shall be used. | whether EAP-AKA authentication is required is not stated in the package |
| 8.2.1 | The "pix" value shall be used for the creation of default content and parameters for the EF DIR and ADF USIM in case PE-IoT template is used. | not decidable from the package alone |
| 8.3.1 | When using a template containing a hierarchy of files, Profile Creator shall take care to not instantiate files within a DF without instantiating the DF before. | not decidable from the package alone |
| 8.3.4 | These files shall be created using the GenericFileManagement PE. | which additional files a profile needs is not derivable from the package |
| 8.3.5 | To select an ADF or a DF in an ADF, the temporary File ID of the ADF shall be used by the Profile Creator. | resolving filePath against the file system would need the templates modelled |
| 8.4.2 | The source of the mapping shall be provided before it can be referenced. | not decidable from the package alone |
| 8.4.2 | If defined, it shall not be provided more than once in a Profile Package. | not decidable from the package alone |
| 8.6.3 | Any key or key component with one of these key types shall be defined using "KeyObject". | deciding that a key was carried some other way needs the sdPersoData payload parsed |
| 8.6.3 | For ECC keys, key components shall be defined using "KeyObject" as stated above. | as above |
| 8.6.3 | ECC Curve Parameters shall be defined using "sdPersoData". | as above |
| 8.6.4 | Only the content of the STORE DATA commands shall be provided (excluding CLA, INS, P1, P2, Lc). | the APDU header is not distinguishable from payload without parsing it |
| 8.7.3 | It should contain all the bytes contained in a STORE DATA command (Including CLA, INS, P1, P2, L) if required by the application but encryption shall not be used. | whether a byte string is encrypted cannot be decided by inspection |
| 9.5.11.3 | otherwise, they shall contain 2 records. | not decidable from the package alone |
| 12.2 | The "Protection Scheme Identifier List data object" shall contain maximum one Key Index entry per protection scheme. | the constraint is on TLV content inside an EF, which this validator does not parse |
| 14.8 | Bit 8 shall not be set in Profiles loaded on eUICCs not indicating support of 5G ProSe usage information reporting during the eligibility check. | not decidable from the package alone |

## Needs a referenced document (19)

The obligation delegates to a specification this project does not hold.

| Clause | Sentence | Note |
| --- | --- | --- |
| 8.1.3 | Global PINs (Application PINs according to ETSI TS 102 221 [102 221]) shall be provided once in the "PIN Context" of the creation of the MF of the UICC. | depends on a referenced document not held by this project |
| 8.1.3 | When a Profile contains an application that implements one or more EAP clients, the content of the EFDIR provided by the Profile Creator shall comply with the requirement defined in ETSI ... | depends on a referenced document not held by this project |
| 8.2.1 | It shall be encoded non-swapped as per ITU E.118 representation and padded with 'F' if less digits are used (Example: 8947010000123456784F). | depends on a referenced document not held by this project |
| 8.6.1 | The values standardised for Supplementary SDs shall be used. | the standardised values live in the GlobalPlatform Card Specification |
| 8.6.2 | The section 3.2 of [GP UC] (secure channel protocol supported by the ISD) shall apply to the MNO-SD for Profiles compliant to GlobalPlatform Card Specification UICC Configuration. | depends on a referenced document not held by this project |
| 8.6.2 | Following instances of SDs shall be installed like regular supplementary SDs as known from GlobalPlatform Card Specification [GP CS]. | depends on a referenced document not held by this project |
| 8.6.3 | For other Secure Channel Protocols, the coding of the following parameters shall follow the GlobalPlatform Card Specification [GP CS]: "keyUsageQualifier" see below. | depends on a referenced document not held by this project |
| 8.6.3 | DGIs described in GlobalPlatform Card Specification [GP CS] section 11.11.4.2.2.1 shall be coded in immediately consecutive "sdPersoData" objects. | depends on a referenced document not held by this project |
| 8.6.3 | To configure the Access Domain DAP and the Toolkit Parameter DAP as specified in TS 102 226 [102 226], the key with Key Identifier '02' and Key Version Number '11' shall be set in the MNO... | depends on a referenced document not held by this project |
| 8.6.4 | The content shall not be encrypted and shall use DGI format. | depends on a referenced document not held by this project |
| 8.6.4 | Each DGI shall be provided in its own "sdPersoData" record. | depends on a referenced document not held by this project |
| 8.7.3 | Interpretation of MSL (Minimum Security Level) shall follow the rules defined within ETSI TS 102 226 [102 226] for all applications. | depends on a referenced document not held by this project |
| 8.8 | Interpretation of MSL shall follow the rules defined within ETSI TS 102 226 [102 226]. | depends on a referenced document not held by this project |
| 8.8 | It shall be coded according to ETSI TS 102 226 [102 226]. | depends on a referenced document not held by this project |
| 12.2 | services n°124 and n°125 are "available" in EFUST and no application is registered on the SUCI interface (uicc.usim.suci.SUCIRegistry in [31.130])), this file shall be present in the Prof... | depends on a referenced document not held by this project |
| 12.2 | The service n°130 in the UST and the AID of the USIM NAA define if the SUPI used to calculate SUCI is based on IMSI or non-IMSI, for a given USIM application: • If the USIM NAA is a 3GPP ... | depends on a referenced document not held by this project |
| 12.2 | • If the USIM NAA is a 3GPP USIM (non-IMSI SUPI Type) (see [101 220]) and service n°130 is available: the SUPI Type shall be a non-IMSI SUPI Type (NAI format, i.e. | depends on a referenced document not held by this project |
| 12.2 | As all applications, it shall follow the application life cycle defined in [GP-CS] (e.g., deletion or lock). | depends on a referenced document not held by this project |
| 12.2 | As indicated in [USIM], UST service n°130 shall be available and EF IMSI shall not be available. | depends on a referenced document not held by this project |

## Describes the eUICC, not the package (144)

What the card does on receiving a profile. Nothing here constrains what a profile may contain.

| Clause | Sentence | Note |
| --- | --- | --- |
| 7.2 | If this feature is not supported by the eUICC, an error is reported to the Profile Creator, the processing of the Profile Package is cancelled, and all of the PE already processed shall b... | describes what the eUICC does, not what the package must contain |
| 7.2 | If a PE is not flagged as mandatory, and the eUICC cannot install the PE or does not support the associated feature, a warning shall be reported and the processing of the Profile Package ... | describes what the eUICC does, not what the package must contain |
| 7.2 | The features that shall be supported by the eUICC in order to install the Profile are also described in the Profile header. | describes what the eUICC does, not what the package must contain |
| 7.2 | In case the eUICC does not support one of the features listed in this Profile header, the eUICC shall immediately return an error code and abort the processing of the Profile. | describes what the eUICC does, not what the package must contain |
| 7.3 | When an eUICC encounters one of these unknown values, it shall report either an error or a warning using the code "invalid-parameter" as defined in section 8.11. | describes what the eUICC does, not what the package must contain |
| 7.3 | eUICCs shall be ready to receive values with unknown tags following those tags defined in this specification. |  |
| 8.1.3 | If the eUICC does not support the following PE, it shall abort the processing of the Profile and return an error to the sender of the Profile. | describes what the eUICC does, not what the package must contain |
| 8.1.3 | When this error code is returned, the installation of the Profile Package shall be aborted by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | If the version indicated by the Profile is not supported by the eUICC (e.g., if it is an earlier or an older version), the eUICC shall return an error "unsupported-profile-version" and st... | describes what the eUICC does, not what the package must contain |
| 8.2.1 | For IoT Minimal Profiles, the eUICC shall use this value as the default content for EF ICCID. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | If this variable is not supplied in the Profile Package, its value shall be set to all 0 by an eUICC compliant with [GS RPT]. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | Profiles intended to be installed on other types of eUICCs shall not include this data element and the eUICC should ignore its value. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | The "ServicesList" is used to indicate the services that shall be supported by the eUICC for the installation of a Profile. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | When a service is present in this sequence, and not supported or not known by the eUICC, the installation of the Profile Package shall be aborted. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | At least one implementation of the ECIES profile A or profile B as described in 3GPP [33.501] shall be supported by the eUICC when this function is supported. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | The Null-scheme shall be supported in addition of the ECIES scheme. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | The Profile maker shall provide a consistent list of services, otherwise the behaviour of the eUICC is undefined. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | If "mandated" is set in the corresponding PE header, the installation of the Profile shall be aborted by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | EFs and DFs defined beneath the DF link in the Profile Package shall not be created either. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | "eUICC-Mandatory-GFSTEList" contains a list of OIDs identifying file system templates which shall be supported by the eUICC in order for the Profile to be correctly installed on the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | If a template OID present in the list is not supported by the eUICC the installation of the Profile Package shall be aborted by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.2.1 | When an AID is present in the Profile header and not known by the eUICC, the installation of the Profile Package shall be aborted with the status code "lib-not-supported". | describes what the eUICC does, not what the package must contain |
| 8.2.1 | When the version is not compatible with the versions supported by the eUICC, the installation of the Profile Package shall also be aborted by the eUICC with the status code "lib-not-suppo... | describes what the eUICC does, not what the package must contain |
| 8.2.1 | If this data element is present and the eUICC does not support the IoT Minimal Profile, the installation of the Profile Package shall be aborted with the status code set to "feature-not-s... | describes what the eUICC does, not what the package must contain |
| 8.3.2 | In case of a template link file, an empty linkPath indicates that the link file shall be turned into an independent file. | describes what the eUICC does, not what the package must contain |
| 8.3.2 | This list shall be returned by the eUICC when selecting an ADF/DF within the PIN status template DO according to ETSI TS 102 221 [102 221]. | describes what the eUICC does, not what the package must contain |
| 8.3.2 | The eUICC shall process the elements contained in the "File" type according to the diagram below to create no, one or several files and optionally fill them with content. | describes what the eUICC does, not what the package must contain |
| 8.3.2 | The parameters "maximumFileSize" and "fileDetails" are dedicated to BER-TLV as described in ETSI 102 222 [102 222]: • The "maximumFileSize" is optional for a BER-TLV file and if not prese... |  |
| 8.3.2 | • The "fileDetails" is optional for a BER-TLV file and if not present in the ASN.1 creating the file, the value "01" (DER Coding) shall be set for this BER-TLV file. |  |
| 8.3.3 | In this case the settings of the source file for fileDescriptor, efFileSize and proprietaryEFInfo shall be applied for creating the file (the respective settings from the template shall b... | describes what the eUICC does, not what the package must contain |
| 8.3.3 | By providing a linkPath value the link shall be changed to the referenced file. | describes what the eUICC does, not what the package must contain |
| 8.3.3 | There are two ways to alter the default: • Overwrite Repeat/Fill Pattern: A repeat or fill pattern provided within the respective "Fcp" shall overwrite the default content completely. | describes what the eUICC does, not what the package must contain |
| 8.3.3 | This means that in case the "Fcp" in the PE includes a fill pattern, but the template is defined as repeat pattern or non-pattern content, the fill pattern from the PE shall be applied (a... | describes what the eUICC does, not what the package must contain |
| 8.3.3 | If parameter "proprietaryEFInfo" is provided and no repeat or fill pattern are present, the default template fill or repeat pattern shall be used. |  |
| 8.3.3 | • Using "fillFileContent" / "fillFileOffset": Providing file content within "fillFileContent" / "fillFileOffset" shall have the same effect as creating a file with a fill/repeat pattern, ... |  |
| 8.3.4 | The rules associated with this kind of template shall be used by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.3.5 | In case a DF/ADF is created it shall be automatically selected. | describes what the eUICC does, not what the package must contain |
| 8.3.5 | No EF shall be selected in this case. | describes what the eUICC does, not what the package must contain |
| 8.3.5 | When an EF has been created it shall be automatically selected as the current EF. | describes what the eUICC does, not what the package must contain |
| 8.3.5 | In these cases, "feature-not-supported" shall be returned by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.3.5 | After creation of the Profile in the eUICC, the record pointer shall be set to the first record created during the processing of the Profile Package. | describes what the eUICC does, not what the package must contain |
| 8.3.5 | In this case the settings of the source file for fileDescriptor, efFileSize, pinStatusTemplateDO and proprietaryEFInfo shall be applied for creating the file (where applicable) and the fi... | describes what the eUICC does, not what the package must contain |
| 8.3.5 | The file, with the exception of ADFs, shall always be created within the currently selected DF/ADF. |  |
| 8.3.5 | The content shall be personalised starting at the current "fillFileOffset" pointer which shall be implicitly set to the next unpersonalised content ("fillFileOffset" pointer new= "fillFil... |  |
| 8.4.2 | If they are present, they shall be ignored by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.4.2 | If "networkName" is provided in the Profile, the SSIM shall check its value during the authentication sequence. | describes what the eUICC does, not what the package must contain |
| 8.4.2 | If "networkName" is incorrect, the SSIM shall behave as if AUTN had been incorrect, and the authentication shall fail. | describes what the eUICC does, not what the package must contain |
| 8.5.1 | The eUICC shall be able to support all the PIN and ADM references listed in "PINKeyReferenceValue". | describes what the eUICC does, not what the package must contain |
| 8.5.1 | Provided they are not linked they shall be handled as two independent PIN values which also may reference different PUK references. | describes what the eUICC does, not what the package must contain |
| 8.5.2 | The eUICC shall be able to support all the PUK references listed in "PUKKeyReferenceValue". | describes what the eUICC does, not what the package must contain |
| 8.6.2 | Since no package AID nor classAID is standardised for the MNO-SD, the eUICC may use vendor specific values and shall not abort the Profile download because of the values for package AID a... | describes what the eUICC does, not what the package must contain |
| 8.6.2 | The presence of Security Domains, in particular the MNO-SD, in the Profile shall be in line with the specifications referencing the present document. | describes what the eUICC does, not what the package must contain |
| 8.6.3 | Therefore, the "keyAccess" and "keyUsageQualifier" fields shall be ignored by the eUICC when the "KeyObject" transports such keys. | describes what the eUICC does, not what the package must contain |
| 8.6.3 | If it is absent, the initial counter value shall be set by the eUICC according to the default value of the related protocol (e.g. | describes what the eUICC does, not what the package must contain |
| 8.6.3 | This value shall be ignored by the eUICC for other key types. | describes what the eUICC does, not what the package must contain |
| 8.6.3 | Enabling trust in a connected future 57 If "keyType" or any other "KeyObject" parameters are not supported by the eUICC, the error code "feature-not-supported" shall be returned and the i... | describes what the eUICC does, not what the package must contain |
| 8.6.3 | An eUICC according to this specification shall support Access Domain DAP and the Toolkit Parameter DAP features, as defined in TS 102 226 [102 226]. | describes what the eUICC does, not what the package must contain |
| 8.6.3 | DAP verification shall not apply during the installation of the Profile Package on the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.6.4 | Since there is no limitation in terms of content length for within the "sdPersoData" parameter, the complete DGI structure for the SD personalisation shall be sent in one complete byte ar... | describes what the eUICC does, not what the package must contain |
| 8.6.4 | Only standardised DGIs, according to GlobalPlatform Card Specification [GP CS], shall be sent when addressing a SD. | describes what the eUICC does, not what the package must contain |
| 8.6.5 | If DNS Resolution mechanism is supported by eUICC, then DNS Resolution parameters shall be configured as described in GlobalPlatform Amd B [GP AB] (Section 3.11: Security Domain DNS Resol... | describes what the eUICC does, not what the package must contain |
| 8.6.5 | The eUICC shall follow the latest ETSI and 3GPP release to provide the necessary level of security. | describes what the eUICC does, not what the package must contain |
| 8.6.6 | The Profile "openPersoData" parameters shall apply only when the Profile is enabled. | describes what the eUICC does, not what the package must contain |
| 8.6.6 | If the eUICC doesn't support the Restrict parameter and this parameter is present in the Profile Package, the error code "feature-not-supported" shall be returned and the installation of ... | describes what the eUICC does, not what the package must contain |
| 8.6.8 | The eUICC shall support the following STORE DATA: • STORE DATA (ECKA Certificate) Command • STORE DATA (Whitelist) Command • STORE DATA (CA-KLOC Identifier) Command Enabling trust in a co... | describes what the eUICC does, not what the package must contain |
| 8.7.2 | In case no value for the optional parameter "securityDomainAID" is provided, the package shall be associated to the MNO-SD by default. | describes what the eUICC does, not what the package must contain |
| 8.7.3 | In case no value for the optional parameter "extraditeSecurityDomainAID" is provided, the instance shall be associated to the MNO-SD by default. | describes what the eUICC does, not what the package must contain |
| 8.7.3 | In case of an association to an SD in a Life Cycle State different from PERSONALIZED, the error code "invalid- parameter" shall be returned and the installation of the Profile Package sha... | describes what the eUICC does, not what the package must contain |
| 8.7.3 | As a consequence, the eUICC shall ignore tag '84' as defined in GlobalPlatform Card Specification UICC Configuration [GP UC] during Profile Package installation. | describes what the eUICC does, not what the package must contain |
| 8.7.3 | Data shall be sent as is to the application for processing. | describes what the eUICC does, not what the package must contain |
| 8.7.3 | All byte strings provided within "processData" shall be directly sent to the respective application instance for processing through the "processData" method of the "Application" or "Perso... |  |
| 8.8 | In case it is not available the MF shall be the default selection. | describes what the eUICC does, not what the package must contain |
| 8.8 | If not provided, it shall automatically be associated to the MNO-SD. | describes what the eUICC does, not what the package must contain |
| 8.8 | When processing an RFM script, the defined ADF shall be selected by default and can be addressed by the file path '7FFF' as it is defined within ETSI standards. | describes what the eUICC does, not what the package must contain |
| 8.8 | In case this optional parameter is not provided, the RFM instance shall be linked only to the MF which shall be the default selection in the context of an RFM script. | describes what the eUICC does, not what the package must contain |
| 8.10 | In case the eUICC has not aborted the installation of the Profile Package after processing the "PE-End", a "EUICCResponse" ending with a "PEStatus" containing the "ok" status code shall b... | describes what the eUICC does, not what the package must contain |
| 8.10 | When using this status code, the eUICC shall not indicate any identification of a PE. | describes what the eUICC does, not what the package must contain |
| 8.10 | If this PE is indicated as "mandated" in the PE header, this status is an error status, and the processing of the Profile shall be aborted. | describes what the eUICC does, not what the package must contain |
| 8.10 | Otherwise, this is just a warning, and the installation of the Profile shall continue. | describes what the eUICC does, not what the package must contain |
| 8.10 | This status is an error status, and the processing of the Profile shall be aborted. | describes what the eUICC does, not what the package must contain |
| 8.10 | If the PE generating this status indicates "mandated" in the PE header, this status is an error status, and the processing of the Profile shall be aborted. | describes what the eUICC does, not what the package must contain |
| 8.10 | This status code shall be used when the eUICC encounters an unknown tag inside a PE. | describes what the eUICC does, not what the package must contain |
| 8.10 | Otherwise, the installation of the Profile should be aborted, and the parameter shall be ignored by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.10 | If the PE generating this status is the Profile Header, this status is an error status, and the processing of the Profile shall be aborted. | describes what the eUICC does, not what the package must contain |
| 8.10 | If the PE generating this status is a PE Application which indicates "mandated" in the PE header, this status is an error status, and the processing of the Profile shall be aborted. | describes what the eUICC does, not what the package must contain |
| 8.10 | Otherwise, the installation of the Profile should be aborted, and the application shall be ignored by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.10 | If the templateID is inside a PE indicated Enabling trust in a connected future 67 as "mandated" or if the OID is in the "eUICC-Mandatory-GFSTEList" of the Profile Header, this status is ... | describes what the eUICC does, not what the package must contain |
| 8.10 | Otherwise, this is just a warning, the installation of the Profile shall continue, and the file system described by this PE shall not be created by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.10 | If the PE generating this status indicates "mandated" in the PE header or if this feature is included into the ServiceList of the Profile Header, this status is an error status, and the p... | describes what the eUICC does, not what the package must contain |
| 8.10 | When this error is returned, the installation of the Profile shall be aborted by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.10 | In case the eUICC aborts the Profile installation, it shall return at least one status code which is defined by Trusted Connectivity Alliance, or defined in a public standard (e.g., ISO/I... | describes what the eUICC does, not what the package must contain |
| 8.10 | When this tag is used, it shall be present in the last EUICCResponse sent by the eUICC. | describes what the eUICC does, not what the package must contain |
| 8.10 | In case the eUICC aborts the Profile installation, it shall return an "offset". | describes what the eUICC does, not what the package must contain |
| 8.10 | Otherwise, this is just a warning, the PE is skipped, and the installation of the Profile shall continue. | describes what the eUICC does, not what the package must contain |
| 8.10 | This status shall not be sent for all the PEs but only at the end of the Profile installation. |  |
| 9.1 | For multiple instances of the same file (by sending multiple fcps for the same file) the processing defined in Figure 2 shall be followed. | describes what the eUICC does, not what the package must contain |
| 9.1 | All subsequent file instances shall be created according to the processing defined in Figure 2. | describes what the eUICC does, not what the package must contain |
| 9.1 | If no value is listed in the template, the SFI shall be set as not supported by the eUICC. | describes what the eUICC does, not what the package must contain |
| 9.1 | For record-based files: − If the number of record or record size is changed, the pattern shall be applied for the complete file according to ETSI TS 102 222 [102 222]. | describes what the eUICC does, not what the package must contain |
| 9.1 | For transparent files the pattern shall be applied according to ETSI TS 102 222 [102 222], if the file size is changed. | describes what the eUICC does, not what the package must contain |
| 9.1 | For non-pattern content: − For record-based files, if the number of records or record size is changed, the non-pattern content shall be truncated or padded with "FF…FF" per record. | describes what the eUICC does, not what the package must contain |
| 9.1 | For transparent files, if the file size is changed, the non-pattern content shall be truncated or padded with "FF…FF". | describes what the eUICC does, not what the package must contain |
| 9.1 | Any content not explicitly set within the Profile Package shall be personalised with the default content. | describes what the eUICC does, not what the package must contain |
| 9.1 | Any content not set within the Profile Package shall be set to the default content. | describes what the eUICC does, not what the package must contain |
| 9.1 | Some additional parameters not listed in the tables shall also be included in the templates: • Except for the files listed below the tables, by default, all the files defined in the templ... | describes what the eUICC does, not what the package must contain |
| 9.1 | • All the files defined in the templates shall have, by default, shareable/not-shareable bit in the file descriptor set to "shareable". | describes what the eUICC does, not what the package must contain |
| 9.1 | • All the files defined in the templates shall set, by default, the attribute "Not readable or updatable when deactivated" in the Special File Information. | describes what the eUICC does, not what the package must contain |
| 9.2 | This template shall be supported by the eUICCs. | describes what the eUICC does, not what the package must contain |
| 9.4.1 | 9.4.1 Template version support An eUICC compliant with this specification shall support version 2 and higher of the DF TELECOM templates as defined below. | describes what the eUICC does, not what the package must contain |
| 9.5.1 | This template shall be supported by the eUICCs supporting the USIM application. | describes what the eUICC does, not what the package must contain |
| 9.5.2.1 | 9.5.2.1 Template version support An eUICC compliant with this specification and supporting the USIM application shall support version 2 and higher of the Optional USIM EFs templates as de... | describes what the eUICC does, not what the package must contain |
| 9.5.11.1 | 9.5.11.1 Template version support An eUICC compliant with this specification and supporting the USIM application shall support both, version 2 and higher of the DF 5GS template as defined... | describes what the eUICC does, not what the package must contain |
| 9.5.13.1 | 9.5.13.1 Template version support An eUICC compliant with this specification and supporting the USIM application shall support version 1 and higher of the DF SNPN templates as defined below. | describes what the eUICC does, not what the package must contain |
| 9.5.14.1 | 9.5.14.1 Template version support An eUICC compliant with this specification and supporting the USIM application shall support version 1 and higher of the DF 5G ProSe templates as defined... | describes what the eUICC does, not what the package must contain |
| 9.6.1 | This template shall be supported by the eUICCs supporting the ISIM application. | describes what the eUICC does, not what the package must contain |
| 9.6.2.1 | 9.6.2.1 Template version support An eUICC compliant with this specification and supporting the ISIM application shall support version 2 and higher of the Optional ISIM EFs templates as de... | describes what the eUICC does, not what the package must contain |
| 9.6.2.2 | The bits related to GBA in the EF IST shall also be cleared by the eUICC if it does not support the related services. | describes what the eUICC does, not what the package must contain |
| 9.7.1 | This template shall be supported by the eUICCs supporting the CSIM application. | describes what the eUICC does, not what the package must contain |
| 9.8 | This template shall be supported by the eUICCs supporting EAP applications. | describes what the eUICC does, not what the package must contain |
| 9.10.1 | This template shall be supported by the eUICCs supporting the IoT minimal Profile. | describes what the eUICC does, not what the package must contain |
| 9.10.1 | Enabling trust in a connected future 106 Note 4: The default AID shall be set by concatenating the default RID ('A000000087') with the PIX supplied in the Profile header. | describes what the eUICC does, not what the package must contain |
| 9.10.1 | The default content and the length of the EF DIR shall be set accordingly. | describes what the eUICC does, not what the package must contain |
| 9.11 | This template shall be supported by the eUICCs supporting the SSIM application. | describes what the eUICC does, not what the package must contain |
| 12.2 | This EF shall not be available to the ME. | describes what the eUICC does, not what the package must contain |
| 12.2 | The USIM application shall select the protection scheme from its supported schemes that has the highest priority in "Protection Scheme Identifier List data object". | describes what the eUICC does, not what the package must contain |
| 12.2 | If there is no supported protection scheme or if the Home Network Public Key for the selected protection scheme is not correctly formatted, the USIM Application shall generate an error in... | describes what the eUICC does, not what the package must contain |
| 12.2 | Enabling trust in a connected future 143 The USIM shall generate a SUCI using "null-scheme" only in the following cases: • if the home network has configured "null-scheme" to be used, or ... | describes what the eUICC does, not what the package must contain |
| 12.2 | The USIM application shall select the Home Network Public Key matching the protection scheme selected from "Protection Scheme Identifier List data object". | describes what the eUICC does, not what the package must contain |
| 12.2 | SUCI calculation for non-IMSI SUPI Type shall be supported by eUICCs supporting SUCI calculation by the USIM. | describes what the eUICC does, not what the package must contain |
| 12.2 | It shall be registered to a dedicated NAA USIM, and only one application can be registered to the same USIM NAA. | describes what the eUICC does, not what the package must contain |
| 12.2 | If the application registration fails, the default USIM NAA SUCI calculation system application shall be triggered to calculate the SUCI if the USIM is correctly configured as specified i... | describes what the eUICC does, not what the package must contain |
| 12.2 | Enabling trust in a connected future 144 • From a default USIM NAA SUCI calculation system application: This system application shall be automatically available for a USIM NAA when the se... | describes what the eUICC does, not what the package must contain |
| 14.3 | These sizes shall be supported by all eUICC compliant with V2.3 and further specifications. | describes what the eUICC does, not what the package must contain |
| 14.3 | PIN, ADM and PUK support: It is clarified that eUICC shall support all the PIN and ADM references listed in the specification. | describes what the eUICC does, not what the package must contain |
| 14.3 | Status codes: It is clarified that in case of Profile installation abortion by the eUICC, it shall send a status code which is defined in a public specification. | describes what the eUICC does, not what the package must contain |
| 14.4 | An eUICC supporting only previous versions of this specification shall reject a V3.0 Profile Package. | describes what the eUICC does, not what the package must contain |
| 14.4 | This size shall be supported by all eUICC compliant with V3.0 and further specifications. | describes what the eUICC does, not what the package must contain |
| 14.6 | 14.6 Profile Version 3.2 ETSI DAP: It is clarified that an eUICC shall support Access Domain DAP and Toolkit Parameter DAP. | describes what the eUICC does, not what the package must contain |
| 14.6 | It is clarified that an eUICC shall not abort the Profile download because of the values provided for package AID and class AID in the Profile for the MNO-SD. | describes what the eUICC does, not what the package must contain |
| 15 | Trusted Connectivity Alliance shall not be held responsible for identifying any or all such IPR, and has made no inquiry into the possible existence of any such IPR. | describes what the eUICC does, not what the package must contain |
| 76 | So, even if indicated in the Profile, the creation of these files shall be skipped by the eUICC if these functionalities are not supported by the eUICC framework. | describes what the eUICC does, not what the package must contain |
| 76 | In that case, the eUICC shall answer to the Profile Creator with a status code set to "feature-not-supported" with "additional-information" set to '1' if GBA is not supported, to '2' if M... | describes what the eUICC does, not what the package must contain |
| 76 | The bits related to these services in the EF UST shall also be cleared by the eUICC if it does not support the services. | describes what the eUICC does, not what the package must contain |
| 76 | If "mandated" is set in the PE header, the installation of the Profile shall be aborted by the eUICC. | describes what the eUICC does, not what the package must contain |

## Table legend (9)

The M/O/C/F definitions themselves. The cells they define are implemented as rules.

| Clause | Sentence | Note |
| --- | --- | --- |
| 8.3.2 | */ shortEFID [8] OCTET STRING (SIZE (0..1)) OPTIONAL, /* proprietaryEFInfo Optional for EF file types Not allowed for DF files */ proprietaryEFInfo [5] ProprietaryInfo OPTIONAL, /* linkPa... | the table legend itself; the cells it defines are implemented |
| 8.3.2 | */ linkPath [PRIVATE 7] OCTET STRING (SIZE (0..8)) OPTIONAL } File ::= SEQUENCE OF CHOICE { doNotCreate NULL, /* Indicates that this file shall not be created by the eUICC even if present... | the table legend itself; the cells it defines are implemented |
| 8.3.3 | C: Conditional Parameters marked with conditional may always be provided if the default value of the template shall be modified (e.g. | the table legend itself; the cells it defines are implemented |
| 8.3.3 | Note 3: In case a link shall be turned in an independent file an empty linkPath needs to be provided. | the table legend itself; the cells it defines are implemented |
| 8.10 | A: This status is allowed for this PE and the eUICC shall abort the Profile Package installation. | the table legend itself; the cells it defines are implemented |
| 8.10 | C: This status is allowed for this PE and the eUICC shall abort the Profile Package installation if "mandated" is set in the PE header. | the table legend itself; the cells it defines are implemented |
| 8.10 | C2: This status is allowed for this PE and the eUICC shall abort the Profile Package installation if "mandated" is set in the PE header. | the table legend itself; the cells it defines are implemented |
| 9.10.2 | Note 2: If Service n°136 is not "available" in EF UST, the Profile Creator shall ensure that these files shall contain one record; | the table legend itself; the cells it defines are implemented |
| 15 | a 2G M2M module) to be able to sustain remote provisioning of an eUICC according to this definition of the Profile Package, it shall support features defined in standard releases which al... | the table legend itself; the cells it defines are implemented |

## Descriptive (4)

Prose that reads like an obligation but states no requirement on the package.

| Clause | Sentence | Note |
| --- | --- | --- |
| 8.3.3 | This might be needed for some files where the default template size shall be modified (e.g., EF ICI, EF OCI). |  |
| 8.6.3 | 8.6.3 Key Personalisation After creation of an SD, the keys which shall be installed can be described with the respective SD PE. |  |
| 8.7.3 | The same means as for STORE DATA shall be used to personalise an application instance. |  |
| 8.8 | The following parameters for RFM can be configured: "instanceAID" Indicates the AID of the RFM instance "securityDomainAID" References the SD to which the RFM application shall be associa... |  |
