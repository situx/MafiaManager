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

import com.github.situx.lndwa.cards.Ability;
import com.github.situx.lndwa.cards.GameSet;
import com.github.situx.lndwa.cards.Card;

import com.github.situx.lndwa.data.Data;

import java.util.Map;

public class ManageAbilities {

	private final Data data;
	
	private static ManageAbilities instance;
	
	private final Map<String,GameSet> gamesetUUIDtoGameSet;
	
	private ManageAbilities(String contextpath){
		this.data=Data.getInstance(contextpath);
		this.gamesetUUIDtoGameSet=this.data.getGamesetUUIDToGameSet();
	}
	
	public static ManageAbilities getInstance(String contextpath){
		if(instance==null){
			instance=new ManageAbilities(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final String gamesetid,final String cardid,final Ability ability){
		GameSet gameset=this.gamesetUUIDtoGameSet.get(gamesetid);
		if(gameset!=null && gameset.getUuidToCard().containsKey(cardid)){
			Card card=this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid);
			card.getUuidToAbility().put(ability.getAbilityId(),ability);
			card.getabblist().add(ability);
			return true;
		}
		return false;
	}
	
	public Ability get(final String gamesetid,final String cardid,final String abilityid){
		return this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid).getUuidToAbility().get(abilityid);
	}

	public Boolean remove(final String gamesetid,final String characterid,final String abilityid) {
		Card card=this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(characterid);
		Ability ability=card.getUuidToAbility().get(abilityid);
		card.getUuidToAbility().remove(abilityid);
		card.getabblist().remove(ability);
		return true;
	}

	/**
	 * Updates a currently existing ability with another version of this ability.
	 * @param gamesetid the gameset id
	 * @param abilityid the abilty id
	 */
	public String update(final String gamesetid,final String cardid,final String abilityid,final Ability ability){
		GameSet gameset=this.gamesetUUIDtoGameSet.get(gamesetid);
		if(gameset!=null && gameset.getUuidToCard().containsKey(cardid) && 
				gameset.getUuidToCard().get(cardid).getUuidToAbility().containsKey(ability.getAbilityId())){
			this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid).getUuidToAbility().get(abilityid).synchronize(ability);
			return "";
		}
		return "error";		
	}
	

}
