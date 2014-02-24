<?xml version="1.0"?>

<!-- ............................................................. -->
<!-- File:  static_content_fo.xsl                                  -->
<!--                                                               -->
<!-- Purpose:  Contains formatting description for static content. -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 20.Apr.2001    Created.                                       -->
<!-- ............................................................. -->

<!--
	<CODE>static_content_fo.xsl</CODE> contains a template that defines
	the	target document's unchanging, repeated content.
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
<!-- Headers and footers (static content) ........................ -->

	<!--
		Contains <CODE>fo:static-content</CODE> elements.

		<P>
		The following <CODE>fo:static-content</CODE> elements define the
		unchanging content of the target document:
		</P>

		<UL>
			<LI><CODE>flow-name="chapter_header"</CODE> &#151; formats the
			document's main heading for each chapter</LI>
			<LI><CODE>flow-name="odd_footer"</CODE> &#151; formats the
			footer information (chapter title and page number) for each
			right hand page</LI>
			<LI><CODE>flow-name="even_footer"</CODE> &#151; formats the
			footer information (chapter title and page number) for each
			left hand page</LI>
		</UL>
	-->
	<xsl:template name="static_content">
		<fo:static-content flow-name="chapter_header">
			<fo:block font-family="Futura-Bold"
								font-size="24pt"
								padding-start="0.25in"
								color="white"
								background-color="#990033"
								padding-before="1.5in"
								padding-after="0.2in">
				<xsl:text>Chapter </xsl:text><xsl:number format="1"/>
			</fo:block>
		</fo:static-content>

		<fo:static-content flow-name="odd_footer">
			<fo:block text-align="end">
				<fo:inline font-family="Futura-Light"
									 font-size="8pt"
									 font-weight="200"
									 color="#990033">
					<xsl:text>CHAPTER </xsl:text><xsl:number format="1"/>
				</fo:inline>
				<fo:inline color="white">
					<xsl:text>oOoOo</xsl:text>
				</fo:inline>
				<fo:inline font-family="Futura-Bold"
									 text-align="end"
									 font-size="10pt"
									 color="#990033">
					<fo:page-number />
				</fo:inline>
			</fo:block>
			<fo:block text-align="end">
				<fo:inline font-family="Futura-Bold"
									 font-size="8pt"
									 color="#990033">
					<xsl:value-of select="./sectionTitle" />
				</fo:inline>
				<fo:inline color="white">
					<xsl:text>oOoOo</xsl:text>
				</fo:inline>
				<fo:inline font-family="Futura-Bold"
									 text-align="end"
									 font-size="10pt"
									 color="white">
					<fo:page-number />
				</fo:inline>
			</fo:block>
		</fo:static-content>

		<fo:static-content flow-name="even_footer">
			<fo:block text-align="start">
				<fo:inline font-family="Futura-Bold"
									 font-size="10pt"
									 color="#990033">
					<fo:page-number />
				</fo:inline>
				<fo:inline color="white">
					<xsl:text>oOoOo</xsl:text>
				</fo:inline>
				<fo:inline font-family="Futura-Light"
									 text-align="start"
									 font-size="8pt"
									 font-weight="200"
									 color="#990033">
					<xsl:text>CHAPTER </xsl:text><xsl:number format="1"/>
				</fo:inline>
			</fo:block>
			<fo:block text-align="start">
				<fo:inline font-family="Futura-Bold"
									 text-align="end"
									 font-size="10pt"
									 color="white">
					<fo:page-number />
				</fo:inline>
				<fo:inline color="white">
					<xsl:text>oOoOo</xsl:text>
				</fo:inline>
				<fo:inline font-family="Futura-Bold"
									 font-size="8pt"
									 font-weight="200"
									 color="#990033">
					<xsl:value-of select="./sectionTitle" />
				</fo:inline>
			</fo:block>
		</fo:static-content>
		
		<fo:static-content flow-name="odd_footer_toc">
			<fo:block text-align="end">
				<fo:inline font-family="Futura-Light"
									 font-size="8pt"
									 font-weight="200"
									 color="#990033">
					<xsl:text>CONTENTS</xsl:text>
				</fo:inline>
				<fo:inline color="white">
					<xsl:text>oOoOo</xsl:text>
				</fo:inline>
				<fo:inline font-family="Futura-Bold"
									 text-align="end"
									 font-size="10pt"
									 color="#990033">
					<fo:page-number />
				</fo:inline>
			</fo:block>
			<fo:block text-align="end">
				<fo:inline color="white">
					<xsl:text>oOoOo</xsl:text>
				</fo:inline>
				<fo:inline font-family="Futura-Bold"
									 text-align="end"
									 font-size="10pt"
									 color="white">
					<fo:page-number />
				</fo:inline>
			</fo:block>
		</fo:static-content>

		<fo:static-content flow-name="even_footer_toc">
			<fo:block text-align="start">
				<fo:inline font-family="Futura-Bold"
									 font-size="10pt"
									 color="#990033">
					<fo:page-number />
				</fo:inline>
				<fo:inline color="white">
					<xsl:text>oOoOo</xsl:text>
				</fo:inline>
				<fo:inline font-family="Futura-Light"
									 text-align="start"
									 font-size="8pt"
									 font-weight="200"
									 color="#990033">
					<xsl:text>CONTENTS</xsl:text>
				</fo:inline>
			</fo:block>
			<fo:block text-align="start">
				<fo:inline font-family="Futura-Bold"
									 text-align="end"
									 font-size="10pt"
									 color="white">
					<fo:page-number />
				</fo:inline>
			</fo:block>
		</fo:static-content>
		
		
	<!-- Tabular footer layout, odd -->
	<!--
		<fo:static-content flow-name="odd_footer">
			<fo:table>
				<fo:table-column column-width="3.0in" />
				<fo:table-column column-width="4.5in" />
				<fo:table-column column-width="0.25in" />
				<fo:table-body font-family="sans-serif"
											 font-size="9pt"
											 font-weight="200">
					<fo:table-row>
						<fo:table-cell background-color="pink">
							<fo:block color="white">
								<xsl:text>oOo</xsl:text>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="3pt"
													background-color="yellow">
							<fo:block text-align="end">
								<xsl:text>CHAPTER XX</xsl:text>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-left-color="darkred"
													 border-left-width="0.5pt"
													 border-left-style="solid"
													 padding="3pt"
													 background-color="lightgreen">
							<fo:block text-align="end"
												font-weight="700">
								<fo:page-number />
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell background-color="pink">
							<fo:block color="white">
								<xsl:text>oOo</xsl:text>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="3pt"
													 background-color="yellow">
							<fo:block text-align="end">
								<xsl:value-of select="./sectionTitle" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-left-color="darkred"
													 border-left-width="0.5pt"
													 border-left-style="solid"
													 background-color="lightgreen">
							<fo:block color="white">
								<xsl:text>oOo</xsl:text>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:static-content>
	-->

	<!-- Tabular footer layout, even -->
	<!--
		<fo:static-content flow-name="even_footer">
			<fo:table background-color="pink">
				<fo:table-column column-width="0.25in" />
				<fo:table-column column-width="4.25in" />
				<fo:table-column column-width="3.0in" />
				<fo:table-body font-family="sans-serif"
											 font-size="9pt"
											 font-weight="200">
					<fo:table-row>
						<fo:table-cell border-right-color="darkred"
													 border-right-width="0.5pt"
													 border-right-style="solid"
													 padding="3pt"
													 background-color="pink">
							<fo:block text-align="start"
												font-weight="700">
								<fo:page-number />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="3pt"
													 background-color="yellow">
							<fo:block>
								<xsl:text>CHAPTER XX</xsl:text>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="lightgreen">
							<fo:block color="white">
								<xsl:text>oOo</xsl:text>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell border-right-color="darkred"
													 border-right-width="0.5pt"
													 border-right-style="solid"
													 background-color="pink">
							<fo:block color="white">
								<xsl:text>oOo</xsl:text>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="3pt"
													 background-color="yellow">
							<fo:block text-align="start">
								<xsl:value-of select="./sectionTitle" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="lightgreen">
							<fo:block color="white">
								<xsl:text>oOo</xsl:text>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:static-content>
	-->

	</xsl:template>

</xsl:stylesheet>
