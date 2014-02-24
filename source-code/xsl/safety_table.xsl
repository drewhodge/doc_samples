<?xml version="1.0" encoding="UTF-8"?>

<!-- ...................................................................... -->
<!-- File: safety_table.xsl                                                 -->
<!--                                                                        -->
<!-- Purpose: Creates individual files (safety tables) for Neutrino library -->
<!--          ref functions.                                                --> 
<!-- ...................................................................... -->
<!-- Notes/History:                                                         -->
<!-- 10.Apr.2011    Created.                                                -->
<!-- 14.Apr.2011    Added XML namespace declaration to allow for creation   -->
<!--                of namespace attributes.                                -->
<!-- 22.Apr.2011    Changed logic to match new structure from initial       -->
<!--                SGML conversion.                                        -->
<!-- 24.Apr.2001    Changed logic to match new structure from SGML          -->
<!--                conversion.                                             -->
<!-- 29.Apr.2011    Added modes to allow table elements to be matched       -->
<!--                under different conditions.                             -->
<!-- 09.May.2011    Minor changes to match latest structure from SGML       -->
<!--                conversion. Updated comments.                           -->
<!-- 08.Jun.2011    Modified process-function-href template to generate     -->
<!--                all href values in lowercase.                           -->
<!-- ...................................................................... -->

<!-- 
    Create entities to make it easier to step through the tables. 
-->
<!DOCTYPE stylesheet [
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
]>

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xml="http://www.w3.org/XML/1998/namespace" 
               version="2.0">


    <!-- .................................................................. -->
    <!-- Top level elements                                                 -->

    <xsl:output method="xml" 
                version="1.0" 
                indent="yes" 
                encoding="utf-8"
                doctype-public="-//QNX//Specialization Reference//EN"
                doctype-system="http://www.qnx.com/dita/xml/1.2/reference.dtd" />

    <!-- 
        Take output directory from Ant task.
    -->
    <xsl:param name="outdir" />

    <!-- 
        Store function names in a hash table using a key.
    -->
    <xsl:key name="index" match="concatenated/reference/title/apiname"
        use="translate(substring(.,1,1), &lowercase;, &uppercase;)" />
    
    <!-- 
        Store xref values for classification data associated with particular
        functions.
    -->
    <xsl:key name="kxref" match="xref" use="generate-id(preceding-sibling::apiname[1])" />

    <!-- .................................................................. -->
    <!-- Root node template                                                 -->

    <xsl:template match="concatenated">
        <xsl:call-template name="create_index" />
    </xsl:template>

    <!-- .................................................................. -->
    <!-- Templates                                                          -->

    <!--
        Prepares for the creation of individual function files.
        
        This recursive template steps through the alphabet and calls 
        create_index_section to create individual files for each
        function.
        
        @param  letters
        The letters of the alphabet, decreasing by one letter
        after each recursion step.
        
        @param  letter
        A single letter, A, B, C, ... ,Z.
        
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
        Creates the individual files for each function.
        
        The template receives alphabetic characters as the param letter,
        and uses the key function to determine whether there
        are any function names that match the character.  If there are,
        the template creates the file for the letter (A, B, ...) using the path 
        passed in as a parameter (outdir) from the Ant build file, and calls
        apply-templates for the appropriate function name.
        
        @param  letter
        A single letter, A, B, C, ... ,Z.
        
        @param outPath
        The full path to the location of the generated safety files.
        
        @variable  function
        The function names extraced from the index key
        by the key function.    
    -->
    <xsl:template name="create_index_section">
        <xsl:param name="letter" />
        <xsl:param name="outPath">
            <xsl:value-of select="concat('file:///', $outdir, '/full_safety_', lower-case($letter), '.xml')" />
        </xsl:param>
        <xsl:variable name="function" select="key('index', $letter)" />
        <xsl:if test="$function">
            <xsl:result-document href="{$outPath}">
                <xsl:element name="reference">
                    <xsl:attribute name="id" select="$letter" />
                    <xsl:attribute name="xml:lang">
                        <xsl:text>en-us</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="title">
                        <xsl:value-of select="$letter" />
                    </xsl:element>
                    <xsl:element name="refbody">
                        <xsl:element name="table">
                            <xsl:attribute name="colsep">
                                <xsl:text>1</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="rowsep">
                                <xsl:text>1</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="tgroup">
                                <xsl:attribute name="cols">
                                    <xsl:text>6</xsl:text>
                                </xsl:attribute>
                                <xsl:element name="thead">
                                    <xsl:element name="row">
                                        <xsl:element name="entry">Function</xsl:element>
                                        <xsl:element name="entry">Classification</xsl:element>
                                        <xsl:element name="entry">Cancel</xsl:element>
                                        <xsl:element name="entry">ISR</xsl:element>
                                        <xsl:element name="entry">Signal</xsl:element>
                                        <xsl:element name="entry">Thread</xsl:element>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="tbody">
                                    <xsl:apply-templates select="$function" />
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>
    
    <!-- 
        Matches apiname nodes and determines which table template to call.
        
        This template matches apiname nodes and then runs tests to determine
        which of the following conditions apply:
        
        1. One function, one classification, one table
        - One function per table row, one classification, one table cell value 
          in each row
        2. Mutilple functions, one classification, one table
        - One function per table row, same classification, same table cell 
          values in each row
        3. Multiple functions, multiple classifications, one table
        - One function per table row, unique classifications per function, 
          same table cell values in each row
        4. Multiple funtions, multiple classifications, multiple tables
        - One function per table row, unique classifications per function, 
           unique table cell values in each row 
           
        @param functions
        The count of the number of functions associated with the topic being 
        processed.
        
        @param functions_all
        A node set containing one or more function names.
        
        @param this_function
        The value of the context node, apiname.    
    -->
    <xsl:template match="reference/title/apiname">
        <!--<xsl:param name="apiname" select="." />-->
        <xsl:param name="functions" select="count(../*[self::apiname])" />
        <xsl:param name="functions_all" select="../*[self::apiname]" />
        <xsl:choose>
            <xsl:when test="$functions = 1">
                <xsl:apply-templates select="../../refbody/section/table" />
            </xsl:when>
            <xsl:when test="$functions > 1 and
                (.[not(../../refbody/section[title='Classification:']/p/apiname)])">
                <xsl:apply-templates select="../../refbody/section/table" mode="multiple-one">
                    <xsl:with-param name="this_function" select="." />
                    <xsl:with-param name="functions_all" select="$functions_all" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$functions > 1 and
                (.[../../refbody/section[title='Classification:']/p/apiname]) and
                count(../../refbody/section[title='Classification:']/table) = 1">
                <xsl:apply-templates select="../../refbody/section/table" mode="multiple-two">
                    <xsl:with-param name="this_function" select="." />
                    <xsl:with-param name="functions_all" select="$functions_all" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$functions > 1 and
                (.[../../refbody/section[title='Classification:']/p/apiname]) and
                count(../../refbody/section[title='Classification:']/table) > 1">
                <xsl:apply-templates select="../../refbody/section/table" mode="multiple-three">
                    <xsl:with-param name="this_function" select="." />
                    <xsl:with-param name="functions_all" select="$functions_all" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>

   <!-- 
       Case 1 template that matches tables in the input topic.
       
       This template matches tables associated with a single function that
       has a single classification associated with it and creates the 
       appropriate table row with the function's table data.
       
       Note that, for this template, the params functionname and hrefvalue
       are the same.
       
       @param functionname
       Node set containing one or more function names.
       
       @param hrefvalue
       Node set containing one or more function names.    
    --> 
    <xsl:template match="table">
        <!--<xsl:param name="functions" />
        <xsl:param name="hrefvalue" />-->
        <xsl:if test=".[@otherprops='safety']">
            <xsl:element name="row">
                <xsl:element name="entry">
                    <xsl:call-template name="process_function_href">
                        <xsl:with-param name="functionname" select="../../../title/apiname" />
                        <xsl:with-param name="hrefvalue" select="../../../title/apiname" />
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:copy-of copy-namespaces="no" select="../../section[title='Classification:']/p//xref" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Cancellation point']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Interrupt handler']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Signal handler']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Thread']/entry[2]" />
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <!-- 
        Case 2 template that matches tables in mode multiple-one.
        
        This template matches tables associated with more than one function
        that have the same classification and the same safety values.  It then
        creates a table row for each function.
        
        @param this_function/functionname
        The function name passed in from the calling template - then 
        passed to the template that generates the content for link href 
        attributes.
        
        @param functions_all
        A node set, passed in from the calling template, containing all
        function names asscoated with the topic.
        
        @variable firstfuntion/hrefvalue
        The first function of two or more functions associated with the topic
        being processed.
    -->
    <xsl:template match="table" mode="multiple-one">
        <xsl:param name="this_function" />
        <xsl:param name="functions_all" />
        <!--<xsl:variable name="count" select="position()" />-->
        <xsl:variable name="firstfunction" select="subsequence($functions_all,1,1)" />
        <xsl:variable name="classification" select="../../section[title='Classification:']/p//xref" />
        <xsl:variable name="cancellation" select="tgroup/tbody/row[entry[1]='Cancellation point']/entry[2]" />
        <xsl:variable name="interrupt" select="tgroup/tbody/row[entry[1]='Interrupt handler']/entry[2]" />
        <xsl:variable name="handler" select="tgroup/tbody/row[entry[1]='Signal handler']/entry[2]" />
        <xsl:variable name="thread" select="tgroup/tbody/row[entry[1]='Thread']/entry[2]" />
        <xsl:if test=".[@otherprops='safety']">
            <xsl:element name="row">
                <xsl:element name="entry">
                    <xsl:call-template name="process_function_href">
                        <xsl:with-param name="functionname"
                            select="$this_function" />
                        <xsl:with-param name="hrefvalue" select="$firstfunction" />
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:copy-of copy-namespaces="no" select="$classification" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="$cancellation" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="$interrupt" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="$handler" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="$thread" />
                </xsl:element>
            </xsl:element>
        </xsl:if> 
    </xsl:template>
    
    
    
    <!-- 
        Case 3 template that matches tables in mode multiple-two.
        
        This template matches tables associated with more than one function
        each of which has uniques classification date, but share the same 
        safety values.  It then creates a table row for each function.
        
        @param this_function/functionname
        The function name passed in from the calling template.
        
        @param functions_all
        A node set, passed in from the calling template, containing all
        function names asscoated with the topic.
        
        @variable firstfuntion/hrefvalue
        The first function of two or more functions associated with the topic
        being processed.
        
        @variable classification
        The classification data (same classification for each function.
        
        @variable cancellation
        Safety table cancellation point value.
        
        @variable interrupt
        Safety table interrupt value.
        
        @variable handler
        Safety table signal handler value.
        
        @variable thread
        Safety table thread value.
    -->   
    <xsl:template match="table" mode="multiple-two">
        <xsl:param name="this_function" />
        <xsl:param name="functions_all" />
        <xsl:variable name="firstfunction" select="subsequence($functions_all,1,1)" />
        <xsl:if test=".[@otherprops='safety']">
            <xsl:element name="row">
                <xsl:element name="entry">
                    <xsl:call-template name="process_function_href">
                        <xsl:with-param name="functionname" select="$this_function" />
                        <xsl:with-param name="hrefvalue" select="$firstfunction" />
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:copy-of copy-namespaces="no"
                        select="../../section[title='Classification:']/p/apiname[self::node()=$this_function]/key('kxref',
                        generate-id())" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Cancellation point']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Interrupt handler']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Signal handler']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Thread']/entry[2]" />
                </xsl:element>
            </xsl:element>
        </xsl:if>   
    </xsl:template>
    
    <!-- 
        Case 4 template that matches tables in mode multiple-three.
        
        This template matches tables associated with more than one function,
        each having unique classification data, and each having unique safety
        table values. It then creates a table row for each function.
        
        @param this_function/functionname
        The function name passed in from the calling template - then 
        passed to the template that generates the content for link href 
        attributes.
        
        @param functions_all
        A node set, passed in from the calling template, containing all
        function names asscoated with the topic.
        
        @variable firstfuntion/hrefvalue
        The first function of two or more functions associated with the topic
        being processed.
        
        @variable count
        Counter that increments from zero every time the template runs.
        
        @variable localhrefvalue
        Holds the constructed function name as part of the code that builds 
        links to separate files about each funtion.
    -->
    <xsl:template match="table" mode="multiple-three">
        <xsl:param name="this_function" />
        <xsl:param name="functions_all" />
        <xsl:variable name="firstfunction" select="subsequence($functions_all,1,1)" />
        <xsl:variable name="count" select="position()" />
        <xsl:if test=".[@otherprops='safety'] and ./title/apiname[child::text() = $this_function]">
            <xsl:element name="row">
                <xsl:element name="entry">
                    <xsl:variable name="localhrefvalue" select="concat(substring($firstfunction,1,1), '/',
                        substring-before($firstfunction, '('), '.xml')"/>
                    <xsl:element name="xref">
                        <xsl:attribute name="href">
                            <xsl:value-of
                                select="$localhrefvalue" />
                        </xsl:attribute>
                        <xsl:element name="apiname">
                            <xsl:value-of select="$this_function" />
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:copy-of copy-namespaces="no"
                        select="../../section[title='Classification:']/p/apiname[$count]/key('kxref', generate-id())" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Cancellation point']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Interrupt handler']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Signal handler']/entry[2]" />
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:value-of select="tgroup/tbody/row[entry[1]='Thread']/entry[2]" />
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <!-- 
        Assembles the value of the xref element's href attribute.
        
        The template receives information about the function name 
        and constructs the link destination using substring functions.
        
        @param functionname
        The function name passed in from the calling template.
        
        @variable hrefvalue
        The first function of two or more functions associated with the topic
        being processed.
        
        @variable localhrefvalue
        Holds the constructed function name.
    -->
    <xsl:template name="process_function_href">
        <xsl:param name="hrefvalue" />
        <xsl:param name="functionname" />
        <xsl:variable name="localhrefvalue">
            <xsl:choose>
                <xsl:when test="contains($hrefvalue, '*')">
                    <xsl:value-of select="lower-case(concat(substring($hrefvalue,1,1), '/',
            substring-before($hrefvalue, '*('), '.xml'))" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="lower-case(concat(substring($hrefvalue,1,1), '/',
            substring-before($hrefvalue, '('), '.xml'))" />
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:variable>
            <xsl:element name="xref">
                <xsl:attribute name="href">
                    <xsl:value-of
                    select="$localhrefvalue" />
                </xsl:attribute>
                <xsl:element name="apiname">
                    <xsl:value-of select="$functionname" />
                </xsl:element>
            </xsl:element>
    </xsl:template>

</xsl:transform>
