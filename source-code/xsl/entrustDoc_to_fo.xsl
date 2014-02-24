<?xml version="1.0"?>

<!-- ............................................................. -->
<!-- File:  entrustDoc_to_fo.xsl                                   -->
<!--                                                               -->
<!-- Purpose:  Driver file for conversion of XML source conforming -->
<!--           to entrustDoc.dtd into formatting objects (fo).     -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 18.Apr.2001    Created.                                       -->
<!-- 25>Jul.2001    XSLDoc comments added.                         -->
<!-- ............................................................. -->

<!--
	<CODE>entrustDoc_to_fo.xsl</CODE> is the driver styrlesheet for
	entrustDoc to PDF conversion.

	<P>
	The design of the set of stylesheets that transforms documentation
	written to conform to the <STRONG>entrustDoc</STRONG> DTD into PDF
	is modular.  This makes the stylesheets easier to modify and to
	maintain.
	</P>

	<P>
	The stylesheets are designed to work with Apache's
	<A href="http://xml.apache.org/fop/index.html">FOP</A> (version
	0.20.1) print formatter for XSL formatting objects (XSL:FO).
	</P>
-->
<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:saxon="http://icl.com/saxon"
		extension-element-prefixes="saxon"
		xmlns:fo="http://www.w3.org/1999/XSL/Format">

<!-- ............................................................. -->
<!-- Top level elements .......................................... -->

<!-- -->
	<xsl:output method="xml"
							version="1.0"
							indent="no"
							encoding="ISO-8859-1"
							doctype-public="-//ENTRUST//DTD FO-TKML 1.0//EN"
		    			doctype-system="http://view-www.entrust.com/views/view_latest/product_docs/gecko/dtd/mod/entrustFO.dtd"/>

<!-- ............................................................. -->
<!-- Included stylesheets ........................................ -->

	<!-- Constants -->
	<xsl:include href="./fo/entrustDoc_constants_fo.xsl" />
	<!-- Static content -->
	<xsl:include href="./fo/static_content_fo.xsl" />
	<!-- Templates -->
	<!--
	<xsl:include href="./fo/entrustDoc_templates_xrefs_fo.xsl" />
	-->
	<xsl:include href="./fo/entrustDoc_templates_front_matter_fo.xsl" />
	<xsl:include href="./fo/entrustDoc_templates_back_matter_fo.xsl" />
	<xsl:include href="./fo/entrustDoc_templates_fo.xsl" />
	<xsl:include href="./fo/entrustDoc_templates_tables_fo.xsl" />


<!-- ............................................................. -->
<!-- Document root template ...................................... -->

<!--
	Matches the document root &#151; <CODE>entrustDoc</CODE>.

	<P>
	This template contains the <CODE>&lt;fo:layout-master-set&gt;</CODE>,
	<CODE>&ltpage-sequence-master&gt;</CODE>, and <CODE>&lt;page-sequence&gt;
	</CODE> elements for	the Entrust Toolkit Programmer's Guide PDF.
	<P>

	<P>
	The following	<CODE>&lt;simple-page-masters&gt;</CODE> are defined:
	</P>

	<UL>
		<LI>Blank page</LI>
		<LI>Title page</LI>
		<LI>Legal page</LI>
		<LI>TOC page &#151; left</LI>
		<LI>TOC page &#151; right</LI>
		<LI>Chapter &#151; first page</LI>
		<LI>Chapter &#151; left page (even)</LI>
		<LI>Chapter &#151; right page (odd)</LI>
	</UL>
-->
	<xsl:template match="entrustDoc">
		<fo:root font-size="{$base-size}"
						 xmlns:fox="http://xml.apache.org/fop/extensions">
			<fo:layout-master-set>

				<!-- Simple page master objects .......................... -->
				<!-- Blank page, chapter -->
				<fo:simple-page-master	master-name="blank_page"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.5in"
																margin-top="0.5in"
																margin-right="0.5in"
																margin-bottom="0.5in">

					<fo:region-body				region-name="title_body"
																margin-left="0.2in"
																margin-top="0.75in"
																margin-right="1.0in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />
																
					<fo:region-after			region-name="even_footer"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>
				
				<!-- Blank page, TOC -->
				<fo:simple-page-master	master-name="blank_page_toc"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.5in"
																margin-top="0.5in"
																margin-right="0.5in"
																margin-bottom="0.5in">

					<fo:region-body				region-name="title_body"
																margin-left="0.2in"
																margin-top="0.75in"
																margin-right="1.0in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />
																
					<fo:region-after			region-name="even_footer_toc"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>


				<!-- Title page -->
				<fo:simple-page-master	master-name="title"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.5in"
																margin-top="0.5in"
																margin-right="0.5in"
																margin-bottom="0.5in">

					<fo:region-body				region-name="title_body"
																margin-left="0.2in"
																margin-top="0.75in"
																margin-right="1.0in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- Legal page -->
				<fo:simple-page-master 	master-name="legal"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.25in"
																margin-top="0.5in"
																margin-right="0.75in"
																margin-bottom="0.5in">

					<fo:region-body				region-name="legal_body"
																margin-left="1.2in"
																margin-top="0.75in"
																margin-right="3.0in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />

					<fo:region-after			region-name="even_footer"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- TOC, left (even) page -->
				<fo:simple-page-master 	master-name="toc_page_left"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.25in"
																margin-top="0.5in"
																margin-right="0.25in"
																margin-bottom="0.5in">

					<fo:region-body				margin-left="0.5in"
																margin-top="0.75in"
																margin-right="0.75in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />

					<fo:region-after			region-name="even_footer_toc"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- TOC, right (odd) page -->
				<fo:simple-page-master 	master-name="toc_page_right"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.25in"
																margin-top="0.5in"
																margin-right="0.25in"
																margin-bottom="0.5in">

					<fo:region-body				margin-left="0.5in"
																margin-top="0.75in"
																margin-right="0.75in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />

					<fo:region-after			region-name="odd_footer_toc"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- Chapter, first page -->
				<!-- The page layout for the first page of each chapter
						 has been optimized for FOP 0.20.1. -->
				<fo:simple-page-master 	master-name="chapter_page_first"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.5in"
																margin-top="0.5in"
																margin-right="0.25in"
																margin-bottom="0.5in">

					<fo:region-body				margin-left="0.5in"
																margin-top="2.75in"
																margin-right="2.5in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />
																
					<fo:region-before			region-name="chapter_header"
																margin-left="0.1in"
																margin-top="0.1in"
																margin-right="0.1in"
																margin-bottom="0.1in"
																extent="2.5in"
																padding="6pt 0pt" />

					<fo:region-after			region-name="odd_footer"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- Chapter, left (even) page -->
				<fo:simple-page-master 	master-name="chapter_page_left"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.25in"
																margin-top="0.5in"
																margin-right="0.25in"
																margin-bottom="0.5in">

					<fo:region-body				margin-left="0.75in"
																margin-top="0.75in"
																margin-right="2.0in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />

					<fo:region-after			region-name="even_footer"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- Chapter, right (odd) page -->
				<fo:simple-page-master 	master-name="chapter_page_right"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.25in"
																margin-top="0.5in"
																margin-right="0.25in"
																margin-bottom="0.5in">

					<fo:region-body				margin-left="0.75in"
																margin-top="0.75in"
																margin-right="2.0in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />

					<fo:region-after			region-name="odd_footer"
																extent="0.5in"
																padding="6pt 0pt"/>
				</fo:simple-page-master>

				<!-- Document index, left (even) page -->
				<fo:simple-page-master 	master-name="index_page_left"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.25in"
																margin-top="0.5in"
																margin-right="0.75in"
																margin-bottom="0.5in">

					<fo:region-body				margin-left="0.5in"
																margin-top="0.75in"
																margin-right="0.75in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />

					<fo:region-after			region-name="even_footer"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- Document index, right (odd) page -->
				<fo:simple-page-master 	master-name="index_page_right"
																page-height="{$page.height}"
																page-width="{$page.width}"
																margin-left="0.75in"
																margin-top="0.5in"
																margin-right="0.25in"
																margin-bottom="0.5in">

					<fo:region-body				margin-left="0.5in"
																margin-top="0.75in"
																margin-right="0.75in"
																margin-bottom="1.0in"
																column-count="1"
																padding="6pt 0pt" />

					<fo:region-after			region-name="odd_footer"
																extent="0.5in"
																padding="6pt 0pt" />
				</fo:simple-page-master>

				<!-- Page sequence master objects ........................ -->

				<!-- Title page layout -->
				<fo:page-sequence-master master-name="title_page">
					<fo:single-page-master-reference master-reference="title" />
				</fo:page-sequence-master>

				<!-- Legal page layout -->
				<fo:page-sequence-master master-name="legal_page">
					<fo:single-page-master-reference master-reference="legal" />
				</fo:page-sequence-master>

				<!-- Table of contents -->
				<fo:page-sequence-master master-name="toc">
					<fo:repeatable-page-master-alternatives>
        		<fo:conditional-page-master-reference
        										master-reference="blank_page_toc"
                            blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference
														master-reference="toc_page_right"
														odd-or-even="odd" />
						<fo:conditional-page-master-reference
														master-reference="toc_page_left"
														odd-or-even="even" />
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>

				<!-- First page of each chapter -->
				<fo:page-sequence-master master-name="chapter_intro">
					<fo:single-page-master-reference
														master-reference="chapter_page_first" />
				</fo:page-sequence-master>

				<!-- Second and subsequent pages of each chapter -->
				<fo:page-sequence-master master-name="chapter">
					<fo:repeatable-page-master-alternatives>
        		<fo:conditional-page-master-reference
        										master-reference="blank_page"
                            blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference
														odd-or-even="even"
														master-reference="chapter_page_left" />
						<fo:conditional-page-master-reference
														odd-or-even="odd"
														master-reference="chapter_page_right" />
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>

				<!-- Document index -->
				<fo:page-sequence-master master-name="index">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference
														master-reference="index_page_right"
														odd-or-even="odd" />
						<fo:conditional-page-master-reference
														master-reference="index_page_left"
														odd-or-even="even" />
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>

			</fo:layout-master-set>

			<!-- Page sequence objects ................................. -->

			<!-- Front matter, title page. -->
			<fo:page-sequence master-reference="title_page"
												initial-page-number="auto"
												format="i">
				<fo:flow flow-name="title_body">
					<xsl:apply-templates select="./docInfo/productFamily" />
					<xsl:apply-templates select="./docInfo/productName" />
					<xsl:apply-templates select="./docInfo/releaseNumber" />
					<xsl:apply-templates select="./docInfo/documentIssue" />
					<xsl:apply-templates select="./docInfo/publicationDate" />
				</fo:flow>
			</fo:page-sequence>

			<!-- Legal information. -->
			<fo:page-sequence master-reference="legal_page"
												initial-page-number="auto">
				<fo:flow flow-name="legal_body">
					<xsl:call-template name="legal_info" />
				</fo:flow>
			</fo:page-sequence>

			<!-- Table of contents. -->
			<fo:page-sequence master-reference="toc"
												force-page-count="end-on-even"
												initial-page-number="auto"
												format="1">
				<xsl:call-template name="static_content" />
				<fo:flow flow-name="xsl-region-body">
					<xsl:call-template name="contents" />
				</fo:flow>
			</fo:page-sequence>

			<!-- Content for each section that represents a chapter. -->
			<xsl:for-each select="./section">

				<!-- First page in each chapter -->
				<fo:page-sequence master-reference="chapter_intro"
												  initial-page-number="auto"
												  format="1">
					<xsl:call-template name="static_content" />
					<fo:flow flow-name="xsl-region-body">
						<xsl:apply-templates select="." />
					</fo:flow>
				</fo:page-sequence>

				<!-- Subsequent pages -->
				<fo:page-sequence master-reference="chapter"
													force-page-count="end-on-even"
													initial-page-number="auto">
					<xsl:call-template name="static_content" />
					<fo:flow flow-name="xsl-region-body">
						<xsl:apply-templates select="section" />
					</fo:flow>
				</fo:page-sequence>

			</xsl:for-each>

			<!-- Document index -->
			<fo:page-sequence master-reference="index"
												initial-page-number="auto">
				<fo:flow flow-name="xsl-region-body">
					<xsl:call-template name="doc_index" />
				</fo:flow>
			</fo:page-sequence>

			<!-- FOP extension to produce Acrobat bookmarks.
			<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format"
							 xmlns:fox="http://xml.apache.org/fop/extensions">
				<fox:outline internal-destination="sec3">
					<fox:label>Running FOP</fox:label>
					<fox:outline internal-destination="sec3-1">
						<fox:label>Prerequisites</fox:label>
					</fox:outline>
			  <fox:outline>
			</fo:root>
			-->

			<!-- Generate Acrobat bookmarks :: FOP extension -->
			<!-- Not working in FOP 0.20.1 -->
			<fox:outline internal-destination="intro">
				<fox:label>Introduction</fox:label>
				<fox:outline internal-destination="about">
					<fox:label>About this document</fox:label>
				</fox:outline>
				<fox:outline internal-destination="related_docs">
					<fox:label>Related documentation</fox:label>
				</fox:outline>
				<fox:outline internal-destination="rec_reading">
					<fox:label>Recommentded reading</fox:label>
				</fox:outline>
				<fox:outline internal-destination="tech_support">
					<fox:label>Technical support</fox:label>
				</fox:outline>
				<fox:outline internal-destination="doc_feedback">
					<fox:label>Documentation feedback</fox:label>
				</fox:outline>
			</fox:outline>


		</fo:root>
	</xsl:template>

</xsl:stylesheet>
