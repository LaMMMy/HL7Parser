<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:hl7-org:v2xml">
	<xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
	
	<xsl:variable name="sendingApp">
		<xsl:value-of select="normalize-space(//MSH/MSH.3/HD.1)" />
	</xsl:variable>
	
	<xsl:variable name="sendingFacility">
		<xsl:value-of select="normalize-space(//MSH/MSH.4/HD.1)" />
	</xsl:variable>		
	
	<xsl:variable name="receivingApp">
		<xsl:value-of select="normalize-space(//MSH/MSH.5/HD.1)" />
	</xsl:variable>		
	
	<xsl:template match="/">
		<html>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="n1:*">
		<a name="MSH">
			<xsl:text> </xsl:text>
		</a>
		<a name="PID">
			<xsl:text> </xsl:text>
		</a>
		<a name="PV1">
			<xsl:text> </xsl:text>
		</a>
		<a name="ORC">
			<xsl:text> </xsl:text>
		</a>
		<a name="ZDR">
			<xsl:text> </xsl:text>
		</a>
		<a name="OBR">
			<xsl:text> </xsl:text>
		</a>
		<a name="NTE">
			<xsl:text> </xsl:text>
		</a>
		<xsl:apply-templates select="MSH"/>
		<xsl:apply-templates select="//PID"/>
		<xsl:apply-templates select="//PD1"/>
		<xsl:apply-templates select="//NK1"/>
		<xsl:apply-templates select="//PV1"/>

		<xsl:apply-templates select="//AL1"/>
		<xsl:apply-templates select="//IN1"/>
		<xsl:apply-templates select="//ORC"/>
		<!--<xsl:apply-templates select="//ZDR"/>-->

		<xsl:apply-templates select="//OBR"/>
		
		<xsl:if test="//NTE">
      <div class="bs-example NTE" id="NTE">
			  <xsl:apply-templates select="//NTE"/>
			</div>
		</xsl:if>

		<div class="bs-example OBX" id="OBX">
			<dl class="dl-horizontal">
				<xsl:apply-templates select="//OBX[./OBX.2 != 'TX'][./OBX.3]" mode="labmode"/>
			</dl>
      <dl class="dl-horizontal">
        <dd>
          <xsl:apply-templates select="//OBX[not(./OBX.3)]|//OBX[./OBX.2 = 'TX']" mode="reportmode"/>
        </dd>
      </dl>
		</div>
    
	</xsl:template>
	<xsl:template match="MSH">
		<div id="MSH" class="bs-example MSH info">
			<dl class="dl-horizontal">
				<dt>App:</dt>
				<dd id="MSH.3">
					<xsl:value-of select="$sendingApp"/>
				</dd>
				<dt>Facility:</dt>
				<dd id="MSH.4">
					<xsl:value-of select="$sendingFacility"/>
				</dd>
				<dt>Msg Time:</dt>
				<dd id="MSH.7">
					<xsl:call-template name="formatDateTime">
						<xsl:with-param name="date" select="normalize-space(MSH.7/*)"/>
					</xsl:call-template>
				</dd>
				<dt>Control ID:</dt>
				<dd id="MSH.10">
					<xsl:value-of select="normalize-space(MSH.10)"/>
				</dd>
				<dt>Type:</dt>
				<dd id="MSH.9">
					<xsl:value-of select="normalize-space(MSH.9/*[1])"/>_<xsl:value-of select="normalize-space(MSH.9/*[2])"/>
				</dd>
				<dt>Version:</dt>
				<dd id="MSH.12">
					HL7 v<xsl:value-of select="normalize-space(MSH.12)"/>
				</dd>
			</dl>
		</div>
	</xsl:template>
	
	<xsl:template match="//PID">
		<div class="bs-example PID" id="PID">
			<dl class="dl-horizontal">
				<dt>Account #</dt>
				<dd id="PID.18">
					<xsl:value-of select="PID.18/*" />
				</dd>
				<xsl:if test="PID.2/*|PID.3/*">
					<dt>ID</dt>
					<dd id="PID.3">
						<xsl:for-each select="PID.3/*">
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="PID.2/*"/>
					</dd>
				</xsl:if>				
				<xsl:if test="PID.4/*|PID.19">
					<dt>PHN</dt>
					<dd id="PID.4">
						<xsl:value-of select=" normalize-space(PID.19)"/>
						<xsl:if test="normalize-space(//PID/PID.4/CX.1) != normalize-space(PID.19)">
							<xsl:if test="normalize-space(PID.19)">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="normalize-space(//PID/PID.4/CX.1)"/>
						</xsl:if>
					</dd>					
				</xsl:if>
				<dt>Sex</dt>
				<dd id="PID.8">
					<xsl:value-of select="PID.8"/>
				</dd>
				<dt>Name</dt>
				<dd id="PID.5">						
					<xsl:for-each select="PID.5/*">
						<xsl:if test="contains(name(),'.1')">
							<strong>
								<xsl:value-of select="."/>,
							</strong>
						</xsl:if>
						<xsl:if test="not(contains(name(),'.1'))">
							<xsl:value-of select="."/>
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</dd>
				<dt>DOB</dt>
				<dd id="PID.7">
					<xsl:call-template name="formatDateTime">
						<xsl:with-param name="date" select="PID.7/*"/>
					</xsl:call-template>
				</dd>
				<dt>Address</dt>
				<dd id="PID.11">
					<xsl:call-template name="formatAddress">
						<xsl:with-param name="addr" select="PID.11/*"/>
					</xsl:call-template>
				</dd>
				<xsl:if test="normalize-space(PID.13)">
					<dt>Phone</dt>
					<dd id="PID.13">
						<xsl:value-of select="normalize-space(PID.13)"/>
					</dd>
				</xsl:if>
			</dl>
		</div>
	</xsl:template>
	
	<xsl:template match="//PD1">
	</xsl:template>
	
	<xsl:template match="//NK1">
		<div class="bs-example NK1" id="NK1">
			<dl class="dl-horizontal">
				<dt>Relationship</dt>
				<dd id="NK1.3">
						<xsl:choose>
							<xsl:when test="NK1.3/*[contains(name(),'.2')]">
								<xsl:value-of select="NK1.3/*[contains(name(),'.2')]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="NK1.3/*[contains(name(),'.1')]"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="NK1.3/*[contains(name(),'.2')]"/>
				</dd>
				<dt>Next of Kin</dt>
				<dd id="NK1.2">
					<xsl:for-each select="NK1.2/*">
						<xsl:if test="contains(name(),'.1')">
							<xsl:value-of select="."/>,
					
						</xsl:if>
						<xsl:if test="not(contains(name(),'.1'))">
							<xsl:value-of select="."/>
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</dd>
				<dt>Contact Role</dt>
				<dd id="NK1.7">
					<xsl:value-of select="NK1.7"/>
				</dd>
				<dt>Address</dt>
				<dd id="NK1.4">
					<xsl:call-template name="formatAddress">
						<xsl:with-param name="addr" select="NK1.4/*"/>
					</xsl:call-template>
				</dd>
				<xsl:if test="NK1.5">
					<dt>Phone</dt>
					<dd id="NK1.5">
						<xsl:value-of select="NK1.5"/>
					</dd>
				</xsl:if>
				<dt>Work Phone</dt>
				<dd id="NK1.6">
					<xsl:value-of select="NK1.6"/>
				</dd>
			</dl>
		</div>
	</xsl:template>
	
	<xsl:template match="//PV1">
    <div class="bs-example PV1" id="PV1">
      <dl class="dl-horizontal">
        <xsl:if test="normalize-space(//PV2.3)">
          <dt>Admit Reason</dt>
          <dd id="PV2.3">
            <xsl:value-of select="//PV2.3/*"/>
          </dd>
        </xsl:if>
        <xsl:if test="PV1.44/*">
          <dt>Admit Date</dt>
          <dd id="PV1.44">
            <xsl:call-template name="formatDateTime">
              <xsl:with-param name="date" select="PV1.44/*"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <xsl:if test="PV1.45/*">
          <dt>Discharge Date</dt>
          <dd id="PV1.45">
            <xsl:call-template name="formatDateTime">
              <xsl:with-param name="date" select="PV1.45/*"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <dt>Location</dt>
        <dd id="PV1.3">
          <xsl:for-each select="PV1.3/*">
            <xsl:value-of select="."/>
          </xsl:for-each>
          <xsl:text> </xsl:text>
          <xsl:value-of select="PV1.39"/>
        </dd>
        <xsl:if test="normalize-space(PV1.39)">
			<dt>Servicing Facility</dt>
			<dd id="PV1.3">
			  <xsl:value-of select="PV1.39"/>
			</dd>
        </xsl:if>
        <xsl:if test="PV1.4">
          <dt>Admit Type</dt>
          <dd id="PV1.4">
            <xsl:value-of select="PV1.4"/>
          </dd>
        </xsl:if>
        <dt>Account Type</dt>
        <dd>
          <xsl:value-of select="PV1.41"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="PV1.18"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="PV1.2"/>
          <xsl:value-of select="PV1.10"/>
        </dd>
        <xsl:if test="PV1.7/*">
          <dt>Attending Provider</dt>
          <dd id="PV1.7">
            <xsl:call-template name="FormatProvider">
              <xsl:with-param name="docField" select="PV1.7/*"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <xsl:if test="PV1.9/*">
          <dt>Consulting Provider</dt>
          <dd id="PV1.9">
            <xsl:call-template name="FormatProvider">
              <xsl:with-param name="docField" select="PV1.9/*"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <xsl:if test="PV1.17/*">
          <dt>Admitting Provider</dt>
          <dd id="PV1.17">
            <xsl:call-template name="FormatProvider">
              <xsl:with-param name="docField" select="PV1.17/*"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <xsl:if test="PV1.52/*">
          <dt>Other Provider</dt>
          <dd id="PV1.52">
            <xsl:call-template name="FormatProvider">
              <xsl:with-param name="docField" select="PV1.52/*"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
      </dl>
    </div>
	</xsl:template>
	
	<xsl:template match="//AL1">
		<div class="bs-example AL1" id="AL1">
			<dl class="dl-horizontal">
				<dt>Allergy Type</dt>				
				<dd id="AL1.2"><xsl:value-of select="AL1.2"/></dd>
				<dt>Allergy Info</dt>
				<dd id="AL1.3">
					<xsl:for-each select="AL1.3/*">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</dd>
				<xsl:if test="AL1.4">
					<dt>Severity</dt>
					<dd id="AL1.4"><xsl:value-of select="AL1.4"/></dd>
				</xsl:if>				
			</dl>
		</div>
	</xsl:template>
	
	<xsl:template match="//IN1">
	</xsl:template>
	
	<xsl:template match="//ORC">
		<div class="bs-example ORC" id="ORC">
			<dl class="dl-horizontal">
				<dt>Order Date</dt>
				<dd id="ORC.9">
					<xsl:call-template name="formatDateTime">
						<xsl:with-param name="date" select="ORC.9/*"/>
					</xsl:call-template>
				</dd>

				<xsl:if test="//OBR/OBR.4/*[contains(name(),'.2')] != 'Discharge Summary'">
					<dt>Order ID</dt>
				</xsl:if>
				<xsl:if test="//OBR/OBR.4/*[contains(name(),'.2')] = 'Discharge Summary'">
					<dt>Report ID</dt>					
				</xsl:if>
				<dd id="ORC.2">
					<xsl:value-of select="ORC.2/*"/>
				</dd>
				
				<dt>Order Status</dt>
				<dd id="ORC.5">
					<xsl:value-of select="ORC.5"/>
				</dd>
				
				<dt>Response Flag</dt>
				<dd id="ORC.6">
					<xsl:value-of select="ORC.6"/>
				</dd>
				
				<dt>Entered By</dt>
				<dd id="ORC.10">
					<xsl:call-template name="FormatProvider">
						<xsl:with-param name="docField" select="ORC.10/*"/>
					</xsl:call-template>
				</dd>
				
				<xsl:if test="ORC.13/*">
					<dt>Entered At</dt>
					<dd id="ORC.13"><xsl:value-of select="ORC.13/*"/></dd>
				</xsl:if>
				<xsl:if test="ORC.12/*">
					<dt>Ordered By</dt>
					<dd id="ORC.12">
						<xsl:call-template name="FormatProvider">
							<xsl:with-param name="docField" select="ORC.12/*"/>
						</xsl:call-template>					
					</dd>
				</xsl:if>
			</dl>
		</div>
	</xsl:template>
	
<!--	<xsl:template match="//ZDR">
		<div class="bs-example ZDR" id="ZDR">
			<dl class="dl-horizontal">
				<dt>Providers</dt>
				<dd id="ZDR">
					<xsl:for-each select="./*">
						<xsl:call-template name="FormatProvider">
							<xsl:with-param name="docField" select="./*"/>
						</xsl:call-template>
						<xsl:element name="br" />
					</xsl:for-each>
				</dd>
			</dl>
		</div>
	</xsl:template>-->
	
	<xsl:template match="//NTE">
    <div class="bs-example NTE" id="NTE">
      <dl class="dl-horizontal">
        <dt>Notes:</dt>
        <dd>
          <xsl:value-of select="NTE.3"/>
        </dd>
      </dl>
    </div>
  </xsl:template>
	
	<xsl:template match="//OBR">
		<div class="bs-example OBR" id="OBR">
			<dl class="dl-horizontal">
				<dt></dt>
				<dd></dd>
				<xsl:choose>
					<xsl:when test="($sendingApp = 'LAB') or ($sendingApp = 'MIC') or ($sendingApp = 'MB') or ($receivingApp = 'MB')">
						<dt>Specimen</dt>
						<dd id="OBR.3">
							<xsl:value-of select="OBR.3/*"/>
						</dd>
						<dt>Service</dt>
						<dd id="OBR.24">
							<xsl:value-of select="OBR.24"/>
						</dd>
						<dt>Test Info</dt>
						<dd id="OBR.4">
							<xsl:text>Test ID: </xsl:text>
							<div class="row">
								<div class="col-md-12">
									<xsl:value-of select="normalize-space(OBR.4/CE.1)"/>
								</div>
								<div class="col-md-12">
									<xsl:value-of select="normalize-space(OBR.4/CE.4)"/>
								</div>
							</div>
							<xsl:text>Test Name: </xsl:text>
							<div class="row">
								<div class="col-md-12">
									<xsl:value-of select="normalize-space(OBR.4/CE.2)"/>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<xsl:value-of select="normalize-space(OBR.4/CE.5)"/>
								</div>
							</div>
						</dd>
						<dt>Test Date/Time</dt>
						<dd id="OBR.7">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="OBR.7/*"/>
							</xsl:call-template>
						</dd>
						<dt>Results Date/Time</dt>
						<dd id="OBR.22">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="OBR.22/*"/>
							</xsl:call-template>
						</dd>
						<dt>Status</dt>
						<dd id="OBR.25">
							<xsl:value-of select="OBR.25"/>
						</dd>
					</xsl:when>
					<xsl:when test="OBR.4/*[contains(name(),'.2')] = 'Discharge Summary'">
						<dt>Discharge Summary Date</dt>
						<dd id="OBR.22">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="OBR.22/*"/>
							</xsl:call-template>
						</dd>
					</xsl:when>
				</xsl:choose>
				<dt>Copies To</dt>
				<dd id="OBR.28">
					<xsl:call-template name="FormatProvider">
						<xsl:with-param name="docField" select="OBR.28/*"/>
					</xsl:call-template>
				</dd>
			</dl>
		</div>
	</xsl:template>
	
	<!-- Lab test results -->
	<xsl:template match="//OBX[./OBX.2 != 'TX'][./OBX.3]" mode="labmode">		
		<hr />
		<dt>Test ID</dt>
		<dd>
			<div class="row">
				<div class="col-md-12">
					<xsl:value-of select="OBX.3/*[name() = 'CE.1']"/>
				</div>
				<div class="col-md-12">
					<xsl:value-of select="OBX.3/*[name() = 'CE.4']"/>
				</div>
			</div>
		</dd>
		<dt>Test Name</dt>
		<dd>
			<div class="row">
				<div class="col-md-12">
					<xsl:value-of select="OBX.3/*[name() = 'CE.2']"/>
				</div>
				<div class="col-md-12">
					<xsl:value-of select="OBX.3/*[name() = 'CE.5']"/>
				</div>
			</div>
		</dd>
		<xsl:if test="normalize-space(OBX.6)">
			<dt>Units</dt>
			<dd>
				<xsl:value-of select="OBX.6"/>
			</dd>
		</xsl:if>				
		<dt>Results</dt>
		<dd>
			<div class="row">
				<div class="col-md-12">
					<xsl:value-of select="OBX.5"/>
				</div>
				<xsl:if test="OBX.7">
					<div class="col-md-12">
						<xsl:text>Reference Range: </xsl:text><xsl:value-of select="OBX.7"/>
					</div>
				</xsl:if>
				<xsl:if test="OBX.8">
					<div class="col-md-12">
						<xsl:text>Abnormal: </xsl:text><xsl:value-of select="OBX.8"/>
					</div>
				</xsl:if>
			</div>
		</dd>
		<xsl:if test="OBX.11">
			<dt>Status</dt>
			<dd>
				<xsl:value-of select="OBX.11"/>
			</dd>
		</xsl:if>
	</xsl:template>
	
	<!-- Reports -->
	<xsl:template match="//OBX[not(./OBX.3)]|//OBX[./OBX.2 = 'TX']" mode="reportmode">    
		<xsl:value-of select="OBX.5"/>
    <br />    
	</xsl:template>
	
	<!---->
	<xsl:template name="FormatProvider">
	<xsl:param name="docField"/>
		<div class="row">
			<div class="col-md-12">				
				<!-- Surname -->
				<xsl:value-of select="$docField[name() = 'XCN.2']"/>
				<xsl:text>, </xsl:text>
				<!-- Prefix -->
				<xsl:if test="$docField/XCN.6[normalize-space(.)]">
					<xsl:value-of select="$docField[name() = 'XCN.6'][normalize-space(.)]"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Given Name -->
				<xsl:value-of select="$docField[name() = 'XCN.3']"/>
				<!-- Middle -->
				<xsl:if test="$docField[name() = 'XCN.4'][normalize-space(.)]">
					<xsl:text> </xsl:text>
					<xsl:value-of select="$docField[name() = 'XCN.4']"/>
				</xsl:if>
			</div>
		
			<div class="col-md-12">
				<!-- Doctor's Licence Number -->
				<xsl:if test="normalize-space($docField[name() = 'XCN.1'])">
					<xsl:text>License #: </xsl:text>
					<xsl:value-of select="normalize-space($docField[name() = 'XCN.1'])"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Doctor's Mnemonic -->
				<xsl:if test="normalize-space($docField[name() = 'XCN.8'])">
					<xsl:text>Custom ID:</xsl:text><xsl:value-of select="normalize-space($docField[name() = 'XCN.8'])"/>
				</xsl:if>
				<xsl:if test="$docField[name() = 'XCN.15']">
					Type: 
					<xsl:value-of select="$docField[name() = 'XCN.15']"/>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<!---->
	<!-- Format DateTime-->
	<xsl:template name="formatDateTime">
		<xsl:param name="date"/>
		<!-- month -->
		<xsl:variable name="month" select="substring ($date, 5, 2)"/>
		<xsl:choose>
			<xsl:when test="$month='01'">
				<xsl:text>January </xsl:text>
			</xsl:when>
			<xsl:when test="$month='02'">
				<xsl:text>February </xsl:text>
			</xsl:when>
			<xsl:when test="$month='03'">
				<xsl:text>March </xsl:text>
			</xsl:when>
			<xsl:when test="$month='04'">
				<xsl:text>April </xsl:text>
			</xsl:when>
			<xsl:when test="$month='05'">
				<xsl:text>May </xsl:text>
			</xsl:when>
			<xsl:when test="$month='06'">
				<xsl:text>June </xsl:text>
			</xsl:when>
			<xsl:when test="$month='07'">
				<xsl:text>July </xsl:text>
			</xsl:when>
			<xsl:when test="$month='08'">
				<xsl:text>August </xsl:text>
			</xsl:when>
			<xsl:when test="$month='09'">
				<xsl:text>September </xsl:text>
			</xsl:when>
			<xsl:when test="$month='10'">
				<xsl:text>October </xsl:text>
			</xsl:when>
			<xsl:when test="$month='11'">
				<xsl:text>November </xsl:text>
			</xsl:when>
			<xsl:when test="$month='12'">
				<xsl:text>December </xsl:text>
			</xsl:when>
		</xsl:choose>
		<!-- day -->
		<xsl:choose>
			<xsl:when test='substring ($date, 7, 1)="0"'>
				<xsl:value-of select="substring ($date, 8, 1)"/>
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring ($date, 7, 2)"/>
				<xsl:text>, </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<!-- year -->
		<xsl:value-of select="substring ($date, 1, 4)"/>
		<!-- time and US timezone -->
		<xsl:if test="string-length($date) > 8">
			<xsl:text> </xsl:text>
			<!-- time -->
			<xsl:variable name="time">
				<xsl:value-of select="substring($date,9,6)"/>
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
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<!-- reference: http://www.timeanddate.com/library/abbreviations/timezones/na/ -->
				<xsl:when test="$tzon = '-0500' ">
					<xsl:text>, EST</xsl:text>
				</xsl:when>
				<xsl:when test="$tzon = '-0600' ">
					<xsl:text>, CST</xsl:text>
				</xsl:when>
				<xsl:when test="$tzon = '-0700' ">
					<xsl:text>, MST</xsl:text>
				</xsl:when>
				<xsl:when test="$tzon = '-0800' ">
					<xsl:text>, PST</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$tzon"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!---->
	<!-- Format Address-->
	<xsl:template name="formatAddress">
		<xsl:param name="addr"/>
			<xsl:for-each select="$addr">
				<xsl:choose>
					<!-- Street Address -->
					<xsl:when test="(self::XAD.1) and ./*[text()] != '' ">
						<xsl:value-of select="./*[text()]"/>
						<xsl:element name="br" />
					</xsl:when>
					<!--  -->
					<xsl:when test="(self::XAD.2) and ./text() != '' ">
						<xsl:value-of select="./text()"/>
						<xsl:element name="br" />
					</xsl:when>
					<!-- City -->
					<xsl:when test="(self::XAD.3) and ./text() != '' ">
						<xsl:value-of select="./text()"/>
						<xsl:element name="br" />
					</xsl:when>
					<!-- Prov/State -->
					<xsl:when test="(self::XAD.4) and ./text() != '' ">
							<xsl:text>CA</xsl:text>
							<xsl:element name="br" ></xsl:element>
					</xsl:when>
					<!-- Postal/Zip -->
					<xsl:when test="(self::XAD.5)">
							<xsl:value-of select="./text()"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
