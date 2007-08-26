<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="UTF-8" method="xml" indent="yes" doctype-system="/dtd/guide.dtd"/>
<xsl:param name="showlevel">1</xsl:param>
<xsl:template match="/projects">
<xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="/xsl/guide.xsl"</xsl:processing-instruction>
        <guide  link="" type="project">
                <title>Project Listing</title>
		<author title="script generated">Gentoo Project</author>
		<abstract>This is an overview of all current gentoo projects</abstract>
		<version>1.1</version>
		<date>2005-05-23</date>
		<chapter>
			<title>Gentoo Projects</title>
			<section><body>
			<p>This page is meant to give an overview of all gentoo projects</p>
			<p>The old static unmaintained version of the document is available <uri link="/proj/en/metastructure/oldprojects.xml">here</uri></p>
			</body></section>
		</chapter>
		<chapter>
			<title>Project listing</title>
			<section><body>
			<p>
			  <xsl:choose>
			    <xsl:when test="$showlevel&lt;=1">
			      <uri link="/proj/en/index.xml?showlevel=2">
			        Show sub-projects
			      </uri>
			    </xsl:when>
			    <xsl:when test="$showlevel&gt;=3">
			      <uri link="/proj/en/index.xml?showlevel=2">
			        Hide sub-sub-projects
			      </uri>
			    </xsl:when>
			    <xsl:otherwise>
			      <uri link="/proj/en/index.xml?showlevel=1">
			        Hide sub-projects</uri>&#160;&#160;&#160;&#160;<uri link="/proj/en/index.xml?showlevel=3">Show sub-sub-projects
			      </uri>
			    </xsl:otherwise>
			  </xsl:choose>
			</p>
			<table>
			  <xsl:if test="$showlevel&lt;=1">
			    <tr>
			      <th>toplevel</th>
			      <th>lead(s)</th>
			      <th>members</th>
			      <th>description</th>
			    </tr>
			  </xsl:if>
			  <xsl:call-template name="projlist">
			    <xsl:with-param name="ref" select="string(text())"/>
			    <xsl:with-param name="level" select="0"/>
			  </xsl:call-template>
			</table>
			</body></section>
		</chapter>
	</guide>
</xsl:template>

<xsl:template name="projlist">
  <xsl:param name="ref"/>
  <xsl:param name="level" select="1"/>
  <xsl:if test='(number($level)=1) and ($showlevel>1)'>
    <tr>
      <th>toplevel</th>
      <xsl:if test="$showlevel>1"><th>project</th></xsl:if>
      <xsl:if test="$showlevel>2"><th>subproject</th></xsl:if>
      <th>lead(s)</th>
      <th>members</th>
      <th>description</th>
    </tr>
  </xsl:if>
  <xsl:for-each select="document(string($ref))">
    <xsl:if test="($level > 0) and ($level &lt;=$showlevel)">
      <tr>
        <ti>
       	  <xsl:if test="$level=1">
       	    <uri>
       	      <xsl:attribute name="link">
       	        <xsl:value-of select="$ref"/>
       	      </xsl:attribute>
      	      <xsl:value-of select="project/name/text()"/>
      	    </uri>
          </xsl:if>
        </ti>
        <xsl:if test="$showlevel>1">
          <ti>
      	    <xsl:if test="$level=2">
              <uri>
       	        <xsl:attribute name="link">
       	          <xsl:value-of select="$ref"/>
                </xsl:attribute>
      	        <xsl:value-of select="project/name/text()"/>
      	      </uri>
      	    </xsl:if>
          </ti>
        </xsl:if>
        <xsl:if test="$showlevel>2">
          <ti>
            <xsl:if test="$level=3">
              <uri>
                <xsl:attribute name="link">
                  <xsl:value-of select="$ref"/>
                </xsl:attribute>
                <xsl:value-of select="project/name/text()"/>
              </uri>
            </xsl:if>
          </ti>
        </xsl:if>
        <ti>
          <xsl:for-each select='project/dev[translate(@role,"DEAL","deal")="lead"]'>
            <xsl:variable name="lead" select="text()"/>
            <xsl:if test='count(following-sibling::dev[text()=$lead and translate(@role,"DEAL","deal")="lead"])=0'>
              <xsl:value-of select="text()"/>
              <xsl:if test="not(position() = last())">, </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </ti>
        <ti>
          <xsl:for-each select='project/dev[not(translate(@role,"DEAL","deal")="lead" or text()=preceding-sibling::dev/text())]'>
            <xsl:sort select="text()"/>
            <xsl:value-of select="text()"/>
            <xsl:if test="not(position() = last())">, </xsl:if>
          </xsl:for-each>
        </ti>
        <ti>
          <xsl:apply-templates select="project/description"/>
        </ti>
      </tr>
    </xsl:if>
    <xsl:for-each select="project/subproject">
      <xsl:sort select="translate(document(string(@ref))/project/name,'QWERTYUIOPLKJHGFDSAZXCVBNM','qwertyuioplkjhgfdsazxcvbnm')"/>
      <xsl:call-template name="projlist">
        <xsl:with-param name="ref" select="string(@ref)"/>
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="project/extraproject">
      <xsl:sort select="@name"/>
      <xsl:call-template name="extraproj">
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template match="/project/description//node()|project/description//@*|/project/extraproject//@*|/project/extraproject//node()">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template name="extraproj">
  <xsl:param name="level" select="1"/>
  <xsl:if test='(number($level)=1) and ($showlevel>1)'>
    <tr>
      <th>toplevel</th>
      <xsl:if test="$showlevel>1"><th>project</th></xsl:if>
      <xsl:if test="$showlevel>2"><th>subproject</th></xsl:if>
      <th>lead(s)</th>
      <th>members</th>
      <th>description</th>
    </tr>
  </xsl:if>
  <xsl:if test="($level > 0) and ($level &lt;=$showlevel)">
    <tr>
      <ti>
        <xsl:if test="$level=1">
          <xsl:value-of select="@name"/>
        </xsl:if>
      </ti>
      <xsl:if test="$showlevel>1">
      <ti>
        <xsl:if test="$level=2">
          <xsl:value-of select="@name"/>
      	</xsl:if>
      </ti>
      </xsl:if>
      <xsl:if test="$showlevel>2">
      <ti>
        <xsl:if test="$level=3">
    	  <xsl:value-of select="@name"/>
        </xsl:if>
      </ti>
      </xsl:if>
      <ti>
        <xsl:value-of select='@lead'/>
      </ti>
      <ti>
      </ti>
      <ti>
        <xsl:apply-templates select="node()"/>
      </ti>
    </tr>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
