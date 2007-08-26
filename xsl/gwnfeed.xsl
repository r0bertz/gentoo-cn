<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:func="http://exslt.org/functions"
                extension-element-prefixes="func">

<xsl:output encoding="UTF-8" method="xml" indent="yes" cdata-section-elements="description"/>

<xsl:include href="inserts.xsl"/>
<xsl:include href="util.xsl"/>

<!-- Load gwn.xml -->
<xsl:variable name="gwn" select="document('gwn.xml',.)"/>

<!-- Define root dir of GWNs as /news/[@LANG]/gwn/ -->
<xsl:variable name="root" select="concat('/news/', $gwn/*[1]/@lang, '/gwn/')"/>
<xsl:variable name="site" select="'http://www.gentoo.org'"/>

<xsl:template match="/gwnfeed">
<rss version="2.0">
  <channel>
    <title><xsl:value-of select="$gwn/*[1]/title"/></title>
    <link><xsl:value-of select="concat($site, $root, 'gwn.xml')"/></link>
    <description><xsl:value-of select="$gwn/*[1]/abstract"/></description>
    <language><xsl:value-of select="translate($gwn/*[1]/@lang, '_', '-')"/></language>
    <managingEditor>gwn-feedback@gentoo.org (GWN Editors)</managingEditor>
    <webMaster>neysx@gentoo.org (Xavier Neys)</webMaster>
    <pubDate><xsl:value-of select="func:format-date(func:today(),'RFC822')"/></pubDate>
    <ttl>1440</ttl>

    <xsl:choose>
      <xsl:when test="$gwn//tr[@id='feed-items']">
        <xsl:for-each select="$gwn//tr[@id='feed-items']/following-sibling::tr[position()&lt;9]">
          <xsl:call-template name="feed-item">
            <xsl:with-param name="tr" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$gwn/*[1]/chapter[2]//table[1]/tr[position()&gt;1 and position()&lt;10]">
          <xsl:call-template name="feed-item">
            <xsl:with-param name="tr" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

  </channel>
</rss>
</xsl:template>

<!-- Emit a feed item -->
<xsl:template name="feed-item">
<xsl:param name="tr"/>
  <item>
    <xsl:variable name="fname">
      <xsl:call-template name="filename">
        <xsl:with-param name="path" select="$tr/ti[1]/uri[1]/@link"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="a-gwn" select="document(concat($root,$fname))"/>
    
    <title><xsl:value-of select="concat($a-gwn/guide/title, ' &#x2014; ', $a-gwn/guide/subtitle)"/></title> 
    <link><xsl:value-of select="concat($site,$root,$fname)"/></link>
    <description><xsl:value-of select="$tr/ti[2]"/></description>
    <author>
      <xsl:choose>
        <!-- Use the first author element -->
        <xsl:when test="$a-gwn/guide/author[1]/mail">
          <xsl:value-of select="concat($a-gwn/guide/author[1]/mail/@link, ' (', $a-gwn/guide/author[1]/mail, ')')"/>
        </xsl:when>
        <xsl:when test="$a-gwn/guide/author[1]">
          <xsl:value-of select="$a-gwn/guide/author[1]"/>
        </xsl:when>
        <xsl:otherwise>gwn-feedback@gentoo.org (GWN Editors)</xsl:otherwise>
      </xsl:choose>
    </author>
    <guid isPermaLink="true"><xsl:value-of select="concat($site,$root,$fname)"/></guid>
    <pubDate><xsl:value-of select="func:format-date($a-gwn/*[1]/date,'RFC822')"/></pubDate>
  </item>
</xsl:template>

</xsl:stylesheet>
