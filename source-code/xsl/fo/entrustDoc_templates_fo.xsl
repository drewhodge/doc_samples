<?xml version="1.0"?>

<!-- ............................................................. -->
<!-- File:  entrustDoc_templates_fo.xsl                            -->
<!--                                                               -->
<!-- Purpose:  Contains entrustDoc-specific templates.             -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 20.Apr.2001    Created.                                       -->
<!-- 25.Jul.2001    XSLDoc comments added.                         -->
<!-- ............................................................. -->

<!--
	Contains templates for chapter-level elements in the XSL:FO document.

	<P>
	The templates in this stylesheet contain both block and inline FO
	elements that process elements in the source such as
	section headings, lists, figures (images), <CODE>&lt;CODE&gt;</CODE>,
	and <CODE>&lt;PRE&gt;</CODE> elements.
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

<!-- ............................................................. -->
<!-- Templates ................................................... -->

<!-- Cancel default templates -->
<!-- <xsl:template match="*" /> -->

<!-- First page of each chapter .................................. -->

	<!--
		Matches the immediate <CODE>&lt;section&gt;</CODE> children of the
		document root.

		<P>
		This template processes only those elements that should appear on
		the first page of each chapter.
		</P>
	-->
	<xsl:template match="section[parent::entrustDoc]">
		<fo:block	font-family="Futura-Bold"
							font-size="24pt"
							color="#990033"
							start-indent="-0.5in"
							space-after="12pt"
							keep-with-next="always"
							id="{generate-id(.)}">
			<xsl:value-of select="./sectionTitle" />
		</fo:block>
		<fo:block	font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200"
							space-before="12pt"
							space-after="12pt"
							keep-with-next="always">
			<xsl:apply-templates select="p" />
			<xsl:apply-templates select="ul" />
			<xsl:apply-templates select="table" />
		</fo:block>
	</xsl:template>

<!-- General section templates (block level) ..................... -->

	<!--
	Matches <CODE>&lt;section&gt;</CODE> elements.

	<P>
	This template does nothing, but allows the processor to move on to
	its child elements.
	</P>
	-->
	<!--
	<xsl:template match="section">
		<xsl:apply-templates />
	</xsl:template>
	-->

	<!-- Section heading (level 2) -->
	<!--<xsl:template match="//section[2]/sectionTitle">-->
	<!--
		Matches <CODE>&lt;sectionTitle&gt;</CODE> elements that are
		heading level 2.

		<P>
		The <CODE>for-each</CODE> block changes the context to the
		element's parent <CODE>section</CODE> element and generates
		a unique ID as a target for the link from the TOC. The
		<CODE>fo:block</CODE> formats a level 2 heading.
		</P>
	-->
	<xsl:template match="section[parent::section[parent::entrustDoc]]/sectionTitle">
	<!--
		<xsl:for-each select="parent::node()">
			<fo:block id="{generate-id(.)}" />
		</xsl:for-each>
	-->
		<fo:block	font-family="Futura-Bold"
							start-indent="-0.5in"
							font-size="20pt"
							space-after="6pt"
							keep-with-next="always"
							id="{generate-id(.)}">
			<!-- <xsl:value-of select="." /> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- Section headings (level 3) -->
	<!--<xsl:template match="//section[3]/sectionTitle">-->
	<!--
		Matches <CODE>&lt;sectionTitle&gt;</CODE> elements that are
		heading level 3.

		<P>
		The <CODE>for-each</CODE> block changes the context to the
		element's parent <CODE>section</CODE> element and generates
		a unique ID as a target for the link from the TOC. The
		<CODE>fo:block</CODE> formats a level 3 heading.
		</P>
	-->
	<xsl:template match="section[parent::section[parent::section[parent::entrustDoc]]]/sectionTitle">
	<!--
		<xsl:for-each select="parent::node()">
			<fo:block id="{generate-id(.)}" />
		</xsl:for-each>
	-->
		<fo:block	font-family="Futura-Bold"
							font-size="15pt"
							space-after="6pt"
							keep-with-next="always"
							id="{generate-id(.)}">
			<!-- <xsl:value-of select="." /> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- Section headings (level 4) -->
	<!--<xsl:template match="//section[4]/sectionTitle">-->
	<!--
		Matches <CODE>&lt;sectionTitle&gt;</CODE> elements that are
		heading level 4.

		<P>
		The <CODE>for-each</CODE> block changes the context to the
		element's parent <CODE>section</CODE> element and generates
		a unique ID as a target for the link from the TOC. The
		<CODE>fo:block</CODE> formats a level 4 heading.
		</P>
	-->
	<xsl:template match="section[parent::section[parent::section[parent::section[parent::entrustDoc]]]]/sectionTitle | figure/figureTitle">
		<fo:block	font-family="Futura-Bold"
							font-size="10pt"
							space-after="3pt"
							keep-with-next="always">
			<!-- <xsl:value-of select="." /> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- Section headings (level 5) -->
	<!--<xsl:template match="//section[5]/sectionTitle">-->
	<!--
		Matches <CODE>&lt;sectionTitle&gt;</CODE> elements that are
		heading level 5.

		<P>
		The	<CODE>fo:block</CODE> formats a level 5 heading.
		</P>
	-->
	<xsl:template match="section[parent::section[parent::section[parent::section[parent::section[parent::entrustDoc]]]]]/sectionTitle">
		<fo:block	font-family="Futura-Book"
							font-size="10pt"
							space-after="6pt"
							keep-with-next="always">
			<!-- <xsl:value-of select="." /> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!--
		Matches nested <CODE>&lt;section&gt;</CODE> elements and applies
		templates.
	-->
	<xsl:template match="section/section">
		<fo:block	font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200"
							space-after="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- Subsections -->
	<!--
		Matches <CODE>&lt;subSection&gt;</CODE> elements and applies
		templates.
	-->
	<xsl:template match="subSection">
		<fo:block	font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200"
							space-after="12pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!--
		Matches <CODE>&lt;sectionTitle&gt;</CODE> elements whose immediate
		parents are <CODE>&lt;subSection&gt;</CODE> elements.

		<P>
		The	<CODE>fo:block</CODE> formats a level 2 heading.
		</P>
	-->
	<xsl:template match="subSection/sectionTitle">
		<fo:block	font-family="Futura-Bold"
							font-size="12pt"
							space-before="12pt"
							space-after="6pt"
							keep-with-next="always">
			<xsl:value-of select="." />
		</fo:block>
	</xsl:template>

	<!-- General paragraph -->
	<!--
		Matches paragraph, <CODE>&lt;p&gt;</CODE>, elements and applies
		templates.
	-->
	<xsl:template match="p">
		<fo:block	font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200"
							space-after="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- Lists -->
	<!--
		Matches both ordered and unordered list elements.

		<P>
		For each <CODE>li</CODE> element, the template determines whether
		it is an immediate child of a <CODE>ul</CODE>, an <CODE>ol</CODE>, or
		another <CODE>li</CODE> element and formats the list, or sublist
		accordingly.
		</P>

		<P>
		Sublists are formatted using a, b, ... n.  Ordered lists are
		formatted using 1, 2, ... n.
		</P>
	-->
	<xsl:template match="ul | ol">
		<fo:list-block font-family="Syntax-Roman"
									 font-size="{$base-size}"
									 font-weight="200"

									 space-after="6pt">
			<xsl:for-each select="li">
				<fo:list-item space-after="3pt">
					<fo:list-item-label end-indent="label-end()"
															font-size="{$base-size}"
															font-weight="200">
						<fo:block >
							<xsl:choose>
								<xsl:when test="parent::ol[parent::li]">
									<xsl:number format="a" />
								</xsl:when>
								<xsl:when test="parent::ol[not(parent::li)]">
									<xsl:number format="1" />
								</xsl:when>
								<xsl:when test="parent::ul[parent::li]">
									<xsl:text>-</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline>&#8226;</fo:inline>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()"
														 space-after="6pt">
						<fo:block>
							<xsl:apply-templates />
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:for-each>
		</fo:list-block>
	</xsl:template>

	<!--Use [white-space="pre"] for XSLFormatter -->
	<!--
		Matches preformated <CODE>pre</CODE> elements.

		<P>
		The <CODE>fo:block</CODE> creates monospaced text a little smaller
		than the surrounding text (9pt), and the text area has a
		background colour set to an RGB value of DDDDDD (Hex).
		</P>
	-->
	<xsl:template match="pre">
		<fo:block font-family="monospace"
							font-size="9pt"
							font-weight="200"
							end-indent="-1.75in"
							space-after="6pt"
							padding-left="6pt"
							padding-top="3pt"
							padding-bottom="3pt"
							white-space-collapse="false"
							background-color="#DDDDDD">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!--
		Matches <CODE>strong</CODE> elements that are children of
		<CODE>pre</CODE> elements.

		<P>
		The <CODE>fo:inline</CODE> creates monospaced text with
		a background colour set to an RGB value of DDDDDD. Font
		weight is set to 700 to format the output as bold.
		</P>
	-->
	<xsl:template match="pre/strong">
		<fo:inline font-family="monospace"
							font-size="9pt"
							font-weight="700"
							white-space-collapse="false"
							background-color="#DDDDDD">
			<xsl:value-of select="." />
		</fo:inline>
	</xsl:template>

	<!-- Notes -->
	<!--
		Matches definition terms within definition lists.

		<P>
		The template formats and writes the value of the <CODE>dt</CODE>
		element and then applies the template matching the
		<CODE>dd</CODE> element.
		</P>
	-->
	<xsl:template match="dl/dt">
		<fo:block font-family="Futura-Bold"
							font-size="{$base-size}"
							space-before="3pt"
							space-after="3pt">
			<xsl:value-of select="." />
			<xsl:apply-templates select="dd" />
		</fo:block>
	</xsl:template>

	<!--
		Matches <CODE>dd</CODE> elements and applies templates.
	-->
	<xsl:template match="dd">
		<fo:block font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200"
							start-indent="0.25in"
							space-after="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!--
		Matches <CODE>dl</CODE> elements nested within <CODE>dd</CODE>
		elements and applies templates.
	-->
	<xsl:template match="ol/li/dl/dd|ul/li/dl/dd">
		<fo:block font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200"
							start-indent="(body-start() + 0.25in)"
							space-after="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!--
		Matches and process <CODE>&lt;note&gt;</CODE>, elements.

		<P>
		The template formates and writes the <STRONG>Note</STRONG>
		heading and then applies the template matching <CODE>dl/dt</CODE>.
		</P>
	-->
	<xsl:template match="note">
		<fo:block font-family="Futura-Bold"
							font-size="{$base-size}"
							space-before="3pt"
							space-after="6pt">
			<xsl:text>Note</xsl:text>
			<xsl:apply-templates select="dl/dt" />
		</fo:block>
	</xsl:template>

	<!--
		Matches <CODE>p</CODE> elements that are children of
		<CODE>note</CODE> elements and applies templates.
	-->
	<xsl:template match="note/p">
		<fo:block	font-family="Syntax-Bold"
							font-size="{$base-size}"
							font-weight="200"
							start-indent="0.5in"
							space-after="12pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!--
	<xsl:template match="figure/figureTitle" />
	-->

	<!-- Images -->
	<!--
		Matches <CODE>figureSource</CODE> elements.

		<P>
		The template creates a variable representing the path to the image
		source and uses it as the value for the <CODE>src</CODE> attribute
		of the <CODE>fo:external-graphic</CODE> element.
		</P>
	-->
	<xsl:template match="figure/figureSource">
		<xsl:variable name="graphic" select="." />
		<xsl:variable name="path">
			<xsl:text>./</xsl:text>
			<!-- Java Prog. Guide -->
			<!--
			<xsl:text>file:///z:/entproj/src/toolkit/tkdoc/source/entrustjava/src/</xsl:text>
			-->
			<!-- JCMP Prog. Guide -->
			<!--
			<xsl:text>file:///z:/entproj/src/toolkit/tkdoc/source/wireless/etjcmptk/guide/</xsl:text>
			-->
		</xsl:variable>
		<xsl:variable name="full_path">
			<xsl:value-of select="concat($path, $graphic)" />
		</xsl:variable>
		<fo:block padding="3pt"
							space-after="3pt">
			<xsl:element name="fo:external-graphic">
				<xsl:attribute name="src">
					<xsl:value-of select="$full_path" />
				</xsl:attribute>
			</xsl:element>
		</fo:block>
	</xsl:template>

	<!--
		Matches index-term elements to create an index for the document.
	-->
	<!-- Now using the entrustTechPub element, indexTerm. 
	<xsl:template match="//*[@class='indexterm']">
		<xsl:for-each select=".">
			<fo:block id="{generate-id(.)}" />
		</xsl:for-each>
	</xsl:template>
	-->
	
<!-- General section templates (inline level) .................... -->

	<!--
		Matches <CODE>strong</CODE> elements, formats, and writes their
		values.
	-->
	<xsl:template match="strong">
		<fo:inline font-family="Syntax-Bold"
							 font-size="{$base-size}">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<!--
		Matches <CODE>code</CODE> elements, formats, and writes their
		values.
	-->
	<xsl:template match="code">
		<fo:inline font-family="monospace"
							 font-size="9pt"
							 font-weight="200">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!--
		Matches <CODE>br</CODE> element and forces a newline.
	-->
	<!--
	<xsl:template match="br">
		<fo:inline font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200">
			<xsl:text>BR element</xsl:text>
		</fo:inline>
	</xsl:template>
	-->

	<!--
		Matches <CODE>&lt;entrustTrademark&gt;</CODE> and 
		<CODE>&lt;referencedTradeMark&gt;</CODE> elements and
		replaces them with a character reference.
	-->
	<xsl:template match="entrustTrademark | referencedTrademark">
		<xsl:apply-templates />
		<xsl:text>&#8482;</xsl:text>
	</xsl:template>
	
	<!--
		Matches <CODE>&lt;entrustRegistered&gt;</CODE> and 
		<CODE>&lt;referencedTRegistered&gt;</CODE> elements and
		replaces them with a character reference.
	-->
	<xsl:template match="entrustRegistered | referencedRegistered">
		<xsl:apply-templates />
		<xsl:text>&#174;</xsl:text>
	</xsl:template>
	
	<!--
		Matches <CODE>&lt;entrustCopyright&gt;</CODE> and 
		<CODE>&lt;referencedTradeMark&gt;</CODE> elements and
		replaces them with a character reference.
	-->
	<xsl:template match="entrustCopyright | referencedCopyright">
		<xsl:apply-templates />
		<xsl:text>&#169;</xsl:text>
	</xsl:template>

	<!--
		Matches the <CODE>&lt;entrustEmdash&gt;</CODE> element and
		replaces it with a character reference.
	-->
	<xsl:template match="emDash">
		<xsl:text>&#8212;</xsl:text>
	</xsl:template>
	
	<!--
		Matches <CODE>&lt;indexTerm&gt;</CODE> elements and assigns
		them a unique id.
	-->
	<xsl:template match="indexTerm">
		<fo:inline font-family="Syntax-Roman"
							 font-size="{$base-size}"
							 font-weight="200"
							 space-after="12pt"
							 id="{generate-id(.)}">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!--
		Mathces <CODE>&lt;a&gt;</CODE> elements and creates a
		basic link with an external destination.
	-->
	<!--
	<xsl:template match="a[@target='_new']">
		<fo:inline font-family="Syntax-Roman"
							 font-size="{$base-size}"
							 font-weight="200"
							 color="#990033">
		<xsl:element name="fo:basic-link">
			<xsl:attribute name="external-destination">
				<xsl:value-of select="./@url" />
			</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
		</fo:inline>
	</xsl:template>

	<xsl:template name="create_hyperlink">
		<xsl:element name="fo:basic-link">
			<xsl:attribute name="external-destination">
				<xsl:value-of select="./@url" />
			</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	-->

	<!--
		Matches <CODE>span</CODE> elements that have a
		<CODE>dh_comment</CODE> class attribute and does nothing.
	-->
	<xsl:template match="//span[@class='dh_comment']" />



</xsl:stylesheet>
