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

import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

public class Statistics {
	Set<GameResult> gameresults;
	Map<String,CompetitionResult> competitionresults;
	
	public Statistics(String contextpath){
		this.gameresults=Data.getInstance(contextpath).getGameresults();
	}
	
	/*public Player getBestPlayer(){
		for(GameResult result:this.gameresults){
			for(result.get)
		}
	}*/
	
	public Integer getMaxPointsPerPlayer(){
		Integer maxpoints=0;
		for(GameResult result:this.gameresults){
			if(maxpoints<result.getMaxPoints()){
				maxpoints=result.getMaxPoints();
			}
		}
		return maxpoints;
	}
	
	public Integer getNumberOfCompetitions(){
		return this.competitionresults.size();
	}
	
	public Integer getNumberOfGames(){
		return this.gameresults.size();
	}
	
	public Integer getAvgPointsPerPlayer(){
		Integer avgpoints=0;
		if(this.gameresults.isEmpty()){
			return 0;
		}
		for(GameResult result:this.gameresults){
			for(com.example.LNDWA.cards.Game gam:result.game){
				avgpoints+=gam.points;
			}
		}
		return avgpoints/this.gameresults.size();
	}
	
	public Integer getAvgPointsPerPlayerForCompetition(String competition){
		Integer avgpoints=0;
		if(this.competitionresults.get(competition).getGameresults().isEmpty()){
			return 0;
		}
		for(GameResult result:this.competitionresults.get(competition).getGameresults()){
			for(com.example.LNDWA.cards.Game gam:result.game){
				avgpoints+=gam.points;
			}
		}
		return avgpoints/this.competitionresults.get(competition).getGameresults().size();
	}
	
	public Map<String,Integer> getMostUsedCharsForCompetition(String competition){
		Map<String,Integer> usedchars=new TreeMap<>();
		for(GameResult result:this.competitionresults.get(competition).getGameresults()){
			for(com.example.LNDWA.cards.Game gam:result.game){
				if(!usedchars.containsKey(gam.character)){
					usedchars.put(gam.character.getName(), 0);
				}
				usedchars.put(gam.character.getName(),usedchars.get(gam.character)+1);
			}
		}
		return usedchars;
	}
	
	public Map<String,Integer> getMostUsedChars(){
		Map<String,Integer> usedchars=new TreeMap<>();
		for(GameResult result:this.gameresults){
			for(com.example.LNDWA.cards.Game gam:result.game){
				if(!usedchars.containsKey(gam.character)){
					usedchars.put(gam.character.getName(), 0);
				}
				usedchars.put(gam.character.getName(),usedchars.get(gam.character)+1);
			}
		}
		return usedchars;
	}
	
	
	
	
}
