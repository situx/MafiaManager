<%@page import="java.util.Locale"%>
<%@page import="java.io.File"%>
<%@page import="de.tt.data.Data"%>
<%@page import="de.tt.data.User"%>
<%@page import="com.example.LNDWA.cards.Karte"%>
<%@page import="com.example.LNDWA.cards.GameSet"%>
<%@page import="com.example.LNDWA.cards.Preset"%>
<%@page import="java.util.Map"%>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
      <%@ page import="java.util.ResourceBundle" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <jsp:include page="locale.jsp" /> 
<%ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
Map<String,String[]> parametermap=request.getParameterMap();
GameSet gameset=new GameSet();
Preset preset=new Preset();
if(parametermap.containsKey("gameset") && parametermap.containsKey("preset")){
	gameset=Data.getInstance(request.getContextPath()).getGamesetUUIDToGameSet().get(request.getParameter("gameset"));
	preset=gameset.getPresets().get(request.getParameter("preset"));
}else if(parametermap.containsKey("gameset")){
	gameset=Data.getInstance(request.getContextPath()).getGamesetUUIDToGameSet().get(request.getParameter("gameset"));
}

System.out.println(parametermap.toString());
Karte newcard=new Karte();
User user=(User)session.getAttribute("login");
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
int i=1;%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("editpreset") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
 <link rel="stylesheet" href="style/jquery-ui.css">
  
 <script src="js/jquery-1.10.2.js"></script>
  <script src="js/jquery-ui.js"></script>
  <style>
  #sortable1, #sortable2 { list-style-type: none; margin: 0; padding: 0 0 2.5em; float: left; margin-left:auto; margin-right:auto; width:85% }
  #sortable1 li, #sortable2 li { margin: 0 5px 5px 5px; padding: 5px; font-size: 1.2em; width: 100%; }
  </style>
    <script>
  $(function() {
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
  });
  
  function setNewValues(){
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
  </script>
</head>
<body>
<h1><%=bundle.getString("editpreset") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<form method="post" action="preset.jsp">
<table><tr><th colspan="2"><%=bundle.getString("preset") %></th><th><%=bundle.getString("gameset") %></th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td width="25%">
<%=bundle.getString("presettitle") %></td><td width="25%">
<input type="text" name="presettitle" value="<%=preset.getPresetName()%>"/></td><td width="50%"></td></tr>

<tr <%=i++%2==0?"class=\"alt\"":"" %>>
<td width="25%"><%=bundle.getString("total") %>
<input type="number" name="player" id="player" disabled value="<%=preset.getPlayer()%>"/>
</td>
<c:if test="<%=true %>"><td><%=bundle.getString("balance") %>

<input type="number" name="balancetotal" id="balancetotal" disabled value="<%=gameset.getToPlayers()%>"/>
</td></c:if><td></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td align="center" width="50%" colspan="2">
<ul id="sortable1" class="connectedSortable">
<%for(Karte card:gameset.getCards()){%>
   <c:if test="<%=preset.getCardlist().keySet().contains(card.getCardid()) %>">
     <li class="ui-state-default">
     <img border="1" src="<%=request.getContextPath()+"/data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
    			+"/"+card.getCardid()+".png"%>" width="20" height="20"/><%=card.getName()+"("+card.getGroup().getGroupIdentifier()+")" %>
		<input type="hidden" class="cardid" name="cards" value="<%=card.getCardid()%>"/>
		<input type="hidden" class="balance" value="<%=card.getBalancevalue() %>" name="balance" id="balanceval"/>
		<input onchange="setNewValues()" type="number" class="cardamount" value="<%=preset.getCardlist().get(card.getCardid())%>" name="cardamount" min="<%=card.getMinamount() %>" <%=card.getMaxamount().equals(-1)?"":"max=\""+card.getMaxamount()+"\"" %> required/></li>
   </c:if>
  <%} %>
</ul>
</td><td align="center" width="50%"> 
<ul id="sortable2" class="connectedSortable">
<%for(Karte card:gameset.getCards()){%>
   <c:if test="<%=!preset.getCardlist().keySet().contains(card.getCardid()) %>">
     <li class="ui-state-default">
     <img border="1" src="<%=request.getContextPath()+"/data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
		+"/"+card.getCardid()+".png"%>" width="20" height="20"/><%=card.getName()+"("+card.getGroup().getGroupIdentifier()+")" %>
				<input type="hidden" class="cardid" name="gamesetcards" value="<%=card.getCardid()%>"/>
				<input type="hidden" class="balance" value="<%=card.getBalancevalue() %>" name="gamesetbalance" id="balanceval"/>
		<input onchange="setNewValues()" type="number" class="cardamount" name="gamesetcardamount" min="<%=card.getMinamount() %>" <%=card.getMaxamount().equals(-1)?"":"max=\""+card.getMaxamount()+"\"" %> value="<%=preset.getCardlist().get(card.getCardid())==null?1:preset.getCardlist().get(card.getCardid())%>" required/></li>
   </c:if>
  <%} %>
</ul></td></tr>
</table>
<input type="hidden" name="<%=parametermap.containsKey("preset")?"editpresetex":"addpresetex" %>" value="1"/>
<input type="hidden" value="<%=preset.getPresetId()%>" name="preset"/>
<input type="hidden" value="<%=gameset.getGamesetid()%>" name="gameset"/>

</form>
<table>
<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer">
<form method="post" action="preset.jsp?gameset=<%=request.getParameter("gameset")%>">
<button type="submit"><%=bundle.getString("savepreset") %></button></form></th></c:if>
<th class="footer"></th></tr>
</table>
</c:when>
<c:otherwise>
<table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr></table></c:otherwise>
</c:choose>

</body>
</html>