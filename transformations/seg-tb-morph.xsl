<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Provisional transform which retrieves text from Perseus, passes it through the LLT segtok service
         creates a treebank template and parses the words through the morphology service
         
         Required Params: 
            e_urn = Perseus document identifier (preferably the cts urn, but the old style doc would work too)
            e_cite = Perseus passage identifier (if you supply the cts urn, then the cts passage e.g. 1.1, otherwise
                                                 the old-style perseus subdoc identifier)
         Optional Params: (Default value is listed first)
            Tokenization:
              e_splitting = true|false (if false, won't split enclitics)
              e_shifting = false|true (if true, shifts enclictics to put the enclitic at the beginning)
              e_merging = fase|true (if true, merges a limited number of words - ask Gernot for details)
              e_encmarker = - (marker for split enclitics)
              e_ignore = teiHeader,head,note,speaker,ref (comma-separated list of TEI tags to ignore)
            Other:
              e_format = aldt (format for treebank file)
    -->
    
    <xsl:param name="e_lang" select="'lat'"/>
    <xsl:param name="e_morphQueryUrl" select="'http://services.perseids.org/bsp/morphologyservice/analysis/word?lang=REPLACE_LANG&amp;word=REPLACE_WORD&amp;engine=morpheusREPLACE_LANG'"/>
    <xsl:param name="e_segtokUrl" 
        select="'http://services.perseids.org/llt/segtok?xml=true&amp;inline=true&amp;uri=REPLACE_URI&amp;shifting=REPLACE_SHIFTING&amp;splitting=REPLACE_SPLITTING&amp;merging=REPLACE_MERGING'"/>
    <xsl:param name="e_urn" select="'urn:cts:latinLit:phi0474.phi036.perseus-lat1'"/>
    <xsl:param name="e_cite" select="'1.1'"/>
    <xsl:param name="e_perseusBase" select="'http://www.perseus.tufts.edu/hopper/xmlchunk?doc='"/>
    <xsl:param name="e_shifting" select="'false'"/>
    <xsl:param name="e_splitting" select="'true'"/>
    <xsl:param name="e_merging" select="'false'"/>
    <xsl:param name="e_encmarker" select="'-'"/>
    <xsl:param name="e_ignore" select="'teiHeader,head,note,speaker,ref'"/>
    <xsl:param name="e_format" select="'aldt'"/>
    <xsl:param name="e_segtokversion" select="'net.latin-language-toolkit:segtok.v0.0.5'"/>
    <xsl:param name="e_morpheusversion" select="'org.perseus:tools:morpheus.v1'"/>
    
    
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
        <xsl:variable name="docuri">
            <xsl:choose>
                <xsl:when test="$e_cite">
                    <xsl:value-of select="encode-for-uri(concat($e_perseusBase,$e_urn,':',$e_cite))"></xsl:value-of>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="encode-for-uri(concat($e_perseusBase,$e_urn))"></xsl:value-of></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="teiignore">
            <xsl:for-each select="tokenize($e_ignore,',')">
                <xsl:value-of select="concat('&amp;remove_tei[]=',.)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="segtokuri">
            <xsl:value-of select="
                concat(
                    replace(
                        replace(
                            replace(
                                replace($e_segtokUrl,'REPLACE_URI',$docuri),
                                'REPLACE_SHIFTING',$e_shifting),
                            'REPLACE_SPLITTING',$e_splitting),
                        'REPLACE_MERGING',$e_merging),
                    $teiignore)"/>
        </xsl:variable>
        <xsl:variable name="text" select="doc($segtokuri)"/>
        <xsl:element name="treebank">
            <xsl:attribute name="xml:lang">
                <xsl:choose>
                    <xsl:when test="//*:text[@xml:lang]"><xsl:value-of select="//*:text/@xml:lang"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$e_lang"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="format"><xsl:value-of select="$e_format"/></xsl:attribute>
            <xsl:attribute name="version">1.5</xsl:attribute>
            <annotator>
                <short>lltsegtok</short>
                <name><xsl:value-of select="$e_segtokversion"/></name>
                <address>http://services.perseids.org/llt/segtok</address>
            </annotator>
            <annotator>
                <short>morpheus</short>
                <name><xsl:value-of select="$e_morpheusversion"/></name>
                <address>http://services.perseids.org/bsp/morphologyservice/engine/morpheuslat</address>
            </annotator>
            <xsl:for-each-group select="$text/(descendant::*:w|descendant::*:pc)" group-by="@s_n">
                <xsl:sort select="@s_n" data-type="number"></xsl:sort>
                <xsl:sort select="@n" data-type="number"></xsl:sort>
                <xsl:element name="sentence">
                    <xsl:attribute name="id"><xsl:value-of select="@s_n"/></xsl:attribute>
                    <xsl:attribute name="document_id"><xsl:value-of select="$e_urn"/></xsl:attribute>
                    <xsl:attribute name="subdoc"><xsl:value-of select="$e_cite"/></xsl:attribute>
                    <xsl:attribute name="span"/>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:element>
       
    </xsl:template>
    
    <xsl:template match="tei:w|w">
        
        <xsl:variable name="lang">
            <xsl:choose>
                <xsl:when test="//*:text/@xml:lang"><xsl:value-of select="//*:text/@xml:lang"/></xsl:when>
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
    
    <xsl:template match="tei:pc|pc">
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
</xsl:stylesheet>