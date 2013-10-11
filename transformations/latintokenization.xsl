<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output indent="yes"></xsl:output>
    
    <xsl:param name="subdoc_start" select="xs:int(0)"/>
    <xsl:param name="subdoc_end" select="xs:int(0)"/>
    
    <xsl:variable name="queforms" select="doc('queforms.xml')">
        
    </xsl:variable>
    <xsl:template match="/treebank">
        
        <treebank version="1.5"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:treebank="http://nlp.perseus.tufts.edu/syntax/treebank/1.5"
            xsi:schemaLocation="http://nlp.perseus.tufts.edu/syntax/treebank/1.5 treebank-1.5.xsd"
            xml:lang="lat"
            format="aldt">
            <!--<xsl:for-each select="sentence[xs:int(@subdoc) >= xs:int($subdoc_start) and xs:int(@subdoc) &lt;= xs:int($subdoc_end)]">-->
            <xsl:for-each select="sentence">
                <xsl:variable name="words">
                    <xsl:for-each select="word">
                        <xsl:variable name="thisform" select="@form"/>
                        <xsl:choose>
                            <xsl:when test="$queforms//form[. = $thisform]">
                                <xsl:element name="word">
                                    <xsl:attribute name="form"><xsl:value-of select="substring-before($thisform,'que')"/></xsl:attribute>
                                    <xsl:copy-of select="@*[not(name() = 'form')]"></xsl:copy-of>
                                </xsl:element>
                                <xsl:element name="word">
                                    <xsl:attribute name="form">que</xsl:attribute>
                                    <xsl:copy-of select="@*[not(name() = 'form')]"></xsl:copy-of>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="@form='neve'">
                                <xsl:element name="word">
                                    <xsl:attribute name="form">ne</xsl:attribute>
                                    <xsl:copy-of select="@*[not(name() = 'form')]"></xsl:copy-of>
                                </xsl:element>
                                <xsl:element name="word">
                                    <xsl:attribute name="form">ve</xsl:attribute>
                                    <xsl:copy-of select="@*[not(name() = 'form')]"></xsl:copy-of>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:copy-of select="@*"/>
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>  
                    </xsl:for-each>
                </xsl:variable>
                <xsl:element name="sentence">
                    <xsl:attribute name="id"><xsl:value-of select="position()"/></xsl:attribute>
                    <xsl:copy-of select="@*[not(name()='id')]"></xsl:copy-of>
                    <xsl:for-each select="$words/word">
                        <xsl:element name="word">
                            <xsl:attribute name="id"><xsl:value-of select="position()"/></xsl:attribute>
                            <xsl:copy-of select="@*[not(name()='id') and not(name()='cid')]"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </treebank>
        
    </xsl:template>
    

</xsl:stylesheet>