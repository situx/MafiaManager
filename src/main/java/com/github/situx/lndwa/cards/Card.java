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
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.UUID;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElementRef;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.google.gson.Gson;

/**
 * .*
 */
@XmlRootElement(name="Card")
public class Card implements Comparable<Card>, GameElements {

    /**
     * The list of abilities .*
     */
	@XmlElementRef
    protected transient Set<Ability> abblist;
	
	public Map<String,Action> getActionlist() {
		return actionlist;
	}

	public void setActionlist(Map<String,Action> actionlist) {
		this.actionlist = actionlist;
	}

	protected transient Map<String,Action> actionlist;
	
	private Map<String,Ability> uuidToAbility;
    /**
     * The name description players name group and image path of the character .*
     */
    @XmlAttribute
    private String name;
    @XmlAttribute
    private String description;
    
    private String spieler;
    
    private String image;
    
    private String cardid;
    
    private Group originalgroup,group;
    
    private Integer deathdelay;
    public Integer getDeathdelay() {
		return deathdelay;
	}

	public void setDeathdelay(Integer deathdelay) {
		this.deathdelay = deathdelay;
	}

	/**
     * The list of dependencies .*
     */
    private transient List<String> depends;
    /**
     * Indicators for the death, the love and the security of the character .*
     */
    @XmlAttribute
    private Boolean nopoints;
    @XmlAttribute
    private Boolean calleveryone;
    @XmlAttribute
    private Boolean deadchars;
    @XmlAttribute
    private Boolean winsalone;
    private Boolean dead, verzaubert, isprotected;
    /**
     * Indicators for the cardid, the love and the character's round .*
     */
    private Integer inlove;
    @XmlAttribute
    private Integer round;
    @XmlAttribute
    private Integer position;
    @XmlAttribute
    private Integer position2;
    @XmlAttribute
    private Integer minamount;
    @XmlAttribute
    private Integer maxamount;
    private Integer currentamount;
    @XmlAttribute
    private Integer extra;
    @XmlAttribute
    private Integer fixeddeath;
    @XmlAttribute
    private Integer winningalive;
    @XmlAttribute
    private Integer balancevalue;
    @XmlAttribute
    private Integer winningdead;

	private LinkedList<Object> secondarygroups;

	private Set<String> wakesupwith;

    /**
     * Constructor for Card.
     *
     * @param cardname the card's name*
     */
    public Card(final String cardname) {
        super();
        this.name = cardname;
        this.depends = new LinkedList<String>();
        this.abblist = new TreeSet<Ability>();
    }

    /**
     * constructor for a character.
     *
     * @param name        its name
     * @param cardid      indicates in which order the characters are called
     * @param abblist     the amount of its abilities
     * @param round       in which round they are called
     * @param group       its group
     * @param description its description
     * @param img         the image path
     * @param depends     the dependency list
     */
    public Card(final String name, final String cardid, final int round, final Group group,
                final String description, final Set<Ability> abblist, final List<String> depends,
                final String img, final int position, final int minamount, final int maxamount,
                final int position2, final int extra, final int fixeddeath, final boolean nopoints,
                final boolean calleveryone, final boolean deadchars, final boolean winsalone, final Integer winningalive,
                final Integer winningdead, final Integer balancevalue, final Integer deathdelay, final Map<String,Action> actionlist
                 , Set<String> wakesupwith) {
        super();
        this.name = name;
        this.dead = false;
        this.abblist = abblist;
        this.uuidToAbility=new TreeMap<>();
        for(Ability abb:abblist){
            this.uuidToAbility.put(abb.getAbilityId(),abb);
        }
        this.actionlist=actionlist;
        this.cardid = cardid;
        this.description = description;
        this.round = round;
        this.group = group;
        this.originalgroup = group;
        this.verzaubert = false;
        this.deathdelay=deathdelay;
        this.depends = depends;
        this.image = img;
        this.position = position;
        this.position2 = position2;
        this.extra = extra;
        this.fixeddeath = fixeddeath;
        this.nopoints = nopoints;
        this.calleveryone = calleveryone;
        this.isprotected = false;
        this.minamount = minamount;
        this.maxamount = maxamount;
        this.deadchars = deadchars;
        this.winsalone = winsalone;
        this.winningalive = winningalive;
        this.winningdead = winningdead;
        this.balancevalue = balancevalue;
        this.currentamount = minamount;
        if (this.abblist == null) {
            this.abblist = new TreeSet<>();
        }
        if (this.depends == null) {
            this.depends = new LinkedList<>();
        }
        if(this.secondarygroups==null){
            this.secondarygroups=new LinkedList<>();
        }
        this.wakesupwith=wakesupwith;

    }
    
    public Map<String, Ability> getUuidToAbility() {
		return uuidToAbility;
	}

	public void setUuidToAbility(Map<String, Ability> uuidToAbility) {
		this.uuidToAbility = uuidToAbility;
	}

	public Card(Card card){
        this.cardid=card.getCardid();
        this.abblist=new TreeSet<>();
        this.depends=new LinkedList<>();
        this.synchronize(card);
    }

    public Card() {
        this.name = "";
        this.dead = false;
        this.originalgroup = new Group();
        this.verzaubert = false;
        this.deathdelay=0;
        this.cardid = UUID.randomUUID().toString();
        this.description = "";
        this.round = 0;
        this.group = new Group();
        this.depends = new LinkedList<>();
        this.image = "";
        this.position = -1;
        this.position2 = -1;
        this.extra = 0;
        this.fixeddeath = 0;
        this.nopoints = false;
        this.calleveryone = false;
        this.isprotected = false;
        this.deadchars = false;
        this.minamount = 1;
        this.maxamount = 1;
        this.currentamount = minamount;
        this.deadchars = false;
        this.winsalone = false;
        this.winningalive = 2;
        this.winningdead = 1;
        this.balancevalue = 0;
        this.abblist = new TreeSet<>();
        this.depends = new LinkedList<>();
        this.secondarygroups = new LinkedList<>();
        this.uuidToAbility=new TreeMap<>();
        this.actionlist=new TreeMap<>();
        this.wakesupwith=new TreeSet<String>();
    }

    /**
     * Changes the group of a character if the game requires it.
     *
     * @param toGroup the group to change the character to
     */
    public void changeGroup(final Group toGroup) {
        this.group = toGroup;
    }

    @Override
    public int compareTo(final Card o) {
    	return this.cardid.compareTo(o.cardid);
    }

    /**
     * Kills the character.
     */
    public void dead() {
        this.dead = true;
    }


    /**
     * Removes a spell from the character.
     */
    public void entzaubern() {
        this.verzaubert = false;
    }

    @Override
    public boolean equals(final Object card) {
        if (card instanceof Card)
            return this.name.equals(((Card) card).name);
        else if (card instanceof String)
            return this.name.equals((String) card);
        return false;
    }

    public Integer getBalancevalue() {
        return balancevalue;
    }

    public void setBalancevalue(final Integer balancevalue) {
        this.balancevalue = balancevalue;
    }

    public Boolean getCalleveryone() {
        return calleveryone;
    }

    public void setCalleveryone(final Boolean calleveryone) {
        this.calleveryone = calleveryone;
    }

    /**
     * Gets the cardid of the character.
     *
     * @return the characters cardid
     */
    public String getCardid() {
        return this.cardid;
    }

    public Integer getCurrentamount() {
        return this.currentamount;
    }

    public void setCurrentamount(Integer currentamount) {
        this.currentamount = currentamount;
    }

    public Boolean getDeadchars() {
        return deadchars;
    }

    public void setDeadchars(final Boolean deadchars) {
        this.deadchars = deadchars;
    }

    /**
     * Gets the description of the character.
     *
     * @return the character description
     */
    public String getDescription() {
        return this.description;
    }

    /**
     * Sets the character's description.
     *
     * @param description the description*
     */
    public void setDescription(final String description) {
        this.description = description.replaceAll("\n", "<br/>");
    }

    public Integer getExtra() {
        return this.extra;
    }

    public void setExtra(final Integer extra) {

        this.extra = extra;
    }

    public Integer getFixeddeath() {
        return fixeddeath;
    }

    public void setFixeddeath(final Integer fixeddeath) {
        this.fixeddeath = fixeddeath;
    }

    /**
     * Gets the group of the character.
     *
     * @return the group string
     */
    public  Group getGroup() {
        return this.group;
    }

    /**
     * Sets the group of the character.
     *
     * @param group the group string*
     */

    public void setGroup(final Group group) {
        this.group = group;
    }

    /**
     * Gets the image path of the character.
     *
     * @return a String: the image path*
     */
    public String getImg() {
        return this.image;
    }

    /**
     * Sets the image path of the character.
     *
     * @param str the image path*
     */
    public void setImg(final String str) {
        this.image = str;
    }

    public Integer getMaxAmount() {
        return this.maxamount;
    }

    public Integer getMaxamount() {

        return maxamount;
    }

    public void setMaxamount(final Integer maxamount) {
        this.maxamount = maxamount;
    }

    public Integer getMinAmount() {
        return this.minamount;
    }

    public Integer getMinamount() {
        return minamount;
    }

    public void setMinamount(final Integer minamount) {
        this.minamount = minamount;
    }

    /**
     * Gets the name of the character.
     *
     * @return the characters name
     */
    public String getName() {
        return this.name;
    }

    /**
     * Sets the name of the character.
     *
     * @param named the name
     */
    public void setName(final String named) {
        this.name = named;
    }

    public Boolean getNopoints() {
        return nopoints;
    }

    public void setNopoints(final Boolean nopoints) {
        this.nopoints = nopoints;
    }

    public Integer getPosition() {
        return this.position;
    }

    public void setPosition(final Integer position) {

        this.position = position;
    }

    public Integer getPosition2() {
        return this.position2;
    }

    /**
     * .
     *
     * @return the round parameter*
     */
    public Integer getRound() {
        return this.round;
    }

    public void setRound(final Integer round) {
        this.round = round;
    }

    /**
     * Gets the status of the character.
     *
     * @return a string containing status information*
     */
    public String getStatus() {
        int i = 1;
        final StringBuffer buf = new StringBuffer(256);
        if (this.verzaubert)
            buf.append("Ist verzaubert<br>");
        if (this.abblist.size() > 0)
            buf.append("Fähigkeiten:<br>");
        for (Ability ability : this.abblist) {
            if (ability.isAktiv()) {
                buf.append("F" + i++ + " " + ability + " verfügbar<br>");
            } else {
                buf.append("F" + i++ + " " + ability + " nicht verfügbar<br>");
            }
        }
        return buf.toString();
    }

    public Integer getWinningAlive() {
        return winningalive;
    }

    public void setWinningAlive(final Integer winningalive) {
        this.winningalive = winningalive;
    }

    public Integer getWinningDead() {
        return winningdead;
    }

    public void setWinningDead(final Integer winningdead) {
        this.winningdead = winningdead;
    }

    public Boolean getWinsalone() {
        return winsalone;
    }

    public void setWinsalone(final Boolean winsalone) {
        this.winsalone = winsalone;
    }

    /**
     * Gets the list of abilities for this character.
     *
     * @return the list of abilities*
     */
    public Set<Ability> getabblist() {
        return this.abblist;
    }

    /**
     * Gets the dependencies of this character.
     *
     * @return a list of the dependency characters*
     */
    public List<String> getdepends() {
        return this.depends;
    }

    /**
     * Gets the partner of the character if he is in love.
     *
     * @return the partners number*
     */
    public Integer getverliebt() {
        return this.inlove;
    }

    /**
     * Checks if an image path already exists.
     *
     * @return true or false*
     */
    public Boolean imgexists() {
        if (!" ".equals(this.image))
            return true;
        return false;
    }

    /**
     * Indicates if a character is in love.
     *
     * @return true or false*
     */
    public Boolean isInLove() {
        return this.inlove != -1;
    }

    /**
     * Indicates if the character is already dead.
     *
     * @return true or false
     */
    public Boolean isdead() {

        return this.dead;
    }

    public Boolean isprotected() {
        return this.isprotected;
    }

    /**
     * Indicates if a character is enchanted.
     *
     * @return true or false
     */
    public Boolean isverzaubert() {
        return this.verzaubert;
    }

    /**
     * Resets the character to the state as it was build.
     */
    public void reset() {
        for (Ability f : this.abblist)
            f.reset();
        this.inlove = -1;
        this.verzaubert = false;
        this.isprotected = false;
        this.dead = false;
        this.spieler = null;
        this.group = this.originalgroup;
        this.currentamount = minamount;
    }

    /**
     * Sets the character's protected state.
     *
     * @param isprotected indicates if the character is protected.*
     */
    public void setProtected(final boolean isprotected) {
        this.isprotected = isprotected;
    }

    /**
     * Sets the death indicator of the character.
     *
     * @param death the new state of life.*
     */
    public void setdead(final boolean death) {
        this.dead = death;
    }

    /**
     * Sets the partner of the character if he is in love.
     *
     * @param love the loving character's number.*
     */
    public void setverliebt(final int love) {
        this.inlove = love;
    }

    @Override
    public String toString() {
        return this.name;
    }

    /**
     * Synchronises this card with another card.
     * @param cardi the card to synchronize
     */
    @Override
    public boolean synchronize(final GameElements cardi){
          Card card=(Card)cardi;
          if(!card.getCardid().equals(cardid)){
              return false;
          }else{
              for(Ability abb:this.abblist){
                  abb.synchronize(card.getUuidToAbility().get(abb.getAbilityId()));
              }
              this.balancevalue=card.balancevalue;
              this.minamount=card.minamount;
              this.maxamount=card.maxamount;
              this.calleveryone=card.calleveryone;
              this.name=card.name;
              this.description=card.description;
              this.extra=card.extra;
              this.fixeddeath=card.fixeddeath;
              this.group=card.group;
              this.nopoints=card.nopoints;
              this.image=card.image;
              this.originalgroup=card.originalgroup;
              this.position=card.position;
              this.position2=card.position2;
              this.round=card.round;
              this.winningdead=card.winningdead;
              this.winningalive=card.winningalive;
              this.winsalone=card.winsalone;
              return true;
          }
    }

    public void setCardid(String cardid) {
		this.cardid = cardid;
	}

	@Override
    public String toXML() {
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartElement("Card");
			writer.writeAttribute("cardid", this.cardid);
			writer.writeAttribute("name", this.name);
			writer.writeAttribute("group", this.group.getGroupIdentifier());
			writer.writeAttribute("round", this.round.toString());
			writer.writeAttribute("img", this.image);
			writer.writeAttribute("minamount", this.minamount.toString());
			writer.writeAttribute("maxamount",this.maxamount.toString());
			writer.writeAttribute("position", this.position.toString());
			writer.writeAttribute("position2", this.position2.toString());
			writer.writeAttribute("extra", this.extra.toString());
			writer.writeAttribute("fixeddeath", this.fixeddeath.toString());
			writer.writeAttribute("nopoints", this.nopoints.toString());
			writer.writeAttribute("calleveryone", this.calleveryone.toString());
			writer.writeAttribute("winsalone",this.winsalone.toString());
			writer.writeAttribute("winningalive",this.winningalive.toString());
			writer.writeAttribute("balance",this.balancevalue.toString());
			writer.flush();
			for(String dep:this.depends){
				writer.writeStartElement("depends");
				writer.writeAttribute("A", dep);
				writer.writeEndElement();
			}
			for(Ability ability:this.abblist){
				writer.writeCharacters(ability.toXML());
			}
			int i=0;
            if(!this.actionlist.isEmpty()){
                writer.writeStartElement("","actions");
            }
            for(Action action:this.actionlist.values()){
                writer.writeStartElement("","action");
                writer.writeAttribute("", "id", i++ + "");
                writer.writeAttribute("","round",action.getRound().toString());
                writer.writeAttribute("","position",action.getPosition().toString());
                writer.writeStartElement("", "gamemaster");
                writer.writeCharacters(action.getGamemaster());
                writer.writeEndElement();
                writer.writeStartElement("","player");
                writer.writeCharacters(action.getPlayer());
                writer.writeEndElement();
                writer.writeEndElement();
             }
            if(!this.actionlist.isEmpty()){
                writer.writeEndElement();
            }
			writer.writeStartElement("description");
			writer.writeCharacters(this.description);
			writer.writeEndElement();
			writer.writeEndElement();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			e.printStackTrace();
		}
		System.out.println(strwriter.toString());
		return strwriter.toString();        
    }

    /**
     * Puts a spell on the character.
     */
    public void verzaubern() {
        this.verzaubert = true;
    }

	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}

    

}
