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
 * Abstract class for implementing abilities.*
 */
@XmlRootElement(name="ability")
public class Ability implements  GameElements,Comparable<Ability> {
    /**
     * .*
     */
    public Integer fk;
    /**
     * .*
     */
    @XmlAttribute
    private Boolean active;
    /**
     * The description of this ability.*
     */
    @javax.xml.bind.annotation.XmlElement
    private String description;
    
    private Operator check;
    public Operator getCheck() {
		return check;
	}

	public void setCheck(Operator check) {
		this.check = check;
	}

	@XmlAttribute
    private Integer delay;
    public Integer getDelay() {
		return delay;
	}

	public void setDelay(Integer delay) {
		this.delay = delay;
	}

	/**
     * .*
     */
    private Integer originalamount;
    /**
     * Describes from which round this ability is available.
     */
    @XmlAttribute
    private Integer availableFrom;
    /**
     * Describes until which round this ability is available.
     */
    @XmlAttribute
    private Integer availableUntil;
    /**
     * Describes the probability of this ability to succeed.
     */
    @XmlAttribute
    private Integer probability;
    /**
     * Describes if the player has to use the ability if it is available.
     */
    @XmlAttribute
    private Boolean mustuse;
    /**Indicates if this ability forces a player to leave the game.*/
    @XmlAttribute
    private Boolean killing;
    /**The id of this ability.*/
    @XmlAttribute
    private String abilityId;
    @XmlAttribute
    private Boolean self;
    @XmlAttribute
    private Boolean everyround;
    /**
     * The image path of this ability.
     */
    @XmlAttribute
    private String image;
    /**
     * The amount of players which are concerned by using this ability.
     */
    @XmlAttribute
    private Integer concerns;
    /**
     * The duration of this ability.
     */
    @XmlAttribute
    private Integer duration;
    @XmlAttribute
    private Boolean counterKilling;
    @XmlAttribute
    private Boolean switchchar;
    @XmlAttribute
    private Boolean ondead;
    public Boolean getOndead() {
		return ondead;
	}

	public void setOndead(Boolean ondead) {
		this.ondead = ondead;
	}

	@XmlAttribute
    private String switchnewchar;
	@XmlAttribute
	private List<Group> changeGroup;
	private int currentamount;
	@XmlAttribute
	private Boolean alwaysChooseOther;
    
    public Boolean getKilling() {
        return killing;
    }

    public Boolean getCounterKilling() {
        return counterKilling;
    }

    public void setKilling(final Boolean killing) {
        this.killing = killing;
    }

    /**
     * Constructor for a new ability.
     *
     * @param description .
     * @param active      .
     * @param fkl         .*
     */
    public Ability(final String description, final boolean active, final int fkl,
                   final Integer availableFrom, final Integer availableUntil, final Integer probability,
                   final String image, final Integer concerns, Boolean mustuseability,
                   final Integer duration, final String abilityId, final Boolean killing, final Boolean counterKilling,
                   final Boolean self, final Boolean everyRound, final List<Group> changeGroup, final Boolean switchchar,
                   final String switchnewchar,final Integer delay,final Boolean alwaysChooseOther,final Boolean ondead,
                   final Operator check) {
        super();
        this.description = description;
        this.active = active;
        this.killing = killing;
        this.delay=delay;
        this.counterKilling = counterKilling;
        this.currentamount = fkl;
        this.originalamount = fkl;
        this.availableFrom = availableFrom;
        this.availableUntil = availableUntil;
        this.probability = probability;
        this.image = image;
        this.concerns = concerns;
        this.mustuse = mustuseability;
        this.duration = duration;
        this.abilityId = abilityId;
        this.self = self;
        this.everyround = everyRound;
        this.changeGroup = changeGroup;
        this.switchchar = switchchar;
        this.switchnewchar = switchnewchar;
        this.alwaysChooseOther=alwaysChooseOther;
        this.ondead=ondead;
        this.check=check;
    }

    /**
     * Empty constructor for ability using default values.
     */
    public Ability() {
        super();
        this.description = "";
        this.active = false;
        this.killing = false;
        this.counterKilling = false;
        this.currentamount = 0;
        this.originalamount = 0;
        this.availableFrom = 0;
        this.availableUntil = -1;
        this.probability = 100;
        this.image = "";
        this.delay=0;
        this.concerns = 0;
        this.mustuse = false;
        this.duration = 1;
        this.abilityId = UUID.randomUUID().toString();
        this.self = false;
        this.changeGroup = new LinkedList<>();
        this.switchchar = false;
        this.switchnewchar = "-1";
        this.everyround=false;
        this.alwaysChooseOther=false;
        this.ondead=false;
        this.check=new Operator();
    }

    public Boolean checkFromUntil(final Integer round) {
        if (round >= availableFrom && (round <= availableUntil || availableUntil == -1)) {
            return true;
        }
        return false;
    }

    /**
     * Gets the ability id of this ability.
     *
     * @return the ability id as Integer
     */
    public String getAbilityId() {
        return abilityId;
    }

    public void setSelf(Boolean self) {
		this.self = self;
	}

	public void setEveryround(Boolean everyround) {
		this.everyround = everyround;
	}

	public void setCounterKilling(Boolean counterKilling) {
		this.counterKilling = counterKilling;
	}

	public void setSwitchchar(Boolean switchchar) {
		this.switchchar = switchchar;
	}

	public void setSwitchnewchar(String switchnewchar) {
		this.switchnewchar = switchnewchar;
	}

	public List<Group> getChangeGroup() {
		return changeGroup;
	}

	public void setChangeGroup(List<Group> changeGroup) {
		this.changeGroup = changeGroup;
	}

	public Boolean getMustuse() {
		return mustuse;
	}

	public Boolean getSelf() {
		return self;
	}

	public Boolean getEveryround() {
		return everyround;
	}

	public Boolean getSwitchchar() {
		return switchchar;
	}

	public String getSwitchnewchar() {
		return switchnewchar;
	}

	/**
     * Sets the id of this ability.
     *
     * @param abilityId the ability id as Integer
     */
    public void setAbilityId(final String abilityId) {
        this.abilityId = abilityId;
    }

    public Boolean getActive() {
        return this.active;
    }

    /**
     * @param active the active to set
     */
    public void setActive(final boolean active) {
        this.active = active;
    }

    public Integer getAvailableFrom() {
        return availableFrom;
    }

    public void setAvailableFrom(final Integer availableFrom) {
        this.availableFrom = availableFrom;
    }

    public Integer getAvailableUntil() {
        return availableUntil;
    }

    public void setAvailableUntil(final Integer availableUntil) {
        this.availableUntil = availableUntil;
    }

    /**
     * Gets the ammount of players concerned by using this ability.
     *
     * @return the amount as Integer
     */
    public Integer getConcerns() {
        return concerns;
    }

    /**
     * Sets the amount of players concerned by using this ability
     *
     * @param concerns the amount of players as Integer
     */
    public void setConcerns(final Integer concerns) {
        this.concerns = concerns;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(final String description) {
        this.description = description;
    }

    /**
     * Gets the duration of this ability.
     *
     * @return -1 if permanent, >0 for the number of rounds
     */
    public Integer getDuration() {
        return duration;
    }

    /**
     * Sets the duration of this ability
     *
     * @param duration -1 for permanent, >0 for the number of rounds.
     */
    public void setDuration(final Integer duration) {
        this.duration = duration;
    }

    public int getFks() {
        return originalamount;
    }

    public void setFks(final int fks) {
        this.originalamount = fks;
    }

    /**
     * Gets the image path of this ability.
     *
     * @return the image path as String
     */
    public String getImage() {
        return image;
    }

    /**
     * Sets the image path of this ability.
     *
     * @param image the image path as String
     */
    public void setImage(final String image) {
        this.image = image;
    }

    /**
     * Gets the indication if this ability has to be used on availability.
     *
     * @return the indication as Boolean
     */
    public Boolean getMustuseability() {
        return mustuse;
    }

    public void setMustuseability(final Boolean mustuseability) {
        this.mustuse = mustuseability;
    }

    public Integer getProbability() {
        return probability;
    }

    public void setProbability(final Integer probability) {
        this.probability = probability;
    }

    /**
     * Returns the ability.
     *
     * @return fks*
     */
    public Integer getfks() {
        return this.originalamount;
    }

    /**
     * @return the active
     */
    public Boolean isAktiv() {
        return this.active;
    }

    /**
     * Resets the ability to the default values.*
     */
    public void reset() {
        this.fk = this.originalamount;
        this.setActive(true);
    }

    /**
     * Sets the active parameter of the character.
     *
     * @param act the new value of active*
     */
    public void setaktiv(final Boolean act) {
        this.setActive(act);
    }

    @Override
    public String toString() {
        return this.description;
    }

    /**
     * Creates a String representation of the current class as XML.
     *
     * @return the XML String
     */
    @Override
    public String toXML() {
		StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartDocument();
			writer.writeStartElement("abb");
			writer.writeAttribute("abilityid", this.abilityId);
			writer.writeAttribute("active", this.active.toString());
			writer.writeAttribute("amount", this.originalamount.toString());
			writer.writeAttribute("availablefrom", this.availableFrom.toString());
			writer.writeAttribute("availableuntil", this.availableUntil.toString());
			writer.writeAttribute("probability", this.probability.toString());
			writer.writeAttribute("img", this.image.toString());
			writer.writeAttribute("concerns", this.concerns.toString());
			writer.writeAttribute("mustuse", this.mustuse.toString());
			writer.writeAttribute("duration", this.duration.toString());
			writer.writeAttribute("killing", this.killing.toString());
			writer.writeAttribute("counterkilling", this.counterKilling.toString());
			writer.writeAttribute("everyround",this.everyround.toString());
			writer.writeAttribute("self", this.self.toString());
            writer.writeAttribute("changegroup", this.changeGroup.toString());
            writer.writeAttribute("switchchar", this.switchchar.toString());
            writer.writeAttribute("delay", this.delay.toString());
            writer.writeAttribute("alwayschooseother",this.alwaysChooseOther.toString());
            writer.writeAttribute("ondead",this.ondead.toString());
            writer.writeAttribute("check",this.check.toString());
			writer.flush();
			writer.writeCharacters("\n");
			writer.writeCharacters(this.description);
			writer.writeEndElement();
			writer.writeEndDocument();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(strwriter.toString());
		return strwriter.toString();
    }


	public Boolean getAlwaysChooseOther() {
		return alwaysChooseOther;
	}

	public void setAlwaysChooseOther(Boolean alwaysChooseOther) {
		this.alwaysChooseOther = alwaysChooseOther;
	}

	@Override
	public boolean synchronize(GameElements elem) {
		Ability ability=(Ability) elem;
		this.active=ability.active;
		this.availableFrom=ability.availableFrom;
		this.availableUntil=ability.availableUntil;
		this.changeGroup=ability.changeGroup;
		this.concerns=ability.concerns;
		this.counterKilling=ability.counterKilling;
		this.currentamount=ability.currentamount;
		this.description=ability.description;
		this.duration=ability.duration;
		this.delay=ability.delay;
		this.everyround=ability.everyround;
		this.image=ability.image;
		this.killing=ability.killing;
		this.mustuse=ability.mustuse;
		this.originalamount=ability.originalamount;
		this.probability=ability.probability;
		this.self=ability.self;
		this.switchchar=ability.switchchar;
		this.switchnewchar=ability.switchnewchar;
		this.ondead=ability.ondead;
		this.check=ability.check;
		return true;
	}
	
	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}

	@Override
	public int compareTo(Ability abb) {
		return this.description.compareTo(abb.description);
	}
	
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof Ability)
			return this.abilityId.equals(((Ability)obj).abilityId);
		return false;
	}
}
