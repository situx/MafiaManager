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

import com.github.situx.lndwa.cards.Card;
import com.github.situx.lndwa.cards.GameSet;

import com.github.situx.lndwa.Utils.Tuple;
import com.github.situx.lndwa.data.Data;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;

import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * Parses a game from a savegame file.
 */
public class GameParse extends DefaultHandler {
    /**
     * Cardlist containing a list of cards with duplicates for the Round2 screen layouts.
     */
    private final List<Card> cardlist;
    /**
     * Cardlist containing a list of cards without duplicates but with correct amount annotations.
     */
    private final List<Card> cardlist2;
    /**
     * A list of players_config playing in this game.
     */
    private final List<String> players;
    /**
     * The list of extracards contained in this game.
     */
    private final List<Card> extracards;
    /**
     * The array of extra card names as String.
     */
    private final List<String> extracardarray;
    /**
     * Maps the following information to represent card overlays:
     * RelativeLayoutID - Sourcecard ID - SourceCard Ability ID - Remaining duration of this ability
     */
    Map<Integer, Map<Integer, Tuple<Integer, Integer>>> cardTocardOverlays;
    /**
     * Card to relative layout map.
     */
    Map<Card, Set<Integer>> cardToRel;
    /**
     * Relative Layout to cardid map.
     */
    Map<Integer, Integer> relToCard;
    boolean gamefield = false;
    String gamesetname;
    GameSet gameset;
    /**
     * List of cardnames as StringList.
     */
    List<String> cardnames;
    /**
     * List of cardids as Integer.
     */
    List<Integer> cardids;
    /**
     * List of dead characters.
     */
    List<Boolean> deadlist;
    /**
     * Map from RelativeLayouts to ImageViews for Round2.
     */
    //private Map<Integer, Map<Integer, List<ImageView>>> relToImgView;
    /**
     * Map from cardnames to cardids.
     */
    private Map<String, Integer> cardUUIDTocardId;
    /**
     * Map from playernames to playerids.
     */
    private Map<String, Integer> playernameToPlayerId;
    private boolean extra = false;
    private boolean notassigned = false;
    private boolean overlay = false;
    private Integer rounds, counter;
    private boolean card;

    /**
     * Costructor for this class.
     *
     * @param context Context for accessing file paths.
     */
    public GameParse() {
        this.cardnames = new LinkedList<>();
        this.cardids = new LinkedList<>();
        this.cardlist = new LinkedList<Card>();
        this.cardlist2 = new LinkedList<>();
        this.players = new LinkedList<>();
        this.extracards = new LinkedList<>();
        this.extracardarray = new LinkedList<>();
        this.deadlist = new LinkedList<>();
        this.cardUUIDTocardId = new TreeMap<>();
        this.playernameToPlayerId = new TreeMap<>();
        this.cardTocardOverlays = new TreeMap<>();
        this.cardToRel = new TreeMap<>();
        this.relToCard = new TreeMap<>();;

    }

    @Override
    public void characters(final char[] ch, final int start, final int length) throws SAXException {
        super.characters(ch, start, length);
        if (card && extra) {
            this.extracardarray.add(new String(ch, start, length));
        } else if (card && notassigned) {
            this.cardnames.add(new String(ch, start, length));
        }/*else if(card && !extra){
            this.cardids.add(Integer.valueOf(new String(ch, start, length)));
        }*/

    }

    public GameSet getGameset() {
        return gameset;
    }

    public void setGameset(final GameSet gameset) {
        this.gameset = gameset;
    }

    @Override
    public void endElement(final String uri, final String localName, final String qName) throws SAXException {
        super.endElement(uri, localName, qName);
        switch (qName) {
            case "gamefield":
                List<Card> roundcardlist = new LinkedList<>();
                int i = 0;
                boolean found = false;
                for (String cardname : this.cardnames) {
                    found = false;
                    for (Card card : gameset.getCards()) {
                        if (card.getCardid().equals(cardname)) {
                            found = true;
                            Card cardd = card;
                            cardd.setCurrentamount(1);
                            if (deadlist.get(i++)) {
                                cardd.dead();
                            }
                            this.cardlist.add(cardd);
                            if (!cardlist2.contains(cardd)) {
                                this.cardlist2.add(new Card(cardd));
                            }else{
                                this.cardlist2.get(this.cardlist2.indexOf(cardd)).setCurrentamount(this.cardlist2.get(this.cardlist2.indexOf(cardd)).getCurrentamount()+1);
                            }

                        }
                    }
                }
                Collections.sort(this.cardlist2, new Comparator<Card>() {
                    public int compare(Card s1, Card s2) {
                        return s1.getPosition().compareTo(s2.getPosition());
                    }
                });
                break;

            case "notassigned":
                this.notassigned = false;
                break;
            case "extra":for(Card card:this.gameset.getCards()){
                if(this.extracardarray.contains(card.getName())){
                    this.extracards.add(card);
                }
            }

            default:
        }
    }

    public Map<Integer, Map<Integer, Tuple<Integer, Integer>>> getCardTocardOverlays() {
        return cardTocardOverlays;
    }

    public List<Boolean> getDeadlist() {
        return deadlist;
    }

    public void setCardTocardOverlays(final Map<Integer, Map<Integer, Tuple<Integer, Integer>>> cardTocardOverlays) {
        this.cardTocardOverlays = cardTocardOverlays;
    }

    public List<Integer> getCardids() {
        return cardids;
    }

    public List<Card> getCardlist() {
        return cardlist;
    }

    public List<Card> getCardlist2() {
        return cardlist2;
    }

    public Map<String, Integer> getCardUUIDTocardId() {
        return cardUUIDTocardId;
    }

    /**
     * Returns the card names found in this savegame.
     *
     * @return the card names as list of String
     */
    public List<String> getCardnames() {
        return cardnames;
    }

    /**
     * Gets the counter of this savegame.
     *
     * @return the counter as Integer
     */
    public Integer getCounter() {
        return counter;
    }

    public List<String> getExtracardarray() {
        return extracardarray;
    }

    public List<Card> getExtracards() {
        return extracards;
    }

    public String getGamesetname() {
        return gamesetname;
    }

    /**
     * Gets the players_config of this savegame.
     *
     * @return the list of players_config as String
     */
    public List<String> getPlayers() {
        return players;
    }

    public Map<Integer, Integer> getRelToCard() {
        return relToCard;
    }

    /**
     * Gets the rounds of this savegame.
     *
     * @return the rounds as Integer
     */
    public Integer getRounds() {
        return rounds;
    }

    /**
     * Parses a game file and fills the corresponding fields in this class.
     *
     * @param file the file to parse
     */
    public void parseGame(final File file) {
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

    @Override
    public void startElement(final String uri, final String localName, final String qName, final Attributes attributes) throws SAXException {
        super.startElement(uri, localName, qName, attributes);
        switch (qName) {
            case "SaveGame":
                this.gamesetname = attributes.getValue("gameset");
                try {
                    this.gameset = new GameSet(new File(Data.GAMESETPATH+"/" + gamesetname + ".xml"),"");
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (ParserConfigurationException e) {
                    e.printStackTrace();
                }
                this.rounds = Integer.valueOf(attributes.getValue("round"));
                this.counter = Integer.valueOf(attributes.getValue("counter"));
                break;
            case "gamefield":
                gamefield = true;
                break;
            case "overlay":
                overlay = true;
                Map<Integer, Tuple<Integer, Integer>> abilitymap = new TreeMap<>();
                abilitymap.put(Integer.valueOf(attributes.getValue("from")), new Tuple<>(Integer.valueOf(attributes.getValue("abb")), Integer.valueOf(attributes.getValue("duration"))));
                this.cardTocardOverlays.put(this.relToCard.keySet().size()-1, abilitymap);
                break;
            case "field":
                this.cardids.add(Integer.valueOf(attributes.getValue("charid")));
                this.cardnames.add(attributes.getValue("cardname"));
                //this.cardUUIDTocardId.put(attributes.getValue("cardname"), Integer.valueOf(attributes.getValue("charid")));
                this.relToCard.put(Integer.valueOf(attributes.getValue("relId")), Integer.valueOf(attributes.getValue("charid")));
                this.players.add(attributes.getValue("player"));
                //this.playernameToPlayerId.put(attributes.getValue("player"),)
                this.deadlist.add(Boolean.valueOf(attributes.getValue("dead")));
                break;
            case "extra":
                this.extra = true;
                break;
            case "notassigned":
                if (gamefield) this.notassigned = true;
                break;
            case "card":
                this.card = true;
                break;
            default:
        }
    }


}
