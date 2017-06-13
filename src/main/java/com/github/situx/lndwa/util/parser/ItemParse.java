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
package com.github.situx.lndwa.util.parser;

import com.github.situx.lndwa.cards.Item;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

/**
 * Created by timo on 18.01.14.
 */
public class ItemParse extends DefaultHandler{


    private Item item;

    private List<Item> itemList;

    private String tempdescription;

    private Boolean play=false,description=false;

    private Random random;

    public ItemParse(){
        this.itemList=new LinkedList<>();
        this.random=new Random(System.currentTimeMillis());
    }

    public void parseEvents(InputSource fileName){
        try {
            SAXParserFactory.newInstance().newSAXParser().parse(fileName, this);
        } catch (SAXException e) {
            e.toString();
        } catch (IOException e) {
            e.toString();
        } catch (ParserConfigurationException e) {
            e.toString();
        }
    }

    @Override
    public void startElement(final String uri, final String localName, final String qName, final Attributes attributes) throws SAXException {
        switch(qName){
            case "item": this.item=new Item();this.item.setId(Integer.valueOf(attributes.getValue("id")));this.item.setName(attributes.getValue("name"));this.play=true;break;
            case "description": if(play){
                this.description=true;this.tempdescription="";
            }break;
            default:
        }
    }

    @Override
    public void characters(final char[] ch, final int start, final int length) throws SAXException {
        if(this.description)
            this.tempdescription+=new String(ch,start,length)+"\n";
    }

    @Override
    public void endElement(final String uri, final String localName, final String qName) throws SAXException {
        switch(qName){
            case "description": this.item.setDescription(this.tempdescription);this.description=false;break;
            case "item": this.itemList.add(this.item);this.play=false;break;
            default:
        }
    }

    public List<Item> getItems() {
        return this.itemList;
    }

}
