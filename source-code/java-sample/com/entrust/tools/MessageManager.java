package com.entrust.tools;

/*********************************************************************
 * Writes messages to stdout.
 * <P></P>
 *
 */
public class MessageManager
{

    /*****************************************************************
     * Creates new MessageHandler.
     */
    public MessageManager()
    {
    }
    
    public void geckoInfo(String stage, long time)
    {
        // Version 1.1 :: ??
        // Version 1.2 :: Modified to handle Knowledgebase build mode.
        // Version 1.3 :: Modified to handle PDF build mode. Gecko made 
        //                independent of snapshot-ClearCase path changes.
        // Version 1.4 :: Modified to clean up output folders of unnecessary
        //                files -- debug/normal modes of operation.
        // Version 1.5 :: Major modification of parsing and transformation
        //                capabilities -- uses JAXP 1.1 APIs for parsing and 
        //                for transformation (TrAX) and adds capability to
        //                switch on validation for parsing.  Also added an
        //                elapsed time counter to measure build time.
        
        String geckoStart = "    ********** Start Gecko **********";
        String version = "              (Version 1.5)";
//        String nonsense = "";
        String debugMode = "\n          !!! Debug mode on !!!";
        String geckoEnd = "\n        Elapsed time = " + time + " seconds" 
                          + "\n    **********  End Gecko  **********";
        
        if(stage == "start")
        {
            System.out.println(geckoStart);
            System.out.println(version);
//            System.out.println(nonsense);

        }
        else if(stage == "debug")
        {
             System.out.println(debugMode);
        }
        else
        {
            System.out.println(geckoEnd);
        }
        
    }
    
    public void displayMessage(String message)
    {
        System.out.println(message);
    }
    
    /**************************************************************************
     * Terminates the program with an error message.
     * <P></P>
     *
     * @param    message
     *           a message <CODE>String</CODE> to be displayed on stderr
     */
    public void quit(String message) 
    {
        System.err.println(message);
        System.exit(2);
    }
} //~ MessageManager.java
