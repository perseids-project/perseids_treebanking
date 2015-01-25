<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- test version of a transform which outputs just the morphology in the source document
         which DOES not apper in the morphology service results
    -->
    <xsl:param name="e_lang" select="'grc'"/>
    <xsl:param name="e_morphQueryUrl" select="'http://services.perseids.org/bsp/morphologyservice/analysis/word?lang=REPLACE_LANG&amp;word=REPLACE_WORD&amp;engine=morpheusREPLACE_LANG'"/>
  
    
    <xsl:output media-type="text/plain" method="text" indent="no"  xml:space="default"/>
    <xsl:include href="morph-to-codes.xsl"/>
    
    <!-- TODO we should split this up into AuxK, AuxX and AuxG -->
    <xsl:variable name="nontext">
        <nontext xml:lang="grc"> “”—&quot;‘’,.:;&#x0387;&#x00B7;?!\[\]\{\}\-</nontext>
        <nontext xml:lang="greek"> “”—&quot;‘’,.:;&#x0387;&#x00B7;?!\[\]\{\}\-</nontext>
        <nontext xml:lang="ara"> “”—&quot;‘’,.:;?!\[\]\{\}\-&#x060C;&#x060D;</nontext>
        <nontext xml:lang="lat"> “”—&quot;‘’,.:;&#x0387;&#x00B7;?!\[\]()\{\}\-</nontext>
        <nontext xml:lang="*"> “”—&quot;‘’,.:;&#x0387;&#x00B7;?!\[\]()\{\}\-</nontext>
    </xsl:variable>
    
    <xsl:template match="/">
      <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>

    <xsl:template match="word">
        <xsl:variable name="match-nontext">
            <xsl:choose>
                <xsl:when test="$e_lang and $nontext/nontext[@xml:lang=$e_lang]">
                    <xsl:value-of select="$nontext/nontext[@xml:lang=$e_lang]"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$nontext/nontext[@xml:lang='*']"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="match_string" select="concat('^[', $match-nontext, ']$')"/>
        <xsl:variable name="punc">
            <xsl:analyze-string select="@form" regex="{$match_string}">
                <xsl:matching-substring><match/></xsl:matching-substring>
                <xsl:non-matching-substring/>
            </xsl:analyze-string>
        </xsl:variable>
                    <xsl:variable name="url" select="replace(replace($e_morphQueryUrl,'REPLACE_LANG',$e_lang),'REPLACE_WORD',encode-for-uri(@form))"/>
                    <xsl:variable name="results" select="doc($url)"></xsl:variable>
                    <xsl:variable name="parsed">
                        <xsl:apply-templates select="$results//entry"/>
                    </xsl:variable>
        <xsl:variable name="notparsed">
            <xsl:if test="not($parsed//morph)">
                <word><xsl:value-of select="@form"/>,<xsl:value-of select="@lemma"/>,<xsl:value-of select="@postag"/>,<xsl:value-of select="@user"/></word>
            </xsl:if>
        </xsl:variable>
<xsl:for-each select="$notparsed/*"><xsl:value-of select="."/></xsl:for-each>
    </xsl:template>
</xsl:stylesheet>