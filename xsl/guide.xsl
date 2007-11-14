<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exslt="http://exslt.org/common"
                xmlns:func="http://exslt.org/functions"
                xmlns:dyn="http://exslt.org/dynamic"
                xmlns:str="http://exslt.org/strings"

                xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
                exclude-result-prefixes="opensearch"

                extension-element-prefixes="exslt func dyn str" >

<xsl:output encoding="UTF-8"
            method="html"
            indent="yes"
            doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
            doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>

<!-- Include external stylesheets -->
<xsl:include href="/xsl/content.xsl" />
<xsl:include href="/xsl/handbook.xsl" />
<xsl:include href="/xsl/inserts.xsl" />

<xsl:include href="/xsl/mail.xsl" />

<xsl:include href="/xsl/devmap.xsl" />

<!-- When using <pre>, whitespaces should be preserved -->
<xsl:preserve-space elements="pre script"/>

<!-- Global definition of style parameter -->
<xsl:param name="style">0</xsl:param>
<xsl:param name="newsitemcount">6</xsl:param>

<!-- Category from metadoc -->
<xsl:param name="catid">0</xsl:param>

<!-- Nick to select on dev map -->
<xsl:param name="dev"/>

<!-- Where is this xsl being run? -->
<xsl:param name="httphost">www</xsl:param>

<!-- img tag -->
<xsl:template match="img">
  <img src="{@src}" alt=""/>
</xsl:template>

<xsl:template name="show-disclaimer">
  <!-- Disclaimer stuff -->
  <xsl:if test="/*[1][@disclaimer] or /*[1][@redirect]">
    <table class="ncontent" align="center" width="90%" border="2px" cellspacing="0" cellpadding="4px">
      <xsl:if test="/*[1]/@disclaimer='obsolete'">
        <xsl:attribute name="style">margin-top:40px;margin-bottom:30px</xsl:attribute>
      </xsl:if>
      <tr>
        <td bgcolor="#ddddff">
          <p class="note">
            <xsl:if test="/*[1][@disclaimer]">
              <xsl:if test="/*[1]/@disclaimer='obsolete'">
                <xsl:attribute name="style">font-size:1.3em</xsl:attribute>
              </xsl:if>
              <b><xsl:value-of select="func:gettext('disclaimer')"/>: </b>
              <xsl:apply-templates select="func:gettext(/*[1]/@disclaimer)"/>
            </xsl:if>
            <xsl:if test="/*[1][@redirect]">
              <xsl:apply-templates select="func:gettext('redirect')">
                <xsl:with-param name="paramlink" select="/*[1]/@redirect"/>
              </xsl:apply-templates>
            </xsl:if>
          </p>
        </td>
      </tr>
    </table>
  </xsl:if>
</xsl:template>


<!-- Content of /guide -->
<xsl:template name="guidecontent">
  <xsl:if test="$style != 'printable'">
    <br />
  </xsl:if>

  <h1>
    <xsl:choose>
      <xsl:when test="/guide/subtitle"><xsl:value-of select="/guide/title"/>: <xsl:value-of select="/guide/subtitle"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="/guide/title"/></xsl:otherwise>
    </xsl:choose>
  </h1>

  <xsl:choose>
    <xsl:when test="$style = 'printable'">
      <xsl:apply-templates select="author" />
      <br/>
      <i><xsl:call-template name="contentdate"/></i>
      <xsl:variable name="outdated">
        <xsl:call-template name="outdated-translation"/>
      </xsl:variable>
      <xsl:if test="string-length($outdated) &gt; 1">
        <br/><b><i><xsl:copy-of select="$outdated"/></i></b>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
     <xsl:if test="count(/guide/chapter)&gt;1">
      <form name="contents" action="http://www.gentoo.org">
        <b><xsl:value-of select="func:gettext('Content')"/></b>:
        <select name="url" size="1" OnChange="location.href=form.url.options[form.url.selectedIndex].value" style="font-family:sans-serif,Arial,Helvetica">
          <xsl:for-each select="chapter">
            <xsl:variable name="chapid">doc_chap<xsl:number/></xsl:variable><option value="#{$chapid}"><xsl:number/>. <xsl:value-of select="title"/></option>
          </xsl:for-each>
        </select>
      </form>
     </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="/guide">
      <xsl:apply-templates select="faqindex|chapter"/>
    </xsl:when>
    <xsl:when test="/sections">
      <xsl:apply-templates select="/sections/section"/>
    </xsl:when>
  </xsl:choose>
  <br/>
  <xsl:if test="/guide/license">
    <xsl:apply-templates select="license" />
  </xsl:if>
  <br/>
</xsl:template>

<!-- Layout for documentation -->
<xsl:template name="doclayout">
  <xsl:param name="chapnum"/>
  <xsl:param name="partnum"/>
<html>
  <xsl:if test="string-length($glang)>1">
    <xsl:attribute name="lang"><xsl:value-of select="translate($glang,'_','-')"/></xsl:attribute>
  </xsl:if>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <link title="new" rel="stylesheet" href="{concat($ROOT,'css/main.css')}" type="text/css"/>
  <link REL="shortcut icon" HREF="{concat($ROOT,'favicon.ico')}" TYPE="image/x-icon"/>

  <!-- Support for opensearch -->
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/www-gentoo-org.xml" title="Gentoo Website"/>
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/forums-gentoo-org.xml" title="Gentoo Forums"/>
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/bugs-gentoo-org.xml" title="Gentoo Bugzilla"/>
<!--  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/packages-gentoo-org.xml" title="Gentoo Packages"/> -->
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/archives-gentoo-org.xml" title="Gentoo List Archives"/>
  
  <xsl:if test="//glsaindex or //glsa-latest">
    <link rel="alternate" type="application/rss+xml">
      <xsl:attribute name="href">
        <xsl:text>/rdf/en/glsa-index.rdf</xsl:text>
        <xsl:if test="//glsa-latest">
          <xsl:text>?num=9</xsl:text>
        </xsl:if>
      </xsl:attribute>
    </link>
  </xsl:if>

  <xsl:if test="/*[1][@redirect]">
    <!-- HTML refresh in case redirect is not supported -->
    <meta http-equiv="Refresh">
      <xsl:attribute name="content"><xsl:value-of select="concat('15; URL=', /*[1]/@redirect)"/></xsl:attribute>
    </meta>
    <xsl:message>
      <!-- Redirect using http header when supported -->
      <xsl:value-of select="concat('%%GORG%%Redirect=',/*[1]/@redirect)"/>
    </xsl:message>
  </xsl:if>    

<title>
  <xsl:choose>
    <xsl:when test="/guide/@type='project'">Gentoo Linux Projects</xsl:when>
    <xsl:when test="/guide/@type='newsletter'">Gentoo Linux Newsletter</xsl:when>
    <xsl:when test="/sections">Gentoo Linux Handbook Page</xsl:when>
    <xsl:otherwise><xsl:value-of select="func:gettext('GLinuxDoc')"/></xsl:otherwise>
  </xsl:choose>
--
  <xsl:choose>
    <xsl:when test="subtitle"><xsl:if test="/guide/@type!='newsletter'"><xsl:value-of select="title"/>:</xsl:if> <xsl:value-of select="subtitle"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="title"/></xsl:otherwise>
  </xsl:choose>
</title>

</head>
<xsl:choose>
  <xsl:when test="$style = 'printable'">
    <!-- Insert the node-specific content -->
<body bgcolor="#ffffff">
    <!-- Test for RTL languages -->
    <xsl:if test="$RTL='Y'">
      <xsl:attribute name="dir">RTL</xsl:attribute>
    </xsl:if>

    <xsl:call-template name="show-disclaimer"/>
    <xsl:call-template name="content">
      <xsl:with-param name="chapnum" select="$chapnum"/>
      <xsl:with-param name="partnum" select="$partnum"/>
    </xsl:call-template>
</body>
  </xsl:when>
  <xsl:otherwise>
<body style="margin:0px;" bgcolor="#ffffff">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top" height="125" bgcolor="#45347b">
    <a href="/"><img border="0" src="{concat($ROOT,'images/gtop-www.jpg')}" alt="Gentoo Logo"/></a>
    </td>
  </tr>
  <tr>
    <td valign="top" align="right" colspan="1" bgcolor="#ffffff">
      <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr>
          <td width="99%" class="content" valign="top">
            <!-- Test for RTL languages -->
            <xsl:choose>
              <xsl:when test="$RTL='Y'">
                <xsl:attribute name="dir">RTL</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="align">left</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <!-- Insert the node-specific content -->
            <xsl:call-template name="show-disclaimer"/>
            <xsl:call-template name="content">
              <xsl:with-param name="chapnum" select="$chapnum"/>
              <xsl:with-param name="partnum" select="$partnum"/>
            </xsl:call-template>
          </td>
          <td width="1%" bgcolor="#dddaec" valign="top">
            <xsl:call-template name="rhcol"/>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="2" align="right" class="infohead">
     <xsl:call-template name="copyright-footer"/>
    </td>
  </tr>
</table>

</body>
  </xsl:otherwise>
  </xsl:choose>
</html>
</xsl:template>


<xsl:template match="/gleps|/devaway|/uris|/inserts|/glsa-index|opensearch:OpenSearchDescription">
 <xsl:message>
  <xsl:value-of select="concat('%%GORG%%Redirect=',$link,'?passthru=1')"/>
 </xsl:message>
</xsl:template>

<!-- Guide template -->
<xsl:template match="/guide">
<xsl:call-template name="doclayout" />
</xsl:template>

<!-- {Mainpage, News, Email} template -->
<xsl:template match="/mainpage | /news">
<html>
  <xsl:if test="string-length($glang)>1">
    <xsl:attribute name="lang"><xsl:value-of select="translate($glang,'_','-')"/></xsl:attribute>
  </xsl:if>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <link title="new" rel="stylesheet" href="{concat($ROOT,'css/main.css')}" type="text/css"/>
  <link REL="shortcut icon" HREF="{concat($ROOT,'favicon.ico')}" TYPE="image/x-icon"/>

  <!-- Support for opensearch -->
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/www-gentoo-org.xml" title="Gentoo Website"/>
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/forums-gentoo-org.xml" title="Gentoo Forums"/>
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/bugs-gentoo-org.xml" title="Gentoo Bugzilla"/>
<!--  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/packages-gentoo-org.xml" title="Gentoo Packages"/> -->
  <link rel="search" type="application/opensearchdescription+xml" href="http://www.gentoo.org/search/archives-gentoo-org.xml" title="Gentoo List Archives"/>
  
  <xsl:if test="/mainpage/newsitems">
    <link rel="alternate" type="application/rss+xml" title="Gentoo Linux News RDF" href="http://www.gentoo.org/rdf/en/gentoo-news.rdf" />
  </xsl:if>
  <xsl:choose>
    <xsl:when test="/mainpage | /news">
      <title>
        Gentoo Linux -- <xsl:value-of select="title"/>
      </title>
    </xsl:when>
  </xsl:choose>

  <xsl:if test="/mainpage/devmap">
    <xsl:variable name="gkey" select="document('/gmaps-key.xml')/gkey"/>
    <script src="{concat('http://maps.google.com/maps?file=api&amp;v=2&amp;key=', $gkey)}" type="text/javascript"></script>

    <xsl:variable name="selectdev">
      <xsl:choose>
        <xsl:when test="string-length(translate($dev,'qwertyuioplkjhgfdsazxcvbnm-_0987654321QWERTYUIOPLKJHGFDSAZXCVBNM',''))=0 and string-length($dev)&lt;24">
          <xsl:value-of select="translate($dev,'QWERTYUIOPLKJHGFDSAZXCVBNM','qwertyuioplkjhgfdsazxcvbnm')"/>
        </xsl:when>
        <xsl:otherwise>NotADev</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="newscript" select="str:replace($devmap-js, 'X-PLACEHOLDER', string($selectdev))"/>
    <script type="text/javascript">//<xsl:comment><xsl:value-of select="$newscript"/>//</xsl:comment></script>
  </xsl:if>
  
</head>
<body style="margin:0px;" bgcolor="#000000">

<xsl:if test="/mainpage/devmap">
  <xsl:attribute name="onload">load()</xsl:attribute>
  <xsl:attribute name="onunload">GUnload()</xsl:attribute>
</xsl:if>

<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <xsl:variable name="tpath" select="str:replace($link, str:replace(concat('/',$glang,'/'),'//','/en/'), '/**/')"/>
  <xsl:variable name="isEnglish"><xsl:if test="string-length($glang)=0 or $glang='en'">Y</xsl:if></xsl:variable>
  <xsl:variable name="www"><xsl:if test="$httphost!='www'">http://www.gentoo.org</xsl:if></xsl:variable>
  <tr>
    <td valign="top" height="125" width="1%" bgcolor="#45347b">
    <a href="{concat($www,'/')}"><img border="0" src="{concat($ROOT,'images/gtop-www.jpg')}" alt="Gentoo Logo"/></a>
    </td>
    <!-- Top bar menu -->
    <td valign="bottom" align="left" bgcolor="#000000" colspan="2" lang="zh_cn">
      <p class="menu">
        <a class="menulink" href="{concat($www,'/main/en/about.xml')}">
         <xsl:choose>
          <xsl:when test="$tpath='/main/**/about.xml'">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
          </xsl:when> 
          <xsl:when test="not($isEnglish='Y' or document(concat('/main/', $glang, '/about.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/about.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        关于</a>
        | 
        <a class="menulink" href="{concat($www,'/proj/en/index.xml')}">
          <xsl:if test="starts-with($tpath, '/proj/**/')">
            <xsl:attribute name="class">highlight</xsl:attribute>
          </xsl:if>
        项目</a>
        |
        <a class="menulink" href="{concat($www,'/doc/zh_cn/index.xml')}">
         <xsl:choose>
          <xsl:when test="starts-with($tpath, '/doc/**/')">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="str:replace(concat('/doc/',$glang,'/'), '//','/en/')"/></xsl:attribute>
          </xsl:when>
          <xsl:when test="not($isEnglish='Y' or document(concat('/doc/', $glang, '/index.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/doc/',$glang,'/index.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        文档</a>
        | <a class="menulink" href="http://forums.gentoo.org">论坛</a>
        |
        <a class="menulink" href="{concat($www,'/main/en/lists.xml')}">
         <xsl:choose>
          <xsl:when test="$tpath='/main/**/lists.xml'">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
          </xsl:when> 
          <xsl:when test="not($isEnglish='Y' or document(concat('/main/', $glang, '/lists.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/lists.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        邮件列表</a>
        | <a class="menulink" href="http://bugs.gentoo.org">Bugs</a>
        | <a class="menulink" href="http://www.cafepress.com/officialgentoo/">Store</a>
        |
        <a class="menulink" href="{concat($www,'/news/zh_cn/gwn/gwn.xml')}">
         <xsl:choose>
          <xsl:when test="starts-with($tpath, '/news/**/gwn/')">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
          </xsl:when> 
          <xsl:when test="not($isEnglish='Y' or document(concat('/news/', $glang, '/gwn/gwn.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/news/',$glang,'/gwn/gwn.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        周报</a>
        |
        <a class="menulink" href="{concat($www,'/main/en/where.xml')}">
         <xsl:choose>
          <xsl:when test="$tpath='/main/**/where.xml'">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
          </xsl:when> 
          <xsl:when test="not($isEnglish='Y' or document(concat('/main/', $glang, '/where.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/where.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        Get Gentoo!</a>
        |
        <a class="menulink" href="{concat($www,'/main/en/support.xml')}">
         <xsl:choose>
          <xsl:when test="$tpath='/main/**/support.xml'">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
          </xsl:when> 
          <xsl:when test="not($isEnglish='Y' or document(concat('/main/', $glang, '/support.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/support.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        Support</a>
        |
        <a class="menulink" href="{concat($www,'/main/en/sponsors.xml')}">
         <xsl:choose>
          <xsl:when test="$tpath='/main/**/sponsors.xml'">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
          </xsl:when> 
          <xsl:when test="not($isEnglish='Y' or document(concat('/main/', $glang, '/sponsors.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/sponsors.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        Sponsors</a>
        | <a class="menulink" href="http://planet.gentoo.org">Planet</a>
        |
        <a class="menulink" href="{concat($www,'/main/en/contact.xml')}">
         <xsl:choose>
          <xsl:when test="$tpath='/main/**/contact.xml'">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
          </xsl:when> 
          <xsl:when test="not($isEnglish='Y' or document(concat('/main/', $glang, '/contact.xml'))/missing)">
            <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/contact.xml')"/></xsl:attribute>
          </xsl:when> 
         </xsl:choose>
        Contact</a>
      </p>
    </td>
  </tr>
  <tr>
    <td valign="top" align="right" width="1%" bgcolor="#dddaec">
      <table width="100%" cellspacing="0" cellpadding="0" border="0">
        <tr>
          <td height="1%" valign="top" align="right">
            <img src="{concat($ROOT,'images/gridtest.gif')}" alt="Gentoo Spaceship"/>
          </td>
        </tr>
        <tr>
          <td height="99%" valign="top" align="left">
            <!--info goes here-->
            <table cellspacing="0" cellpadding="5" border="0">
              <tr>
                <td valign="top" class="leftmenu" lang="zh_cn">
                  <p class="altmenu">
                   安装：
                   <br/>
                    <a class="altlink" href="{concat($www,'/doc/zh_cn/handbook/index.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/doc/', $glang, '/handbook/index.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/doc/',$glang,'/handbook/index.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>Gentoo手册</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/doc/zh_cn/index.xml?catid=install#doc_chap2')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/doc/', $glang, '/index.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/doc/',$glang,'/index.xml?catid=install#doc_chap2')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>安装文档</xsl:text></a>
                   <br/><br/>
                   文档：
                   <br/>
                    <a class="altlink" href="{concat($www,'/doc/zh_cn/index.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/doc/', $glang, '/index.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/doc/',$glang,'/index.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>文档首页</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/doc/zh_cn/list.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/doc/', $glang, '/list.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/doc/',$glang,'/list.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>文档列表</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/about.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/about.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/about.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>About&#xA0;Gentoo</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/philosophy.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/philosophy.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/philosophy.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>Philosophy</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/contract.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/contract.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/contract.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>Social&#xA0;Contract</xsl:text></a>
                   <br/><br/>
                   资源：
		   <br/>
	            <a class="altlink" href="http://www.gentoo-cn.org/gitweb">Git仓库</a>
                    <br/>
                    <a class="altlink" href="http://bugs.gentoo.org">Bug&#xA0;Tracker</a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/proj/en/devrel/roll-call/userinfo.xml')}">Developer&#xA0;List</a>
                    <br/>
                    <a class="altlink" href="http://forums.gentoo.org">Discussion&#xA0;Forums</a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/irc.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/irc.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/irc.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>IRC&#xA0;频道</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/lists.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/lists.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/lists.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>邮件列表</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/mirrors.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/mirrors.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/mirrors.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>Mirrors</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/name-logo.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/name-logo.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/name-logo.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>Name and Logo Guidelines</xsl:text></a>
                    <br/>
<!--
                    <a class="altlink" href="http://packages.gentoo.org/">Online Package Database</a>
                    <br/>
-->
                    <a class="altlink" href="{concat($www,'/security/en/index.xml')}">Security Announcements</a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/proj/en/devrel/staffing-needs/')}">Staffing&#xA0;Needs</a>
                    <br/>
		   <br/>
                   Graphics:
                   <br/>
                    <a class="altlink" href="{concat($www,'/main/en/graphics.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/graphics.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/graphics.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>Logos and themes</xsl:text></a>
                    <br/>
                    <a class="altlink" href="{concat($www,'/main/en/shots.xml')}">
                      <xsl:if test="not($isEnglish='Y' or document(concat('/main/', $glang, '/shots.xml'))/missing)">
                        <xsl:attribute name="href"><xsl:value-of select="concat('/main/',$glang,'/shots.xml')"/></xsl:attribute>
                      </xsl:if> 
                    <xsl:text>ScreenShots</xsl:text></a>
                   <br/><br/>
                   Miscellaneous Resources:
                   <br/>
                    <a class="altlink" href="{concat($www,'/doc/en/articles/')}">IBM dW/Intel article archive</a>
                  </p>
                  <br/><br />
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
    <!-- Content below top menu and between left menu and ads -->
    <td valign="top" bgcolor="#ffffff">
      <!-- Test for RTL languages -->
      <xsl:if test="$RTL='Y'">
        <xsl:attribute name="dir">RTL</xsl:attribute>
      </xsl:if>
            <xsl:choose>
              <xsl:when test="/mainpage/newsitems">
              <p class="news">
                <img class="newsicon" src="{concat($ROOT,'images/gentoo-new.gif')}" alt="Gentoo logo"/>
                <span class="newsitem" lang="zh_cn">We produce Gentoo Linux, a special flavor of Linux that
                can be automatically optimized and customized for just
                about any application or need. Extreme performance,
                configurability and a top-notch user and developer
                community are all hallmarks of the Gentoo experience.
                To learn more, read our <b><a href="/main/en/about.xml">about
                page</a></b>.</span>
              </p>
              <xsl:for-each select="document('/dyn/news-index.xml')/uris/uri[position()&lt;=$newsitemcount]/text()">
                <xsl:call-template name="newscontent">
                  <xsl:with-param name="thenews" select="document(.)/news"/>
                  <xsl:with-param name="summary" select="'yes'"/>
                  <xsl:with-param name="link" select="."/>
                </xsl:call-template>
              </xsl:for-each>
              <!-- Links to older news below news items -->
              <div class="news">
               <p class="newshead" lang="zh_cn">
                <b>Older News</b>
               </p>
               <ul>
                <xsl:for-each select="document('/dyn/news-index.xml')/uris/uri[position()&gt;$newsitemcount][position()&lt;20]/text()">
                 <xsl:variable name="newsuri" select="."/>
                 <li><b><a class="altlink" href="{$newsuri}"><xsl:value-of select="document(.)/news/title"/></a></b></li>
                </xsl:for-each>
               </ul>
              </div>
              </xsl:when>
              <xsl:when test="/news">
                <xsl:call-template name="newscontent">
                  <xsl:with-param name="thenews" select="/news"/>
                  <xsl:with-param name="summary" select="no"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
            <br/>
            <table border="0" class="content">
              <tr>
                <td>
                  <xsl:apply-templates select="chapter|devmap"/>
                </td>
              </tr>
            </table>
            <br/>
            <xsl:if test="/mainpage/license">
              <xsl:apply-templates select="license" />
            </xsl:if>
            <br/>
            <!--content end-->
    </td>
    <td width="1%" bgcolor="#dddaec" valign="top">
      <xsl:call-template name="rhcol"/>
    </td>
  </tr>
  <tr lang="zh_cn">
    <td align="right" class="infohead" colspan="3">
     <xsl:call-template name="copyright-footer"/>
    </td>
  </tr>
</table>

</body>
</html>
</xsl:template>

<xsl:template name="copyright-footer">
  <xsl:variable name="isEnglish">
    <xsl:if test="string-length($glang)=0 or $glang='en'">Y</xsl:if>
  </xsl:variable>
  <xsl:variable name="www">
    <xsl:if test="$httphost!='www'">http://www.gentoo.org</xsl:if>
  </xsl:variable>
  <xsl:variable name="contact">
   <xsl:choose>
    <xsl:when test="not($isEnglish='Y' or document(concat('/main/', $glang, '/contact.xml'))/missing)">
      <xsl:value-of select="concat('/main/', $glang, '/contact.xml')"/>
    </xsl:when>
    <xsl:otherwise>/main/en/contact.xml</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
Copyright <xsl:value-of select="substring(func:today(),1,4)"/> Gentoo中文. 有问
题和建议请<a class="highlight" href="{concat($www, $contact)}">联系我们</a>.
</xsl:template>

<!-- Mail template -->
<xsl:template match="mail">
 <xsl:variable name="mail">
  <xsl:call-template name="smart-mail">
   <xsl:with-param name="mail" select="."/>
  </xsl:call-template>
 </xsl:variable>

 <xsl:choose>
  <xsl:when test="string-length(exslt:node-set($mail)/mail/@link)>0">
   <a href="{concat('mailto:',exslt:node-set($mail)/mail/@link)}">
     <xsl:choose>
      <xsl:when test="name(..)='author'">
       <xsl:attribute name="class">altlink</xsl:attribute>
       <b><xsl:value-of select="exslt:node-set($mail)/mail/text()"/></b>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="exslt:node-set($mail)/mail/text()"/>
      </xsl:otherwise>
     </xsl:choose>
   </a>
  </xsl:when>
  <xsl:otherwise><xsl:value-of select="exslt:node-set($mail)/mail/text()"/></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- Author -->
<xsl:template match="author">
  <xsl:apply-templates/>
  <xsl:if test="@title">
    <xsl:if test="$style != 'printable'"><br/></xsl:if>
    <xsl:if test="$style  = 'printable'">&#160;</xsl:if>
    <i><xsl:value-of select="@title"/></i>
  </xsl:if>
  <br/>
  <xsl:if test="$style != 'printable' and position() != last()"><br/></xsl:if>
</xsl:template>

<!-- FAQ Index & Chapter -->
<xsl:template match="faqindex|chapter">
  <xsl:variable name="chid"><xsl:number count="faqindex|chapter"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="title">
      <p class="chaphead">
        <xsl:if test="@id"><a name="{@id}"/></xsl:if>
        <a name="doc_chap{$chid}"/>
        <xsl:if test="not(/mainpage) and (count(//faqindex)+count(//chapter))>1">
          <span class="chapnum"><xsl:value-of select="$chid"/>.&#160;</span>
        </xsl:if>
        <xsl:value-of select="title"/>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="/guide">
        <p class="chaphead">
          <span class="chapnum">
            <a name="doc_chap{$chid}"><xsl:number/>.</a>
          </span>
        </p>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="body">
    <xsl:with-param name="chid" select="$chid"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="section">
    <xsl:with-param name="chid" select="$chid"/>
  </xsl:apply-templates>

  <xsl:if test="name()='faqindex'">
    <!-- Generate FAQ index -->

    <xsl:for-each select="./following-sibling::chapter">
     <xsl:if test="section/title">
      <p class="secthead">
        <xsl:value-of select="title"/>
      </p>
      <xsl:variable name="nchap"><xsl:value-of select="1+position()"/></xsl:variable>
      <ul>
        <xsl:for-each select="section">
         <xsl:if test="title">
          <li>
           <a>
            <xsl:attribute name="href">
             <xsl:choose>
              <xsl:when test="@id">
               #<xsl:value-of select="@id"/>
              </xsl:when>
              <xsl:otherwise>
               <xsl:value-of select="concat('#doc_chap', $nchap, '_sect')"/><xsl:number/>
              </xsl:otherwise>
             </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="title"/>
           </a>
          </li>
         </xsl:if>
        </xsl:for-each>
      </ul>
     </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>


<!-- Section template -->
<xsl:template match="section">
<xsl:param name="chid"/>
<xsl:if test="title">
  <xsl:variable name="sectid">doc_chap<xsl:value-of select="$chid"/>_sect<xsl:number/></xsl:variable>
  <xsl:if test="@id">
    <a name="{@id}"/>
  </xsl:if>
  <p class="secthead">
    <a name="{$sectid}"><xsl:value-of select="title"/></a>
  </p>
</xsl:if>
<xsl:apply-templates select="body">
  <xsl:with-param name="chid" select="$chid"/>
</xsl:apply-templates>
</xsl:template>

<!-- Figure template -->
<xsl:template match="figure">
<xsl:param name="chid"/>
<xsl:variable name="fignum"><xsl:number level="any" from="chapter" count="figure"/></xsl:variable>
<xsl:variable name="figid">doc_chap<xsl:value-of select="$chid"/>_fig<xsl:value-of select="$fignum"/></xsl:variable>
<xsl:variable name="llink">
  <xsl:choose>
    <xsl:when test="starts-with(@link,'http://www.gentoo.org/')">
      <xsl:value-of select="concat($ROOT, substring-after(@link, 'http://www.gentoo.org/'))"/>
    </xsl:when>
    <xsl:when test="starts-with(@link,'/')">
      <xsl:value-of select="concat($ROOT, substring-after(@link, '/'))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<br/>
<a name="{$figid}"/>
<table cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td bgcolor="#7a5ada">
      <p class="codetitle">
        <xsl:choose>
          <xsl:when test="@caption">
            <xsl:value-of select="func:gettext('Figure')"/>&#160;<xsl:value-of select="$chid"/>.<xsl:value-of select="$fignum"/><xsl:value-of select="func:gettext('SpaceBeforeColon')"/>: <xsl:value-of select="@caption"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="func:gettext('Figure')"/>&#160;<xsl:value-of select="$chid"/>.<xsl:value-of select="$fignum"/>
          </xsl:otherwise>
        </xsl:choose>
      </p>
    </td>
  </tr>
  <tr>
    <td align="center" bgcolor="#ddddff">
      <xsl:choose>
        <xsl:when test="@short">
          <img src="{$llink}" alt="Fig. {$fignum}: {@short}"/>
        </xsl:when>
        <xsl:otherwise>
          <img src="{$llink}" alt="Fig. {$fignum}"/>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</table>
<br/>
</xsl:template>

<!--figure without a caption; just a graphical element-->
<xsl:template match="fig">
  <xsl:variable name="llink">
    <xsl:choose>
      <xsl:when test="starts-with(@link,'http://www.gentoo.org/')">
        <xsl:value-of select="concat($ROOT, substring-after(@link, 'http://www.gentoo.org/'))"/>
      </xsl:when>
      <xsl:when test="starts-with(@link,'/')">
        <xsl:value-of select="concat($ROOT, substring-after(@link, '/'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@link"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <center>
    <xsl:choose>
      <xsl:when test="@linkto">
        <a href="{@linkto}"><img border="0" src="{$llink}" alt="{@short}"/></a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$llink}" alt="{@short}"/>
      </xsl:otherwise>
    </xsl:choose>
  </center>
</xsl:template>

<xsl:template match="devmap">
  <h1>Gentoo Developers Map</h1>
  <p id="map" style="height:460px"/>
  <br/>
  <table id="devlinks" style="width:100%"/>
</xsl:template>

<!-- Line break -->
<xsl:template match="br">
<br/>
</xsl:template>

<!-- Note -->
<xsl:template match="note">
 <xsl:if test="not(@test) or dyn:evaluate(@test)">
  <table class="ncontent" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td bgcolor="#bbffbb">
        <p class="note">
          <b><xsl:value-of select="func:gettext('Note')"/>: </b>
          <xsl:apply-templates/>
        </p>
      </td>
    </tr>
  </table>
 </xsl:if>
</xsl:template>

<!-- Important item -->
<xsl:template match="impo">
 <xsl:if test="not(@test) or dyn:evaluate(@test)">
  <table class="ncontent" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td bgcolor="#ffffbb">
        <p class="note">
          <b><xsl:value-of select="func:gettext('Important')"/>: </b>
          <xsl:apply-templates/>
        </p>
      </td>
    </tr>
  </table>
 </xsl:if>
</xsl:template>

<!-- Warning -->
<xsl:template match="warn">
 <xsl:if test="not(@test) or dyn:evaluate(@test)">
  <table class="ncontent" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td bgcolor="#ffbbbb">
        <p class="note">
          <b><xsl:value-of select="func:gettext('Warning')"/>: </b>
          <xsl:apply-templates/>
        </p>
      </td>
    </tr>
  </table>
 </xsl:if>
</xsl:template>

<!-- Code note -->
<xsl:template match="codenote">
<span class="comment">
  <xsl:if test='not(starts-with(., "("))'>(</xsl:if>
  <xsl:apply-templates/>
  <xsl:if test='not(starts-with(., "("))'>)</xsl:if>
</span>
</xsl:template>

<!-- Regular comment -->
<xsl:template match="comment">
<span class="code-comment"><xsl:apply-templates/></span>
</xsl:template>

<!-- Colour coding inside <pre> -->
<xsl:template match="i">
<span class="code-input"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="var">
<span class="code-variable"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="ident">
<span class="code-identifier"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="keyword">
<span class="code-keyword"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="stmt">
<span class="code-statement"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="const">
<span class="code-constant"><xsl:apply-templates/></span>
</xsl:template>


<!-- Bold -->
<xsl:template match="b">
<b><xsl:apply-templates/></b>
</xsl:template>

<!-- Superscript -->
<xsl:template match="sup">
  <sup><xsl:apply-templates/></sup>
</xsl:template>

<!-- Subscript -->
<xsl:template match="sub">
  <sub><xsl:apply-templates/></sub>
</xsl:template>

<!-- Brite -->
<xsl:template match="brite">
<font color="#ff0000">
  <b><xsl:apply-templates/></b>
</font>
</xsl:template>

<!-- Body -->
<xsl:template match="body">
<xsl:param name="chid"/>
 <xsl:if test="not(@test) or dyn:evaluate(@test)">
  <xsl:apply-templates>
    <xsl:with-param name="chid" select="$chid"/>
  </xsl:apply-templates>
 </xsl:if>
</xsl:template>

<!-- Command or input, not to use inside <pre> -->
<xsl:template match="c">
<span class="code" dir="ltr"><xsl:apply-templates/></span>
</xsl:template>

<!-- Preserve whitespace, aka Code Listing -->
<xsl:template match="pre">
<xsl:param name="chid"/>
  <xsl:if test="not(@test) or dyn:evaluate(@test)">
    <xsl:variable name="prenum"><xsl:number level="any" from="chapter" count="pre[not(ancestor-or-self::*[@test and not(dyn:evaluate(@test))])]"/></xsl:variable>
    <xsl:variable name="preid">doc_chap<xsl:value-of select="$chid"/>_pre<xsl:value-of select="$prenum"/></xsl:variable>
    <a name="{$preid}"/>
    <table class="ntable" width="100%" cellspacing="0" cellpadding="0" border="0">
      <tr>
        <td bgcolor="#7a5ada">
          <p class="codetitle">
          <xsl:value-of select="func:gettext('CodeListing')"/>&#160;<xsl:if test="$chid"><xsl:value-of select="$chid"/>.</xsl:if><xsl:value-of select="$prenum"/>
          <xsl:if test="@caption">
            <xsl:value-of select="func:gettext('SpaceBeforeColon')"/>: <xsl:value-of select="@caption"/>
          </xsl:if>
          </p>
        </td>
      </tr>
      <tr>
        <td bgcolor="#eeeeff" align="left" dir="ltr">
          <pre>
            <xsl:apply-templates/>
          </pre>
        </td>
      </tr>
    </table>
  </xsl:if>
</xsl:template>

<!-- Path -->
<xsl:template match="path">
<span class="path" dir="ltr"><xsl:apply-templates/></span>
</xsl:template>

<!-- Url -->
<xsl:template match="uri">
<xsl:param name="paramlink"/>
<!-- expand templates to handle things like <uri link="http://bar"><c>foo</c></uri> -->
<xsl:choose>
  <xsl:when test="@link">
    <xsl:choose>
      <xsl:when test="($TTOP = 'sections') and (starts-with(@link, '?'))">
        <!-- Handbook link pointing to another part/chapter when viewing a single page,
             cannot be a link because we have no idea where to link to
             Besides, we have no way of knowing the language unless told via a param -->
          <xsl:variable name="nolink"><xsl:value-of select="func:gettext('hb_file', $glang)"/></xsl:variable>
          <span title="{$nolink}"><font color="#404080">(<xsl:apply-templates/>)</font></span>
      </xsl:when>
      <xsl:when test="($TTOP = 'book') and ($full = 0) and (starts-with(@link, '?'))">
        <!-- Handbook link pointing to another part/chapter, normal case -->
        <xsl:choose>
          <xsl:when test="$style != 'printable'">
            <a href="{$link}{@link}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$link}{@link}&amp;style=printable"><xsl:apply-templates/></a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="($TTOP = 'book') and ($full = 1) and (starts-with(@link, '?'))">
        <!-- Handbook link pointing to another part/chapter
             Handbook is being rendered in a single page (full=1)
             Hence link needs to be rewritten as a local one
             i.e. ?part=1&chap=3#doc_chap1 must become #book_part1_chap3__chap1   Case 1a
             i.e. ?part=1&chap=3#anID      must become #anID                      Case 1b
             or   ?part=1&chap=3           must become #book_part1_chap3          Case 2
             or   ?part=2                  must become #book_part2                Case 3-->
        <xsl:choose>
          <xsl:when test="contains(@link, 'chap=') and contains(@link, '#doc_')">
            <!-- Link points inside a chapter  (Case 1a)-->
            <xsl:variable name="linkpart" select="substring-after(substring-before(@link, '&amp;'), '=')" />
            <xsl:variable name="linkchap" select="substring-before(substring-after(substring-after(@link, '&amp;'), '='), '#doc_')" />
            <xsl:variable name="linkanch" select="substring-after(@link, '#doc_')" />
            <a href="#book_part{$linkpart}_chap{$linkchap}__{$linkanch}"><xsl:apply-templates /></a>
          </xsl:when>
          <xsl:when test="contains(@link, 'chap=') and contains(@link, '#')">
            <!-- Link points inside a chapter via an ID (Case 1b)
                 (IDs are expected to be unique throughout a handbook) -->
            <xsl:variable name="linkanch" select="substring-after(@link, '#')" />
            <a href="#{$linkanch}"><xsl:apply-templates /></a>
          </xsl:when>
          <xsl:when test="contains(@link, 'chap=')">
            <!-- Link points to a chapter  (Case 2)-->
            <xsl:variable name="linkpart" select="substring-after(substring-before(@link, '&amp;'), '=')" />
            <xsl:variable name="linkchap" select="substring-after(substring-after(@link, '&amp;'), '=')" />
            <a href="#book_part{$linkpart}_chap{$linkchap}"><xsl:apply-templates /></a>
          </xsl:when>
          <xsl:otherwise>
            <!-- Link points to a part  (Case 3)-->
            <xsl:variable name="linkpart" select="substring-after(@link, '=')" />
            <a href="#book_part{$linkpart}"><xsl:apply-templates/></a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="($TTOP = 'book') and ($full = 1) and (starts-with(@link, '#'))">
        <!-- Handbook link pointing to another place in same part/chapter
             Handbook is being rendered in a single page (full=1)
             Hence link needs to be rewritten as an internal one that is unique
             for the whole handbook, i.e.
             #doc_part1_chap3 becomes #book_{UNIQUEID}_part1_chap3, but
             #anything_else_like_an_ID is left unchanged (IDs are expected to be unique throughout a handbook)-->
        <xsl:choose>
          <xsl:when test="starts-with(@link, '#doc_')">
            <xsl:variable name="locallink" select="substring-after(@link, 'doc_')" />
            <a href="#book_{generate-id(/)}_{$locallink}"><xsl:apply-templates /></a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{@link}"><xsl:apply-templates/></a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="theurl">
          <xsl:choose>
            <xsl:when test="@link"><xsl:value-of select="@link" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="text()" /></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="thelink">
          <xsl:choose>
            <xsl:when test="name(..)='insert' and $theurl='$redirect' and $paramlink"><xsl:value-of select="$paramlink" /></xsl:when>
            <xsl:when test="name(..)='insert' and $theurl='$originalversion' and $paramlink">
              <xsl:variable name="temp">
                <xsl:value-of select="$paramlink"/>
                <xsl:if test="$style = 'printable'">&amp;style=printable</xsl:if>
                <xsl:if test="$full != '0'">&amp;full=1</xsl:if>
                <xsl:if test="$part != '0'">&amp;part=<xsl:value-of select="$part"/></xsl:if>
                <xsl:if test="$chap != '0'">&amp;chap=<xsl:value-of select="$chap"/></xsl:if>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="contains($temp, '&amp;')">
                  <xsl:value-of select="concat(substring-before($temp,'&amp;'), '?', substring-after($temp,'&amp;'))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$temp"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$theurl" /></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Strip http://www.gentoo.org from links if running on www.g.o
             Has no effect on actual www.g.o but helps when surfing on a local copy as long as httphost is set to www as well
             Rewrite http://www.gentoo.org/cgi-bin/viewcvs/ to use sources.gentoo.org/
          -->
        <xsl:variable name="llink">
          <xsl:choose>
            <xsl:when test="starts-with($thelink, 'http://www.gentoo.org/cgi-bin/viewcvs.cgi')"><xsl:value-of select="concat('http://sources.gentoo.org/viewcvs.py', substring-after($thelink, 'http://www.gentoo.org/cgi-bin/viewcvs.cgi'))" /></xsl:when>
            <xsl:when test="starts-with($thelink, '/cgi-bin/viewcvs.cgi')"><xsl:value-of select="concat('http://sources.gentoo.org/viewcvs.py', substring-after($thelink, '/cgi-bin/viewcvs.cgi'))" /></xsl:when>
            <xsl:when test="$httphost='www' and starts-with($thelink, 'http://www.gentoo.org/')"><xsl:value-of select="substring-after($thelink, 'http://www.gentoo.org')" /></xsl:when>
            <xsl:when test="not($httphost='www') and starts-with($thelink, '/') and not(starts-with($thelink, '/~'))"><xsl:value-of select="concat('http://www.gentoo.org', $thelink)" /></xsl:when>
            <!-- Add catid to links to /doc/LL/index.xml -->
            <xsl:when test="$catid != '0' and starts-with($thelink, '/doc/') and (substring-after(substring-after($thelink, '/doc/'), '/')='' or substring-after(substring-after($thelink, '/doc/'), '/')='index.xml')">
              <xsl:value-of select="concat($thelink, '?catid=', $catid)"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$thelink" /></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Now, insert style=printable in the URL if necessary -->
        <xsl:variable name="alink">
          <xsl:choose>
          <xsl:when test="$style != 'printable'  or  contains($llink, 'style=printable')">
            <!-- Not printable style or style=printable already in URL, copy link -->
            <xsl:value-of select="$llink" />
          </xsl:when>
          <xsl:when test="contains($llink, '://')">
            <!-- External link, copy link -->
            <xsl:value-of select="$llink" />
          </xsl:when>
          <xsl:when test="starts-with($llink, '#')">
            <!-- Anchor, copy link -->
            <xsl:value-of select="$llink" />
          </xsl:when>
          <xsl:otherwise>
            <!--  We should have eliminated all other cases,
                  style printable, local link, then insert ?style=printable -->
            <xsl:choose>
              <xsl:when test="starts-with($llink, '?')">
                <xsl:value-of select="concat( '?style=printable&amp;', substring-after($llink, '?'))" />
              </xsl:when>
              <xsl:when test="contains($llink, '.xml?')">
                <xsl:value-of select="concat(substring-before($llink, '.xml?'), '.xml?style=printable&amp;', substring-after($llink, '.xml?'))" />
              </xsl:when>
              <xsl:when test="contains($llink, '.xml#')">
                <xsl:value-of select="concat(substring-before($llink, '.xml#'), '.xml?style=printable#', substring-after($llink, '.xml#'))" />
              </xsl:when>
              <xsl:when test="substring-after($llink, '.xml') = ''">
                <xsl:value-of select="concat($llink, '?style=printable')" />
              </xsl:when>
              <xsl:otherwise>
                <!-- Have I forgotten anything?
                     Copy link -->
                <xsl:value-of select="$llink" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a href="{$alink}"><xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="loc" select="."/>
    <a href="{$loc}"><xsl:apply-templates/></a>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- Paragraph -->
<xsl:template match="p">
<xsl:param name="chid"/>
 <xsl:if test="not(@test) or dyn:evaluate(@test)">
  <p>
    <!-- Keep this for old files with <p class="secthead"> -->
    <xsl:if test="@class">
      <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
    </xsl:if>

    <xsl:if test="@by">
      <xsl:attribute name="class">epigraph</xsl:attribute>
    </xsl:if>

    <xsl:apply-templates>
      <xsl:with-param name="chid" select="$chid"/>
    </xsl:apply-templates>

    <xsl:if test="@by">
      <br/><br/><span class="episig">—<xsl:value-of select="@by"/></span><br/><br/>
    </xsl:if>
  </p>
 </xsl:if>
</xsl:template>

<!-- Emphasize -->
<xsl:template match="e">
  <span class="emphasis"><xsl:apply-templates/></span>
</xsl:template>

<!-- Table -->
<xsl:template match="table">
  <xsl:if test="not(@test) or dyn:evaluate(@test)">
    <table class="ntable">
      <xsl:apply-templates/>
    </table>
  </xsl:if>
</xsl:template>

<!-- Table Row -->
<xsl:template match="tr">
  <xsl:if test="not(@test) or dyn:evaluate(@test)">
    <tr>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:template match="tcolumn">
<col width="{@width}"/>
</xsl:template>

<!-- Table Item -->
<xsl:template match="ti">
<td class="tableinfo">
  <xsl:if test="@align='center' or @align='right'">
    <xsl:attribute name="style"><xsl:value-of select="concat('text-align:',@align)"/></xsl:attribute>
  </xsl:if>
  <xsl:if test="@colspan">
    <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
  </xsl:if>
  <xsl:if test="@rowspan">
    <xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
</td>
</xsl:template>

<!-- Table Heading, no idea why <th> hasn't been used -->
<xsl:template match="th">
<td class="infohead">
  <xsl:if test="@colspan">
    <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
    <!-- Center only when item spans several columns as
         centering all <th> might disrupt some pages.
         We might want to use a plain html <th> tag later.
         Tip: to center a single-cell title, use <th colspan="1">
       -->
    <xsl:attribute name="style">text-align:center</xsl:attribute>
  </xsl:if>
  <xsl:if test="@rowspan">
    <xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
  </xsl:if>
  <b>
    <xsl:apply-templates/>
  </b>
</td>
</xsl:template>

<!-- Unnumbered List -->
<xsl:template match="ul">
  <xsl:if test="not(@test) or dyn:evaluate(@test)">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:if>
</xsl:template>

<!-- Ordered List -->
<xsl:template match="ol">
  <xsl:if test="not(@test) or dyn:evaluate(@test)">
    <ol>
      <xsl:apply-templates/>
    </ol>
  </xsl:if>
</xsl:template>

<!-- List Item -->
<xsl:template match="li">
  <xsl:if test="not(@test) or dyn:evaluate(@test)">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:if>
</xsl:template>

<!-- Definition Lists -->
<xsl:template match="dl">
<dl><xsl:apply-templates/></dl>
</xsl:template>

<xsl:template match="dt">
<dt><xsl:apply-templates/></dt>
</xsl:template>

<xsl:template match="dd">
<dd><xsl:apply-templates/></dd>
</xsl:template>

<!-- NOP -->
<xsl:template match="ignoreinemail">
<xsl:apply-templates/>
</xsl:template>

<!-- NOP -->
<xsl:template match="ignoreinguide">
</xsl:template>

<!-- License Tag -->
<xsl:template match="license">
<p class="copyright">
  <!-- Test for RTL languages -->
  <xsl:if test="$RTL='Y'">
    <xsl:attribute name="dir">RTL</xsl:attribute>
  </xsl:if>
  <xsl:apply-templates select="func:gettext('License')"/>
</p>
<xsl:comment>
  &lt;rdf:RDF xmlns="http://web.resource.org/cc/"
      xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"&gt;
  &lt;License rdf:about="http://creativecommons.org/licenses/by-sa/2.5/"&gt;
     &lt;permits rdf:resource="http://web.resource.org/cc/Reproduction" /&gt;
     &lt;permits rdf:resource="http://web.resource.org/cc/Distribution" /&gt;
     &lt;requires rdf:resource="http://web.resource.org/cc/Notice" /&gt;
     &lt;requires rdf:resource="http://web.resource.org/cc/Attribution" /&gt;
     &lt;permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" /&gt;
     &lt;requires rdf:resource="http://web.resource.org/cc/ShareAlike" /&gt;
  &lt;/License&gt;
  &lt;/rdf:RDF&gt;
</xsl:comment>
</xsl:template>

<!-- GLEP index -->
<xsl:template match="glepindex">
 <table class="ntable">
 <tr>
   <td class="infohead">Number</td><td class="infohead">Type</td><td class="infohead">Status</td><td class="infohead">Title</td>
 </tr>
  <xsl:apply-templates select="document(@index)/gleps/glep">
    <xsl:with-param name="status" select="string(@status)"/>
  </xsl:apply-templates>
 </table>
</xsl:template>

<!-- One GLEP table row -->
<xsl:template match="glep">
<xsl:param name="status" select="''"/>
 <xsl:if test="string-length($status)=0 or contains($status, @status)">
  <tr>
   <td class="tableinfo"><a href="{@file}"><xsl:value-of select="@id"/></a></td>
   <td class="tableinfo"><xsl:value-of select="@type"/></td>
   <td class="tableinfo"><xsl:value-of select="@status"/></td>
   <td class="tableinfo"><xsl:apply-templates select="node()"/></td>
  </tr>
 </xsl:if>
</xsl:template>


<!-- GLSA Index -->
<xsl:template match="glsaindex">
  <xsl:apply-templates select="document('/dyn/glsa-index.xml')/guide/chapter[1]/section[1]/body"/>
</xsl:template>

<!-- GLSA Latest (max 10) -->
<xsl:template match="glsa-latest">
  <xsl:variable name="src" select="'/dyn/glsa-index.xml'"/>
  <table>
  <xsl:for-each select="document($src)/guide/chapter[1]/section[1]/body/table[1]/tr[position()&lt;11]">
    <tr><xsl:apply-templates/></tr>
  </xsl:for-each>
  </table>
</xsl:template>


<!-- Compare versions between two documents, scan handbooks if need be -->
<xsl:template name="compare-versions">
<xsl:param name="original"/>
<xsl:param name="translation"/>
  <xsl:choose>
    <xsl:when test="$original/book and $translation/book">
    <!-- /book == /book -->
      <xsl:choose>
        <xsl:when test="$full != 0">
        <!-- if full != 0, then compare all files -->
          <!-- Compare versions in master files -->
          <xsl:if test="$original/book/version != $translation/book/version">X</xsl:if>
          <!-- Compare versions in original chapters vs. translated chapters that have the same position -->
          <xsl:for-each select="$original/book/part">
            <xsl:variable name="part" select="position()"/>
            <xsl:for-each select="chapter">
              <xsl:variable name="chap" select="position()"/>
              <xsl:variable name="ov" select="document($original/book/part[$part]/chapter[$chap]/include/@href)/sections/version"/>
              <xsl:variable name="tv" select="document($translation/book/part[$part]/chapter[$chap]/include/@href)/sections/version"/>
              <xsl:if test="$ov != $tv or not($tv)">X</xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$part = '0' or $chap = '0'">
        <!-- Table of contents, check master file -->
          <xsl:if test="$original/book/version != $translation/book/version">X</xsl:if>
        </xsl:when>
        <xsl:otherwise>
        <!-- Compare chapters at same position (/$part/$chap/) in English handbook and in translated one -->
          <xsl:variable name="ov" select="document($original/book/part[position()=$part]/chapter[position()=$chap]/include/@href)/sections/version"/>
          <xsl:variable name="tv" select="document($translation/book/part[position()=$part]/chapter[position()=$chap]/include/@href)/sections/version"/>
          <xsl:if test="$ov != $tv or not($tv)">X</xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$original/guide and $translation/guide">
    <!-- /guide == /guide -->
      <xsl:if test="$original/guide/version != $translation/guide/version">X</xsl:if>
    </xsl:when>
    <xsl:when test="$original/mainpage and $translation/mainpage">
      <xsl:if test="$original/mainpage/version != $translation/mainpage/version">X</xsl:if>
    </xsl:when>
    <xsl:when test="$original/sections and $translation/sections">
      <xsl:if test="$original/sections/version != $translation/sections/version">X</xsl:if>
    </xsl:when>
    <!-- If we did not compare book==book, mainpage==mainpage or guide==guide, then consider versions are different -->
    <xsl:otherwise>X</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Return the date of a document, for handbooks, it is the max(main file date, all included parts dates) -->
<xsl:template name="maxdate">
  <xsl:param name="thedoc"/>
  <xsl:choose>
    <xsl:when test="$thedoc/book">
      <!-- In a book: look for max(/date, include_files/sections/date) -->
      <xsl:for-each select="$thedoc/book/part/chapter/include">
        <xsl:sort select="document(@href)/sections/date" order="descending" />
        <xsl:if test="position() = 1">
          <!-- Compare the max(date) from included files with the date in the master file
               Of course, XSLT 1.0 knows no string comparison operator :-(
               So we build a node set with the two dates and we sort it.
            -->
          <xsl:variable name="theDates">
            <xsl:element name="bookDate">
              <xsl:value-of select="$thedoc/book/date"/>
            </xsl:element>
            <xsl:element name="maxChapterDate">
              <xsl:value-of select="document(@href)/sections/date"/>
            </xsl:element>
          </xsl:variable>
          <xsl:variable name="sortedDates">  
            <xsl:for-each select="exslt:node-set($theDates)/*">  
              <xsl:sort select="." order="descending" />
              <xsl:copy-of select="."/>
            </xsl:for-each>   
          </xsl:variable>
          <!-- First date is the one we want -->
          <xsl:value-of select="exslt:node-set($sortedDates)/*[position()=1]"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="$thedoc/guide or $thedoc/sections or $thedoc/mainpage or $thedoc/news">
      <xsl:value-of select="$thedoc/*[1]/date"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="contentdate">
  <xsl:variable name="docdate">
    <xsl:call-template name="maxdate">
      <xsl:with-param name="thedoc" select="/"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="func:gettext('Updated')/docdate">
      <xsl:apply-templates select="func:gettext('Updated')">
        <xsl:with-param name="docdate" select="$docdate"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(func:gettext('Updated'),' ')"/> <xsl:copy-of select="func:format-date($docdate)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="outdated-translation">
  <!-- Add mention that translation is outdated whenever possible in /main and /doc-->
  <xsl:if test="$glang != '' and not (//*[1]/@metadoc = 'yes') and (starts-with($link, '/doc/') or starts-with($link, '/main/') or (starts-with($link, '/proj/') and contains($link, '/gdp/'))) and not(starts-with($link, '/doc/en/') or starts-with($link, '/main/en/') or starts-with($link, '/proj/en/'))">
    <!-- We have a translation, is it up-to-date? -->
    <xsl:variable name="metadoc" select="document(concat('/doc/', $glang, '/metadoc.xml'))"/>
    <xsl:variable name="fileid" select="$metadoc/metadoc/files/file[text()=$link]/@id"/>
    <xsl:choose>
      <xsl:when test="not($fileid)">
        <!-- File is not even listed in local metadoc.xml -->
        <xsl:value-of select="func:gettext('NoIndex')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="pmetadoc" select="document($metadoc/metadoc/@parent)"/>
        <xsl:choose>
          <xsl:when test="not($pmetadoc/metadoc/files/file[@id=$fileid])">
            <!-- File is not listed in original metadoc.xml -->
            <xsl:value-of select="func:gettext('NoOriginal')"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Document is listed in both local metadoc.xml and English one, compare version numbers -->
            <xsl:variable name="pfile" select="$pmetadoc/metadoc/files/file[@id=$fileid]"/>
            <xsl:variable name="versions">
              <xsl:call-template name="compare-versions">
                <xsl:with-param name="original" select ="document($pfile)"/>
                <xsl:with-param name="translation" select ="/"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="string-length($versions) > 0">
              <xsl:variable name="pdocdate">
                <xsl:call-template name="maxdate">
                  <xsl:with-param name="thedoc" select="document($pfile)"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:variable name="res">
                <xsl:apply-templates select="func:gettext('Outdated')">
                  <xsl:with-param name="docdate" select="$pdocdate"/>
                  <xsl:with-param name="paramlink" select="$pfile"/>
                </xsl:apply-templates>
              </xsl:variable>
              <xsl:copy-of select="$res"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="docdate">
<xsl:param name="docdate"/>
  <xsl:copy-of select="func:format-date($docdate)"/>
</xsl:template>


<xsl:template name="rhcol">
<!-- Right-hand column with date/authors/ads -->

  <xsl:variable name="images">
    <!-- Source images from www.gentoo.org when on another server to
         prevent missing images after an update -->
    <xsl:choose>
      <xsl:when test="$httphost != 'www'">http://www.gentoo.org/</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$ROOT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <table border="0" cellspacing="4px" cellpadding="4px">
    <!-- Add a "printer-friendly" button when link attribute exists -->
    <xsl:if test="/book or /guide">
     <tr>
      <td class="topsep" align="center">
        <p class="altmenu">
          <xsl:variable name="PrintTip"><xsl:value-of select="func:gettext('PrintTip')"/></xsl:variable>
          <xsl:variable name="href">
            <xsl:choose>
              <xsl:when test="/book and $full != 0">
                <xsl:value-of select="concat($link, '?full=1&amp;style=printable')"/>
              </xsl:when>
              <xsl:when test="/book">
                <xsl:value-of select="concat($link, '?style=printable')"/>
                <xsl:if test="$part != '0'">&amp;part=<xsl:value-of select="$part"/></xsl:if>
                <xsl:if test="$chap != '0'">&amp;chap=<xsl:value-of select="$chap"/></xsl:if>
              </xsl:when>
              <xsl:when test="/guide">
                <xsl:value-of select="concat($link, '?style=printable')"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <a title="{$PrintTip}" class="altlink" href="{$href}"><xsl:value-of select="func:gettext('Print')"/></a>
        </p>
      </td>
     </tr>
    </xsl:if>
    <xsl:if test="/book/date or /guide/date or /sections/date or /mainpage/date or /news/date">
      <tr>
        <td class="topsep">
          <!-- Test for RTL languages -->
          <xsl:choose>
            <xsl:when test="$RTL='Y'">
              <xsl:attribute name="dir">RTL</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="align">center</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <p class="alttext">
          <xsl:call-template name="contentdate"/>
          </p>
        </td>
      </tr>
      <xsl:if test="/book/date or /guide/date or /sections/date or /mainpage/date">
        <xsl:variable name="outdated">
          <xsl:call-template name="outdated-translation"/>
        </xsl:variable>
        <xsl:if test="string-length($outdated) &gt; 1">
          <tr>
            <td class="topsep">
              <!-- Test for RTL languages -->
              <xsl:choose>
                <xsl:when test="$RTL='Y'">
                  <xsl:attribute name="dir">RTL</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="align">left</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>

              <p class="alttext">
                <b><xsl:copy-of select="$outdated"/></b>
              </p>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
    </xsl:if>
    <xsl:if test="abstract or document(include/@href)/*[1]/abstract">
      <tr>
        <td class="topsep">
          <!-- Test for RTL languages -->
          <xsl:choose>
            <xsl:when test="$RTL='Y'">
              <xsl:attribute name="dir">RTL</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="align">left</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <p class="alttext">
            <!-- Abstract (summary) of the document -->
            <b><xsl:value-of select="func:gettext('Summary')"/>: </b>
            <xsl:choose>
              <xsl:when test="abstract">
                <xsl:value-of select="abstract" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="document(include/@href)/*[1]/abstract" />
              </xsl:otherwise>
            </xsl:choose>
          </p>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="/book/author or /guide/author">
    <tr>
      <td align="left" class="topsep">
        <p class="alttext">
          <!-- Authors -->
          <xsl:apply-templates select="/guide/author|/book/author"/>
        </p>
      </td>
    </tr>
    </xsl:if>

      <tr lang="zh_cn">
      <td align="center" class="topsep">
        <p class="alttext">
          <b>Donate</b> to support our development efforts.
        </p>

        <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
          <input type="hidden" name="cmd" value="_xclick"/>
          <input type="hidden" name="business" value="paypal@gentoo.org"/>
          <input type="hidden" name="item_name" value="Gentoo Linux Support"/>
          <input type="hidden" name="item_number" value="1000"/>
          <input type="hidden" name="image_url" value="/images/paypal.png"/>
          <input type="hidden" name="no_shipping" value="1"/>
          <input type="hidden" name="return" value="http://www.gentoo.org"/>
          <input type="hidden" name="cancel_return" value="http://www.gentoo.org"/>

          <input type="image" src="http://images.paypal.com/images/x-click-but21.gif" name="submit" alt="Donate to Gentoo"/>
        </form>
      </td>
    </tr>
    <tr>
    <td align="center" class="topsep">
    <script type="text/javascript">&lt;!--
           google_ad_client = "pub-3740337540082957";
           google_ad_width = 120;
           google_ad_height = 600;
           google_ad_format = "120x600_as";
           google_ad_type = "text_image";
           //2007-10-06: HomeRightSkyscpIsAGeek
           google_ad_channel = "1077535397";
           google_color_border = "CCCCCC";
           google_color_bg = "CCCCCC";
           google_color_link = "000000";
           google_color_text = "333333";
           google_color_url = "666666";
           google_ui_features = "rc:0";
           //-->
    </script>
    <script type="text/javascript"
             src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
    </script>
    </td>
    </tr>
  </table>
</xsl:template>

<xsl:template name="newscontent">
<xsl:param name="thenews"/>
<xsl:param name="summary"/>
<xsl:param name="link"/>

  <div class="news">
    <p class="newshead" lang="zh_cn">
      <b><xsl:value-of select="$thenews/title"/></b>
      <br/>
      <font size="0.90em">
      发布于<xsl:copy-of select="func:format-date($thenews/date)"/>，
      作者<xsl:value-of select="$thenews/poster"/>
      </font>
    </p>
    
    <xsl:choose>
      <xsl:when test="$thenews/@category='alpha'">
        <img class="newsicon" src="/images/icon-alpha.gif" alt="AlphaServer GS160"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='kde'">
        <img class="newsicon" src="/images/icon-kde.png" alt="KDE"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='gentoo'">
        <img class="newsicon" src="/images/icon-gentoo.png" alt="gentoo"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='main'">
        <img class="newsicon" src="/images/icon-stick.png" alt="stick man"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='ibm'">
        <img class="newsicon" src="/images/icon-ibm.gif" alt="ibm"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='linux'">
        <img class="newsicon" src="/images/icon-penguin.png" alt="tux"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='moo'">
        <img class="newsicon" src="/images/icon-cow.png" alt="Larry the Cow"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='plans'">
        <img class="newsicon" src="/images/icon-clock.png" alt="Clock"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='nvidia'">
        <img class="newsicon" src="/images/icon-nvidia.png" alt="Nvidia"/>
      </xsl:when>
      <xsl:when test="$thenews/@category='freescale'">
        <img class="newsicon" src="/images/icon-freescale.gif" alt="Freescale Semiconductor"/>
      </xsl:when>
    </xsl:choose>
                  
    <div class="newsitem">
    <xsl:choose>
      <xsl:when test="$thenews/summary and $summary='yes'">
        <xsl:apply-templates select="$thenews/summary"/>
        <br/>
        <a href="{$link}"><b>(full story)</b></a>
      </xsl:when>
      <xsl:when test="$thenews/body">
        <xsl:apply-templates select="$thenews/body"/>
      </xsl:when>
    </xsl:choose>
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
