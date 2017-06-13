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
package com.github.situx.lndwa.cards;



import java.util.List;

/**
 * Created by timo on 03.05.14.
 */
public class Operator{


    public Boolean getDirection() {
		return direction;
	}

	public void setDirection(Boolean direction) {
		this.direction = direction;
	}

	public Boolean getAbility() {
		return ability;
	}

	public void setAbility(Boolean ability) {
		this.ability = ability;
	}

	public Boolean getUsedonabb() {
		return usedonabb;
	}

	public void setUsedonabb(Boolean usedonabb) {
		this.usedonabb = usedonabb;
	}

	private Boolean hascheck=false;
    private Boolean group;

    private Boolean not;

    private Boolean count;

    private Boolean direction;

    private Boolean ability;

    private Boolean usedonabb;

    private Boolean onlycheck;

    private Boolean valueOp;

    public Operator(String operatorstr){
        this.hascheck=true;
        count=operatorstr.contains("#(");
        group=operatorstr.substring(0,operatorstr.indexOf('(')).contains("g");
        ability=operatorstr.substring(0,operatorstr.indexOf('(')).contains("a");
        usedonabb=operatorstr.substring(0,operatorstr.indexOf('(')).contains("u");
        direction=operatorstr.substring(0,operatorstr.indexOf('(')).contains("d");
        onlycheck=operatorstr.contains("?");
        not=operatorstr.substring(0,operatorstr.indexOf('(')).contains("!");
        valueOp=group || count || not;
        this.value=operatorstr.substring(operatorstr.indexOf('(')+1,operatorstr.lastIndexOf(')'));
    }

    public Operator(){
        this.hascheck=false;
        this.count=false;
        this.group=false;
        this.value="";
        this.not=false;
        this.direction=false;
        this.onlycheck=false;
        this.ability=false;
        this.valueOp=false;
        this.usedonabb=false;
    }


    public Boolean getOnlyCheck() {
        return this.onlycheck;
    }

    public Boolean hasCheck() {
        return this.hascheck;
    }


    public Integer evaluate(Card comparecard, List<Card> cards, List<Card> deadcards){
        Integer result=0;
        if(count){
            if(group){
                if(not){
                    for(Card card:cards){
                        if(!card.getGroup().getGroupId().equals(this.value)){
                            result+=card.getCurrentamount();
                        }
                    }
                }else{
                    for(Card card:cards){
                        if(card.getGroup().getGroupId().equals(this.value)){
                            result+=card.getCurrentamount();
                        }
                    }
                }
            }else{
                if(not){
                    for(Card card:cards){
                        if(!card.getCardid().equals(this.value)){
                            result+=card.getCurrentamount();
                        }
                    }
                }else{
                    for(Card card:cards){
                        if(card.getCardid().equals(this.value)){
                            result+=card.getCurrentamount();
                            break;
                        }
                    }
                }
            }

        }else{
            if(group) {
                if (not) {
                    result = !comparecard.getGroup().getGroupId().equals(this.value) ? 1 : 0;
                } else {
                    result = comparecard.getGroup().getGroupId().equals(this.value) ? 1 : 0;
                }
            }else if(!group && ability && !usedonabb){
                 result=comparecard.getUuidToAbility().containsKey(this.value)?1:0;
            }else if(!group && !ability && usedonabb){
                result=comparecard.getUuidToAbility().containsKey(this.value)?1:0;
            }else{
               if(not){
                           if(comparecard.getCardid().equals(this.value)){
                           result=comparecard.isdead()?1:0;
                   }

               }else{
                       if(comparecard.getCardid().equals(this.value)){
                           result=comparecard.isdead()?0:1;
                       }
               }
            }
        }
        return result;
    }

    public Boolean getValueOp() {
        return valueOp;
    }

    public void setValueOp(final Boolean valueOp) {
        this.valueOp = valueOp;
    }

    public String getValue() {
        return value;
    }

    public void setValue(final String value) {
        this.value = value;
    }

    private String value;

    public Boolean getNot() {
        return not;
    }

    public void setNot(final Boolean not) {
        this.not = not;
    }

    public Boolean getGroup() {
        return group;
    }

    public void setGroup(final Boolean group) {
        this.group = group;
    }

    public Boolean getCount() {
        return count;
    }

    public void setCount(final Boolean count) {
        this.count = count;
    }

    @Override
    public String toString() {
        return this.toXML();
    }

    public String toXML(){
        String result="";
        if(!hascheck){
            return result;
        }
        if(onlycheck){
            result+="?";
        }
        if(not){
            result+="!";
        }
        if(ability){
            result+="a";
        }
        if(direction){
            result+="d";
        }
        if(usedonabb){
            result+="u";
        }
        if(group){
            result+="g";
        }else{
            result+="c";
        }
        if(count){
            result+="#";
        }
        result+="("+this.value+")";
        return result;
    }
}
