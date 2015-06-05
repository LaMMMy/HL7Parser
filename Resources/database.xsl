<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml ADT-DB.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:hl7-org:v2xml">
<xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
<xsl:template match="/" >
	<html>
		<body>
			<xsl:apply-templates />
		</body>
	</html>
</xsl:template>
<xsl:template match="n1:*">
	<table border="1px"  width="100%">
     <tbody>
      <tr><th colspan="2" bgcolor="#4488FF">PATIENT</th></tr>
	   <tr><td>PATIENT_ID</td>
	    <td>
	      <xsl:for-each select="//n1:PID.3/*">
	         <xsl:value-of select="." /><br />
	      </xsl:for-each>
	      <xsl:value-of select="//n1:PID.2/*" />
       </td></tr>   
	   <tr><td>LAST_NAME</td>
	    <td>
  	     <xsl:value-of select="//n1:PID.5/*[contains(name(),'.1')]" />
	    </td></tr>
	   <tr><td>FIRST_NAME</td>
	    <td>
  	     <xsl:value-of select="//n1:PID.5/*[contains(name(),'.2')]" />
	    </td></tr>     
	   <tr><td>BIRTH_DATE</td>
  	  <td>
      <xsl:call-template name="formatDateTime">
        <xsl:with-param name="date" select="//n1:PID.7/*"/>
      </xsl:call-template>
	  </td></tr>
	   <tr><td>ADDRESS</td>
  	  <td>
        <xsl:call-template name="formatAddress">
        <xsl:with-param name="addr" select="//n1:PID.11/*"/>
        </xsl:call-template>
  	  </td></tr>
	   <tr><td>SEX</td>
       <td>
       <xsl:choose>
		   <xsl:when test="//n1:PID.8[text()='F']">
		   0
		   </xsl:when>
		   <xsl:when test="//n1:PID.8[text()='M']">
		   1
		   </xsl:when>
	   </xsl:choose>
       </td></tr>    
	   <tr><td>PHONE</td>
      <td><xsl:value-of select="//n1:PID.13/*" />
             <xsl:value-of select="//n1:PID.14/*" />
      </td></tr>
     </tbody>
    </table>
	  <br/><br/>
	  
	<table border="1px"  width="100%">
     <tbody>
      <tr><th colspan="2" bgcolor="#4488FF">VISIT</th></tr>
	   <tr><td>PATIENT_ID</td>
	    <td>
	      <xsl:for-each select="//n1:PID.3/*">
	         <xsl:value-of select="." /><br />
	      </xsl:for-each>
	      <xsl:value-of select="//n1:PID.2/*" />
       </td></tr>
       <tr><td>VISIT_ID</td>
       <td><xsl:value-of select="//n1:PV1.19" /></td></tr>
       <tr><td>ADMISSION_DATE</td>
           	  <td>
             <xsl:call-template name="formatDateTime">
             <xsl:with-param name="date" select="//n1:PV1.44/*"/>
             </xsl:call-template>
     	  </td></tr>
       <tr><td>ADMITTING_ID</td>
       <td>
       <xsl:value-of select="//n1:PV1.17/*[contains(name(),'.1')]" />
       </td></tr>
       <tr><td>ADMITTING_LAST_NAME</td>
       <td>
       <xsl:value-of select="//n1:PV1.17/*[contains(name(),'.2')]" />
       </td></tr>
       <tr><td>ADMITTING_FIRST_NAME</td>
       <td>
       <xsl:value-of select="//n1:PV1.17/*[contains(name(),'.3')]" />
       </td></tr>
       <tr><td>ATTENDING_ID</td>
       <td>
       <xsl:value-of select="//n1:PV1.7/*[contains(name(),'.1')]" />
       </td></tr>
       <tr><td>ATTENDING_LAST_NAME</td>
       <td>
       <xsl:value-of select="//n1:PV1.7/*[contains(name(),'.2')]" />
       </td></tr>
       <tr><td>ATTENDING_FIRST_NAME</td>
       <td>
       <xsl:value-of select="//n1:PV1.7/*[contains(name(),'.3')]" />
       </td></tr>
       <tr><td>DISCHARGE_DATE</td>
       <td>
             <xsl:call-template name="formatDateTime">
             <xsl:with-param name="date" select="//n1:PV1.45/*"/>
             </xsl:call-template>
       </td></tr>
        <tr><td>STATE</td>
        <td>
        <xsl:choose>
		   <xsl:when test="//n1:PV1.45/*">
		   1
		   </xsl:when>
		   <xsl:otherwise>
		   0
		   </xsl:otherwise>
	   </xsl:choose>
        </td>
       </tr>
        <tr><td>INSURED_PLAN_ID</td>
        <td><xsl:value-of select="//n1:IN1.2/*" /></td>
        </tr>
        <tr><td>INSURED_NUMBER</td>
        <td><xsl:value-of select="//n1:IN1.49/*" /></td>
       </tr>
     </tbody>
    </table>
	  <br/><br/>
	  
	<table border="1px"  width="100%">
     <tbody>
      <tr><th colspan="2" bgcolor="#4488FF">LOCATION</th></tr>
      <tr><td>VISIT_ID</td>
       <td><xsl:value-of select="//n1:PV1.19" /></td></tr>
       <tr><td>LOCATION_DATE</td>
             <td>
             <xsl:call-template name="formatDateTime">
             <xsl:with-param name="date" select="//n1:EVN.2/*"/>
             </xsl:call-template>
     	     </td>
       </tr>
       <tr><td>LOCATION_AREA</td>
       <td>
       <xsl:value-of select="//n1:PV1.3/*[contains(name(),'.1')]" />
       </td></tr>
       <tr><td>LOCATION_ROOM</td>
       <td>
       <xsl:value-of select="//n1:PV1.3/*[contains(name(),'.2')]" />
       </td></tr>
       <tr><td>LOCATION_BED</td>
       <td>
       <xsl:value-of select="//n1:PV1.3/*[contains(name(),'.3')]" />
       </td></tr>
     </tbody>
    </table>
   <br/><br/>
	  
	<table border="1px"  width="100%">
     <tbody>
      <tr><th colspan="2" bgcolor="#4488FF">
       PATIENT_CONTACT</th></tr>
	   <tr><td>VISIT_ID</td>
       <td><xsl:value-of select="//n1:PV1.19" /></td></tr>
	   <tr><td>CONTACT_NAME</td>
       <td>
       <xsl:value-of select="//n1:NK1.2/*[contains(name(),'.1')]" />
       <xsl:text>, </xsl:text>
       <xsl:value-of select="//n1:NK1.2/*[contains(name(),'.2')]" />
       </td></tr>
	   <tr><td>CONTACT_RELATIONSHIP</td>
       <td>
       <xsl:value-of select="//n1:NK1.3/*" />
       </td></tr>
	   <tr><td>CONTACT_START_DATE</td>
             <td>
             <xsl:call-template name="formatDateTime">
             <xsl:with-param name="date" select="//n1:NK1.8/*"/>
             </xsl:call-template>
     	     </td>
       </tr>
	   <tr><td>CONTACT_ADDRESS</td>
  	  <td>
        <xsl:call-template name="formatAddress">
        <xsl:with-param name="addr" select="//n1:NK1.4/*"/>
        </xsl:call-template>
  	  </td></tr>
	   <tr><td>CONTACT_PHONE</td>
	   <td><xsl:value-of select="//n1:NK1.5" />
	   <xsl:value-of select="//n1:NK1.6" />
	   </td>
       </tr>
     </tbody>
    </table>
	  <br/><br/>
	  
</xsl:template>

<xsl:template name="formatDoctor">
     <xsl:param name="docField"/>
        <!-- Doctor's Licence Number -->
        <xsl:value-of select="$docField[1]" />
		<xsl:text> </xsl:text>
        <!-- Doctor's Mnemonic -->
        <xsl:value-of select="$docField[contains(name(),'.8')]" />
        <br />
        <!-- Doctor's Name -->
        <xsl:value-of select="$docField[contains(name(),'.6')]" />
		<xsl:text> </xsl:text>
        <xsl:value-of select="$docField[contains(name(),'.3')]" />
		<xsl:text> </xsl:text>
        <xsl:value-of select="$docField[contains(name(),'.4')]" />
		<xsl:text> </xsl:text>
        <xsl:value-of select="$docField[contains(name(),'.2')]" />
		<xsl:if test="$docField[contains(name(),'.15')]">
		    <br />Type: 
            <xsl:value-of select="$docField[contains(name(),'.15')]" />
		</xsl:if>
</xsl:template>

<xsl:template name="formatDateTime">
      <xsl:param name="date"/>
            <!-- year -->
      <xsl:value-of select="substring ($date, 1, 4)"/>
      <xsl:text>-</xsl:text>
      <!-- month -->
      <xsl:value-of select="substring ($date, 5, 2)"/>
      <xsl:text>-</xsl:text>
      <!-- day -->
      <xsl:value-of select="substring ($date, 7, 2)"/>
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

         <xsl:if test="string-length($hh)&gt;1">
            <xsl:value-of select="$hh"/>
            <xsl:if test="string-length($mm)&gt;1 and not(contains($mm,'-')) and not (contains($mm,'+'))">
               <xsl:text>:</xsl:text>
               <xsl:value-of select="$mm"/>
             </xsl:if>
         </xsl:if>
      </xsl:if>
 
   </xsl:template>

<xsl:template name="formatAddress">
  <xsl:param name="addr" />
  	     <xsl:for-each select="$addr">
  	     <xsl:value-of select="normalize-space(.)" />
  	     <xsl:if test="contains(name(),'.1')">
  	       <xsl:text>,</xsl:text>
  	      </xsl:if>
  	     <xsl:if test="contains(name(),'.2')">
  	        <xsl:text> </xsl:text>
  	     </xsl:if>
  	     <xsl:if test="not(contains(name(),'.2'))">
  	       <br />
  	     </xsl:if>
  	  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
