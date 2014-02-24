<?xml version="1.0"?>

<!-- ............................................................. -->
<!-- File:  entrustDoc_templates_xrefs_fo.xsl                      -->
<!--                                                               -->
<!-- Purpose:  Driver file for conversion of XML source conforming -->
<!--           to entrustDoc.dtd into formatting objects (fo).     -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 18.Apr.2001    Created.                                       -->
<!-- ............................................................. -->

<!--
	Processes cross references and links.
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
<!-- Cross reference templates ................................... -->

	<!--
		Matches <CODE>crossReference</CODE> elements.
	-->
	<xsl:template match="crossReference">
		<fo:basic-link internal-destination="{generate-id(.)}">
			<xsl:value-of select="." />
		</fo:basic-link>
	</xsl:template>
	
</xsl:stylesheet>
