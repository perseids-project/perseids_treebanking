<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="e_lang" select="'grc'"/>
    <xsl:param name="e_morphQueryUrl" select="'http://services.perseids.org/bsp/morphologyservice/analysis/word?lang=REPLACE_LANG&amp;word=REPLACE_WORD&amp;engine=morpheusREPLACE_LANG'"/>
    <xsl:param name="e_annotationQueryUrl" select="'http://services.perseids.org/bsp/annotationservice/annotation/template/document?document_id=REPLACE_URN&amp;repos_type=cts&amp;mime_type=text/xml&amp;lang=REPLACE_LANG&amp;template_format=Perseus&amp;repos_uri=http://www.perseus.tufts.edu/hopper/CTS?'"/>
    <xsl:param name="e_urn" select="'urn:cts:greekLit:tlg0012.tlg001.perseus-grc1:1.1'"/>
    <xsl:param name="e_includeExtras" select="false()"/>
    
    
    <xsl:output media-type="text/plain" omit-xml-declaration="no" method="xml" indent="yes" />
    <xsl:preserve-space elements=""/>
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
        <xsl:variable name="sentences" select="doc(replace(replace($e_annotationQueryUrl,'REPLACE_LANG',$e_lang),'REPLACE_URN',$e_urn))"/>
        <xsl:apply-templates select="$sentences//*:treebank"/>
    </xsl:template>

    <xsl:template match="*:word">
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
            <xsl:choose>
                <xsl:when test="$punc/match">
                    <xsl:element name="word">
                        <xsl:apply-templates select="@*[not(name() = 'lemma') and not(name() = 'postag') and not(name() = 'relation')]"/>
                        <xsl:attribute name="lemma" select="'punc1'"/>
                        <xsl:attribute name="postag" select="'u--------'"/>
                        <xsl:choose>
                            <!-- RGorman says we always want AuxX for commas -->
                            <xsl:when test="@form=','">
                                <xsl:attribute name="relation" select="'AuxX'"/>
                            </xsl:when>
                            <xsl:when test="following-sibling::word">
                                <xsl:attribute name="relation" select="'AuxX'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="relation" select="'AuxK'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="url" select="replace(replace($e_morphQueryUrl,'REPLACE_LANG',$e_lang),'REPLACE_WORD',@form)"/>
                    <xsl:variable name="results" select="doc($url)"/>
                    <xsl:variable name="parsed">
                        <xsl:apply-templates select="$results//entry"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$parsed//morph">
                            <xsl:variable name="first_parse">
                                <xsl:element name="word">
                                    <xsl:apply-templates select="@*[not(name() = 'lemma') and not(name() = 'postag')]"/>
                                    <xsl:attribute name="lemma" select="(($parsed//morph)[1]/hdwd)[1]"/>
                                    <xsl:attribute name="postag" select="(($parsed//morph)[1]/code)[1]"/>
                                </xsl:element>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$e_includeExtras">
                                    <xsl:element name="word">
                                        <xsl:copy-of select="$first_parse/word/@*"/>
                                        <xsl:for-each select="$parsed//morph">
                                            <xsl:variable name="parsenum" select="position()"/>
                                            <xsl:for-each select="hdwd">
                                                <xsl:variable name="index" select="position()"/>
                                                <xsl:variable name="nval">
                                                    <xsl:choose>
                                                        <xsl:when test="$index &gt; 1"><xsl:value-of select="concat($parsenum,'.',$index)"/></xsl:when>
                                                        <xsl:otherwise><xsl:value-of select="$parsenum"/></xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                    <xsl:element name="alt">
                                                        <xsl:attribute name="n"><xsl:value-of select="$nval"/></xsl:attribute>
                                                        <xsl:copy-of select="$first_parse/word/@*[not(name() = 'lemma') and not(name() = 'postag') and not(name() = 'id')]"/>
                                                        <xsl:attribute name="lemma" select="."/>
                                                        <xsl:attribute name="postag" select="(../code)[$index]"/>
                                                        <xsl:copy-of select="(../extras)[$index]/@*"/>
                                                    </xsl:element>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:copy-of select="$first_parse"></xsl:copy-of>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="word">
                                <xsl:apply-templates select="@*"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*"></xsl:apply-templates>
            <xsl:apply-templates select="node()"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>