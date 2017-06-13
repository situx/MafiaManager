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

import java.io.File;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.ext.DefaultHandler2;

import com.example.LNDWA.cards.Game;

import com.github.situx.lndwa.Utils.Tuple;
import com.github.situx.lndwa.data.GameResult;
import com.github.situx.lndwa.data.datamanagement.ManageCards;
import com.github.situx.lndwa.data.datamanagement.ManageGameSets;
import com.github.situx.lndwa.data.datamanagement.ManagePlayers;

public class GameResultParser extends DefaultHandler2 {
	
	private List<Tuple<String,Integer>> gamelog;
	
	private String gameid;
	
	private String gameset;
	
	
	private String player;
	
	private Boolean log;
	
	private Integer round;

	List<GameResult> results;

	private GameResult gameresult;

	private boolean gamelg;

	private String contextpath,logtemp="";
	
	public GameResultParser(String contextpath){
		this.results=new LinkedList<GameResult>();
		this.gamelog=new LinkedList<>();
		this.log=false;
		this.gamelg=false;
		this.contextpath=contextpath;
	}
	
	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {
		System.out.println(qName);
		switch(qName){
		case "gameresult":this.gameresult=new GameResult();
			this.gameresult.setGameid(attributes.getValue("gameid"));
			this.gameresult.setRounds(Integer.valueOf(attributes.getValue("rounds")));
			this.gameresult.setGameset(ManageGameSets.getInstance(contextpath).get(attributes.getValue("gameset")));
			this.gameresult.setTime(attributes.getValue("time"));
			this.gameresult.setCompetition(attributes.getValue("competition"));
			this.gameresult.setGametitle(attributes.getValue("gametitle"));
			//this.gameresult.setWinninggroup(ManageGroups.getInstance(contextpath).get(this.gameset, attributes.getValue("winninggroup")));
							break;
		case "game": Game game=new Game(this.gameresult.getGameid());
					 game.setPoints(Integer.valueOf(attributes.getValue("points")));
					 game.setPlayer(attributes.getValue("player"));
					 game.setCharacter(ManageCards.getInstance(contextpath).get(this.gameresult.getGameset().getGamesetid(), attributes.getValue("character")));
					 game.setPlayer(ManagePlayers.getInstance(contextpath).get(attributes.getValue("player")));
					 game.setWon(Boolean.valueOf(attributes.getValue("won")));
					 game.setDead(Boolean.valueOf(attributes.getValue("dead")));
					 game.setRound(Integer.valueOf(attributes.getValue("round")));
					 this.gameresult.game.add(game);
					 break;
		case "gamelog":this.gamelg=true;break;
		case "log": this.log=true;this.round=Integer.valueOf(attributes.getValue("round"));break;
		}
	}
	
	@Override
	public void characters(char[] ch, int start, int length)
			throws SAXException {
		if(log)
			this.logtemp+=new String(ch,start,length);
	}

	@Override
	public void endElement(String uri, String localName, String qName)
			throws SAXException {
		switch(qName){
		case "gameresult":System.out.println("Add GameResult: "+this.gameresult.toString());this.results.add(this.gameresult);break;
		case "gamelog":this.gamelg=false;this.gameresult.setGamelog(this.gamelog);break;
		case "log":this.gamelog.add(new Tuple<String,Integer>(this.logtemp,round));this.logtemp="";break;
		}
		
	}
	
    /**
     * Parses a game file and fills the corresponding fields in this class.
     *
     * @param file the file to parse
     * @return 
     */
    public List<GameResult> parseGameResult(final File file) {
    	System.out.println("GameResult Parser File: "+file.getAbsolutePath());
        try {
            SAXParserFactory.newInstance().newSAXParser().parse(file, this);
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        }
        return this.results;
    }
}
