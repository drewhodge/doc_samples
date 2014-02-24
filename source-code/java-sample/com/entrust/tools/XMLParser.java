
package com.entrust.tools;

// JAXP packages
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.ParserConfigurationException;

// SAX APIs
import org.xml.sax.*;
import org.xml.sax.helpers.*;

// Java packages
import java.io.*;
import java.util.*;
import java.net.*;

/*********************************************************************
 * Parser for Gecko application.
 *
 * <P>
 * This class uses the JAXP 1.1 APIs to allow users to select among
 * compliant XML processors.
 * </P>
 *
 */
public class XMLParser extends DefaultHandler
{    
    private static Vector parserOutput = new Vector(3, 3);
    private static Vector sourceFiles = new Vector(10, 10);
    private static Vector imageFiles = new Vector(10, 10);
    private static Vector cssFiles = new Vector(2, 2);
    
    private String elemContent = null;
    
    /*****************************************************************
     * Creates new XMLParser
     *
     */
    public XMLParser()
    {
    }

    // Parse a Gecko build config file to obtain the following:
    //    1. Path to output folder
    //    2. Path to source folder
    //    3. Build mode
    //    4. Run mode
    //    5. An array or Vector of XML files

    /*****************************************************************
     * Parses an XML document.
     *
     * #param    xmlFile the path to the XML file to be parsed
     *
     */
    public Vector parseXML(String xmlFile)
    {
        Properties props = null;
        String geckoProps = null;
        String filename = null;
        String drvLetter = null;
        String clearCasePath = null;

        // The paser used by Gecko can be changed by using a properties
        // file, using the -D option on the command line, or by setting
        // system properties directly.

        // The next three steps are required to read properties
        // required by Gecko.

        // Create a Properties object with system props as its parent.
        props = new Properties(System.getProperties());

        // Load geckoProps file into props.
        FileManager fmDrive = new FileManager("");
        drvLetter = fmDrive.analyzePath(new File(Gecko.primaryBuildConfig), 1);
        clearCasePath = fmDrive.analyzePath(new File(Gecko.primaryBuildConfig), 2);
        geckoProps = drvLetter + clearCasePath + "\\properties\\geckoProps.properties";
        
        try
        {          
            FileInputStream fis = new FileInputStream(geckoProps);
            props.load(fis);
            fis.close();
        }
        catch(FileNotFoundException ioe)
        {
            System.err.println(ioe);
            System.exit(1);
        }
        catch (IOException ioe)
        {
            System.err.println(ioe);
            System.exit(1);
        }

        // Set the combined properties as the system properties.
        System.setProperties(props);

        // If we decide not to use a properties file or to set the
        // parser from the command line, we can specify it directly
        // as follows. Use a conditional statement to select the parser.
        // Xerces SAX parser -- validating.
        //System.setProperty("javax.xml.parsers.SAXParserFactory", "org.apache.xerces.jaxp.SAXParserFactoryImpl");
        // Aelfred SAX parser -- non-validating.
        //System.setProperty("javax.xml.parsers.SAXParserFactory", "com.icl.saxon.aelfred.SAXParserFactoryImpl");

        // Begin using JAXP as the interface /////////////////////////
        // with the chosen parser. 
        
        // Use an instance of this class as the SAX event handler.
        DefaultHandler handler = new XMLParser();

        try
        {            
            // There are several ways to parse a document using SAX and JAXP.
            // This is one approach.  The first step is to bootstrap a
            // parser.  There are two ways: one is to use only the SAX API, the
            // other is to use the JAXP utility classes in the
            // javax.xml.parsers package.  Gecko uses the latter
            // because it allows the application to use a platform default
            // implementation. After bootstrapping a parser/XMLReader, there
            // are several ways to begin parsing.  This class uses the SAX API.

            // Instantiate a SAXParserFactory (as determined in system
            // properties).
            SAXParserFactory spFactory = SAXParserFactory.newInstance();
            // Set validation as specified.
            spFactory.setValidating(Gecko.validation);

            // Instantiate an XML Reader -- must be implemented by SAX2.0
            // drivers.
            XMLReader xmlReader = null;

            try
            {
                // Obtain a parser from the factory.
                SAXParser saxParser = spFactory.newSAXParser();

                // Going from JAXP to SAX here ... ///////////////////////

                // Retrieve the encapsulated SAX XMLReader.
                xmlReader = saxParser.getXMLReader();
            }
            catch(Exception ex)
            {
                System.err.println(ex);
                System.exit(1);
            }

            // Set the ContentHandler of the XMLReader.
            xmlReader.setContentHandler(new XMLParser());

            // Set an ErrorHandler before parsing.
            xmlReader.setErrorHandler(new XMLParserErrorHandler(System.err));

            try
            {
                // Tell the XMLReader to parse the XML document
                xmlReader.parse(convertToFileURL(xmlFile));
            }
            catch (SAXException se)
            {
                System.err.println(se.getMessage());
                System.exit(1);
            }
            catch (IOException ioe)
            {
                System.err.println(ioe);
                System.exit(1);
            }
        }
        catch (Throwable t)
        {
            t.printStackTrace();
        }

        // System.exit(0);
  
        parserOutput.trimToSize();
        
        return parserOutput;
    }

    // Methods required for SAX parsing //////////////////////////////

    /*****************************************************************
     * Handle start document events.
     *
     * <P>
     * Do nothing -- possible future use.
     * </P>
     *
     */
    public void startDocument()
    throws SAXException
    {
        ; // Empty statement.
    }

    /*****************************************************************
     * Handle end document events.
     *
     * <P>
     * Do nothing -- possible future use.
     * </P>
     *
     */
    public void endDocument()
    throws SAXException
    {
        ; // Empty statement.
    }

    /*****************************************************************
     * Handle start-element events.
     *
     */
    public void startElement(String namespaceURI,
                             String sName, // simple name (localName)
                             String qName, // qualified name
                             Attributes attrs)
    throws SAXException
    {
        // Element name
        String eName = sName;

        if ("".equals(eName))
        {
            // NamespaceAware = false
            eName = qName;
        }

        if (attrs != null)
        {
            for (int i = 0; i < attrs.getLength(); i++)
            {
                // Attr name
                String aName = attrs.getLocalName(i);
                if ("".equals(aName))
                {
                    aName = attrs.getQName(i);
                }
            }
        }
    }

    /*****************************************************************
     * Handle end-element events.
     *
     */
    public void endElement(String namespaceURI,
                           String sName, // simple name
                           String qName  // qualified name
                          )
    throws SAXException
    {
        // Add parsed information to the results Vector.
        
        // Results obtained from build config file. //////////////////
        // Retrieve build mode.
        if(qName.equals("outputFormat"))
        {
            parserOutput.add(0, elemContent);
        }
        
        // Retrieve HTMLHelp file name.
        if(qName.equals("htmlHelpFileName"))
        {
            parserOutput.add(1, elemContent);
        }
        
        // Retrieve path to input folder (source folder).
        if(qName.equals("sourceFolder"))
        {
            parserOutput.add(2, elemContent);
        }
        
        // Retrieve path to output folder.
        if(qName.equals("outputFolder"))
        {
            parserOutput.add(3, elemContent);
        }
        
        // Retrieve paths to source files.
        if(qName.equals("documentSource"))
        {
            sourceFiles.add(new XMLSource(elemContent));
        }
        
        // Retrieve paths to image files.
        if(qName.equals("imageFile"))
        {
            imageFiles.add(new XMLSource(elemContent));
        }
        
        // Retrieve paths to CSS files.
        if(qName.equals("styleFile"))
        {
            cssFiles.add(new XMLSource(elemContent));
        }
        
        // Results obtained from parsing XML source files. ///////////    
        // Retrieve document element from source files conforming to 
        // the entrustAPI DTD.
        if(qName.equals("entrustAPI"))
        {
            parserOutput.add(0, "entrustAPI");
        }
        
        // Retrieve document element from source files conforming to 
        // the entrustCAPI DTD.
        if(qName.equals("entrustCAPI"))
        {
            parserOutput.add(0, "entrustCAPI");
        }
        
        // Retrieve document element from source files conforming to 
        // the xhtml-1 strict DTD.
        if(qName.equals("html"))
        {
            parserOutput.add(0, "html");
        }
        
        // Retrieve document element from source files conforming to 
        // the entrustAPI DTD.
        if(qName.equals("api"))
        {
            parserOutput.add(0, "api");
        }
        
        // Retrieve document element from source files conforming to 
        // the entrustDoc DTD.
        if(qName.equals("entrustDoc"))
        {
            parserOutput.add(0, "entrustDoc");
        }

    }

    /*****************************************************************
     * Retrieve element content -- handling character events.
     */
    public void characters(char[] chars, int start, int len)
    throws SAXException
    {
        elemContent = new String(chars, start, len);
    }
    
    /*****************************************************************
     * Returns a Vector containing paths to XML source files.
     *
     * @return    a <CODE>Vector</CODE> containing the XML source
     *            files listed in the build config file
     */
    public Vector retrieveSourceFiles()
    {
        sourceFiles.trimToSize();
        
        return sourceFiles;
    }
    
    /*****************************************************************
     * Returns a Vector containing image files.
     *
     * @return    a <CODE>Vector</CODE> containing any image files
     *            listed in the build config file
     */
    public Vector retrieveImageFiles()
    {
        imageFiles.trimToSize();
        
        return imageFiles;
    }
    
    /*****************************************************************
     * Returns a Vector containing CSS files.
     *
     * @return    a <CODE>Vector</CODE> containing any CSS stylesheet
     *            files listed in the build config file.
     */
    public Vector retrieveCssFiles()
    {
        cssFiles.trimToSize();
        
        return cssFiles;
    }
    
    /*****************************************************************
     * Convert from a filename to a file URL.
     *
     * @param    filename a <CODE>String</CODE> representing the 
     *           file to be converted to a URL
     *
     * @return    the input <CODE>String</CODE> converted to a URL
     */
    private static String convertToFileURL(String filename)
    {

        File file = new File(filename);
        String path = "";

        try
        {
            path = file.toURL().toString();
        }
        catch(MalformedURLException mue)
        {
            System.err.println(mue);
            System.exit(1);
        }

        return path;
    }

    // Inner class ///////////////////////////////////////////////////

    /*****************************************************************
     * Error handler to report errors and warnings.
     *
     */
    private static class XMLParserErrorHandler implements ErrorHandler
    {
        private PrintStream out;

        XMLParserErrorHandler(PrintStream out)
        {
            this.out = out;
        }

        /*************************************************************
         * Returns a string describing parse exception details.
         *
         * @return    a <CODE>String</CODE> containing parse
         *            exception information
         */
        private String getParseExceptionInfo(SAXParseException spe)
        {
            String systemId = spe.getSystemId();
            if (systemId == null) {
                systemId = "null";
            }
            String info = "URI=" + systemId +
                " Line=" + spe.getLineNumber() +
                ": " + spe.getMessage();
            return info;
        }

        // The following methods are standard SAX ErrorHandler methods.
        // See SAX documentation for more information.

        public void warning(SAXParseException spe) throws SAXException
        {
            out.println("Warning: " + getParseExceptionInfo(spe));
        }

        public void error(SAXParseException spe) throws SAXException
        {
            String message = "Error: " + getParseExceptionInfo(spe);
            throw new SAXException(message);
        }

        public void fatalError(SAXParseException spe) throws SAXException
        {
            String message = "Fatal Error: " + getParseExceptionInfo(spe);
            throw new SAXException(message);
        }
    }
} //~ XMLParser.java
