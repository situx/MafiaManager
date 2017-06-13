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

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.example.LNDWA.cards.GameElements;
import com.google.gson.Gson;


@XmlRootElement(name="game")
public class Game implements GameElements{
	@XmlAttribute
	public String character;
	@XmlAttribute
	public String player;
	@XmlAttribute
	public String competition;
	@XmlAttribute
	public Integer points;
	@XmlAttribute
	public Boolean won;
	@XmlAttribute
	public Integer round;
	@XmlAttribute
	public Boolean dead;
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return character+" "+player+" "+points+" "+won;
	}

	@Override
	public boolean synchronize(GameElements elem) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public String toXML() {
		StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartDocument();
			writer.writeStartElement("game");
			writer.writeAttribute("character", this.character);
			writer.writeAttribute("player", this.player);
			writer.writeAttribute("dead", this.dead.toString());
			writer.writeAttribute("points", this.points.toString());
			writer.writeAttribute("won", this.won.toString());
			writer.writeAttribute("round",this.round.toString());
			writer.writeEndElement();
			writer.writeEndDocument();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(strwriter.toString());
		return strwriter.toString();
	}
	
	
	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}
	
}
