<!-- ...................................................................... -->
<!-- Toolkit entrustDoc DTD Module ........................................ -->
<!-- Filename: entrustDoc.mod
     Purpose:  entrustDoc module for prototype evaluation.
     
     This DTD module is identified by the PUBLIC and SYSTEM identifiers:
     
          PUBLIC "-//ENTRUST//ELEMENTS XHTML 1.1 Toolkit Common 1.0//EN"
          SYSTEM "entrustDoc.mod"
                              
     Notes:
     None.
     
-->

<!-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: -->

<!-- Main document root -->
<!ELEMENT entrustDoc (section*) >

<!-- We can allow 'empty' sections, but they must contain at least a title -->
<!ELEMENT section (sectionTitle, sectionInfo?, (%Body.content;)?, subSection*, popupDefn*) >
<!ATTLIST section
		topicType (reference|concept|procedure|example|glossaryTerm|container|general|home) #IMPLIED
		%Id.attrib;
		%Class.attrib;
		legacyType CDATA #IMPLIED
		hhpAlias CDATA #IMPLIED
		>
<!ELEMENT subSection (sectionTitle, (%Body.content;)?) >
<!ATTLIST subSection
		%Id.attrib;
		%Class.attrib;		
		>

<!ELEMENT sectionTitle ( #PCDATA | %Inline.mix; )* >
<!ELEMENT sectionInfo (indexTerm*, keyWord*) >

<!-- Elements for providing inline tags for defining terms that 
	 require processing as copyrights or trademarks. 
	 Added 2 elements for copyright processing ~dwh. -->
<!ELEMENT entrustTrademark (#PCDATA)* >
<!ELEMENT referencedTrademark (#PCDATA)* >
<!ELEMENT entrustRegistered (#PCDATA)* >
<!ELEMENT referencedRegistered (#PCDATA)* >
<!ELEMENT entrustCopyright (#PCDATA)* >
<!ELEMENT referencedCopyright (#PCDATA)* >

<!-- Elements to enable the use of character entities for punctuation.
	 Such character enties include em dash, en dash, and so on. 
	 ~ dwh -->
<!ELEMENT emDash EMPTY >
<!ELEMENT enDash EMPTY >


<!-- Element for including terms in a generated index -->
<!-- Changed (%Body.content)* to (#PCDATA)*.  ~dwh -->
<!ELEMENT indexTerm (#PCDATA)* >
<!ATTLIST indexTerm
		term CDATA #REQUIRED
		>
		
<!-- Elements that handle scripted popups within HTML Help 
     topic files. ~~dwh -->
<!ELEMENT popupTerm (#PCDATA)* >
<!ATTLIST popupTerm
		popupID CDATA #REQUIRED
		>
<!ELEMENT popupDefn (#PCDATA)* >
<!ATTLIST popupDefn
		popupID CDATA #REQUIRED
		>

<!-- Custom elements for proving entrustDoc specific constructs -->

<!ELEMENT note (%Block.mix;)* >
<!ELEMENT figure (figureTitle?, figureSource) >
<!ELEMENT figureTitle (#PCDATA)* > 
<!ELEMENT figureSource (#PCDATA)* >

<!-- Element(s) for providing linking mechanism -->

<!-- Element(s) for providing htmlhelp keyword linking capabilities -->
<!ELEMENT keyWord (#PCDATA)* >


<!ELEMENT crossReference ( #PCDATA | %Inline.mix; )* >
<!ATTLIST crossReference
		referenceType (internal|external) #IMPLIED
		targetSource CDATA #IMPLIED
		targetID CDATA #IMPLIED
		resolveTitle (yes|no) #IMPLIED
		>

		
<!ELEMENT apiReference (#PCDATA)* >
<!ATTLIST apiReference
		targetID CDATA #IMPLIED
		>

<!ELEMENT webLink ( #PCDATA | %Inline.mix; )* >
<!ATTLIST webLink
		url CDATA #IMPLIED
		new-window (yes|no) #IMPLIED
		>
		
		
<!-- Special elements for conditional processing to allow for internal/external doc'n. -->

<!-- Equivalent behaviour to a <div> element. -->
<!ELEMENT conditionalBlock %Div.content; >
<!ATTLIST conditionalBlock
		conditionType (internal | markup) #REQUIRED
		>

<!-- Equivelent behaviour to a <span> element. -->
<!ELEMENT conditionalInLine %Span.content; >
<!ATTLIST conditionalInLine
		conditionType (internal | markup) #REQUIRED
		>
<!-- The intention is that only attributes defined for these elements can be treated
     as conditional text in processing. This way, more precise control can be implemented
     on the use of conditional elements. More attribute values can be added, as required,
     providing the additional processing required is also added. ~psd -->
