<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="util.xsl"/>
<xsl:output encoding="UTF-8" method="xml" indent="yes"/>
<!--xsl:param name="search" select='""'/-->
<xsl:template match="/packages">
  <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="/xsl/guide.xsl"</xsl:processing-instruction>
  <mainpage id="packages">
    <title>Gentoo Linux Packages</title>
    <version>Current</version>
    <date><xsl:value-of select="date"/></date>
    <chapter>
      <section>
<!--        <xsl:choose>
          <xsl:when test='$search=""'>-->
            <title>Gentoo Package List - index</title>
            <body>
              <p>Total number of packages available:
                <xsl:value-of select="count(category/package)"/>,
                number of categories: <xsl:value-of select="count(category)"/>
              </p>
              <table>
                <tr><th>category</th></tr>
                <xsl:for-each select="category">
                  <xsl:sort select="name"/>
                  <xsl:if test="position() mod 3=1">
                    <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
                  </xsl:if>
                  <ti>
                    <uri>
                      <xsl:attribute name="link"><xsl:value-of select="name"/></xsl:attribute>
                      <xsl:value-of select="name"/>
                    </uri>
                    (<xsl:value-of select="count(package)"/>)
                  </ti>
                  <xsl:if test="(position() mod 3=0) and not(position()=last())">
                    <xsl:text disable-output-escaping="yes">&lt;/tr&gt;<![CDATA[
]]></xsl:text>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
              </table>
            </body>
<!--          </xsl:when>
          <xsl:otherwise>
            <title>Gentoo Package List - search (<xsl:value-of select="$search"/>)</title>
            <body>
	      <table>
                <xsl:for-each select='category/package[contains(translate(name,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVW"),translate($search,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVW"))]|category/package[contains(translate(description,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVW"),translate($search,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVW"))]'>
		  <xsl:sort select='not(contains(translate(name,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVW"),translate($search,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVW")))'/>
		  <xsl:sort select="../category"/>
		  <xsl:sort select="name"/>
                  <tr>
                    <ti><xsl:value-of select="position()"/>.</ti>
                    <ti>
		      <uri>
		        <xsl:attribute name="link"><xsl:value-of select="../name"/>/<xsl:value-of select="name"/>.xml</xsl:attribute>
                        <xsl:value-of select="../name"/>/<xsl:value-of select="name"/>
                      </uri>
                    </ti>
                    <ti>
                      <xsl:value-of select="description"/>
                    </ti>
		  </tr>
		</xsl:for-each>
	      </table>
	    </body>
          </xsl:otherwise>
        </xsl:choose>-->
      </section>
    </chapter>
  </mainpage>
</xsl:template>
<xsl:template match="/category">
  <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="/xsl/guide.xsl"</xsl:processing-instruction>
  <xsl:variable name="category"><xsl:value-of select="text()"/></xsl:variable>
  <mainpage id="packages">
    <title>Gentoo Linux Packages</title>
    <version>Current</version>
    <date><xsl:value-of select="date"/></date>
    <chapter>
      <section>
        <title>Package Category <xsl:value-of select="text()"/></title>
        <body>
          <xsl:for-each select='document("/dyn/pkgs/index.xml")/packages/category[name=$category]'>
            <p>Number of packages in category:
              <xsl:value-of select="count(package)"/></p>
            <table>
              <tr><th>package</th><th>description</th></tr>
              <xsl:for-each select="package">
                <xsl:sort select="name"/>
                <tr>
                  <ti>
                    <uri>
                      <xsl:attribute name="link"><xsl:value-of select="name"/>.xml</xsl:attribute>      
                      <xsl:value-of select="name"/>
                    </uri>
                  </ti>
                  <ti>
                    <xsl:value-of select="description"/>
                  </ti>
                </tr>
              </xsl:for-each>
            </table>
          </xsl:for-each>
        </body>
      </section>
    </chapter>
  </mainpage>    
</xsl:template>
<xsl:template match="/package">
  <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="/xsl/guide.xsl"</xsl:processing-instruction>
  <xsl:variable name="name"><xsl:value-of select="category"/>/<xsl:value-of select="name"/></xsl:variable>
  <mainpage id="packages">
    <title>Gentoo Linux Packages</title>
    <version>Current</version>
    <date><xsl:value-of select="date"/></date>
    <chapter>
      <section>
        <title><xsl:value-of select="category"/>/<xsl:value-of select="name"/></title>
        <body>
          <table>
            <tr>
              <th>Package name</th>
              <ti><xsl:value-of select="name"/></ti>
            </tr>
            <tr>
              <th>Package version</th>
              <ti><xsl:value-of select="version"/></ti>
            </tr>
            <xsl:if test="homepage">
              <tr>
                <th>Package homepage</th>
                <ti><uri>
                  <xsl:attribute name="link"><xsl:value-of select="homepage"/></xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="string-length(homepage)>80">
                      <xsl:value-of select="substring(homepage,1,77)"/>...
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="homepage"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </uri></ti>
              </tr>
            </xsl:if>
            <tr>
              <th>Package dependencies</th>
              <ti><xsl:value-of select="depend"/></ti>
            </tr>
            <tr>
              <th>Run-time dependencies</th>
              <ti><xsl:value-of select="rdepend"/></ti>
            </tr>
            <xsl:if test="license">
              <tr>
                <th>Licensed under</th>
                <ti><xsl:value-of select="license"/></ti>
              </tr>
            </xsl:if>
            <xsl:if test="keywords">
              <tr>
                <th>Keywords</th>
                <ti><xsl:value-of select="keywords"/></ti>
              </tr>
            </xsl:if>
            <xsl:if test="description">
              <tr>
                <th>Package Description</th>
                <ti><xsl:value-of select="description"/></ti>
              </tr>
            </xsl:if>
            <xsl:for-each select='document("/proj/en/metastructure/herds/pkgList.xml")/packages/pkgmetadata[@pkgname=$name]'>
              <xsl:if test="longdescription">
                <tr>
                  <th>Long Description</th>
                  <ti>
                    <xsl:value-of select="longdescription"/>
                  </ti>
                </tr>
              </xsl:if>
              <tr>
                <th>maintained by</th>
                <ti>
                  <xsl:choose>
                    <xsl:when test="maintainer">
                      <xsl:value-of select='substring-before(maintainer[1]/email,"@gentoo.org")'/>
                      <xsl:text> </xsl:text>
                      <xsl:call-template name="fullname">
                        <xsl:with-param name="nick" select='substring-before(maintainer[1]/email,"@gentoo.org")'/>
                        <xsl:with-param name="parent" select='"true"'/>
                      </xsl:call-template>
                      <xsl:if test="maintainer/description">
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="maintainer/description"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <brite>herd maintained</brite>
                    </xsl:otherwise>
                  </xsl:choose>
                </ti>
              </tr>
              <tr>
                <th>Herd</th>
                <ti>
                  <xsl:choose>
                    <xsl:when test='herd and herd/text()!="no-herd"'>
                      <uri>
                        <xsl:attribute name="link">/proj/en/metastructure/herds/herds.xml?select=<xsl:value-of select="herd/text()"/></xsl:attribute>
                        <xsl:value-of select="herd/text()"/>
                      </uri>
                    </xsl:when>
                    <xsl:otherwise>
                      <brite>* NO HERD SPECIFIED *</brite>
                    </xsl:otherwise>
                  </xsl:choose>
                </ti>
              </tr>
        
            </xsl:for-each>
            <tr>
              <th>View CVS Repository</th>
              <ti>
                <uri link="http://www.gentoo.org/cgi-bin/viewcvs.cgi/{$name}/">
                  http://www.gentoo.org/cgi-bin/viewcvs.cgi/<xsl:value-of select="$name"/>/
                </uri>
              </ti>
            </tr>
          </table>
        </body>
      </section>
    </chapter>
  </mainpage>    
</xsl:template>


</xsl:stylesheet>
<!-- Keep this comment at the end of the file
Local variables:
mode: xml
sgml-indent-step:2
sgml-set-face:1
End:
-->
