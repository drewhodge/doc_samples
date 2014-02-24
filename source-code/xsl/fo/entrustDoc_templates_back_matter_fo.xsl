<?xml version="1.0"?>

<!-- ............................................................. -->
<!-- File:  entrustDoc_templates_back_matter_fo.xsl                -->
<!--                                                               -->
<!-- Purpose:  Contains templates for generating back matter.      -->
<!--                                                               -->
<!-- ............................................................. -->
<!-- Notes:                                                        -->
<!-- 27.Jul.2001    Created.                                       -->
<!-- 04.Mar.2002    Modified processing logic for index terms.     -->
<!-- ............................................................. -->

<!-- Create entities to make it easier to convert between cases
		 later on. -->
<!DOCTYPE stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
]>

<!--
	Contains templates to process the target document's index page.
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
<!-- Top level elements .......................................... -->
	
	<!-- Store indexterm term attibutes in a hash table using a key. -->
	<xsl:key name="index" match="indexTerm/@term" use="translate(substring(.,1,1), &lowercase;, &uppercase;)" />

<!-- Index page templates ........................................ -->

	<!--
		This named template formats the heading for the Index page.
		
		<P>
		The template calls a named template (<CODE>create_index</CODE>)
		to generate individual sections and index entries within each
		section.
		</P>
	-->
	<xsl:template name="doc_index">	
		<fo:block	font-family="sans-serif"
							font-size="28pt"
							font-weight="700"
							color="darkred"
							space-after="12pt">
			<xsl:text>Index</xsl:text>
		</fo:block>
		<xsl:call-template name="create_index" />
	</xsl:template>
	
	<!--
		The <CODE>create_index</CODE> template prepares for the creation
		of individual index sections
		
		<P>
		The template is a recursive template that steps through the 
		alphabet and calls the <CODE>create_index_section</CODE> to 
		create individual sections for each <CODE>&gt;indexterm&lt;</CODE>
		element.
		</P>
		
		@param  letters
						The letters of the alphabet, decreasing by one letter
						after each recursion step
		@param  letter
						A single letter, A, B, C, ... ,Z
		@param  remainder
						The remaining letters of the alphabet after each
						recursion step	
	-->
	<xsl:template name="create_index">
		<xsl:param name="letters" select="&uppercase;" />
		<xsl:call-template name="create_index_section">
			<xsl:with-param name="letter" select="substring($letters,1,1)" />
		</xsl:call-template>
		<xsl:variable name="remainder" select="substring($letters,2)" />
		<xsl:if test="$remainder">
			<xsl:call-template name="create_index">
				<xsl:with-param name="letters" select="$remainder" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!--
		The <CODE>create_index_section</CODE> template creates the
		indivual sections of the index.
		
		<P>
		The template receives letters as the param <CODE>letter</CODE>,
		and uses the <CODE>key</CODE> function to determine whether there
		are any index terms that match the given parameter.  If there are,
		the template creates the index section for the letter and calls
		<CODE>apply-templates</CODE> for the appropriate index term.
		</P>
		
		@param  letter
					  A single letter, A, B, C, ... ,Z
		@param  terms
						The index terms extraced from the <CODE>index</CODE> key
						by the <CODE>key</CODE> function
	
	-->
	<xsl:template name="create_index_section">
		<xsl:param name="letter" />
		<xsl:variable name="terms" select="key('index', $letter)" />
		<xsl:if test="$terms">
			<fo:block font-family="sans-serif"
								font-size="16pt"
								font-weight="700"
								space-before="12pt"
								space-after="6pt"
								color="darkred">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$letter" />
			</fo:block>
			<xsl:apply-templates select="$terms">
				<xsl:sort select="." />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<!--
		Matches <CODE>term</CODE> attributes in <CODE>indexterm</CODE>
		elements for processing individual sections.
		
		<P>
		The template creates a unique entry for each index term and 
		appends a comma separated list of linked page number references.
		</P>
	-->
	<xsl:template match="indexTerm/@term">
		<fo:block font-family="Syntax-Roman"
							font-size="{$base-size}"
							font-weight="200">
			<xsl:value-of select="self::node()[not(self::node()=preceding::indexTerm/@term)]" />
			<xsl:text> </xsl:text>	
			<xsl:if test="self::node()[not(self::node()=preceding::indexTerm/@term)]">
				<xsl:for-each select="//@term[self::node()=current()]">
					<!-- Dynamic linking is not yet working.  Probably 
					something to do with the area returned by the page-
					number-citation object.  If an xsl:text element, with
					arbitrary content (eg. #, or a space), is placed before 
					and after the fo:page-number-citation, the link works. -->
						<fo:inline font-family="Syntax-Roman"
											 font-size="{$base-size}"
											 font-weight="200">
							<fo:basic-link internal-destination="{generate-id(..)}">
								<xsl:text> </xsl:text><fo:page-number-citation ref-id="{generate-id(..)}" /><xsl:text> </xsl:text>
							</fo:basic-link>
								<xsl:if test="position()!=last()">
									<xsl:text>   </xsl:text>
								</xsl:if>
						</fo:inline>
				</xsl:for-each>
			</xsl:if>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>