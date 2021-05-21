<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <style type="text/css">
     .res, .resp, .resf, .resi, .resn, .resnum, .resc3 { 
       border: 1px solid black; 
       padding-left:10px;
       padding-right:10px
     }
     .resp, .resf, .resi, .resn 
     { 
       text-transform:uppercase;
       text-align:center;
     }
     .resp, .pass { color:green; }
     .resf, .fail { color:red; }
     .resi, .inconc { color:sienna; }
     .resnum { text-align: right;}
     .resc3 { width: 600px;}
  </style>
  <body>
    <h2>TestCast Test Session Report</h2>
    <xsl:variable name="passed" select="count(session_report/campaigns/campaign/test_cases/test_case[verdict='pass'])" />
    <xsl:variable name="failed" select="count(session_report/campaigns/campaign/test_cases/test_case[verdict='fail'])" />
    <xsl:variable name="inconc" select="count(session_report/campaigns/campaign/test_cases/test_case[verdict='inconc'])" />
    <xsl:variable name="none" select="count(session_report/campaigns/campaign/test_cases/test_case[verdict='none'])" />
    <xsl:variable name="errors" select="count(session_report/campaigns/campaign/test_cases/test_case[verdict='error'])" />
    <table>
      <tr>
        <td style="width:250px"><b>Test suite name:</b></td>
        <td><xsl:value-of select="session_report/project" /></td>
      </tr>
      <tr>
        <td><b>Test session start:</b></td>
        <td><xsl:value-of select="session_report/start_time" /></td>
      </tr>
      <tr>
        <td><b>Test session end:</b></td>
        <td><xsl:value-of select="session_report/end_time" /></td>
      </tr>
      <tr>
        <td><b>Execution time:</b></td>
        <td><xsl:value-of select="session_report/duration" /></td>
      </tr>
      <tr>
        <td><b>Test session result:</b></td>
         <xsl:choose>
           <xsl:when test="$failed &gt; 0 or $errors &gt; 0">
             <td class="fail"><b><xsl:text>FAILED</xsl:text></b></td>
           </xsl:when>
           <xsl:when test="$inconc &gt; 0 or $none &gt; 0">
             <td class="inconc"><b><xsl:text>INCONCLUSIVE</xsl:text></b></td>
           </xsl:when>
           <xsl:otherwise>
             <td class="pass"><b><xsl:text>PASSED</xsl:text></b></td>
           </xsl:otherwise>
         </xsl:choose>
      </tr>
    </table>
    <br />
    <table>
      <tr>
        <td style="width:250px"><b>Executed test cases:</b></td>
        <td><xsl:value-of select="count(session_report/campaigns/campaign/test_cases/test_case)" /></td>
      </tr>      
      <tr>
        <td><b>Passed test cases:</b></td>        
        <xsl:choose>
          <xsl:when test="$passed &gt; 0"><td class="pass"><b><xsl:copy-of select="$passed" /></b></td></xsl:when>
          <xsl:otherwise><td>0</td></xsl:otherwise>
        </xsl:choose>
      </tr>
      <tr>
        <td><b>Failed test cases:</b></td>        
        <xsl:choose>
          <xsl:when test="$failed &gt; 0"><td class="fail"><b><xsl:copy-of select="$failed" /></b></td></xsl:when>
          <xsl:otherwise><td>0</td></xsl:otherwise>
        </xsl:choose>
      </tr>
      <xsl:if test="$none &gt; 0">
        <tr>
          <td><b>Test cases without verdict:</b></td>
          <td><xsl:copy-of select="$none" /></td>
        </tr>
      </xsl:if>
      <xsl:if test="$inconc &gt; 0">
        <tr>
          <td class="inconc"><b>Inconclusive test cases:</b></td>
          <td><xsl:copy-of select="$inconc" /></td>
        </tr>
      </xsl:if>
      <xsl:if test="$errors &gt; 0">
        <tr>
          <td><b>Erroneous test cases:</b></td>
          <td class="fail"><b><xsl:copy-of select="$errors" /></b></td>
        </tr>
      </xsl:if>
    </table>
    <xsl:for-each select="session_report/campaigns/campaign">
      <br />
      <table>
        <tr>
          <td style="width:250px"><b>Campaign:</b></td>
          <xsl:choose>
            <xsl:when test="name">
              <td><xsl:value-of select="name" /></td>
            </xsl:when>
            <xsl:otherwise><td>-</td></xsl:otherwise>
          </xsl:choose>
        </tr>
        <xsl:for-each select="ts/item">
          <tr>
            <xsl:choose>
              <xsl:when test="position()=1"><td><b>Test case selection:</b></td></xsl:when>
              <xsl:otherwise><td /></xsl:otherwise>
            </xsl:choose>
            <td><xsl:value-of select="." /></td>
          </tr>
        </xsl:for-each>
        <xsl:for-each select="modpar/item">
          <tr>
            <xsl:choose>
              <xsl:when test="position()=1"><td><b>Module parameters:</b></td></xsl:when>
              <xsl:otherwise><td /></xsl:otherwise>
            </xsl:choose>
            <td><xsl:value-of select="." /></td>
          </tr>
        </xsl:for-each>
      </table>
      <br />
      <table style="border-collapse:collapse;width:800px">
        <tr>
          <th class="res">Nr</th>
          <th class="res">Result</th>
          <th class="res">Name</th>
          <th class="resc3">Details</th>
        </tr>
        <xsl:for-each select="test_cases/test_case">
        <tr>
          <td class="resnum"><xsl:number value="position()" /></td>
          <xsl:choose>        
            <xsl:when test="verdict='pass'">
              <td class="resp">
                <xsl:value-of select="verdict"/>
              </td>
            </xsl:when>
            <xsl:when test="verdict='fail' or verdict='error'">
              <td class="resf">
                <xsl:value-of select="verdict"/>
              </td>
            </xsl:when>
            <xsl:when test="verdict='inconc'">
              <td class="resi">
                <xsl:value-of select="verdict"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td class="resn">      
                <xsl:value-of select="verdict"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
          <td class="res"><xsl:value-of select="name"/></td>
          <td class="res">
            <xsl:if test="details">
              <xsl:text>Component: </xsl:text>
              <xsl:value-of select="details/comp" />
              <xsl:text>, script: </xsl:text>
              <xsl:value-of select="details/file" />
              <xsl:text>, line: </xsl:text>
              <xsl:value-of select="details/line" />
              <xsl:if test="details/reason">
                <xsl:text>, reason: </xsl:text>
                <xsl:value-of select="details/reason" />
              </xsl:if>
            </xsl:if>
          </td>
        </tr>
        </xsl:for-each>
      </table>
    </xsl:for-each>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>