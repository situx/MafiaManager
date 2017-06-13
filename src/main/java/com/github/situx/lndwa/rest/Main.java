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
package com.github.situx.lndwa.rest;

import java.io.IOException;
import java.io.StringWriter;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Locale;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.github.situx.lndwa.cards.GameSet;
import com.github.situx.lndwa.cards.Player;
import com.google.gson.Gson;

import com.github.situx.lndwa.data.Data;
import com.github.situx.lndwa.data.GameResult;
import com.github.situx.lndwa.data.datamanagement.ManagePlayers;

@Path("/lndwa")
public class Main {
	
	private Data data;
	
	private String contextpath;
	
	public Main(){
		//this.contextpath=contextpath;
		//this.data=Data.getInstance(contextpath);
	}
	
	public void getStatistics(){
		
	}
	
	@GET
	@Path("/receivegame")
	@Produces("text/plain")
	public String receiveGame(){
		return "Hallo Welt";
	}
	
	@GET
	@Path("/gamesetlist/{param}")
	@Produces("text/plain")
	public String getGameSetList(@PathParam("param") String locale){
		try {
			return Data.getInstance("").getGameSetNamesByLanguage(locale).toString();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			return this.writeExceptionReply(e.getMessage());
		}
	}
	
	@GET
	@Path("/gamesetlistjson/{param}")
	@Produces("text/plain")
	public String getGameSetListJson(@PathParam("param") String locale){
		try {
			Gson gson=new Gson();
			return gson.toJson(Data.getInstance("").getGameSets(new Locale(locale)).toString());
		} catch (FactoryConfigurationError e) {
			return this.writeExceptionReply(e.getMessage());
		}
	}
	
	@GET
	@Path("/gameset/{param}/{name}")
	@Produces("text/plain")
	public String getGameSet(@PathParam("param") String locale,@PathParam("name")String name){
		try {
			return Data.getInstance("").getGameSet(locale, name);
		} catch (FactoryConfigurationError e) {
			return this.writeExceptionReply(e.getMessage());
		} catch (IOException e) {
			return this.writeExceptionReply(e.getMessage());
		}
	}
	
	@GET
	@Path("/gamesetjson/{name}")
	@Produces("text/plain")
	public String getGameSetJSON(@PathParam("name")String name){
		try {
			return Data.getInstance("").getGamesetUUIDToGameSet().get(name).toJSON();
		} catch (FactoryConfigurationError e) {
			return this.writeExceptionReply(e.getMessage());
		}
	}
	
	@GET
	@Path("/getplayers")
	@Produces("text/plain")
	public String getPlayers(){
		try {
			return Data.getInstance("").getPlayersAsXML();
		} catch (FactoryConfigurationError e) {
			return this.writeExceptionReply(e.getMessage());
		} catch (XMLStreamException e) {
			return this.writeExceptionReply(e.getMessage());
		}
	}
	
	@GET
	@Path("/getplayersjson")
	@Produces("text/plain")
	public String getPlayersJson(){
		try {
			return Data.getInstance("").getPlayersAsJSON();
		} catch (FactoryConfigurationError e) {
			return this.writeExceptionReply(e.getMessage());
		} catch (XMLStreamException e) {
			return this.writeExceptionReply(e.getMessage());
		}
	}
	
	@GET
	@Path("/gameresults")
	@Consumes(MediaType.APPLICATION_XML)
	public String updateGameResults(GameResult incomingXML) {
		System.out.println("Received: "+incomingXML);
	    /*GameResultParser parse=new GameResultParser();
	    parse.parseGameResult(new InputSource(incomingXML));
	    List<Game> gamelist=parse.getGames();
	    this.data.updateGameResults(gamelist);*/
		return "Success";
	}
	
	@GET
	@Path("/players")
	@Consumes(MediaType.APPLICATION_XML)
	public String updateGameResults(List<Player> incomingXML) {
		System.out.println("Received: "+incomingXML);
	    /*GameResultParser parse=new GameResultParser();
	    parse.parseGameResult(new InputSource(incomingXML));
	    List<Game> gamelist=parse.getGames();
	    Data.getInstance("").updateGameResults(gamelist);*/
		return "Success";
	}
	
	/**
	 * Writes an error message to the client if the requested data cannot be delivered.
	 * @param exceptiontext
	 * @return
	 * @throws FactoryConfigurationError 
	 * @throws XMLStreamException 
	 */
	public String writeExceptionReply(final String exceptiontext) {
		StringWriter resultwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(resultwriter);
			writer.writeStartDocument();
			writer.writeStartElement("error");
			writer.writeCharacters(exceptiontext);
			writer.writeEndElement();
			writer.flush();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return resultwriter.toString();
	}
	
	/**
	 * Login method.
	 * @param loginstr xml string for login
	 * @return success indicator
	 */
	@POST
	@Path("login")
	@Consumes(MediaType.APPLICATION_XML)
	public String login(final String loginstr){
		
		return "";
	}
	
	@GET
	@Path("download/{gameset}/{language}/{printlang}")
	@Consumes(MediaType.TEXT_PLAIN)
	@Produces("application/pdf")
	public Response download(@PathParam("gameset") final String gameset,@PathParam("language")final String language,@PathParam("printlang")final String printlang,@QueryParam("context") final String contextpath) throws URISyntaxException {
		System.out.println("In Download Method");
		System.out.println("Gameset "+gameset+" Language "+language);
	    ResponseBuilder response = Response.ok(Data.getInstance(contextpath).generateGameSetPDF(gameset, language,printlang,contextpath));
	    response.header("Content-Disposition",  "attachment; filename="+Data.getInstance(contextpath).getGamesetUUIDToGameSet().get(gameset).getGamesetImg()+".pdf");
	    System.out.println("Response Created "+Data.getInstance(contextpath).getGamesetUUIDToGameSet().get(gameset).getGamesetImg()+".pdf");
	    Response res=response.build();
	    System.out.println("Real response "+res.getMetadata().toString());
	    return res;
	}
	
	@GET
	@Path("gameresult/{gameresult}/{printlang}")
	@Consumes(MediaType.TEXT_PLAIN)
	@Produces("application/pdf")
	public Response download(@PathParam("gameresult") final String gameid,@PathParam("printlang") final String printlang,@QueryParam("context") final String contextpath) throws URISyntaxException {
		System.out.println("In Download Method");
		System.out.println("Gameset "+gameid);
	    ResponseBuilder response = Response.ok(Data.getInstance(contextpath).generateGameResultPDF(gameid,printlang,contextpath));
	    response.header("Content-Disposition",  "attachment; filename="+gameid+".pdf");
	    System.out.println("Response Created "+gameid+".pdf");
	    Response res=response.build();
	    System.out.println("Real response "+res.getMetadata().toString());
	    return res;
	}
	
	/**
	 * Adds a player.
	 * @param player the player to add
	 * @return success indicator
	 */
	@POST
	@Path("addplayer")
	@Consumes(MediaType.APPLICATION_XML)
	public String addPlayer(final Player player){
		StringWriter resultwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(resultwriter);
			writer.writeStartDocument();
			writer.writeStartElement("result");
			writer.writeCharacters(ManagePlayers.getInstance(contextpath).add(player).toString());
			writer.writeEndElement();
			writer.flush();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return resultwriter.toString();
	}
	
	/**
	 * Adds a gameset.
	 * @param gameset the gameset to add
	 * @return success indicator
	 * @throws IOException 
	 */
	@POST
	@Path("addgameset")
	@Consumes(MediaType.APPLICATION_XML)
	public String addPlayer(final GameSet gameset,@QueryParam("contextpath") String context) throws IOException{
		StringWriter resultwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(resultwriter);
			writer.writeStartDocument();
			writer.writeStartElement("result");
			writer.writeCharacters(Data.getInstance("").addGameSet(gameset,"de").toString());
			writer.writeEndElement();
			writer.flush();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return resultwriter.toString();
	}
	
	//@PUT
	  //@Consumes(MediaType.APPLICATION_XML)
	  /*public Response putTodo(JAXBElement<Todo> todo) {
	    Todo c = todo.getValue();
	    return putAndGetResponse(c);
	  }*/

}
