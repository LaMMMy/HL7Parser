<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml ORU-R01.xml?>
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
    <table border="1px" width="100%">
       <tbody>
          <tr>
	        <th colspan="20">Message Header:</th>
          </tr>
	      <xsl:apply-templates select="MSH"/>
       </tbody>
    </table>
	<table border="1px"  width="100%">
     <tbody>
      <tr><th colspan="20">Patient Information:</th></tr>
  	  <xsl:apply-templates select="//PID"/>
	  <xsl:apply-templates select="//PD1"/>
	  <xsl:apply-templates select="//NK1"/>
      <xsl:apply-templates select="//PV1"/>
      <xsl:apply-templates select="//AL1"/>
      <xsl:apply-templates select="//IN1"/>
     </tbody>
    </table>
	  
	<xsl:apply-templates select="//ORC"/>
	<xsl:apply-templates select="//ZDR"/>
	<xsl:apply-templates select="//OBR"/>
	
	<xsl:if test="//NTE" >
       <table width="100%" border="1px">
	   <tbody>
		   <tr>
			  <th>Notes:</th>
  		   </tr>
  		   
	<xsl:apply-templates select="//NTE"/>
	
    	</tbody>
      </table>
	</xsl:if>
	
	<xsl:apply-templates select="//OBX[./OBX.2 != 'TX'][./OBX.3]" mode="labmode" />
	<pre><xsl:text>
      </xsl:text>
	<xsl:apply-templates select="//OBX[not(./OBX.3)]|//OBX[./OBX.2 = 'TX']" mode="reportmode" />
<xsl:text>
</xsl:text>
    </pre>
<xsl:text>
</xsl:text>

</xsl:template>

<xsl:template match="MSH">
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
    <td><xsl:value-of select="MSH.3/*"/></td>
    <td>
         <xsl:value-of select="MSH.4"/>
    </td>
    <td>
      <xsl:call-template name="formatDateTime">
        <xsl:with-param name="date" select="MSH.7/*"/>
      </xsl:call-template>
    </td>
    <td><xsl:value-of select="MSH.10"/></td>
    <td>
      <xsl:value-of select="MSH.9/*[1]"/>-<xsl:value-of select="MSH.9/*[2]"/>
    </td>
    <td>
      HL7 v<xsl:value-of select="MSH.12"/>
    </td>
    <xsl:if test="//EVN/EVN.2">
     <td>
		<xsl:call-template name="formatDateTime">
        <xsl:with-param name="date" select="//EVN/EVN.2/*"/>
      </xsl:call-template>
     </td>
    </xsl:if>
    <xsl:if test="//EVN/EVN.5/*">
    <td>
    <xsl:value-of select="//EVN/EVN.5/*"/>
    </td>
    </xsl:if>
  </tr>
</xsl:template>
 
<xsl:template match="//PID">
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
   	  <td><xsl:value-of select="PID.18/*" /></td>
	  <xsl:if test="PID.2/*|PID.3/*">
	    <td>
	      <xsl:for-each select="PID.3/*">
	         <xsl:value-of select="." /><br />
	      </xsl:for-each>
	     <xsl:value-of select="PID.2/*" />
	     </td>
      </xsl:if>   	  
	   <xsl:if test="PID.4/*|PID.19">
    	  <td>
    	  <xsl:value-of select="PID.19" />
          <xsl:if test="PID.4/*[text()] != PID.19[text()]">
 	         <br /><xsl:value-of select="PID.4/*" />
  	       </xsl:if>      
          </td>
      </xsl:if>
  	  <td><xsl:value-of select="PID.8" /></td>
  	  <td>
  	  <xsl:for-each select="PID.5/*">
  	     <xsl:if test="contains(name(),'.1')">
  	       <b><xsl:value-of select="." />,</b><br />
  	      </xsl:if>
  	      <xsl:if test="not(contains(name(),'.1'))">
  	      <xsl:value-of select="." />
  	      <xsl:text> </xsl:text>
  	      </xsl:if>
  	  </xsl:for-each>
  	  </td>
  	  <td>
      <xsl:call-template name="formatDateTime">
        <xsl:with-param name="date" select="PID.7/*"/>
      </xsl:call-template>
	  </td>
  	  <td>
        <xsl:call-template name="formatAddress">
        <xsl:with-param name="addr" select="PID.11/*"/>
        </xsl:call-template>
  	  </td>
  	  <td><xsl:value-of select="PID.13/*" /></td>
   </tr>
</xsl:template>

<xsl:template match="//PD1">
</xsl:template>

<xsl:template match="//NK1">
	<tr>
	  <td colspan="2"><xsl:text> </xsl:text></td>
  	   <td><b>Next of Kin</b></td>
  	   <td><b>Relationship:</b><br/>
  	   <xsl:choose>
			<xsl:when test="NK1.3/*[contains(name(),'.2')]">
			  <xsl:value-of select="NK1.3/*[contains(name(),'.2')]" />
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="NK1.3/*[contains(name(),'.1')]" />
			</xsl:otherwise>
		</xsl:choose>
  	   
  	   <xsl:value-of select="NK1.3/*[contains(name(),'.2')]" />
  	   </td>
  	   <td>
    	  <xsl:for-each select="NK1.2/*">
  	     <xsl:if test="contains(name(),'.1')">
  	       <b><xsl:value-of select="." />,</b><br />
  	      </xsl:if>
  	      <xsl:if test="not(contains(name(),'.1'))">
  	      <xsl:value-of select="." />
  	      <xsl:text> </xsl:text>
  	      </xsl:if>
  	  </xsl:for-each>
  	  </td>
  	   <xsl:if test="NK1.7">
  	   <td><b>Contact Role:</b><br/>
  	   <xsl:value-of select="NK1.7" />
  	   </td>
  	   </xsl:if>
   	   <td>
  	   <b>Address:</b><br/>
        <xsl:call-template name="formatAddress">
        <xsl:with-param name="addr" select="NK1.4/*"/>
        </xsl:call-template>  	   
  	   </td>
  	   <xsl:if test="NK1.5">
  	   <td><b>Phone:</b><br/>
  	   <xsl:value-of select="NK1.5" />
  	   </td>
  	   </xsl:if>
  	   <xsl:if test="NK1.6">
  	   <td><b>Work Phone:</b><br/>
  	   <xsl:value-of select="NK1.6" />
  	   </td>
  	   </xsl:if>
	</tr>
</xsl:template>

<xsl:template match="//PV1">
   <tr>
	<th colspan="20">Visit Information:</th>
   </tr>
   <tr>
   <xsl:if test="//PV2.3/*">
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
           <td><xsl:value-of select="//PV2.3/*" /></td>
      </xsl:if>
       <xsl:if test="PV1.44/*">
     	  <td>
             <xsl:call-template name="formatDateTime">
             <xsl:with-param name="date" select="PV1.44/*"/>
             </xsl:call-template>
     	  </td>
      </xsl:if>
       <xsl:if test="PV1.45/*">
     	  <td>
             <xsl:call-template name="formatDateTime">
             <xsl:with-param name="date" select="PV1.45/*"/>
             </xsl:call-template>
     	  </td>
      </xsl:if>
		<td>
		  <xsl:for-each select="PV1.3/*">
     	     <xsl:value-of select="." />
   		     <br />
		  </xsl:for-each>
		  <xsl:value-of select="PV1.39" />
		</td>
        <xsl:if test="PV1.4">
         <td><xsl:value-of select="PV1.4" /></td>
        </xsl:if>
   
		<td>
		  <xsl:value-of select="PV1.41" />
		  <xsl:text> </xsl:text>
		  <xsl:value-of select="PV1.18" />
		  <xsl:text> </xsl:text>
		  <xsl:value-of select="PV1.2" />
		  <br />
		  <xsl:value-of select="PV1.10" />
		</td>
  	    <xsl:if test="PV1.7/*">
		<td>
           <xsl:call-template name="formatDoctor">
             <xsl:with-param name="docField" select="PV1.7/*"/>
           </xsl:call-template>
		</td>
		</xsl:if>
        <xsl:if test="PV1.9/*">
		<td>
          <xsl:call-template name="formatDoctor">
             <xsl:with-param name="docField" select="PV1.9/*"/>
           </xsl:call-template>
		</td>
		</xsl:if>
        <xsl:if test="PV1.17/*">
		<td>
          <xsl:call-template name="formatDoctor">
             <xsl:with-param name="docField" select="PV1.17/*"/>
           </xsl:call-template>
		</td>
		</xsl:if>
        <xsl:if test="PV1.52/*">
		<td>
          <xsl:call-template name="formatDoctor">
             <xsl:with-param name="docField" select="PV1.52/*"/>
           </xsl:call-template>
		</td>
  	    </xsl:if>
    </tr>
</xsl:template>

<xsl:template match="//AL1">
<tr>
	<th>Allergy Type</th>
	<th>Allergy Info</th>
	<xsl:if test="AL1.4">
	  <th>Severity</th>
	</xsl:if>
</tr>
<tr>
	<td><xsl:value-of select="AL1.2"/></td>
	<td>
	<table width="100%" border="1px"><tr>
	<xsl:for-each select="AL1.3/*">
	  <td><xsl:value-of select="."/></td>
	</xsl:for-each>
	</tr></table>
	</td>
	<xsl:if test="AL1.4">
	  <td><xsl:value-of select="AL1.4"/></td>
	</xsl:if>

</tr>
</xsl:template>

<xsl:template match="//IN1">
</xsl:template>

<xsl:template match="//ORC">
<table border="1px" width="100%">
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
			<td>
			  <xsl:call-template name="formatDateTime">
                 <xsl:with-param name="date" select="ORC.9/*"/>
              </xsl:call-template>
			</td>
			<td>
			   <xsl:value-of select="ORC.2/*" />
			</td>
			<td>
			   <xsl:value-of select="ORC.5" />
			   <xsl:text> </xsl:text>
			   <xsl:value-of select="ORC.6" />
			</td>
			<td>
             <xsl:call-template name="formatDoctor">
              <xsl:with-param name="docField" select="ORC.10/*"/>
             </xsl:call-template>
			</td>
			<xsl:if test="ORC.13/*">
  			    <td><xsl:value-of select="ORC.13/*" /></td>
			</xsl:if>
			<xsl:if test="ORC.12/*">
			  <td>
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
<table border="1px" width="100%">
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
		<tr>
    		<td><xsl:value-of select="NTE.3"/></td>
		</tr>
</xsl:template>

<xsl:template match="//OBR">
<table width="100%" border="1px">
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
		   <td>
			  <xsl:call-template name="formatDateTime">
                 <xsl:with-param name="date" select="OBR.22/*"/>
              </xsl:call-template>
            </td>
           </xsl:if>

		<!-- Other Test Results -->
  		   <xsl:if test="OBR.4/*[contains(name(),'.2')] != 'Discharge Summary'">
			<td>
			<xsl:value-of select="OBR.3/*" />
			</td>
			<td>
			<xsl:value-of select="OBR.24" />
			</td>		
			<td>
			<table width="100%" border="1px">
					<tr>
						<td>
                           <b>Test ID:</b><br />	        
	                        <xsl:value-of select="OBR.4/*[contains(name(),'.1')]"/><br />
	                        <xsl:value-of select="OBR.4/*[contains(name(),'.4')]"/>
						</td>
						<td>
                           <b>Test Name:</b><br />	        
	                        <xsl:value-of select="OBR.4/*[contains(name(),'.2')]"/><br />
	                        <xsl:value-of select="OBR.4/*[contains(name(),'.5')]"/>
						</td>
					</tr>
			</table>
			</td>
			<td>
			  <xsl:call-template name="formatDateTime">
                 <xsl:with-param name="date" select="OBR.7/*"/>
              </xsl:call-template>
			</td>
			<td>
			  <xsl:call-template name="formatDateTime">
                 <xsl:with-param name="date" select="OBR.22/*"/>
              </xsl:call-template>
			</td>
			<td>
			<xsl:value-of select="OBR.25" />
			</td>
			</xsl:if>

		<!-- Common fields -->
			<xsl:for-each select="OBR.28">
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

<!-- Lab test results -->
<xsl:template match="//OBX[./OBX.2 != 'TX'][./OBX.3]" mode="labmode">
      <table width="100%" border="1px">
      	<tbody>
      	   <tr>
			 <th colspan="20">Test Results:</th>
		   </tr>
           <tr>
	        <td>
             <b>Test ID:</b><br />	        
	         <xsl:value-of select="OBX.3/*[contains(name(),'.1')]"/><br />
	         <xsl:value-of select="OBX.3/*[contains(name(),'.4')]"/>
            </td>
	        <td>
	         <b>Test Name:</b><br />
	        <xsl:value-of select="OBX.3/*[contains(name(),'.2')]"/><br />
	        <xsl:value-of select="OBX.3/*[contains(name(),'.5')]"/>
            </td>
           <xsl:if test="OBX.6">
           <td>
           <b>Units:</b><br />           
           <xsl:value-of select="OBX.6"/>
           </td>
           </xsl:if>
           <td>
           <b>Results:</b><br />
           <xsl:if test="OBX.5">
              <xsl:value-of select="OBX.5"/><br />
           </xsl:if>
           <xsl:if test="OBX.7">
              <xsl:value-of select="OBX.7"/><br />
           </xsl:if>
           <xsl:if test="OBX.8">
              Abnormal: <xsl:value-of select="OBX.8"/>
           </xsl:if>
           </td>
           <xsl:if test="OBX.11">
           <td>
             <b>Status:</b><br />
             <xsl:value-of select="OBX.11"/>
           </td>
           </xsl:if>
           </tr>
       	</tbody>
      </table>
</xsl:template>

<!-- Reports -->
<xsl:template match="//OBX[not(./OBX.3)]|//OBX[./OBX.2 = 'TX']" mode="reportmode">

      <xsl:value-of select="OBX.5"/><xsl:text>
      </xsl:text>
      
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

<xsl:template name="formatAddress">
  <xsl:param name="addr" />
    	     <xsl:for-each select="$addr">
  	     <xsl:value-of select="." />
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
