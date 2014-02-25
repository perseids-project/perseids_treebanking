<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- 
  Table mapping morphological tag abbreviations to
  full names for Ancient Language Dependency Treebank
-->
  <xsl:variable name="s_rawAldtMorphologyTable">
    <aldt-morphology-table>
      <!-- part of speech -->
      <entry>
        <category>pofs</category>
        <short>n</short>
        <long>noun</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>v</short>
        <long>verb</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>v</short>
        <long>verb participle</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>a</short>
        <long>adjective</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>d</short>
        <long>adverb</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>c</short>
        <long>conjunction</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>l</short>
        <long>article</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>g</short>
        <long>particle</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>r</short>
        <long>preposition</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>p</short>
        <long>pronoun</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>m</short>
        <long>numeral</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>i</short>
        <long>interjection</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>e</short>
        <long>exclamation</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>x</short>
        <long>irregular</long>
      </entry>
      <entry>
        <category>pofs</category>
        <short>u</short>
        <long>punctuation</long>
      </entry>

      <!-- pers -->
      <entry>
        <category>pers</category>
        <short>1</short>
        <long>1st</long>
      </entry>
      <entry>
        <category>pers</category>
        <short>2</short>
        <long>2nd</long>
      </entry>
      <entry>
        <category>pers</category>
        <short>3</short>
        <long>3rd</long>
      </entry>

      <!-- num -->
      <entry>
        <category>num</category>
        <short>s</short>
        <long>singular</long>
      </entry>
      <entry>
        <category>num</category>
        <short>p</short>
        <long>plural</long>
      </entry>
      <entry>
        <category>num</category>
        <short>d</short>
        <long>dual</long>
      </entry>

      <!-- tense -->
      <entry>
        <category>tense</category>
        <short>p</short>
        <long>present</long>
      </entry>
      <entry>
        <category>tense</category>
        <short>i</short>
        <long>imperfect</long>
      </entry>
      <entry>
        <category>tense</category>
        <short>r</short>
        <long>perfect</long>
      </entry>
      <entry>
        <category>tense</category>
        <short>l</short>
        <long>pluperfect</long>
      </entry>
      <entry>
        <category>tense</category>
        <short>t</short>
        <long>future perfect</long>
      </entry>
      <entry>
        <category>tense</category>
        <short>f</short>
        <long>future</long>
      </entry>
      <entry>
        <category>tense</category>
        <short>a</short>
        <long>aorist</long>
      </entry>

      <!-- mood -->
      <entry>
        <category>mood</category>
        <short>i</short>
        <long>indicative</long>
      </entry>
      <entry>
        <category>mood</category>
        <short>s</short>
        <long>subjunctive</long>
      </entry>
      <entry>
        <category>mood</category>
        <short>o</short>
        <long>optative</long>
      </entry>
      <entry>
        <category>mood</category>
        <short>n</short>
        <long>infinitive</long>
      </entry>
      <entry>
        <category>mood</category>
        <short>m</short>
        <long>imperative</long>
      </entry>
      <entry>
        <category>mood</category>
        <short>g</short>
        <long>gerundive</long>
      </entry>
      <entry>
        <category>mood</category>
        <short>p</short>
        <long>participle</long>
      </entry>

      <!-- voice -->
      <entry>
        <category>voice</category>
        <short>a</short>
        <long>active</long>
      </entry>
      <entry>
        <category>voice</category>
        <short>p</short>
        <long>passive</long>
      </entry>
      <entry>
        <category>voice</category>
        <short>d</short>
        <long>deponent</long>
      </entry>
      <entry>
        <category>voice</category>
        <short>e</short>
        <long>mediopassive</long>
      </entry>
      <entry>
        <category>voice</category>
        <short>m</short>
        <long>middle</long>
      </entry>

      <!-- gend -->
      <entry>
        <category>gend</category>
        <short>m</short>
        <long>masculine</long>
      </entry>
      <entry>
        <category>gend</category>
        <short>f</short>
        <long>feminine</long>
      </entry>
      <entry>
        <category>gend</category>
        <short>n</short>
        <long>neuter</long>
      </entry>
       <entry>
        <category>gend</category>
        <short>c</short>
        <long>common</long>
      </entry>

      <!-- case -->
      <entry>
        <category>case</category>
        <short>n</short>
        <long>nominative</long>
      </entry>
      <entry>
        <category>case</category>
        <short>g</short>
        <long>genitive</long>
      </entry>
      <entry>
        <category>case</category>
        <short>d</short>
        <long>dative</long>
      </entry>
      <entry>
        <category>case</category>
        <short>a</short>
        <long>accusative</long>
      </entry>
      <entry>
        <category>case</category>
        <short>b</short>
        <long>ablative</long>
      </entry>
      <entry>
        <category>case</category>
        <short>v</short>
        <long>vocative</long>
      </entry>
      <entry>
        <category>case</category>
        <short>i</short>
        <long>instrumental</long>
      </entry>
      <entry>
        <category>case</category>
        <short>l</short>
        <long>locative</long>
      </entry>

      <!-- degree -->
      <entry>
        <category>comp</category>
        <short>p</short>
        <long>positive</long>
      </entry>
      <entry>
        <category>comp</category>
        <short>c</short>
        <long>comparative</long>
      </entry>
      <entry>
        <category>comp</category>
        <short>s</short>
        <long>superlative</long>
      </entry>
    </aldt-morphology-table>
  </xsl:variable>
  <xsl:variable name="s_aldtMorphologyTable"
    select="$s_rawAldtMorphologyTable/aldt-morphology-table"/>

  <!-- keys for lookup table -->
  <xsl:key name="s_aldtMorphologyLookupShort"
           match="aldt-morphology-table/entry"
           use="short"/>
  <xsl:key name="s_aldtMorphologyLookupLong"
           match="aldt-morphology-table/entry"
           use="long"/>

  <!--
    Template to calculate a long name from morphology code
    
    Parameters:
      a_category            morphological category (pers, case, etc.)
      a_key                 short value to look up
      a_attribute           whether to output attribute or element (default=attr)
      a_name                name of attribute/element (default=use category)

    Return value:
      If code found in requested category
        attribute or element containing long value
      If code not found, empty
  -->
  <xsl:template match="aldt-morphology-table" mode="short2long">
    <xsl:param name="a_category"/>
    <xsl:param name="a_key"/>
    <xsl:param name="a_attribute" select="true()"/>
    <xsl:param name="a_name" select="''"/>

    <!-- use long value from entry with matching category -->
    <xsl:variable name="value"
      select="key('s_aldtMorphologyLookupLong', $a_key)[category=$a_category]/long"/>

    <xsl:if test="string-length($value) > 0">
      <!-- name to use for attribute/element -->
      <xsl:variable name="nameToUse">
        <xsl:choose>
          <xsl:when test="string-length($a_name) > 0">
            <xsl:value-of select="$a_name"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$a_category"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <!-- if returning attribute -->
        <xsl:when test="$a_attribute">
          <xsl:attribute name="{$nameToUse}">
            <xsl:value-of select="$value"/>
          </xsl:attribute>
        </xsl:when>
        <!-- if returning element -->
        <xsl:otherwise>
          <xsl:element name="{$nameToUse}">
            <xsl:value-of select="$value"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!--
    Template to calculate a morphology code from a long name
    
    Parameters:
      a_category            morphological category (pers, case, etc.)
      a_key                 short value to look up

    Return value:
      If long name found in category, the short code
      If not found, "-"
  -->
  <xsl:template match="aldt-morphology-table" mode="long2short">
    <xsl:param name="a_category"/>
    <xsl:param name="a_key"/>
    <!-- use short value from entry with matching category -->
    <xsl:variable name="value"
      select="key('s_aldtMorphologyLookupLong', $a_key)[category=$a_category]/short"/>
    <xsl:if test="string-length($value) > 0">
      <xsl:value-of select="$value"/>
    </xsl:if>
    <xsl:if test="string-length($value) = 0">-</xsl:if>
  </xsl:template>

</xsl:stylesheet>
