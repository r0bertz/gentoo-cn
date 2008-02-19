<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exslt="http://exslt.org/common"
                xmlns:func="http://exslt.org/functions"
                extension-element-prefixes="exslt func">

<xsl:output encoding="UTF-8" method="xml" indent="yes" cdata-section-elements="description"/>

<xsl:include href="inserts.xsl"/>
<xsl:include href="util.xsl"/>
<xsl:include href="mail.xsl"/>

<!-- Load index.xml -->
<xsl:variable name="gmn" select="document('index.xml',.)"/>

<!-- Used in mail.xsl, can only be on www -->
<xsl:variable name="httphost">www</xsl:variable>

<!-- Define root dir of GMNs as /news/[@LANG]/gmn/ -->
<xsl:variable name="root" select="concat('/news/', $gmn/*[1]/@lang, '/gmn/')"/>
<xsl:variable name="site" select="'http://www.gentoo.org'"/>

<xsl:template match="/gmnfeed">
<rss version="2.0">
  <channel>
    <title><xsl:value-of select="$gmn/*[1]/title"/></title>
    <link><xsl:value-of select="concat($site, $root)"/></link>
    <description><xsl:value-of select="$gmn/*[1]/abstract"/></description>
    <language><xsl:value-of select="translate($gmn/*[1]/@lang, '_', '-')"/></language>
    <managingEditor>gmn-feedback@gentoo.org (GMN Editors)</managingEditor>
    <webMaster>neysx@gentoo.org (Xavier Neys)</webMaster>
    <pubDate><xsl:value-of select="func:format-date(func:today(),'RFC822')"/></pubDate>
    <ttl>1440</ttl>

    <xsl:choose>
      <xsl:when test="$gmn//tr[@id='feed-items']">
        <xsl:for-each select="$gmn//tr[@id='feed-items']/following-sibling::tr[position()&lt;9]">
          <xsl:call-template name="feed-item">
            <xsl:with-param name="tr" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$gmn/*[1]/chapter[2]//table[1]/tr[position()&gt;1 and position()&lt;10]">
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
  <xsl:variable name="fname">
    <xsl:call-template name="filename">
      <xsl:with-param name="path" select="$tr/ti[1]/uri[1]/@link"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="a-gmn" select="document(concat($root,$fname))"/>
  <xsl:if test="not($a-gmn/missing)">
    <item>
      <title><xsl:value-of select="concat($a-gmn/guide/title, ' &#x2014; ', $a-gmn/guide/subtitle)"/></title> 
      <link><xsl:value-of select="concat($site,$root,$fname)"/></link>
      <description><xsl:value-of select="$tr/ti[2]"/></description>
      <author>
        <xsl:choose>
          <!-- Use the first author element -->
          <xsl:when test="$a-gmn/guide/author[1]/mail">
            <xsl:variable name="mail">
              <xsl:call-template name="smart-mail">
               <xsl:with-param name="mail" select="$a-gmn/guide/author[1]/mail"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:value-of select="concat(exslt:node-set($mail)/mail/@link, ' (', exslt:node-set($mail)/mail/text(), ')')"/>
          </xsl:when>
          <xsl:when test="$a-gmn/guide/author[1]">
            <xsl:value-of select="$a-gmn/guide/author[1]"/>
          </xsl:when>
          <xsl:otherwise>gmn-feedback@gentoo.org (GMN Editors)</xsl:otherwise>
        </xsl:choose>
      </author>
      <guid isPermaLink="true"><xsl:value-of select="concat($site,$root,$fname)"/></guid>
      <pubDate><xsl:value-of select="func:format-date($a-gmn/*[1]/date,'RFC822')"/></pubDate>
    </item>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
