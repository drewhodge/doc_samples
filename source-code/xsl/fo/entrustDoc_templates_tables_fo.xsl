<?xml version="1.0"?>

<!-- ............................................................. -->
<!-- File:  entrustDoc_templates_tables_fo.xsl                     -->
<!--                                                               -->
<!-- Purpose:  Contains entrustDoc-specific templates.             -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 20.Apr.2001    Created.                                       -->
<!-- ............................................................. -->

<!--
	Contains templates for processing tables.
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
<!-- Templates ................................................... -->

	<!--
		Matches <CODE>table</CODE> elements.

		<P>
		This template processes two cases: tables with two columns, and
		tables with more than two columns.  FOP version 0.20.1 requires
		that column widths are specified explicitly.
		</P>
	-->
	<xsl:template match="table">
		<fo:block	font-family="sans-serif"
							font-size="12pt"
							font-weight="700"
							space-before="12pt"
							space-after="6pt">
			<xsl:value-of select="caption" />
		</fo:block>
		<fo:table table-layout="fixed"
		          inline-progression-dimension.maximum="100%"
							space-before="12pt"
							space-after="12pt">
			<xsl:variable name="colCount" select="count(tr[1]/th | tr[1]/td)" />
			<xsl:variable name="areaWidth" select="6.75" />
			<xsl:choose>
				<!-- Two-column tables -->
				<xsl:when test="$colCount = 2">
				
					<xsl:for-each select="tr[1]/th | tr[1]/td">
						<!-- Fit table to area width plus 1.75in (table-wide) -->
						<fo:table-column column-width="proportional-column-width(2)" />
					</xsl:for-each>
				
					<fo:table-body font-family="Syntax-Roman"
												 font-size="{$base-size}"
												 font-weight="200"
												 space-after="12pt"

												 border-top-color="grey"
												 border-top-width="0.5pt"
												 border-top-style="solid"

												 border-bottom-color="grey"
												 border-bottom-width="0.5pt"
												 border-bottom-style="solid">
						<xsl:for-each select="tr">
							<fo:table-row>
								<xsl:for-each select="th">
									<fo:table-cell border-top-color="grey"
																 border-top-width="0.5pt"
																 border-top-style="solid"

																 border-bottom-color="grey"
																 border-bottom-width="0.5pt"
																 border-bottom-style="solid"

																 padding-left="3pt"
																 padding-right="3pt"
																 padding-top="3pt"
																 padding-bottom="3pt">
										<fo:block font-family="sans-serif"
							                font-size="10pt"
							                font-weight="700">
											<xsl:apply-templates />
										</fo:block>
									</fo:table-cell>
								</xsl:for-each>
								<xsl:for-each select="td">
									<fo:table-cell border-top-color="grey"
																 border-top-width="0.5pt"
																 border-top-style="solid"

																 border-bottom-color="grey"
																 border-bottom-width="0.5pt"
																 border-bottom-style="solid"

																 padding-left="3pt"
																 padding-right="3pt"
																 padding-top="3pt"
																 padding-bottom="3pt">
										<fo:block>
											<xsl:apply-templates />
										</fo:block>
									</fo:table-cell>
								</xsl:for-each>
							</fo:table-row>
						</xsl:for-each>
					</fo:table-body>
				</xsl:when>

				<!-- Multi-column (more than two) tables -->
				<xsl:otherwise>
					<xsl:for-each select="tr[1]/th | tr[1]/td">
						<!-- Fit table to area width plus 1.75in (table-wide) -->
						<fo:table-column>
							<xsl:attribute name="column-width">
								<xsl:call-template name="calculate.col.width">
									<xsl:with-param name="areawidth">
										<xsl:value-of select="$areaWidth" />
									</xsl:with-param>
									<xsl:with-param name="colcount">
										<xsl:value-of select="$colCount" />
									</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
						</fo:table-column>
					</xsl:for-each>
					<fo:table-body font-family="Syntax-Roman"
												 font-size="{$base-size}"
												 font-weight="200"
												 space-after="12pt"

												 border-top-color="grey"
												 border-top-width="0.5pt"
												 border-top-style="solid"

												 border-bottom-color="grey"
												 border-bottom-width="0.5pt"
												 border-bottom-style="solid">
						<xsl:for-each select="tr">
							<fo:table-row>
								<xsl:for-each select="th">
									<fo:table-cell border-top-color="grey"
																 border-top-width="0.5pt"
																 border-top-style="solid"

																 border-bottom-color="grey"
																 border-bottom-width="0.5pt"
																 border-bottom-style="solid"

																 padding-left="3pt"
																 padding-right="3pt"
																 padding-top="3pt"
																 padding-bottom="3pt">
										<fo:block font-family="sans-serif"
							                font-size="10pt"
							                font-weight="700">
											<xsl:apply-templates />
										</fo:block>
									</fo:table-cell>
								</xsl:for-each>
								<xsl:for-each select="td">
									<fo:table-cell border-top-color="grey"
																 border-top-width="0.5pt"
																 border-top-style="solid"

																 border-bottom-color="grey"
																 border-bottom-width="0.5pt"
																 border-bottom-style="solid"

																 padding-left="3pt"
																 padding-right="3pt"
																 padding-top="3pt"
																 padding-bottom="3pt">
										<fo:block>
											<xsl:apply-templates />
										</fo:block>
									</fo:table-cell>
								</xsl:for-each>
							</fo:table-row>
						</xsl:for-each>
					</fo:table-body>
				</xsl:otherwise>
			</xsl:choose>
		</fo:table>
	</xsl:template>

	<!--
		Named template to calculate column widths for tables of more
		than two columns.

		<P>
		This template simply divides the available page width by the
		number of columns in the table producing a table with equal
		column widths.
		</P>

		@param    colcount    number of columns in the table
		@param    areawidth   the page width available
	-->
	<xsl:template name="calculate.col.width">
		<xsl:param name="colcount" />
		<xsl:param name="areawidth" />
		<xsl:variable name="width">
			<xsl:value-of select="$areawidth div $colcount" />
		</xsl:variable>
		<xsl:variable name="units">
			<xsl:text>in</xsl:text>
		</xsl:variable>
		<!-- Return width and units -->
		<xsl:value-of select="$width" />
		<xsl:value-of select="$units" />
	</xsl:template>

</xsl:stylesheet>
