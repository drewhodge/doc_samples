<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY copyright SYSTEM "../../boilerplate/legal/copyright.txt">
<!ENTITY legal_1 SYSTEM "../../boilerplate/legal/tm_statement.txt">
<!ENTITY legal_2 SYSTEM "../../boilerplate/legal/other_notice.txt">
]>

<!-- ............................................................. -->
<!-- File:  entrustDoc_templates_front_matter_fo.xsl               -->
<!--                                                               -->
<!-- Purpose:  Contains templates for creating front matter.       -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 23.Jul.2001    Created.                                       -->
<!-- ............................................................. -->

<!--
	Contains templates to process the target document's title page,
	legal and copyright information, and TOC.

	<P>
	The information for the title page is taken from the
	<CODE>docInfo</CODE> in the source document.
	</P>
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

<!-- Title page templates ........................................ -->

	<!--
		Matches the <CODE>productName</CODE> element and writes its value.
	-->
	<xsl:template match="productName">
		<fo:block font-family="Futura-Bold"
							font-size="30pt"
							space-after="30pt">
			<xsl:apply-templates />
			<xsl:text>&#8482;</xsl:text>
			<xsl:text> Programmer's Guide</xsl:text>
		</fo:block>
	</xsl:template>

	<!--
		Matches the <CODE>productFamily</CODE> element, writes its
		value, and appends <STRONG>Programmer's Guide</STRONG>.
	-->
	<xsl:template match="productFamily">
		<fo:block font-family="Futura-Bold"
							font-size="16pt"
							space-after="48pt">
			<xsl:apply-templates />
			<xsl:text>&#8482;</xsl:text>
		</fo:block>
	</xsl:template>

	<!--
		Matches the <CODE>productNumber</CODE> element, prepends
		<STRONG>Software Release:</STRONG>, and writes its value.
	-->
	<xsl:template match="releaseNumber">
		<fo:block font-family="Futura-Bold"
							space-after="6pt"
							font-size="14pt">
			<xsl:text>Software Release: </xsl:text><xsl:value-of select="." />
		</fo:block>
	</xsl:template>

	<!--
		Matches the <CODE>documentIssue</CODE> element prepends
		<STRONG>Document Issue:</STRONG>, and writes its value.
	-->
	<xsl:template match="documentIssue">
		<fo:block font-family="Futura-Bold"
							space-after="6pt"
							font-size="12pt">
			<xsl:text>Document Issue: </xsl:text><xsl:value-of select="." />
		</fo:block>
	</xsl:template>

	<!--
		Matches the <CODE>publicationDate</CODE> element.

		<P>
		The template prepares to write the date (month and year) on the
		title page of the target document.  The
		<CODE>fo:external-graphic</CODE> element formats the Entrust logo.
		</P>
	-->
	<xsl:template match="publicationDate">
		<fo:block font-family="Futura-Bold"
							space-after="36pt"
							font-size="12pt">
			<xsl:text>Date: </xsl:text>
			<xsl:value-of select="./publicationMonth" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="./publicationYear" />
		</fo:block>
		<fo:block space-before="3.5in">
			<fo:external-graphic src="/entproj/src/toolkit/tkdoc/gecko/image/entrust_logo.png" />
		</fo:block>
	</xsl:template>

<!-- Legal page templates ........................................ -->

	<!--
		This named template contains, and formats, hard-coded legal
		information for the	target document.
	-->
	<xsl:template name="legal_info">
		<fo:block	font-family="Syntax-Roman"
							font-size="8pt"
							font-weight="200"
							space-after="12pt">
			<xsl:text>&#169;&copyright;</xsl:text>
		</fo:block>
		<fo:block	font-family="Syntax-Roman"
					font-size="8pt"
					font-weight="200"
					space-after="12pt">
			<xsl:text>&legal_1;</xsl:text>
		</fo:block>
		<fo:block	font-family="Syntax-Roman"
					font-size="8pt"
					font-weight="200"
					space-after="12pt">
			<xsl:text>&legal_2;</xsl:text>
		</fo:block>
		<!--
		<fo:block	font-family="Helvetica"
					font-size="{$base-size}"
					font-weight="200"
					space-after="12pt">
			<xsl:text>Cryptographic products are subject to export and import
			restrictions.  You are required to obtain the appropriate
			government license prior to shipping this product.</xsl:text>
		</fo:block>
		<fo:block	font-family="Helvetica"
					font-size="{$base-size}"
					font-weight="200"
					space-after="12pt">
			<xsl:text>Published in Switzerland.</xsl:text>
		</fo:block>
		-->
	</xsl:template>

<!-- Table of contents templates ................................. -->

	<!--
		This named template formats the headings for the TOC.

		<P>
		The template contains two for-each loops that extract the
		<CODE>sectionTitle</CODE> elements for nested sections.  This
		creates TOC level 2 and level 3 headings.
		</P>
	-->
	<xsl:template name="contents">
		<fo:block	font-family="Futura-Bold"
							font-size="24pt"
							color="#990033"
							space-after="12pt">
			<xsl:text>Contents</xsl:text>
		</fo:block>
		
<!-- ///////////////////////////////////////////////////////////// -->
<!-- // TOC with dynamic leader lengths. ///////////////////////// -->
		
		<!-- An entry for each chapter. -->
		<xsl:for-each select="section[parent::entrustDoc]">
			<!-- TOC level 1 -->
			<fo:block font-family="sans-serif"
								font-size="12pt"
								font-weight="700"
								color="#990033"
								space-before="12pt">
				<fo:basic-link internal-destination="{generate-id(.)}">
					<xsl:text>Chapter </xsl:text><xsl:number format="1"/>
				</fo:basic-link>
			</fo:block>
			
			<fo:block font-family="sans-serif"
								font-size="12pt"
								font-weight="700"
								color="#990033"
								space-after="12pt"
								text-align-last="justify">
				<fo:basic-link internal-destination="{generate-id(.)}">
					<xsl:value-of select="sectionTitle"/>
				</fo:basic-link>
				<xsl:text> </xsl:text>
				<fo:leader leader-pattern="dots"
									 leader-pattern-width="0.1in"/>
				<xsl:text> </xsl:text>
				<fo:basic-link internal-destination="{generate-id(.)}">
					<xsl:text> </xsl:text><fo:page-number-citation ref-id="{generate-id(.)}"/><xsl:text> </xsl:text>
				</fo:basic-link>
			</fo:block>
			
				<xsl:for-each select="section[parent::section[parent::entrustDoc]]/sectionTitle">
					<!-- TOC level 2 -->
					<fo:block font-family="Syntax-Roman"
										font-size="10pt"
										font-weight="200"
										space-before="5pt"
										space-after="5pt"
										text-indent="0.65in"
										text-align-last="end"
										> <!-- text-align-last="end" -->
						<xsl:text> </xsl:text>
						<fo:basic-link internal-destination="{generate-id(.)}">
							<xsl:apply-templates />
						</fo:basic-link>
						<xsl:text>  </xsl:text>
						<fo:leader leader-pattern="dots"
											 leader-pattern-width="0.1in"/>
						<xsl:text> </xsl:text>
						<fo:basic-link internal-destination="{generate-id(.)}">
							<xsl:text> </xsl:text><fo:page-number-citation ref-id="{generate-id(.)}"/><xsl:text> </xsl:text>
						</fo:basic-link>
					</fo:block>

						<xsl:for-each select="../section[parent::section[parent::section[parent::entrustDoc]]]/sectionTitle">
							<!-- TOC level 3 -->
							<fo:block font-family="Syntax-Roman"
												font-size="10pt"
												font-weight="200"
												space-after="3pt"
												text-indent="0.85in"
												text-align-last="end">
								<xsl:text> </xsl:text>
								<fo:basic-link internal-destination="{generate-id(.)}">
							    <xsl:apply-templates />
								</fo:basic-link>
								<xsl:text>  </xsl:text>
								<fo:leader leader-pattern="dots"
													 leader-pattern-width="0.1in"/>
								<xsl:text> </xsl:text>
								<fo:basic-link internal-destination="{generate-id(.)}">
									<xsl:text> </xsl:text><fo:page-number-citation ref-id="{generate-id(.)}"/><xsl:text> </xsl:text>
								</fo:basic-link>
							</fo:block>
					
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
				
<!-- // End dynamic leader length TOC //////////////////////////// -->
		
		
<!-- ///////////////////////////////////////////////////////////// -->
<!-- // TOC using fo:table :: no dynamic leader lengths. ///////// -->
				
		<!-- An entry for each chapter. -->
		<!--
		<fo:table>
			<fo:table-column column-width="5.0in" />
			<fo:table-column column-width="0.5in" />
			<fo:table-column column-width="0.5in" />

			<fo:table-body space-after="6pt">
		-->

				<!-- TOC level 1 -->
				<!--
				<xsl:for-each select="section[parent::entrustDoc]">
					<fo:table-row>
						<fo:table-cell>
							<fo:block font-family="Futura-Book"
												font-size="12pt"
												color="#990033"
												text-align="start"
												space-before="12pt">
								<fo:basic-link internal-destination="{generate-id(.)}">
									<xsl:text>CHAPTER </xsl:text><xsl:number format="1"/>
								</fo:basic-link>
							</fo:block>
							<fo:block font-family="Futura-Bold"
												font-size="12pt"
												color="#990033">
								<fo:basic-link internal-destination="{generate-id(.)}">
									<xsl:value-of select="sectionTitle"/>
								</fo:basic-link>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-before="12pt">
							<fo:block text-align-last="end"
												space-before="12pt"
												color="white">
								<xsl:text>oOo</xsl:text>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-before="12pt">
							<fo:block font-family="Futura-Bold"
												font-size="12pt"
												color="#990033"
												text-align="end"
												space-before="12pt">
								<fo:basic-link internal-destination="{generate-id(.)}">
									<fo:page-number-citation ref-id="{generate-id(.)}"/>
								</fo:basic-link>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					-->

						<!-- TOC level 2 -->
						<!--
						<xsl:for-each select="section[parent::section[parent::entrustDoc]]/sectionTitle">
							<fo:table-row>
								<fo:table-cell>
									<fo:block font-family="Syntax-Roman"
														font-size="10pt"
														font-weight="200"
														space-before="5pt"
														space-after="5pt"
														margin-left="1.0in"
														text-align="start">
										<xsl:text> </xsl:text>
										<fo:basic-link internal-destination="{generate-id(.)}">
											<xsl:value-of select="."/>
										</fo:basic-link>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block text-align-last="end"
														space-before="12pt"
														color="white">
										<xsl:text>oOo</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block font-family="Syntax-Roman"
														font-size="10pt"
														font-weight="200"
														space-before="5pt"
														space-after="5pt"
														text-align="end">
										<fo:basic-link internal-destination="{generate-id(.)}">
											<fo:page-number-citation ref-id="{generate-id(.)}"/>
										</fo:basic-link>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						-->
							
							
						<!-- TOC level 3 -->
						<!--
						<xsl:for-each select="../section[parent::section[parent::section[parent::entrustDoc]]]/sectionTitle">
							<fo:table-row>
								<fo:table-cell>
									<fo:block font-family="Syntax-Roman"
														font-size="10pt"
														font-weight="200"
														space-after="3pt"
														margin-left="1.5in"
														text-align="start">
										<xsl:text> </xsl:text>
										<fo:basic-link internal-destination="{generate-id(.)}">
											<xsl:value-of select="."/>
										</fo:basic-link>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block text-align="end"
														color="white">
										<xsl:text>oOo</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block font-family="Syntax-Roman"
														font-size="10pt"
														font-weight="200"
														space-after="3pt"
														text-align="end">
										<fo:basic-link internal-destination="{generate-id(.)}">
											<fo:page-number-citation ref-id="{generate-id(.)}"/>
										</fo:basic-link>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>

						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>

			</fo:table-body>
		</fo:table>
		-->
		
<!-- // End table TOC //////////////////////////////////////////// -->	

		<!-- An entry for the last page. -->
		<!--
		<fo:block space-before="12pt"
					 start-indent="0.5in"
					 end-indent="0.25in"
					 text-align-last="justify">
			<fo:basic-link internal-destination="{generate-id(/)}">
				Last page of book
			</fo:basic-link>
			<xsl:text> </xsl:text>
			<fo:leader leader-pattern="dots"/>
			<xsl:text> </xsl:text>
			<fo:basic-link internal-destination="{generate-id(/)}">
				<fo:page-number-citation ref-id="{generate-id(/)}"/>
			</fo:basic-link>
		</fo:block>
		-->

	</xsl:template>

</xsl:stylesheet>
