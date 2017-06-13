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
package com.github.situx.lndwa.util.parser;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.github.situx.lndwa.data.User;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;

public class UserParse extends DefaultHandler {

	private Map<String,User> users;
	
	public UserParse(){
		this.users=new TreeMap<String,User>();
	}
	
	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {
		switch(qName){
		case "user": User user=new User();
			user.setUsername(attributes.getValue("username"));
			user.setPassword(attributes.getValue("password"));
			user.setAdmin(Boolean.valueOf(attributes.getValue("admin")));
			user.setEdit(Boolean.valueOf(attributes.getValue("edit")));
			this.users.put(user.getUsername(),user);
		}
	}
	
    /**The parsing function for the characters.
     * @param fileName the name of the file to be parsed.
     * @return the list of characters.**/
    public Map<String,User> parseUsers(final File fileName){
        try {
            SAXParserFactory.newInstance().newSAXParser().parse(fileName, this);
        } catch (SAXException e) {
            e.toString();
        } catch (IOException e) {
            e.toString();
        } catch (ParserConfigurationException e) {
            e.toString();
        }
        return this.users;
    }
}
