<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"   
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 16, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> Bridget</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
       
    <xsl:include href="aldt-util.xsl"/>
    
    <xsl:variable name="postag">
        <order>
            <item>pofs</item>
            <item alt="person">pers</item>
            <item alt="number">num</item>
            <item>tense</item>
            <item>mood</item>
            <item>voice</item>
            <item alt="gender">gend</item>
            <item>case</item>
            <item>comp</item>
        </order>
    </xsl:variable>
  
    <xsl:variable name="extra">
        <order>
            <item>conj</item> <!-- may be in dict or infl -->
            <item>decl</item> <!-- may be in dict or infl -->
            <item>dial</item>
            <item>stemtype</item>
            <item>derivtype</item>
            <item>morph</item>
            <item>age</item>
            <item>area</item>
            <item>geo</item>
            <item>freq</item>
            <item>src</item>
            <item>note</item>
        </order>
    </xsl:variable>
    
    <xsl:template match="entry">
                <xsl:for-each select="infl">
                    <xsl:variable name="infl" select="current()"/>                                 
                            <xsl:call-template name="do_convert">
                                <xsl:with-param name="a_infl" select="$infl"/>
                                <xsl:with-param name="a_hdwd" select="$infl/../dict/hdwd"/>
                            </xsl:call-template>                                                            
                </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="do_convert">
        <xsl:param name="a_infl"/>
        <xsl:param name="a_hdwd"/>
        <xsl:param name="a_item"/>
        <xsl:element name="morph">
            <xsl:element name="hdwd"><xsl:value-of select="$a_hdwd"/></xsl:element>
            <xsl:element name="code">                
                <xsl:for-each select="$postag/order/item">        
                    <xsl:call-template name="convert">
                        <xsl:with-param name="a_att" select="current()"/>
                        <xsl:with-param name="a_infl" select="$a_infl"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="extras">
                <xsl:for-each select="$extra/order/item">
                    <xsl:variable name="value">
                        <xsl:choose>
                            <xsl:when test="$a_infl/*[local-name(.) = current()]">
                                <xsl:copy-of select="$a_infl/*[local-name(.) = current()]"/>
                            </xsl:when>
                            <xsl:when test="$a_infl/../dict/*[local-name(.) = current()]">
                                <xsl:copy-of select="$a_infl/../dict/*[local-name(.) = current()]"></xsl:copy-of>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$value != ''">
                        <xsl:attribute name="{current()}"><xsl:value-of select="$value"/></xsl:attribute>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>         
    </xsl:template>
    
    <xsl:template name="convert">
        <xsl:param name="a_att"/>
        <xsl:param name="a_infl"/>
        <xsl:variable name="name" select="xs:string($a_att)"/>
        <xsl:variable name="alt" select="$a_att/@alt"/>                
        <xsl:choose>
            <xsl:when test="$a_infl/*[local-name(.) = $name]">                
                <xsl:variable name="full">                                        
                    <xsl:apply-templates select="$s_aldtMorphologyTable" mode="long2short">
                        <xsl:with-param name="a_category" select="$name"/>
                        <xsl:with-param name="a_key">
                                    <xsl:value-of select="$a_infl/*[local-name() = $name]/text()"/>
                        </xsl:with-param> 
                    </xsl:apply-templates>                    
                </xsl:variable>                
                <xsl:choose>                    
                    <xsl:when test="not(matches($full,'-'))">                        
                        <xsl:value-of select="$full"/>
                    </xsl:when>
                    <!-- try again using alternate name -->
                    <xsl:when test="$alt">                        
                        <xsl:apply-templates select="$s_aldtMorphologyTable" mode="long2short">
                            <xsl:with-param name="a_category" select="$alt"/>
                            <xsl:with-param name="a_key" select="$a_infl/*[local-name() = $name]/text()"/>
                        </xsl:apply-templates>                                            
                    </xsl:when>                             
                    <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>                                
            </xsl:when>
            <xsl:otherwise>                
                <xsl:text>-</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>