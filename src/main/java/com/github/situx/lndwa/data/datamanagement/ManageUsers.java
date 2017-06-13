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
package com.github.situx.lndwa.data.datamanagement;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import com.github.situx.lndwa.data.Data;
import com.github.situx.lndwa.data.User;

public class ManageUsers {
	
	private static ManageUsers instance;
	
	private Map<String,User> logindata;
	
	private Set<User> userlist;

	private ManageUsers(String contextpath){
		this.logindata=Data.getInstance(contextpath).getLogindata();
		this.userlist=new TreeSet<>();
	}
	
	public static ManageUsers getInstance(String contextpath){
		if(instance==null){
			instance=new ManageUsers(contextpath);
		}
		return instance;
	}
	
	/**
	 * Login procedure for the user.
	 * @param username the username
	 * @param password the password
	 * @return success indicator
	 * @throws NoSuchAlgorithmException
	 * @throws IOException
	 */
	public Boolean login(final String username,final String password) throws NoSuchAlgorithmException, IOException{
		if(!this.logindata.containsKey(username)){
			return false;
		}
		System.out.println(generateHashValue(password)+" - "+this.logindata.get(username).getPassword());
		if(!generateHashValue(password).equals(this.logindata.get(username).getPassword())){
			return false;
		}
		return true;
	}
	
	
	/**
	 * Generates a hash value to store in the database.
	 * @param password the password to convert
	 * @return the converted String
	 * @throws NoSuchAlgorithmException
	 * @throws IOException
	 */
	private static String generateHashValue(final String password) throws NoSuchAlgorithmException, IOException{
		MessageDigest md = MessageDigest.getInstance("SHA1");
	    ByteArrayInputStream fis = new ByteArrayInputStream(password.getBytes("UTF-8"));
	    byte[] dataBytes = new byte[1024];
	 
	    int nread = 0; 
	 
	    while ((nread = fis.read(dataBytes)) != -1) {
	      md.update(dataBytes, 0, nread);
	    };
	 
	    byte[] mdbytes = md.digest();
	 
	    //convert the byte to hex format
	    StringBuffer sb = new StringBuffer("");
	    for (int i = 0; i < mdbytes.length; i++) {
	    	sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16).substring(1));
	    } 
	    return sb.toString();	 
	}
	
	public Boolean add(final User user){
		if(!this.logindata.containsKey(user.getUsername())){
			try {
				user.setPassword(generateHashValue(user.getPassword()));
			} catch (NoSuchAlgorithmException | IOException e) {
				e.printStackTrace();
			}
			this.logindata.put(user.getUsername(),user);
			return true;
		}
		return false;
	}
	
	public Boolean remove(final String username){
		this.logindata.remove(username);
		return true;
	}
	
	public List<User> getUsers(){
		this.userlist.clear();
		for(User user:this.logindata.values()){
			this.userlist.add(user);
		}
		return new LinkedList<>(this.userlist);
	}
	
	public User getUser(final String username){
		return this.logindata.get(username);
	}
	
	public Boolean updateUser(final String username,final User user){
		if(this.logindata.containsKey(username)){
			this.logindata.get(username).synchronize(user);
			return true;
		}
		return false;
	}

	public static void main(String[] args) throws IOException, NoSuchAlgorithmException {
		System.out.println(ManageUsers.generateHashValue("123"));
	}
}
