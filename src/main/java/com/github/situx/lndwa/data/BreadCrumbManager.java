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
package com.github.situx.lndwa.data;

import java.util.List;
import java.util.LinkedList;

import com.github.situx.lndwa.Utils.Tuple;

public class BreadCrumbManager {
	List<Tuple<String,String>> breadcrumbs;
	
	public BreadCrumbManager(){
		this.breadcrumbs=new LinkedList<Tuple<String,String>>();
	}
	
	public void addBreadCrumb(final String url,final String title){
		Tuple<String,String> toinsert=new Tuple<String,String>(url,title);
		if(this.breadcrumbs.contains(toinsert)){
			int index=this.breadcrumbs.indexOf(toinsert);
			for(int i=index;i<this.breadcrumbs.size();i++){
				this.breadcrumbs.remove(i);
			}		
		}else{
			this.breadcrumbs.add(toinsert);	
		}
		
	}
	
	public Tuple<String,String> getBreadCrumb(final Integer id){
		return this.breadcrumbs.get(id);
	}
	
	public void removeBreadCrumb(Integer id){
		this.breadcrumbs.remove(id);
	}
	
	public void removeBreadCrumb(String id,String title){
		this.breadcrumbs.remove(this.breadcrumbs.indexOf(new Tuple<String, String>(id, title)));
	}
	
	public Integer length(){
		return this.breadcrumbs.size();
	}
	
	public Boolean isEmpty(){
		return this.breadcrumbs.isEmpty();
	}
	
	public void clear(){
		this.breadcrumbs.clear();
	}
}
