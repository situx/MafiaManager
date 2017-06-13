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

import com.github.situx.lndwa.cards.GameSet;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import java.io.IOException;
import java.io.StringReader;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by timo on 15.03.14.
 */
public class SyncParse extends DefaultHandler {

    private List<String> gamesetlist;

    private GameSet gameSet;

    private boolean set=false;

    private boolean error=false;

    private String errormessage="";

    public SyncParse(){
        this.gamesetlist=new LinkedList<>();
    }

    public void setError(final boolean error) {
        this.error = error;
    }

    @Override
    public void startElement(final String uri, final String localName, final String qName, final Attributes attributes) throws SAXException {
        super.startElement(uri, localName, qName, attributes);

        switch(qName){
            case "error": error=true;break;
            case "gamesetlist":break;
            case "set": this.set=true;break;
        }
    }

    public String getErrormessage() {
        return errormessage;
    }

    public boolean isError() {
        return error;
    }


    @Override
    public void characters(final char[] ch, final int start, final int length) throws SAXException {
        super.characters(ch, start, length);
        if(this.set){
            this.gamesetlist.add(new String(ch,start,length));
        }
        if(this.error){
            this.errormessage=new String(ch,start,length);

        }
    }

    @Override
    public void endElement(final String uri, final String localName, final String qName) throws SAXException {
        super.endElement(uri, localName, qName);
        switch(qName){
            case "gamesetlist":break;
            case "set": this.set=false;break;
        }
    }

    public List<String> parseGameSetList(final String filestring) throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory.newInstance().newSAXParser().parse(new InputSource(new StringReader(filestring)),this);
        Collections.sort(this.gamesetlist);
        return this.gamesetlist;
    }
}
