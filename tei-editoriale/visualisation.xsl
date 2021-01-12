<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="html" encoding="utf-8"/>
<!--    <xsl:param name="MBfile" select="document('Madame-Bovary.xml')"/>
    <xsl:param name="SIDfile" select="document('SIDDHARTHA.xml')"/>
    <xsl:param name="WHfile" select="document('Wuthering-Heights.xml')"/>-->
<!--    <xsl:output method="html"/>-->
    <xsl:template match="/">
<!--        <xsl:result-document href="output.html" method="html" indent="yes">-->
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="style/type/visualisation.css" media="all"/>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="//tei:titleStmt/tei:title/text()"/>
                </h1>
                <p>
                    <xsl:value-of select="//tei:author"/> (<xsl:value-of select="//tei:bibl/tei:date"/>)</p>
                <xsl:apply-templates select="//tei:body"/>
                    
                
            </body>
        </html>
            <!--</xsl:result-document>-->
    </xsl:template>
        <xsl:template match="tei:body">
        <xsl:for-each select=".//tei:div">
            <xsl:if test="@n='1'">
                <h2>
                    <xsl:value-of select="./tei:head/text()"/>
                </h2>
            </xsl:if>
            <xsl:if test="@n='2'">
                <h3>
                    <xsl:value-of select="./tei:head/text()"/>
                </h3>
            </xsl:if>
            <!-- <h3><xsl:value-of select="./tei:head/text()"/></h3> -->
            <xsl:if test="./tei:head/following-sibling::*[1][name()='quote']">
                <p>
                    <xsl:value-of select="./tei:quote/text()"/>
                </p>
            </xsl:if>
            <xsl:if test="./tei:head/following-sibling::*[1][name()='p']">
            <xsl:for-each select="./tei:p">
                <p>
                        <xsl:value-of select="./text()"/>
                    </p>
            </xsl:for-each>
            </xsl:if>            
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>