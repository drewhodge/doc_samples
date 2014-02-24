<?xml version="1.0" encoding="UTF-8"?>

<!-- ...................................................................... -->
<!-- File: migration_prep_prolog.xsl                                        -->
<!--                                                                        -->
<!-- Purpose: Adds prolog element to all topic files to which it is applied.-->
<!--                                                                        -->
<!-- ...................................................................... -->
<!-- History:                                                               -->
<!-- 25.Oct.2013   Created.                                                -->
<!-- ...................................................................... -->

<xsl:transform version="2.0" xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- .................................................................. -->
    <!-- Top level elements                                                 -->

    <xsl:output method="xml"
        version="1.0"
        indent="yes"
        encoding="utf-8" />

    <!-- .................................................................  -->
    <!-- Document root template ........................................... -->

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/concept">
                <xsl:call-template name="concept" />
            </xsl:when>
            <xsl:when test="/task">
                <xsl:call-template name="task" />
            </xsl:when>
            <xsl:when test="/reference">
                <xsl:call-template name="reference" />
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>

    </xsl:template>

    <!-- ............................................................. -->
    <!-- Document root template ...................................... -->

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

    <!--<xsl:template name="ditamap">
        <xsl:text disable-output-escaping="yes">
	<![CDATA[
<!DOCTYPE map PUBLIC "-//QNX//Specialization Map//EN" "http://www.qnx.com/dita/xml/1.2/map.dtd">
	]]>
	    </xsl:text>
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>-->

    <!-- ............................................................. -->
    <!-- Templates ................................................... -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="shortdesc">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
        <xsl:choose>
            <xsl:when test="following-sibling::prolog">
                <!-- do nothing -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="create_prolog" />
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template name="create_prolog">
        <xsl:element name="prolog">
            <xsl:element name="metadata">
                <xsl:element name="othermeta">
                    <xsl:attribute name="content">doxygen</xsl:attribute>
                    <xsl:attribute name="name">source</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>


    <xsl:template match="attribute::class">
        <!-- Don't copy @class attributes. -->
    </xsl:template>


</xsl:transform>
