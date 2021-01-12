<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" encoding="utf-8"/>
	<xsl:template match="/">
		<html>
			<head>
				<style>
					.center {
					  display: block;
					  margin-left: auto;
					  margin-right: auto;
					  width: 50%;
					}
				</style>
			</head>
			<body>
				<div>
				<xsl:apply-templates select="root"/>
				</div>
				<div>
				<xsl:apply-templates select="//div"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="root">
		<h2>
            <xsl:value-of select=".//title/text()"/>
        </h2>
	</xsl:template>
	<xsl:template match="div">
		<!-- <p><xsl:value-of select="./p"/></p> -->
		<!-- <xsl:for-each select="./*"> -->
			<xsl:for-each select="./*">
			<xsl:choose>
				<xsl:when test="name()='objective'">
					<li>
                        <xsl:value-of select="./objective/text()"/>
                    </li>
				</xsl:when>
				<xsl:when test="name()='image'">
				<img src="{.}" width="50%" class="center"/>
				</xsl:when>
				<xsl:when test="name()='link'">
				<p>
                        <b>
                            <a href="{./l}">
                                <xsl:value-of select="./name"/>
                            </a>
                        </b>
                    </p>
				</xsl:when>
				<xsl:when test="name()='code'">
				<code class="center" src="{.}">
                        <xsl:value-of select="."/>
                    </code>
				</xsl:when>
				<xsl:when test="name()='p'">
					<p>
                        <xsl:value-of select="./text()"/>
                    </p>
				</xsl:when>
				<xsl:when test="name()='h'">
					<h3>
                        <xsl:value-of select="./text()"/>
                    </h3>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<!-- </xsl:for-each> -->
	</xsl:template>

	
</xsl:stylesheet>