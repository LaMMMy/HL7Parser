<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:hl7-org:v2xml">
	<xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
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
		<xsl:apply-templates select="//ZDR"/>
		<xsl:apply-templates select="//OBR"/>
		<xsl:if test="//NTE">
			<xsl:apply-templates select="//NTE"/>
			
		</xsl:if>
		<xsl:apply-templates select="//OBX[./OBX.2 != 'TX'][./OBX.3]" mode="labmode"/>

		<xsl:apply-templates select="//OBX[not(./OBX.3)]|//OBX[./OBX.2 = 'TX']" mode="reportmode"/>

	</xsl:template>
	<xsl:template match="MSH">
    <div class="table-responsive bs-example">
	    <table class="table table-bordered">
		    <tbody>
			    <tr>
				    <th colspan="20">Message Header:</th>
			    </tr>
			    <tr>
				    <th>App:</th>
				    <th>Facility:</th>
				    <th>Msg Time:</th>
				    <th>Control ID:</th>
				    <th>Type:</th>
				    <th>Version:</th>
				    <xsl:if test="//EVN/EVN.2">
					    <th>Event Datetime:</th>
					    <xsl:if test="//EVN/EVN.5/*">
						    <th>
					    Operator
				    </th>
					    </xsl:if>
				    </xsl:if>
			    </tr>
			    <tr>
				    <td id="MSH.3">
					    <xsl:value-of select="normalize-space(MSH.3)"/>
				    </td>
				    <td id="MSH.4">
					    <xsl:value-of select="normalize-space(MSH.4)"/>
				    </td>
				    <td id="MSH.7">
					    <xsl:call-template name="formatDateTime">
						    <xsl:with-param name="date" select="normalize-space(MSH.7/*)"/>
					    </xsl:call-template>
				    </td>
				    <td id="MSH.10">
					    <xsl:value-of select="normalize-space(MSH.10)"/>
				    </td>
				    <td id="MSH.9">
					    <xsl:value-of select="normalize-space(MSH.9/*[1])"/>_<xsl:value-of select="normalize-space(MSH.9/*[2])"/>
				    </td>
				    <td id="MSH.12">
			    HL7 v<xsl:value-of select="normalize-space(MSH.12)"/>
				    </td>
				    <xsl:if test="//EVN/EVN.2">
					    <td id="EVN.2">
						    <xsl:call-template name="formatDateTime">
							    <xsl:with-param name="date" select="normalize-space(//EVN/EVN.2/*)"/>
						    </xsl:call-template>
					    </td>
				    </xsl:if>
				    <xsl:if test="normalize-space(//EVN/EVN.5/*)">
					    <td id="EVN.5">
						    <xsl:value-of select="//EVN/EVN.5/*"/>
					    </td>
				    </xsl:if>
			    </tr>
		    </tbody>
	    </table>
     </div>
		
	</xsl:template>
	
	<xsl:template match="//PID">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th colspan="20">Patient Information:</th>
				</tr>
				<tr>
					<th>Acct:</th>
					<xsl:if test="PID.2/*|PID.3/*">
						<th>ID:</th>
					</xsl:if>
					<xsl:if test="PID.4/*|PID.19">
						<th>PHN:</th>
					</xsl:if>
					<th>Sex:</th>
					<th>Name:</th>
					<th>DOB:</th>
					<th>Address:</th>
					<th>Phone:</th>
				</tr>
				<tr>
					<td id="PID.18">
						<xsl:value-of select="PID.18/*"/>
					</td>
					<xsl:if test="PID.2/*|PID.3/*">
						<td id="PID.3">
							<xsl:for-each select="PID.3/*">
								<xsl:value-of select="."/>
							</xsl:for-each>
							<xsl:value-of select="PID.2/*"/>
						</td>
					</xsl:if>
					<xsl:if test="PID.4/*|PID.19">
						<td id="PID.4">
							<xsl:value-of select="PID.19"/>
							<xsl:if test="PID.4/*[text()] != PID.19[text()]">
								<xsl:value-of select="PID.4/*"/>
							</xsl:if>
						</td>
					</xsl:if>
					<td id="PID.8">
						<xsl:value-of select="PID.8"/>
					</td>
					<td id="PID.5">
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
					</td>
					<td id="PID.7">
						<xsl:call-template name="formatDateTime">
							<xsl:with-param name="date" select="PID.7/*"/>
						</xsl:call-template>
					</td>
					<td id="PID.11">
						<xsl:call-template name="formatAddress">
							<xsl:with-param name="addr" select="PID.11/*"/>
						</xsl:call-template>
					</td>
					<td id="PID.13">
						<xsl:value-of select="PID.13/*"/>
					</td>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template match="//PD1">
	</xsl:template>
	
	<xsl:template match="//NK1">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th colspan="20">Patient Information:</th>
				</tr>
				<tr>
					<td colspan="2">
						<xsl:text> </xsl:text>
					</td>
					<td>
						<strong>Next of Kin</strong>
					</td>
					<td id="NK1.3">
						<strong>Relationship:</strong>
						<xsl:choose>
							<xsl:when test="NK1.3/*[contains(name(),'.2')]">
								<xsl:value-of select="NK1.3/*[contains(name(),'.2')]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="NK1.3/*[contains(name(),'.1')]"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="NK1.3/*[contains(name(),'.2')]"/>
					</td>
					<td id="NK1.2">
						<xsl:for-each select="NK1.2/*">
							<xsl:if test="contains(name(),'.1')">
								<xsl:value-of select="."/>,
						
					</xsl:if>
							<xsl:if test="not(contains(name(),'.1'))">
								<xsl:value-of select="."/>
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</td>
					<xsl:if test="NK1.7">
						<td id="NK1.7">
							<strong>Contact Role:</strong>
							<xsl:value-of select="NK1.7"/>
						</td>
					</xsl:if>
					<td>
						<strong>Address:</strong>
						<xsl:call-template name="formatAddress">
							<xsl:with-param name="addr" select="NK1.4/*"/>
						</xsl:call-template>
					</td>
					<xsl:if test="NK1.5">
						<td id="NK1.5">
							<strong>Phone:</strong>
							<xsl:value-of select="NK1.5"/>
						</td>
					</xsl:if>
					<xsl:if test="NK1.6">
						<td id="NK1.6">
							<strong>Work Phone:</strong>
							<xsl:value-of select="NK1.6"/>
						</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template match="//PV1">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th colspan="20">Visit Information:</th>
				</tr>
				<tr>
					<xsl:if test="normalize-space(//PV2.3)">
						<th>Admit Reason:</th>
					</xsl:if>
					<xsl:if test="PV1.44/*">
						<th>Admit Date:</th>
					</xsl:if>
					<xsl:if test="PV1.45/*">
						<th>Discharge Date:</th>
					</xsl:if>
					<th>Location:</th>
					<xsl:if test="PV1.4">
						<th>Adm Type:</th>
					</xsl:if>
					<th>Acct Type:</th>
					<xsl:if test="PV1.7/*">
						<th>Attending Phys:</th>
					</xsl:if>
					<xsl:if test="PV1.9/*">
						<th>Consulting Phys:</th>
					</xsl:if>
					<xsl:if test="PV1.17/*">
						<th>Admitting Phys:</th>
					</xsl:if>
					<xsl:if test="PV1.52/*">
						<th>Other Provider:</th>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="//PV2.3/*">
						<td>
							<xsl:value-of select="//PV2.3/*"/>
						</td>
					</xsl:if>
					<xsl:if test="PV1.44/*">
						<td id="PV1.44">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="PV1.44/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="PV1.45/*">
						<td id="PV1.45">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="PV1.45/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<td>
						<xsl:for-each select="PV1.3/*">
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:value-of select="PV1.39"/>
					</td>
					<xsl:if test="PV1.4">
						<td id="PV1.4">
							<xsl:value-of select="PV1.4"/>
						</td>
					</xsl:if>
					<td>
						<xsl:value-of select="PV1.41"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="PV1.18"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="PV1.2"/>
						<xsl:value-of select="PV1.10"/>
					</td>
					<xsl:if test="PV1.7/*">
						<td id="PV1.7">
							<xsl:call-template name="formatDoctor">
								<xsl:with-param name="docField" select="PV1.7/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="PV1.9/*">
						<td id="PV1.9">
							<xsl:call-template name="formatDoctor">
								<xsl:with-param name="docField" select="PV1.9/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="PV1.17/*">
						<td id="PV1.17">
							<xsl:call-template name="formatDoctor">
								<xsl:with-param name="docField" select="PV1.17/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="PV1.52/*">
						<td id="PV1.52">
							<xsl:call-template name="formatDoctor">
								<xsl:with-param name="docField" select="PV1.52/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template match="//AL1">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th colspan="20">Patient Information:</th>
				</tr>
				<tr>
					<th>Allergy Type</th>
					<th>Allergy Info</th>
					<xsl:if test="AL1.4">
						<th>Severity</th>
					</xsl:if>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="AL1.2"/>
					</td>
					<td>
						<table width="100%" border="1px">
							<tr>
								<xsl:for-each select="AL1.3/*">
									<td>
										<xsl:value-of select="."/>
									</td>
								</xsl:for-each>
							</tr>
						</table>
					</td>
					<xsl:if test="AL1.4">
						<td>
							<xsl:value-of select="AL1.4"/>
						</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template match="//IN1">
	</xsl:template>
	
	<xsl:template match="//ORC">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th colspan="20" width="100%">Order Information</th>
				</tr>
				<tr>
					<th>Date/Time</th>
					<xsl:if test="//OBR/OBR.4/*[contains(name(),'.2')] != 'Discharge Summary'">
						<th>Order ID</th>
					</xsl:if>
					<xsl:if test="//OBR/OBR.4/*[contains(name(),'.2')] = 'Discharge Summary'">
						<th>Report ID</th>
					</xsl:if>
					<th>Status</th>
					<th>Entered By</th>
					<xsl:if test="ORC.13/*">
						<th>Entered At</th>
					</xsl:if>
					<xsl:if test="ORC.12/*">
						<th>Ordered By</th>
					</xsl:if>
				</tr>
				<tr>
					<td id="ORC.9">
						<xsl:call-template name="formatDateTime">
							<xsl:with-param name="date" select="ORC.9/*"/>
						</xsl:call-template>
					</td>
					<td id="ORC.2">
						<xsl:value-of select="ORC.2/*"/>
					</td>
					<td id="ORC.5">
						<xsl:value-of select="ORC.5"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="ORC.6"/>
					</td>
					<td id="ORC.10">
						<xsl:call-template name="formatDoctor">
							<xsl:with-param name="docField" select="ORC.10/*"/>
						</xsl:call-template>
					</td>
					<xsl:if test="ORC.13/*">
						<td id="ORC.13">
							<xsl:value-of select="ORC.13/*"/>
						</td>
					</xsl:if>
					<xsl:if test="ORC.12/*">
						<td id="ORC.12">
							<xsl:call-template name="formatDoctor">
								<xsl:with-param name="docField" select="ORC.12/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template match="//ZDR">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th colspan="20" width="100%">
			  Distribution Providers
					</th>
				</tr>
				<tr>
					<xsl:for-each select="./*">
						<td>
							<xsl:call-template name="formatDoctor">
								<xsl:with-param name="docField" select="./*"/>
							</xsl:call-template>
						</td>
					</xsl:for-each>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template match="//NTE">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>Notes:</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="NTE.3"/>
					</td>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template match="//OBR">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<!-- Discharge Summary -->
					<xsl:if test="OBR.4/*[contains(name(),'.2')] = 'Discharge Summary'">
						<th>Discharge Summary Date</th>
					</xsl:if>
					<!-- Other Test Results -->
					<xsl:if test="OBR.4/*[contains(name(),'.2')] != 'Discharge Summary'">
						<th>Specimen:</th>
						<th>Service:</th>
						<th>Test Info:</th>
						<th>Test Date/Time:</th>
						<th>Results Date/Time:</th>
						<th>Status:</th>
					</xsl:if>
					<!-- Common fields -->
					<th colspan="10">Copies To:</th>
				</tr>
				<tr>
					<!-- Discharge Summary -->
					<xsl:if test="OBR.4/*[contains(name(),'.2')] = 'Discharge Summary'">
						<td id="OBR.22">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="OBR.22/*"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<!-- Other Test Results -->
					<xsl:if test="OBR.4/*[contains(name(),'.2')] != 'Discharge Summary'">
						<td id="OBR.3">
							<xsl:value-of select="OBR.3/*"/>
						</td>
						<td id="OBR.24">
							<xsl:value-of select="OBR.24"/>
						</td>
						<td>
							<table class="table table-bordered">
								<tr>
									<td id="OBR.4.1">
										<strong>Test ID:</strong>
										<xsl:value-of select="OBR.4/*[contains(name(),'.1')]"/>
										<xsl:value-of select="OBR.4/*[contains(name(),'.4')]"/>
									</td>
									<td id="OBR.4.2">
										<strong>Test Name:</strong>
										<xsl:value-of select="OBR.4/*[contains(name(),'.2')]"/>
										<xsl:value-of select="OBR.4/*[contains(name(),'.5')]"/>
									</td>
								</tr>
							</table>
						</td>
						<td id="OBR.7">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="OBR.7/*"/>
							</xsl:call-template>
						</td>
						<td id="OBR.22">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="OBR.22/*"/>
							</xsl:call-template>
						</td>
						<td id="OBR.25">
							<xsl:value-of select="OBR.25"/>
						</td>
					</xsl:if>
					<!-- Common fields -->
					<xsl:for-each select="OBR.28">
						<td id="OBR.28">
							<xsl:call-template name="formatDoctor">
								<xsl:with-param name="docField" select="./*"/>
							</xsl:call-template>
						</td>
					</xsl:for-each>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<!-- Lab test results -->
	<xsl:template match="//OBX[./OBX.2 != 'TX'][./OBX.3]" mode="labmode">
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th colspan="20">Test Results:</th>
				</tr>
				<tr>
					<td class="obxTestId">
						<strong>Test ID:</strong>
						<xsl:value-of select="OBX.3/*[contains(name(),'.1')]"/>
						<xsl:value-of select="OBX.3/*[contains(name(),'.4')]"/>
					</td>
					<td class="obxTestName">
						<strong>Test Name:</strong>
						<xsl:value-of select="OBX.3/*[contains(name(),'.2')]"/>
						<xsl:value-of select="OBX.3/*[contains(name(),'.5')]"/>
					</td>
					<xsl:if test="OBX.6">
						<td class="obxTestUnits">
							<strong>Units:</strong>
							<xsl:value-of select="OBX.6"/>
						</td>
					</xsl:if>
					<td class="obxTestResults">
						<strong>Results:</strong>
						<xsl:if test="OBX.5">
							<xsl:value-of select="OBX.5"/>
						</xsl:if>
						<xsl:if test="OBX.7">
							<xsl:value-of select="OBX.7"/>
						</xsl:if>
						<xsl:if test="OBX.8">
              Abnormal: <xsl:value-of select="OBX.8"/>
						</xsl:if>
					</td>
					<xsl:if test="OBX.11">
						<td class="obxTestStatus">
							<strong>Status:</strong>
							<xsl:value-of select="OBX.11"/>
						</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<!-- Reports -->
	<xsl:template match="//OBX[not(./OBX.3)]|//OBX[./OBX.2 = 'TX']" mode="reportmode">
		<pre>
			<xsl:text>
			</xsl:text>
			<xsl:value-of select="OBX.5"/>		
			<xsl:text>
			</xsl:text>
		</pre>
	</xsl:template>
	
	<!---->
	<xsl:template name="formatDoctor">
		<xsl:param name="docField"/>
		<!-- Doctor's Licence Number -->
		<xsl:value-of select="$docField[1]"/>
		<xsl:text> </xsl:text>
		<!-- Doctor's Mnemonic -->
		<xsl:value-of select="$docField[contains(name(),'.8')]"/>
		<!-- Doctor's Name -->
		<xsl:value-of select="$docField[contains(name(),'.6')]"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$docField[contains(name(),'.3')]"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$docField[contains(name(),'.4')]"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$docField[contains(name(),'.2')]"/>
		<xsl:if test="$docField[contains(name(),'.15')]">
			Type: 
			<xsl:value-of select="$docField[contains(name(),'.15')]"/>
		</xsl:if>
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
			<xsl:text>, </xsl:text>
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
			<xsl:value-of select="."/>
			<xsl:if test="contains(name(),'.1')">
				<xsl:text>,</xsl:text>
			</xsl:if>
			<xsl:if test="contains(name(),'.2')">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="not(contains(name(),'.2'))">
				
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
