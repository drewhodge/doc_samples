package com.entrust.tools;

// Imported packages and classes
import java.io.*;
import java.util.Vector;

//import javax.xml.parsers.*;   //SAX parser classes

/*********************************************************************
 * Driver class for Gecko toolset.
 *
 * <P>
 * Gecko processes XML source files produced by the Toolkit documentation 
 * group.  The program runs  from the command line and accepts the following
 * arguments:
 * </P>
 *
 * <UL>
 *   <LI>-v &#151; an optional argument that turns on validation for
 *       parsing XML source files</LI>
 *   <LI>-debud &#151; an optional argument specifying whether to run 
 *       in 'debug' mode</LI>
 *   <LI>the absoute path to a build configuration file written in XML and 
 *       conforming to the entrustTechPub DTD with <CODE>buildConfig</CODE>
 *       as the document element</LI>
 * </UL>
 *   
 * <P>
 * The build configuration file contains information that tells the Gecko 
 * program where to find the files it has to process, what kind of processing is
 * to be done (htmlHelp, FO for PDF, and so on), and where to put the processed
 * source files.
 * </P>
 *
 * <P>
 * Debug mode retains the intermediate files that are created as part of the
 * transformation process.  If 'debug' is not specified, Gecko clears the output
 * folder of those files that are unnecessary for further processing.
 * </P>
 *
 * <P>
 * Usage:<BR>
 * <PRE>
 *     java -cp <classpath> Gecko [-v] [-debug] <absolute path to build config file>
 * </PRE>
 * </P>
 *
 * <P>
 * <STRONG>Version history:</STRONG>
 * </P>
 * <UL>
 *  <LI>Version 1.1 :: ??</LI>
 *  <LI>Version 1.2 :: Modified to handle Knowledgebase build mode.</LI>
 *  <LI>Version 1.3 :: Modified to handle PDF build mode. Gecko made 
 *      independent of snapshot-ClearCase path changes.</LI>
 *  <LI>Version 1.4 :: Modified to clean up output folders of unnecessary
 *      files -- debug/normal modes of operation.</LI>
 *  <LI>Version 1.5 :: Major modification of parsing and transformation
 *      capabilities -- uses JAXP 1.1 APIs for parsing and for transformation
 *      (TrAX) and adds capability to switch on validation for parsing.  Also
 *      added an elapsed time counter to measure build time.</LI>
 * </UL>
 *
 * @version 1.5
 */
public class Gecko
{
    static final int PRIMARY = 1;
    static final int SECONDARY = 2;
    static final int TO_ENTRUST_DOC = 3;
    static final int TO_HTML_HELP = 4;
    static final int PROCESS_SOURCE = 5;
    static final int RESOLVE_XREF = 6;
    static final int TO_FO = 7;
    static final int TO_HTML_KB = 8;
    
    static String primaryBuildConfig = null;
    static String buildMode = null;
    static String helpFileName = null;
    public static String drvLetter = "";
    static String runMode = "";

    static File inputFolder = null;
    static File outputFolder = null;
    
    static boolean validation = false;
    static boolean userValidation = false;
    
    private static Vector parserResults = new Vector(3, 3);
    private static Vector xmlSourceFiles = new Vector(10, 10);
    private static Vector ancillaryImages = new Vector(10, 10);
    private static Vector ancillaryCSS = new Vector(2, 2);
        
    /** Creates new Driver */
    public Gecko()
    {
    }
    
    /**************************************************************************
     * <CODE>main</CODE> method of the <CODE>Gecko</CODE> class.
     *
     * <P>
     * This method controls the overall program flow of the Gecko toolset.
     * </P>
     *
     * @param    args[n]
     *           <UL>
     *             <LI><CODE>-v</CODE> &#151; (optional) turns on Xvalidation for 
     *             XML parsing </LI>
     *             <LI><CODE>-debug</CODE> &#151; (optional) &#151; turns on debug
     *             to retain all intermediate files </LI>
     *             <LI><CODE>file name</CODE> &#151; absolute path to the primary 
     *             build configuaration file</LI>
     *           </UL>
     *
     */
    public static void main(String args[])
    {
        // Measuring elapsed time.
        long startTime = System.currentTimeMillis();
        long endTime = 0;
        long elapsedTime = 0;
        
        // Case sensitive build modes specified in the build configuration file.
        String BUILDMODE_HELP = "htmlHelp";
        String BUILDMODE_KB = "htmlKB";
        String BUILDMODE_FO = "FO";
        
        MessageManager msgMgr = new MessageManager();
        ExceptionsManager excepMgr = new ExceptionsManager();
        XMLParser xmlParser = new XMLParser();
        XSLTProcessor xsltProc = new XSLTProcessor();
        FileManager fmMgr = new FileManager("");
        
        msgMgr.geckoInfo("start", 0); 
        runMode = "normal";
        
        // Check command line arguments.
        String usage = "Usage:\n\n  java -cp <classpath> Gecko" 
                       +  " [-debug]" + " [-v]"
                       +  " <build config file name>"
                       + "\n\nWhere:\n\n" 
                       + "  -debug turns on 'debug' mode\n"
                       + "  -v turns on validation\n"
                       + "  build config file name is the absolute "
                       + "path to the build config file." ;
        
        if(args.length < 1 || args.length > 3)
        {
            msgMgr.displayMessage("Bad usage.\n");
            msgMgr.displayMessage(usage);
            System.exit(1);
        }
 
        // Read command line arguments.
        int arg = 0;
        while(true)
        {
            if(arg > args.length)
            {
                msgMgr.displayMessage("Bad usage.\n");
                msgMgr.displayMessage(usage);
                System.exit(1);
            }
            
            if(args[arg].charAt(0) == '-')
            {
                if(args[arg].equals("-debug"))
                {
                    runMode = args[arg];
                    msgMgr.geckoInfo("debug", 0);
                    arg++;
                }
                else if(args[arg].equals("-v"))
                {
                    userValidation = true;
                    arg++;
                }
            }
            else 
            {
                primaryBuildConfig = args[arg];
                
                break;    
            }
        } 
        
        // Preparation stage /////////////////////////////////////////
        // Parse the build config file to retrieve information and 
        // create output and staging folders.
        
        // Parse primary build configuration file to obtain:
        //      1. The input folder
        //      2. The output folder
        //      3. The build mode (htmlHelp, htmlKB, or FO)
        //      4. An XMLSource array of XML source files
        //      5. An array containg ancillary image files
        //      6. An array containing ancillary stylesheet (*.css) files
        
        msgMgr.displayMessage(" \n\n    ... parsing build config file ...\n ");
        
        // Redirect stderr for errorl logging.
        excepMgr.redirectStdErr();
        
        // Set validation to that specified by the user.
        validation = userValidation;
        
        // Parse primary build config file.
        parserResults = xmlParser.parseXML(primaryBuildConfig);
        
        // Retrieve build mode.
        buildMode = parserResults.get(0).toString();
        // Retrieve HTMLHelp file name.
        helpFileName = parserResults.get(1).toString();
        // Retrieve input folder.
        inputFolder = new File(parserResults.get(2).toString());
        // Retrieve output folder.
        outputFolder = new File(parserResults.get(3).toString());
        
        // Retrieve XML source files.
        XSLTProcessor.sourceFiles = new XMLSource[xmlParser.retrieveSourceFiles().size()];
        xmlParser.retrieveSourceFiles().copyInto(XSLTProcessor.sourceFiles);
        
        // Retrieve ancillary image files.
        XSLTProcessor.imageArray = new XMLSource[xmlParser.retrieveImageFiles().size()];
        xmlParser.retrieveImageFiles().copyInto(XSLTProcessor.imageArray);
        
        // Retrieve ancillary CSS file(s).
        XSLTProcessor.styleArray = new XMLSource[xmlParser.retrieveCssFiles().size()];
        xmlParser.retrieveCssFiles().copyInto(XSLTProcessor.styleArray);
        
        // Turn off validation.
        validation = false;
               
        // Create output folder.
        msgMgr.displayMessage(" \n    ... creating temporary output folder ...\n ");
        drvLetter = fmMgr.analyzePath(new File(primaryBuildConfig), 1);
        FileManager fmOutput = new FileManager((drvLetter + outputFolder), "");
        fmOutput.createDirectory();
        
        // Create staging folder.
        msgMgr.displayMessage(" \n    ... creating temporary staging folder ...\n ");
        FileManager fmStaging = new FileManager((drvLetter + outputFolder 
                                                + "\\staged"), "");
        fmStaging.createDirectory();
        
        // ... end preparation stage. ////////////////////////////////
        
        // Transformation stage //////////////////////////////////////
        //  1. Transform source into entrustDoc format (if necessary).
        //  2. Transform primary build config file to secondary build 
        //     config file.
        //  3. Copy ancillary files to output folder.
        //  4. Concatenate source files into a single file.
        //  5. Resolve cross references.
        //  6. Perform transformations according to build mode.
        
        // Transform XML source files (specified in the primary build
        // config file) to entrustDoc format.
        msgMgr.displayMessage(" \n    ... transforming source files ...\n ");
        xsltProc.processXMLSource(XSLTProcessor.sourceFiles, PRIMARY); 
        
        // Filter to ensure that only XML files appear in the output folder.
        java.io.FilenameFilter select = new FileManager.FileListFilter("", "xml");
        
        // Process secondary source files.
        validation = userValidation;
        msgMgr.displayMessage(" \n    ... processing source files ...\n ");
        xsltProc.processXMLSource(fmOutput.listFiles(select), PROCESS_SOURCE);
        
        // Transform primary build config to secondary build config.
        msgMgr.displayMessage(" \n    ... creating secondary build config file ...\n ");
        XMLSource[] xmlSourceArray = new XMLSource[1];
        XMLSource primaryBuildConfigFile = new XMLSource(primaryBuildConfig);
        xmlSourceArray[0] = primaryBuildConfigFile;
        xsltProc.processXMLSource(xmlSourceArray, SECONDARY);
      
        // Copy ancillary files (images and CSS stylesheet)
        msgMgr.displayMessage(" \n    ... copying ancillary files ...\n ");
        try
        {
            File output = new File(drvLetter + "\\" + outputFolder);
            File input = new File(drvLetter + "\\" + inputFolder);
            
            for(int i=0; i<XSLTProcessor.imageArray.length; i++)
            {
                FileManager.copy((new File(input+ "\\" + XSLTProcessor.imageArray[i])), output);
            }

            for(int i=0; i<XSLTProcessor.styleArray.length; i++)
            {
                FileManager.copy((new File(input+ "\\" + XSLTProcessor.styleArray[i])), output);
            }
        }
        catch(Throwable t)
        {
            t.printStackTrace();
        }
        
        // Concatenate XML source files into a single file.
        msgMgr.displayMessage(" \n    ... concatenating files ...\n ");
        xmlSourceArray[0] = new XMLSource(XSLTProcessor.secondaryBuildConfig);
        xsltProc.processXMLSource(xmlSourceArray, TO_ENTRUST_DOC);
        
        // Resolve cross references in concatenated file.
        msgMgr.displayMessage(" \n    ... resolving cross references ...\n ");
        xmlSourceArray[0] = new XMLSource(XSLTProcessor.singleEntrustDoc);
        xsltProc.processXMLSource(xmlSourceArray, RESOLVE_XREF);
        
        // NB: The value of singleEntrustDoc changes between the last section 
        // of code and the next.
        
        if(buildMode.equals(BUILDMODE_HELP))
        {        
            // Create HTMLHelp project and topic files.
            msgMgr.displayMessage(" \n    ... creating HTMLHelp ...\n ");
            xmlSourceArray[0] = new XMLSource(XSLTProcessor.singleEntrustDoc);
            xsltProc.processXMLSource(xmlSourceArray, TO_HTML_HELP);
        }
        else if(buildMode.equals(BUILDMODE_KB))
        {
            // Create HTML files for Knowledgbase.
            msgMgr.displayMessage(" \n    ... creating HTML files ...\n ");
            xmlSourceArray[0] = new XMLSource(XSLTProcessor.singleEntrustDoc);
            xsltProc.processXMLSource(xmlSourceArray, TO_HTML_KB);
        }
        else if(buildMode.equals(BUILDMODE_FO))
        {
            // Create HTMLHelp project and topic files.
            msgMgr.displayMessage(" \n    ... creating XML FO file ...\n ");
            xmlSourceArray[0] = new XMLSource(XSLTProcessor.singleEntrustDoc);
            xsltProc.processXMLSource(xmlSourceArray, TO_FO);        
        }
        else
        {
            msgMgr.displayMessage("You have specified an invalid output format");
        }
        
        // ... end transformation stage. /////////////////////////////
        
        // Clean up stage ////////////////////////////////////////////
        // Remove 'staged' folder and all unnecessary files from 
        // output folder -- if runMode is not 'debug'.
        
        // Clean up output folder.
        if(runMode == "normal")
        {
           fmOutput.CleanUp(buildMode);  
        }
        
        // ... end clean up stage. ///////////////////////////////////
        
        excepMgr.closeStreams();
        
        // Measuring elapsed time.
        endTime = System.currentTimeMillis();
        elapsedTime = (endTime - startTime)/1000;

        msgMgr.geckoInfo("end", elapsedTime);
        
        System.exit(0);
    }  
} //~ Gecko.java
