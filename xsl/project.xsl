<?xml version="1.0" encoding="UTF-8"?>
<!-- Identity xsl transformation to allow downloading of other documents
  without the automatic translation kicking in -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="UTF-8" method="xml" indent="yes" doctype-system="/dtd/guide.dtd"/>
<xsl:include href="util.xsl"/>

<xsl:variable name="rollcall" select='document("/proj/en/devrel/roll-call/userinfo.xml")'/>

<xsl:template match="/project">
<xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="/xsl/guide.xsl"</xsl:processing-instruction>
<guide  link="index.xml" type="project">
<title>
<xsl:choose>
  <xsl:when test="longname"><xsl:value-of select="longname"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
</xsl:choose>
</title>
		<xsl:choose>
		  <xsl:when test="author">
		    <xsl:for-each select="author">
		      <xsl:copy>
		        <xsl:apply-templates select="@*|node()"/>
                      </xsl:copy>
		    </xsl:for-each>
		  </xsl:when>
		  <xsl:otherwise>
		    <author title="script generated">Gentoo Project</author>
		  </xsl:otherwise>
		</xsl:choose>
		<abstract><xsl:apply-templates select="description"/></abstract>
		<version>1.0</version>
		<xsl:if test="date">
		<date><xsl:value-of select="date/text()"/></date>
		</xsl:if>
		<chapter>
			<title>Project Description</title>
			<section><body><p>
			<xsl:apply-templates select="longdescription"/>
			</p></body></section>
		</chapter>
		<xsl:apply-templates select='extrachapter[@position="top"]'/>
		<!-- here extra chapters would appear-->
		<xsl:if test="goals">
		<chapter>
			<title>Project Goals</title>
			<section><body>
			<xsl:apply-templates select="goals"/>
			</body></section>
		</chapter>
		</xsl:if>
		<xsl:apply-templates select='extrachapter[@position="goals"]'/>
		<xsl:if test="dev">
		<chapter>
			<title>Developers</title>
			<section><body>
			<table><tr>
				 <th>Developer</th>
				 <th>Nickname</th>
				 <th>Role</th>
			       </tr>
			       <xsl:apply-templates select='dev[translate(@role,"DEAL","deal")="lead"]'/>
			       <xsl:apply-templates select='dev[@role and not(translate(@role,"DEAL","deal")="lead")]'>
			       	<xsl:sort select="@role"/>
			       	<xsl:sort select="text()"/>
			       </xsl:apply-templates>
			       <xsl:apply-templates select='dev[not(@role)]'/>
			       <xsl:call-template name="inheritdev"/>
			</table>
      <p>
       All developers can be reached by e-mail using <c>nickname@gentoo.org</c>.
      </p>
      
                        </body></section>
		</chapter>
		</xsl:if>
		<xsl:apply-templates select='extrachapter[@position="devs"]'/>
		<xsl:if test="subproject|extraproject">
		<chapter>
			<title>Subprojects</title>
			<section><body>
			<p>The <xsl:value-of select="normalize-space(/project/name/text())"/>
			project has the following subprojects:
			</p>
			<table><tr>
				 <th>Project</th>
				 <th>Lead</th>
				 <th>Description</th>
			       </tr>
			       <xsl:apply-templates select="subproject|extraproject">
				   <xsl:with-param name="ref" select="@ref"/>			       
			       </xsl:apply-templates>
			</table></body></section>
		</chapter>
		</xsl:if>		
		<xsl:if test="plannedproject">
		<chapter>
			<title>Planned subprojects</title>
			<section><body>
			<p>The <xsl:value-of select="normalize-space(/project/name/text())"/>
			project has the following subprojects planned:
			</p>
			<table><tr>
				 <th>Project</th>
				 <th>Description</th>
			       </tr>
			       <xsl:for-each select="plannedproject">
			         <tr>
				   <ti><xsl:value-of select="@name"/></ti>
				   <ti><xsl:apply-templates select="node()"/></ti>
				 </tr>
			       </xsl:for-each>
			</table></body></section>
		</chapter>
		</xsl:if>		
		<xsl:apply-templates select='extrachapter[@position="subproject"]'/>

		<xsl:if test="task">
		<chapter>
			<title>Project tasks</title>
			<section><body>
			<p>The tasks of the
			<xsl:value-of select="normalize-space(/project/name/text())"/>
			project are:</p>
			</body></section>
			<xsl:apply-templates select="task">
			</xsl:apply-templates>
		</chapter>			
		</xsl:if>
		<xsl:apply-templates select='extrachapter[@position="tasks"]'/>

		<xsl:if test="resource">
		<chapter>
			<title>Resources</title>
			<section><body>
			<p>Resources offered by the
			<xsl:value-of select="normalize-space(/project/name/text())"/>
			project are:</p>
			<ul>
			<xsl:apply-templates select="resource"/>
			<xsl:call-template name="inheritres"/>
			</ul>
			</body></section>
		</chapter>			
		</xsl:if>
		<xsl:apply-templates select='extrachapter[@position="resources"]'/>
		<xsl:if test="herd">
		<chapter>
			<title>Herds</title>
			<section><body>
			<p>The <xsl:value-of select="normalize-space(/project/name/text())"/>
			project maintains the following herds:
			</p>
			<table><tr>
				 <th>Herd</th>
				 <th>Members</th>
				 <th>Description</th>
			       </tr>
			       <xsl:apply-templates select="herd">
			       </xsl:apply-templates>
			</table></body></section>
		</chapter>
		</xsl:if>		
	
		<xsl:apply-templates select='extrachapter[@position="bottom" or (not(@position) or @position="")]'/>
	</guide>
</xsl:template>
<xsl:template match="name|description">
<xsl:value-of select="normalize-space(text())"/>
</xsl:template>
<xsl:template match="longdescription|goals">
	<xsl:apply-templates select="node()|@*" />
</xsl:template>
<xsl:template match="longdescription//node()|longdescription//@*|goals//node()|goals//@*|extrachapter//node()|extrachapter//@*|extraproject//node()|extraproject//@*|plannedproject//node()|plannedproject//@*|uri//@*|uri//node()|mail//@*|mail//node()|author//node()|author//@*">
	<xsl:copy>
		<xsl:apply-templates select="node()|@*"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="dev">
<xsl:variable name="nick" select='string(text())'/>
	<tr>
		<ti>
			<xsl:call-template name="fullname">
				<xsl:with-param name="nick" select="$nick"></xsl:with-param>
        <xsl:with-param name="rollcall"><xsl:copy-of select="$rollcall"/></xsl:with-param>
			</xsl:call-template>
		
		</ti>
		<ti>
			<xsl:value-of select='translate($nick,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")'/>
		</ti>
		<ti>
			<xsl:value-of select="concat( translate( substring( @role, 1, 1 ),'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ), substring( @role, 2))" />
			<xsl:if test="@description">
				<xsl:value-of select="concat(' ( ', @description, ' )')"/>
			</xsl:if>
		</ti>
	</tr>
</xsl:template>

<xsl:template match="userlist/user">
	<xsl:value-of select="realname/firstname/text()"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="realname/familyname/text()"/>
</xsl:template>
<xsl:template match="extraproject">
  <tr>
  <xsl:choose>
    <xsl:when test="@link">
      <ti><uri link="{@link}"><xsl:value-of select="@name"/></uri></ti>
    </xsl:when>
    <xsl:otherwise>
      <ti><xsl:value-of select="@name"/></ti>
    </xsl:otherwise>
  </xsl:choose>
	<ti><xsl:if test="@lead">
		<xsl:call-template name="fullname">
			<xsl:with-param name="nick"><xsl:value-of select="@lead"/></xsl:with-param>
			<xsl:with-param name="fallback">true</xsl:with-param>
      <xsl:with-param name="rollcall"><xsl:copy-of select="$rollcall"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if></ti>
	<ti><xsl:apply-templates select="node()"/>
	</ti></tr>
</xsl:template>
<xsl:template match="subproject">
	<xsl:variable name="ref" select='string(@ref)'/>
	<xsl:for-each select='document($ref)'>
		<tr><ti>
		<uri link="{$ref}">
			<xsl:value-of select="/project/name/text()"/>
		</uri>
		</ti>
		<ti>
		<xsl:if test='/project/dev[translate(@role,"DEAL","deal")="lead"]'>
			<xsl:call-template name="fullname">
				<xsl:with-param name="nick"><xsl:value-of select='/project/dev[translate(@role,"DEAL","deal")="lead"]'/></xsl:with-param>
				<xsl:with-param name="fallback">true</xsl:with-param>
        <xsl:with-param name="rollcall"><xsl:copy-of select="$rollcall"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		</ti>
		<ti><xsl:value-of select="normalize-space(/project/description/text())"/></ti>
		</tr>
	</xsl:for-each>
</xsl:template>
<xsl:template match="resource">
<li><uri><xsl:attribute name="link"><xsl:value-of select="@link"/>
</xsl:attribute>
<xsl:value-of select="text()"/>
</uri>
</li>
</xsl:template>
<xsl:template match="extrachapter">
<chapter>
<xsl:apply-templates/>
</chapter>
</xsl:template>

<xsl:template match="herd">
  <xsl:for-each select='document("/proj/en/metastructure/herds/herds.xml")/herds/herd[name/text()=current()/@name]'>
    <tr>
      <ti>
    <!-- The herds.xml?select= is not working currently, we are waiting
         until the necessary dyn/ page is fixed.
        <uri>
          <xsl:attribute name="link">
            /proj/en/metastructure/herds/herds.xml?select=<xsl:value-of select="name"/>
          </xsl:attribute>
          <xsl:value-of select="name"/>
        </uri>
    -->
        <xsl:value-of select="name"/>
      </ti>
      <ti>
        <!-- We can have maintainer/email OR maintainingproject, but not both -->
        <xsl:choose>
         <xsl:when test="maintainer/email">
          <xsl:for-each select="maintainer/email">
            <xsl:sort/>
            <xsl:value-of select='substring-before(text(),"@gentoo.org")'/>
            <xsl:if test="not(position()=last())">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
         </xsl:when>
         <xsl:when test="maintainingproject">
          <xsl:for-each select="document(maintainingproject/text())/project/dev">
            <xsl:sort select="text()"/>
              <xsl:value-of select="text()"/>
              <xsl:if test="not(position()=last())">
                <xsl:text>, </xsl:text>
              </xsl:if>
          </xsl:for-each>
         </xsl:when>
        </xsl:choose>
      </ti>
      <ti>
	<xsl:value-of select="description"/>
      </ti>
    </tr>
  </xsl:for-each>
</xsl:template>

<xsl:template name="inheritres">
  <xsl:for-each select='/project/subproject[@inheritresources="yes"]'>
    <xsl:for-each select="document(@ref)">
      <li>
        <b>
          <xsl:value-of select="/project/longname"/>
          <xsl:if test="not(/project/longname)">
            <xsl:value-of select="/project/name"/>
          </xsl:if>
          subproject resources
        </b>
        <ul>
          <xsl:apply-templates select="/project/resource"/>
          <xsl:call-template name="inheritres"/>
        </ul>
      </li>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template name="inheritdev">
  <xsl:for-each select='/project/subproject[@inheritmembers="yes"]'>
    <xsl:for-each select="document(@ref)">
      <xsl:for-each select="/project[dev]">
        <tr>
          <th>Members from subproject
            <xsl:value-of select="name"/>
          </th><th></th><th></th>
        </tr>
        <xsl:apply-templates select='dev'>
          <xsl:sort select="@role"/>
          <xsl:sort select="text()"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template match="task">
  <section>
    <title><xsl:value-of select="name"/> -
      <xsl:value-of select="description"/>
      <xsl:if test='@finished="yes"'> (finished)</xsl:if>
    </title>
    <body>
      <p><xsl:value-of select="longdescription"/></p>
      <table>
        <tr>
	  <th>Starting date:</th><ti><xsl:value-of select="startdate"/></ti>
	</tr>
	<xsl:if test="enddate">
          <tr>
	    <th>End date:</th><ti><xsl:value-of select="enddate"/></ti>
	  </tr>
	</xsl:if>
	<xsl:for-each select="dev">
	  <tr><th>Developer:</th><ti>
	  <!--xsl:sort select="text()"/-->
	    <xsl:value-of select="text()"/>
	    <xsl:text> </xsl:text>
	    <xsl:call-template name="fullname">
		<xsl:with-param name="nick" select="normalize-space(text())"/>
		<xsl:with-param name="parent" select='"true"'/>
    <xsl:with-param name="rollcall"><xsl:copy-of select="$rollcall"/></xsl:with-param>
	    </xsl:call-template>
	    -
	    <xsl:value-of select="@role"/>
	    <xsl:if test="@description">
	      (<xsl:value-of select="@description"/>)
	    </xsl:if>
	  </ti></tr>
	</xsl:for-each>
	<xsl:for-each select="reference">
	  <tr><th>Reference:</th>
	    <ti><xsl:apply-templates select="uri|bug|mail"/></ti>
	  </tr>
	</xsl:for-each>
      </table>
      <xsl:if test="milestone">
        <table>
          <tr><th>Milestone #</th><th>ETA</th><th>Description</th></tr>
          <xsl:for-each select="milestone">
            <xsl:sort select="enddate"/>
            <tr>
              <ti><xsl:value-of select="position()"/></ti>
              <xsl:choose>
                <xsl:when test='@finished="yes"'>
                  <th>Finished</th>
                </xsl:when>
                <xsl:otherwise>
                  <ti><xsl:value-of select="enddate"/></ti>
                </xsl:otherwise>
              </xsl:choose>
              <ti><xsl:value-of select="description"/></ti>
            </tr>      
          </xsl:for-each>
        </table>
      </xsl:if>
      <xsl:if test="depends">
        <table>
          <xsl:for-each select="depends">
            <tr><th>Depends on</th>
              <ti>This task depends on the
                <brite><xsl:value-of select="id(@ref)/name"/></brite> task
              </ti>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:if>
    </body>
  </section>
</xsl:template>
<xsl:template match="uri|mail">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>
<xsl:template match="bug">
  <uri>
    <xsl:attribute name="link">http://bugs.gentoo.org/show_bug.cgi?id=<xsl:value-of select="@no"/></xsl:attribute>
    <xsl:choose>
      <xsl:when test="text()">
        <xsl:value-of select="text()"/>
      </xsl:when>
      <xsl:otherwise>
        bug #<xsl:value-of select="@no"/>
      </xsl:otherwise>
    </xsl:choose>
  </uri>
</xsl:template>


</xsl:stylesheet>
