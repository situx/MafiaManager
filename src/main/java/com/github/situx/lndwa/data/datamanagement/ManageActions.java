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

import java.util.Map;
import com.example.LNDWA.cards.Action;
import com.github.situx.lndwa.cards.Card;
import com.github.situx.lndwa.cards.GameSet;

import com.github.situx.lndwa.data.Data;

public class ManageActions {

	private final Data data;
	
	private static ManageActions instance;
	
	
	private final Map<String,GameSet> gamesetUUIDtoGameSet;
	
	private ManageActions(String contextpath){
		this.data=Data.getInstance(contextpath);
		this.gamesetUUIDtoGameSet=this.data.getGamesetUUIDToGameSet();
	}
	
	public static ManageActions getInstance(String contextpath){
		if(instance==null){
			instance=new ManageActions(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final String gamesetid,final String cardid,final Action action){
		GameSet gameset=this.gamesetUUIDtoGameSet.get(gamesetid);
		if(gameset!=null && gameset.getUuidToCard().containsKey(cardid)){
			Card card=this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid);
			card.getActionlist().put(action.getId().toString(),action);
			return true;
		}
		return false;
	}
	
	public Action get(final String gamesetid,final String cardid,final String actionid){
		return this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid)
				.getActionlist().get(actionid);
	}
	
	public Boolean remove(final String gamesetid,final String characterid,final String actionid) {
		Card card=this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(characterid);
		card.getActionlist().remove(actionid);
		return true;
	}

	/**
	 * Updates a currently existing ability with another version of this ability.
	 * @param characterid the character id
	 * @param gamesetid the gameset id
	 * @param actionid the abilty id
	 * @param card the card id
	 */
	public String update(final String gamesetid,final String cardid,final String actionid,final Action action){
		GameSet gameset=this.gamesetUUIDtoGameSet.get(gamesetid);
		if(gameset!=null && gameset.getUuidToCard().containsKey(cardid) && 
				gameset.getUuidToCard().get(cardid).getActionlist()
				.containsKey(action.getId())){
			this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid)
			.getActionlist().get(actionid).synchronize(action);
			return "";
		}
		return "error";		
	}
	
}
