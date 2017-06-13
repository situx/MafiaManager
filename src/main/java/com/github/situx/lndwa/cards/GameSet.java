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

import com.github.situx.lndwa.util.parser.PresetParse;
import org.xml.sax.SAXException;

import com.example.LNDWA.util.parser.CharParse;
import com.google.gson.Gson;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElementRef;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.*;

/**
 * Created by timo on 07.02.14.
 */
@XmlRootElement(name="gameset")
public class GameSet implements  GameElements,Comparable<GameSet> {

    /**
     * The list of cards used by this GameSet.
     */
    @XmlElementRef
    private List<Card> cards;
    
    private Map<String,Card> uuidToCard;
    
    private Map<String,Event> uuidToEvent;
    
    
    private Map<String,Group> uuidToGroup;
    public Map<String, Group> getUuidToGroup() {
		return uuidToGroup;
	}



	public void setUuidToGroup(Map<String, Group> uuidToGroup) {
		this.uuidToGroup = uuidToGroup;
	}

	/**
     * The list of events used by this GameSet.
     */
    @XmlElementRef
    private List<Event> events;
    /**
     * The list of items used by this GameSet.
     */
    @XmlElementRef
    private List<Item> items;
    /**
     * The list of presets used by this GameSet.
     */
    @XmlElementRef
    private Map<String,Preset> presets;
    /**
     * The set of groups included in this GameSet.
     */
    private Set<Group> groups;
    /**
     * The title of this GameSet.
     */
    @XmlAttribute
    private String title;
    /**
     * The front cover of this GameSet.
     */
    @XmlAttribute
    private String gamesetImg;
    /**
     * The card back image of all the cards in this GameSet.
     */
    @XmlAttribute
    private String backImg;
    /**
     * The xml sourcefile path to this GameSet.
     */
    @XmlAttribute
    private String sourcefile;
    
    private String introtitle;
    
    private String introtext;
    
    private String outrotitle;
    
    private String outrotext;
    /**
     * The minimum amount of players to play using this GameSet.
     */
    @XmlAttribute
    private Integer fromPlayers;
    /**
     * The maximum amount of players to play using this GameSet.
     */
    @XmlAttribute
    private Integer toPlayers;
    public Map<String, Card> getUuidToCard() {
		return uuidToCard;
	}
    
    

	public String getIntrotitle() {
		return introtitle;
	}



	public void setIntrotitle(String introtitle) {
		this.introtitle = introtitle;
	}



	public String getIntrotext() {
		return introtext;
	}



	public void setIntrotext(String introtext) {
		this.introtext = introtext;
	}



	public String getOutrotitle() {
		return outrotitle;
	}



	public void setOutrotitle(String outrotitle) {
		this.outrotitle = outrotitle;
	}



	public String getOutrotext() {
		return outrotext;
	}



	public void setOutrotext(String outrotext) {
		this.outrotext = outrotext;
	}



	public void setUuidToCard(Map<String, Card> uuidToCard) {
		this.uuidToCard = uuidToCard;
	}

	/**
     * Indicates if this GameSet uses a balance valuese to indicates the equalness of certain parties.
     */
    @XmlAttribute
    private Boolean hasBalance = true;
    @XmlAttribute
    private String language;
    @XmlAttribute
    private String gamesetid;



    /**
     * Empty constructor for GameSet.
     */
    public GameSet() {
        this.cards = new LinkedList<>();
        this.events = new LinkedList<>();
        this.gamesetImg = "";
        this.title = "";
        this.items = new LinkedList<>();
        this.presets = new TreeMap<String, Preset>();
        this.uuidToCard=new TreeMap<String, Card>();
        this.uuidToEvent=new TreeMap<String, Event>();
        this.uuidToGroup=new TreeMap<String, Group>();
        this.sourcefile = "";
        this.fromPlayers = 0;
        this.toPlayers = 0;
        this.groups = new TreeSet<>();
        this.backImg = "";
        this.gamesetid=UUID.randomUUID().toString();
        this.introtext="";
        this.introtitle="";
        this.outrotext="";
        this.outrotitle="";
        this.language="";

    }


    /**
     * Constructor for gameset.
     *
     * @param cards
     * @param events
     * @param items
     * @param title
     * @param gamesetImg
     * @param sourcefile
     */
    public GameSet(List<Card> cards, List<Event> events, List<Item> items, String title, String gamesetImg, String sourcefile, String gamesetid,

                   String introtext, String outrotext, String introtitle, String outrotitle, String language) {
        this.cards = cards;
        this.events = events;
        this.gamesetImg = gamesetImg;
        this.title = title;
        this.items = items;
        this.sourcefile = sourcefile;
        this.fromPlayers = 0;
        this.toPlayers = 0;
        this.groups = new TreeSet<>();
        this.uuidToGroup=new TreeMap<>();
        this.uuidToCard=new TreeMap<String, Card>();
        this.uuidToGroup=new TreeMap<String, Group>();
        this.gamesetid=gamesetid;
        this.introtext=introtext;
        this.introtitle=introtitle;
        this.outrotext=outrotext;
        this.outrotitle=outrotitle;
        this.language=language;
    }

    /**
     * File constructor for GameSet.
     *
     * @param file the gameset file
     * @throws IOException
     * @throws SAXException
     * @throws ParserConfigurationException
     */
    public GameSet(final File file,String presetpath) throws IOException, SAXException, ParserConfigurationException {
        CharParse charparse = new CharParse();
        this.cards=new LinkedList<>();
        this.cards = charparse.parseChars(file);
        this.cards=charparse.getCardList();
        this.items = new LinkedList<>();
        this.title = charparse.getGamesettitle();
        this.gamesetImg = charparse.getGamesetimg();
        this.gamesetid=charparse.getGamesetid();
        this.hasBalance=charparse.getHasBalanceValue();
        this.sourcefile = file.getAbsolutePath();
        this.language=charparse.getLanguage();
        this.backImg = charparse.getBackimg();
        this.fromPlayers = charparse.getFromPlayers();
        this.toPlayers = charparse.getToPlayers();
        this.groups = new TreeSet<>(charparse.getGroups());
		this.uuidToGroup=new TreeMap<String, Group>();
		for(Group group:this.groups){
			this.uuidToGroup.put(group.getGroupId(),group);
		}
        this.outrotext=charparse.getOutrotext();
        this.outrotitle=charparse.getOutrotitle();
        this.introtitle=charparse.getIntrotitle();
        this.introtext=charparse.getIntrotext();
		Collections.sort(this.cards, new Comparator<Card>() {
            public int compare(Card s1, Card s2) {
                return s1.getName().compareTo(s2.getName());
            }
        });
		this.uuidToCard=new TreeMap<String, Card>();
		for(Card card:this.cards){
			this.uuidToCard.put(card.getCardid(),card);
		}
        this.events = new LinkedList<>(charparse.getEvents());
		Collections.sort(this.events, new Comparator<Event>() {
            public int compare(Event s1, Event s2) {
                return s1.getTitle().compareTo(s2.getTitle());
            }
        });
		this.uuidToEvent=new TreeMap<String, Event>();
		for(Event event:this.events){
			this.uuidToEvent.put(event.getId(),event);
		}
        this.presets=new TreeMap<String, Preset>();
        String temppath=presetpath+this.gamesetid+"_presets.xml";
        File presetfile=new File(temppath);
        if(presetfile.exists()){
        	System.out.println("Parsing Presets");
        	this.presets = new PresetParse().parsePreset(presetfile);
        	System.out.println("Results "+this.presets.toString());
        }else{
        	System.out.println("Presetfile "+temppath+" does not exist!");
        }

    }


    public Map<String, Event> getUuidToEvent() {
		return uuidToEvent;
	}



	public void setUuidToEvent(Map<String, Event> uuidToEvent) {
		this.uuidToEvent = uuidToEvent;
	}



	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getGamesetid() {
		return gamesetid;
	}

	public void setGamesetid(String gamesetid) {
		this.gamesetid = gamesetid;
	}

	/**
     * Gets the card back image of all the cards in this GameSet.
     *
     * @return the image path as String.
     */
    public String getBackImg() {
        return backImg;
    }

    /**
     * Sets the card back image path of all the cards in this GameSet.
     *
     * @param backImg the image path as String
     */
    public void setBackImg(final String backImg) {
        this.backImg = backImg;
    }

    public List<Card> getCards() {
        return cards;
    }

    public void setCards(final List<Card> cards) {
        this.cards = cards;
    }

    public List<Event> getEvents() {
        return events;
    }

    public void setEvents(final List<Event> events) {
        this.events = events;
    }

    public Integer getFromPlayers() {
        return fromPlayers;
    }

    public void setFromPlayers(final Integer fromPlayers) {
        this.fromPlayers = fromPlayers;
    }

    public String getGamesetImg() {
        return gamesetImg;
    }

    public void setGamesetImg(final String gamesetImg) {
        this.gamesetImg = gamesetImg;
    }

    public Set<Group> getGroups() {
        return groups;
    }

    public void setGroups(final Set<Group> groups) {
        this.groups = groups;
    }

    public Boolean getHasBalance() {
        return hasBalance;
    }

    public void setHasBalance(final Boolean hasBalance) {
        this.hasBalance = hasBalance;
    }

    public List<Item> getItems() {
        return items;
    }

    public void setItems(final List<Item> items) {
        this.items = items;
    }

    public Map<String,Preset> getPresets() {
        return presets;
    }

    public void setPresets(final Map<String,Preset> presets) {
        this.presets = presets;
    }

    public String getSourcefile() {
        return sourcefile;
    }

    public void setSourcefile(final String sourcefile) {
        this.sourcefile = sourcefile;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(final String title) {
        this.title = title;
    }

    public Integer getToPlayers() {
        return toPlayers;
    }

    public void setToPlayers(final Integer toPlayers) {
        this.toPlayers = toPlayers;
    }

    @Override
    public boolean synchronize(final GameElements elem) {
        GameSet set=(GameSet)elem;
        this.backImg=set.backImg;
        this.fromPlayers=set.fromPlayers;
        this.toPlayers=set.toPlayers;
        this.gamesetImg=set.gamesetImg;
        this.hasBalance=set.hasBalance;
        this.title=set.title;
        //for(this.)
        return false;
    }

    /**
     * Creates an XML string from this gameset.
     *
     * @return the xml String
     */
    @Override
    public String toXML() {
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartDocument();
			writer.writeStartElement("gameset");
			writer.writeAttribute("gamesetid", this.gamesetid);
			writer.writeAttribute("language", this.language);
			writer.writeAttribute("title", this.title.toString());
			writer.writeAttribute("fromPlayers", this.fromPlayers.toString());
			writer.writeAttribute("toPlayers", this.toPlayers.toString());
			writer.writeAttribute("img", this.gamesetImg.toString());
			writer.writeAttribute("backimg", this.backImg.toString());
			writer.writeAttribute("balance", this.hasBalance.toString());
			for(Group group:this.groups){
				writer.writeCharacters(group.toXML());
			}
			for(Card card:this.cards){
				writer.writeCharacters(card.toXML());
			}
			for(Event event:this.events){
				writer.writeCharacters(event.toXML());
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
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}

	@Override
	public int compareTo(GameSet o) {
		return this.gamesetid.compareTo(o.gamesetid);
	}

}
