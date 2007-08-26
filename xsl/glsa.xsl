<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="UTF-8" method="xml" indent="yes"/>

<xsl:template match="glsa">
<guide>
<title><xsl:value-of select="title"/></title>
<author title="Contact Address">
  <mail link="security@gentoo.org">security@gentoo.org</mail>
</author>
<abstract>
This is a Gentoo Linux Security Advisory
</abstract>

<xsl:if test="license">
  <license />
</xsl:if>

<version><xsl:value-of select="@id"/></version>
<date><xsl:value-of select="announced"/></date>

<chapter>
<title>Gentoo Linux Security Advisory</title>
<section>
<title>Version Information</title>
<body>

<table>
<tr>
  <th>Advisory Reference</th>
  <ti>GLSA <xsl:value-of select="@id"/> / <xsl:value-of select="product/text()"/></ti>
</tr>
<tr>
  <th>Release Date</th>
  <ti><xsl:value-of select="announced"/></ti>
</tr>
<tr>
  <th>Latest Revision</th>
  <ti><xsl:value-of select="revised"/></ti>
</tr>
<tr>
  <th>Impact</th>
  <ti><xsl:value-of select="impact/@type"/></ti>
</tr>
<tr>
  <th>Exploitable</th>
  <ti><xsl:value-of select="access"/></ti>
</tr>
</table>

<xsl:apply-templates select="affected">
  <xsl:with-param name="type" select="product/@type"/>
</xsl:apply-templates>

<p>
Related bugreports: 
<xsl:choose>
  <xsl:when test="bug">
  
<xsl:for-each select="bug">
  <uri link="http://bugs.gentoo.org/show_bug.cgi?id={text()}">#<xsl:value-of select="text()"/></uri>
  <xsl:if test="not(position() = last())">, </xsl:if>
</xsl:for-each>
  </xsl:when>
  <xsl:otherwise>
    No related gentoo bugreports
  </xsl:otherwise>
</xsl:choose>

</p>

</body>
</section>
<section>
<title>Synopsis</title>
<body>

<xsl:apply-templates select="synopsis"/>

</body>
</section>
</chapter>
<chapter>
<title>Impact Information</title>
<section>
<title>Background</title>
<body>

<xsl:apply-templates select="background"/>

</body>
</section>
<section>
<title>Description</title>
<body>

<xsl:apply-templates select="description"/>

</body>
</section>
<section>
<title>Impact</title>
<body>

<xsl:apply-templates select="impact"/>

</body>
</section>
</chapter>
<chapter>
<title>Resolution Information</title>
<section>
<title>Workaround</title>
<body>

<xsl:apply-templates select="workaround"/>

</body>
</section>
<section>
<title>Resolution</title>
<body>

<xsl:apply-templates select="resolution"/>

</body>
</section>
</chapter>
<xsl:if test="references/uri">
<chapter>
<title>References</title>
<section>
<body>

<ul>
<xsl:for-each select="references/uri">
  <xsl:choose>
    <xsl:when test="@link">
      <li><uri link="{@link}"><xsl:value-of select="text()"/></uri></li>
    </xsl:when>
    <xsl:otherwise>
      <li><uri link="{text()}"><xsl:value-of select="text()"/></uri></li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>
</ul>

</body>
</section>
</chapter>
</xsl:if>
</guide>
</xsl:template>

<xsl:template match="affected">
<xsl:param name="type"/>
<xsl:choose>
  <xsl:when test="$type = 'ebuild'">
    <table>
    <tr>
      <th>Package</th>
      <th>Vulnerable versions</th>
      <th>Unaffected versions</th>
      <th>Architecture(s)</th>
    </tr>
    <xsl:for-each select="package">
    <tr>
      <ti><xsl:value-of select="@name"/></ti>
      <ti>
        <xsl:for-each select="vulnerable">
          <xsl:choose>
            <xsl:when test="@range = 'le'">
              &lt;=
            </xsl:when>
            <xsl:when test="@range = 'lt'">
              &lt;
            </xsl:when>
            <xsl:when test="@range = 'eq'">
              =
            </xsl:when>
            <xsl:when test="@range = 'gt'">
              &gt;
            </xsl:when>
            <xsl:when test="@range = 'ge'">
              &gt;=
            </xsl:when>
            <xsl:when test="@range = 'rlt'">
              revision &lt;
            </xsl:when>
            <xsl:when test="@range = 'rle'">
              revision &lt;=
            </xsl:when>
            <xsl:when test="@range = 'rgt'">
              revision &gt;
            </xsl:when>
            <xsl:when test="@range = 'rge'">
              revision &gt;=
            </xsl:when>
          </xsl:choose>  
        <xsl:value-of select="text()"/>
        <xsl:if test="not(position() = last())">, </xsl:if>
        </xsl:for-each>
      </ti>
      <ti>
        <xsl:for-each select="unaffected">
          <xsl:choose>
            <xsl:when test="@range = 'le'">
              &lt;=
            </xsl:when>
            <xsl:when test="@range = 'lt'">
              &lt;
            </xsl:when>
            <xsl:when test="@range = 'eq'">
              =
            </xsl:when>
            <xsl:when test="@range = 'gt'">
              &gt;
            </xsl:when>
            <xsl:when test="@range = 'ge'">
              &gt;=
            </xsl:when>
          </xsl:choose>
        <xsl:if test="@name">
          <xsl:value-of select="@name"/>-
        </xsl:if>
        <xsl:value-of select="text()"/>
        <xsl:if test="not(position() = last())">, </xsl:if>
        </xsl:for-each>
        <xsl:if test="@auto = 'no'"><brite>*</brite></xsl:if>
      </ti>
      <ti>
        <xsl:choose>
          <xsl:when test="@arch = '*'">
            All supported architectures
          </xsl:when>
          <xsl:when test="@arch = 'x86'">
            Intel compatible
          </xsl:when>
          <xsl:when test="@arch = 'ppc'">
            PowerPC
          </xsl:when>
          <xsl:when test="@arch = 'sparc'">
            Sparc
          </xsl:when>
          <xsl:when test="@arch = 'hppa'">
            HP-PA
          </xsl:when>
          <xsl:when test="@arch = 'alpha'">
            Alpha
          </xsl:when>
          <xsl:when test="@arch = 'amd64'">
            AMD64
          </xsl:when>
          <xsl:when test="@arch = 'arm'">
            ARM
          </xsl:when>
          <xsl:when test="@arch = 'ia64'">
            ia64 
          </xsl:when>
          <xsl:when test="@arch = 'mips'">
            mips
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@arch"/>
          </xsl:otherwise>
        </xsl:choose>
      </ti>
    </tr>
    </xsl:for-each>
    </table>
 
  <xsl:if test="//affected/package/@auto = 'no'">
  <warn>
    <brite>*</brite>: Needs to be manually updated
  </warn>
  </xsl:if>
 
  </xsl:when>
  <xsl:when test="$type = 'infrastructure'">
    <table>
    <tr>
      <th>Affected Service</th>
      <th>Affected Server</th>
    </tr>
    <xsl:for-each select="service">
    <tr>
      <ti><xsl:value-of select="@type"/></ti>
      <ti><xsl:value-of select="text()"/>
        <xsl:if test="@fixed = 'yes'"> (fixed)</xsl:if>
      </ti>
    </tr>
    </xsl:for-each>
    </table>
  </xsl:when>
  <xsl:otherwise>

  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="p">
<p><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="code">
<pre>
<xsl:apply-templates select="text()"/>
</pre>
</xsl:template>

<xsl:template match="description">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="background">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="impact">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="resolution">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="ul">
<ul>
  <xsl:for-each select="li">
    <li><xsl:apply-templates/></li>
  </xsl:for-each>
</ul>
</xsl:template>

<xsl:template match="ol">
<ol>
  <xsl:for-each select="li">
    <li><xsl:apply-templates/></li>
  </xsl:for-each>
</ol>
</xsl:template>

<xsl:template match="b">
<b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="u">
<u><xsl:apply-templates/></u>
</xsl:template>

<xsl:template match="i">
<span class="input"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="br">
<br/>
</xsl:template>

<xsl:template match="metadata">
</xsl:template>

</xsl:stylesheet>
