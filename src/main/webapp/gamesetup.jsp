<%@page import="de.tt.data.datamanagement.ManagePlayers"%>
<%@page import="de.tt.data.FileUploader"%>
<%@page import="de.tt.data.datamanagement.ManageActions"%>
<%@page import="de.tt.data.datamanagement.ManageGroups"%>
<%@page import="de.tt.data.datamanagement.ManageAbilities"%>
<%@page import="de.tt.data.datamanagement.ManageCards"%>
<%@page import="de.tt.data.User"%>
<%@page import="de.tt.Utils.Tuple"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ page import="de.tt.data.Data" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Karte" %>
  <%@ page import="com.example.LNDWA.cards.Group" %>
    <%@ page import="com.example.LNDWA.cards.Player" %>
  <%@ page import="com.example.LNDWA.cards.Ability" %>
  <%@ page import="com.example.LNDWA.cards.Action" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.Map" %>
  <%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
  <jsp:include page="locale.jsp" />  
<%
  	
Map<String,String[]> requestmap=request.getParameterMap();
                  request.setCharacterEncoding("UTF-8");
                  response.setCharacterEncoding("UTF-8");
                  Locale locale=(Locale)session.getAttribute("locale");
                  System.out.println(requestmap.toString());
                  Data data=Data.getInstance(request.getRealPath(request.getContextPath()));
                  User user=(User)session.getAttribute("login");
                  ManageGameSets managegs=ManageGameSets.getInstance(request.getPathTranslated());
                  Locale gamesetloc=(Locale)session.getAttribute("gamesetlang");
                  List<GameSet> gamesets=data
                		  .getGameSets(gamesetloc);
                  ManagePlayers manageplayers=ManagePlayers.getInstance(request.getContextPath());
                  List<Player> players=ManagePlayers.getInstance(request.getContextPath()).getAll();
                 
                  ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
                  
                  int i=0;
  %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="js/jquery-1.9.1.js"></script>
  <script src="js/jquery-ui.js"></script>
<script language="javascript">
//<![CDATA[ 
$(window).load(function(){
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#charimg').attr('src', e.target.result);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    $("#imginput").change(function(){
        readURL(this);
    });
    
    $("#gamesetlang").change(function(){
    	$.get( "<%=request.getContextPath()%>/rest/lndwa/gamesetlistjson/"+$('#gamesetlang').val(), function( data ) {
  		  $( ".result" ).html( data );
  		  var gamesett=JSON.parse(data);
  		  alert(gamesett)
  		  var result="<select id=\"gameset\">"
  		  for(var gameset in gamesett){
  			  result+="<option value=\""+gameset['gamesetid']+"\">"+gameset['title']+"</option>"
  		  }
  		  result+="</select>"
  			$("#gamesetlangtd").html(result)
        });
    });
    
    $("#gameset").change(function(){
    	
    	$.get( "<%=request.getContextPath()%>/rest/lndwa/gamesetjson/"+$('#gameset').val(), function( data ) {
    		  $( ".result" ).html( data );
    		  var gamesett=JSON.parse(data);
    		  var result="<ul id=\"sortable1\" class=\"connectedSortable\">"
    		  for(var cardi in gamesett['cards']){
    			  var card=gamesett['cards'][cardi]		  
    			  result+="<li class=\"ui-state-default\"><img src=\"<%=request.getContextPath()+"/data/gamesets/"
    		  +((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"%>"
    			  +gamesett["language"]+"_"+gamesett["gamesetid"]
      			+"/"+card["cardid"]+".png\" width=\"20\" height=\"20\"/>"+card['name']
      			+" ("+card['originalgroup']['groupIdentifier']+")"+
      				"<input type=\"hidden\" class=\"cardid\" name=\"cards\" value="+card['cardid']+"\"/>"+
      					"<input type=\"hidden\" class=\"balance\" value="+card['balance']+" name=\"balance\" id=\"balanceval\"/>"+
      					"<input onchange=\"setNewValues()\" type=\"number\" class=\"cardamount\" value=\"1\""+ 
      					"name=\"cardamount\" min=\""+card['minamount']+"\" max=\""+card['maxamount']+"\" required/></li>" 
      					

      			
      			
      			
    		  }
    		  result+="</ul>"
    		  $('#cardtd').html(result)
    				  $( "#sortable1, #sortable2" ).sortable({

    				    }).disableSelection();
    				    $("#sortable1").sortable({
    				        connectWith: ".connectedSortable",
    				    	receive: function(event, ui) {
    				       		ui.item.children( ".cardid" ).prop('name', 'cards');
    				    		ui.item.children( ".cardamount" ).prop('name', 'cardamount');
    				    		ui.item.children( ".balance" ).prop('name', 'balance');
    				       		var i=0;
    				        	$( ".cardamount" ).each(function( index ) {
    				        		if($(this).attr("name")=="cardamount")
    				        			i+=parseInt($(this).attr("value"));
    				        		});
    				  		  	document.getElementById("player").value=i;
    				        	i=0;
    				        	$( ".balance" ).each(function( index ) {
    				        		if($(this).attr("name")=="balance")
    				        			i+=parseInt($(this).attr("value"));
    				        		});
    				  		  	document.getElementById("balancetotal").value=i;
    					    }
    				    }).disableSelection();
    		})
    	
    	$('#gameset').val()
    });
    
    $( "#sortable1, #sortable2" ).sortable({

    }).disableSelection();
    $("#sortable1").sortable({
        connectWith: ".connectedSortable",
    	receive: function(event, ui) {
       		ui.item.children( ".cardid" ).prop('name', 'cards');
    		ui.item.children( ".cardamount" ).prop('name', 'cardamount');
    		ui.item.children( ".balance" ).prop('name', 'balance');
       		var i=0;
        	$( ".cardamount" ).each(function( index ) {
        		if($(this).attr("name")=="cardamount")
        			i+=parseInt($(this).attr("value"));
        		});
  		  	document.getElementById("player").value=i;
        	i=0;
        	$( ".balance" ).each(function( index ) {
        		if($(this).attr("name")=="balance")
        			i+=parseInt($(this).attr("value"));
        		});
  		  	document.getElementById("balancetotal").value=i;
	    }
    }).disableSelection();
    $("#sortable2").sortable({
        connectWith: ".connectedSortable",
    	receive:function(event, ui) {
    		ui.item.children( ".cardid" ).prop('name', 'gamesetcards');
    		ui.item.children( ".cardamount" ).prop('name', 'gamesetcardamount');
    		ui.item.children( ".balance" ).prop('name', 'gamesetbalance');
       		var i=0;
        	$( ".cardamount" ).each(function( index ) {
        		if($(this).attr("name")=="cardamount")
        			i+=parseInt($(this).attr("value"));
        		});
  		  	document.getElementById("player").value=i;
        	i=0;
        	$( ".balance" ).each(function( index ) {
        		if($(this).attr("name")=="balance")
        			i+=parseInt($(this).attr("value"));
        		});
  		  	document.getElementById("balancetotal").value=i;
	    }
    })
    
});//]]>
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("charinfo")%></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
   <style>
  #sortable1, #sortable2 { list-style-type: none; margin: 0; padding: 0 0 2.5em; float: left; margin-left:auto; margin-right:auto; width:85% }
  #sortable1 li, #sortable2 li { margin: 0 5px 5px 5px; padding: 5px; font-size: 1.2em; width: 100%; }
  </style>
</head>
<body <%=request.getParameter("file")!=null?"onload=\"setresult()\"":" " %>>
<h1><%=bundle.getString("gamesetup") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<form>
<table>
<tr><th>Gameset</th><th><select id="gameset">
<%for(GameSet gameset:gamesets){%>
<option value="<%=gameset.getGamesetid()%>"><%=gameset.getTitle()%></option>
<%}%></select></th><th id="gamesetlangtd"><select id="gamesetlang" name="gamesetlang">
<%List<Locale> list = Arrays.asList(SimpleDateFormat.getAvailableLocales());
Set<Tuple<String,String>> locales=new TreeSet<Tuple<String,String>>();
for(Locale loc:list){
	locales.add(new Tuple<String,String>(loc.getDisplayLanguage(locale),loc.getLanguage()));
}
for(Tuple<String,String> loc:locales){ %>
<option value="<%=loc.getTwo()%>"<%=loc.getTwo().equals(gamesetloc.getLanguage())?"selected":" " %>>
<%=loc.getOne() %></option>
<%} %>
</select></th></tr>
<tr><th>Amount of Players: <span id="amountofplayers"/></th><th>Amount of Cards: <span id="amountofcards"/></th>
<th>Balance Value: <span id="balancevalue"/></th><th>Needed Extra Cards: <span id="neededextracards"/></th></tr>
<tr><th>Available Cards</th><th>Chosen Cards</th><th>Available Players</th><th>Extra cards</th></tr>
<tr><td id="cardtd"><ul id="sortable1" class="connectedSortable">
<%for(Karte card:gamesets.get(0).getCards()){	GameSet gameset=gamesets.get(0);%>

     <li class="ui-state-default">
     <img border="1" src="<%=request.getContextPath()+"/data/gamesets/"
     +((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+
    		 gameset.getLanguage()+"_"+gameset.getGamesetid()
    			+"/"+card.getCardid()+".png"%>" width="20" height="20"/>
    			<%=card.getName()+"("+card.getGroup().getGroupIdentifier()+")" %>
		<input type="hidden" class="cardid" name="cards" value="<%=card.getCardid()%>"/>
		<input type="hidden" class="balance" value="<%=card.getBalancevalue() %>" name="balance" id="balanceval"/>
		<input onchange="setNewValues()" type="number" class="cardamount" value="" name="cardamount" min="<%=card.getMinamount() %>" <%=card.getMaxamount().equals(-1)?"":"max=\""+card.getMaxamount()+"\"" %> required/></li>
  <%} %>
</ul></td><td><ul id="sortable2" class="connectedSortable"></ul></td>
<td><select id="player" multiple><%
for(Player player:players){%>
<option value="<%=player.getPlayerid()%>"><%=player.getFirstname()%> <%=player.getName()%></option>
<%}%></select></td><td></td>
</tr></table>

<button type="submit">Start Game</button>
</form>
</body></html>