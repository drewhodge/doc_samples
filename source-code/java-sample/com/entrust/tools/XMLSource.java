package com.entrust.tools;

// Imported packages and classes
import java.io.File;


/*********************************************************************
 * Represents an XML source file withing Gecko.
 *
 */ 
public class XMLSource extends java.io.File 
{

   public XMLSource(String path)
    {
      super(path); 
    }

    public XMLSource(String path, String name)
    {
        super(path, name);
    }
    
    public XMLSource(File folder, String name)
    {
        super(folder, name);
    }
} //~ XMLSource.java
