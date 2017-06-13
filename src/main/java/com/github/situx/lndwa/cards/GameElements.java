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

/**
 * Created by timo on 09.03.14.
 */
public interface GameElements {
    /**
     * Synchronizes a game element with another game element.
     * @param elem
     */
    public boolean synchronize(GameElements elem);
    /**
     * Creates a JSON String representation of the current class.
     * @return the representation as String
     */
    public String toJSON();
    /**
     * Creates a XML String representation of the current class.
     * @return the representation as String
     */
    public String toXML();
}
