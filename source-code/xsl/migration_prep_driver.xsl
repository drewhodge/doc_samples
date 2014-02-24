<?xml version="1.0" encoding="UTF-8"?>

<!-- ...................................................................... -->
<!-- File: migration_prep.xsl                                               -->
<!--                                                                        -->
<!-- Purpose: Driver file for migration prep transformations.               -->
<!--                                                                        -->
<!-- ...................................................................... -->
<!-- History:                                                               -->
<!-- 17.Oct.2013    Created driver file.                                    -->
<!-- ...................................................................... -->

<xsl:transform version="2.0" 
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<!-- ...................................................................... -->
<!-- Top level elements                                                     -->
    
       
<!-- ............................................................. -->
<!-- Document root template ...................................... -->
    
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
            <xsl:when test="/map">
                <xsl:call-template name="ditamap" />
            </xsl:when>
            <xsl:when test="/bookmap">
                <xsl:call-template name="bookmap" />
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
    </xsl:template>

    <xsl:include href="migration_prep_dita.xsl"/>
    
</xsl:transform>
