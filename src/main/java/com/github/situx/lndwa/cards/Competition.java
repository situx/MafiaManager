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

import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import com.google.gson.Gson;

import com.github.situx.lndwa.data.GameResult;
import com.github.situx.lndwa.data.User;

public class Competition implements GameElements {
	private Set<GameSet> allowedgamesets;
	private Boolean finished;
	private Set<GameResult> games;
	private Set<String> music;
	private String name,competitionid,description,location,competition,image;
	private User organiser;
	private Set<Player> players;
	private Date registerdeadline;
	private Date start,end;
	public Competition(){
		this.finished=false;
		this.games=new TreeSet<GameResult>();
	}
	public Set<GameSet> getAllowedgamesets() {
		return allowedgamesets;
	}
	public String getCompetition() {
		return competition;
	}
	public String getCompetitionid() {
		return competitionid;
	}
	public String getDescription() {
		return description;
	}
	public Date getEnd() {
		return end;
	}
	public Boolean getFinished() {
		return finished;
	}
	public Set<GameResult> getGames() {
		return games;
	}
	public String getImg() {
		return image;
	}
	public String getLocation() {
		return location;
	}
	public Set<String> getMusic() {
		return music;
	}
	public String getName() {
		return name;
	}
	public User getOrganiser() {
		return organiser;
	}
	public Set<Player> getPlayers() {
		return players;
	}
	public Map<Player,Integer> getRanking(){
		Map<Player,Integer> result=new TreeMap<Player,Integer>();
		for(GameResult gameres:this.games){
			for(Game game:gameres.getGame()){
				System.out.println("Player: "+game.getGameid());
				if(!result.containsKey(game.getGameid())){
					result.put(game.getPlayer(),0);
				}
				result.put(game.getPlayer(),result.get(game.getPlayer())+game.getPoints());
			}
		}
		return result;
	}
	public Date getRegisterdeadline() {
		return registerdeadline;
	}
	public Date getStart() {
		return start;
	}
	
	public void setAllowedgamesets(Set<GameSet> allowedgamesets) {
		this.allowedgamesets = allowedgamesets;
	}
	public void setCompetition(String competition) {
		this.competition = competition;
	}
	public void setCompetitionid(String competitionid) {
		this.competitionid = competitionid;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public void setEnd(Date end) {
		this.end = end;
	}
	public void setFinished(Boolean finished) {
		this.finished = finished;
	}
	public void setGames(Set<GameResult> games) {
		this.games = games;
	}
	public void setImg(String image) {
		this.image = image;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public void setMusic(Set<String> music) {
		this.music = music;
	}
	public void setName(String name) {
		this.name = name;
	}

	public void setOrganiser(User organiser) {
		this.organiser = organiser;
	}
	public void setPlayers(Set<Player> players) {
		this.players = players;
	}
	public void setRegisterdeadline(Date registerdeadline) {
		this.registerdeadline = registerdeadline;
	}
	public void setStart(Date start) {
		this.start = start;
	}
	@Override
	public boolean synchronize(GameElements elem) {
		// TODO Auto-generated method stub
		return false;
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
