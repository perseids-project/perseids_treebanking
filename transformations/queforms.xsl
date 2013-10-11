<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:report = "http://www.oxygenxml.com/ns/report"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//report:description"/>
    </xsl:template>
    
    <xsl:template match="report:description">
        <xsl:value-of select="."/><xsl:text>&#x0a;</xsl:text>
    </xsl:template>
    
    <xsl:template match="*"/>
    
</xsl:stylesheet>