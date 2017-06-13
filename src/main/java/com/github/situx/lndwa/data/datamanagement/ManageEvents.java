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
import java.util.Locale;

import com.example.LNDWA.cards.Event;
import com.example.LNDWA.cards.GameElements;
import com.github.situx.lndwa.cards.GameSet;

import com.github.situx.lndwa.data.Data;

public class ManageEvents implements ManageInnerGameElement {
	private final Data data;
	
	private static ManageEvents instance;
	
	public ManageEvents(String contextpath){
		this.data=Data.getInstance(contextpath);
	}
	
	public static ManageEvents getInstance(String contextpath){
		if(instance==null){
			instance=new ManageEvents(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final String gamesetid,final GameElements eventt) {
		if(!(eventt instanceof Event)){
			return false;
		}
		Event event=(Event)eventt;
		if(this.data.getGamesetUUIDToGameSet().containsKey(gamesetid)){
			GameSet gameset=this.data.getGamesetUUIDToGameSet().get(gamesetid);
			gameset.getEvents().add(event);
			gameset.getUuidToEvent().put(event.getId(),event);
			return true;
		}
		return false;
	}
	
	public List<Event> getAll(final String gamesetid,final Locale locale){
		return this.data.getGamesetUUIDToGameSet().get(gamesetid).getEvents();
	}
	
	public Event get(final String gamesetid,final String eventid){
		return this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToEvent().get(eventid);
	}

	public Boolean remove(final String gamesetid,final String eventid) {
		if(this.data.getGamesetUUIDToGameSet().containsKey(gamesetid)){
		GameSet gameset=this.data.getGamesetUUIDToGameSet().get(gamesetid);
		Event event=gameset.getUuidToEvent().get(eventid);
		gameset.getEvents().remove(event);
		gameset.getUuidToEvent().remove(eventid);
		return true;
		}
		return false;
	}

	public Boolean update(final String gamesetid,final String eventid,final GameElements eventt) {
		if(!(eventt instanceof Event)){
			return false;
		}
		Event event=(Event)eventt;
		if(this.data.getGamesetUUIDToGameSet().containsKey(gamesetid) && 
				this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToEvent().containsKey(eventid)){
			Event existingevent=this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToEvent().get(eventid);
			existingevent.synchronize(event);
			return true;
		}
		return false;
	}

	@Override
	public List<Event> getAll(String gamesetid) {
		return new LinkedList<Event>(this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToEvent().values());
	}

}
