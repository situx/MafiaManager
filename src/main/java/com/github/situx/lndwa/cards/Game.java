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

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.google.gson.Gson;

import com.github.situx.lndwa.data.datamanagement.ManagePlayers;

/**
 * Created with IntelliJ IDEA.
 * User: timo
 * Date: 25.11.13
 * Time: 18:03
 * Represents a game having taken place.
 */
@XmlRootElement(name="game")
public class Game implements GameElements {
    /**
     * The character being used in this game.
     */
	@XmlAttribute
    public Card character;
    @XmlAttribute
	public Boolean dead;

	/**
     * The id of this game.
     */
	@XmlAttribute
    public String gameid;

	@XmlAttribute
    public Player player;

	/**
     * The points this player got in this game.
     */
	@XmlAttribute
    public Integer points;

	public Integer round;

	@XmlAttribute
	public Boolean won;

	/**
     * Gameid constructor for this game initializing it with default values.
     *
     * @param id the gameid
     */
    public Game(final String id) {
        this.gameid = id;
        this.points = 0;
        this.character = new Card();
    }

	/**
     * Constructor for this class.
     *
     * @param character the character being played in this game
     * @param points    the points reached in this game
     * @param id        the gameid
     */
    public Game(final String character, final Integer points, final String id) {
        super();
        this.character = new Card();
        this.character.setName(character);
        this.points = points;
        this.gameid = id;
    }
    @Override
    public boolean equals(final Object o) {
        if(o instanceof Game){
            return this.gameid.equals(((Game)o).gameid);
        }
        return false;
    }
	public Card getCharacter() {
		return character;
	}
	public Boolean getDead() {
		return dead;
	}

	public String getGameid() {
		return gameid;
	}

	public Player getPlayer() {
		return player;
	}
	
	public Integer getPoints() {
		return points;
	}
	
	public Integer getRound() {
		return round;
	}


	public Boolean getWon() {
		return won;
	}

	public void setCharacter(Card character) {
		this.character = character;
	}

	public void setDead(Boolean dead) {
		this.dead = dead;
	}

	public void setGameid(String gameid) {
		this.gameid = gameid;
	}

	public void setPlayer(Player player) {
		this.player = player;
	}

    public void setPoints(Integer points) {
		this.points=points;
		
	}


    public void setRound(Integer round) {
		this.round = round;
	}

    public void setWon(Boolean won) {
		this.won = won;
	}

    @Override
    public boolean synchronize(final GameElements elem) {

        return false;
    }

	@Override
	public String toString() {
		return this.character+" ("+this.points+")";
	}
	
	/**
     * Generates an xml representation of this class.
     *
     * @return the xml representation as String
     */
    @Override
    public String toXML() {
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartElement("game");
			writer.flush();
	        writer.writeAttribute("id", this.gameid);
	        writer.writeAttribute("points", this.points.toString());
	        writer.writeAttribute("player", this.player.getPlayerid().toString());
	        writer.writeAttribute("character", this.character.toString());
	        writer.flush();
			writer.writeEndElement();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return strwriter.toString();
    }
    
	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}

	public void setPlayer(String value) {
		this.player=ManagePlayers.getInstance("").get(value);
		
	}
}
