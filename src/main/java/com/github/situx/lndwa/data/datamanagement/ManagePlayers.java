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

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import com.github.situx.lndwa.cards.GameElements;
import com.github.situx.lndwa.cards.Player;

import com.github.situx.lndwa.data.Data;

public class ManagePlayers  implements ManageGameElement{
	private final Data data;
	
	private final Map<String,Player> playerUUIDToPlayer;
	
	private Set<Player> playerlist;
	
	private static ManagePlayers instance;
	
	private  ManagePlayers(String contextpath){
		this.data=Data.getInstance(contextpath);
		this.playerUUIDToPlayer=data.getPlayeruuidToPlayer();
		this.playerlist=new TreeSet<>();
	}
	
	public static ManagePlayers getInstance(String contextpath){
		if(instance==null){
			instance=new ManagePlayers(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final GameElements play) {
		if(!(play instanceof Player)){
			return false;
		}
		Player player=(Player)play;
		System.out.println(this.playerUUIDToPlayer.toString());
		if(!this.playerUUIDToPlayer.containsKey(player.getPlayerid())){
			this.playerUUIDToPlayer.put(player.getPlayerid(),player);
			System.out.println("Add player yeah");
			return true;
		}
		System.out.println("Already added yeah!");
		return true;
	}
	
	public Player get(final String playerid){
		return this.playerUUIDToPlayer.get(playerid);
	}
	
	public List<Player> getAll(){
		this.playerlist.clear();
		for(Player player:this.playerUUIDToPlayer.values()){
			this.playerlist.add(player);
		}
		return new LinkedList<>(this.playerlist);
	}

	public Boolean remove(String playeruuid) {
		this.playerUUIDToPlayer.remove(playeruuid);
		return true;
	}

	public Boolean update(String playeruuid,GameElements player) {
		System.out.println("Update Player");
		if(this.playerUUIDToPlayer.containsKey(playeruuid)){
			System.out.println("Contains Player");
			this.playerUUIDToPlayer.get(playeruuid).synchronize(player);
			return true;
		}
		return false;

	}

}
