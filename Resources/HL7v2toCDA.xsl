<?xml version="1.0" encoding="UTF-8"?>
<!-- HL7 v2 to BC CDA, version 2013-08-01 -->
<!-- This pattern is used to achieve the same effect as ends-with() in XPath 1.0 processors: -->
<!-- substring(name(),(string-length(name())-1))='.1' -->
<!-- See: http://users.atw.hu/xsltcookbook2/xsltckbk2-chp-2-sect-1.html -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:hl7-org:v2xml" 
                          xmlns:ns1="http://interiorhealth.ca/Meditech/HL7/2X/2.3/ORU/v1/Combined" 
                          xmlns:ns2="http://interiorhealth.ca/Meditech/HL7/2X" 
                          xmlns:voc="urn:hl7-org:v3/voc" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:mif="urn:hl7-org:v3/mif" xmlns:lab="urn:oid:1.3.6.1.4.1.19376.1.3.2" exclude-result-prefixes="msxsl var userCSharp" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var" xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xml:space="default">
	<xsl:output method="xml" indent="yes" encoding="ISO-8859-1" standalone="yes"/>

	<!-- Can we call inline C# scripts? If so, set $microsoft to 'true' -->
	<xsl:variable name="microsoft" select="'true'"/>
	
	<!-- Is this an IHA Meditech message with sub-components in OBX.1? If so, set $ihaMTlab to true() -->
    <xsl:variable name="ihaMTlab" select="boolean(//OBX.1/*[substring(name(),(string-length(name())-1))='.1']/text()[normalize-space(.)])" />
    
	<!-- Template ID OIDs -->
	<xsl:variable name="templateCdaLevel1">2.16.840.1.113883.10.20.19</xsl:variable>
	<xsl:variable name="templateCdaLevel1disp">Unstructured CDA Template</xsl:variable>
	<!-- GENERAL OIDS -->
	<xsl:variable name="loincRootOid">2.16.840.1.113883.6.1</xsl:variable>
	<xsl:variable name="loincRootOidDisp">LOINC Code</xsl:variable>
	<!-- BC OIDS -->
	<xsl:variable name="bcProvRootOid">2.16.840.1.113883.3.40.2.11</xsl:variable>
	<xsl:variable name="bcProvRootOidDisp">BC MSP Provider License Number</xsl:variable>
	<xsl:variable name="bcPhnRootOid">2.16.840.1.113883.4.50</xsl:variable>
	<xsl:variable name="bcPhnRootOidDisp">BC Patient Health Number</xsl:variable>
	<xsl:variable name="ihaRootOid">2.16.840.1.113883.3.277</xsl:variable>
	<!-- IHA Root OID -->
	<xsl:variable name="ihaRootOidDisp">Interior Health Authority</xsl:variable>
	<!-- CDX Project Root OID -->
	<xsl:variable name="CDXRootOid">
		<xsl:value-of select="$ihaRootOid"/>.100</xsl:variable>
	<xsl:variable name="CDXRootOidDisp">CDX System</xsl:variable>
	<xsl:variable name="CDXMessageOid">
		<xsl:value-of select="$CDXRootOid"/>.3</xsl:variable>
	<xsl:variable name="CDXMessageOidDisp">CDX Clinical Document ID</xsl:variable>

	<!-- IHA Local OIDs based on the IHA Root OID -->
	<xsl:variable name="specRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.11</xsl:variable>
	<xsl:variable name="specRootOidDisp">IHA Test/Specimen Number (OBR.3 Filler Order Number)</xsl:variable>
	<xsl:variable name="softwareRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.12</xsl:variable>
	<xsl:variable name="softwareRootOidDisp">IHA Software Code</xsl:variable>
	<xsl:variable name="deviceRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.13</xsl:variable>
	<xsl:variable name="deviceRootOidDisp">IHA Device Code</xsl:variable>
	<xsl:variable name="orderRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.22</xsl:variable>
	<xsl:variable name="orderRootOidDisp">IHA Order Number (Requisition Number)</xsl:variable>
	<xsl:variable name="orderAltRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.23</xsl:variable>
	<xsl:variable name="orderAltRootOidDisp">IHA Alternate Order Number (OBR.2 Placer Order Number)</xsl:variable>
	<xsl:variable name="encounterRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.51</xsl:variable>
	<xsl:variable name="encounterRootOidDisp">IHA-MT Encounter Identifier</xsl:variable>
	<xsl:variable name="ihaProvRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.61</xsl:variable>
	<xsl:variable name="ihaProvRootOidDisp">IHA Provider Code: IHA-MT PVD-ID</xsl:variable>
	<xsl:variable name="facilityRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.62</xsl:variable>
	<xsl:variable name="facilityRootOidDisp">IHA Meditech Location Identifier</xsl:variable>
	<xsl:variable name="ptUnitRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.71</xsl:variable>
	<xsl:variable name="ptUnitRootOidDisp">IHA Patient Unit Number</xsl:variable>
	<xsl:variable name="ptVisitRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.72</xsl:variable>
	<xsl:variable name="ptVisitRootOidDisp">IHA Patient Account Number</xsl:variable>
	<xsl:variable name="ptEmrRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.73</xsl:variable>
	<xsl:variable name="ptEmrRootOidDisp">IHA Patient EMR Number</xsl:variable>
	<xsl:variable name="messageNumberRootOid">
		<xsl:value-of select="$ihaRootOid"/>.1.81</xsl:variable>
	<xsl:variable name="messageNumberRootOidDisp">IHA Message Number</xsl:variable>

	<!-- Make a GUID using C#, if we've got it -->
	<xsl:variable name="var:v1">
		<xsl:choose>
			<xsl:when test="$microsoft='true'">
				<xsl:value-of select="userCSharp:generateGUID()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>GUID</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Dictionaries used in Muenchian grouping below. -->
	<!-- === Build a dictionary of OBX segments and their Loinc sections using the codes found in OBX.3 === -->
	<xsl:key name="loincSection" match="//OBX[./OBX.3 and (./OBX.2 = 'TX' or ./OBX.2 = 'FT')]" use="./OBX.3/*[substring(name(),(string-length(name())-1))='.1']"/>
	<!-- === Build a dictionary of recipient providers  === -->
	<xsl:key name="providers" match="//ORC.12|//OBR.16|//PV1.52|//OBR.28|//PV1.7|//PV1.8|//PV1.9|//PV1.17" use="./*[substring(name(),(string-length(name())-1))='.1']"/>
	<!-- ===== Document Type variables ===== -->
	<xsl:variable name="OERept" select="(//MSH.3/* = 'OE')" />
	<xsl:variable name="OEdocType" select="//OBR/OBR.4/*[substring(name(),(string-length(name())-1))='.2']"/>
	<xsl:variable name="OECode" select="//OBR/OBR.21" />

	<!-- Determine document type using MSH.3 and Meditech report mnemonic in OBR.21 -->
	<xsl:variable name="docCode">
		<xsl:choose>
			<!-- Core CDA types -->
			<!-- xsl:when test="(//MSH.3/* = 'MIC') or (//MSH.3/* = 'MB')">11502-2</xsl:when -->
			<xsl:when test="(//MSH.3/* = 'MIC') or (//MSH.3/* = 'MB') or (//MSH.5/* = 'MIC')">18725-2</xsl:when>
			<xsl:when test="//MSH.3/* = 'LAB'">11502-2</xsl:when>
			<xsl:when test="//MSH.3/* = 'BBK'">18717-9</xsl:when>
			<xsl:when test="//MSH.3/* = 'PTH'">11526-1</xsl:when>
			<xsl:when test="//MSH.3/* = 'RAD'">18748-4</xsl:when>
			
			<!-- Meditech mnemonic collisions -->
			<xsl:when test="($OERept) and (starts-with($OEdocType,'Audiology'))">68636-0</xsl:when>
			<xsl:when test="($OERept) and ($OECode='CONEURO') and (starts-with($OEdocType,'Neuropsychology'))">34788-0</xsl:when>
			<xsl:when test="($OERept) and ($OECode='CONEURO') and (starts-with($OEdocType,'ABI'))">34791-4</xsl:when>
			<xsl:when test="($OERept) and ($OECode='HP') and (starts-with($OEdocType,'Psychiatric'))">68599-0</xsl:when>
			<xsl:when test="($OERept) and ($OECode='HPPREM') and (starts-with($OEdocType,'Pre-Admission'))">11488-4</xsl:when>
			<xsl:when test="($OERept) and ($OECode='HPPRES') and (starts-with($OEdocType,'Pre-Operative'))">67862-3</xsl:when>
			
			<!-- Procedure Note -->
			<xsl:when test="($OERept) and (($OEdocType = 'Procedure Note') or ($OEdocType = 'Procedure Report') or ($OECode='ANG') or ($OECode='CLCOLP') or ($OECode='CLCOLPCMH') or ($OECode='COPR') or ($OECode='ECHOT') or ($OECode='PCI') or ($OECode='PR') or ($OECode='PTA'))">28570-0</xsl:when>
			<!-- Discharge Summary -->
			<xsl:when test="($OERept) and (($OEdocType = 'Discharge Summary') or ($OECode='DS') or ($OECode='DSNEURO') or	($OECode='DSPHYS') or ($OECode='DSPSY') or ($OECode='ZDS') or ($OECode='ZDS1'))">18842-5</xsl:when>
			<!-- Some extra, optional level 1 types -->
			<!-- Consultation Report -->
			<xsl:when test="($OERept) and (($OEdocType = 'Consultation Report') or ($OECode='C.COORT') or ($OECode='CHILD') or ($OECode='CLCARD') or ($OECode='CLCDM') or ($OECode='CO') or ($OECode='COCN') or ($OECode='COTEST') or ($OECode='COTESTHM') or ($OECode='COTNR') or ($OECode='ICUTN') or ($OECode='INEVAL') or ($OECode='LC') or ($OECode='NVE') or ($OECode='TA') or ($OECode='TRAUMA') or ($OECode='TSTMEDITOR') or ($OECode='VASC'))">11488-4</xsl:when>

			<xsl:when test="($OERept) and (($OECode = 'OR')or($OECode = 'OPNOTE'))">11504-8</xsl:when>
			<xsl:when test="($OERept) and (($OEdocType = 'Progress Note') or ($OECode='CLTRANS') or ($OECode='PN'))">11506-3</xsl:when>
			<xsl:when test="($OERept) and (($OECode='PNNEURO') or ($OECode='PNPSY'))">11510-5</xsl:when>
			<xsl:when test="($OERept) and (($OECode='ECHO')or($OECode='ECHOFT')or($OECode='ECHOL'))">11522-0</xsl:when>
			<xsl:when test="($OERept) and (($OECode='ECHOS'))">59282-4</xsl:when>
			<xsl:when test="($OERept) and ($OECode='EEG')">11523-8</xsl:when>
			<xsl:when test="($OERept) and ($OECode='ECG')">11524-6</xsl:when>
			<xsl:when test="($OERept) and (($OECode='CC')or($OECode='CAT'))">18745-0</xsl:when>
			<xsl:when test="($OERept) and ($OECode='EMG')">18749-2</xsl:when>
            <xsl:when test="($OERept) and ($OECode='EST')">18752-6</xsl:when>
			<xsl:when test="($OERept) and (($OECode='HM')or($OECode='HMQVH')or($OECode='HMSLH')or($OECode='CER'))">18754-2</xsl:when>
			<xsl:when test="($OERept) and ($OECode='C.PN')">28627-8</xsl:when>
			<xsl:when test="($OERept) and (($OECode='POLY')or($OECode='POLYER'))">28633-6</xsl:when>
			<xsl:when test="($OERept) and (($OECode='CL')or($OECode='CLANES'))">34108-1</xsl:when>
			<xsl:when test="($OERept) and ($OECode='VNOTE')">34111-5</xsl:when>
			<xsl:when test="($OERept) and (($OECode = 'HP')or($OECode = 'HP1')or($OECode = 'HPPREM')or($OECode = 'HPPRES')or($OECode = 'ZHP')or($OECode = 'ZHP2'))">34117-2</xsl:when>
			<xsl:when test="($OERept) and ($OECode='COTEL')">34748-4</xsl:when>
			<xsl:when test="($OERept) and ($OECode='CODEP')">34760-9</xsl:when>
			<xsl:when test="($OERept) and (($OECode='C.COPHYS')or($OECode='GERI'))">34785-6</xsl:when>
			<xsl:when test="($OERept) and (($OECode='C.CO')or($OECode='CONEURO'))">34788-0</xsl:when>
			<xsl:when test="($OERept) and (($OECode='COPHYS')or($OECode='COPSY'))">34791-4</xsl:when>
			<xsl:when test="($OERept) and (($OECode='CLREN')or($OECode='CLRENKID'))">34795-5</xsl:when>
			<xsl:when test="($OERept) and ($OECode='CLONC')">34805-2</xsl:when>
			<xsl:when test="($OERept) and ($OECode='CLORTH')">34815-1</xsl:when>
			<xsl:when test="($OERept) and ($OECode='PF')">34830-0</xsl:when>
			<xsl:when test="($OERept) and ($OECode='RESP')">34838-3</xsl:when>
			<xsl:when test="($OERept) and ($OECode='C.PNPHYS')">34904-3</xsl:when>
			<xsl:when test="($OERept) and ($OECode='MAM')">36625-2</xsl:when>
			<xsl:when test="($OERept) and ($OECode='OUTEVAL')">51845-6</xsl:when>
			<xsl:when test="($OERept) and (($OECode='COER')or($OECode='EDC')or($OECode='ERC'))">51846-4</xsl:when>
			<xsl:when test="($OERept) and ($OECode='RL')">51852-2</xsl:when>
			<xsl:when test="($OERept) and ($OECode='LD')">57057-2</xsl:when>
			<xsl:when test="($OERept) and (($OECode='COD')or($OECode='CODS'))">59259-2</xsl:when>
			<xsl:when test="($OERept) and ($OECode='COPRE')">67862-3</xsl:when>
			<xsl:when test="($OERept) and (($OECode='ERG')or($OECode='SLEEP')or($OECode='SOMATO')or($OECode='STEM')or($OECode='VISUAL')or($OECode='VNG'))">68556-0</xsl:when>
			<xsl:when test="($OERept) and ($OECode='PSYHP')">68599-0</xsl:when>
			<xsl:when test="($OERept) and ($OECode='IHSCF')">68636-0</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<!-- Another hard-coded lookup table -->
	<xsl:variable name="docTemplate">
		<xsl:choose>
			<xsl:when test="($docCode = '11502-2') or ($docCode = '18725-2') or ($docCode = '18717-9')">2.16.840.1.113883.3.51.60.2.1</xsl:when>
			<xsl:when test="$docCode = '11526-1'">2.16.840.1.113883.3.51.60.2.2</xsl:when>
			<xsl:when test="$docCode = '28570-0'">2.16.840.1.113883.3.51.60.2.3</xsl:when>
			<xsl:when test="$docCode = '18842-5'">2.16.840.1.113883.3.51.60.2.4</xsl:when>
			<xsl:when test="$docCode = '18748-4'">2.16.840.1.113883.3.51.60.2.5</xsl:when>
			<xsl:when test="$docCode = '11488-4'">2.16.840.1.113883.10.20.4</xsl:when>
			<xsl:when test="$docCode = '11504-8'">2.16.840.1.113883.10.20.2</xsl:when>
			<xsl:when test="$docCode = '11504-8'">2.16.840.1.113883.10.20.7</xsl:when>
			<xsl:when test="$docCode = '11506-3'">2.16.840.1.113883.10.20.21</xsl:when>			
			<xsl:otherwise>
				<xsl:value-of select="$templateCdaLevel1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Another hard-coded lookup table -->
	<xsl:variable name="docName">
		<xsl:choose>
			<xsl:when test="$docCode = '11502-2'">General Lab Report</xsl:when>
			<xsl:when test="$docCode = '18725-2'">Microbiology Lab Report</xsl:when>
			<xsl:when test="$docCode = '18717-9'">Transfusion Medicine Lab Report</xsl:when>
			<xsl:when test="$docCode = '11526-1'">Anatomic Pathology Report</xsl:when>
			
			<xsl:when test="$docCode = '11488-4'">Consultation Note</xsl:when>
			<xsl:when test="$docCode = '11504-8'">Operative Note</xsl:when>
			<xsl:when test="$docCode = '11506-3'">Progress Note</xsl:when>
			<xsl:when test="$docCode = '11508-9'">Physical Therapy Progress Note</xsl:when>
			<xsl:when test="$docCode = '11510-5'">Psychology Progress Note</xsl:when>
			<xsl:when test="$docCode = '11522-0'">Cardiac Echo Study</xsl:when>
			<xsl:when test="$docCode = '11523-8'">EEG Study Report</xsl:when>
			<xsl:when test="$docCode = '11524-6'">EKG</xsl:when>
			<xsl:when test="$docCode = '18745-0'">Cardiac Catheterization Study</xsl:when>
			<xsl:when test="$docCode = '18748-4'">Diagnostic Imaging Study</xsl:when>
			<xsl:when test="$docCode = '18749-2'">Electromyogram Study</xsl:when>
			<xsl:when test="$docCode = '18752-6'">Exercise Stress Test Study</xsl:when>
			<xsl:when test="$docCode = '18754-2'">Holter Monitor Study</xsl:when>
			<xsl:when test="$docCode = '18842-5'">Discharge Summary</xsl:when>
			<xsl:when test="$docCode = '24858-1'">Pain Management Note</xsl:when>
			<xsl:when test="$docCode = '27445-6'">Cardiac Rehabilitation Treatment Plan, Initial Assessment</xsl:when>
			<xsl:when test="$docCode = '28570-0'">Procedure Note</xsl:when>
			<xsl:when test="$docCode = '28627-8'">Psychiatry Progress Note</xsl:when>
			<xsl:when test="$docCode = '28633-6'">Polysomnography Study</xsl:when>
			<xsl:when test="$docCode = '34099-2'">Cardiovascular Disease Consult Note</xsl:when>
			<xsl:when test="$docCode = '34108-1'">Outpatient Note</xsl:when>
			<xsl:when test="$docCode = '34111-5'">Emergency Department Note</xsl:when>
			<xsl:when test="$docCode = '34117-2'">History &amp; Physical Note</xsl:when>
			<xsl:when test="$docCode = '34748-4'">Telephone Encounter Note</xsl:when>
			<xsl:when test="$docCode = '34760-9'">Diabetology Consult Note</xsl:when>
			<xsl:when test="$docCode = '34785-6'">Mental Health Consult Note</xsl:when>
			<xsl:when test="$docCode = '34788-0'">Psychiatry Consult Note</xsl:when>
			<xsl:when test="$docCode = '34791-4'">Psychology Consult Note</xsl:when>
			<xsl:when test="$docCode = '34795-5'">Nephrology Consult Note</xsl:when>
			<xsl:when test="$docCode = '34805-2'">Oncology Consult Note</xsl:when>
			<xsl:when test="$docCode = '34815-1'">Orthopedics Note</xsl:when>
			<xsl:when test="$docCode = '34830-0'">Pulmonary Note</xsl:when>
			<xsl:when test="$docCode = '34838-3'">Respiratory Therapy Note</xsl:when>
			<xsl:when test="$docCode = '34904-3'">Mental Health Progress Note</xsl:when>
			<xsl:when test="$docCode = '36625-2'">Breast Mammogram</xsl:when>
			<xsl:when test="$docCode = '51845-6'">Outpatient Consult Note</xsl:when>
			<xsl:when test="$docCode = '51846-4'">Emergency Department Consult Note</xsl:when>
			<xsl:when test="$docCode = '51852-2'">Letter</xsl:when>
			<xsl:when test="$docCode = '57057-2'">Labour and Delivery Summary</xsl:when>
			<xsl:when test="$docCode = '59259-2'">Discharge Summary</xsl:when>
			<xsl:when test="$docCode = '59282-4'">Stress Cardiac Echo Study Report</xsl:when>
			<xsl:when test="$docCode = '67862-3'">Pre-operative Evaluation &amp; Management Note</xsl:when>
			<xsl:when test="$docCode = '68599-0'">Psychiatry History &amp; Physical</xsl:when>
			<xsl:when test="$docCode = '68636-0'">Audiology Note</xsl:when>
			<xsl:when test="$docCode = '68556-0'">Neurology Diagnostic Study Note</xsl:when>
			
			<xsl:when test="($OERept)and($OEdocType)">
				<xsl:value-of select="$OEdocType"/>
			</xsl:when>
			<xsl:otherwise>Report</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="cdaConformanceLevel">
		<xsl:choose>
			<!-- Lab/BBK/Micro Results are the only document types that can be level 3 at the moment -->
			<!-- BUT: consider non-discrete (level 1) microbiology reports to be non-lab for this -->
			<!-- Level 1 reports have only OBX.2 ='TX' so check for other OBX types. -->
			<xsl:when test="($docTemplate = '2.16.840.1.113883.3.51.60.2.1') and //OBX.2[not(contains(text(),'TX') or contains(text(),'FT'))]">
				<xsl:value-of select="'Level 3'"/>
			</xsl:when>
			<!-- Discharge Summary is the only document type that has been developed to level 2 at the moment -->
			<xsl:when test="count(//OBX[./OBX.3/text()[normalize-space(.)] != '' and (./OBX.2 = 'TX' or ./OBX.2 = 'FT')])&gt;0 and $docCode = '18842-5'">
				<xsl:value-of select="'Level 2'"/>
			</xsl:when>
			<!-- All other report types will be level 1 -->
			<xsl:otherwise>
				<xsl:value-of select="$templateCdaLevel1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="facilityId">
		<xsl:choose>
			<xsl:when test="//MSH.4/*[normalize-space(.)]">
				<xsl:value-of select="//MSH.4/*[normalize-space(.)]" />
			</xsl:when>
			<xsl:otherwise><xsl:text>IHA</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="OEdept" select="//OBR[1]/OBR.4/*[substring(name(),(string-length(name())-1))='.1']" />
						
	<!-- Determine Time Zone database in Meditech -->
	<xsl:variable name="timezonedb">
		<xsl:choose>
		
			<!-- Specimen-based results time zone: Grab the first two characters of the specimen number. -->
			<xsl:when test="((//MSH.3/*='MIC')or(//MSH.3/*='MB')or(//MSH.3/*='LAB')or(//MSH.3/*='BBK'))and(//OBR[1]/OBR.3/*[normalize-space(.)])">
				<xsl:value-of select="substring(normalize-space(//OBR[1]/OBR.3),1,2)"/>" />
			</xsl:when>
			
			<!-- OE report time zone: This may be sufficient for production. Further testing is needed. -->
			<xsl:when test="($OERept) and ($OEdept='HIM.EK' or $OEdept='PCM.EK')">
				<xsl:text>MT</xsl:text>
			</xsl:when>
			<xsl:when test="($OERept) and ($OEdept='HIM.CV' or $OEdept='PCM.CV')">
				<xsl:text>CT</xsl:text>
			</xsl:when>

			<!-- Better strategy for determining Mountain time zone for RAD reports is needed. This is not sufficient for long-term production use. -->
			<!-- xsl:when test="(//MSH.3/*='RAD')and(substring(//MSH/MSH.10,1,1)='G')" -->
			<xsl:when test="(//MSH.3/*='RAD' or //MSH.3/*='PTH') and
																	  (($facilityId='IHASC')
																	or($facilityId='IHASM')
																	or($facilityId='IHCLH')
																	or($facilityId='IHDUR')
																	or($facilityId='IHEHC')
																	or($facilityId='IHEKH')
																	or($facilityId='IHEVH')
																	or($facilityId='IHFWC')
																	or($facilityId='IHFWG')
																	or($facilityId='IHFWM')
																	or($facilityId='IHGDH')
																	or($facilityId='IHIDH')
																	or($facilityId='IHKMC')
																	or($facilityId='IHKMP')
																	or($facilityId='IHKSH')
																	or($facilityId='IHRML')
																	or($facilityId='IHSCC')
																	or($facilityId='IHSPE')
																	or($facilityId='IHSPP')
																	or($facilityId='IHSVC')
																	or($facilityId='IHTAM'))" >
				<xsl:text>MT</xsl:text>
			</xsl:when>

			<!-- RAD report CT time zone. This MAY BE sufficient for production. -->	
			<xsl:when test="(//MSH.3/*='RAD' or //MSH.3/*='PTH') and 
																	  (($facilityId='IHCVH')
																	or($facilityId='IHHCU')
																	or($facilityId='IHSVL'))">
				<xsl:text>CT</xsl:text>
			</xsl:when>
			
			<!-- When all else fails, use PT -->
			<xsl:otherwise>PT</xsl:otherwise>
			
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>
	<!-- Tranform the V2 HL7 message -->
	<xsl:template match="ns1:*|n1:*">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>type="text/xsl" href="CDA.xsl"</xsl:text>
		</xsl:processing-instruction>
		<xsl:comment>
			<xsl:text>This CDA document was automatically generated from an HL7 v2 XML message via an XSL transform.</xsl:text>
		</xsl:comment>
		<!-- === Basic ClinicalDocument header === -->
		<!-- Note that using the ClinicalDocument tag directly copies the namespaces into the output, but causes validation errors when saving this XSL in XMLSpy 2006.
<ClinicalDocument xsi:schemaLocation="urn:hl7-org:v3 CDA_R2_NormativeWebEdition2005\infrastructure\cda\CDA.xsd">
ClinicalDocument production node END  -->
		<!-- Note that using xsl:element to generate the root ClinicalDocument node works better when developing in XMLSpy 2006, but does not copy the namespaces. -->
		<xsl:element name="ClinicalDocument">
			<xsl:attribute name="xsi:schemaLocation">urn:hl7-org:v3 CDA_R2_NormativeWebEdition2005\infrastructure\cda\CDA.xsd</xsl:attribute>
			<xsl:attribute name="classCode">DOCCLIN</xsl:attribute>
			<xsl:attribute name="moodCode">EVN</xsl:attribute>
			<!-- XMLSpy ClinicalDocument node END -->
			<xsl:comment>
				<xsl:text>
********************************************************
CDA Header
********************************************************
</xsl:text>
			</xsl:comment>
			<xsl:call-template name="cdaHeader"/>
			<xsl:comment>
				<xsl:text> ==== Patient Information ==== </xsl:text>
			</xsl:comment>
			<xsl:call-template name="recordTarget"/>
			<xsl:comment>
				<xsl:text> ==== Author: Person and/or software that created this document ==== </xsl:text>
			</xsl:comment>
			<xsl:call-template name="authorPerson"/>
			<xsl:call-template name="authorSoftware"/>
			<xsl:comment>
				<xsl:text>  ==== Custodian: organization responsible for this document ==== </xsl:text>
			</xsl:comment>
			<xsl:call-template name="custodian"/>
			<xsl:comment>
				<xsl:text> ==== Information Recipients: Providers who have requested a copy of this document ==== </xsl:text>
			</xsl:comment>
			<xsl:apply-templates select="(//ORC.12|//OBR.16)[ ./*[substring(name(),(string-length(name())-1))='.2']]" mode="recipients">
				<xsl:with-param name="rType" select="'PRCP'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="(//PV1.52|//OBR.28|//PV1.7|//PV1.8|//PV1.9|//PV1.17)[ ./*[substring(name(),(string-length(name())-1))='.2']]" mode="recipients">
				<xsl:with-param name="rType" select="'TRC'"/>
			</xsl:apply-templates>
			
			<xsl:if test="//PV1.52/*[normalize-space(.)]">
				<xsl:comment><xsl:text> ==== Primary provider: Family provider ==== </xsl:text></xsl:comment>
				<xsl:element name="participant">
					<xsl:attribute name="typeCode">IND</xsl:attribute>
					<xsl:attribute name="contextControlCode">OP</xsl:attribute>
					<xsl:element name="functionCode">
						<xsl:attribute name="code">PCP</xsl:attribute>
						<xsl:attribute name="displayName">Primary Care Physician</xsl:attribute>
						<xsl:attribute name="codeSystem">2.16.840.1.113883.2.20.3.87</xsl:attribute>
						<xsl:attribute name="codeSystemName">HL7ParticipationFunction</xsl:attribute>
					</xsl:element>
					<xsl:element name="associatedEntity">
						<xsl:attribute name="classCode">PROV</xsl:attribute>
						<xsl:call-template name="formatAssignedEntity">
							<xsl:with-param name="docField" select="//PV1.52/*"/>
							<xsl:with-param name="personType" select="'associatedPerson'"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="//ORC.12/*[normalize-space(.)]|//OBR.16/*[normalize-space(.)]">
				<xsl:comment><xsl:text> ==== Ordering Physician ==== </xsl:text></xsl:comment>
				<xsl:element name="participant">
					<xsl:attribute name="typeCode">REF</xsl:attribute>
					<xsl:attribute name="contextControlCode">OP</xsl:attribute>
					<xsl:element name="functionCode">
						<xsl:attribute name="code">ORD</xsl:attribute>
						<xsl:attribute name="displayName">Ordering Provider</xsl:attribute>
							<!--
							<xsl:attribute name="codeSystem">2.16.840.1.113883.2.20.3.87</xsl:attribute>
							<xsl:attribute name="codeSystemName">HL7ParticipationFunction</xsl:attribute> -->
					</xsl:element>
					
					<xsl:if test="//ORC[1]/ORC.9/*[normalize-space(.)]" >
						<xsl:element name="time">
							<xsl:attribute name="value">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="//ORC[1]/ORC.9/*"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:element>
					</xsl:if>
												
					<xsl:element name="associatedEntity">
						<xsl:attribute name="classCode">PROV</xsl:attribute>
						<xsl:choose>
							<xsl:when test="//ORC.12/*[normalize-space(.)]">
								<xsl:call-template name="formatAssignedEntity">
									<xsl:with-param name="docField" select="//ORC.12/*"/>
									<xsl:with-param name="personType" select="'associatedPerson'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="formatAssignedEntity">
									<xsl:with-param name="docField" select="//OBR.16/*"/>
									<xsl:with-param name="personType" select="'associatedPerson'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			
			<xsl:call-template name="order"/>
			
			<!-- Procedure: can be populated for DI reports, must be present for Procedure Notes (although it will be empty/nullFlavor), 
				  and is used in Lab reports if the status is not set to FINAL. -->
				  
			<xsl:if test="($docCode = '18748-4') or ($docCode = '28570-0') or ($docTemplate = '2.16.840.1.113883.3.51.60.2.1' and //OBR/OBR.25 != 'F')">
				<xsl:comment>
					<xsl:text> ==== Service Event: Procedure ==== </xsl:text>
				</xsl:comment>
				<xsl:call-template name="procedure"/>
			</xsl:if>
			
			<xsl:comment>
				<xsl:text> ==== Parent Document: HL7 v2 message from Meditech ==== </xsl:text>
			</xsl:comment>
			<xsl:call-template name="relatedDocument"/>
			
			<xsl:comment>
				<xsl:text> ==== Encompassing Encounter: Patient Visit ==== </xsl:text>
			</xsl:comment>
			<xsl:call-template name="encounter"/>
			
			<xsl:choose>
				<xsl:when test="$cdaConformanceLevel=$templateCdaLevel1">
					<xsl:call-template name="level1body"/>
				</xsl:when>
				<!-- Dealing with the very non-standard Meditech Blood Bank Product messages -->
				<xsl:when test="(//MSH.3/* = 'BBK') and (//OBR/OBR.15/*[substring(name(),(string-length(name())-1))='.1']/*[text()] = 'P') and (//OBX/OBX.1/*[substring(name(),(string-length(name())-1))='.2'])">
				   <xsl:call-template name="bbkBody"/>
				</xsl:when>
				<xsl:when test="$docTemplate = '2.16.840.1.113883.3.51.60.2.1'">
					<xsl:call-template name="labBody"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="level2body"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Use this if developing in XMLSpy -->
		</xsl:element>
		<!-- Use this when not developing the XSL 
	</ClinicalDocument> -->
	</xsl:template>
	<!-- ======== CDA HEADER ======== -->
	<xsl:template name="cdaHeader">
		<xsl:element name="realmCode">
			<xsl:attribute name="code">CA-BC</xsl:attribute>
		</xsl:element>
		<xsl:element name="typeId">
			<xsl:attribute name="root">2.16.840.1.113883.1.3</xsl:attribute>
			<xsl:attribute name="extension">POCD_HD000040</xsl:attribute>
			<xsl:attribute name="assigningAuthorityName">HL7 CDA R2</xsl:attribute>
		</xsl:element>

			<xsl:call-template name="formatTemplateId">
				<xsl:with-param name="templateOID">
					<xsl:value-of select="$docTemplate"/>
				</xsl:with-param>
				<xsl:with-param name="templateDesc">
					<xsl:value-of select="$docName"/>
					<xsl:text> template</xsl:text>
				</xsl:with-param>
			</xsl:call-template>

		<!-- ClinicalDocument\id is required to have a GUID. -->
		<xsl:call-template name="formatId">
			<xsl:with-param name="root">
				<xsl:value-of select="$CDXMessageOid"/>
			</xsl:with-param>
			<xsl:with-param name="id">
				<xsl:value-of select="$var:v1"/>
			</xsl:with-param>
			<xsl:with-param name="idDesc">
				<xsl:value-of select="$CDXMessageOidDisp"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- Code is mandatory, but we don't always know it, so allow for nullFlavor -->
		<xsl:element name="code">
			<xsl:choose>
				<xsl:when test="not($docCode = '')">
					<xsl:attribute name="codeSystem"><xsl:value-of select="$loincRootOid"/></xsl:attribute>
					<xsl:attribute name="code"><xsl:copy-of select="$docCode"/></xsl:attribute>
					<xsl:attribute name="displayName"><xsl:copy-of select="$docName"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="title">
			<xsl:copy-of select="$docName"/>
		</xsl:element>
		<xsl:element name="effectiveTime">
			<xsl:attribute name="value">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="//MSH.7/*"/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="confidentialityCode">
			<xsl:attribute name="code">N</xsl:attribute>
			<xsl:attribute name="codeSystem">2.16.840.1.113883.5.25</xsl:attribute>
			<xsl:attribute name="codeSystemName">Confidentiality</xsl:attribute>
		</xsl:element>
		<xsl:element name="languageCode">
			<xsl:attribute name="code">en-CA</xsl:attribute>
		</xsl:element>
	</xsl:template>
	<!-- ======== Patient Information ======= -->
	<xsl:template name="recordTarget">
		<xsl:element name="recordTarget">
			<xsl:attribute name="typeCode">RCT</xsl:attribute>
			<xsl:attribute name="contextControlCode">OP</xsl:attribute>
			<xsl:element name="patientRole">
				<xsl:attribute name="classCode">PAT</xsl:attribute>
				<!-- Patient PHN 
        <xsl:if test="//PID.4/*|//PID.19">
        -->
				<xsl:call-template name="formatId">
					<xsl:with-param name="root">
						<xsl:value-of select="$bcPhnRootOid"/>
					</xsl:with-param>
					<xsl:with-param name="id">
						<xsl:choose>
							<xsl:when test="//PID.4/text()|//PID.4/*[text()]">
								<xsl:value-of select="//PID.4/*|//PID.4/*[text()]"/>
							</xsl:when>
							<xsl:when test="//PID.19/text()">
								<xsl:value-of select="//PID.19/*"/>
							</xsl:when>
							<xsl:otherwise>UNK</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="idDesc">
						<xsl:value-of select="$bcPhnRootOidDisp"/>
					</xsl:with-param>
				</xsl:call-template>
				<!-- Patient EMR Number   -->
				<xsl:if test="//PID.2/text()|//PID.2/*[text()]">
					<xsl:call-template name="formatId">
						<xsl:with-param name="root">
							<xsl:value-of select="$ptEmrRootOid"/>
						</xsl:with-param>
						<xsl:with-param name="id">
							<xsl:value-of select="//PID.2/*"/>
						</xsl:with-param>
						<xsl:with-param name="idDesc">
							<xsl:value-of select="$ptEmrRootOidDisp"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<!-- Patient Unit Number -->
				<xsl:if test="//PID.3/text()|//PID.3/*[text()]">
					<xsl:call-template name="formatId">
						<xsl:with-param name="root">
							<xsl:value-of select="$ptUnitRootOid"/>
						</xsl:with-param>
						<xsl:with-param name="id">
							<xsl:value-of select="//PID.3/*"/>
						</xsl:with-param>
						<xsl:with-param name="idDesc">
							<xsl:value-of select="$ptUnitRootOidDisp"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:apply-templates select="//PID.11"/>
				<xsl:if test="//PID.13/text()|//PID.13/*[text()]">
					<xsl:call-template name="formatTelecom">
						<xsl:with-param name="telno">
							<xsl:choose>
								<xsl:when test="//PID.13/*[substring(name(),(string-length(name())-1))='.1']">
									<xsl:value-of select="//PID.13/*[substring(name(),(string-length(name())-1))='.1']"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="//PID.13/text()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="use">H</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="//PID.14/text()[normalize-space(.)]|//PID.14/*[normalize-space(text())]">
					<xsl:call-template name="formatTelecom">
						<xsl:with-param name="telno">
							<xsl:choose>
								<xsl:when test="//PID.14/*[substring(name(),(string-length(name())-1))='.1']">
									<xsl:value-of select="//PID.14/*[substring(name(),(string-length(name())-1))='.1']"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="//PID.14/text()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="use">WP</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:element name="patient">
					<xsl:attribute name="classCode">PSN</xsl:attribute>
					<xsl:attribute name="determinerCode">INSTANCE</xsl:attribute>
					<!-- Patient Name -->
					<xsl:variable name="ptName" select="//PID.5/*"/>
					<xsl:element name="name">
						<xsl:attribute name="use">L</xsl:attribute>
						<xsl:element name="family">
							<xsl:value-of select="$ptName[substring(name(),(string-length(name())-1))='.1']"/>
						</xsl:element>
						<xsl:element name="given">
							<xsl:value-of select="$ptName[substring(name(),(string-length(name())-1))='.2']"/>
						</xsl:element>
						<xsl:if test="$ptName[substring(name(),(string-length(name())-1))='.3']">
							<xsl:element name="given">
								<xsl:value-of select="$ptName[substring(name(),(string-length(name())-1))='.3']"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
					<!-- ========= -->
					<xsl:element name="administrativeGenderCode">
						<xsl:attribute name="code"><xsl:value-of select="//PID.8"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="birthTime">
						<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//PID.7/*"/></xsl:call-template></xsl:attribute>
					</xsl:element>
					<xsl:if test="//PID.16/*">
						<xsl:element name="maritalStatusCode">
							<xsl:attribute name="code"><xsl:value-of select="//PID.16"/></xsl:attribute>
						</xsl:element>
					</xsl:if>
					<xsl:if test="//PID.17/*">
						<xsl:element name="religiousAffiliationCode">
							<xsl:attribute name="code"><xsl:value-of select="//PID.16"/></xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- ====== Patient Address(es) ====== -->
	<xsl:template match="PID.11">
         <xsl:call-template name="formatAddress">
			<xsl:with-param name="addr" select="./*"/>
		</xsl:call-template>
	</xsl:template>
	<!-- ====== Human Author Information ===== -->
	<xsl:template name="authorPerson">
		<xsl:if test="//OBR.32/*">
			<xsl:element name="author">
				<xsl:attribute name="typeCode">AUT</xsl:attribute>
				<xsl:attribute name="contextControlCode">OP</xsl:attribute>
				<xsl:element name="time">
					<xsl:choose>
						<xsl:when test="//OBR/OBR.7/*[text()]">
							<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//OBR.7/*"/></xsl:call-template></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="assignedAuthor">
					<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
					<xsl:call-template name="formatAssignedEntity">
						<xsl:with-param name="docField" select="//OBR.32/*"/>
						<xsl:with-param name="personType" select="'assignedPerson'"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- ====== Authoring Software Information ===== -->
	<xsl:template name="authorSoftware">
		<xsl:element name="author">
			<xsl:attribute name="typeCode">AUT</xsl:attribute>
			<xsl:attribute name="contextControlCode">OP</xsl:attribute>
			<xsl:element name="time">
					<xsl:choose>
						<xsl:when test="//OBR/OBR.7/*[text()]">
							<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//OBR.7/*"/></xsl:call-template></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
			</xsl:element>
			<xsl:element name="assignedAuthor">
				<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
				<xsl:call-template name="formatId">
					<xsl:with-param name="id"><xsl:value-of select="//MSH.10"/></xsl:with-param>
					<xsl:with-param name="root"><xsl:value-of select="$messageNumberRootOid"/></xsl:with-param>
					<xsl:with-param name="idDesc"><xsl:value-of select="$messageNumberRootOidDisp"/></xsl:with-param>				
				</xsl:call-template>
				<xsl:element name="code">
					<xsl:attribute name="code"><xsl:text>HL7v</xsl:text><xsl:value-of select="//MSH.12/*"/></xsl:attribute>
					<xsl:attribute name="codeSystem"><xsl:value-of select="$deviceRootOid"/></xsl:attribute>
					<xsl:attribute name="codeSystemName"><xsl:value-of select="$deviceRootOidDisp"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="assignedAuthoringDevice">
					<xsl:attribute name="classCode">DEV</xsl:attribute>
					<xsl:attribute name="determinerCode">INSTANCE</xsl:attribute>

					<xsl:variable name="facilityId">
						<xsl:choose>
							<xsl:when test="//MSH.4/*[normalize-space(.)]">
								<xsl:value-of select="//MSH.4/*[normalize-space(.)]" />
							</xsl:when>
							<xsl:otherwise><xsl:text>IHA</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
										
					<xsl:element name="softwareName">
						<xsl:attribute name="code"><xsl:value-of select="//MSH.3/*"/><xsl:text>_</xsl:text><xsl:value-of select="$facilityId"/></xsl:attribute>
						<xsl:attribute name="codeSystem"><xsl:value-of select="$softwareRootOid"/></xsl:attribute>
						<xsl:attribute name="codeSystemName"><xsl:value-of select="$softwareRootOidDisp"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- ====== Custodian Information ====== -->
	<xsl:template name="custodian">
		<xsl:element name="custodian">
			<xsl:attribute name="typeCode">CST</xsl:attribute>
			<xsl:element name="assignedCustodian">
				<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
				<xsl:element name="representedCustodianOrganization">
					<xsl:attribute name="classCode">ORG</xsl:attribute>
					<xsl:attribute name="determinerCode">INSTANCE</xsl:attribute>

					<xsl:variable name="facilityId">
						<xsl:choose>
							<xsl:when test="//MSH.4/*[normalize-space(.)]">
								<xsl:value-of select="//MSH.4/*[normalize-space(.)]" />
							</xsl:when>
							<xsl:otherwise><xsl:text>IHA</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:call-template name="formatId">
						<xsl:with-param name="root">
							<xsl:value-of select="$facilityRootOid"/>
						</xsl:with-param>
						<xsl:with-param name="id">
							<xsl:value-of select="$facilityId"/>
						</xsl:with-param>
						<xsl:with-param name="idDesc">
							<xsl:value-of select="$facilityRootOidDisp"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- === === Document Recipients  === === -->
	<xsl:template match="*" mode="recipients">
		<xsl:param name="rType" select="'none'"/>
		<xsl:variable name="provCode" select="./*[substring(name(),(string-length(name())-1))='.1']"/>
		<!-- Only providers with prov. license codes -->
		<xsl:if test="$provCode">
			<xsl:variable name="docType">
				<xsl:choose>
					<!-- === The PRIMARY recipient(s) === -->
					<xsl:when test="((//ORC.12|//OBR.16)/*[substring(name(),(string-length(name())-1))='.1'] = $provCode)">PRCP</xsl:when>
					<!-- === SECONDARY recipient(s) === -->
					<xsl:otherwise>TRC</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- xsl:if test="($rType='none') or ($rType=$docType)" -->
			<!-- This is an example of Muenchian grouping.  See http://www.jenitennison.com/xslt/grouping/muenchian.html -->
			<!-- Briefly: Using a key() dictionary of all the recipients and their BC provider license code,  -->
			<!--             use only the first occurance of each provider (to avoid duplication of providers) -->
			<xsl:if test="count(. | key('providers', $provCode)[1]) = 1">
				<xsl:call-template name="recipient">
					<xsl:with-param name="docNode" select="./*"/>
					<xsl:with-param name="pDocType" select="$docType"/>
				</xsl:call-template>
			</xsl:if>
			<!-- /xsl:if -->
		</xsl:if>
	</xsl:template>
	<xsl:template name="recipient">
		<xsl:param name="docNode"/>
		<xsl:param name="pDocType"/>
		<xsl:element name="informationRecipient">
			<xsl:attribute name="typeCode"><xsl:value-of select="$pDocType"/></xsl:attribute>
			<xsl:element name="intendedRecipient">
				<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
				<xsl:call-template name="formatAssignedEntity">
					<xsl:with-param name="docField" select="$docNode"/>
					<xsl:with-param name="personType" select="'informationRecipient'"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- ======== Order Information ======== -->
	<xsl:template name="order">
		<xsl:if test="(//ORC.2/*[text()]) or (//OBX[1]/OBX.3/*[substring(name(),(string-length(name())-1))='.3']/text()[normalize-space(.)])">
			<xsl:comment>
				<xsl:text> ==== Order information ==== </xsl:text>
			</xsl:comment>
			<xsl:element name="inFulfillmentOf">
				<xsl:attribute name="typeCode">FLFS</xsl:attribute>
				<xsl:element name="order">
					<xsl:attribute name="classCode">ENC</xsl:attribute>
					<xsl:attribute name="moodCode">RQO</xsl:attribute>
					<xsl:call-template name="formatId">
						<xsl:with-param name="root">
							<xsl:value-of select="$orderRootOid"/>
						</xsl:with-param>
						<xsl:with-param name="id">
							<xsl:choose>
								<xsl:when test="//OBX[1]/OBX.3/*[substring(name(),(string-length(name())-1))='.3']/text()[normalize-space(.)]">
									<xsl:value-of select="//OBX[1]/OBX.3/*[substring(name(),(string-length(name())-1))='.3']/text()[normalize-space(.)]"/>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="//ORC.2/*"/></xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="idDesc">
							<xsl:value-of select="$orderRootOidDisp"/>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:if test="//ORC.3/*[normalize-space(.)]">
						<xsl:call-template name="formatId">
							<xsl:with-param name="root">
								<xsl:value-of select="$orderAltRootOid"/>
							</xsl:with-param>
							<xsl:with-param name="id">
								<xsl:value-of select="//ORC.3/*"/>
							</xsl:with-param>
							<xsl:with-param name="idDesc">
								<xsl:value-of select="$orderAltRootOidDisp"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="//ORC.1/*[text()]">
						<xsl:element name="code">
							<xsl:attribute name="code"><xsl:value-of select="//ORC.1"/><xsl:if test="//ORC.5/*[text()]"><xsl:text>:</xsl:text><xsl:value-of select="//ORC.5"/></xsl:if><xsl:if test="//ORC.6/*[text()]"><xsl:text>:</xsl:text><xsl:value-of select="//ORC.6"/></xsl:if></xsl:attribute>
							<xsl:attribute name="codeSystemName">Order Status (Order Control:Order Status:Response Flag)</xsl:attribute>
						</xsl:element>
					</xsl:if>
					<!-- NON-STANDARD BEGIN 

				<xsl:element name="statusCode" >
					<xsl:attribute name="code"><xsl:value-of select="//ORC.5" /></xsl:attribute>
				</xsl:element>

				<xsl:element name="effectiveTime" >
					<xsl:attribute name="value">
						<xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="//ORC.9"/>
						</xsl:call-template>
					</xsl:attribute>
				</xsl:element>
				
				 END NON-STANDARD -->
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- ======== Procedure Information ======== -->
	<xsl:template name="procedure">
		<xsl:element name="documentationOf">
			<xsl:attribute name="typeCode">DOC</xsl:attribute>
			<xsl:element name="serviceEvent">
				<xsl:attribute name="classCode">ACT</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<!-- xsl:element name="id" / -->
				<!-- We don't have any info coming from Meditech -->
				
				<xsl:choose>
					<xsl:when test="($docCode='18748-4') and (//OBR[1]/OBR.4/*/text()[normalize-space(.)])">
					
						<!-- Radiology procedure codes: Need to remove spaces first -->
						<xsl:variable name="RADcode">
							<xsl:call-template name="replaceCharsInString">
								<xsl:with-param name="stringIn">
									<xsl:value-of select="//OBR[1]/OBR.4/*[substring(name(),(string-length(name())-1))='.1']/text()[normalize-space(.)]"/>
									<xsl:text>:</xsl:text>
									<xsl:value-of select="//OBR[1]/OBR.4/*[substring(name(),(string-length(name())-1))='.2']/text()[normalize-space(.)]"/>
								</xsl:with-param>
								<xsl:with-param name="charsIn" select="' '"/>
								<xsl:with-param name="charsOut" select="'_'"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:element name="code">
							<xsl:attribute name="code">
								<xsl:value-of select="$RADcode"/>
							</xsl:attribute>
							<xsl:attribute name="displayName">
								<xsl:value-of select="//OBR[1]/OBR.4/*[substring(name(),(string-length(name())-1))='.3']/text()[normalize-space(.)]"/>
							</xsl:attribute>
							<xsl:attribute name="codeSystemName"><xsl:text>Meditech RAD Procedure Code</xsl:text></xsl:attribute>
						</xsl:element>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="code">
							<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:element name="effectiveTime">
				  <xsl:choose>
					<xsl:when test="//OBR.7/*[normalize-space(.)]">
						<xsl:attribute name="value">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="date" select="//OBR.7/*"/>
							</xsl:call-template>
						</xsl:attribute>					
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
					</xsl:otherwise>
				  </xsl:choose>
				</xsl:element>
				
				<xsl:if test="//OBR.16/*[normalize-space(.)]">
				<xsl:element name="performer">
					<xsl:attribute name="typeCode">PPRF</xsl:attribute>
					<xsl:element name="assignedEntity">
						<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
						<xsl:call-template name="formatAssignedEntity">
							<xsl:with-param name="docField" select="//OBR.16/*"/>
							<xsl:with-param name="personType" select="'assignedPerson'"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
				</xsl:if>
				
				<!-- Lab report with non-final status on any of the tests -->
				<xsl:if test="($docTemplate = '2.16.840.1.113883.3.51.60.2.1') and (//OBR/OBR.25 != 'F')">
					<xsl:element name="lab:statusCode">
						<xsl:attribute name="code">active</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- ======== Transformed From HL7 v2 Message ======== -->	
	<xsl:template name="relatedDocument">
		<xsl:element name="relatedDocument">
			<xsl:attribute name="typeCode">XFRM</xsl:attribute>
			<xsl:element name="parentDocument">
				<xsl:call-template name="formatId">
					<xsl:with-param name="id"><xsl:value-of select="//MSH.10"/></xsl:with-param>
					<xsl:with-param name="root"><xsl:value-of select="$messageNumberRootOid"/></xsl:with-param>
					<xsl:with-param name="idDesc"><xsl:value-of select="$messageNumberRootOidDisp"/></xsl:with-param>				
				</xsl:call-template>		
				<xsl:element name="code">
					<xsl:attribute name="code"><xsl:text>HL7v</xsl:text><xsl:value-of select="//MSH.12/*"/></xsl:attribute>
					<xsl:attribute name="codeSystem"><xsl:value-of select="$deviceRootOid"/></xsl:attribute>
					<xsl:attribute name="codeSystemName"><xsl:value-of select="$deviceRootOidDisp"/></xsl:attribute>
				</xsl:element>	
			</xsl:element>
		</xsl:element>
	</xsl:template>	
	<!-- ===== Patient Visit / Encounter Info ====== -->
	<xsl:template name="encounter">
		<xsl:element name="componentOf">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="encompassingEncounter">
				<xsl:attribute name="classCode">ENC</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:call-template name="formatId">
					<xsl:with-param name="root">
						<xsl:value-of select="$ptVisitRootOid"/>
					</xsl:with-param>
					<xsl:with-param name="id">
						<xsl:value-of select="//PID.18/*"/>
					</xsl:with-param>
					<xsl:with-param name="idDesc">
						<xsl:value-of select="$ptVisitRootOidDisp"/>
					</xsl:with-param>
				</xsl:call-template>
				<!--
					<xsl:element name="code">
					</xsl:element>
				-->
				<xsl:if test="//PV1.44/*[normalize-space(.)]">
					<xsl:choose>
						<xsl:when test="//PV1.45/*[normalize-space(.)]">
							<xsl:comment>
								<xsl:text>Encounter has an admission date (low) and discharge date (high)</xsl:text>
							</xsl:comment>
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment>
								<xsl:text>Encounter has an admission date only</xsl:text>
							</xsl:comment>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:element name="effectiveTime">
						<xsl:choose>
							<xsl:when test="//PV1.45/*[normalize-space(.)]">
								<xsl:element name="low">
									<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//PV1.44/*"/></xsl:call-template></xsl:attribute>
								</xsl:element>
								<xsl:element name="high">
									<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//PV1.45/*"/></xsl:call-template></xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="//PV1.44/*"/></xsl:call-template></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
				<xsl:if test="//PV1.36/*[text()]">
					<xsl:element name="dischargeDispositionCode">
						<xsl:attribute name="code"><xsl:value-of select="//PV1.36"/></xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- ======== Admitting Doctor ======== -->
				<xsl:if test="//PV1.17/*[text()]">
					<xsl:element name="encounterParticipant">
						<xsl:attribute name="typeCode">ADM</xsl:attribute>
						<xsl:element name="assignedEntity">
							<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
							<xsl:call-template name="formatAssignedEntity">
								<xsl:with-param name="docField" select="//PV1.17/*"/>
								<xsl:with-param name="personType" select="'assignedPerson'"/>
							</xsl:call-template>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- ======== Attending Doctor ======== -->
				<xsl:if test="//PV1.7/*[text()]">
					<xsl:element name="encounterParticipant">
						<xsl:attribute name="typeCode">ATND</xsl:attribute>
						<xsl:element name="assignedEntity">
							<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
							<xsl:call-template name="formatAssignedEntity">
								<xsl:with-param name="docField" select="//PV1.7/*"/>
								<xsl:with-param name="personType" select="'assignedPerson'"/>
							</xsl:call-template>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- ======== Consulting Doctor ======== -->
				<xsl:if test="//PV1.9/*[text()]">
					<xsl:element name="encounterParticipant">
						<xsl:attribute name="typeCode">CON</xsl:attribute>
						<xsl:element name="assignedEntity">
							<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
							<xsl:call-template name="formatAssignedEntity">
								<xsl:with-param name="docField" select="//PV1.9/*"/>
								<xsl:with-param name="personType" select="'assignedPerson'"/>
							</xsl:call-template>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- ======== Admitting Facility ======== -->
				<xsl:element name="location">
					<xsl:element name="healthCareFacility">
						<xsl:attribute name="classCode">SDLOC</xsl:attribute>
						<xsl:call-template name="formatId">
							<xsl:with-param name="root">
								<xsl:value-of select="$facilityRootOid"/>
							</xsl:with-param>
							<xsl:with-param name="id">
								<xsl:value-of select="//PV1.39"/>
							</xsl:with-param>
							<xsl:with-param name="idDesc">
								<xsl:value-of select="$facilityRootOidDisp"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:comment>code represents the patient location, in the form "Pt.Type:Unit[:Room[:Bed]]"</xsl:comment>
						<xsl:element name="code">
							<xsl:attribute name="code">
							     <xsl:value-of select="//PV1.18"/><xsl:text>:</xsl:text>
							     <xsl:value-of select="//PV1.3/*[substring(name(),(string-length(name())-1))='.1']"/>
							     <xsl:if test="//PV1.3/*[substring(name(),(string-length(name())-1))='.2']">
							        <xsl:text>:</xsl:text>
							        <xsl:value-of select="//PV1.3/*[substring(name(),(string-length(name())-1))='.2']"/>
							        <xsl:if test="//PV1.3/*[substring(name(),(string-length(name())-1))='.3']">
							           <xsl:text>:</xsl:text>
							           <xsl:value-of select="//PV1.3/*[substring(name(),(string-length(name())-1))='.3']"/>
							        </xsl:if>
							     </xsl:if>
							</xsl:attribute>
							<xsl:attribute name="codeSystemName">
							     <xsl:text>Patient Type:Unit</xsl:text>
							     <xsl:if test="//PV1.3/*[substring(name(),(string-length(name())-1))='.2']">
							        <xsl:text>:Room</xsl:text>
							        <xsl:if test="//PV1.3/*[substring(name(),(string-length(name())-1))='.3']">
							           <xsl:text>:Bed</xsl:text>
							        </xsl:if>
							     </xsl:if>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- ================================== -->
	<!-- ======== LEVEL 1 TEXT BODY ======== -->
	<xsl:template name="level1body">
		<xsl:text>
    </xsl:text>
		<xsl:comment>
			<xsl:text> 
********************************************************
CDA Body: Level 1 - Basic Text Report  
********************************************************
    </xsl:text>
		</xsl:comment>
		<xsl:text>
    </xsl:text>
		<xsl:element name="component">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="nonXMLBody">
				<xsl:attribute name="classCode">DOCBODY</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:element name="text">
					<xsl:attribute name="mediaType">text/plain</xsl:attribute>
					<xsl:attribute name="representation">TXT</xsl:attribute>
					<xsl:apply-templates select="//OBX[not(./OBX.3/text()[normalize-space(.)])]|//OBX[(./OBX.2 = 'TX' or ./OBX.2 = 'FT')]" mode="reportmode"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Level 1 Text Reports -->
	<xsl:template match="//OBX" mode="reportmode">
	<xsl:variable name="obx5">
		<xsl:choose>
			<xsl:when test="./OBX.5/*[text()]">
				<xsl:value-of select="./OBX.5/*[text()]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./OBX.5/text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
		<!-- Handle NHA OBX segments with \.br\ line delimiters -->
		<xsl:choose>
			<xsl:when test="OBX.5[contains(., '\.br\')]">
				<xsl:call-template name="replaceCharsInString">
					<xsl:with-param name="stringIn" select="$obx5"/>
					<xsl:with-param name="charsIn" select="'\.br\'"/>
					<xsl:with-param name="charsOut" select="'&#xa;'"/>
				</xsl:call-template>
			</xsl:when>
			<!-- The plain IHA one-line-per-OBX method -->
			<xsl:otherwise>
				<xsl:value-of select="$obx5"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	<!-- Handy, recursive replace-text template
        Found at http://www.dpawson.co.uk/xsl/sect2/replace.html
   -->
	<xsl:template name="replaceCharsInString">
		<xsl:param name="stringIn"/>
		<xsl:param name="charsIn"/>
		<xsl:param name="charsOut"/>
		<xsl:choose>
			<xsl:when test="contains($stringIn,$charsIn)">
				<xsl:value-of select="concat(substring-before($stringIn,$charsIn),$charsOut)"/>
				<xsl:call-template name="replaceCharsInString">
					<xsl:with-param name="stringIn" select="substring-after($stringIn,$charsIn)"/>
					<xsl:with-param name="charsIn" select="$charsIn"/>
					<xsl:with-param name="charsOut" select="$charsOut"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stringIn"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====================================== -->
	<!-- ========= BBK PRODUCT MESSAGE ======== -->
	<xsl:template name="bbkBody">
		<xsl:variable name="crlf">
           <xsl:text>
           </xsl:text>
        </xsl:variable>
		<!-- length 100! -->
		<xsl:variable name="LineSeparator">
			<xsl:text>----------------------------------------------------------------------------------------------------</xsl:text>
			<xsl:value-of select="$crlf"/>
        </xsl:variable>      
	<xsl:element name="component">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="nonXMLBody">
				<xsl:attribute name="classCode">DOCBODY</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:element name="text">
					<xsl:attribute name="mediaType">text/plain</xsl:attribute>
					<xsl:attribute name="representation">TXT</xsl:attribute>
						<xsl:value-of select="$crlf" />
						<xsl:value-of select="$LineSeparator" />
						<!-- ORDER INFO LINE: Assumes (perhaps dangerously) that there is only one ORC/OBR pair in these messages. -->
						<!-- "SPEC #: " + obr3 + "       COLL: " + FormatDateTime(obr7) + "     STATUS: " + orc5 + "           REQ #: " + obr4_3 -->
						<xsl:text> SPEC #: </xsl:text><xsl:value-of select="//OBR/OBR.3/*"/>
						<xsl:text>    COLL: </xsl:text><xsl:value-of select="//OBR/OBR.7/*"/>
						<xsl:text>   STATUS: </xsl:text><xsl:value-of select="//ORC/ORC.5"/>
						<xsl:text>           REQ #: </xsl:text><xsl:value-of select="//OBR/OBR.4/*[substring(name(),(string-length(name())-1))='.3']"/>
						<xsl:value-of select="$crlf"/>
						<!-- Received datetime and submitting provider -->
						<xsl:text>   RECD: </xsl:text>
						<xsl:call-template name="formatTextDate">
							<xsl:with-param name="date" select="//OBR/OBR.14/*" />
						</xsl:call-template>
						<xsl:if test="//OBR.16">
							<xsl:text>                          SUBM DR: </xsl:text>
							<xsl:call-template name="formatTextProvider">
								<xsl:with-param name="provider" select="//OBR.16/*" />
							</xsl:call-template>
						</xsl:if>
						<xsl:value-of select="$crlf"/>
						<!-- Entered datetime + Other provider -->
						<xsl:text>ENTERED: </xsl:text>
						<xsl:call-template name="formatTextDate">
							<xsl:with-param name="date" select="//ORC/ORC.9/*" />
						</xsl:call-template>
						<xsl:if test="//OBR.28">
							<xsl:text>                         OTHER DR: </xsl:text>
							<xsl:call-template name="formatTextProvider">
								<xsl:with-param name="provider" select="//OBR.28[1]/*" />
							</xsl:call-template>
						</xsl:if>
						<xsl:value-of select="$crlf"/>
						<!-- Copy-To providers -->
						<xsl:value-of select="$crlf"/>
						<!-- Ordered products -->
						<xsl:text>ORDERED PRODUCTS: </xsl:text>
						<xsl:value-of select="//OBR/OBR.4/*[substring(name(),(string-length(name())-1))='.2']" />
						<xsl:value-of select="$crlf"/><xsl:value-of select="$crlf"/>	
						<!-- Comments / Queries -->
						<xsl:if test="//NTE1">
							<xsl:text>COMMENTS/QUERIES:</xsl:text>
							<xsl:apply-templates select="//NTE1" mode="bbkNotes"/>
							<xsl:apply-templates select="//NTE2" mode="bbkNotes"/>
							<xsl:value-of select="$crlf"/><xsl:value-of select="$crlf"/>	
						</xsl:if>
						<!-- Product Section -->
						<xsl:apply-templates select="//OBX" mode="bbkOBX" >
							<xsl:with-param name="LineSeparator" select="$LineSeparator"/>
							<xsl:with-param name="crlf" select="$crlf"/>
						</xsl:apply-templates>
						
                        <xsl:value-of select="$crlf"/>	
						<xsl:value-of select="$LineSeparator"/>
						
				</xsl:element>
			</xsl:element>
		</xsl:element>		
	</xsl:template>
	<xsl:template match="*" mode="bbkOrder">
		<xsl:variable name="crlf">
           <xsl:text>
           </xsl:text>
        </xsl:variable>	
	</xsl:template>
	<xsl:template match="*" mode="bbkNotes">
             <xsl:text>
             </xsl:text>
             <xsl:if test="NTE.2">
 			     <xsl:value-of select="./NTE.2"	/><xsl:text>    </xsl:text>
			 </xsl:if>
             <xsl:value-of select="./NTE.3"	/>
	</xsl:template>
	
	<xsl:template match="*" mode="bbkOBX">
		<xsl:param name="LineSeparator"/>
		<xsl:param name="crlf"/>
		
		<xsl:value-of select="$LineSeparator"/>
		<!-- headers -->
		<xsl:apply-templates select="./OBX.5" mode="bbkValues" >
		     <xsl:with-param name="isHead" select="true()"/>
		</xsl:apply-templates>
		<xsl:value-of select="$crlf"/>	
		<xsl:value-of select="$LineSeparator"/>
		<!-- details -->
		<xsl:apply-templates select="./OBX.5" mode="bbkValues" >
			 <xsl:with-param name="isHead" select="false()"/>
		</xsl:apply-templates>
		<xsl:value-of select="$crlf"/>	
	</xsl:template>
	
	<xsl:template match="*" mode="bbkValues">
	    <xsl:param name="isHead" select="true()"/>

        <xsl:variable name="padding"><xsl:text>                                                                                                    </xsl:text></xsl:variable>
		<xsl:variable name="heading" select="./*[substring(name(),(string-length(name())-1))='.1']"/>
		<xsl:variable name="bbkValue" select="./*[substring(name(),(string-length(name())-1))='.2']"/>
        <xsl:variable name="headlen" select="string-length($heading)"/>
        <xsl:variable name="valuelen" select="string-length($bbkValue)"/>
        <xsl:variable name="maxlen">
			<xsl:choose>
				<xsl:when test="$headlen > $valuelen"><xsl:value-of select="$headlen"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$valuelen"/></xsl:otherwise>
			</xsl:choose>
        </xsl:variable>
        <xsl:variable name="theString">
			<xsl:choose>
				<xsl:when test="$isHead"><xsl:value-of select="$heading"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$bbkValue"/></xsl:otherwise>
			</xsl:choose>
        </xsl:variable>
        
	    <xsl:value-of select="substring(concat($theString, $padding), 1, $maxlen+3)"/>
	    
	</xsl:template>

	<!-- ====================================== -->
	<!-- ========= DISCRETE LAB RESULTS ======== -->
	<xsl:template name="labBody">
		<xsl:text>
    </xsl:text>
		<xsl:comment>
			<xsl:text> 
********************************************************
CDA Body: Level 3 - Discrete Lab Results  
********************************************************
</xsl:text>
		</xsl:comment>
		<xsl:text>
    </xsl:text>
		<xsl:call-template name="LabSpecialtySection"/>
	</xsl:template>
	<!--
<xsl:template match="OBR" mode="LabSpecialtySection">
-->
	<!-- =========Lab Specialty Section: main lab results container ======== -->
	<xsl:template name="LabSpecialtySection">
		<xsl:variable name="obrSet" select="//OBR[1]/OBR.1"/>
		
		<xsl:variable name="obrCode">
		<xsl:choose>
			<!-- If we have the pCLOCD code, use it -->
			<xsl:when test="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.4'][normalize-space(.)]">
			   <xsl:value-of select="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.4']" />
			</xsl:when>
			<!-- Uh oh, no pCLOCD code, try the local code! -->
			<xsl:when test="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.1'][normalize-space(.)]">
			   <xsl:value-of select="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.1']" />
			</xsl:when>
			<!-- If we don't have either a pCLOCD code or a local code, we're in trouble. This message will probably fail. But try to save it anyway. -->
			<xsl:otherwise>
				<xsl:text>unknown</xsl:text>
			</xsl:otherwise>
		</xsl:choose> 
		</xsl:variable>
		
		<xsl:variable name="obrCodeName">
			<xsl:choose>
				<xsl:when test="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.5'][normalize-space(.)]">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.5']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.2'][text()]">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.2']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Code Name Not Provided</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="obrCodeSystemName">
			<xsl:choose>
				<!-- We have a standard code -->
				<xsl:when test="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.4'][text()]">
					<xsl:value-of select="//OBR[./OBR.1=$obrSet]/OBR.4/*[substring(name(),(string-length(name())-1))='.6']"/>
				</xsl:when>
				<!-- Local code only -->
				<xsl:otherwise>
					<xsl:text>Local IHA LIS Code</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="obrCodeSystemOID">
			<xsl:choose>
				<xsl:when test="$obrCodeSystemName = 'pCLOCD'">2.16.840.1.113883.2.20.5.1</xsl:when>
				<xsl:when test="$obrCodeSystemName = 'LOINC'">
					<xsl:value-of select="$loincRootOid"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$ihaRootOid"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="labSpecCode">
			<xsl:choose>
				<xsl:when test="$obrCode = '24336-0'">18719-5</xsl:when>
				<!-- If we don't know the specialty code, just set it to "Laboratory Studies" -->
				<xsl:otherwise>26436-6</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- This list comes from the BC CDA Implementation Guide, section 5.1.2.2 -->
		<xsl:variable name="labSpecName">
			<xsl:choose>
				<xsl:when test="$labSpecCode = '18717-9'">Blood Bank Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18718-7'">Cell Marker Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18719-5'">Chemistry Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18720-3'">Coagulation Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18721-1'">Therapeutic Drug Monitoring Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18722-9'">Fertility Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18723-7'">Hematology Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18724-5'">HLA Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18725-2'">Microbiology Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18727-8'">Serology Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18728-6'">Toxicology Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18729-4'">Urinalysis Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18767-4'">Blood Gas Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18768-2'">Cell Counts + Differential Studies</xsl:when>
				<xsl:when test="$labSpecCode = '18769-0'">Microbial Susceptibility Tests</xsl:when>
				<xsl:when test="$labSpecCode = '26435-8'">Molecular Pathology Studies</xsl:when>
				<xsl:when test="$labSpecCode = '26436-6'">Laboratory Studies</xsl:when>
				<xsl:when test="$labSpecCode = '26437-4'">Chemistry Challenge Studies</xsl:when>
				<xsl:when test="$labSpecCode = '26438-2'">Cytology Studies</xsl:when>
			</xsl:choose>
		</xsl:variable>

       <!-- Report Item Code: If there are multiple OBR segments, use the specialty code, otherwise use the OBR code -->
		<xsl:variable name="rptItemCode">
			<xsl:choose>
				<xsl:when test="count(//OBR) &gt; 1">
					<xsl:value-of select="$labSpecCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$obrCode"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rptItemCodeName">
			<xsl:choose>
				<xsl:when test="count(//OBR) &gt; 1">
					<xsl:value-of select="$labSpecName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$obrCodeName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rptItemCodeSystem">
			<xsl:choose>
				<xsl:when test="count(//OBR) &gt; 1">
					<xsl:value-of select="$loincRootOid"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$obrCodeSystemOID"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rptItemCodeSystemName">
			<xsl:choose>
				<xsl:when test="count(//OBR) &gt; 1">
					<xsl:value-of select="$loincRootOidDisp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$obrCodeSystemName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
       <!-- Structured body components -->
		<xsl:element name="component">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="structuredBody">
				<xsl:attribute name="classCode">DOCBODY</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:element name="component">
					<xsl:attribute name="typeCode">COMP</xsl:attribute>
					
					<!-- Lab Specialty Section -->
					<xsl:element name="section">
						<xsl:attribute name="classCode">DOCSECT</xsl:attribute>
						<xsl:attribute name="moodCode">EVN</xsl:attribute>
						<xsl:call-template name="formatTemplateId">
							<xsl:with-param name="templateOID">1.3.6.1.4.1.19376.1.3.3.2.1</xsl:with-param>
							<xsl:with-param name="templateDesc">Laboratory Specialty Section</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="formatCode">
							<xsl:with-param name="codeSystem" select="$loincRootOid"/>
							<xsl:with-param name="codeSystemName" select="$loincRootOidDisp"/>
							<xsl:with-param name="codeValue" select="$labSpecCode"/>
							<xsl:with-param name="dispName" select="$labSpecName"/>
						</xsl:call-template>
						<xsl:element name="title">
							<xsl:value-of select="$labSpecName"/>
						</xsl:element>

						<!-- Lab Report Item Component/Section -->
						<xsl:element name="component">
							<xsl:attribute name="typeCode">COMP</xsl:attribute>
							<xsl:element name="section">
								<xsl:attribute name="classCode">DOCSECT</xsl:attribute>
								<xsl:attribute name="moodCode">EVN</xsl:attribute>
								<xsl:call-template name="formatTemplateId">
									<xsl:with-param name="templateOID">1.3.6.1.4.1.19376.1.3.3.2.2</xsl:with-param>
									<xsl:with-param name="templateDesc">Laboratory Report Item Section</xsl:with-param>
								</xsl:call-template>
								
								
								<xsl:call-template name="formatCode">
									<xsl:with-param name="codeSystem" select="$rptItemCodeSystem"/>
									<xsl:with-param name="codeSystemName">
										<xsl:value-of select="$rptItemCodeSystemName"/>
									</xsl:with-param>
									<xsl:with-param name="codeValue">
										<xsl:value-of select="$rptItemCode"/>
									</xsl:with-param>
									<xsl:with-param name="dispName">
										<xsl:value-of select="$rptItemCodeName"/>
									</xsl:with-param>
								</xsl:call-template>
								
								<xsl:comment>
									<xsl:text> ==== Derived Text Representation of Discrete Lab Results ==== </xsl:text>
								</xsl:comment>
								<xsl:element name="title">
									<xsl:value-of select="$rptItemCodeName"/>
								</xsl:element>
								<!-- Text from OBR/OBX sets -->
								<xsl:element name="text">
								
									<xsl:call-template name="labSpecText" />

									<xsl:apply-templates select="//OBR" mode="LabOBRtext"/>
<!--									
									<xsl:choose>
										<xsl:when test="count(//OBR) &gt; 1">
											<xsl:for-each select="//OBR">
												<xsl:apply-templates select="." mode="LabOBRtext"/>
  									            <xsl:element name="br" />
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates select="//OBR" mode="LabOBRtext"/>
										</xsl:otherwise>
									</xsl:choose>
-->
									
									<!-- PLIS-style Lab Footer -->
									
									<xsl:element name="br" />
									<xsl:element name="table">
										<xsl:element name="tbody">
											<xsl:element name="tr">
												<xsl:element name="th">Result Flags Legend:</xsl:element>
												<xsl:element name="td">

													<xsl:element name="content">
														<xsl:attribute name="styleCode">alert</xsl:attribute>
														<xsl:text>H</xsl:text>
													</xsl:element>
													<xsl:text>/</xsl:text>
													<xsl:element name="content">
														<xsl:attribute name="styleCode">alert</xsl:attribute>
														<xsl:text>L</xsl:text>
													</xsl:element>
													<xsl:text>/</xsl:text>
													<xsl:element name="content">
														<xsl:attribute name="styleCode">alert</xsl:attribute>
														<xsl:text>A</xsl:text>
													</xsl:element>
													<xsl:element name="br" />
													
													<xsl:element name="content">
														<xsl:attribute name="styleCode">alert</xsl:attribute>
														<xsl:text>HH</xsl:text>
													</xsl:element>
													<xsl:text>/</xsl:text>
													<xsl:element name="content">
														<xsl:attribute name="styleCode">alert</xsl:attribute>
														<xsl:text>LL</xsl:text>
													</xsl:element>
													<xsl:text>/</xsl:text>
													<xsl:element name="content">
														<xsl:attribute name="styleCode">alert</xsl:attribute>
														<xsl:text>AA</xsl:text>
													</xsl:element>

												</xsl:element>
												<xsl:element name="td">
													<xsl:text>Abnormal Value</xsl:text><xsl:element name="br" />
													<xsl:text>Critical Value</xsl:text>
												</xsl:element>
											</xsl:element>
											<xsl:element name="tr">
												<xsl:element name="th">Performing Lab:</xsl:element>
												<xsl:element name="td">
													<xsl:attribute name="colspan">2</xsl:attribute>
													<xsl:value-of select="//OBX[1]/OBX.15/*[substring(name(),(string-length(name())-1))='.2']" />
													<xsl:text> (</xsl:text>
													<xsl:value-of select="//OBX[1]/OBX.15/*[substring(name(),(string-length(name())-1))='.1']" />
													<xsl:text>)</xsl:text>
												</xsl:element>
											</xsl:element>
											<xsl:element name="tr">
												<xsl:element name="th"><xsl:text>Report Status:</xsl:text></xsl:element>
												<xsl:element name="td">
													<xsl:attribute name="colspan">2</xsl:attribute>
													<xsl:call-template name="formatLabStatus">
														<xsl:with-param name="resultStatus" select="//OBR[1]/OBR.25"/>
													</xsl:call-template>
												</xsl:element>
											</xsl:element>
										</xsl:element>
									</xsl:element>
									
								</xsl:element>
								
								<!-- Entries from OBR/OBX sets -->
								<xsl:comment>
									<xsl:text> ==== Machine Readable HL7 V3 Representation of Discrete Lab Results ==== </xsl:text>
								</xsl:comment>
								<xsl:element name="entry">
									<xsl:attribute name="typeCode">DRIV</xsl:attribute>
									<xsl:call-template name="formatTemplateId">
										<xsl:with-param name="templateOID">1.3.6.1.4.1.19376.1.3.1</xsl:with-param>
										<xsl:with-param name="templateDesc">Laboratory Report Data Processing Entry</xsl:with-param>
									</xsl:call-template>
									<!-- Specimen Act -->
									<xsl:element name="act">
										<xsl:attribute name="classCode">ACT</xsl:attribute>
										<xsl:attribute name="moodCode">EVN</xsl:attribute>
			<!--										
			<xsl:call-template name="formatCode">
				<xsl:with-param name="codeSystem">2.16.840.1.113883.6.1</xsl:with-param>
				<xsl:with-param name="codeSystemName">LOINC</xsl:with-param>
				<xsl:with-param name="codeValue" select="$labSpecCode"/>
				<xsl:with-param name="dispName" select="$labSpecName"/>
			</xsl:call-template>
			-->
			<!--
										<xsl:call-template name="formatCode">
											<xsl:with-param name="codeSystem" select="$rptItemCodeSystem"/>
											<xsl:with-param name="codeValue" select="$rptItemCode"/>
											<xsl:with-param name="dispName" select="$rptItemCodeName"/>
											<xsl:with-param name="codeSystemName" select="$rptItemCodeSystemName"/>
										</xsl:call-template>
			-->							
										<xsl:element name="code" >
											<xsl:attribute name="nullFlavor">NA</xsl:attribute>
										</xsl:element>
										
										<xsl:element name="statusCode">
											<xsl:attribute name="code">
												<xsl:call-template name="formatLabStatus">
													<xsl:with-param name="resultStatus" select="./OBR.25"/>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:element>
										
										<!-- Specimen Collection -->
										<xsl:comment>
											<xsl:text>Specimen Collection: </xsl:text>
											<xsl:value-of select="//OBR[1]/OBR.3/*"/>
										</xsl:comment>
										<xsl:element name="entryRelationship">
											<xsl:attribute name="typeCode">COMP</xsl:attribute>
											<xsl:element name="procedure">
												<xsl:attribute name="classCode">PROC</xsl:attribute>
												<xsl:attribute name="moodCode">EVN</xsl:attribute>
												<xsl:call-template name="formatTemplateId">
													<xsl:with-param name="templateOID">1.3.6.1.4.1.19376.1.3.1.2</xsl:with-param>
													<xsl:with-param name="templateDesc">Specimen Collection</xsl:with-param>
												</xsl:call-template>
												<xsl:call-template name="formatCode">
													<xsl:with-param name="codeSystem">2.16.840.1.113883.6.1</xsl:with-param>
													<xsl:with-param name="codeValue">33882-2</xsl:with-param>
													<xsl:with-param name="dispName">Specimen Collection</xsl:with-param>
													<xsl:with-param name="codeSystemName">
														<xsl:value-of select="$loincRootOidDisp"/>
													</xsl:with-param>
												</xsl:call-template>
												<xsl:if test="//OBR[1]/OBR.22/*" >
													<xsl:element name="effectiveTime">
														<xsl:attribute name="value">
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="//OBR[1]/OBR.22/*"/>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:element>
												</xsl:if>
												<!-- targetSiteCode from OBR.15 -->
												<xsl:if test="//OBR[1]/OBR.15/*/*/text()[normalize-space(.)]">
													<xsl:element name="targetSiteCode">
														<xsl:attribute name="code">
															<xsl:choose>
																<xsl:when test="//OBR[1]/OBR.15/*[substring(name(),(string-length(name())-1))='.1']">
																	<xsl:call-template name="replaceCharsInString">
																		<xsl:with-param name="stringIn" select="//OBR[1]/OBR.15/*[substring(name(),(string-length(name())-1))='.1']"/>
																		<xsl:with-param name="charsIn" select="' '"/>
																		<xsl:with-param name="charsOut" select="'_'"/>
																	</xsl:call-template>
																	<xsl:if test="//OBR[1]/OBR.15/*[substring(name(),(string-length(name())-1))='.4']">
																		<xsl:text>|</xsl:text>
																		<xsl:call-template name="replaceCharsInString">
																			<xsl:with-param name="stringIn" select="//OBR[1]/OBR.15/*[substring(name(),(string-length(name())-1))='.4']"/>
																			<xsl:with-param name="charsIn" select="' '"/>
																			<xsl:with-param name="charsOut" select="'_'"/>
																		</xsl:call-template>
																	</xsl:if>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:call-template name="replaceCharsInString">
																		<xsl:with-param name="stringIn" select="//OBR[1]/OBR.15/*"/>
																		<xsl:with-param name="charsIn" select="' '"/>
																		<xsl:with-param name="charsOut" select="'_'"/>
																	</xsl:call-template>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
													</xsl:element>
												</xsl:if>
												<!-- Future: performer/assignedEntity/id from OBR.10 -->
												<!-- Specimen ID from OBR.3 -->
												<xsl:element name="participant">
													<xsl:attribute name="typeCode">PRD</xsl:attribute>
													<xsl:element name="participantRole">
														<xsl:attribute name="classCode">SPEC</xsl:attribute>
														<xsl:call-template name="formatId">
															<xsl:with-param name="root">
																<xsl:value-of select="$specRootOid"/>
															</xsl:with-param>
															<xsl:with-param name="id">
																<xsl:value-of select="//OBR[1]/OBR.3/*"/>
															</xsl:with-param>
															<xsl:with-param name="idDesc">
																<xsl:value-of select="$specRootOidDisp"/>
															</xsl:with-param>
														</xsl:call-template>
														<xsl:element name="playingEntity">
															<xsl:element name="code">
																<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
															</xsl:element>
														</xsl:element>
													</xsl:element>
													
													<!-- Specimen Received dateTime from OBR.14 -->
													<xsl:if  test="/OBR[1]/OBR.14">
														<xsl:comment><xsl:text>Specimen Recieved DateTime</xsl:text></xsl:comment>
														<xsl:element name="entryRelationship">
															<xsl:attribute name="typeCode">COMP</xsl:attribute>
															<xsl:element name="act">
																<xsl:attribute name="classCode">ACT</xsl:attribute>
																<xsl:attribute name="moodCode">EVN</xsl:attribute>
																<xsl:element name="templateId">
																	<xsl:attribute name="root">1.3.6.1.4.1.19376.1.3.1.3</xsl:attribute>
																</xsl:element>
																<xsl:element name="code">
																	<xsl:attribute name="code">SPRECEIVE</xsl:attribute>
																	<xsl:attribute name="codeSystem">1.3.5.1.4.1.19376.1.5.3.2</xsl:attribute>
																	<xsl:attribute name="codeSystemName">IHEActCode</xsl:attribute>
																</xsl:element>
																<xsl:element name="effectiveTime">
																	<xsl:attribute name="value">
																		<xsl:call-template name="formatDate">
																			<xsl:with-param name="date" select="//OBR[1]/OBR.14/*"/>
																		</xsl:call-template>
																	</xsl:attribute>
																</xsl:element>
															</xsl:element>
														</xsl:element>
													</xsl:if>
													
												</xsl:element>
											</xsl:element>
										</xsl:element>
										
										<xsl:apply-templates select="//OBR" mode="LabOBRentry"/>
<!--							
										<xsl:choose>
											<xsl:when test="count(//OBR) &gt; 1">
												<xsl:for-each select="//OBR">
													<xsl:apply-templates select="." mode="LabOBRentry"/>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="//OBR" mode="LabOBRentry"/>
											</xsl:otherwise>
										</xsl:choose>
-->
									</xsl:element>
								</xsl:element>
							</xsl:element>

						<!-- Lab Report Item Component/Section -->
						</xsl:element>

					<!-- Lab Specialty Section -->
					</xsl:element>

       <!-- Structured body components -->
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	
	<!-- =========Lab Panel / Battery Section (OBR segment) TEXT ======== -->
	<xsl:template match="OBR" mode="LabOBRtext">

        <!-- This works great until one of the OBRs has no OBXs, then it is off -->
		<xsl:variable name="obrSet" select="./OBR.1"/>
		
		<xsl:variable name="test1" select="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']"/>
		<xsl:variable name="obrCode">
			<xsl:choose>
				<xsl:when test="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:value-of select="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBR.4/*[substring(name(),(string-length(name())-1))='.1']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeName">
			<xsl:choose>
				<xsl:when test="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBR.4/*[substring(name(),(string-length(name())-1))='.5']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBR.4/*[substring(name(),(string-length(name())-1))='.2']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>				
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeSystemName">
			<xsl:choose>
				<xsl:when test="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:value-of select="./OBR.4/*[substring(name(),(string-length(name())-1))='.6']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Local IHA LIS Code</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeSystemOID">
			<xsl:choose>
				<xsl:when test="$obrCodeSystemName = 'pCLOCD'">2.16.840.1.113883.2.20.5.1</xsl:when>
				<xsl:when test="$obrCodeSystemName = 'LOINC'">
					<xsl:value-of select="$loincRootOidDisp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$ihaRootOid"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeSystemText">
			<xsl:choose>
				<xsl:when test="($obrCodeSystemName = 'pCLOCD') or ($obrCodeSystemName = 'LOINC')">
					<xsl:value-of select="$obrCodeSystemName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Local</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
						
		<xsl:element name="table">
			<xsl:element name="caption">
				<xsl:value-of select="$obrCode"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$obrCodeName"/>
			</xsl:element>
			
			<xsl:element name="tbody">

				<!-- NTE1 segments only; NTE2 segments should be in-line with the associated observations -->
				<xsl:if test="following-sibling::node()[1]/NTE.1">		
					<xsl:element name="tr">
						<xsl:element name="th">Comments</xsl:element>
						<xsl:element name="td">
							<xsl:attribute name="colspan">7</xsl:attribute>
							<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationTextGeneral"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="tr">
						<xsl:element name="td">
							<xsl:attribute name="colspan">8</xsl:attribute>
						</xsl:element>
					</xsl:element>					
				</xsl:if>

          <xsl:variable name="hasOBX">
				<xsl:choose>
					<xsl:when test="following-sibling::node()[1]/NTE.1">
						<xsl:apply-templates select="following-sibling::node()[1]" mode="obxHunterBool" />
					</xsl:when>
					<xsl:when test="following-sibling::node()[1]/OBX.1 or following-sibling::node()[1]/*/*[name()='OBX.1']">
						<xsl:text>true</xsl:text>
					</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
		  </xsl:variable>

		  <xsl:choose>
			<xsl:when test="$hasOBX='true'">
				<xsl:element name="tr">
					<xsl:element name="th">
						<xsl:text>Test ID:</xsl:text>
					</xsl:element>
					<xsl:element name="th">
						<xsl:text>Test Name:</xsl:text>
					</xsl:element>
					<xsl:element name="th">
						<xsl:text>Test Result:</xsl:text>
					</xsl:element>
					<xsl:element name="th">
						<xsl:text>Result Flags:</xsl:text>
					</xsl:element>
					<xsl:element name="th">
						<xsl:text>Reference Range:</xsl:text>
					</xsl:element>
					<xsl:element name="th">
						<xsl:text>Result Units:</xsl:text>
					</xsl:element>
					<xsl:element name="th">
						<xsl:text>Time Resulted:</xsl:text>
					</xsl:element>
					<xsl:element name="th">
						<xsl:text>Status:</xsl:text>
					</xsl:element>
					<!--
                <xsl:element name="th">
                  <xsl:text>Performed At:</xsl:text>
                </xsl:element>
				-->
				</xsl:element>
				
			<!-- /xsl:element -->
	          
				<xsl:choose>
					<xsl:when test="$docCode = '18725-2'">
					    <xsl:apply-templates select="." mode="obxHunterMicro" />
				    </xsl:when>
					<xsl:otherwise>
					    <xsl:apply-templates select="." mode="obxHunter" />
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			
			<!-- If there are no OBX segments, we need at least one row -->
			<xsl:otherwise>
				<xsl:element name="tr">
					<xsl:element name="td">
					<xsl:text>(no associated result values)</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		  </xsl:choose>
          
		   </xsl:element>
		            
		</xsl:element>
		<xsl:element name="br" />
	</xsl:template>	
	
	<!-- =========Lab Panel / Battery Section (OBR segment) ENTRY ======== -->
	<xsl:template match="OBR" mode="LabOBRentry">
		<xsl:variable name="obrSet" select="./OBR.1"/>
		<xsl:variable name="test1" select="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']"/>
		<xsl:variable name="obrCode">
			<xsl:choose>
				<xsl:when test="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:value-of select="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBR.4/*[substring(name(),(string-length(name())-1))='.1']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeName">
			<xsl:choose>
				<xsl:when test="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBR.4/*[substring(name(),(string-length(name())-1))='.5']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBR.4/*[substring(name(),(string-length(name())-1))='.2']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>	
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeSystemName">
			<xsl:choose>
				<xsl:when test="./OBR.4/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:value-of select="./OBR.4/*[substring(name(),(string-length(name())-1))='.6']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Local IHA LIS Code</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeSystemOID">
			<xsl:choose>
				<xsl:when test="$obrCodeSystemName = 'pCLOCD'">2.16.840.1.113883.2.20.5.1</xsl:when>
				<xsl:when test="$obrCodeSystemName = 'LOINC'">
					<xsl:value-of select="$loincRootOidDisp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$ihaRootOid"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="obrCodeSystemText">
			<xsl:choose>
				<xsl:when test="($obrCodeSystemName = 'pCLOCD') or ($obrCodeSystemName = 'LOINC')">
					<xsl:value-of select="$obrCodeSystemName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Local</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Put all of the tests into a battery organizer -->
		<xsl:comment>
			<xsl:text> Battery: </xsl:text>
			<xsl:value-of select="$obrCodeName"/>
			<xsl:text> </xsl:text>
		</xsl:comment>		

		<xsl:element name="entryRelationship">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="organizer">
				<xsl:attribute name="classCode">BATTERY</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:call-template name="formatTemplateId">
					<xsl:with-param name="templateOID">1.3.6.1.4.1.19376.1.3.1.4</xsl:with-param>
					<xsl:with-param name="templateDesc">Laboratory Battery Organizer</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="./OBR.3/*">
					<xsl:call-template name="formatId">
						<xsl:with-param name="root">
							<xsl:value-of select="$specRootOid"/>
						</xsl:with-param>
						<xsl:with-param name="id">
							<xsl:value-of select="./OBR.3/*"/>
						</xsl:with-param>
						<xsl:with-param name="idDesc">
							<xsl:value-of select="$specRootOidDisp"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$obrCode != '' ">
					<xsl:call-template name="formatCode">
						<xsl:with-param name="codeSystem" select="$obrCodeSystemOID"/>
						<xsl:with-param name="codeValue" select="$obrCode"/>
						<xsl:with-param name="dispName" select="$obrCodeName"/>
						<xsl:with-param name="codeSystemName" select="$obrCodeSystemName"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:element name="statusCode">
					<xsl:attribute name="code">
					   <xsl:call-template name="formatLabStatus">
					      <xsl:with-param name="resultStatus" select="./OBR.25"/>
					   </xsl:call-template>
					</xsl:attribute>
				</xsl:element>
  			    <xsl:if test="./OBR.22/*">
				    <xsl:element name="effectiveTime">
					  <xsl:attribute name="value">
					   <xsl:call-template name="formatDate">
					       <xsl:with-param name="date" select="./OBR.22/*"/>
					    </xsl:call-template>
					  </xsl:attribute>
				    </xsl:element>
                </xsl:if>

				<!-- If there are general notes attached to this OBR, include them here. -->
				<xsl:if test="following-sibling::node()[1]/NTE.1">
					<xsl:comment>Associated Battery Observation Annotation</xsl:comment>
					<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationEntries">
						<xsl:with-param name="entryType">component</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>		

<!-- (Need to account for OBR segments with NO OBX segments ) -->
			<xsl:variable name="hasOBX">
				<xsl:choose>
					<xsl:when test="following-sibling::node()[1]/NTE.1">
						<xsl:apply-templates select="following-sibling::node()[1]" mode="obxHunterBool" />
					</xsl:when>
					<xsl:when test="following-sibling::node()[1]/OBX.1 or following-sibling::node()[1]/*/*[name()='OBX.1']">
						<xsl:text>true</xsl:text>
					</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$hasOBX='true'">
		  
			    <xsl:apply-templates select="." mode="obxHunterEntries" />
					    
			</xsl:if>
				
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- =========Text Table for Lab Specimen (First OBR segment) ======== -->
	<xsl:template name="labSpecText">

		<!-- First the specimen information -->
		<xsl:element name="table">
			<xsl:element name="caption">Specimen Information</xsl:element>
			<xsl:element name="tbody">
				<xsl:element name="tr">
					<xsl:element name="th">Lab #</xsl:element>
					<xsl:element name="td">
						<xsl:value-of select="//OBR[1]/OBR.3/*"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="tr">
					<xsl:element name="th">Collected:</xsl:element>
					<xsl:element name="td">
						<xsl:call-template name="formatTextDate">
							<xsl:with-param name="date" select="//OBR[1]/OBR.7/*"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
				<xsl:element name="tr">
					<xsl:element name="th">Received:</xsl:element>
					<xsl:element name="td">
						<!-- Not sure if OBR.14 is the Meditech HL7 v2 field for received date -->
						<xsl:call-template name="formatTextDate">
							<xsl:with-param name="date" select="//OBR[1]/OBR.14/*"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
				<!-- NTE1 segments only; NTE2 segments should be in-line with the associated observations -->
				<xsl:if test="following-sibling::node()[1]/NTE.1">
					<xsl:element name="tr">
						<xsl:element name="th">Comments</xsl:element>
						<xsl:element name="td">
							<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationTextGeneral"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>
		<xsl:element name="br" />
	</xsl:template>
	
	<!-- =========Text for Lab Annotations (NTE1,NTE2 segments) ======== -->
	<xsl:template match="*" mode="labAnnotationText">
		<xsl:param name="multiNteSet" select="'N'"/>
		<!-- This is the BizTalk way to determine if this is a specimen note or an observation note. 
               If you aren't using Biztalk you'll have to find another way. -->
		<xsl:if test="(contains(name(),'NTE2')) and ($multiNteSet='N')">
			<xsl:element name="content">
				<xsl:attribute name="styleCode">Bold</xsl:attribute>
				<xsl:text>Observation Notes:</xsl:text>
			</xsl:element>
			<xsl:element name="br"/>
		</xsl:if>
		<xsl:value-of select="./NTE.3"/>
		<xsl:element name="br"/>
	</xsl:template>
	
	<!-- =========Text for General Lab Annotations (NTE1 segments) ======== -->
	<xsl:template match="*" mode="labAnnotationTextGeneral">
		<xsl:param name="multiNteSet" select="'N'"/>
		<xsl:apply-templates select="." mode="labAnnotationText">
			<xsl:with-param name="multiNteSet" select="$multiNteSet"/>
		</xsl:apply-templates>
		<!-- Do the next NTE segment in this set, recursively -->
		<xsl:if test="following-sibling::node()[1]/NTE.1">
			<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationTextGeneral">
				<xsl:with-param name="multiNteSet" select="'Y'"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!-- =========Text for In-Line Lab Annotations (NTE2 segments) ======== -->
	<xsl:template match="*" mode="labAnnotationTextInline">
		<xsl:param name="multiNteSet" select="'N'"/>
		<!-- This seems like a clumsy way to do it; including the recursive portion for both cases. I'm open to suggestions. -->
		<xsl:choose>
			<xsl:when test="$multiNteSet = 'N'">
				<xsl:element name="tr">
					<xsl:element name="td">
						<xsl:attribute name="colspan">2</xsl:attribute>
						<xsl:text> </xsl:text>
					</xsl:element>
					<xsl:element name="td">
						<xsl:attribute name="colspan">9</xsl:attribute>
						<xsl:apply-templates select="." mode="labAnnotationText">
							<xsl:with-param name="multiNteSet" select="$multiNteSet"/>
						</xsl:apply-templates>
						<!-- Do the next NTE segment in this set, recursively -->
						<xsl:if test="following-sibling::node()[1]/NTE.1">
							<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationTextInline">
								<xsl:with-param name="multiNteSet">Y</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:element>
				</xsl:element>
				
				<!-- Do the next OBX segment in this set, recursively -->
				<xsl:choose>
					<xsl:when test="following-sibling::node()[1]/NTE.1">
						<xsl:apply-templates select="following-sibling::node()[1]" mode="obxHunter" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="obxHunter" />
					</xsl:otherwise>
				</xsl:choose>
			
				<!--
				<xsl:choose>
					<xsl:when test="following-sibling::node()[1]/OBX.1">
						<xsl:apply-templates select="following-sibling::node()[1]" mode="labTestsText"/>
					</xsl:when>
					<xsl:when test="../following-sibling::node()[1]/OBX.1">
						<xsl:apply-templates select="../following-sibling::node()[1]" mode="labTestsText"/>
					</xsl:when>
				</xsl:choose>
				-->
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="labAnnotationText">
					<xsl:with-param name="multiNteSet" select="$multiNteSet"/>
				</xsl:apply-templates>
				<!-- Do the next NTE segment in this set, recursively -->
				<xsl:if test="following-sibling::node()[1]/NTE.1">
					<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationTextInline">
						<xsl:with-param name="multiNteSet">Y</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<!-- We can't simply go on to the next OBX segment, because we could be down many levels of recursion. -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- Skip over Notes segments to find Observation segments; abort if no Observation segments -->
	
<xsl:template match="*" mode="obxHunter" >

	<xsl:choose>
		<xsl:when test="following-sibling::node()[1]/NTE.1">
			<xsl:apply-templates select="following-sibling::node()[1]" mode="obxHunter" />
		</xsl:when>
		<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='NTE.1']">
			<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="obxHunter" />
		</xsl:when>		
		<!-- Biztalk version: If there are no OBX segments, ABORT -->
		<xsl:when test="(following-sibling::node()[1]/ORC.1)">
			<xsl:text /> 
		</xsl:when>	
		<xsl:when test="following-sibling::node()[1]/OBX.1">
			<xsl:apply-templates select="following-sibling::node()[1]" mode="labTestsText"/>
		</xsl:when>		
		<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
			<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="labTestsText"/>
		</xsl:when>	
		<xsl:when test="following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
			<xsl:apply-templates select="following-sibling::node()[1]/*[1]" mode="labTestsText"/>
		</xsl:when>	
		<!-- HAPI (HL7 Parser) version: If there are no OBX segments, ABORT -->
		<xsl:when test="(../following-sibling::node()[1]/*[1]/*[name()='ORC.1'])">
			<xsl:text /> 
		</xsl:when>			
	</xsl:choose>
	
</xsl:template>

<!-- Skip over Notes segments to find Observation segments; return false if no Observation segments -->

<xsl:template match="*" mode="obxHunterBool" >
	<xsl:choose>
		<xsl:when test="following-sibling::node()[1]/NTE.1">
			<xsl:apply-templates select="following-sibling::node()[1]" mode="obxHunterBool" />
		</xsl:when>
		<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='NTE.1']">
			<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="obxHunterBool" />
		</xsl:when>			
		<!-- BIZTALK version: If there are no OBX segments, ABORT -->
		<xsl:when test="(following-sibling::node()[1]/ORC.1)">false</xsl:when>	
		<xsl:when test="(following-sibling::node()[1]/OBX.1) or (../following-sibling::node()[1]/*[1]/*[name()='OBX.1']) or (following-sibling::node()[1]/*[1]/*[name()='OBX.1'])">
			<xsl:text >true</xsl:text> 
		</xsl:when>
		<!-- HAPI (HL7 Parser) version: If there are no OBX segments, ABORT -->
		<xsl:when test="(../../following-sibling::node()[1]/*[1]/*[name()='ORC.1'])">false</xsl:when>
		<xsl:otherwise>false</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Skip over Notes segments to find Observation segments; abort if no Observation segments -->
	
<xsl:template match="*" mode="obxHunterEntries" >
	<xsl:choose>
		<xsl:when test="following-sibling::node()[1]/NTE.1">
			<xsl:apply-templates select="following-sibling::node()[1]" mode="obxHunterEntries" />
		</xsl:when>
		<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='NTE.1']">
			<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="obxHunterEntries" />
		</xsl:when>			
		<!-- If there are no OBX segments, ABORT -->
		<xsl:when test="(following-sibling::node()[1]/ORC.1)">
			<xsl:text /> 
		</xsl:when>	
		<xsl:when test="following-sibling::node()[1]/OBX.1">
			<xsl:apply-templates select="following-sibling::node()[1]" mode="labTestsEntries"/>
		</xsl:when>		
		<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
			<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="labTestsEntries"/>
		</xsl:when>	
		<xsl:when test="following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
			<xsl:apply-templates select="following-sibling::node()[1]/*[1]" mode="labTestsEntries"/>
		</xsl:when>	
		<!-- HAPI version: If there are no OBX segments, ABORT -->
		<xsl:when test="(../following-sibling::node()[1]/*[1]/*[name()='ORC.1'])">
			<xsl:text /> 
		</xsl:when>			
	</xsl:choose>
</xsl:template>
	
<!-- ========= FIRST DRAFT: Text for Discrete Microbiology Tests ======== -->
<!-- This section has fallen out of date due to lack of test cases, and it has only been tested 
      against Meditech TEST messages (Discrete Micro has not been moved to LIVE) -->

	<xsl:template match="*" mode="obxHunterMicro" >
		<xsl:choose>
			<xsl:when test="following-sibling::node()[1]/NTE.1">
				<xsl:apply-templates select="following-sibling::node()[1]" mode="obxHunterMicro" />
			</xsl:when>
			<!-- If there are no OBX segments, ABORT -->
			<xsl:when test="following-sibling::node()[1]/ORC.1">
				<xsl:text /> 
			</xsl:when>	
			<xsl:when test="following-sibling::node()[1]/OBX.1">
				<xsl:apply-templates select="following-sibling::node()[1]" mode="microTestsText"/>
			</xsl:when>		
			<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
				<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="microTestsText"/>
			</xsl:when>	
			<xsl:when test="following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
				<xsl:apply-templates select="following-sibling::node()[1]/*[1]" mode="microTestsText"/>
			</xsl:when>	
    	</xsl:choose>
	</xsl:template>

    <xsl:template match="*" mode="microTestsText">
    
				<xsl:variable name="obxSubId">
					<xsl:choose>
						<xsl:when test="./OBX.4"><xsl:value-of select="./OBX.4"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
	
			<xsl:variable name="obxId">
				<xsl:choose>
					<xsl:when test="$ihaMTlab"><xsl:value-of select="./OBX.1/*[substring(name(),(string-length(name())-1))='.1']" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="./OBX.1" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 

			<xsl:variable name="obxSet">
				<xsl:choose>
					<xsl:when test="$obxId = 1 and $obxSubId > 1"><xsl:value-of select="$obxSubId" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$obxId" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>    
    
		<!-- If we have a LOINC/pCLOCD code (OBX.3.4) use it, otherwise fall back to the local code (OBX.3.1) -->
		<xsl:variable name="testCode">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.1']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="testName">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBX.3/*[substring(name(),(string-length(name())-1))='.5']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.2']"/>
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBX.3/*[substring(name(),(string-length(name())-1))='.2']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>		
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="tr">
			<xsl:variable name="obrSet" select="preceding-sibling::node()[./OBR.1][1]/OBR.1|../preceding-sibling::node()[./OBR.1][1]/OBR.1" />
			<xsl:attribute name="ID">
				<xsl:text>p</xsl:text><xsl:value-of select="$testCode"/>
 			    <!--Test results with the same LOINC need to be 'uniquified', so the OBX and OBR Set IDs are added -->
				<xsl:text>_</xsl:text><xsl:value-of select="$obxSet"/>
				<xsl:text>-</xsl:text><xsl:value-of select="$obrSet"/>
			</xsl:attribute>
			<xsl:element name="td">
				<xsl:value-of select="$testCode"/>
			</xsl:element>
			<xsl:element name="td">
				<xsl:value-of select="$testName"/>
			</xsl:element>

		<xsl:element name="td">
			<xsl:attribute name="colspan">4</xsl:attribute>
			<xsl:apply-templates select="." mode="microTestsOBR5" />
		</xsl:element>
		<xsl:element name="td">
			<xsl:call-template name="formatTextDate">
				<xsl:with-param name="date" select="./OBX.14/*"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="td">
			<xsl:call-template name="formatLabStatus">
				<xsl:with-param name="resultStatus" select="./OBX.11"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:element>

			<!-- Do the next OBX segment in this set, recursively -->
		
			<!-- I suspect that this may need to be tested for compatibility with the $ihaMTlab scenario -->
			<xsl:choose>
				<xsl:when test="(../following-sibling::node()[1]/*[1]/*[name()='OBX.1'] > $obxSet) and not(../following-sibling::node()[1]/*[1]/*[name()='OBX.3']/*[name()='CE.4'] = $testCode)">
					<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="microTestsText"/>
				</xsl:when>
			</xsl:choose>	
			
</xsl:template>
	
	<xsl:template match="*" mode="microTestsOBR5">
	
		<xsl:variable name="testCode">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.1']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	        <xsl:value-of select="./OBX.5" />
	        <xsl:element name="br" />
	        
			<!-- Do the next OBX segment in this set, recursively -->
	
				<xsl:variable name="obxSubId">
					<xsl:choose>
						<xsl:when test="./OBX.4"><xsl:value-of select="./OBX.4"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
	
			<xsl:variable name="obxId">
				<xsl:choose>
					<xsl:when test="$ihaMTlab"><xsl:value-of select="./OBX.1/*[substring(name(),(string-length(name())-1))='.1']" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="./OBX.1" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 

			<xsl:variable name="obxSet">
				<xsl:choose>
					<xsl:when test="$obxId = 1 and $obxSubId > 1"><xsl:value-of select="$obxSubId" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$obxId" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 
						
			<xsl:choose>
				<xsl:when test="$ihaMTlab and (following-sibling::node()[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1'] > $obxSet)">
					<xsl:apply-templates select="following-sibling::node()[1]" mode="microTestsOBR5"/>
				</xsl:when>
				<xsl:when test="(following-sibling::node()[1]/*[name()='OBX.1'] > $obxSet)">
					<xsl:apply-templates select="following-sibling::node()[1]" mode="microTestsOBR5"/>
				</xsl:when>
				<xsl:when test="$ihaMTlab and (../following-sibling::node()[1]/*[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1'] > $obxSet) and (../following-sibling::node()[1]/*[1]/*[name()='OBX.3']/*[name()='CE.4'] = $testCode)">
					<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="microTestsOBR5"/>
				</xsl:when>
				<xsl:when test="(../following-sibling::node()[1]/*[1]/*[name()='OBX.1'] > $obxSet) and (../following-sibling::node()[1]/*[1]/*[name()='OBX.3']/*[name()='CE.4'] = $testCode)">
					<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="microTestsOBR5"/>
				</xsl:when>
			</xsl:choose>	
	</xsl:template>
	
 	<!-- =========Text for Lab Tests / Observations (OBX segments) ======== -->
	<xsl:template match="OBX" mode="labTestsText">
	
			<!-- Populate the obxSet variable -->
	
				<xsl:variable name="obxSubId">
					<xsl:choose>
						<xsl:when test="./OBX.4/text()"><xsl:value-of select="./OBX.4"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
	
			<xsl:variable name="obxId">
				<xsl:choose>
					<xsl:when test="$ihaMTlab"><xsl:value-of select="./OBX.1/*[substring(name(),(string-length(name())-1))='.1']" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="./OBX.1" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 

			<xsl:variable name="obxSet">
				<xsl:choose>
					<xsl:when test="$obxId = 1 and $obxSubId > 1"><xsl:value-of select="$obxSubId" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$obxId" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 	
	
		<!-- If we have a LOINC/pCLOCD code (OBX.3.4) use it, otherwise fall back to the local code (OBX.3.1) -->
		<xsl:variable name="testCode">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.1']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="testName">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBX.3/*[substring(name(),(string-length(name())-1))='.5']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>						
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.2']"/>
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBX.3/*[substring(name(),(string-length(name())-1))='.2']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>							
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Test value: Do the logic here, once, so styling logic can be applied to the result. -->
		<xsl:variable name="obx52" select="(./OBX.5/*[substring(name(),(string-length(name())-1))='.2']/text()[normalize-space(.)])"/>
		<xsl:variable name="testValue">
			<xsl:choose>
				<xsl:when test="$obx52 and (./OBX.5/*[substring(name(),(string-length(name())-1))='.1']/text()[normalize-space(.)])">
					<xsl:value-of select="./OBX.5/*[substring(name(),(string-length(name())-1))='.1']"/>
				</xsl:when>
				<xsl:when test="$obx52">
					<xsl:value-of select="./OBX.5/*[substring(name(),(string-length(name())-1))='.2']"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="./OBX.5"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="resultFlag">
			<xsl:value-of select="./OBX.8[normalize-space(.)]"/>
		</xsl:variable>
		
		<xsl:element name="tr">
            <xsl:variable name="obrSet" select="preceding-sibling::node()[./OBR.1][1]/OBR.1|../preceding-sibling::node()[./OBR.1][1]/OBR.1" />
			<xsl:attribute name="ID">
				<xsl:text>p</xsl:text><xsl:value-of select="$testCode"/>
 			    <!--Test results with the same LOINC need to be 'uniquified', so the OBX and OBR Set IDs are added -->
				<xsl:text>_</xsl:text><xsl:value-of select="$obxSet"/>
				<xsl:text>-</xsl:text><xsl:value-of select="$obrSet"/>
			</xsl:attribute>
			<xsl:element name="td">
				<xsl:value-of select="$testCode"/>
			</xsl:element>
			<xsl:element name="td">
				<xsl:value-of select="$testName"/>
				
				<!-- Bloodbank test results can have multiple tests with the same LOINC name, and the local lab name can help clarify -->
				<xsl:if test="($docCode = '18717-9') and (./OBX.16/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)])">
					<xsl:element name="br"/>
					<xsl:value-of select="./OBX.16/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]"/>
				</xsl:if>
				
			</xsl:element>
			<xsl:element name="td">
			  <xsl:choose>
				<xsl:when test="$resultFlag='H' or $resultFlag='HH' or $resultFlag='L' or $resultFlag='LL' or $resultFlag='A' or $resultFlag='AA'">
				  <xsl:comment>This is an exceptional value and has been marked as such using the 'alert' styleCode.</xsl:comment>
				  <xsl:element name="content">
				    <xsl:attribute name="styleCode">alert</xsl:attribute>
					<xsl:value-of select="$testValue"/>
				  </xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$testValue"/>
				</xsl:otherwise>
			  </xsl:choose>
			</xsl:element>
			<xsl:element name="td">
			  <xsl:choose>
				<xsl:when test="$resultFlag='H' or $resultFlag='HH' or $resultFlag='L' or $resultFlag='LL' or $resultFlag='A' or $resultFlag='AA'">
				  <xsl:element name="content">
				    <xsl:attribute name="styleCode">alert</xsl:attribute>
					<xsl:value-of select="$resultFlag"/>
				  </xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$resultFlag"/>
				</xsl:otherwise>
			  </xsl:choose>
			</xsl:element>
			<xsl:element name="td">
			  <xsl:choose>			
				<xsl:when test="$resultFlag='H' or $resultFlag='HH' or $resultFlag='L' or $resultFlag='LL' or $resultFlag='A' or $resultFlag='AA'">
				  <xsl:element name="content">
				    <xsl:attribute name="styleCode">alert</xsl:attribute>
					<xsl:value-of select="./OBX.7[normalize-space(.)]"/>
				  </xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.7[normalize-space(.)]"/>
				</xsl:otherwise>			
			  </xsl:choose>
			</xsl:element>
			<xsl:element name="td">
				<xsl:value-of select="./OBX.6/*"/>
			</xsl:element>
			<xsl:element name="td">
				<xsl:call-template name="formatTextDate">
					<xsl:with-param name="date" select="./OBX.14/*"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="td">
				<xsl:call-template name="formatLabStatus">
					<xsl:with-param name="resultStatus" select="./OBX.11"/>
				</xsl:call-template>
			</xsl:element>
			<!-- 
      <xsl:element name="td">
        <xsl:value-of select="./OBX.15/*[substring(name(),(string-length(name())-1))='.2']" />
      </xsl:element>
      -->
		</xsl:element>
		<!-- Handle in-line notes -->
		<xsl:if test="following-sibling::node()[1][contains(name(),'NTE')]">
			<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationTextInline"/>		
		</xsl:if>
		
		<!-- Do the next OBX segment in this set, recursively -->
		
			<!-- Populate the nextObxSet variable -->
	
				<xsl:variable name="nextObxSubId">
					<xsl:choose>
						<xsl:when test="following-sibling::node()[1]/OBX.4/text()">
							<xsl:value-of select="following-sibling::node()[1]/OBX.4"/>
						</xsl:when>
						<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='OBX.4']/text()">
							<xsl:value-of select="../following-sibling::node()[1]/*[1]/*[name()='OBX.4']"/>
						</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
	
			<xsl:variable name="nextObxId">
				<xsl:choose>
					<xsl:when test="following-sibling::node()[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']">
						<xsl:value-of select="following-sibling::node()[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']" />
					</xsl:when>
					<xsl:when test="following-sibling::node()[1]/*[name()='OBX.1']">
						<xsl:value-of select="following-sibling::node()[1]/*[name()='OBX.1']"/>
					</xsl:when>
					<xsl:when test="../following-sibling::node()[1]/*[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']">
						<xsl:value-of select="../following-sibling::node()[1]/*[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']"/>
					</xsl:when>
					<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
						<xsl:value-of select="../following-sibling::node()[1]/*[1]/*[name()='OBX.1']"/>
					</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 

			<xsl:variable name="nextObxSet">
				<xsl:choose>
					<xsl:when test="$nextObxId = 1 and $nextObxSubId > 1"><xsl:value-of select="$nextObxSubId" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$nextObxId" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 	
	
		<!-- Finally, decide if we can go on to the next OBX segment or not -->
	
		<xsl:choose>
			<xsl:when test="($nextObxSet > $obxSet) and (../following-sibling::node()[1]/*[1]/*[name()='OBX.1'])" >
				<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="labTestsText"/>
			</xsl:when>
			<xsl:when test="($nextObxSet > $obxSet)" >
				<xsl:apply-templates select="following-sibling::node()[1]" mode="labTestsText"/>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- =========Entries for Lab Annotations (NTE1,NTE2 segments) ======== -->
	<xsl:template match="*" mode="labAnnotationEntries">
		<xsl:param name="entryType">entryRelationship</xsl:param>
		<xsl:element name="{$entryType}">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="act">
				<xsl:attribute name="classCode">ACT</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:call-template name="formatTemplateId">
					<xsl:with-param name="templateOID">1.3.6.1.4.1.19376.1.5.3.1.4.2</xsl:with-param>
					<xsl:with-param name="templateDesc">Annotation Comment</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="formatCode">
					<xsl:with-param name="codeSystem" select="$loincRootOid"/>
					<xsl:with-param name="codeSystemName" select="$loincRootOidDisp"/>
					<xsl:with-param name="codeValue">48767-8</xsl:with-param>
					<xsl:with-param name="dispName">Annotation Comment</xsl:with-param>
				</xsl:call-template>
				<xsl:element name="text">
					<xsl:apply-templates select="." mode="allNoteEntries"/>
				</xsl:element>
				<xsl:element name="statusCode">
					<xsl:attribute name="code"><xsl:call-template name="formatLabStatus"><xsl:with-param name="resultStatus">F</xsl:with-param></xsl:call-template></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="*" mode="allNoteEntries">
		<xsl:value-of select="./NTE.3"/>
		<!-- Do the next NTE segment in this set, recursively -->
		<xsl:if test="following-sibling::node()[1]/NTE.1">
			<xsl:text>
			</xsl:text>
			<xsl:apply-templates select="following-sibling::node()[1]" mode="allNoteEntries"/>
		</xsl:if>
	</xsl:template>
	
	<!-- =========Entries for Lab Tests / Observations (OBX segments) ======== -->
	<xsl:template match="OBX" mode="labTestsEntries">
		<!-- If we have a LOINC/pCLOCD code (OBX.3.4) use it, otherwise fall back to the local code (OBX.3.1) -->
		<xsl:variable name="testCode">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.1']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="testName">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBX.3/*[substring(name(),(string-length(name())-1))='.5']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>							
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.2']"/>
					<xsl:call-template name="replaceCharsInString">
						<xsl:with-param name="stringIn" select="./OBX.3/*[substring(name(),(string-length(name())-1))='.2']"/>
						<xsl:with-param name="charsIn" select="'\T\'"/>
						<xsl:with-param name="charsOut" select="'&amp;'"/>
					</xsl:call-template>							
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="testCodeSystem">
			<xsl:choose>
				<xsl:when test="./OBX.3/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
					<xsl:value-of select="./OBX.3/*[substring(name(),(string-length(name())-1))='.6']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Local IHA Lab Code</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
			<!-- Populate the obxSet variable -->
	
				<xsl:variable name="obxSubId">
					<xsl:choose>
						<xsl:when test="./OBX.4/text()"><xsl:value-of select="./OBX.4"/></xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
	
			<xsl:variable name="obxId">
				<xsl:choose>
					<xsl:when test="$ihaMTlab"><xsl:value-of select="./OBX.1/*[substring(name(),(string-length(name())-1))='.1']" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="./OBX.1" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 

			<xsl:variable name="obxSet">
				<xsl:choose>
					<xsl:when test="$obxId = 1 and $obxSubId > 1"><xsl:value-of select="$obxSubId" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$obxId" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 	
		
		
		<xsl:comment>
			<xsl:value-of select="./OBX.1"/>
			<xsl:text> - </xsl:text>
			<xsl:value-of select="$testName"/>
			
			<!-- Bloodbank test results can have multiple tests with the same ID, and the local lab name can help clarify -->
			<xsl:if test="($docCode = '18717-9') and (./OBX.16/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)])">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="./OBX.16/*[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]"/>
			</xsl:if>
			
		</xsl:comment>
		<xsl:element name="component">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="observation">
				<xsl:attribute name="classCode">OBS</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:call-template name="formatTemplateId">
					<xsl:with-param name="templateOID">1.3.6.1.4.1.19376.1.3.1.6</xsl:with-param>
					<xsl:with-param name="templateDesc">Laboratory Observation</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="$testCode">
				<xsl:call-template name="formatCode">
					<xsl:with-param name="codeSystem">
						<xsl:choose>
							<xsl:when test="$testCodeSystem = 'pCLOCD'">2.16.840.1.113883.2.20.5.1</xsl:when>
							<xsl:when test="$testCodeSystem = 'LOINC'">
								<xsl:value-of select="$loincRootOid"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$ihaRootOid"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="codeValue" select="$testCode"/>
					<xsl:with-param name="dispName" select="$testName"/>
					<xsl:with-param name="codeSystemName" select="$testCodeSystem"/>
				</xsl:call-template>
				</xsl:if>
				<xsl:element name="text">
					<xsl:element name="reference">
						<xsl:variable name="obrSet" select="preceding-sibling::node()[./OBR.1][1]/OBR.1|../preceding-sibling::node()[./OBR.1][1]/OBR.1" />
						<xsl:attribute name="value">
							<xsl:text>#p</xsl:text><xsl:value-of select="$testCode"/>
							<!--Test results with the same LOINC need to be 'uniquified', so the OBX and OBR Set IDs are added -->
							<xsl:text>_</xsl:text><xsl:value-of select="$obxSet"/>
							<xsl:text>-</xsl:text><xsl:value-of select="$obrSet"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<xsl:element name="statusCode">
					<xsl:attribute name="code"><xsl:call-template name="formatLabStatus"><xsl:with-param name="resultStatus" select="./OBX.11/*[normalize-space(.)]"/></xsl:call-template></xsl:attribute>
				</xsl:element>
				<xsl:if test="./OBX.14/*/text()[normalize-space(.)]">
					<xsl:element name="effectiveTime">
						<xsl:attribute name="value">
						  <xsl:call-template name="formatDate">
							 <xsl:with-param name="date" select="./OBX.14/*[normalize-space(.)]"/>
						   </xsl:call-template>
						 </xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:variable name="resultValue">
					<xsl:choose>
						<xsl:when test="./OBX.5/*[substring(name(),(string-length(name())-1))='.2']">
							<xsl:value-of select="./OBX.5/*[substring(name(),(string-length(name())-1))='.1']/text()[normalize-space(.)]"/>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="./OBX.5/text()[normalize-space(.)]"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="value">
					<xsl:choose>
					    <!-- If this is a numeric value then represent it as a value with type PQ -->
						<xsl:when test="(./OBX.2 = 'NM')and($resultValue != 'ND')and(string(number($resultValue)) != 'NaN')">
							<xsl:attribute name="value"><xsl:value-of select="$resultValue"/></xsl:attribute>
						    <xsl:if test="./OBX.6/*[normalize-space(.)]">
							     <xsl:attribute name="unit">
									 <xsl:choose>
											<xsl:when test="contains(./OBX.6/*,' ')">
												<xsl:call-template name="replaceCharsInString">
													<xsl:with-param name="stringIn" select="./OBX.6/*[normalize-space(.)]"/>
													<xsl:with-param name="charsIn" select="' '"/>
													<xsl:with-param name="charsOut" select="'_'"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise><xsl:value-of select="./OBX.6/*[normalize-space(.)]"/></xsl:otherwise>
										</xsl:choose>							     
							     </xsl:attribute>
						    </xsl:if>
						    <xsl:attribute name="xsi:type">PQ</xsl:attribute>
					    </xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="mediaType"><xsl:text>text/plain</xsl:text></xsl:attribute>
							<xsl:attribute name="representation">TXT</xsl:attribute>
							<xsl:attribute name="xsi:type">ST</xsl:attribute>
							<xsl:value-of select="$resultValue"/>
  					        <!-- If there are units recorded, add a space and the units -->
                            <xsl:if test="./OBX.6/*[normalize-space(.)]">
							     <xsl:text> </xsl:text><xsl:value-of select="./OBX.6/*"/>
						    </xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<!-- 
						<interpretationCode codeSystem="2.16.840.1.113883.3.277.1.30" codeSystemName="Observation Interpretation Code (Abnormal Flag)" code="" />
				-->
				<xsl:if test="./OBX.8[normalize-space(.)]">
					<xsl:element name="interpretationCode">
						<xsl:attribute name="codeSystem">2.16.840.1.113883.3.277.1.30</xsl:attribute>
						<xsl:attribute name="codeSystemName">Observation Interpretation Code (Abnormal Flag)</xsl:attribute>
						<xsl:attribute name="code"><xsl:value-of select="./OBX.8"/></xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="./OBX.15/*[normalize-space(.)]">
					<xsl:element name="performer">
						<xsl:attribute name="typeCode">PRF</xsl:attribute>
						<xsl:element name="assignedEntity">
							<xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
							<xsl:element name="id">
								<xsl:attribute name="nullFlavor">NI</xsl:attribute>
							</xsl:element>
							
							<xsl:if test="./OBX.15/*[substring(name(),(string-length(name())-1))='.1']/text()">
							<xsl:element name="representedOrganization">
								<xsl:attribute name="classCode">ORG</xsl:attribute>
								<xsl:attribute name="determinerCode">INSTANCE</xsl:attribute>
								<xsl:call-template name="formatId">
									<xsl:with-param name="root">2.16.840.1.113883.3.277.1.62</xsl:with-param>
									<xsl:with-param name="id">
										<xsl:value-of select="./OBX.15/*[substring(name(),(string-length(name())-1))='.1']"/>
									</xsl:with-param>
									<xsl:with-param name="idDesc">IHA Lab Provider</xsl:with-param>
								</xsl:call-template>
								<xsl:element name="name">
									<xsl:value-of select="./OBX.15/*[substring(name(),(string-length(name())-1))='.2']"/>
								</xsl:element>
							</xsl:element>
							</xsl:if>
							
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- Handle in-line notes -->
				<xsl:if test="following-sibling::node()[1][contains(name(),'NTE')]">
					<xsl:apply-templates select="following-sibling::node()[1]" mode="labAnnotationEntries"/>
				</xsl:if>
				<xsl:if test="./OBX.7[text()]">
					<xsl:element name="referenceRange">
						<xsl:element name="observationRange">
							<xsl:element name="value">
								<xsl:attribute name="mediaType"><xsl:text>text/plain</xsl:text></xsl:attribute>
								<xsl:attribute name="representation"><xsl:text>TXT</xsl:text></xsl:attribute>
								<xsl:attribute name="xsi:type"><xsl:text>ST</xsl:text></xsl:attribute>
								<xsl:value-of select="./OBX.7"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>
		
		<!-- Do the next OBX segment in this set, recursively -->
		
			<!-- Populate the nextObxSet variable -->
	
				<xsl:variable name="nextObxSubId">
					<xsl:choose>
						<xsl:when test="following-sibling::node()[1]/OBX.4/text()">
							<xsl:value-of select="following-sibling::node()[1]/OBX.4"/>
						</xsl:when>
						<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='OBX.4']">
							<xsl:value-of select="../following-sibling::node()[1]/*[1]/*[name()='OBX.4']"/>
						</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
	
			<xsl:variable name="nextObxId">
				<xsl:choose>
					<xsl:when test="following-sibling::node()[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']">
						<xsl:value-of select="following-sibling::node()[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']" />
					</xsl:when>
					<xsl:when test="following-sibling::node()[1]/*[name()='OBX.1']">
						<xsl:value-of select="following-sibling::node()[1]/*[name()='OBX.1']"/>
					</xsl:when>
					<xsl:when test="../following-sibling::node()[1]/*[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']">
						<xsl:value-of select="../following-sibling::node()[1]/*[1]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']"/>
					</xsl:when>
					<xsl:when test="../following-sibling::node()[1]/*[1]/*[name()='OBX.1']">
						<xsl:value-of select="../following-sibling::node()[1]/*[1]/*[name()='OBX.1']"/>
					</xsl:when>
					<xsl:when test="(following-sibling::node()[1]/NTE.1) and (following-sibling::node()[2]/OBX.1/*[substring(name(),(string-length(name())-1))='.1'])">
						<xsl:value-of select="following-sibling::node()[2]/OBX.1/*[substring(name(),(string-length(name())-1))='.1']"/>
					</xsl:when>					
					<xsl:when test="(following-sibling::node()[1]/NTE.1) and (following-sibling::node()[2]/OBX.1)">
						<xsl:value-of select="following-sibling::node()[2]/OBX.1"/>
					</xsl:when>	
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 

			<xsl:variable name="nextObxSet">
				<xsl:choose>
					<xsl:when test="$nextObxId = 1 and $nextObxSubId > 1"><xsl:value-of select="$nextObxSubId" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$nextObxId" /></xsl:otherwise>
				</xsl:choose>
			</xsl:variable> 	
	
		<!-- Finally, decide if we can go on to the next OBX segment or not -->
	
		<xsl:choose>
			<xsl:when test="($nextObxSet > $obxSet) and (../following-sibling::node()[1]/*[1]/*[name()='OBX.1'])" >
				<xsl:apply-templates select="../following-sibling::node()[1]/*[1]" mode="labTestsEntries"/>
			</xsl:when>
			<xsl:when test="(following-sibling::node()[1]/NTE.1) and (following-sibling::node()[2]/OBX.1)">
				<xsl:apply-templates select="following-sibling::node()[2]" mode="labTestsEntries"/>
			</xsl:when>
			<xsl:when test="($nextObxSet > $obxSet)" >
				<xsl:apply-templates select="following-sibling::node()[1]" mode="labTestsEntries"/>
			</xsl:when>
		</xsl:choose>		
		 				
	</xsl:template>
	<!-- ================================== -->
	<!-- ======== LEVEL 2 TEXT REPORTS ======== -->
	<xsl:template name="level2body">
		<xsl:text>
    </xsl:text>
		<xsl:comment>
			<xsl:text> 
********************************************************
CDA Body: Level 2 - Structured Report 
********************************************************
</xsl:text>
		</xsl:comment>
		<xsl:text>
    </xsl:text>
		<xsl:element name="component">
			<xsl:attribute name="typeCode">COMP</xsl:attribute>
			<xsl:element name="structuredBody">
				<xsl:attribute name="classCode">DOCBODY</xsl:attribute>
				<xsl:attribute name="moodCode">EVN</xsl:attribute>
				<xsl:apply-templates select="//OBX[./OBX.3/*[normalize-space(.)] and (./OBX.2 = 'TX' or ./OBX.2 = 'FT')]" mode="level2Report"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Level 2 Text Report Section -->
	<xsl:template match="OBX" mode="level2Report">
		<xsl:variable name="sectionCode" select="OBX.3/*[substring(name(),(string-length(name())-1))='.1']"/>
		<xsl:variable name="sectionName" select="OBX.3/*[substring(name(),(string-length(name())-1))='.2']"/>
		<xsl:variable name="sectionCodeSystem" select="OBX.3/*[substring(name(),(string-length(name())-1))='.3']"/>
		<!-- This is an example of Muenchian grouping.  See http://www.jenitennison.com/xslt/grouping/muenchian.html -->
		<!-- Briefly: Using a key() dictionary of all the OBX segments and their OBX.3.1 LOINC codes,  -->
		<!--             determine if this is the first line of a section. If it is, set up the section elements. -->
		<xsl:if test="count(. | key('loincSection',./OBX.3/*[substring(name(),(string-length(name())-1))='.1'])[1]) = 1">
			<xsl:element name="component">
				<xsl:attribute name="typeCode">COMP</xsl:attribute>
				<xsl:element name="section">
					<xsl:attribute name="classCode">DOCSECT</xsl:attribute>
					<xsl:attribute name="moodCode">EVN</xsl:attribute>
					<xsl:call-template name="formatTemplateId">
						<!-- 	
								So here we have a short list of section templates. 
								The list is short because it only covers the sections included in the sample Discharge Summary
								hand-crafted to demonstrate what a level 2 CDA would look like. At this point it is very unlikely that
								there will ever be non-lab reports that are above a level 1. 
						-->
						<xsl:with-param name="templateOID">
							<xsl:choose>
								<xsl:when test="$sectionCode='46241-6'">2.16.840.1.113883.10.20.22.2.43</xsl:when>
								<xsl:when test="$sectionCode='48765-2'">2.16.840.1.113883.10.20.22.2.6</xsl:when>
								<xsl:when test="$sectionCode='8648-8'">1.3.6.1.4.1.19376.1.5.3.1.3.5</xsl:when>
								<xsl:when test="$sectionCode='11535-2'">2.16.840.1.113883.10.20.22.2.24</xsl:when>
								<xsl:when test="$sectionCode='10183-2'">2.16.840.1.113883.10.20.22.2.11</xsl:when>
								<xsl:when test="$sectionCode='18776-5'">2.16.840.1.113883.10.20.22.2.10</xsl:when>
								<xsl:otherwise>unknown</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="formatCode">
						<xsl:with-param name="codeSystem">
							<xsl:choose>
								<xsl:when test="$sectionCodeSystem = 'pCLOCD'">2.16.840.1.113883.2.20.5.1</xsl:when>
								<xsl:when test="$sectionCodeSystem = 'LOINC'">
									<xsl:value-of select="$loincRootOid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$ihaRootOid"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="codeValue" select="$sectionCode"/>
						<xsl:with-param name="dispName" select="$sectionName"/>
						<xsl:with-param name="codeSystemName" select="$sectionCodeSystem"/>
					</xsl:call-template>
					<xsl:element name="title">
						<xsl:value-of select="$sectionName"/>
					</xsl:element>
					<xsl:element name="text">
						<xsl:for-each select="key('loincSection',$sectionCode)">
							<xsl:if test="OBX.5 != $sectionName">
								<xsl:value-of select="OBX.5"/>
								<xsl:element name="br"/>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>
            </xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text>
      </xsl:text>
		</xsl:if>
		<!-- </xsl:for-each> -->
	</xsl:template>
	<!-- =============================== -->
	<!-- ====    FORMATTING UTILITIES    ==== -->
	<xsl:template name="formatId">
		<xsl:param name="root"/>
		<xsl:param name="id"/>
		<xsl:param name="idDesc"/>
		<xsl:element name="id">
			<xsl:attribute name="root"><xsl:value-of select="$root"/></xsl:attribute>
			<xsl:if test="$id != 'UNK'">
				<xsl:attribute name="extension"><xsl:value-of select="$id"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="assigningAuthorityName"><xsl:value-of select="$idDesc"/></xsl:attribute>
			<xsl:if test="$id = 'UNK'">
				<xsl:attribute name="nullFlavor"><xsl:value-of select="$id"/></xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="formatTemplateId">
		<xsl:param name="templateOID"/>
		<xsl:param name="templateDesc"/>
		<xsl:element name="templateId">
			<xsl:attribute name="root"><xsl:value-of select="$templateOID"/></xsl:attribute>
			<xsl:if test="$templateDesc">
				<!--
				<xsl:attribute name="identifierName"><xsl:value-of select="$templateDesc"/></xsl:attribute>
			-->
				<xsl:attribute name="assigningAuthorityName"><xsl:value-of select="$templateDesc"/></xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="formatCode">
		<xsl:param name="codeSystem"/>
		<xsl:param name="codeSystemName"/>
		<xsl:param name="codeValue"/>
		<xsl:param name="dispName"/>
		<xsl:element name="code">
			<xsl:attribute name="codeSystem"><xsl:value-of select="$codeSystem"/></xsl:attribute>
			<xsl:attribute name="codeSystemName"><xsl:value-of select="$codeSystemName"/></xsl:attribute>
			<xsl:attribute name="code"><xsl:value-of select="$codeValue"/></xsl:attribute>
			<xsl:attribute name="displayName"><xsl:value-of select="$dispName"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="formatLabStatus">
		<xsl:param name="resultStatus"/>
		<xsl:choose>
			<xsl:when test="$resultStatus = 'F'">
				<xsl:text>completed</xsl:text>
			</xsl:when>
			<xsl:when test="$resultStatus = 'X'">
				<xsl:text>aborted</xsl:text>
			</xsl:when>
			<xsl:when test="$resultStatus != ''">
				<xsl:text>active</xsl:text>
				<!-- <xsl:value-of select="$resultStatus" /> -->
			</xsl:when>
			<!-- TODO: Need to handle NullFlavor="NI" -->
			<xsl:otherwise>
				<xsl:text>NI</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====  ==  Format Providers  ==   ==== -->
	<xsl:template name="formatAssignedEntity">
		<xsl:param name="docField"/>
		<xsl:param name="personType"/>
		<!-- Doctor's Licence Number (often mandatory) -->
		<xsl:call-template name="formatId">
			<xsl:with-param name="root">
				<xsl:value-of select="$bcProvRootOid"/>
			</xsl:with-param>
			<xsl:with-param name="id">
				<xsl:choose>
					<!-- Meditech treats OBR.32, a CM field, like an XCN field. So the XML is wonky. -->
					<!-- That's why we have to check both $docfield[1] and its children for text. -->
					<xsl:when test="$docField[1]/text()[normalize-space(.)]|$docField[1]/*/text()[normalize-space(.)]">
						<xsl:value-of select="$docField[1]"/>
					</xsl:when>
					<!-- Because this is mandatory, send in a nullFlavor if it isn't available -->
					<xsl:otherwise>UNK</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="idDesc">
				<xsl:value-of select="$bcProvRootOidDisp"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- Doctor's Mnemonic (usually optional) -->
		<xsl:if test="$docField[substring(name(),(string-length(name())-1))='.8']/text()[normalize-space(.)]">
			<xsl:call-template name="formatId">
				<xsl:with-param name="root">
					<xsl:value-of select="$ihaProvRootOid"/>
				</xsl:with-param>
				<xsl:with-param name="id">
					<xsl:value-of select="$docField[substring(name(),(string-length(name())-1))='.8']"/>
				</xsl:with-param>
				<xsl:with-param name="idDesc">
					<xsl:value-of select="$ihaProvRootOidDisp"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!-- Doctor's Name -->
		<xsl:element name="{$personType}">
			<xsl:attribute name="classCode">PSN</xsl:attribute>
			<xsl:attribute name="determinerCode">INSTANCE</xsl:attribute>
			<xsl:element name="name">
				<xsl:attribute name="use">L</xsl:attribute>
				<xsl:if test="$docField[substring(name(),(string-length(name())-1))='.6']/text()[normalize-space(.)]">
					<xsl:element name="prefix">
						<xsl:value-of select="$docField[substring(name(),(string-length(name())-1))='.6']"/>
					</xsl:element>
				</xsl:if>
				<xsl:element name="family">
					<xsl:value-of select="$docField[substring(name(),(string-length(name())-1))='.2']"/>
				</xsl:element>
				<xsl:element name="given">
					<xsl:value-of select="$docField[substring(name(),(string-length(name())-1))='.3']"/>
				</xsl:element>
				<xsl:if test="$docField[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
					<xsl:element name="given">
						<xsl:value-of select="$docField[substring(name(),(string-length(name())-1))='.4']"/>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Format provider name as Lastname, Dr Firstname Middlename -->
	<xsl:template name="formatTextProvider">
		<xsl:param name="provider"/>
		<xsl:value-of select="$provider[substring(name(),(string-length(name())-1))='.2']"/>
		<xsl:text>, </xsl:text>
		<xsl:if test="$provider[substring(name(),(string-length(name())-1))='.6']/text()[normalize-space(.)]">
			<xsl:value-of select="$provider[substring(name(),(string-length(name())-1))='.6']"/>
    		<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="$provider[substring(name(),(string-length(name())-1))='.3']"/>
		<xsl:if test="$provider[substring(name(),(string-length(name())-1))='.4']/text()[normalize-space(.)]">
			<xsl:text> </xsl:text>
			<xsl:value-of select="$provider[substring(name(),(string-length(name())-1))='.4']"/>
		</xsl:if>		
	</xsl:template>
	<!-- ====  ==  Format Address  ==   ==== -->
	<!-- === Thanks, CHI, for this format. === -->
	<xsl:template name="formatAddress">
		<xsl:param name="addr"/>
		<xsl:variable name="addrType" select="$addr[substring(name(),(string-length(name())-1))='.7']"/>
		<xsl:element name="addr">
			<xsl:attribute name="use">
				<xsl:choose>
					<xsl:when test="$addrType='Mailing'">PST</xsl:when>
					<xsl:when test="$addrType='Alternate'">TMP</xsl:when>
					<xsl:otherwise>H</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		  <xsl:for-each select="$addr">
			<xsl:choose>
				<xsl:when test="(substring(name(),(string-length(name())-1))='.1' or substring(name(),(string-length(name())-1))='.2') and text() != ''">
					<xsl:value-of select="."/>
					<xsl:element name="delimiter"/>
				</xsl:when>
				<xsl:when test="substring(name(),(string-length(name())-1))='.3'">
					<xsl:element name="city">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="substring(name(),(string-length(name())-1))='.4'">
					<xsl:element name="state">
						<xsl:text>CA-</xsl:text>
						<xsl:value-of select="substring(.,0,3)"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="substring(name(),(string-length(name())-1))='.5'">
					<xsl:element name="postalCode">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		  </xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="formatTelecom">
		<xsl:param name="telno"/>
		<xsl:param name="use"/>
		<xsl:element name="telecom">
			<xsl:attribute name="use"><xsl:value-of select="$use"/></xsl:attribute>
			<xsl:attribute name="value"><xsl:text>tel:</xsl:text><xsl:value-of select="normalize-space($telno)"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	
    <!-- A really hackish, unpleasant way to determine if a date is within Cdn DST, only good between 2012 and 2018 -->
    <!-- The C# method is much better if it is available (via BizTalk or ASP.NET). -->
	<xsl:template name="isDST">
		<xsl:param name="date"/>
		<xsl:variable name="year" select="substring($date,0,5)"/>
		<!-- xsl:variable name="month" select="substring($date,5,2)"/ -->
		<!-- xsl:variable name="day" select="substring($date,7,2)"/ -->
		<xsl:variable name="mody" select="substring($date,5,4)"/>
		<xsl:variable name="dstStart">
			<xsl:choose>
				<xsl:when test="$year='2012'">0311</xsl:when>
				<xsl:when test="$year='2013'">0310</xsl:when>
				<xsl:when test="$year='2014'">0309</xsl:when>
				<xsl:when test="$year='2015'">0308</xsl:when>
				<xsl:when test="$year='2016'">0313</xsl:when>
				<xsl:when test="$year='2017'">0312</xsl:when>
				<xsl:when test="$year='2018'">0311</xsl:when>
				<xsl:otherwise>0310</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dstEnd">
			<xsl:choose>
				<xsl:when test="$year='2012'">1104</xsl:when>
				<xsl:when test="$year='2013'">1103</xsl:when>
				<xsl:when test="$year='2014'">1102</xsl:when>
				<xsl:when test="$year='2015'">1101</xsl:when>
				<xsl:when test="$year='2016'">1106</xsl:when>
				<xsl:when test="$year='2017'">1105</xsl:when>
				<xsl:when test="$year='2018'">1104</xsl:when>
				<xsl:otherwise>1101</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($date) &gt; 7">
				<xsl:choose>
					<xsl:when test="$mody &gt;= $dstStart and $mody &lt; $dstEnd">
						<xsl:value-of select="true()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="false()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Format HL7 v3 date -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:param name="timezone" select="$timezonedb"/>
		<xsl:choose>
  		<xsl:when  test="$date">
		<xsl:variable name="dateOnly">
			<xsl:choose>
				<xsl:when test="contains($date,'+')">
					<xsl:value-of select="substring-before($date, '+')"/>
				</xsl:when>
				<xsl:when test="contains($date,'-')">
					<xsl:value-of select="substring-before($date, '-')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$date"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
  		<!-- Need to know daylight savings time -->
  		<xsl:variable name="DST">
			<xsl:call-template name="isDST">
				<xsl:with-param name="date" select="$dateOnly" />
			</xsl:call-template>
  		</xsl:variable>
		<!-- time zone -->
		<xsl:variable name="tzon">
			<xsl:choose>
				<xsl:when test="contains($date,'+')">
					<xsl:text>+</xsl:text>
					<xsl:value-of select="substring-after($date, '+')"/>
				</xsl:when>
				<xsl:when test="contains($date,'-')">
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring-after($date, '-')"/>
				</xsl:when>			
				<!-- MDT -->
				<xsl:when test="contains($timezone,'MT') and not($DST)">-0700</xsl:when>
				<!-- MST -->
				<xsl:when test="contains($timezone,'MT') and $DST">-0600</xsl:when>
				<!-- Creston does not observe DST -->
				<xsl:when test="contains($timezone,'CT')">-0700</xsl:when>
				<!-- PDT -->
				<xsl:when test="contains($timezone,'PT') and $DST">-0700</xsl:when>
				<!-- PST if no time zone -->
				<xsl:otherwise>-0800</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="(string-length($dateOnly) &gt; 8) and ($microsoft='true')">
				<xsl:value-of select="userCSharp:UTC_Offset_Time($dateOnly, $timezone)"/>
			</xsl:when>			
			<xsl:when test="string-length($dateOnly) &gt; 8">
				<xsl:value-of select="substring($dateOnly,0,13)"/>
				<xsl:value-of select="$tzon"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$dateOnly"/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:when>
		<xsl:otherwise>null</xsl:otherwise>
      </xsl:choose>
	</xsl:template>
	
	<!-- Format Text Dates: PLIS-style date time -->
	
	<xsl:template name="formatTextDate">
		<xsl:param name="date"/>
		<xsl:param name="timezone" select="$timezonedb"/>

		<xsl:variable name="dateOnly">
			<xsl:choose>
				<xsl:when test="contains($date,'+')">
					<xsl:value-of select="substring-before($date, '+')"/>
				</xsl:when>
				<xsl:when test="contains($date,'-')">
					<xsl:value-of select="substring-before($date, '-')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$date"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

  		<!-- Need to know daylight savings time -->
  		<xsl:variable name="DST">
			<xsl:call-template name="isDST">
				<xsl:with-param name="date" select="$dateOnly" />
			</xsl:call-template>
  		</xsl:variable>
		
		<!-- time zone -->
		<xsl:variable name="tzon">
			<xsl:choose>
				<xsl:when test="contains($date,'+')">
					<xsl:text>+</xsl:text>
					<xsl:value-of select="substring-after($date, '+')"/>
				</xsl:when>
				<xsl:when test="contains($date,'-')">
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring-after($date, '-')"/>
				</xsl:when>
				<!-- MDT -->
				<xsl:when test="contains($timezone,'MT') and not($DST)">-0700</xsl:when>
				<!-- MST -->
				<xsl:when test="contains($timezone,'MT') and $DST">-0600</xsl:when>
				<!-- Creston does not observe DST -->
				<xsl:when test="contains($timezone,'CT')">-0700</xsl:when>
				<!-- PDT -->
				<xsl:when test="contains($timezone,'PT') and $DST">-0700</xsl:when>
				<!-- PST if no time zone -->
				<xsl:otherwise>-0800</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="string-length($dateOnly) &gt; 0">
		
		<!-- day -->
		<xsl:value-of select="substring ($dateOnly, 7, 2)"/>
		<xsl:text>/</xsl:text>

		<!-- month -->
		<xsl:variable name="month" select="substring ($dateOnly, 5, 2)"/>
		<xsl:choose>
			<xsl:when test="$month='01'">
				<xsl:text>Jan</xsl:text>
			</xsl:when>
			<xsl:when test="$month='02'">
				<xsl:text>Feb</xsl:text>
			</xsl:when>
			<xsl:when test="$month='03'">
				<xsl:text>Mar</xsl:text>
			</xsl:when>
			<xsl:when test="$month='04'">
				<xsl:text>Apr</xsl:text>
			</xsl:when>
			<xsl:when test="$month='05'">
				<xsl:text>May</xsl:text>
			</xsl:when>
			<xsl:when test="$month='06'">
				<xsl:text>Jun</xsl:text>
			</xsl:when>
			<xsl:when test="$month='07'">
				<xsl:text>Jul</xsl:text>
			</xsl:when>
			<xsl:when test="$month='08'">
				<xsl:text>Aug</xsl:text>
			</xsl:when>
			<xsl:when test="$month='09'">
				<xsl:text>Sep</xsl:text>
			</xsl:when>
			<xsl:when test="$month='10'">
				<xsl:text>Oct</xsl:text>
			</xsl:when>
			<xsl:when test="$month='11'">
				<xsl:text>Nov</xsl:text>
			</xsl:when>
			<xsl:when test="$month='12'">
				<xsl:text>Dec</xsl:text>
			</xsl:when>
		</xsl:choose>

		<xsl:text>/</xsl:text>

		<!-- year -->
		<xsl:value-of select="substring ($dateOnly, 1, 4)"/>
		<!-- time and US timezone -->
		<xsl:if test="string-length($dateOnly) &gt; 8">
			<xsl:text> </xsl:text>
			<!-- time -->
			<xsl:variable name="time">
				<xsl:value-of select="substring($dateOnly,9,6)"/>
			</xsl:variable>
			<xsl:variable name="hh">
				<xsl:value-of select="substring($time,1,2)"/>
			</xsl:variable>
			<xsl:variable name="mm">
				<xsl:value-of select="substring($time,3,2)"/>
			</xsl:variable>
			<xsl:variable name="ss">
				<xsl:value-of select="substring($time,5,2)"/>
			</xsl:variable>
			<xsl:if test="string-length($hh)&gt;1">
				<xsl:value-of select="$hh"/>
				<xsl:if test="string-length($mm)&gt;1 and not(contains($mm,'-')) and not (contains($mm,'+'))">
					<xsl:text>:</xsl:text>
					<xsl:value-of select="$mm"/>
					<xsl:if test="string-length($ss)&gt;1 and not(contains($ss,'-')) and not (contains($ss,'+'))">
						<xsl:text>:</xsl:text>
						<xsl:value-of select="$ss"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:choose>
				<!-- Get the timezone in C# -->
				<xsl:when test="$microsoft='true'">
					<xsl:text> </xsl:text>
					<xsl:value-of select="userCSharp:DTS_ShortName($dateOnly, $timezone)"/>
				</xsl:when>
				<!-- MDT -->
				<xsl:when test="contains($timezone,'MT') and $DST"> MDT</xsl:when>
				<!-- MST -->
				<!-- Creston does not observe DST -->
				<xsl:when test="contains($timezone,'MT') or contains($timezone,'CT')"> MST</xsl:when>
				<!-- PDT -->
				<xsl:when test="contains($timezone,'PT') and $DST"> PDT</xsl:when>
				<!-- PST if no time zone -->
				<xsl:when test="contains($timezone,'PT')"> PST</xsl:when>
			
				<xsl:otherwise>
					<xsl:text> </xsl:text><xsl:value-of select="$tzon"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		</xsl:if>
		
	</xsl:template>
	<msxsl:script language="C#" implements-prefix="userCSharp"><![CDATA[
		public string generateGUID()
		{
			return System.Guid.NewGuid().ToString();
		}
		
       /// <summary>
       /// Determine UTC Offset for HL7 v3 from a Meditech date string and timezone database name.
       /// </summary>
       /// <param name="mtdt">Meditech date string: yyyyMMddHHmm</param>
       /// <param name="tzdb">Meditech timezone database name: PT, MT, or CT</param>
       /// <returns>Date-time with UTC offset, suitable for HL7 v3 messages</returns>
        public string UTC_Offset_Time(string mtdt, string tzdb)
        {
            string utcText = mtdt;

            string cleanMTdt = parseMeditechDate(mtdt);
            if (cleanMTdt == "UNK")
            {
                return utcText;
            }

            DateTime dtMT = DateTime.Parse(cleanMTdt);
            DateTimeOffset timezoneDate = new DateTimeOffset(dtMT, TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time").GetUtcOffset(dtMT));

            switch (tzdb.Substring(0, 2))
            {
                // Pacific Time Zone: Affected by DST
                case "PT":
                    timezoneDate = new DateTimeOffset(dtMT, TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time").GetUtcOffset(dtMT));
                    break;

                // Mountain Time Zone: Affected by DST
                case "MT":
                    timezoneDate = new DateTimeOffset(dtMT, TimeZoneInfo.FindSystemTimeZoneById("Mountain Standard Time").GetUtcOffset(dtMT));
                    break;

                // Creston Time Zone: Always -7:00 UTC
                case "CT":
                    timezoneDate = new DateTimeOffset(dtMT, new TimeSpan(-7, 0, 0));
                    break;
            }

            return String.Format("{0:yyyyMMddHHmmzz}00", timezoneDate);
        }

        /// <summary>
        /// Return a three-letter timezone acronym to use in text representations of dates from a Meditech date string and timezone database name.
        /// </summary>
        /// <param name="mtdt">Meditech date string: yyyyMMddHHmm</param>
        /// <param name="tzdb">Meditech timezone database name: PT, MT, or CT</param>
        /// <returns></returns>
        public string DTS_ShortName(string mtdt, string tzdb)
        {

            string cleanMTdt = parseMeditechDate(mtdt);
            if (cleanMTdt == "UNK")
            {
                return tzdb;
            }

            DateTime dtMT = DateTime.Parse(cleanMTdt);

            bool isDST = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time").IsDaylightSavingTime(dtMT);

            switch (tzdb.Substring(0, 2))
            {
                // Pacific Time Zone: Affected by DST
                case "PT":
                    return isDST ? "PDT" : "PST";

                // Mountain Time Zone: Affected by DST
                case "MT":
                    return isDST ? "MDT" : "MST";

                // Creston Time Zone: Always -7:00 UTC
                case "CT":
                    return "MST";

            }

            return tzdb;
        }

        /// <summary>
        /// Convert a Meditech date string (yyyyMMddHHmm) to the default .NET DateTime string representation
        /// </summary>
        /// <param name="mtdt">Meditech date string: yyyyMMddHHmm</param>
        /// <returns>default .NET DateTime string representation</returns>
        public string parseMeditechDate(string mtdt)
        {
            if (mtdt.Length < 8)
            {
                return "UNK";
            }

            try
            {
                if (mtdt.Length < 12)
                {
                    return DateTime.Parse(mtdt.Substring(0, 4) + "-" + mtdt.Substring(4, 2) + "-" + mtdt.Substring(6, 2)).ToString();
                }
                else 
                {
                    return DateTime.Parse(mtdt.Substring(0, 4) + "-" + mtdt.Substring(4, 2) + "-" + mtdt.Substring(6, 2) + " " + mtdt.Substring(8, 2) + ":" + mtdt.Substring(10, 2)).ToString();
                }
            }
            catch { return "UNK"; }
        }
]]></msxsl:script>
</xsl:stylesheet>
