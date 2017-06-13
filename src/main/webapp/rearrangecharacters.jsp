<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Karte" %>
  <%@ page import="com.example.LNDWA.cards.Ability" %>
    <%@ page import="com.example.LNDWA.cards.Action" %>
  <%@ page import="java.util.ResourceBundle" %>
    <%@ page import="de.tt.data.User" %>
      <%@ page import="de.tt.data.Data" %>
                  <%@ page import="de.tt.Utils.Tuple" %>
            <%@ page import="java.util.Comparator" %>
            <%@ page import="java.util.Collections" %>
            <%@ page import="java.util.TreeMap" %>
        <%@ page import="de.tt.data.datamanagement.ManageGameSets" %>
  <%@ page import="java.util.Map" %>
  <jsp:include page="locale.jsp" />  
  <%
    	Data data=Data.getInstance(request.getContextPath());
    ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
    User user=(User)session.getAttribute("login");
    request.setCharacterEncoding("UTF-8");
    Map<String,String[]> requestmap=request.getParameterMap();
    GameSet gameset=new GameSet();
    if(requestmap.containsKey("gameset")){
    	gameset=ManageGameSets.getInstance(request.getContextPath()).get(request.getParameter("gameset"));	
    }
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
 <link rel="stylesheet" href="style/jquery-ui.css">
   <script src="js/jquery-1.9.1.js"></script>
  <script src="js/jquery-ui.js"></script>
  <script>
  $(function() {
    $( "#sortable" ).sortable();
    $( "#sortable" ).disableSelection();
  });
  </script>
<title><%=(user!=null && (user.getEdit() || user.getAdmin()))?gameset.getTitle()+" "+bundle.getString("rearrangecharacters"):gameset.getTitle()+" "+bundle.getString("characterorder") %></title>
</head>
<body>
<h1><%=(user!=null && (user.getEdit() || user.getAdmin()))?gameset.getTitle()+" "+bundle.getString("rearrangecharacters"):gameset.getTitle()+" "+bundle.getString("characterorder") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && (user.getEdit() || user.getAdmin()) %>">
<form action="characters.jsp" method="post">
<table><tr><th><%=bundle.getString("rearrangechartitle") %></th></tr><tr><td>
<ul id="sortable">
<%
Collections.sort(gameset.getCards(), new Comparator<Karte>() {
    public int compare(Karte s1, Karte s2) {
        return s1.getPosition().compareTo(s2.getPosition());
    }
});
Map<Integer,Tuple<Karte,Action>> posToCardAction=new TreeMap<>();
for(Karte card:gameset.getCards()){
	if(card.getActionlist().isEmpty()){
		posToCardAction.put(card.getPosition(),new Tuple<Karte,Action>(card,null));
	}else{
		for(Action action:card.getActionlist().values()){
			posToCardAction.put(action.getPosition(),new Tuple<Karte,Action>(card,action));
		}
	}
}
for(Integer pos:posToCardAction.keySet()){
	System.out.println(pos+" - "+posToCardAction.get(pos));
Karte card=posToCardAction.get(pos).getOne();
Action action=posToCardAction.get(pos).getTwo();
if(action==null){
%>
	<li <%=(card.getRound()!=(-1))?("class=\"ui-state-default\""):("style=\"background-color:grey\"") %>>
	<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
	<img border="1" src="<%=request.getContextPath()+"/data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
	+"/"+card.getCardid()+".png"%>" width="20" height="20"/><%=card.getName() %>
			<input type="hidden" name="cards" value="<%=card.getCardid()%>"/>
			<input type="hidden" name="actions" value="0"/></li>
<%}else{%>
<li <%=(card.getRound()==(-1))?("style=\"background-color:grey\"") :((card.getRound()==0)?("class=\"ui-state-default\""):("style=\"background-color:#BBBBBB\""))%>>
	<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
	<img border="1" src="<%=request.getContextPath()+"/data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
			+"/"+card.getCardid()+".png"%>" width="20" height="20"/><%=card.getName()+" (" %><%=(action.getRound()==(-1))?("On Death: ") :((action.getRound()==0)?(bundle.getString("everyRound")+": "):(bundle.getString("round")+" "+action.getRound()+": "))%>
			<%=action.getTitle()+")" %>
		<input type="hidden" name="cards" value="<%=card.getCardid()%>"/>
			<input type="hidden" name="actions" value="<%=action.getId()%>"/></li>
<%}} %>
</ul></td></tr>
<tr><th class="footer" colspan="2">
<input type="hidden" value="1" name="rearrangecharsex"/>
<input type="hidden" value="<%=gameset.getGamesetid() %>" name="gameset"/>
<button type="submit"><%=bundle.getString("saveorder") %></button></th></tr>
</table>
</form>
</c:when>
<c:otherwise>
<table>
<%
Collections.sort(gameset.getCards(), new Comparator<Karte>() {
    public int compare(Karte s1, Karte s2) {
        return s1.getPosition().compareTo(s2.getPosition());
    }
});
Map<Integer,Tuple<Karte,Action>> posToCardAction=new TreeMap<>();
for(Karte card:gameset.getCards()){
	if(card.getActionlist().isEmpty()){
		posToCardAction.put(card.getPosition(),new Tuple<Karte,Action>(card,null));
	}else{
		for(Action action:card.getActionlist().values()){
			posToCardAction.put(action.getPosition(),new Tuple<Karte,Action>(card,action));
		}
	}
}
for(Integer pos:posToCardAction.keySet()){
	System.out.println(pos+" - "+posToCardAction.get(pos));
Karte card=posToCardAction.get(pos).getOne();
Action action=posToCardAction.get(pos).getTwo();
if(action==null){%>
<tr><td>
<img border="1" src="<%="data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getSourcefile().substring(gameset.getSourcefile().lastIndexOf('/')+1,gameset.getSourcefile().lastIndexOf('_'))
		+"/"+card.getCardid()+".png"%>" width="20" height="20"/><%=card.getName() %>
		<input type="hidden" name="cards" value="<%=card.getCardid()%>" /><input type="hidden" name="actions" value="0"/></td></tr>
<%}else{%>
<tr><td>
<img border="1" src="<%="data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getSourcefile().substring(gameset.getSourcefile().lastIndexOf('/')+1,gameset.getSourcefile().lastIndexOf('_'))
		+"/"+card.getCardid()+".png"%>" width="20" height="20"/><%=card.getName()+" ("+action.getTitle()+")" %>
		<input type="hidden" name="cards" value="<%=card.getCardid()%>"/><input type="hidden" name="actions" value="<%=action.getId()%>"/></td></tr>
<% }} %>
<tr><th></th></tr>
</table>
</c:otherwise>
</c:choose>
</body>
</html>