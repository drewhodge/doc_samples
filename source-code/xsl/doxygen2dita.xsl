<?xml version="1.0" encoding="UTF-8"?>
   
<!-- ...................................................................... -->
<!-- File: doxygen2dita.xsl                                                 -->
<!--                                                                        -->
<!-- Purpose: Driver file to create valid DITA topics from Doxygen XML.     -->
<!--                                                                        --> 
<!-- ...................................................................... -->
<!-- History:                                                               -->
<!-- 01.Oct.2012    Created driver file -/- removed templates to create     -->
<!--                doxyprime2dita.xsl.                                     -->
<!-- ...................................................................... -->

<xsl:transform version="2.0" 
               xmlns:xml="http://www.w3.org/XML/1998/namespace"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<!-- ...................................................................... -->
<!-- Top level elements                                                     -->
    
<!-- Imported stylesheets ................................................. -->
    
    <xsl:import href="qnx_entities.xsl"/>
    
    <xsl:import href="utils.xsl"/>
    
<!-- Take input and output directories from Ant task. ..................... -->
    
    <!-- Output directory. -->
    <xsl:param name="outdir"/>

    <!-- Plug-in name. -->
    <xsl:param name="pluginName"/>

    <!-- Doxygen XML src directory. -->
    <xsl:param name="srcdir" />
    <!--<xsl:text>/Users/dhodge/Development/DITASource/com.qnx.doc.bbmsp.lib_ref/src/xml/</xsl:text>
    </xsl:param>-->

    <!-- Library name. -->
    <xsl:param name="library"/>

    <!-- Header file location in NDK. -->
    <xsl:param name="headerlocn"/>
    
<!-- Create keys .......................................................... -->

    <!-- Collect struct member ids. -->
    <xsl:key match="/doxygen/compounddef[@kind='struct']/sectiondef/memberdef/@id" name="memberIDs"
        use="."/>

<!-- Create variables ..................................................... -->
        
    <!-- The API reference library being processed. -->
    <xsl:variable name="apiLib">
        <xsl:value-of select="$library"/>
    </xsl:variable>

    <!-- Preserve whitespace in text elements. -->
    <xsl:preserve-space elements="text"/>
    
<!-- Included stylesheets ................................................. -->
    
    <!-- Processes the @mainpage comment, which becomes the overview topic 
         for the doc set. -->
    <xsl:include href="doxymain2dita.xsl"/>
    
    <!-- Creates introductory topics for API content. -->
    <xsl:include href="doxyconcept2dita.xsl "/>
    
    <!-- Creates topics from Doxygen XML 'group' pages. -->
    <xsl:include href="doxygroup2dita.xsl "/>
    
    <!-- Primary stylesheet -/ contains most of the standard templates -->
    <xsl:include href="doxyprime2dita.xsl"/>

</xsl:transform>
