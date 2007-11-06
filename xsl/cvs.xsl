<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="iso-8859-1" method="xml" indent="yes"/>
<xsl:output method="xml" doctype-system="/dtd/guide.dtd"  />
<xsl:template match="/changelog">
	<xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="/xsl/guide.xsl"</xsl:processing-instruction>
	<mainpage id="changelog">
	<title>Gentoo Linux Development Changelog for <xsl:value-of select="entry/date"/></title>
	<author title="script">cvs-xml.xsl</author>

	<version>1.0.0</version>
	<date><xsl:value-of select="entry/date"/></date>
	<chapter>
    <title>Gentoo Linux Development Changelog</title>
		<xsl:apply-templates select="entry"/>
	</chapter>
	</mainpage>
</xsl:template>

<xsl:template match="entry">
	<section>
		<title>Files modified by <xsl:value-of select="author"/> at <xsl:value-of select="time"/></title>
		<body>
			<note><xsl:value-of select="msg"/></note>
			<ul>
				<xsl:apply-templates select="file"/>
			</ul>
		</body>
	</section>
</xsl:template>

<xsl:template match="file">
	<li><path><xsl:value-of select="name"/></path>, <xsl:value-of select="revision"/></li>
</xsl:template>

</xsl:stylesheet>

