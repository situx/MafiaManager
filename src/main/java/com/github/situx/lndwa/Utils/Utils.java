/*******************************************************************************
 * LNDWAWeb
 *    Copyright (C) 2016 Timo Homburg
 * This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *   This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *     You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software Foundation,
 *    Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *******************************************************************************/
package com.github.situx.lndwa.Utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

/**
 * Created by timo on 21.01.14.
 */
public class Utils {
	
	public static final String PLAYERPATH="data"+File.separator+"players.xml";
	
	public static final String USERPATH="data"+File.separator+"users.xml";

    /**
     * Pretty formats the file name to display it in an application.
     * @param filename the filename as String
     * @return the pretty formatted filename
     */
    public static String prettyFormatFileName(String filename){
        StringBuffer stringbf = new StringBuffer();
        Matcher m = Pattern.compile("([a-z])([a-z]*)",
                Pattern.CASE_INSENSITIVE).matcher(filename.replace('_',' '));
        while (m.find()) {
            m.appendReplacement(stringbf,
                    m.group(1).toUpperCase() + m.group(2).toLowerCase());
        }
        return stringbf.toString();
    }
    
    public static void zipFiles(final File input,final File zipFile) throws IOException{
        byte[] buffer = new byte[1024];
    
       	FileOutputStream fos = new FileOutputStream(zipFile);
       	ZipOutputStream zos = new ZipOutputStream(fos);
    
       	System.out.println("Output to Zip : " + zipFile);
    
       	for(String file : input.list()){
    
       		System.out.println("File Added : " + file);
       		ZipEntry ze= new ZipEntry(file);
           	zos.putNextEntry(ze);
    
           	FileInputStream in = 
                          new FileInputStream(input + File.separator + file);
    
           	int len;
           	while ((len = in.read(buffer)) > 0) {
           		zos.write(buffer, 0, len);
           	}
    
           	in.close();
       	}
    
       	zos.closeEntry();
       	//remember close it
       	zos.close();
    
       	System.out.println("Done");
    }
    
    public static void unzipFiles(final File input,final File output) throws IOException{
    	byte[] buffer = new byte[1024];
    
       	//create output directory is not exists
       	File folder = output;
       	if(!folder.exists()){
       		folder.mkdir();
       	}
    
       	//get the zip file content
       	ZipInputStream zis = 
       		new ZipInputStream(new FileInputStream(input));
       	//get the zipped file list entry
       	ZipEntry ze = zis.getNextEntry();
    
       	while(ze!=null){
    
       	   String fileName = ze.getName();
              File newFile = new File(output + File.separator + fileName);
    
              System.out.println("file unzip : "+ newFile.getAbsoluteFile());
    
               //create all non exists folders
               //else you will hit FileNotFoundException for compressed folder
               new File(newFile.getParent()).mkdirs();
    
               FileOutputStream fos = new FileOutputStream(newFile);             
    
               int len;
               while ((len = zis.read(buffer)) > 0) {
          		fos.write(buffer, 0, len);
               }
    
               fos.close();   
               ze = zis.getNextEntry();
       	}
    
           zis.closeEntry();
       	zis.close();
    
       	System.out.println("Done");
    
    }
}
