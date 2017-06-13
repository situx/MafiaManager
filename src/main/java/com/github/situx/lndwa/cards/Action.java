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

import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;

import com.google.gson.Gson;

public class Action implements Comparable<Action>,GameElements{
	@XmlElement
	private String gamemaster="";
	@XmlAttribute
	private String id="0";


	@XmlAttribute
	private Boolean ondead=false;
	@XmlElement
	private String player="";
	@XmlAttribute
	private Integer position=0;
	@XmlAttribute
	private Integer round=0;
	@XmlAttribute
	private Boolean self;
	@XmlElement
	private String title="";
	private List<String> wakesupwith=new LinkedList<>();
	public Action(){
		
	}
	
	@Override
	public int compareTo(Action o) {
		return this.position.compareTo(o.position);
	}
	
	@Override
	public boolean equals(Object obj) {
		return obj instanceof Action && this.id.equals(((Action)obj).id);
	}


	public String getGamemaster() {
		return gamemaster;
	}


	public String getId() {
		return id;
	}


	public Boolean getOndead() {
		return ondead;
	}


	public String getPlayer() {
		return player;
	}


	public Integer getPosition() {
		return position;
	}


	public Integer getRound() {
		return round;
	}
	
	
	public String getTitle() {
		return title;
	}
	public List<String> getWakesupwith() {
		return wakesupwith;
	}
	public void setActionid(String id) {
		this.id = id;
		
	}
	public void setGamemaster(String gamemaster) {
		this.gamemaster = gamemaster;
	}
	public void setOndead(Boolean ondead) {
		this.ondead = ondead;
	}
	public void setPlayer(String player) {
		this.player = player;
	}
	public void setPosition(Integer position) {
		this.position = position;
	}


	public void setRound(Integer round) {
		this.round = round;
	}

	public void setTitle(String title) {
		this.title = title;
	}


	public void setWakesupwith(List<String> wakesupwith) {
		this.wakesupwith = wakesupwith;
	}


	@Override
	public boolean synchronize(GameElements elem) {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
	public String toString() {
		return this.title+" "+this.id;
	}


	@Override
	public String toXML() {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public String toJSON() {
		Gson gson=new Gson();
		return gson.toJson(this);
	}
	
	
	
}
