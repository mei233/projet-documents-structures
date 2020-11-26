<?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0">

        <xsl:param name="meta.file" select="'meta.xml'" /> 

        <xsl:template match="@*|node()">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()" />
            </xsl:copy>
        </xsl:template>

        <xsl:template match="office:document-content">
            <office:document>
                <xsl:copy-of select="@*" />
                <xsl:variable name="meta" select="document($meta.file)/office:document-meta/office:meta" />
                <xsl:copy-of select="$meta" />
                <xsl:apply-templates />
            </office:document>
        </xsl:template>

    </xsl:stylesheet>