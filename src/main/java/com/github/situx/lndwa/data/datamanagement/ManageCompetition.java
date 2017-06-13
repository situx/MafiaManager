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
package com.github.situx.lndwa.data.datamanagement;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.TreeSet;

import com.example.LNDWA.cards.Competition;
import com.example.LNDWA.cards.GameElements;

import com.github.situx.lndwa.data.Data;

public class ManageCompetition implements ManageGameElement {
private final Data data;
	
	private static ManageCompetition instance;
	
	private ManageCompetition(String contextpath){
		this.data=Data.getInstance(contextpath);
	}
	
	public static ManageCompetition getInstance(String contextpath){
		if(instance==null){
			instance=new ManageCompetition(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final String competitionid,final Competition competition){
		if(!this.data.getCompetitions().containsKey(competitionid)){
			this.data.getCompetitions().put(competitionid,competition);
			return true;
		}
		return false;

	}
	
	public Competition get(final String competitionid){
		return this.data.getCompetitions().get(competitionid);
	}
	
	public List<Competition> getAll(){
		Competition comp=new Competition();
		comp.setCompetitionid("123");
		comp.setDescription("Lange Nacht der Wölfe");
		comp.setStart(new Date(System.currentTimeMillis()));
		comp.setEnd(new Date(System.currentTimeMillis()));
		comp.setName("LNDW");
		comp.setLocation("Gelnhausen");
		comp.setRegisterdeadline(new Date(System.currentTimeMillis()));
		comp.setFinished(false);
		comp.setMusic(new TreeSet<String>());
		comp.setGames(Data.getInstance("").getGameresults());
		//comp.setPlayers(new TreeSet<Player>());
		List<Competition> comps= new LinkedList<>();
		comps.add(comp);
		this.data.getCompetitions().put("123", comp);
		return comps;
	}

	public Boolean remove(final String competitionid) {
		this.data.getCompetitions().remove(competitionid);
		return true;
	}

	/**
	 * Updates a currently existing ability with another version of this ability.
	 * @param characterid the character id
	 * @param gamesetid the gameset id
	 * @param abilityid the abilty id
	 * @param card the card id
	 */
	public String update(final String competitionid,final Competition competition){
		if(!this.data.getCompetitions().containsKey(competitionid)){
			this.data.getCompetitions().put(competitionid,competition);
			return "";
		}
		return "error";
	}

	@Override
	public Boolean add(GameElements elem) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Boolean update(String id, GameElements element) {
		// TODO Auto-generated method stub
		return null;
	}
}
