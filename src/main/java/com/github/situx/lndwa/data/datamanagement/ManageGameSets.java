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

import com.example.LNDWA.cards.GameElements;
import com.github.situx.lndwa.cards.GameSet;

import com.github.situx.lndwa.Utils.Tuple;
import com.github.situx.lndwa.data.Data;

public class ManageGameSets implements ManageGameElement {
	
	private Map<String,GameSet> gamesetUUIDToGameset;
	
	private Data data;
	
	private static ManageGameSets instance;
	
	private ManageGameSets(String contextpath){
		this.data=Data.getInstance(contextpath);
		this.gamesetUUIDToGameset=this.data.getGamesetUUIDToGameSet();

	}
	
	public static ManageGameSets getInstance(String contextpath){
		if(instance==null){
			instance=new ManageGameSets(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final GameElements gamesett){
		if(!(gamesett instanceof GameSet)){
			return false;
		}
		GameSet gameset=(GameSet)gamesett;
		System.out.println("Add GameSet");
		System.out.println("GameSetId: "+gameset.getGamesetid());
		System.out.println(this.gamesetUUIDToGameset.toString());
		if(!this.gamesetUUIDToGameset.containsKey(gameset.getGamesetid())){
			this.gamesetUUIDToGameset.put(gameset.getGamesetid(), gameset);
			if(!this.data.getLanguageToGameSetPath().containsKey(gameset.getLanguage())){
				this.data.getLanguageToGameSetPath().put(gameset.getLanguage(),new LinkedList<Tuple<String,GameSet>>());				
			}
			this.data.getLanguageToGameSetPath().get(gameset.getLanguage()).add(new Tuple<String,GameSet>(gameset.getGamesetid(),gameset));			
			System.out.println("GameSet added!");
			return true;
		}
		return false;
	}
	
	public GameSet get(final String gamesetid){
		return this.data.getGamesetUUIDToGameSet().get(gamesetid);
	}

	public List<GameSet> getAll(){
		return new LinkedList<GameSet>(this.data.getGamesetUUIDToGameSet().values());
	}
	
	public Boolean remove(final String gamesetid) {
		GameSet gameset=this.gamesetUUIDToGameset.get(gamesetid);
		this.data.getLanguageToGameSetPath().get(gameset.getLanguage()).remove(new Tuple<String,GameSet>(gameset.getGamesetid(),gameset));
		this.gamesetUUIDToGameset.remove(gamesetid);
		return true;
	}

	public Boolean update(final String gamesetid,final GameElements gamesett) {
		if(!(gamesett instanceof GameSet)){
			return false;
		}
		GameSet gameset=(GameSet)gamesett;
		if(this.gamesetUUIDToGameset.containsKey(gamesetid)){
			this.gamesetUUIDToGameset.get(gamesetid).synchronize(gameset);
			return true;
		}
		return false;
	}
	
	public void saveGameSet(final String gamesetid){
		this.data.saveGameSet(this.data.getGamesetUUIDToGameSet().get(gamesetid));
	}

}
