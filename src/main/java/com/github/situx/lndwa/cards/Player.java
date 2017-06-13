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
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.google.gson.Gson;

/**
 * Created with IntelliJ IDEA.
 * User: timo
 * Date: 25.11.13
 * Time: 18:03
 * To change this template use File | Settings | File Templates.
 */
@XmlRootElement(name="player")
public class Player implements GameElements,Comparable<Player>{
    /**The player's first name.*/
	@XmlAttribute
    private String firstname;
    /**The players_config' last name.*/
    @XmlAttribute
    private String name;
    /**The id of this player.*/
    @XmlAttribute
    private String playerid;
    /**The total score of this player.*/
    @XmlAttribute
    private Integer total;
    /**List of games this player has played.*/
    private List<Game> games;
    /**List of items this player has collected.*/
    private List<Item> items;
    /**The current card of this player.*/
    private Card currentCard;

    /**
     * Constructor for this class.
     * @param name the last name of the player
     * @param firstname the first name of the player
     */
    public Player(final String name, final String firstname){
        this.name=name;
        this.firstname=firstname;
        this.total=0;
        this.games=new LinkedList<>();
        this.currentCard =null;
        this.playerid=UUID.randomUUID().toString();
    }

    /**
     * Empty constructor for player using default values.
     */
    public Player(){
        this.name="";
        this.firstname="";
        this.total=0;
        this.games=new LinkedList<>();
        this.items=new LinkedList<>();
        this.playerid= UUID.randomUUID().toString();
    }

    /**
     * Sets the first name of the corresponding player
     * @param firstname  the first name as String
     */
    public void setFirstname(final String firstname) {
        this.firstname = firstname;
    }

    /**
     * Sets the last name of the corresponding player
     * @param name the last name as String
     */
    public void setName(final String name) {
        this.name = name;
    }


    public Card getCurrentCard() {
        return currentCard;
    }

    public void setCurrentCard(final Card currentCard) {
        this.currentCard = currentCard;
    }

    public void addGame(final Game game){
        this.games.add(game);
    }

    public String getName(){
        return this.name;
    }

    public String getFirstname(){
        return this.firstname;
    }

    public Integer getTotal(){
        return this.total;
    }

    public void setTotal(final Integer total){
        this.total=total;
    }

    public List<Game> getGames(){
        return this.games;
    }

    @Override
    public boolean synchronize(final GameElements elem) {
    	Player player=(Player)elem;
    	this.firstname=player.firstname;
    	this.name=player.name;
        return false;
    }

    public String getPlayerid() {
        return playerid;
    }

    public void setPlayerid(final String playerid) {
        this.playerid = playerid;
    }

	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}
    
    /**
     * Generates an XML represntation of the current class.
     * @return the representation as String
     */
    @Override
    public String toXML(){
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartElement("player");
	        writer.writeAttribute("firstname", this.firstname);
	        writer.writeAttribute("name", this.name);
	        writer.writeAttribute("playerid", this.playerid);
	        writer.writeAttribute("total", this.total.toString());
	        writer.flush();
	        writer.writeCharacters("\n");
	        for (Game game: this.games){
	            strwriter.write(game.toXML()+"\n");
	        }
	        writer.flush();
			writer.writeEndElement();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			e.printStackTrace();
		}

		return strwriter.toString();
    }

    @Override
    public String toString() {
        return this.firstname+" "+this.name;
    }

	@Override
	public int compareTo(Player o) {
		int result=this.total.compareTo(o.total);
		if(result==0){
			return (this.firstname+" "+this.name).compareTo(o.firstname+" "+o.name);
		}		
		return result*-1;
	}
	
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof Player){
			return this.playerid.equals(((Player)obj).playerid);
		}
		return false;
	}
}
