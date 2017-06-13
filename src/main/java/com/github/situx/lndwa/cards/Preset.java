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
package com.github.situx.lndwa.cards;

import java.io.StringWriter;
import java.util.TreeMap;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.google.gson.Gson;

/**
 * Created by timo on 13.02.14.
 */
public class Preset implements GameElements,Comparable<Preset> {

    /**
     * The preset list of cards.
     */
    private java.util.Map<String, Integer> cardlist;
    /**The name of the preset.*/
    @XmlAttribute
    private String presetName;
    /**The amount of players included in the preset.*/
    @XmlAttribute
    private Integer player;
    @XmlAttribute
    private String gamesetid;
    
    private String presetId;

    public String getPresetId() {
		return presetId;
	}

	public void setPresetId(String presetId) {
		this.presetId = presetId;
	}

	public String getGamesetid() {
        return gamesetid;
    }

    public void setGamesetid(final String gamesetid) {
        this.gamesetid = gamesetid;
    }

    /**
     * Constructor for this class.
     *
     * @param cardlist the list of cards
     */
    public Preset(final java.util.Map<String, Integer> cardlist) {
        this.cardlist = cardlist;
    }

    /**
     * Empty constructor for preset.
     */
    public Preset() {
        this.cardlist = new TreeMap<>();
        this.presetName="";
        this.player=0;
    }


    public java.util.Map<String, Integer> getCardlist() {
        return cardlist;
    }

    public void setCardlist(final java.util.Map<String, Integer> cardlist) {
        this.cardlist = cardlist;
    }

    public Integer getPlayer() {
        return player;
    }

    public void setPlayer(final Integer player) {
        this.player = player;
    }

    public String getPresetName() {
        return presetName;
    }

    public void setPresetName(final String presetName) {
        this.presetName = presetName;
    }

    @Override
    public String toXML() {
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartDocument();
			writer.writeStartElement("preset");
			writer.writeAttribute("name", this.presetName.toString());
			writer.writeAttribute("player", this.player.toString());
			writer.writeAttribute("gameid", this.gamesetid);
			for(String cardid:this.cardlist.keySet()){
				writer.writeStartElement("card");
				writer.writeAttribute("amount", this.cardlist.get(cardid).toString());
				writer.writeCharacters(cardid);
				writer.writeEndElement();
			}
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
	public boolean synchronize(GameElements elem) {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return this.presetName;
	}

	@Override
	public int compareTo(Preset o) {
		int compareval = this.getPlayer().compareTo(o.getPlayer());
        if (compareval == 0) {
            return this.getPresetName().compareTo(o.getPresetName());
        }
        return compareval;
	}
}
