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


import com.github.situx.lndwa.cards.Preset;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;

/**
 * Created by timo on 19.02.14.
 */
public class PresetParse extends DefaultHandler {

    private boolean card=false,preset=false;

    private Integer cardamount=0;

    private Map<String,Preset> result;

    private Preset temp;

    public PresetParse(){
        this.result=new TreeMap<String, Preset>();
    }

    public Map<String,Preset> parsePreset(File file) throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory.newInstance().newSAXParser().parse(file,this);
        return this.result;
    }

    /**The parsing function for the characters.
     * @param fileName the name of the file to be parsed.
     * @return the list of characters.**/
    public Map<String,Preset> parsePreset(final InputSource fileName){
        try {
            SAXParserFactory.newInstance().newSAXParser().parse(fileName, this);
        } catch (SAXException e) {
            e.toString();
        } catch (IOException e) {
            e.toString();
        } catch (ParserConfigurationException e) {
            e.toString();
        }
        return this.result;
    }

    @Override
    public void startElement(final String uri, final String localName, final String qName, final Attributes attributes) throws SAXException {
        switch(qName){
            case "preset": temp=new Preset(); temp.setPresetName(attributes.getValue("name"));
                temp.setGamesetid(attributes.getValue("gamesetid"));
                temp.setPlayer(Integer.valueOf(attributes.getValue("player")));
                if(attributes.getValue("id")==null){
                	temp.setPresetId(UUID.randomUUID().toString());
                }else{
                	temp.setPresetId(attributes.getValue("id"));
                }
            	preset=true;break;
            case "card": if(preset){card=true;cardamount=Integer.valueOf(attributes.getValue("amount"));}break;
            default:
        }
    }

    @Override
    public void characters(final char[] ch, final int start, final int length) throws SAXException {
        if(card && preset){
           temp.getCardlist().put(new String(ch, start, length), cardamount);
        }
    }

    @Override
    public void endElement(final String uri, final String localName, final String qName) throws SAXException {
        switch(qName){
            case "preset": this.result.put(temp.getPresetId(),temp);preset=false;break;
            case "card": card=false;break;
            default:
        }
    }


}
