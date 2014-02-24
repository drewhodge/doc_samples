<?xml version="1.0"?>

<!-- ............................................................. -->
<!-- File:  entrustDoc_constants_fo.xsl                            -->
<!--                                                               -->
<!-- Purpose:  Contains entrustDoc-specific templates.             -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 20.Apr.2001    Created.                                       -->
<!-- ............................................................. -->

<!--
	Declares global variables	and params.

	<P>
	<CODE>entrustDOC_constants_fo.xsl</CODE> declares global variables
	and params for the stylesheet set that converts documentation
	written in <CODE>entrustDoc</CODE> format to XSL:FO in preparation
	for generating a PDF document.
	</P>

	@param		base-line	declares the base size for all text in the
						document
-->
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:saxon="http://icl.com/saxon"
		extension-element-prefixes="saxon"
		xmlns:fo="http://www.w3.org/1999/XSL/Format">
		
<!-- ............................................................. -->
<!-- Top level elements .......................................... -->

	<xsl:output method="xml"
							version="1.0"
							indent="no"
							encoding="ISO-8859-1"
							doctype-public="-//ENTRUST//DTD FO-TKML 1.0//EN"
		    			doctype-system="http://view-www.entrust.com/views/view_latest/product_docs/gecko/dtd/mod/entrustFO.dtd"/>

<!-- ............................................................. -->
<!-- Formatting constants ........................................ -->

	<xsl:param name="base-size" select="'10pt'" />

	<xsl:param name="page.height" select="'11in'" />
	<xsl:param name="page.width" select="'8.5in'" />

<!-- ............................................................. -->
<!-- Attribute sets .............................................. -->

	<xsl:attribute-set name="toc.page.margins">
		<xsl:attribute name="margin-left">0.25in</xsl:attribute>
		<xsl:attribute name="margin-top">0.5in</xsl:attribute>
		<xsl:attribute name="margin-right">0.25in</xsl:attribute>
		<xsl:attribute name="margin-bottom">0.5in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="chapter.page.margins">
	  <xsl:attribute name="margin-left">0.25in</xsl:attribute>
	  <xsl:attribute name="margin-top">0.5in</xsl:attribute>
	  <xsl:attribute name="margin-right">0.25in</xsl:attribute>
	  <xsl:attribute name="margin-bottom">0.5in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="chapter.left.region.body">
	  <xsl:attribute name="margin-left">0.75in</xsl:attribute>
	  <xsl:attribute name="margin-top">0.75in</xsl:attribute>
	  <xsl:attribute name="margin-right">2.0in</xsl:attribute>
	  <xsl:attribute name="margin-bottom">1.0in</xsl:attribute>
	  <xsl:attribute name="column-count">1</xsl:attribute>
	  <xsl:attribute name="padding">6pt 0pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="chapter.right.region.body">
	  <xsl:attribute name="margin-left">0.75in</xsl:attribute>
	  <xsl:attribute name="margin-top">0.75in</xsl:attribute>
	  <xsl:attribute name="margin-right">2.0in</xsl:attribute>
	  <xsl:attribute name="margin-bottom">1.0in</xsl:attribute>
	  <xsl:attribute name="column-count">1</xsl:attribute>
	  <xsl:attribute name="padding">6pt 0pt</xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>
