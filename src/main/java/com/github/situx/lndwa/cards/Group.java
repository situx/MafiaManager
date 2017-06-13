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
import java.util.Set;
import java.util.UUID;

import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.google.gson.Gson;

/**
 * Created by timo on 21.03.14.
 */
public class Group implements GameElements, Comparable<Group> {
    /**
     * Icon of this group.
     */
    private String groupIcon;
    /**
     * Unique identifier of this group.
     */
    private String groupId;
    /**
     * Short identifier of this group.
     */
    private String groupIdentifier;
    /**
     * Description of this group.
     */
    private String groupdescription;
    /**
     * The name of this group.
     */
    private String groupname;
    private Set<String> winsTogetherWith;
    /**
     * Indicates if this group can win the game.
     */
    private Boolean winsgame;

    private Boolean dietogether;

    /**
     * Constructor for this class.
     *
     * @param groupname
     * @param winsgame
     * @param groupdescription
     * @param groupIcon
     * @param groupIdentifier
     */
    public Group(final String groupname, final Boolean winsgame,final Boolean dietogether, final String groupdescription, final String groupIcon, final String groupIdentifier) {
        this.groupname = groupname;
        this.winsgame = winsgame;
        this.dietogether=dietogether;
        this.groupdescription = groupdescription;
        this.groupIcon = groupIcon;
        this.groupIdentifier = groupIdentifier;
    }

    public Group(){
        this.groupname="";
        this.groupIcon=" ";
        this.groupdescription="";
        this.groupIdentifier="";
        this.dietogether=false;
        this.winsgame=false;
        this.groupId= UUID.randomUUID().toString();
    }
    public Group(final String name){
        this.groupname=name;
        this.groupIcon="";
        this.groupdescription="";
        this.groupIdentifier="";
        this.winsgame=false;
        this.dietogether=false;
        this.groupId= UUID.randomUUID().toString();
    }

    public Boolean imgexists() {
        if (!" ".equals(this.groupIcon))
            return true;
        return false;
    }

    @Override
    public int compareTo(final Group group) {
        return this.groupIdentifier.compareTo(group.groupIdentifier);
    }

    public String getGroupIcon() {
        return groupIcon;
    }

    public void setGroupIcon(final String groupIcon) {
        this.groupIcon = groupIcon;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(final String groupId) {
        this.groupId = groupId;
    }

    public String getGroupIdentifier() {
        return groupIdentifier;
    }

    public void setGroupIdentifier(final String groupIdentifier) {
        this.groupIdentifier = groupIdentifier;
    }

    public String getGroupdescription() {
        return groupdescription;
    }

    public void setGroupdescription(final String groupdescription) {
        this.groupdescription = groupdescription;
    }

    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(final String groupname) {
        this.groupname = groupname;
    }

    public Set<String> getWinsTogetherWith() {
        return winsTogetherWith;
    }

    public void setWinsTogetherWith(final Set<String> winsTogetherWith) {
        this.winsTogetherWith = winsTogetherWith;
    }

    //TODO Define winning conditions for groups? Is this possible in XML?

    public Boolean getWinsgame() {
        return winsgame;
    }

    public void setWinsgame(final Boolean winsgame) {
        this.winsgame = winsgame;
    }

    @Override
    public boolean synchronize(final GameElements elem) {
        return false;
    }

    public Boolean getDietogether() {
        return dietogether;
    }

    public void setDietogether(Boolean dietogether) {
        this.dietogether = dietogether;
    }

	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}
    
    @Override
    public String toXML() {
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartElement("gameset");
			writer.writeAttribute("gid", this.groupIdentifier.toString());
			writer.writeAttribute("name", this.groupname.toString());
			writer.writeAttribute("id", this.groupId.toString());
			writer.writeAttribute("icon", this.groupIcon.toString());
			writer.writeAttribute("canwin", this.winsgame.toString());
            writer.writeAttribute("dietogether",this.dietogether.toString());
			writer.writeStartElement("description");
			writer.writeCharacters(this.groupdescription);
			writer.writeEndDocument();
			writer.writeEndElement();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(strwriter.toString());
		return strwriter.toString();
    }


    @Override
    public String toString() {
        return groupIdentifier;
    }

    @Override
    public boolean equals(final Object o) {
        if(o instanceof Group){
            return this.groupId.equals(((Group)o).groupId);
        }
        return false;
    }
}
