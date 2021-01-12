<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    version="2.0">
    <xsl:param name="metaFile" select="document('meta.xml')"/>
    <xsl:param name="contentFile" select="document('content.xml')"/>
    <!--<xsl:output method="xml" indent="yes" />-->
    
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="/">
        <xsl:result-document href="output.xml" method="xml" indent="yes">
         <TEI>
             <teiHeader>
                 <fileDesc>
                     <titleStmt>
                         <title><xsl:value-of select="$metaFile/office:document-meta/office:meta/dc:title"/></title>
                     </titleStmt>
                     <publicationStmt>
                         <authority/>
                         <availability><p><xsl:value-of select="$metaFile/office:document-meta/office:meta/meta:user-defined[@meta:name='Licence']"/></p></availability>
                         <date><xsl:value-of select="$metaFile/office:document-meta/office:meta/meta:user-defined[@meta:name='Date de publication']"/></date>
                       
                     </publicationStmt>
                     <sourceDesc>
                         <bibl>
                             <xsl:apply-templates select="$metaFile/office:document-meta"/>
                         </bibl>
                         </sourceDesc>
                 </fileDesc>
        
                 <encodingDesc>
                     <projectDesc><p><xsl:value-of select="$metaFile/office:document-meta/office:meta/meta:user-defined[@meta:name='Description']"/></p></projectDesc>
                 </encodingDesc>
                 
             </teiHeader>
             <text>
                 <body>
                     <head><xsl:value-of select="$contentFile/office:document-content/office:body/office:text/text:p[@text:style-name='Title']/text()"/></head>
                     <xsl:apply-templates select="$contentFile/office:document-content"/>
                 </body>
             </text>
         </TEI>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="office:document-meta">
        <xsl:apply-templates  select="./office:meta/dc:title"/>
        <xsl:apply-templates  select="./office:meta/meta:user-defined"/>
    </xsl:template>
    <xsl:template match="dc:title">
        <title>
            <xsl:value-of select="./text()"/>
        </title>
    </xsl:template>
    <xsl:template match="meta:user-defined">
        <xsl:choose>
            <xsl:when test=".[@meta:name='Auteur']">
                <author><xsl:value-of select="text()"/></author>
            </xsl:when>
            <xsl:when test=".[@meta:name='Source']">
                <bibl><xsl:value-of select="text()"/></bibl>
            </xsl:when>
            <xsl:when test=".[@meta:name='Date de la source']">
                <date><xsl:value-of select="text()"/></date>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- file content.xml -->
    <xsl:template match="office:document-content">
        <xsl:apply-templates select="./office:body/office:text"/>
    </xsl:template>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//text:span">
        <xsl:variable name="font" select="./@text:style-name/data()"/>
        <hi rend='{$font}'><xsl:apply-templates select="node()[not(self::text:style-name)]"/></hi>
    </xsl:template>

    <xsl:template match="office:text">
        <xsl:variable name="nextOne" select="./text:h[1]"/>
        <xsl:choose>
            <xsl:when test="$nextOne[@text:style-name[contains(.,'Heading')] and @text:outline-level='1']">
                <xsl:for-each select="./text:h[@text:outline-level='1']">
                    <xsl:variable name="counter1" select="./@text:outline-level"/>
                    <xsl:variable name="header-id" select="generate-id(.)"/>
                    <div n="{$counter1}">
                        <head><xsl:value-of select="text()"/></head>
                        <xsl:if test="./following-sibling::text:p[1][@text:style-name='citation']">
                            <quote><xsl:value-of select="./following-sibling::text:p[1]/text()"/></quote>
                        </xsl:if>
                        <xsl:for-each select="./following-sibling::text:h[@text:outline-level='2'][generate-id(preceding-sibling::text:h[@text:outline-level='1'][1]) = $header-id] ">
                            <xsl:variable name="counter2" select="./@text:outline-level"/>
                            <xsl:variable name="header-id2" select="generate-id(.)"/>
                            <div n="{$counter2}">
                                <head><xsl:value-of select="text()"/></head>
                                <!--<xsl:apply-templates select="./following-sibling::text:p"/>-->
                                <xsl:for-each select="./following-sibling::text:p[@text:style-name='Text_20_body'][generate-id(preceding-sibling::text:h[@text:outline-level='2'][1]) = $header-id2]">
                                    <p>
                                        <xsl:apply-templates select="node()[not(self::text:soft-page-break) and not(self::text:s)]"/>
                                    </p>
                                </xsl:for-each>
                            </div>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$nextOne[@text:style-name[contains(.,'Heading')]] and $nextOne[@text:outline-level='2']">
                <xsl:for-each select="./text:h[@text:outline-level='2']">
                    <xsl:variable name="counter2" select="./@text:outline-level"/>
                    <xsl:variable name="header-id2" select="generate-id(.)"/>
                    <div n="{$counter2}">
                        <head><xsl:value-of select="text()"/></head>
                        <!--<xsl:apply-templates select="./following-sibling::text:p"/>-->
                        <xsl:for-each select="./following-sibling::text:p[@text:style-name='Text_20_body'][generate-id(preceding-sibling::text:h[@text:outline-level='2'][1]) = $header-id2]">
                            <p>
                                <xsl:apply-templates select="node()[not(self::text:soft-page-break) and not(self::text:s)]"/>
                            </p>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
        

</xsl:stylesheet>
