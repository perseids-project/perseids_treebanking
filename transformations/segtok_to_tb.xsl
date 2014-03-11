<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:include href="morph-to-codes.xsl"/>
    
    <xsl:param name="e_lang" select="'lat'"/>
    <xsl:param name="e_format" select="'aldt'"/>
    <xsl:param name="e_cite" select="'section'"/>
    <xsl:param name="e_encmarker" select="'-'"/>
    <xsl:param name="e_morphQueryUrl" select="'http://services.perseids.org/bsp/morphologyservice/analysis/word?lang=REPLACE_LANG&amp;word=REPLACE_WORD&amp;engine=morpheusREPLACE_LANG'"/>
    
    <xsl:variable name="doc_urn" select="//tei:div[@type='edition']/@n|//tei:div[@type='translation']/@n"/>
    <xsl:output indent="yes"></xsl:output>
    <xsl:template match="/">
        <xsl:element name="treebank">
            <xsl:attribute name="xml:lang">
                <xsl:choose>
                    <xsl:when test="//tei:text[@xml:lang]"><xsl:value-of select="//tei:text[@xml:lang]"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$e_lang"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="format"><xsl:value-of select="$e_format"/></xsl:attribute>
            <xsl:attribute name="version">1.5</xsl:attribute>
            <xsl:apply-templates select="//tei:div[@subtype='section']"></xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:div[@subtype=$e_cite]">
        <!-- TODO we need the text inventory to calculate the paths -->
        <xsl:variable name="parents">
            <xsl:call-template name="make_cite">
                <xsl:with-param name="a_node" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="subdoc"><xsl:value-of select="string-join(reverse($parents/*),'.')"/></xsl:variable>
        <xsl:for-each-group select="descendant::tei:w|descendant::tei:pc" group-by="@s_n">
            <xsl:sort select="@s_n" data-type="number"></xsl:sort>
            <xsl:sort select="@n" data-type="number"></xsl:sort>
            <xsl:element name="sentence">
                <xsl:attribute name="id"><xsl:value-of select="@s_n"/></xsl:attribute>
                <xsl:attribute name="document_id"><xsl:value-of select="$doc_urn"/></xsl:attribute>
                <xsl:attribute name="subdoc"><xsl:value-of select="$subdoc"/></xsl:attribute>
                <xsl:attribute name="span"/>
                <xsl:apply-templates select="current-group()"/>
            </xsl:element>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:variable name="lang">
            <xsl:choose>
                <xsl:when test="//tei:text[@xml:lang]"><xsl:value-of select="//tei:text[@xml:lang]"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$e_lang"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="parsed">
            <xsl:choose>
                <!-- skip marked enclytics for now -->
                <xsl:when test="starts-with(.,$e_encmarker)"/>
                <xsl:otherwise>
                    <xsl:variable name="url" select="replace(replace($e_morphQueryUrl,'REPLACE_LANG',$lang),'REPLACE_WORD',.)"/>
                    <xsl:variable name="results" select="doc($url)"/>
                    <xsl:apply-templates select="$results//entry"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="word">
            <xsl:attribute name="id"><xsl:value-of select="@n"></xsl:value-of></xsl:attribute>
            <xsl:attribute name="form"><xsl:value-of select="."/></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$parsed//morph">
                        <xsl:attribute name="lemma" select="(($parsed//morph)[1]/hdwd)[1]"/>
                        <xsl:attribute name="postag" select="(($parsed//morph)[1]/code)[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="lemma"/>
                        <xsl:attribute name="postag"/>
                    </xsl:otherwise>
                </xsl:choose>
            <xsl:attribute name="head">0</xsl:attribute>
            <xsl:attribute name="relation">nil</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:pc">
        <xsl:variable name="s" select="@s_n"/>
        <xsl:element name="word">
            <xsl:attribute name="id"><xsl:value-of select="@n"></xsl:value-of></xsl:attribute>
            <xsl:attribute name="form"><xsl:value-of select="."/></xsl:attribute>
            <xsl:attribute name="lemma" select="'punc1'"/>
            <xsl:attribute name="postag" select="'u--------'"/>
            <xsl:attribute name="head">0</xsl:attribute>
            <xsl:choose>
                <!-- RGorman says we always want AuxX for commas -->
                <xsl:when test=".=','">
                    <xsl:attribute name="relation" select="'AuxX'"/>
                </xsl:when>
                <!-- if punctuation is mid-sentence-->
                <xsl:when test="following-sibling::*[@s_n=$s]">
                    <xsl:attribute name="relation" select="'AuxX'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="relation" select="'AuxK'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*"/>

    <xsl:template match="*"/>
    
    <xsl:template name="make_cite">
        <xsl:param name="a_node"/>
        <xsl:choose>
            <xsl:when test="$a_node/@n">
                <xsl:choose>
                    <xsl:when test="$a_node/@type='edition' or $a_node/@type='translation'"/>
                    <xsl:otherwise>
                        <xsl:element name="cite"><xsl:value-of select="$a_node/@n"/></xsl:element>
                        <xsl:call-template name="make_cite">
                            <xsl:with-param name="a_node" select="$a_node/parent::*"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>     
                <xsl:call-template name="make_cite">
                    <xsl:with-param name="a_node" select="$a_node/parent::*"></xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>