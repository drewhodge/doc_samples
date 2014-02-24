<?xml version="1.0" encoding="UTF-8"?>

<!-- ............................................................. -->
<!-- File:  migration_prep_concept.xsl                             -->
<!--                                                               -->
<!-- Purpose:  Produces a copy of the DITA concept topic file to   -->
<!--           which it is applied.  Allows the DOCTYPE            -->
<!--           declaration to be changed if necessary. Removes     -->
<!--           unneeded content.                                   -->
<!-- ............................................................. -->
<!-- History/Notes:                                                -->
<!-- 16.Oct.2013    Created.                                       -->
<!-- ............................................................. -->

<xsl:transform
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
     
    <!-- ...........................................................-->
    <!-- Top level elements                                         -->
    
    <xsl:output method="xml"
        version="1.0"
        indent="yes"
        encoding="utf-8" />
							
    <!-- ......................................................... -->
    <!-- Document root template .................................. -->
    
    <xsl:template name="concept">
        <xsl:text disable-output-escaping="yes">
	<![CDATA[
<!DOCTYPE concept PUBLIC "-//QNX//Specialization Concept//EN" "http://www.qnx.com/dita/xml/1.2/concept.dtd">
	]]>
	    </xsl:text>
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="task">
        <xsl:text disable-output-escaping="yes">
	<![CDATA[
<!DOCTYPE task PUBLIC "-//QNX//Specialization Task//EN" "http://www.qnx.com/dita/xml/1.2/task.dtd">
	]]>
	    </xsl:text>
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="reference">
        <xsl:text disable-output-escaping="yes">
	<![CDATA[
<!DOCTYPE reference PUBLIC "-//QNX//Specialization Reference//EN" "http://www.qnx.com/dita/xml/1.2/reference.dtd">
	]]>
	    </xsl:text>
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="ditamap">
        <xsl:text disable-output-escaping="yes">
	<![CDATA[
<!DOCTYPE map PUBLIC "-//OASIS//DTD DITA Map//EN" "http://www.qnx.com/dita/xml/1.2/map.dtd">
	]]>
	    </xsl:text>
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="bookmap">
        <xsl:text disable-output-escaping="yes">
	<![CDATA[
<!DOCTYPE bookmap PUBLIC "-//OASIS//DTD DITA BookMap//EN" "http://www.qnx.com/dita/xml/1.2/bookmap.dtd">
	]]>
	    </xsl:text>
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
<!-- ............................................................. -->
<!-- Templates ................................................... -->
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>  
    </xsl:template>
    
    <xsl:template match="attribute::class">
        <!-- Don't copy @class attributes. -->
    </xsl:template>
    
    <xsl:template match="attribute::domains">
        <!-- Don't copy @domains attributes. -->
    </xsl:template>
    
    <xsl:template match="indexterm">
        <!-- Remove indexterm elements. -->
    </xsl:template>
    
    <xsl:template match="*[@product='SDP']">
        <!-- Remove all elements with SDP conditions. -->
    </xsl:template>
    
    <xsl:template match="*[@product='CAR']" >
        <!-- Remove all elements with CAR conditions. -->
    </xsl:template>
    
    <xsl:template match="*[@product='SDP CAR']">
        <!-- Remove all elements with SDP and CAR conditions. -->
    </xsl:template>
    
    <xsl:template match="*[@product='CAR SDP']">
        <!-- Remove all elements with SDP and CAR conditions. -->
    </xsl:template>
    
    <xsl:template match="@product">
        <xsl:choose>
            <xsl:when test=". = 'NDK'">
                <!-- Remove @product attributes whose value is 'NDK' -->
            </xsl:when>         
            <xsl:when test=". = 'NDK SDP'">
                <!-- Remove @product attributes whose value is 'NDK SDP' -->
            </xsl:when>
            <xsl:when test=". = 'SDP NDK'">
                <!-- Remove @product attributes whose value is 'SDP NDK' -->
            </xsl:when>
            <xsl:when test=". = 'NDK CAR'">
                <!-- Remove @product attributes whose value is 'NDK CAR' -->
            </xsl:when>
            <xsl:when test=". = 'CAR NDK'">
                <!-- Remove @product attributes whose value is 'CAR NDK' -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Adding @format attribute for xrefs with @scope set to 'external'. -->
    <xsl:template match="xref[@scope='external']">
        <xsl:choose>
            <xsl:when test="@format='html'">
                <xsl:element name="xref">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="xref">
                    <xsl:attribute name="format">
                        <xsl:text>html</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Adding @format attribute for keydefs with @scope set to 'external'. -->
    <xsl:template match="keydef[@scope='external']">
        <xsl:choose>
            <xsl:when test="@format='html'">
                <xsl:element name="keydef">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="keydef">
                    <xsl:attribute name="format">
                        <xsl:text>html</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
							
</xsl:transform>