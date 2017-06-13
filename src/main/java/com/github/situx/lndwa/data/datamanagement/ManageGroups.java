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

import com.github.situx.lndwa.cards.GameSet;
import com.github.situx.lndwa.cards.Group;

import com.github.situx.lndwa.data.Data;

public class ManageGroups {
	private final Data data;
	
	private static ManageGroups instance;
	
	public ManageGroups(String contextpath){
		this.data=Data.getInstance(contextpath);
	}
	
	public static ManageGroups getInstance(String contextpath){
		if(instance==null){
			instance=new ManageGroups(contextpath);
		}
		return instance;
	}
	
	public Boolean add(final String gamesetid,final Group group) {
		if(this.data.getGamesetUUIDToGameSet().containsKey(gamesetid)){
			GameSet gameset=this.data.getGamesetUUIDToGameSet().get(gamesetid);
			gameset.getGroups().add(group);
			gameset.getUuidToGroup().put(group.getGroupId(),group);
			return true;
		}
		return false;
	}
	
	public List<Group> getAll(final String gamesetid,final Locale locale){
		return new LinkedList<Group>(this.data.getGamesetUUIDToGameSet().get(gamesetid).getGroups());
	}
	
	public Group get(final String gamesetid,final String groupid){
		System.out.println("GroupId "+groupid+" GameSet "+gamesetid+" UUIDToGroup "+this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToGroup());
		if(groupid!=null && this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToGroup().containsKey(groupid)){
			return this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToGroup().get(groupid);
		}
		return new Group();
	}

	public Boolean remove(final String gamesetid,final String groupid) {
		if(this.data.getGamesetUUIDToGameSet().containsKey(gamesetid)){
			GameSet gameset=this.data.getGamesetUUIDToGameSet().get(gamesetid);
			Group group=gameset.getUuidToGroup().get(groupid);
			gameset.getGroups().remove(group);
			gameset.getUuidToGroup().remove(groupid);
			return true;
		}
		return false;
	}

	public Boolean update(final String gamesetid,final String groupid,final Group group) {
		if(this.data.getGamesetUUIDToGameSet().containsKey(gamesetid) && 
				this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToEvent().containsKey(groupid)){
			Group existinggroup=this.data.getGamesetUUIDToGameSet().get(gamesetid).getUuidToGroup().get(groupid);
			existinggroup.synchronize(group);
			return true;
		}
		return false;
	}
}
