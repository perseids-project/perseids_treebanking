<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- test version of a transform to aggregate all words annotated with morphology -->
    
    <xsl:output method="xml" indent="yes"></xsl:output>
    <xsl:param name="e_master" select="'wordsall.xml'"/>
    
    <xsl:variable name="words_all" select="doc($e_master)"/>
    <xsl:param name="user" select="'http://data.perseus.org/sosol/users/Vanessa%20Gorman'"/>
    
    <xsl:template match="/">
        <xsl:variable name="words">
            <xsl:apply-templates select="treebank/sentence/word"></xsl:apply-templates>
            <xsl:apply-templates select="$words_all//word"/>
        </xsl:variable>
       <words>
           <xsl:for-each-group select="($words/*)" group-by="concat(@form,'|',@lemma, '|',@postag)">
               <xsl:copy-of select="current()"/>
           </xsl:for-each-group>
       </words>
    </xsl:template>
    
    
    <xsl:template match="word[@postag != '---------' and @postag !='' and @postag != 'undefined']">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="user" select="$user"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>