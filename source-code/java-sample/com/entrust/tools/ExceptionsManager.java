package com.entrust.tools;

// Imported packages and classes
import java.io.*;


/******************************************************************************
 * The base class for Gecko exceptions.
 *
 * <P>
 * Class description ... 
 * </P>
 *
 * @version
 */
public class ExceptionsManager extends java.lang.Exception
{
    private PrintStream stderr = null;
    private MessageManager msgMgr = new MessageManager();

    /**************************************************************************
    * Constructs new exceptions for Gecko.
    * 
    * <P>
    * Description ...
    * </P>
    *
    * @param    message
    *          The exception message  
    */
    public ExceptionsManager()
    {
        super();
    }
    
    public void redirectStdErr()
    {
        // Obtain ClearCase working directory
        String clearCasePath = "";
        String drvLetter = "";
        FileManager fmDrive = new FileManager(Gecko.primaryBuildConfig, "");
        drvLetter = fmDrive.analyzePath(new File(Gecko.primaryBuildConfig), 1);
        clearCasePath = fmDrive.analyzePath(new File(Gecko.primaryBuildConfig), 2);
        clearCasePath = clearCasePath;
        
        // System.err redirection for error logging.
        try
        {
            stderr = new PrintStream(new FileOutputStream(drvLetter 
                                     + clearCasePath + "\\XSLTProc_errorlog.txt"));
        }
        catch(Exception e)
        {
            msgMgr.displayMessage("Unable to open Gecko error log file.");
            System.exit(1);
        }
        
        System.setErr(stderr);
        System.err.println("Gecko error log:\n" + "================\n\n");
    }
     
    public void closeStreams()
    {
        // Close stderr stream.
        try
        {
            stderr.close();
        }
        catch(Exception e)
        {
            msgMgr.displayMessage("Unable to close Gecko error log file.");
        }
    }

}

