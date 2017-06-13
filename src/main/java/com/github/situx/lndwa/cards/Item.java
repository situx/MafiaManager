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

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;


/**
 * Created by timo on 18.01.14.
 */
@XmlRootElement(name="item")
public class Item{

    private String description;
	@XmlAttribute
    private Integer id;
	@XmlAttribute
    private String image;
	@XmlAttribute
    private String name;
	@XmlAttribute
    private Integer probability;
	@XmlAttribute
    private Integer round;

    public Integer getRound() {
        return round;
    }

    public void setRound(final Integer round) {
        this.round = round;
    }

    public Integer getProbability() {
        return probability;
    }

    public Boolean imgexists() {
        if (this.image != null)
            return true;
        return false;
    }

    public void setProbability(final Integer probability) {
        this.probability = probability;
    }

    public Integer getValid() {
        return valid;
    }

    public void setValid(final Integer valid) {
        this.valid = valid;
    }

    private Integer valid;

    public String getDescription() {
        return description;
    }

    public void setDescription(final String description) {
        this.description = description;
    }

    public Integer getId() {
        return id;
    }

    public void setId(final Integer id) {
        this.id = id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(final String image) {
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public void setName(final String name) {
        this.name = name;
    }

    public Item() {

    }

}
