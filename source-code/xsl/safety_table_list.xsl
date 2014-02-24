<?xml version="1.0" encoding="UTF-8"?>
   
<!-- ...................................................................... -->
<!-- File: safety_table_list.xsl                                            -->
<!--                                                                        -->
<!-- Purpose: Creates list depending on product type in prepartion for      -->
<!--          creating safety tables.                                       --> 
<!-- ...................................................................... -->
<!-- Notes/History:                                                         -->
<!-- 22.Jun.2011    Created.                                                -->
<!-- 22.May.2012    Added code to prevent 'full' safety tables from being   -->
<!--                processed.                                              -->
<!-- 26.Nov.2012    Made temporary modifications to allow for processing    -->
<!--                conditionalized CAR and SDP topics.                     -->
<!--                                                                        -->
<!-- ...................................................................... -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xml="http://www.w3.org/XML/1998/namespace" 
               version="2.0">


    <!-- .................................................................. -->
    <!-- Top level elements                                                 -->

    <xsl:output method="xml" 
                version="1.0" 
                indent="yes" 
                encoding="utf-8" />
    
    <xsl:param name="docSetType" />
    <xsl:param name="listPath" />
    
    
    <!-- .................................................................. -->
    <!-- Root node template                                                 -->

    <xsl:template match="map">
        <xsl:element name="directory">
            <xsl:call-template name="docSetType" />
        </xsl:element>
    </xsl:template>

    <!-- .................................................................. -->
    <!-- Templates                                                          -->
    
    <!-- 
        Determine which templates to apply.
        
        Apply template modes depending on whether docSetType is set
        to NDK or SDP.
    -->
    <xsl:template name="docSetType">
        <xsl:choose>
            <xsl:when test="$docSetType='NDK'">
                <xsl:apply-templates mode="ndk" />
            </xsl:when>
            <xsl:when test="$docSetType='SDP'">
                <xsl:apply-templates mode="sdp" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
        Create a list entry if the topicref element has a product
        attribute set to NDK.
    -->
    <xsl:template match="topicref/topicref[@type='reference'][@product='NDK']" mode="ndk">
        <xsl:variable name="absPath">
            <xsl:value-of select="$listPath" />
        </xsl:variable>
        <xsl:variable name="funcName">
            <xsl:value-of select="tokenize(@href, '/')[last()]" />
        </xsl:variable>
        <xsl:element name="file">
            <xsl:attribute name="name">
                <xsl:value-of select="$funcName" />
            </xsl:attribute>
            <xsl:attribute name="absolutePath">
                <xsl:value-of select="concat($absPath, $funcName)" />
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- 
        Create a list entry if the topicref element has a product
        attribute set to SDP.
    -->
    <xsl:template match="topicref/topicref[@type='reference'][@product='SDP']" mode="sdp "> 
        <xsl:variable name="absPath">
            <xsl:value-of select="$listPath" />
        </xsl:variable>
        <xsl:variable name="funcName">
            <xsl:value-of select="tokenize(@href, '/')[last()]" />
        </xsl:variable>
        <xsl:element name="file">
            <xsl:attribute name="name">
                <xsl:value-of select="$funcName" />
            </xsl:attribute>
            <xsl:attribute name="absolutePath">
                <xsl:value-of select="concat($absPath, $funcName)" />
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- 
        Create a list entry if the topicref element has no product
        attribute set.  Runs when ndk modes are active.
    -->
    <xsl:template match="topicref/topicref[@type='reference'][not(@product='NDK') and
        not(@product='SDP')]" mode="ndk">
        <xsl:choose>
            <xsl:when test="contains(./@href, 'full_safety')">
                <!-- Do nothing. -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="absPath">
                    <xsl:value-of select="$listPath" />
                </xsl:variable>
                <xsl:variable name="funcName">
                    <xsl:value-of select="tokenize(@href, '/')[last()]" />
                </xsl:variable>
                <xsl:element name="file">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$funcName" />
                    </xsl:attribute>
                    <xsl:attribute name="absolutePath">
                        <xsl:value-of select="concat($absPath, $funcName)" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
        Create a list entry if the topicref element has no product
        attribute set.  Runs when sdp modes are active.
    -->
    <xsl:template match="topicref/topicref[@type='reference'][not(@product='NDK') and
        not(@product='SDP')]" mode="sdp">
        <xsl:choose>
            <xsl:when test="contains(./@href, 'full_safety')">
                <!-- Do nothing. -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="absPath">
                    <xsl:value-of select="$listPath" />
                </xsl:variable>
                <xsl:variable name="funcName">
                    <xsl:value-of select="tokenize(@href, '/')[last()]" />
                </xsl:variable>
                <xsl:element name="file">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$funcName" />
                    </xsl:attribute>
                    <xsl:attribute name="absolutePath">
                        <xsl:value-of select="concat($absPath, $funcName)" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:transform>