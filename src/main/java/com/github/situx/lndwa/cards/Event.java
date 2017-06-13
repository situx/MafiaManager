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
import java.util.UUID;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.google.gson.Gson;

/**
 * Created by timo on 17.01.14.
 */
public class Event implements GameElements, Comparable<Event> {

    /**
     * Title of the event.
     */
	@XmlAttribute
    private String title;
    /**
     * Event id.
     */
	@XmlAttribute
    private String id;
    /**
     * Description of the event.
     */
    private String description;
    /**
     * Probability of the event to occur.
     */
    @XmlAttribute
    private Integer probability;
    /**
     * Indicates if the event is active.
     */
    @XmlAttribute
    private Boolean active;

    /**
     * Empty constructor for event using default values.
     */
    public Event() {
        this.title = "";
        this.description = "";
        this.probability = 100;
        this.active = false;
        this.id=UUID.randomUUID().toString();
    }


    /**
     * Gets the active state of this event.
     * @return the state as Boolean
     */
    public Boolean getActive() {
        return active;
    }

    /**
     * Sets the active state of this event.
     * @param active the active state as Boolean
     */
    public void setActive(final Boolean active) {
        this.active = active;
    }

    /**
     * Gets the description of this event.
     * @return the description as String
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the description of this event.
     * @param description the description as String
     */
    public void setDescription(final String description) {
        this.description = description;
    }

    /**
     * Gets the id of this event.
     * @return the id as Integer
     */
    public String getId() {
        return id;
    }

    /**
     * Sets the id of this event.
     * @param id the id as Integer
     */
    public void setId(final String id) {
        this.id = id;
    }

    /**
     * Gets the probability of this event.
     * @return the probability as Integer
     */
    public Integer getProbability() {
        return probability;
    }

    /**
     * Sets the probability of this event.
     * @param probability the probability as Integer
     */
    public void setProbability(final Integer probability) {
        this.probability = probability;
    }

    /**
     * Gets the title of this event.
     * @return the title as String
     */
    public String getTitle() {
        return title;
    }

    /**
     * Sets the title of this event.
     * @param title the title as Stirng
     */
    public void setTitle(final String title) {
        this.title = title;
    }

    /**
     * Generates an xml representation of this event.
     * @return The xml representation as String
     */
    @Override
    public String toXML() {
		StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartDocument();
			writer.writeStartElement("event");
			writer.writeAttribute("active", this.active.toString());
			writer.writeAttribute("id", this.id.toString());
			writer.writeAttribute("probability", this.probability.toString());
			writer.writeAttribute("title", this.title);
			writer.flush();
			writer.writeCharacters("\n");
			writer.writeStartElement("description");
			writer.writeCharacters(this.description);
			writer.writeEndElement();
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


	@Override
	public boolean synchronize(GameElements elem) {
		Event newevent=(Event)elem;
		this.active=newevent.active;
		this.description=newevent.description;
		this.id=newevent.id;
		this.probability=newevent.probability;
		this.title=newevent.title;
		return true;
	}


	@Override
	public int compareTo(Event o) {
		return this.title.compareTo(o.title);
	}
	
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof Event){
			return this.id.equals(((Event)obj).id);
		}
		return false;
	}
	
	@Override
	public String toString() {
		return this.title;
	}

}
