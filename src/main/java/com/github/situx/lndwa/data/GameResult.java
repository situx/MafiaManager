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
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElementRef;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.github.situx.lndwa.cards.Card;
import com.github.situx.lndwa.cards.GameElements;
import com.github.situx.lndwa.cards.GameSet;
import com.github.situx.lndwa.cards.Group;
import com.google.gson.Gson;
import com.github.situx.lndwa.cards.Game;

import com.github.situx.lndwa.Utils.Tuple;

@XmlRootElement(name="GameResult")
public class GameResult implements GameElements,Comparable<GameResult> {
	  @XmlAttribute(name="gameid")
	  public String gameid;
	  @XmlAttribute
	  public String competition;
	  @XmlElementRef
	  public List<Game> game=new LinkedList<Game>();
	  
	  public List<Tuple<String,Integer>> gamelog;
	  @XmlAttribute(name="gameset")
	  public GameSet gameset;
	  
	  public Map<Card,Boolean> characters;
	  @XmlAttribute(name="winninggroup")
	  public Group winninggroup;
	  
	  public String gametitle;
	  
	  public Integer rounds;
	  
	  public Integer getRounds() {
		return rounds;
	}

	public void setRounds(Integer rounds) {
		this.rounds = rounds;
	}

	public String getGameid() {
		return gameid;
	}

	public void setGameid(String gameid) {
		this.gameid = gameid;
	}

	public List<Game> getGame() {
		return game;
	}

	public void setGame(List<Game> game) {
		this.game = game;
	}

	public List<Tuple<String, Integer>> getGamelog() {
		return gamelog;
	}

	public void setGamelog(List<Tuple<String, Integer>> gamelog) {
		this.gamelog = gamelog;
	}

	public GameSet getGameset() {
		return gameset;
	}

	public void setGameset(GameSet gameset) {
		this.gameset = gameset;
	}

	public Map<Card, Boolean> getCharacters() {
		return characters;
	}

	public void setCharacters(Map<Card, Boolean> characters) {
		this.characters = characters;
	}

	public Group getWinninggroup() {
		return winninggroup;
	}

	public void setWinninggroup(Group winninggroup) {
		this.winninggroup = winninggroup;
	}

	public String getGametitle() {
		return gametitle;
	}

	public void setGametitle(String gametitle) {
		this.gametitle = gametitle;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String time;
	  
	  public GameResult(){
		 //this.winningroup=game.get(0). 
	  }
	  
	  public Integer getMaxPoints(){
		  Integer max=0;
		  for(Game gam:game){
			  if(max<gam.points){
				  max=gam.points;
			  }
		  }
		  return max;
	  }
	  
	  @Override
	public String toString() {
		// TODO Auto-generated method stub
		return gameid+"\n"+game;
	}

	@Override
	public boolean synchronize(GameElements elem) {
		// TODO Auto-generated method stub
		return false;
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
				writer.writeStartElement("GameResult");
				writer.writeAttribute("competition",this.competition);
				writer.writeAttribute("gameid", this.gameid);
				writer.writeAttribute("gameset", this.gameset.getGamesetid());
				writer.writeAttribute("gametitle", this.gametitle);
				writer.writeAttribute("time", this.time);
				writer.writeAttribute("rounds", this.rounds.toString());
				writer.writeAttribute("winninggroup",this.winninggroup.toString());
				for(Game gam:this.game){
					writer.writeCharacters(gam.toXML());
				}
				writer.writeStartElement("gamelog");
				for(Tuple<String,Integer> log:this.gamelog){
					writer.writeStartElement("log");
					writer.writeAttribute("round", log.getTwo().toString());
					writer.writeCharacters(log.getOne());
					writer.writeEndElement();
				}
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

		public String getCompetition() {
			return competition;
		}

		public void setCompetition(String competition) {
			this.competition = competition;
		}

		@Override
		public int compareTo(GameResult o) {
			return this.gameid.compareTo(o.gameid);
		}

}
