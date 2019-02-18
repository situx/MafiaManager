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
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import javax.servlet.http.HttpServlet;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import com.github.situx.lndwa.cards.Competition;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.apache.xalan.processor.TransformerFactoryImpl;
import org.xml.sax.SAXException;

import com.github.situx.lndwa.cards.GameSet;
import com.github.situx.lndwa.cards.Player;
import com.github.situx.lndwa.cards.Preset;
import com.github.situx.lndwa.util.parser.GameResultParser;
import com.github.situx.lndwa.util.parser.PlayerParse;
import com.github.situx.lndwa.util.parser.UserParse;
import com.google.gson.Gson;

import com.github.situx.lndwa.Utils.Utils;
import com.github.situx.lndwa.Utils.Tuple;


public class Data extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = -3695571590576818550L;
	/**The gameset folder.*/
	private File gameSetFolder=new File("data"+File.separator+"gamesets"+File.separator);
	/**The name of the resource bundle sets to use.*/
	public static final String RESBUNDLENAME="LNDWAWeb";
	/**The name of the resource bundle sets to use.*/
	public static final String GAMERESULTPATH="data"+File.separator+"result"+File.separator;
	/**The path to the currently available gamesets.*/
	public static final String GAMESETPATH="data"+File.separator+"gamesets"+File.separator;
	/**The path to the currently available gamesets.*/
	public static final String PRESETPATH="data"+File.separator+"presets"+File.separator;
	/**Map frmo languages to gamesetspaths.*/
	private Map<String,List<Tuple<String,GameSet>>> languageToGameSetPath;
	/**The map of gamesetpaths to gamesetnames.*/
	private Map<String,String> gamesetMap;
	/**The map of gamesetpaths to gamesetnames.*/
	private Map<String,Competition> competitionMap;
	/**Maps from game set uuids to gamesets.*/
	private Map<String,GameSet> gamesetUUIDToGameSet;
	/**Maps from gameset paths to gameset uuids.*/	
	private Map<String,String> gamesetPathToUUID;
	
	final private static int BUFFER_SIZE = 1024;
	
	private static String MIMETEX_EXE = "c:\\Program Files (x86)\\mimetex\\mimetex.cgi";
	
	
	private static String LATEX = "c:\\Program Files (x86)\\mimetex\\mimetex.cgi";
	
	private Set<GameResult> gameresults;
	
	public Set<GameResult> getGameresults() {
		return gameresults;
	}


	public void setGameresults(Set<GameResult> gameresults) {
		this.gameresults = gameresults;
	}
	private Map<String,User> logindata;
	
	public Map<String, GameSet> getGamesetUUIDToGameSet() {	
		return gamesetUUIDToGameSet;
	}


	public void setGamesetUUIDToGameSet(Map<String, GameSet> gamesetUUIDToGameSet) {
		this.gamesetUUIDToGameSet = gamesetUUIDToGameSet;
	}
	/**Maps from gamesets to their presets.*/
	private Map<String,Preset> gamesetToPreset;
	
	private Map<String,ResourceBundle> resourcebundlemap;
	
	private Map<String,Player> playeruuidToPlayer;
	
	private static Data instance;
	
	/**Parses a player xml file.*/
	private Set<Player> playerList;
	private String contextpath;
	
	/**
	 * Private constructor for this singleton class.
	 */
	private Data(String requestPath){
		Data.instance=this;
		requestPath=requestPath.substring(0,requestPath.lastIndexOf('/'));
		this.contextpath=requestPath;
		this.languageToGameSetPath=new TreeMap<String,List<Tuple<String,GameSet>>>();
		this.competitionMap=new TreeMap<>();
		this.gamesetMap=new TreeMap<String,String>();
		this.playeruuidToPlayer=new HashMap<>();
		PlayerParse playerparse=new PlayerParse();
		playerparse.parsePlayer(new File(requestPath+File.separator+Utils.PLAYERPATH));
		System.out.println("Playerpath: "+requestPath+File.separator+Utils.PLAYERPATH);
		System.out.println("Players: "+this.logindata);
		this.playerList=new TreeSet<Player>(playerparse.getPlayers());
		for(Player player:this.playerList){
			this.playeruuidToPlayer.put(player.getPlayerid(),player);
			System.out.println(player.toJSON());
		}
		UserParse userparse=new UserParse();
		this.logindata=userparse.parseUsers(new File(requestPath+File.separator+Utils.USERPATH));
		System.out.println("Userpath: "+requestPath+File.separator+Utils.USERPATH);
		System.out.println("Logindata: "+this.logindata);
		this.resourcebundlemap=new TreeMap<>();
		this.gamesetUUIDToGameSet=new TreeMap<>();
		this.gamesetPathToUUID=new TreeMap<>();
		System.out.println(requestPath+File.separator+GAMESETPATH);
		String path=new File(requestPath+File.separator+GAMESETPATH).getAbsolutePath();
		System.out.println(path);
		System.out.println(new File(path).isDirectory());
		for(String language:new File(path).list()){
			this.languageToGameSetPath.put(language,new LinkedList<Tuple<String,GameSet>>());
		}
		for(String language:this.languageToGameSetPath.keySet()){
			System.out.println(path+"/"+language);
			for(File set:new File(path+"/"+language).listFiles()){
				if(!set.isDirectory() && set.getName().contains("_chars")){
				try {
					System.out.println("Set: "+set);
					GameSet gameset=new GameSet(set,requestPath+File.separator+PRESETPATH);
					this.languageToGameSetPath.get(language).add(new Tuple<String, GameSet>(set.getName(), gameset));
					this.gamesetPathToUUID.put(set.getName(), gameset.getGamesetid());
					this.gamesetUUIDToGameSet.put(gameset.getGamesetid(),gameset);
				} catch (IOException | SAXException
						| ParserConfigurationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				}
			}
		}
		this.gameresults=new TreeSet<GameResult>();
		this.gameresults=new TreeSet<GameResult>(new GameResultParser(contextpath).parseGameResult(new File(requestPath+File.separator+GAMERESULTPATH+"gameresults.xml")));
		System.out.println(this.gameresults.toString());
		System.out.println(this.gamesetUUIDToGameSet.toString());
		System.out.println(this.languageToGameSetPath.toString());
	}
	
	public Map<String, List<Tuple<String, GameSet>>> getLanguageToGameSetPath() {
		return languageToGameSetPath;
	}


	public Map<String, Player> getPlayeruuidToPlayer() {
		return playeruuidToPlayer;
	}
	
	public byte[] latexToPDF(String latexString){
		byte[] imageData = null;
	    try {
	        // mimetex is asked (on the command line) to convert
	        // the LaTeX expression to .gif on standard output:
	    	Process texproc=Runtime.getRuntime().exec(LATEX);
	    	
	        Process proc = Runtime.getRuntime().exec(MIMETEX_EXE + " -d \"" + latexString + "\"");
	        // get the output stream of the process:
	        BufferedInputStream bis = (BufferedInputStream) proc.getInputStream();
	        // read output process by bytes blocks (size: BUFFER_SIZE)
	        // and stores the result in a byte[] Arraylist:
	        int bytesRead;
	        byte[] buffer = new byte[BUFFER_SIZE];
	        ArrayList<byte[]> al = new ArrayList<byte[]>();
	        while ((bytesRead = bis.read(buffer)) != -1) {
	            al.add(buffer.clone());
	        }
	        // convert the Arraylist in an unique array:
	        int nbOfArrays = al.size();
	        if (nbOfArrays == 1) {
	            imageData = buffer;
	        } else {
	            imageData = new byte[BUFFER_SIZE * nbOfArrays];
	            byte[] temp;
	            for (int k = 0; k < nbOfArrays; k++) {
	                temp = al.get(k);
	                for (int i = 0; i < BUFFER_SIZE; i++) {
	                    imageData[BUFFER_SIZE * k + i] = temp[i];
	                }
	            }
	        }
	        bis.close();
	        proc.destroy();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	    return imageData;
	}
	
	public byte[] generateGameSetPDF(String gameset,String language,String printlang,String contextpath) throws URISyntaxException{
		language="de";
		System.out.println("Gameset "+gameset+" Language "+language);
		System.out.println(contextpath+File.separator+"data"+File.separator+"gamesets"+File.separator+language+File.separator+this.gamesetUUIDToGameSet.get(gameset).getLanguage()+"_"+this.gamesetUUIDToGameSet.get(gameset).getGamesetid()+"_chars.xml");
		System.out.println(new File(contextpath+File.separator+"data"+File.separator+"gamesets"+File.separator+language+File.separator+this.gamesetUUIDToGameSet.get(gameset).getLanguage()+"_"+this.gamesetUUIDToGameSet.get(gameset).getGamesetid()+"_chars.xml").exists());
		System.out.println(new File(contextpath+File.separator+"xslt"+File.separator+printlang+File.separator+"gameset.xsl").exists());

		// the XSL FO file
		File xsltfile = new File(contextpath+File.separator+"xslt"+File.separator+printlang+File.separator+"gameset.xsl");
		// the XML file from which we take the name
		StreamSource source = new StreamSource(new File(contextpath+
		File.separator+"data"+File.separator+"gamesets"+File.separator+language+File.separator+this.gamesetUUIDToGameSet.get(gameset).getLanguage()
		+"_"+this.gamesetUUIDToGameSet.get(gameset).getGamesetid()+"_chars.xml"));
		// creation of transform source
		StreamSource transformSource = new StreamSource(xsltfile);
		// create an instance of fop factory
		FopFactory fopFactory = FopFactory.newInstance(new URI("https://situx.ydns.eu"));
		// a user agent is needed for transformation
		FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
		// to store output
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();

		Transformer xslfoTransformer;
		try
		{
			TransformerFactoryImpl impl = 
					new TransformerFactoryImpl();


			xslfoTransformer = impl.newTransformer(transformSource);
	        System.out.println("Transformer Created");
			// Construct fop with desired output format
		        Fop fop;
			try
			{
				fop = fopFactory.newFop
					(MimeConstants.MIME_PDF, foUserAgent, outStream);
		                Result res = new SAXResult(fop.getDefaultHandler());
		        System.out.println("Fop Created");
				try
				{
					xslfoTransformer.transform(source, res);
			        System.out.println("Transformed");
					return outStream.toByteArray();

				}
				catch (TransformerException e) {
					try {
						throw e;
					} catch (TransformerException e1) {
						e1.printStackTrace();
					}
				}
			}
			catch (FOPException e) {
				try {
					throw e;
				} catch (FOPException e1) {
					e1.printStackTrace();
				}
			}
		}
		catch (TransformerConfigurationException e)
		{
			try {
				throw e;
			} catch (TransformerConfigurationException e1) {
				e1.printStackTrace();
			}
		}
		catch (TransformerFactoryConfigurationError e)
		{
			throw e;
		}

		  return null;

	}


	public void setPlayeruuidToPlayer(Map<String, Player> playeruuidToPlayer) {
		this.playeruuidToPlayer = playeruuidToPlayer;
	}
	
	public void saveUsers(){
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartElement("users");
			for(User user:this.logindata.values()){
				writer.writeCharacters(user.toXML()+"\n");
			}
	        writer.flush();
			writer.writeEndElement();
			BufferedWriter fwriter;
				fwriter = new BufferedWriter(new FileWriter(new File(Utils.USERPATH)));
				fwriter.write(writer.toString());
				fwriter.close();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


	}
	

	
	public void savePlayers(){
    	StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer;
		try {
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
			writer.writeStartElement("users");
			for(Player player:this.playerList){
				writer.writeCharacters(player.toXML()+"\n");
			}
	        writer.flush();
			writer.writeEndElement();
			BufferedWriter fwriter;
				fwriter = new BufferedWriter(new FileWriter(new File(Utils.PLAYERPATH)));
				fwriter.write(writer.toString());
				fwriter.close();
		} catch (XMLStreamException | FactoryConfigurationError e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void saveGameSet(final GameSet gameset){
		try {
			BufferedWriter fwriter;
				fwriter = new BufferedWriter(new FileWriter(new File(GAMESETPATH+gameset.getLanguage()+File.separator+gameset.getLanguage()+"_"+gameset.getGamesetid()+"_chars.xml")));
				fwriter.write(gameset.toXML());
				fwriter.close();
		} catch (FactoryConfigurationError e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void saveGameResult(GameResult result){
		try {
			BufferedWriter fwriter;
				fwriter = new BufferedWriter(new FileWriter(new File(GAMERESULTPATH+"gameresults.xml"), true));
				fwriter.write(result.toXML());
				fwriter.close();
		} catch (FactoryConfigurationError e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}


	/**
	 * Gets a resource bundle for a corresponding language.
	 * @param locale the locale to use
	 * @return the ResourceBundle
	 */
	public ResourceBundle getResourceBundle(final Locale locale){
		if(!this.resourcebundlemap.containsKey(locale)){
			ResourceBundle.getBundle(RESBUNDLENAME, locale);
			//Locale local=new Locale.Builder().setLanguage(locale).build();
			this.resourcebundlemap.put(locale.toString(), ResourceBundle.getBundle(RESBUNDLENAME, locale));
		}
		return this.resourcebundlemap.get(locale);
	}
	
	/**
	 * Returns the instance of this singleton class.
	 * @return the data instance
	 */
	public static Data getInstance(String requestPath){
		if(Data.instance==null){
			Data.instance=new Data(requestPath);
		}
		return Data.instance;
	}

	/**WebService to get GameSet names from this server.
	 * 
	 * @return the list of GameSets
	 */
	public List<GameSet> getGameSets(Locale locale) {
		Set<GameSet> res=new TreeSet<>();
		if(!this.languageToGameSetPath.containsKey(locale.getLanguage())){
			this.languageToGameSetPath.put(locale.getLanguage(), new LinkedList<Tuple<String,GameSet>>());
		}
		for(Tuple<String,GameSet> dataset:this.languageToGameSetPath.get(locale.getLanguage())){
			res.add(dataset.getTwo());
		}
		List<GameSet> result=new LinkedList<GameSet>(res);
		Collections.sort(result, new Comparator<GameSet>() {
            public int compare(GameSet s1, GameSet s2) {
                return s1.getTitle().compareTo(s2.getTitle());
            }
        });
		return result;
	}
	
	/**
	 * Gets the list of gamesets by language.
	 * @param locale the locale as String
	 * @return
	 * @throws FactoryConfigurationError 
	 * @throws XMLStreamException 
	 */
	public String getGameSetNamesByLanguage(final String locale) throws XMLStreamException, FactoryConfigurationError {
		File gameSetFolder=new File(GAMESETPATH+locale+File.separator);
		System.err.println(gameSetFolder.getAbsolutePath());
		System.err.println("Beep");
		StringWriter resultwriter=new StringWriter();
		XMLStreamWriter writer=XMLOutputFactory.newInstance().createXMLStreamWriter(resultwriter);
		writer.writeStartDocument();
		writer.writeStartElement("gamesetlist");
		for(Tuple<String,GameSet> gameset:this.languageToGameSetPath.get(locale)){
			writer.writeStartElement("set");
			writer.writeCharacters(Utils.prettyFormatFileName(gameset.getOne().substring(gameset.getOne().indexOf('_')+1,gameset.getOne().lastIndexOf('_'))));
			writer.writeEndElement();
		}
		writer.writeEndElement();
		writer.flush();
		return resultwriter.toString();
	}
	/**
	 * Gets a specific GameSet from the server in the designated locale.
	 * @param locale the locale as String
	 * @return
	 * @throws IOException 
	 */
	public String getGameSet(String locale,String name) throws IOException{
		String path=GAMESETPATH+locale+File.separator+locale+"_"+name+"_chars.xml";
		System.err.println(path);
		File gameSetFile=new File(path);
		if(!this.gamesetMap.containsKey(path) && gameSetFile.exists()){
			BufferedReader reader=new BufferedReader(new FileReader(gameSetFile));
			String temp;
			StringBuffer result=new StringBuffer(10000);
			while((temp=reader.readLine())!=null){
				result.append(temp);
			}
			reader.close();
			this.gamesetMap.put(path,result.toString());
		}
		return this.gamesetMap.get(path);
	}

	/**
	 * Gets the current playerlist from the server.
	 * @return the list as xml
	 * @throws XMLStreamException
	 * @throws FactoryConfigurationError
	 */
	public String getPlayersAsXML() throws XMLStreamException, FactoryConfigurationError {
		StringWriter strwriter=new StringWriter();
		XMLStreamWriter writer=XMLOutputFactory.newInstance().createXMLStreamWriter(strwriter);
		writer.writeStartDocument();
		writer.writeStartElement("players");
		writer.flush();
		writer.writeCharacters("\n");
		for(Player player:this.playeruuidToPlayer.values()){
			strwriter.write(player.toXML()+"\n");
		}
		writer.flush();
		writer.writeEndElement();
		writer.writeEndDocument();
		System.out.println(strwriter.toString());
		return strwriter.toString();
	}
	
	/**
	 * Gets the current playerlist from the server.
	 * @return the list as xml
	 * @throws XMLStreamException
	 * @throws FactoryConfigurationError
	 */
	public String getPlayersAsJSON() throws XMLStreamException, FactoryConfigurationError {
		Gson gson=new Gson();
		return gson.toJson(this.playeruuidToPlayer.values());
	}
	
	
	/**
	 * Adds a player to the server's player list if the player does not exist.
	 * @param player the player to add
	 * @throws IOException 
	 */
	public Boolean addGameSet(final GameSet gameset,final String locale) throws IOException{
		if(this.languageToGameSetPath.get(locale).contains(gameset.getGamesetid())){
			return false;
		}
		BufferedWriter writer=new BufferedWriter(new FileWriter(new File(gameSetFolder+gameset.getTitle()+"_chars.xml")));
		this.languageToGameSetPath.get(locale).add(new Tuple<String,GameSet>(gameset.getTitle(),gameset));
		return true;
	}
	/**
	 * Synchronizes exisiting gamesets with a gameset list.
	 * @param gameset the list of gamesets to synchronize
	 * @throws ParserConfigurationException 
	 * @throws SAXException 
	 * @throws IOException 
	 */
	public void synchronizeGameSet(final List<GameSet> gamesets) throws IOException, SAXException, ParserConfigurationException{
		GameSet originalset=new GameSet(new File(gamesets.get(0).getTitle()+"_chars.xml"),"");
	}
	
	
	/**
	 * Synchronizes exisiting players with a player list.
	 * @param players the players to synchronize
	 */
	public void synchronizePlayers(final List<Player> players){
		for(Player player:players){
				if(players.contains(player)){
					
				}
		}
	}
	
	/**
	 * Synchronizes exisiting players with a player list.
	 * @param players the players to synchronize
	 */
	public void synchronizePresets(final List<Preset> presets,final GameSet gameset){
		for(Preset preset:presets){
		}
	}
	
	/**
	 * Updates results of games played on clients to the server.
	 * @param games the games and their results
	 */
	public void updateGameResults(final List<Game> games){
		for(Game game:games){
			//this.uuidToPlayer.get(game.getPlayerid()).addGame(game);
		}
	}


	public Map<String, User> getLogindata() {
		return this.logindata;
	}


	public Map<String,Competition> getCompetitions() {
		// TODO Auto-generated method stub
		return this.competitionMap;
	}


	public byte[] generateGameResultPDF(String gameid,String printlang,String contextpath) throws URISyntaxException {
		System.out.println("Gameset "+gameid);
		System.out.println(contextpath+File.separator+"data"+File.separator+"result"+File.separator+gameid+".xml");
		System.out.println(new File(contextpath+File.separator+"data"+File.separator+"result"+File.separator+gameid+".xml").exists());
		System.out.println(new File(contextpath+File.separator+"xslt"+File.separator+printlang+File.separator+"gameresult.xsl").exists());

		// the XSL FO file
		File xsltfile = new File(contextpath+File.separator+"xslt"+File.separator+printlang+File.separator+"gameresult.xsl");
		// the XML file from which we take the name
		StreamSource source = new StreamSource(new File(contextpath+File.separator+"data"+File.separator+"result"+File.separator+gameid+".xml"));
		// creation of transform source
		StreamSource transformSource = new StreamSource(xsltfile);
		// create an instance of fop factory
		FopFactory fopFactory = FopFactory.newInstance(new URI("https://situx.ydns.eu"));
		// a user agent is needed for transformation
		FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
		// to store output
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();

		Transformer xslfoTransformer;
		try
		{
			TransformerFactoryImpl impl = 
					new TransformerFactoryImpl();


			xslfoTransformer = impl.newTransformer(transformSource);
	        System.out.println("Transformer Created");
			// Construct fop with desired output format
		        Fop fop;
			try
			{
				fop = fopFactory.newFop
					(MimeConstants.MIME_PDF, foUserAgent, outStream);
		                Result res = new SAXResult(fop.getDefaultHandler());
		        System.out.println("Fop Created");
				try
				{
					xslfoTransformer.transform(source, res);
			        System.out.println("Transformed");
					return outStream.toByteArray();

				}
				catch (TransformerException e) {
					try {
						throw e;
					} catch (TransformerException e1) {
						e1.printStackTrace();
					}
				}
			}
			catch (FOPException e) {
				e.printStackTrace();
			}
		}
		catch (TransformerConfigurationException e)
		{
				e.printStackTrace();
		}
		catch (TransformerFactoryConfigurationError e)
		{
			throw e;
		}

		  return null;

	}
	

	
	
}
