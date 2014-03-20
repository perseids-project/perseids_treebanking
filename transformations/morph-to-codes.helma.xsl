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
   <xsl:output media-type="text/plain" omit-xml-declaration="yes" method="text" indent="no"/>    
    <xsl:include href="aldt-util.xsl"/>
    
    <xsl:variable name="postag">
        <order>
            <!--item>pofs</item-->
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
            <item>dial</item>
            <item>stemtype</item>
            <item>derivtype</item>
            <item>morph</item>
        </order>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:text>form,lemma,parse,extras&#x0a;</xsl:text>
        <xsl:apply-templates select="//entry"/>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>
    

    <xsl:template match="entry">
        <xsl:for-each select="infl">
            <xsl:variable name="infl" select="current()"/>
            <xsl:value-of select="$infl/ancestor::parse/@form"/><xsl:text>,</xsl:text>
            <xsl:value-of select="$infl/../dict/hdwd"/><xsl:text>,</xsl:text>
            <xsl:choose>
                <!-- special handling for adverbials -->
                <xsl:when test="$infl/gend = 'adverbial' and ($infl/pofs = 'noun' or $infl/pofs = 'adjective')">
                    <xsl:text>d---------</xsl:text>    
                </xsl:when>               
                <!-- adjectives with combined gender should be split into separate parses --> 
                <xsl:when test="($infl/gend = 'masculine/feminine' or $infl/gend = '/masculine/femine/neuter') and $infl/pofs = 'adjective'">
                    <xsl:call-template name="split_adjective">
                        <xsl:with-param name="a_infl" select="$infl"/>
                        <xsl:with-param name="a_gend" select="$infl/gend"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- nouns with masc/fem gender should be combined as common --> 
                <xsl:when test="$infl/pofs = 'noun' and ($infl/../dict/gend = 'masculine/feminine' or $infl/../dict/gend  = '/masculine/femine/neuter')">
                    <xsl:if test="$infl/gend = 'masculine'">
                        <xsl:call-template name="do_convert">
                                <xsl:with-param name="a_infl" select="$infl"/>
                                <xsl:with-param name="a_overrideAtt" select="'gend'"/>
                                <xsl:with-param name="a_overrideVal" select="'common'"/>
                        </xsl:call-template>                                                                                            
                     </xsl:if>                                                            
                </xsl:when>              
                <xsl:otherwise>                            
                    <xsl:call-template name="do_convert">
                        <xsl:with-param name="a_infl" select="$infl"/>
                    </xsl:call-template>                                                            
                </xsl:otherwise>
            </xsl:choose>  
            <xsl:text>,</xsl:text>                        
            <xsl:variable name="extras">
                <xsl:for-each select="$extra/order/item">
                    <xsl:if test="$infl/*[local-name(.) = current()]">
                        <xsl:copy-of select="$infl/*[local-name(.) = current()]"/>    
                    </xsl:if>
                </xsl:for-each>    
            </xsl:variable>
            <xsl:value-of select="string-join($extras/*,'|')"></xsl:value-of>
            <xsl:text>&#x0a;</xsl:text>            
         </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="do_convert">
        <xsl:param name="a_infl"/>
        <xsl:param name="a_item"/>
        <xsl:param name="a_overrideAtt"/>
        <xsl:param name="a_overrideVal"/>
        
                <!-- do pofs first -->
                <xsl:call-template name="convert">
                    <xsl:with-param name="a_att" select="'pofs'"/>
                    <xsl:with-param name="a_infl" select="$a_infl"/>
                    <xsl:with-param name="a_overrideAtt" select="$a_overrideAtt"/>
                    <xsl:with-param name="a_overrideVal" select="$a_overrideVal"/>
                </xsl:call-template>                                
                <!-- add 2nd slot -->
                <xsl:call-template name="subpos">
                    <xsl:with-param name="a_infl" select="$a_infl"/>
                </xsl:call-template>
                <!-- now do the rest -->
                <xsl:for-each select="$postag/order/item">        
                    <xsl:call-template name="convert">
                        <xsl:with-param name="a_att" select="current()"/>
                        <xsl:with-param name="a_infl" select="$a_infl"/>
                        <xsl:with-param name="a_overrideAtt" select="$a_overrideAtt"/>
                        <xsl:with-param name="a_overrideVal" select="$a_overrideVal"/>
                    </xsl:call-template>
                </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="split_adjective">
        <xsl:param name="a_infl"/>
        <xsl:param name="a_gend"/>
        <xsl:param name="a_pre"/>
        <xsl:variable name="new_gend" select="substring-before($a_gend,'/')"/>
        <xsl:choose>
            <!-- if we have a new gender, use it -->
            <xsl:when test="$new_gend">
                <xsl:call-template name="do_convert">
                      <xsl:with-param name="a_infl" select="$a_infl"/>
                      <xsl:with-param name="a_overrideAtt" select="'gend'"/>
                      <xsl:with-param name="a_overrideVal" select="$new_gend"/>
                </xsl:call-template>                               
                <!-- recurse for any remaining values -->
                <xsl:call-template name="split_adjective">
                    <xsl:with-param name="a_infl" select="$a_infl"/>
                    <xsl:with-param name="a_pre" select="$a_pre"/>
                    <xsl:with-param name="a_gend" select="substring-after($a_gend,'/')"/>
                </xsl:call-template>        
            </xsl:when>
            <!-- process the last remaining gender -->
            <xsl:when test="$a_gend">
                <xsl:call-template name="do_convert">
                      <xsl:with-param name="a_infl" select="$a_infl"/>
                      <xsl:with-param name="a_overrideAtt" select="'gend'"/>
                      <xsl:with-param name="a_overrideVal" select="$new_gend"/>
                </xsl:call-template>                               
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>                            
    </xsl:template>
    
    <xsl:template name="subpos">
        <xsl:param name="a_infl"/>
        <!-- philo: a: Article or determinative (Latin is, idem, ipse), Personal, Demonstrative, x: indefinite, Interrogative, Relative, poSsessive, k: reflexive, reCiprocal, propEr; -->
        <!-- morpheus stem_types: 
            a = article
            p = pers_pron
            d = art_adj and demonstr ?
            x = indef indef_pron, indef_rel_pron
            r = relative, rel_pron
            i = interrog
            unmapped: pron1 pron3 pron_adj1 pron_adj3 prep irreg_adj1 irreg_adj3 irreg_decl3 irreg_fut indecl indecl_noun art_adj
        -->
        <xsl:choose>
            <xsl:when test="$a_infl/stemtype = 'article'">a</xsl:when>
            <xsl:when test="$a_infl/stemtype = 'pers_pron'">p</xsl:when>
            <xsl:when test="$a_infl/stemtype = 'demonstr'">d</xsl:when>
            <xsl:when test="starts-with($a_infl/stemtype,'indef')">x</xsl:when>
            <xsl:when test="$a_infl/stemtype = 'relative' or $a_infl/stemtype = 'rel_pron'">r</xsl:when>            
            <xsl:when test="$a_infl/stemtype = 'interrog'">i</xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>                    
    </xsl:template>
    
    <xsl:template name="convert">
        <xsl:param name="a_att"/>
        <xsl:param name="a_infl"/>
        <xsl:param name="a_overrideAtt"/>
        <xsl:param name="a_overrideVal"/>
        <xsl:variable name="name" select="xs:string($a_att)"/>
        <xsl:variable name="alt" select="$a_att/@alt"/>                
        <xsl:choose>
            <xsl:when test="$a_infl/*[local-name(.) = $name]">                
                <xsl:variable name="full">                                        
                    <xsl:apply-templates select="$s_aldtMorphologyTable" mode="long2short">
                        <xsl:with-param name="a_category" select="$name"/>
                        <xsl:with-param name="a_key">
                            <xsl:choose>
                                <xsl:when test="$name = $a_overrideAtt">
                                    <xsl:value-of select="$a_overrideVal"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$a_infl/*[local-name() = $name]/text()"/>
                                </xsl:otherwise>
                            </xsl:choose>
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
    
    <!-- TODO RULES -->
    
    <!-- LEMMA  
        if you see ἐυπλεκής (smooth breathing on first letter of what could be diphthong)
        e.g. eu, ai, Then add diaeresis to second letter.
    -->
    <xsl:template match="*"/>
</xsl:stylesheet>