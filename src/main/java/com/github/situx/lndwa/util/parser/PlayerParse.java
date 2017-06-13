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

import com.example.LNDWA.cards.Game;
import com.github.situx.lndwa.cards.Player;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import java.io.File;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;

/**
 * Created with IntelliJ IDEA.
 * User: timo
 * Date: 25.11.13
 * Time: 18:02
 * Parses a list of players_config.
 */
public class PlayerParse extends DefaultHandler {
    /**Temp player for parsing a player list.*/
    private Player player;
    /**List of player to be parsed.*/
    private List<Player> playerList;

    private Boolean play=false;

    /**
     * Constructor for this class.
     */
    public PlayerParse(){
        this.playerList=new LinkedList<>();
    }

    @Override
    public void startElement(final String uri, final String localName, final String qName, final Attributes attributes) throws SAXException {
        switch(qName){
            case "player": this.player=new Player(attributes.getValue("name"),attributes.getValue("firstname"));
                this.player.setTotal(Integer.valueOf(attributes.getValue("total")));
                if(attributes.getValue("playerid")==null){
                    this.player.setPlayerid(UUID.randomUUID().toString());
                }else{
                    this.player.setPlayerid(attributes.getValue("playerid"));
                }
                this.play=true;break;
            case "game": if(play){
                this.player.addGame(new Game(attributes.getValue("character"),Integer.valueOf(attributes.getValue("points")),attributes.getValue("id")));
            }
            default:
        }
    }

    @Override
    public void endElement(final String uri, final String localName, final String qName) throws SAXException {
        switch(qName){
            case "player": this.playerList.add(this.player);this.play=false;break;
            default:
        }
    }

    /**
     * Returns the parsed list of players_config.
     * @return the list of players_config
     */
    public List<Player> getPlayers() {
        return this.playerList;
    }

    /**
     * Parses a game file and fills the corresponding fields in this class.
     *
     * @param file the file to parse
     */
    public void parsePlayer(final File file) {
        try {
            SAXParserFactory.newInstance().newSAXParser().parse(file, this);
        } catch (SAXException e) {
            e.toString();
        } catch (IOException e) {
            e.toString();
        } catch (ParserConfigurationException e) {
            e.toString();
        }
    }
}
