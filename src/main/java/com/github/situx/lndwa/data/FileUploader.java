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
package com.github.situx.lndwa.data;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.TreeMap;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.imgscalr.Scalr;

public class FileUploader {

	private int _1adsads=0; 
	
	private Integer maxMemSize=50000 * 1024;
	
	public Integer getMaxMemSize() {
		return maxMemSize;
	}

	public void setMaxMemSize(Integer maxMemSize) {
		this.maxMemSize = maxMemSize;
	}

	public Integer getMaxFileSize() {
		return maxFileSize;
	}

	public void setMaxFileSize(Integer maxFileSize) {
		this.maxFileSize = maxFileSize;
	}

	private Integer maxFileSize=50000 * 1024;
	
	public FileUploader(){
		
	}
	
	public Map<String,String> uploadFiles(String repository,String initparam,String subfolder,String filenm,ServletContext context,Locale locale,HttpServletRequest request){
		Map<String,String> result=new TreeMap<String,String>();
		File file;
		ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",locale);
		String newimagepath;
		String filePath = context.getInitParameter(initparam);
		System.out.println("Fileeee  "+filePath);
		if(!initparam.equals("music-upload")){
			filePath=filePath.substring(0,filePath.length()-1);
			filePath+=File.separator;
		    filePath+=subfolder+File.separator;
		}
		System.out.println("Filepath "+filePath);
		DiskFileItemFactory factory = new DiskFileItemFactory();
	    // maximum size that will be stored in memory
	    factory.setSizeThreshold(maxMemSize);
	    // Location to save data that is larger than maxMemSize.
	    factory.setRepository(new File(repository));

	    // Create a new file upload handler
	    ServletFileUpload upload = new ServletFileUpload(factory);
	    String sep=File.separator;
	    // maximum file size to be uploaded.
	    upload.setSizeMax( maxFileSize );
	    
	    try{ 
	       // Parse the request to get file items.
	       List<FileItem> fileItems = upload.parseRequest(request);
	       System.out.println("Fileitems.size() "+fileItems.size());
	       // Process the uploaded file items
	       Iterator<FileItem> i = fileItems.iterator();
	       while ( i.hasNext () ) 
	       {
	          FileItem fi = (FileItem)i.next();
	          // Get the uploaded file parameters
	          String fieldName = fi.getFieldName();
	          System.out.println("FieldName "+fieldName);
	          String fileName = fi.getName();
	          System.out.println("FileName "+fileName);
	          if ( !fi.isFormField () )	
	          {
	          BufferedImage image=null;
	          if(fieldName.endsWith("_img")){
	        	  image=ImageIO.read(fi.getInputStream());
	        	  image=Scalr.resize(image, 150);
	          }
	          boolean isInMemory = fi.isInMemory();
	          long sizeInBytes = fi.getSize();
	          // Write the file
	          if( filenm==null && fileName.lastIndexOf("\\") >= 0 ){
	          file = new File( filePath + 
	          fileName.substring( fileName.lastIndexOf("\\"))) ;
	          }else if(filenm==null){
	          file = new File( filePath + 
	          fileName.substring(fileName.lastIndexOf("\\")+1)) ;
	          }else{
	        	  file = new File( filePath+File.separator+filenm); 
	          }
	          System.out.println("File Absolute Path "+file.getAbsolutePath());
	          File filepath=new File(filePath);
	          System.out.println("FilePath to Check: "+filepath.getAbsolutePath());
	          if(!filepath.exists()){
	        	  System.out.println("Filepath does not exist");
	        	  filepath.mkdirs();
	          }
	          if(fieldName.endsWith("_img")){
	        	  ImageIO.write(image, "png", file);
	          }else{
		          fi.write( file) ;	        	  
	          }


	          System.out.println("<tr><td>"+bundle.getString("uploadedfilename")+" " + file.getAbsolutePath() + "</td></tr>");
	          result.put(fieldName,"<tr><td>"+bundle.getString("uploadedfilename")+" " + file.getAbsolutePath() +"</td></tr>");
	          newimagepath=filePath+fileName;
	          }else{
	        	 result.put(fieldName,fi.getString()); 
	          }
	       }
	    }catch(Exception ex) {
	    	System.out.println(ex.getMessage());
	    }
	    return result;
	}

}
