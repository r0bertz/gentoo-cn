<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:dyn="http://exslt.org/dynamic"
                xmlns:func="http://exslt.org/functions"
                extension-element-prefixes="func dyn">

<!-- Define global variables; if a user has
     already defined those, this is a NOP -->
<xsl:param name="part">0</xsl:param>
<xsl:param name="chap">0</xsl:param>
<xsl:param name="full">0</xsl:param>

<!-- A book -->
<xsl:template match="/book">
  <!-- If chap = 0, show an index -->
  <xsl:choose>
    <xsl:when test="$part != 0">
      <xsl:apply-templates select="part" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="doclayout"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- <sections>, i.e. when user tries to access a book file directly -->
<xsl:template match="/sections">
  <xsl:call-template name="doclayout"/>
</xsl:template>

<!-- Content of /book -->
<xsl:template name="bookcontent">
  <xsl:call-template name="menubar" />
  <h1><xsl:value-of select="title" /></h1>
  <xsl:if test="$style = 'printable'">
    <xsl:apply-templates select="author" />
    <br/>
    <i><xsl:call-template name="contentdate"/></i>
    <xsl:variable name="outdated">
      <xsl:call-template name="outdated-translation"/>
    </xsl:variable>
    <xsl:if test="string-length($outdated) &gt; 1">
      <br/><i><xsl:copy-of select="$outdated"/></i>
    </xsl:if>
  </xsl:if>
  <p><xsl:value-of select="func:gettext('Content')"/>:</p>
  <ul>
    <xsl:for-each select="part">
      <xsl:variable name="curpart" select="position()" />
      <li>
        <xsl:choose>
          <xsl:when test="$full = 0">
            <xsl:choose>
              <xsl:when test="$style != 'printable'">
                <b><a href="?part={$curpart}"><xsl:value-of select="title" /></a></b>
              </xsl:when>
              <xsl:otherwise>
                <b><a href="?part={$curpart}&amp;style=printable"><xsl:value-of select="title" /></a></b>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <b><a href="#book_part{$curpart}"><xsl:value-of select="title" /></a></b>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="abstract">
          <br />
          <xsl:value-of select="abstract" />
        </xsl:if>
        <ol>
          <xsl:for-each select="chapter">
            <xsl:variable name="curchap" select="position()" />
            <li>
              <xsl:choose>
                <xsl:when test="$full = 0">
                  <xsl:choose>
                    <xsl:when test="$style != 'printable'">
                      <b><a href="?part={$curpart}&amp;chap={$curchap}"><xsl:value-of select="title" /></a></b>
                    </xsl:when>
                    <xsl:otherwise>
                      <b><a href="?part={$curpart}&amp;chap={$curchap}&amp;style=printable"><xsl:value-of select="title" /></a></b>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <b><a href="#book_part{$curpart}_chap{$curchap}"><xsl:value-of select="title" /></a></b>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="abstract">
                  <br/>
                  <xsl:value-of select="abstract" />
                </xsl:when>
                <xsl:otherwise>
                  <br/>
                  <xsl:value-of select="document(include/@href)/*[1]/abstract" />
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:for-each>
        </ol>
      </li>
    </xsl:for-each>
  </ul>
  <xsl:call-template name="menubar" />

  <xsl:if test="$full =1">
    <xsl:apply-templates select="part" />
  </xsl:if>
  
  <xsl:apply-templates select="/book/license" />
</xsl:template>

<!-- Part inside a book -->
<xsl:template match="/book/part">
  <xsl:if test="(($chap != 0) and ($part = position())) or ($full = 1)">
    <xsl:param name="pos" select="position()"/>
    <xsl:if test="$full = 1">
      <a name="book_part{$pos}"/>
      <h2><xsl:number level="multiple" format="A. " value="$pos"/><xsl:value-of select="title" /></h2>
    </xsl:if>
    <xsl:apply-templates select="chapter">
      <xsl:with-param name="partnum" select="$pos"/>
    </xsl:apply-templates>
  </xsl:if>
  <xsl:if test="($chap = 0) and ($part = position())">
    <xsl:call-template name="doclayout" />
  </xsl:if>
</xsl:template>

<!-- Content of /book/part -->
<xsl:template name="bookpartcontent">
  <xsl:call-template name="menubar" />
  <xsl:if test="@id">
    <a name="{@id}"/>
  </xsl:if>
  <h1><xsl:number level="multiple" format="1. " value="position()"/><xsl:value-of select="title" /></h1>
  <xsl:if test="abstract">
    <p><xsl:value-of select="abstract" /></p>
  </xsl:if>
  <p><xsl:value-of select="func:gettext('Content')"/>:</p>
  <ol>
    <xsl:for-each select="chapter">
      <xsl:variable name="curpos" select="position()" />
      <xsl:if test="title">
        <li>
          <b><a href="?part={$part}&amp;chap={$curpos}"><xsl:value-of select="title" /></a></b>
          <xsl:choose>
            <xsl:when test="abstract">
              <br/>
              <xsl:value-of select="abstract" />
            </xsl:when>
            <xsl:otherwise>
              <br/>
              <xsl:value-of select="document(include/@href)/*[1]/abstract" />
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:if>
    </xsl:for-each>
  </ol>
  
  <xsl:call-template name="menubar" />
  <xsl:apply-templates select="/book/license" />
</xsl:template>

<!-- Menu bar -->
<xsl:template name="menubar">
  <xsl:variable name="prevpart" select="number($part) - 1" />
  <xsl:variable name="prevchap" select="number($chap) - 1" />
  <xsl:variable name="nextpart" select="number($part) + 1" />
  <xsl:variable name="nextchap" select="number($chap) + 1" />
  <xsl:if test="($style != 'printable') and ($full = 0)">
    <hr />
    <p>
      <!-- Previous Parts -->
      <xsl:choose>
        <xsl:when test="number($prevpart) &lt; 1">
          [ &lt;&lt; ]
        </xsl:when>
        <xsl:otherwise>
          [ <a href="{concat($link, '?part=', $prevpart)}">&lt;&lt;</a> ]
        </xsl:otherwise>
      </xsl:choose>
      <!-- Previous Chapter -->
      <xsl:choose>
        <xsl:when test="number($prevchap) &lt; 1">
          [ &lt; ]
        </xsl:when>
        <xsl:otherwise>
          [ <a href="{concat($link, '?part=', $part, '&amp;chap=', $prevchap)}">&lt;</a> ]
        </xsl:otherwise>
      </xsl:choose>
      <!-- Content -->
      [ <a href="{$link}"><xsl:value-of select="func:gettext('Home')"/></a> ]
      <!-- Next Chapter -->
      <xsl:if test="name() = 'book'">
        [ <a href="{concat($link, '?part=1')}">&gt;</a> ]
      </xsl:if>
      <xsl:if test="name() = 'part'">
        [ <a href="{concat($link, '?part=', $part, '&amp;chap=1')}">&gt;</a> ]
      </xsl:if>
      <xsl:if test="name() = 'chapter'">
        <xsl:choose>
          <xsl:when test="last() = position()">
            [ &gt; ]
          </xsl:when>
          <xsl:otherwise>
            [ <a href="{concat($link, '?part=', $part, '&amp;chap=', $nextchap)}">&gt;</a> ]
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- Next Part -->
      <xsl:if test="name() = 'book'">
        [ <a href="{concat($link, '?part=', $nextpart)}">&gt;&gt;</a> ]
      </xsl:if>
      <xsl:if test="name() = 'part'">
        <xsl:choose>
          <xsl:when test="number($part) = last()">
            [ &gt;&gt; ]
          </xsl:when>
          <xsl:otherwise>
            [ <a href="{concat($link, '?part=', $nextpart)}">&gt;&gt;</a> ]
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name() = 'chapter'">
        <xsl:choose>
          <xsl:when test="count(/book/part) = number($part)">
            [ &gt;&gt; ] 
          </xsl:when>
          <xsl:otherwise>
            [ <a href="{concat($link, '?part=', $nextpart)}">&gt;&gt;</a> ]
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </p>
    <hr />
  </xsl:if>
</xsl:template>


<!-- Chapter inside a part -->
<xsl:template match="/book/part/chapter">
  <xsl:if test="($chap = position()) and ($full = 0)">
    <xsl:call-template name="doclayout" />
  </xsl:if>
  <xsl:if test="$full = 1">
    <xsl:call-template name="bookpartchaptercontent">
      <xsl:with-param name="partnum"><xsl:value-of select="$partnum" /></xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- Content of /book/part/chapter -->
<xsl:template name="bookpartchaptercontent">
  <xsl:param name="chapnum" select="position()"/>
  <xsl:call-template name="menubar" />
  <xsl:if test="@id">
    <a name="{@id}"/>
  </xsl:if>
  <xsl:if test="$full = 1">
    <a name="book_part{$partnum}_chap{$chapnum}"/>
    <h3><xsl:number level="multiple" format="1. " value="position()"/><xsl:value-of select="title" /></h3>
  </xsl:if>
  <xsl:if test="$full = 0">
    <h1><xsl:number level="multiple" format="1. " value="position()"/><xsl:value-of select="title" /></h1>
  </xsl:if>
  <xsl:variable name="doc" select="include/@href"/>
  <xsl:variable name="FILE" select="document($doc)" />
  <xsl:if test="$full = 0">
    <!-- Chapter content only when rendering a single page -->
    <xsl:if test="$FILE/sections/section/title">
      <b><xsl:value-of select="func:gettext('Content')"/>: </b>
      <ul>
        <xsl:for-each select="$FILE/sections/section[not(@test) or dyn:evaluate(@test)]/title">
          <xsl:variable name="pos" select="position()" />
          <li><a href="#doc_chap{$pos}" class="altlink"><xsl:value-of select="." /></a></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$full = 1">
      <xsl:apply-templates select="$FILE/sections/section[not(@test) or dyn:evaluate(@test)]">
        <xsl:with-param name="chapnum" select="$chapnum"/>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$FILE/sections/section[not(@test) or dyn:evaluate(@test)]">
        <xsl:with-param name="chapnum" select="$chapnum"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
  
  <xsl:call-template name="menubar" />

  <xsl:if test="$full = 0">
    <xsl:apply-templates select="/book/license" />
  </xsl:if>
</xsl:template>

<!-- Section inside a chapter -->
<xsl:template match="/sections/section">
  <xsl:param name="pos" select="position()" />
  <xsl:choose>
    <xsl:when test="$full = 1">
      <!-- We need two anchors, 1 for internal links, 1 for cross-chapters links -->
      <a name="book_{generate-id(../..)}_chap{$pos}"/>
      <a name="book_part{$partnum}_chap{$chapnum}__chap{$pos}"/>
    </xsl:when>
    <xsl:otherwise>
      <a name="doc_chap{$pos}"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="@id">
    <a name="{@id}"/>
  </xsl:if>
  <xsl:if test="title">
    <p class="chaphead"><span class="chapnum"><xsl:value-of select="$chapnum" />.<xsl:number level="multiple" format="a. " value="position()" /></span><xsl:value-of select="title" /></p>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$full = 1">
      <xsl:apply-templates select="body|subsection">
        <xsl:with-param name="chpos" select="$pos"/>
        <xsl:with-param name="chapnum" select="$chapnum"/>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="body|subsection">
        <xsl:with-param name="chpos" select="$pos"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- Subsubsection inside a section -->
<xsl:template match="/sections/section/subsection">
 <xsl:param name="pos" select="position()"/>
  <xsl:if test="not(@test) or dyn:evaluate(@test)">
    <xsl:choose>
      <xsl:when test="$full = 1">
        <!-- We need two anchors, 1 for internal links, 1 for cross-chapters links -->
        <a name="book_{generate-id(../../..)}_chap{$chpos}_sect{$pos}"/>
        <a name="book_part{$partnum}_chap{$chapnum}__chap{$chpos}_sect{$pos}"/>
      </xsl:when>
      <xsl:otherwise>
        <a name="doc_chap{$chpos}_sect{$pos}" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@id">
      <a name= "{@id}"/>
    </xsl:if>
    <p class="secthead"><xsl:value-of select="title" /></p>
    <xsl:apply-templates select="body" />
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
