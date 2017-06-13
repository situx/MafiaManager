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
package com.github.situx.lndwa.Utils;



/**
 * Created with IntelliJ IDEA.
 * Generic tuple class representing a tuple of two comparable types.
 */
public class Tuple<T extends Comparable<T>,T2 extends Comparable<T2>> implements Comparable<Tuple<T,T2>> {
    /**Tuple value of type one.*/
    private T one;
    /**Tuple value of type two.*/
    private T2 two;

    /**
     * Constructor for this class.
     * @param one value one as type one
     * @param two value two as type two
     */
    public Tuple(T one, T2 two){
        this.one=one;
        this.two=two;
    }

    @Override
    public int compareTo(final Tuple<T, T2> o) {
        Tuple<T,T2> t=(Tuple<T,T2>) o;

        int cmp = this.getOne().compareTo((T) t.getOne());
        if (cmp == 0)
            cmp = this.getTwo().compareTo((T2) t.getTwo());
        return cmp;
    }

    /**
     * Gets the first value of type one.
     * @return the value
     */
    public T getOne(){
        return one;
    }

    /**
     * Gets the second value of type two.
     * @return the value
     */
    public T2 getTwo(){
        return two;
    }

    /**
     * Sets the first value of type one.
     * @param one the value to set
     */
    public void setOne(T one){ this.one=one;}

    /**
     * Sets the second value of type two.
     * @param two the value to set
     */
    public void setTwo(T2 two){this.two=two;}

    @SuppressWarnings("unchecked")
	@Override
    public boolean equals(Object obj) {
        if(obj instanceof Tuple){
        	System.out.println(this.one+" "+this.two);
            return this.one.equals(((Tuple<T,T2>)obj).one) && this.two.equals(((Tuple<T,T2>)obj).two);
        }
        return false;
    }


    @Override
    public String toString() {
        return "["+this.one+","+this.two+"]";
    }
}
