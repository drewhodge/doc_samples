package com.entrust.tools;

// Imported packages and classes
import java.io.*;
import java.util.*;

/******************************************************************************
 * Handles folder and file management tasks for the Gecko toolset.
 * 
 */
public class FileManager extends java.io.File
{
    // Fields /////////////////////////////////////////////////////////////////
        
    // Constructors ///////////////////////////////////////////////////////////
    
    public FileManager(String path)
    {
        super(path);
    }
    
    public FileManager(String path, String name)
    {
        super(path, name);
    }
    
    public FileManager(File folder, String name)
    {
        super(folder, name);
    }    
    
    /**************************************************************************
     * Copies files to the output folder.
     * <P></P>
     * 
     * @param    fromFile
     *           the source file to be copied
     *
     * @param    toFile
     *           the target file
     */
    public static void copy(File fromFile, File toFile) 
                       throws IOException
    {
        FileInputStream file_in = null;
        FileOutputStream file_out = null;
        
        int buffer_length = 512;
        int bytes_read = 0;
        
        try
        {
            // Use source file name as target file name
            if(toFile.isDirectory())
            {
                toFile = new File(toFile, fromFile.getName());
                
                file_in = new FileInputStream(fromFile);
                file_out = new FileOutputStream(toFile);
                
                byte[] buffer = new byte[buffer_length];
                                
                // Read and write files
                while((bytes_read = file_in.read(buffer)) != -1)
                {
                    file_out.write(buffer, 0, bytes_read);
                }
            }
        }
        finally
        {
            // Close input stream
            if(file_in != null)
            {
                try
                {
                    file_in.close();
                }
                catch(IOException io_e)
                {
                    ; // Empty statement
                }
            }
            
            // Close output stream
            if(file_out != null)
            {
                try
                {
                    file_out.close();
                }
                catch(IOException io_e)
                {
                    ; // Empty statement
                }
            }
        }
    }
    
    /*************************************************************************
     * Creates the target, or output, folder (<CODE>this</CODE>).
     *
     * <P>
     * If the folder exists and it contains old files, the old files are
     * deleted.  If the folder does not exist, it is created.
     * </P>
     *
     */
    public void createDirectory()
    {
        MessageManager msgMgr = new MessageManager();
              
        if(this.exists())
        {
            // Initialize files array
            File[] files = this.listFiles();
            
            // Load files array
            for(int i = 0; i < files.length; i++)
            {
                if(!files[i].delete())
                {
                    // Handle a subfolder, if it exists.
                    if(files[i].isDirectory())
                    {
                        File subDirectory = files[i];
                        File[] subFiles = subDirectory.listFiles();
                        
                        for(int j=0; j<subFiles.length; j++)
                        {
                            if(!subFiles[j].delete())
                            {
                                msgMgr.quit("Could not delete " + subFiles[j].getName());
                            }
                        }
                        
                        files[i].delete();
                    }
                }
            }
        }
        else
        {
            // Create output folder
            if(!this.mkdir())
            {
                msgMgr.quit("Could not create directory.");
            }
        }
    }
    
    /**************************************************************************
     * Analyzes a given path, separating it into discreet parts.
     * <P></P>
     *
     * @param    path
     *           the <CODE>File</CODE> to be analyzed
     *
     * @param    mode
     *           a <CODE>mode</CODE> value of 0 returns a file name, other 
     *           values return the drive letter of the input path
     */
    public String analyzePath(File path, int mode)
    {
        StringTokenizer tokenizer = null;
        StringTokenizer pathTokenizer = null;
        StringTokenizer xslPathTokenizer = null;
        String filename = "";
        String tempPath = "";
        String tempXSLPath = "";
        String xslPath = "";
        String fs = "";
        File tempFile = null;
        File file = null;
                        
        tempPath = path.getAbsolutePath();
        tempXSLPath = path.getParent();
        tempFile = new File(tempXSLPath);
        xslPath = tempFile.getParent();
        
        
        // Get the 'file separator' property for the system.
        fs = System.getProperty("file.separator");
        
        if(fs.length() == 1) 
        {
            char sep = fs.charAt(0);
            
            if (sep == '/')
            {
                tempPath = tempPath.replace(sep, '\\');
            }
            
            if (tempPath.charAt(0) == '/')
            {
                tempPath = "\\" + tempPath;
            }
        }
        
        tokenizer = new StringTokenizer(tempPath, "\\", false);
        
        // Returns file name
        if(mode == 0)
        {        
            while(tokenizer.hasMoreTokens())
            {
                filename = tokenizer.nextToken();
            }

            return filename;
        }
        // Returns path to XSLT folder
        else if(mode == 2)
        {
            pathTokenizer = new StringTokenizer(xslPath, ":", false);
            
            while(pathTokenizer.hasMoreTokens())
            {
                filename = pathTokenizer.nextToken();
            }
            
            return filename;
        }
        // Returns drive letter
        else
        {
            filename = tokenizer.nextToken();
            
            return filename;
        }
    }

    /**************************************************************************
     * Removes unnecessary files from output folder.
     *
     * <P>
     * This method deletes those files in the output folder that are not
     * required for futher processing.
     * </P>
     *
     * @param    mode
     *           an <CODE>XMLSource</CODE> object specifying the current build 
     *           mode.
     */
    public void CleanUp(String mode)
    {      
        // Delete files in a subfolder, if it exists, and then delete the 
        // subfolder.
        MessageManager msgMgr = new MessageManager();
        
        File[] files = this.listFiles();
        
        for(int i = 0; i < files.length; i++)
        {
            if(files[i].isDirectory())
            {
                File subDirectory = files[i];
                File[] subFiles = subDirectory.listFiles();

                for(int j=0; j<subFiles.length; j++)
                {
                    if(!subFiles[j].delete())
                    {
                        msgMgr.quit("Could not delete " + subFiles[j].getName());
                    }
                }

                files[i].delete();
            }
        }
        
        // Filter to ensure that only necessary files appear in the output folder.
        FilenameFilter selectXML = new FileManager.FileListFilter("", "xml");
        /*
        FilenameFilter selectPNG = new FileManager.FileListFilter("", "png");
        FilenameFilter selectGIF = new FileManager.FileListFilter("", "gif");
        FilenameFilter selectJPG = new FileManager.FileListFilter("", "jpg");
         */
        
        // Create a File array containing selected output files.
        File[] xmlArray = this.listFiles(selectXML);
        /*
        File[] pngArray = this.listFiles(selectPNG);
        File[] gifArray = this.listFiles(selectGIF);
        File[] jpgArray = this.listFiles(selectJPG);
         */
        
        // Clear output folder after FO builds.
        if(mode.equals("FO"))
        {
            for(int i = 0; i < xmlArray.length; i++)
            {
                xmlArray[i].delete();
            }
            
            /* FO file might refer to images -- so they should not be deleted.
            for(int i = 0; i < pngArray.length; i++)
            {
                pngArray[i].delete();
            }

            for(int i = 0; i < gifArray.length; i++)
            {
                gifArray[i].delete();
            }

            for(int i = 0; i < jpgArray.length; i++)
            {
                jpgArray[i].delete();
            }
             */
        }  
        
        // Clear output folder after htmlHelp builds.
        if(mode.equals("htmlHelp"))
        {
            for(int i = 0; i < xmlArray.length; i++)
            {
                xmlArray[i].delete();
            }
        }
        
        // Clear output folder after Knowledge Base builds.
        if(mode.equals("htmlKB"))
        {
            for(int i = 0; i < xmlArray.length; i++)
            {
                xmlArray[i].delete();
            }
        }
    }
    
    // Inner class ////////////////////////////////////////////////////////////
    public static class FileListFilter implements FilenameFilter
    {
        private String name = "";
        private String extension = "";
        
        // Constructor ////////////////////////////////////////////////////////
        
        public FileListFilter(String name, String extension)
        {
            this.name = name;
            this.extension = extension;
        }
        
        // Public methods /////////////////////////////////////////////////////
    
        public boolean accept(File folder, String filename)
        {
            boolean fileExists = true;

            if(name != null)
            {
                fileExists &= filename.startsWith(name);
            }

            if(extension != null)
            {
                fileExists &= filename.endsWith('.' + extension);
            }

            return fileExists;
        }
    }
} //~ FileManager.java
