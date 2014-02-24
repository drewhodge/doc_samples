package com.entrust.tools;

// Import JAXP TrAX classes
import javax.xml.transform.*;
import javax.xml.transform.stream.*;

import java.io.*;
import java.net.*;
import java.util.Vector;


/******************************************************************************
 * Performs all transformations required byt Gecko.
 *
 * <P>
 * This class uses the JAXP1.1 APIs, which includes TrAX, to allow users to
 * select among compliant XSLT processors.
 * </P>
 */
public class XSLTProcessor
{
    static String drvLetter = "";
    static String secondaryBuildConfig = "";
    static String singleEntrustDoc = "";
    
    static XMLSource[] sourceFiles = null;
    static XMLSource[] imageArray = null;
    static XMLSource[] styleArray = null;
    
    // Constructors ///////////////////////////////////////////////////////////
    
    /** Creates new Processor */
    public XSLTProcessor()
    {
    }
    
    // Private methods ////////////////////////////////////////////////////////
    
    /**************************************************************************
     * Processes each file named in the build configutation file to determine
     * its type.
     *
     * <P>
     * If the source file is of type <CODE>entrustDoc</CODE>, this method 
     * calls <CODE>traxTransform</CODE> and selects the identity 
     * transformation. Source files of type <CODE>xhtml1-strict<CODE>,
     * </CODE>enttoolkit_api</CODE>, <CODE>entrustCAPI</CODE>, or 
     * <CODE>entrustAPI</CODE>, are sent to the <CODE>traxTransform</CODE> 
     * method to be transformed to files of type <CODE>entrustDoc<CODE>. The 
     * transformation results are stored in the output folder specified in the 
     * build configuration file.
     * </P>
     *
     * @param     sourceFileArray
     *            a <CODE>XMLSource</CODE> array holding the XML source files
     *            to be processed
     * @param     mode
     *            an integer representing the processing stage (listed as
     *            a literal in the <CODE>Gecko</CODE> class)
     */
    public void processXMLSource(File[] xmlSourceFileArray, int mode)
    {
        XMLParser xmlParser = new XMLParser();
        String[] xmlFileArray = null;
        
        // Obtain drive letter for ClearCase working directory
        FileManager fmDrive = new FileManager(Gecko.primaryBuildConfig, "");
        drvLetter = fmDrive.analyzePath(new File(Gecko.primaryBuildConfig), 1);
        
        xmlFileArray =  new String[xmlSourceFileArray.length];
        
        for(int i=0; i<xmlSourceFileArray.length; i++)
        {
            xmlFileArray[i] = xmlSourceFileArray[i].toString();
        }
        
        for (int i=0; i<xmlFileArray.length; i++)
        {
            try
            {
                if(mode == 1 || mode == 5)
                {
                    // Transform XML source files to entrustDoc 
                    // (if necessary). The following type-to-type 
                    // (DTD) transformations are performed :
                    //      1. entrustAPI to entrustDoc
                    //      2. entrustCAPI to entrustDoc
                    //      3. xhtml to entrustDoc
                    //      4. enttoolkit_api to entrustDoc
                    if(mode == 1)
                    {
                        // Instantiate a Vector to hold information
                        // (in this case, the document element) from 
                        // the parsed XML source file.
                        Vector docElement = null;
                        
                        // The XML source file to be parsed.
                        String xmlFile = drvLetter + "/" + Gecko.inputFolder 
                                         + "/" + xmlFileArray[i];
                        
                        // Parse the XML source file.
                        docElement = xmlParser.parseXML(xmlFile);
                        
                        // Testing ///////////////////////////////////
                        String temp = docElement.get(0).toString();
                        //////////////////////////////////////////////
                        
                        // Check document element and call 
                        // transformation method with the appropriate 
                        // stylesheet.
                        if(docElement.get(0).toString().equals("entrustAPI"))
                        {
                            // Perform an identity transformation 
                            // witout validation.
                            traxTransform(xmlFileArray[i], mode, "utilities\\identity_entrustAPI.xsl", 0);
                            
                            Gecko.validation = Gecko.userValidation;
                            docElement = xmlParser.parseXML(drvLetter + "/" 
                                         + Gecko.outputFolder + "/" 
                                         + (fmDrive.analyzePath(new File(xmlFileArray[i]), 0))); 
                            
                            // Transform to entrustDoc format, with 
                            // validation (if selected by user)
                            traxTransform(xmlFileArray[i], mode, "utilities\\entrustAPI_to_entrustDoc.xsl", 0 );
                            
                            Gecko.validation = false;
                        }
                        else if(docElement.get(0).toString().equals("entrustCAPI"))
                        {
                            // Perform an identity transformation 
                            // witout validation.
                            traxTransform(xmlFileArray[i], mode, "utilities\\identity_entrustCAPI.xsl", 0);
                            
                            Gecko.validation = Gecko.userValidation;
                            docElement = xmlParser.parseXML(drvLetter + "/" 
                                         + Gecko.outputFolder + "/" 
                                         + (fmDrive.analyzePath(new File(xmlFileArray[i]), 0))); 
                            
                            traxTransform(xmlFileArray[i], mode, "utilities\\entrustCAPI_to_entrustDoc.xsl", 0);
                            
                            Gecko.validation = false;
                        }                       
                        else if(docElement.get(0).toString().equals("html"))
                        {
                            // Perform an identity transformation 
                            // witout validation.
                            traxTransform(xmlFileArray[i], mode, "utilities\\identity_xhtml.xsl", 0);
                            
                            Gecko.validation = Gecko.userValidation;
                            docElement = xmlParser.parseXML(drvLetter + "/" 
                                         + Gecko.outputFolder + "/" 
                                         + (fmDrive.analyzePath(new File(xmlFileArray[i]), 0))); 
                            
                            // Transform to entrustDoc format, with 
                            // validation (if selected by user)
                            traxTransform(xmlFileArray[i], mode, "utilities\\xhtml_to_entrustDoc.xsl", 0);
                            
                            Gecko.validation = false;
                        }
                        else if(docElement.get(0).toString().equals("api"))
                        {
                            // Perform an identity transformation 
                            // witout validation.
                            traxTransform(xmlFileArray[i], mode, "utilities\\identity_enttoolkit_api.xsl", 0);
                            
                            Gecko.validation = Gecko.userValidation;
                            docElement = xmlParser.parseXML(drvLetter + "/" 
                                         + Gecko.outputFolder + "/" 
                                         + (fmDrive.analyzePath(new File(xmlFileArray[i]), 0)));  
                            
                            // Transform to entrustDoc format, with 
                            // validation (if selected by user)
                            traxTransform(xmlFileArray[i], mode, "utilities\\enttoolkit_api_to_entrustAPI.xsl", 0);
                            
                            Gecko.validation = false;
                        }
                        else if(docElement.get(0).toString().equals("entrustDoc"))
                        {
                            // Copy files without applying a stylesheet.
                            //File tempFile = new File(xmlFile);
                            //FileManager.copy(tempFile, (new File(drvLetter + "\\" + Gecko.outputFolder)));
                            
                            // Possible future enhancement ///////////
                            // In a future version of Gecko, it might
                            // be worth considering using an identity
                            // transformation rather than simply 
                            // copying the source file.
                            
                            // Construct a Transformer without any 
                            // XSLT stylesheet
                            // Transformer trans = transFact.newTransformer(  );

                            // In this case, the processor provides
                            // its own stylesheet for the transforma-
                            // tion. This is also useful if we need to
                            // use JAXP to convert a DOM tree to XML 
                            // text for debugging purposes, because
                            // the default Transformer copies the XML
                            // data without any transformation.
                            //////////////////////////////////////////
                            
                            // Perform an identity, or copy, 
                            // transformation without validation.
                            traxTransform(xmlFileArray[i], mode, "utilities\\identity_entrustDoc.xsl", 0);
                            
                            Gecko.validation = Gecko.userValidation;
                            docElement = xmlParser.parseXML(drvLetter + "/" 
                                         + Gecko.outputFolder + "/" 
                                         + (fmDrive.analyzePath(new File(xmlFileArray[i]), 0)));                            
                            
                            // Perform a second itentity transformation
                            // with validation.
                            traxTransform(xmlFileArray[i], mode, "utilities\\identity.xsl", 0);
                            
                            Gecko.validation = false;
                        }
                    }
                    else
                    {
                        Gecko.validation = Gecko.userValidation;
                        Vector tempVector = new Vector();
                        tempVector = xmlParser.parseXML(drvLetter + "/" 
                                     + Gecko.outputFolder + "/" 
                                     + (fmDrive.analyzePath(new File(xmlFileArray[i]), 0))); 
                            
                        traxTransform(xmlFileArray[i], mode, "processSourceXML.xsl", 0 );
                        
                        Gecko.validation = false;
                    }
                }
                
                // Transform primary build config to secondary build config.
                if(mode == 2)
                {
                    traxTransform(xmlSourceFileArray[0].toString(), mode, "primarybuildConfig_to_secondary.xsl", 0 );
                }
                
                // Concatenation step, transforming XML source files into a 
                // single entrustDoc file.
                if(mode == 3)
                {
                    traxTransform(xmlSourceFileArray[0].toString(), mode, "concatenate.xsl", 0 );   
                }
                
                // Transform concatenated file into files required for HTMLHelp.
                if(mode == 4)
                {
                    String[] htmlHelpXSLT = {"entrustDoc_to_html.xsl",
                                             "entrustDoc_to_htmlhelp_contents.xsl",
                                             "entrustDoc_to_htmlhelp_index.xsl",
                                             "entrustDoc_to_htmlhelp_project.xsl"};
                    
                    for(int j=0; j<4; j++)
                    {
                        traxTransform(xmlSourceFileArray[0].toString(), mode, htmlHelpXSLT[j], j ); 
                    }
                }
                
                // Resolve cross references.
                if(mode == 6)
                {
                      traxTransform(xmlSourceFileArray[0].toString(), mode, "resolveCrossRefs.xsl", 0 );   
                }
                
                // Transform single, concatenated file (entrustDoc) into an 
                // XML FO file.
                if(mode == 7)
                {
                    traxTransform(xmlSourceFileArray[0].toString(), mode, "entrustDoc_to_fo.xsl", 0 );
                }
                
                // Transform single, concatenated file (entrustDoc) into HTML 
                // files only -- for Knowledge Base.
                if(mode == 8)
                {
                    traxTransform(xmlSourceFileArray[0].toString(), mode, "entrustDoc_to_html.xsl", 0 ); 
                }
            }
            catch(Throwable t)
            {
                t.printStackTrace();
            }
        }
    }
    
    /*************************************************************************
     * Applies an XSL stylesheet using the TrAX API.
     * <P></P>
     *
     * @param   xmlFile
     *          the path of the XML source file to be transformed
     * @param   mode
     *          an integer that specifies the kind of transformation to perform:
     *          <UL>
     *              <LI><CODE>1</CODE> &#151; transform to entrustDoc</LI>
     *              <LI><CODE>2</CODE> &#151; transform primary build config to
     *                  secondary build config</LI>
     *              <LI><CODE>3</CODE> &#151; concatenate source files</LI>
     *              <LI><CODE>4</CODE> &#151; create discrete HTML Help topic 
     *                  files</LI>
     *              <LI><CODE>5</CODE> &#151; add source and output file name 
     *                  attributes to source files</LI>
     *              <LI><CODE>6</CODE> &#151; resolve cross references</LI>
     *              <LI><CODE>7</CODE> &#151; transform to XSL FO</LI>
     *              <LI><CODE>8</CODE> &#151; transform to HTML files (for
     *                  Knowledge base</LI>
     *          </UL>
     *
     * @param   count
     *          an integer used to control the creation of HTMLHelp topic files
     *
     */
    public void traxTransform(String xmlFile, int mode, String xslFile, int count)
    throws TransformerException, TransformerConfigurationException, IOException,
    MalformedURLException
    {
        Source stylesheet = null;
        Source xmlSource = null;
        FileWriter fileWriter = null;
        FileWriter tempFileWriter = null;
        String xmlFilename = "";
        String clearCasePath = "";
        boolean directory = false;
        
        MessageManager msgMgr = new MessageManager();
        
        // Obtain ClearCase working directory
        FileManager fmDrive = new FileManager(Gecko.primaryBuildConfig, "");
        clearCasePath = fmDrive.analyzePath(new File(Gecko.primaryBuildConfig), 2);
        clearCasePath = clearCasePath + "\\xsl";
        
        switch(mode)
        {
            // Case 1 -- transforms files to entrustDoc type.
            case 1:
                // Instantiate Source objects containing the XML and
                // XSLT source files.
                stylesheet = new StreamSource(drvLetter 
                                              + clearCasePath + "\\"
                                              + xslFile);
                xmlSource = new StreamSource(drvLetter 
                                              + "\\" + Gecko.inputFolder + "\\"
                                              + xmlFile);
                
                // Isolate the XML file name
                XMLSource sourceFile = new XMLSource(xmlFile);
                xmlFilename = fmDrive.analyzePath(sourceFile, 0);
                
                // If the XML source is in enttoolkit_api format,
                // convert it to entrustAPI before converting to
                // entrustDoc.
                if(xslFile == "utilities\\enttoolkit_api_to_entrustAPI.xsl")
                {
                    tempFileWriter = new FileWriter(drvLetter + "\\"
                                                + Gecko.outputFolder + "\\"
                                                + "temp.xml");
                    
                    // Create a buffered output stream
                    BufferedWriter tempBuff = new BufferedWriter(tempFileWriter);
                    
                    // Create a TransformerFactory.
                    TransformerFactory transFactory = TransformerFactory.newInstance();
                    Transformer transformer = transFactory.newTransformer(stylesheet);
                    
                    // Perform the transformation.
                    Result transformedSource = new StreamResult(tempBuff);
                    transformer.transform(xmlSource, transformedSource);
                    
                    // Point to the stylesheet and the XML source file.
                    stylesheet = new StreamSource(drvLetter +  clearCasePath + "\\"
                                               + "utilities\\entrustAPI_to_entrustDoc.xsl");
                    xmlSource = new StreamSource(drvLetter + "\\"
                                                + Gecko.outputFolder + "\\"
                                                + "temp.xml");
                   
                    // Close the buffered output stream.
                    tempBuff.close();
                     
                }
                
                // Instantiate a FileWriter.
                fileWriter = new FileWriter(drvLetter + "\\"
                                            + Gecko.outputFolder + "\\"
                                            + xmlFilename);

                break;
                
            // Case 2 -- transforms primaryBuildConfig file to secondaryBuildConfig file.
            case 2:
                // Instantiate Source objects containing the XML and
                // XSLT source files.
                stylesheet = new StreamSource(drvLetter 
                                              + clearCasePath + "\\"
                                              + xslFile);
                xmlSource = new StreamSource(xmlFile);
                
                // Isolate the XML file name
                XMLSource sourceFile2 = new XMLSource(xmlFile);
                xmlFilename = fmDrive.analyzePath(sourceFile2, 0);
                
                // Instantiate a FileWriter.
                fileWriter = new FileWriter(drvLetter + "\\"
                                            + Gecko.outputFolder + "\\"
                                            + "staged\\" + "secondary_" 
                                            + xmlFilename);
                
                secondaryBuildConfig = (drvLetter + "\\" + Gecko.outputFolder 
                                        + "\\" + "staged\\" + "secondary_" 
                                        + xmlFilename);
                
                break;
                
            // Case 3 -- concatenates staged XML source files into a single file
            // that conformas to the entrustDoc type.
            case 3:                
                stylesheet = new StreamSource(drvLetter 
                                              + clearCasePath + "\\"
                                              + xslFile);
                xmlSource = new StreamSource(xmlFile);
                
                // Isolate the XML file name
                XMLSource sourceFile3 = new XMLSource(xmlFile);
                xmlFilename = fmDrive.analyzePath(sourceFile3, 0);
                
                // Instantiate a FileWriter.
                fileWriter = new FileWriter(drvLetter + "\\"
                                            + Gecko.outputFolder + "\\"
                                            + "staged\\" + "concatenated_" 
                                            + xmlFilename);
                
                singleEntrustDoc = (drvLetter + "\\" + Gecko.outputFolder 
                                    + "\\" + "staged\\" + "concatenated_" 
                                    + xmlFilename);
                
                break;

            // Case 4 -- Creates discreet HTMLHelp topic files (in html) and
            // the HTMLHelp project-specific files, *.hhp, *.hhc, and *.hhk.
            case 4:
                if(count == 0)
                {
                    msgMgr.displayMessage("         --> topic files\n ");

                    stylesheet = new StreamSource(drvLetter + clearCasePath 
                                                  +"\\" + "htmlhelp" + "\\" 
                                                  + xslFile);
                    xmlSource = new StreamSource(xmlFile);

                    // Instantiate a FileWriter.
                    fileWriter = new FileWriter(drvLetter + "\\"
                                                + Gecko.outputFolder 
                                                + "\\build_report.html" );

                    count = count + 1;
                }
                else if(count == 1)
                {
                    msgMgr.displayMessage("         --> *.hhc file\n ");

                    stylesheet = new StreamSource(drvLetter + clearCasePath 
                                                  +"\\" + "htmlhelp" + "\\" 
                                                  + xslFile);
                    xmlSource = new StreamSource(xmlFile);

                    // Instantiate a FileWriter.
                    fileWriter = new FileWriter(drvLetter + "\\"
                                                + Gecko.outputFolder + "\\"
                                                +  Gecko.helpFileName + ".hhc");

                   count = count + 1;
                }
                else if(count == 2)
                {
                    msgMgr.displayMessage("         --> *.hhk file\n ");

                    stylesheet = new StreamSource(drvLetter + clearCasePath 
                                                  +"\\" + "htmlhelp" + "\\" 
                                                  + xslFile);
                    xmlSource = new StreamSource(xmlFile);

                    // Instantiate a FileWriter.
                    fileWriter = new FileWriter(drvLetter + "\\"
                                                + Gecko.outputFolder + "\\"
                                                + Gecko.helpFileName + ".hhk");

                    count = count + 1;
                }
                else
                {
                    msgMgr.displayMessage("         --> *.hhp file\n ");

                    stylesheet = new StreamSource(drvLetter + clearCasePath 
                                                  +"\\" + "htmlhelp" + "\\" 
                                                  + xslFile);
                    xmlSource = new StreamSource(xmlFile);

                    // Instantiate a FileWriter.
                    fileWriter = new FileWriter(drvLetter + "\\"
                                                + Gecko.outputFolder + "\\"
                                                + Gecko.helpFileName + ".hhp");

                    count = count + 1;
                }

                break;

            // Case 5 -- adds source and output file name attributes to each 
            // <CODE>section</CODE> element in source files.
            case 5:
                // Instantiate Source objects containing the XML and
                // XSLT source files.
                stylesheet = new StreamSource(drvLetter 
                                              + clearCasePath + "\\"
                                              + xslFile);
                xmlSource = new StreamSource(xmlFile);

                // Isolate the XML file name
                XMLSource secondarySourceFile = new XMLSource(xmlFile);
                xmlFilename = fmDrive.analyzePath(secondarySourceFile, 0);
                
                // Instantiate a FileWriter.
                fileWriter = new FileWriter(drvLetter + "\\"
                                            + Gecko.outputFolder + "\\"
                                            + "staged\\" + xmlFilename);
                
                break;

            // Case 6 -- applies a stylesheet to resolve cross references.
            case 6:
                stylesheet = new StreamSource(drvLetter 
                                              + clearCasePath + "\\"
                                              + xslFile);
                xmlSource = new StreamSource(xmlFile);
                
                // Isolate the XML file name
                XMLSource sourceFile6 = new XMLSource(xmlFile);
                xmlFilename = fmDrive.analyzePath(sourceFile6, 0);

                // Instantiate a FileWriter.
                fileWriter = new FileWriter(drvLetter + "\\"
                                            + Gecko.outputFolder + "\\"
                                            + xmlFilename);
                
                singleEntrustDoc = (drvLetter + "\\" + Gecko.outputFolder 
                                    + "\\" + xmlFilename);
                
                break;
                
             // Case 7 -- applies a stylesheet to transform source to XSL FO.
            case 7:
                stylesheet = new StreamSource(drvLetter 
                                              + clearCasePath + "\\"
                                              + xslFile);
                xmlSource = new StreamSource(xmlFile);
                
                // Isolate the XML file name
                XMLSource sourceFile7 = new XMLSource(xmlFile);
                xmlFilename = fmDrive.analyzePath(sourceFile7, 0);

                // Instantiate a FileWriter.
                fileWriter = new FileWriter(drvLetter + "\\"
                                            + Gecko.outputFolder + "\\"
                                            + "formatted_output.fo");
          
                break;
             
             // Case 8 -- applies a stylesheet to transform source to HTML topic
             // files (for KnowledgeBase).
             case 8:
                msgMgr.displayMessage("         --> topic files\n ");

                stylesheet = new StreamSource(drvLetter +  clearCasePath +"\\" 
                                           + "htmlhelp" +  "\\" + xslFile);

                xmlSource = new StreamSource(xmlFile);

                // Instantiate a FileWriter.
                fileWriter = new FileWriter(drvLetter + "\\"
                                            + Gecko.outputFolder 
                                            + "\\build_report.html" );

                break;
                
             default:
                ; // empty statement
                break;
        }
                
        // Instantiate TranformerFactory and Transformer.
        TransformerFactory transFactory = TransformerFactory.newInstance();
        Transformer transformer = transFactory.newTransformer(stylesheet);
        
        // Pass parameters to XSLT stylesheets, if necessary.
        if(mode == 3 || (mode == 4 && count ==1) || mode == 8)
        {
            transformer.setParameter("clearCaseDrive", drvLetter);
        }
        else if(mode == 5) 
        {
            transformer.setParameter("sourceXMLFileName", xmlFilename);
        }
        
        // Perform the transformation.
        Result transformedSource = new StreamResult(fileWriter);
        transformer.transform(xmlSource, transformedSource);
        
        fileWriter.close();
        
    }    
} //~ XSLTProcessor.java
