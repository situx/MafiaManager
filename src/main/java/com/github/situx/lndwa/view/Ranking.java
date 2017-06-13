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
package com.github.situx.lndwa.view;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import com.github.situx.lndwa.cards.Game;
import com.github.situx.lndwa.cards.Player;

import com.github.situx.lndwa.data.Data;

public class Ranking {
	/**Parses a player xml file.*/
	private Set<Player> playerList;
	/**The map of player uuid to player classes.*/
	private Map<String,Player> uuidToPlayer;
	/**Constructor for this class.*/
	public Ranking(String contextpath){
		Data data=Data.getInstance(contextpath);
		this.uuidToPlayer=data.getPlayeruuidToPlayer();
		this.playerList=new TreeSet<>();

	}
	
	public List<Player> getPlayerMap(){
		this.playerList.clear();
		for(Player player:this.uuidToPlayer.values()){
			this.playerList.add(player);
		}
		return new LinkedList<Player>(this.playerList);
	}
	
	public Map<String,Player> getUUIDToPlayer(){
		return this.uuidToPlayer;
	}
	
	public void addGame(Game game){
		
	}
	
	public void addPlayer(Player player){
		
	}

	
}
