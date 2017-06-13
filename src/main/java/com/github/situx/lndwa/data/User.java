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

import java.io.StringWriter;

import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.example.LNDWA.cards.GameElements;
import com.google.gson.Gson;

public class User implements GameElements,Comparable<User>{
	
	private String username;
	
	private String password;
	
	private Boolean admin;
	
	private Boolean edit;
	
	public User(String username, String password, Boolean admin,Boolean edit) {
		super();
		this.username = username;
		this.password = password;
		this.admin = admin;
		this.edit=edit;
	}

	public User() {
		this.username="";
		this.password="";
		this.admin=false;
		this.edit=false;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Boolean getAdmin() {
		return admin;
	}

	public void setAdmin(Boolean admin) {
		this.admin = admin;
	}

	@Override
	public boolean synchronize(GameElements elem) {
		User user=(User)elem;
		this.admin=user.admin;
		this.edit=user.edit;
		this.password=user.password;
		return true;
	}

	@Override
	public String toXML() {
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartElement("user");
	        writer.writeAttribute("username", this.username);
	        writer.writeAttribute("password", this.password);
	        writer.writeAttribute("admin", this.admin.toString());
	        writer.writeAttribute("edit", this.edit.toString());
	        writer.flush();
	        writer.writeCharacters("\n");
	        writer.flush();
			writer.writeEndElement();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			e.printStackTrace();
		}
		return strwriter.toString();
	}

	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}
	
	@Override
	public int compareTo(User o) {
		return this.username.compareTo(o.username);
	}

	public void setEdit(Boolean edit) {
		this.edit=edit;
	}

	public Boolean getEdit() {
		return edit;
	}
	
	
}
