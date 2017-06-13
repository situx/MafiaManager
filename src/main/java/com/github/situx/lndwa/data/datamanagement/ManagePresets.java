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

import com.github.situx.lndwa.cards.Preset;

import com.github.situx.lndwa.data.Data;

public class ManagePresets {
	private final Data data;
	
	private static ManagePresets instance;
	
	public ManagePresets(String contextpath){
		this.data=Data.getInstance(contextpath);
	}
	
	public static ManagePresets getInstance(String contextpath){
		if(instance==null){
			instance=new ManagePresets(contextpath);
		}
		return instance;
	}
	
	public void add(String gamesetid,Preset preset) {
		
		this.data.getGamesetUUIDToGameSet().get(gamesetid).getPresets().put(preset.getPresetId(),preset);
	}
	
	public Preset get(String gamesetid,String presetid){
		return this.data.getGamesetUUIDToGameSet().get(gamesetid).getPresets().get(presetid);
	}


	public String remove(String presetid,Preset element) {
		// TODO Auto-generated method stub
		return null;
	}

	public Boolean update(Preset element, String... ids) {
		// TODO Auto-generated method stub
		return null;
	}

}
