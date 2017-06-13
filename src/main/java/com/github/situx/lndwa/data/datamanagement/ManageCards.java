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
import com.github.situx.lndwa.cards.Card;
import com.github.situx.lndwa.cards.GameSet;

import com.github.situx.lndwa.data.Data;

public class ManageCards implements ManageInnerGameElement {

	private final Data data;
	
	private final Map<String,GameSet> gamesetUUIDtoGameSet;
	
	private static ManageCards instance;
	
	private ManageCards(String contextpath){
		this.data=Data.getInstance(contextpath);
		this.gamesetUUIDtoGameSet=data.getGamesetUUIDToGameSet();
	}
	
	public static ManageCards getInstance(String contextpath){
		if(instance==null){
			instance=new ManageCards(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final String gamesetid,final GameElements cardd){
		if(!(cardd instanceof Card)){
			return false;
		}
		Card card=(Card)cardd;
		GameSet gameset=this.gamesetUUIDtoGameSet.get(gamesetid);
		if(gameset!=null && !gameset.getUuidToCard().containsKey(card.getCardid())){
			this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().put(card.getCardid(),card);
			this.gamesetUUIDtoGameSet.get(gamesetid).getCards().add(card);
			return true;
		}
		return false;
	}
	
	public Card get(final String gamesetid, final String cardid){
		return this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid);
	}

	public Boolean remove(final String gamesetid,final String characterid) {
		Card card=this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(characterid);
		this.gamesetUUIDtoGameSet.get(gamesetid).getCards().remove(card);
		this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().remove(card.getCardid());
		return true;
	}

	/**
	 * Updates a currently existing ability with another version of this ability.
	 * @param characterid the character id
	 * @param gamesetid the gameset id
	 * @param abilityid the abilty id
	 * @param card the card id
	 */
	public Boolean update(final String gamesetid,final String cardid,final GameElements card){
		GameSet gameset=this.gamesetUUIDtoGameSet.get(gamesetid);
		if(gameset!=null && gameset.getUuidToCard().containsKey(cardid)){
			this.gamesetUUIDtoGameSet.get(gamesetid).getUuidToCard().get(cardid).synchronize(card);
			return true;
		}
		return false;		
	}

	@Override
	public List<Card> getAll(String id) {
		return new LinkedList<Card>(this.gamesetUUIDtoGameSet.get(id).getUuidToCard().values());
	}

}
