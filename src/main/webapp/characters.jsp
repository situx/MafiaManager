<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@page import="de.tt.data.FileUploader"%>
<%@page import="java.util.Locale"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Collections"%>
<%@page import="de.tt.data.datamanagement.ManageGroups"%>
<%@page import="de.tt.data.datamanagement.ManageCards"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
             <%@ page import="de.tt.data.Data" %>
             <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Karte" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.Comparator" %>
  <%@ page import="java.util.Map" %>
    <%@ page import="java.util.List" %>
      <%@ page import="java.util.LinkedList" %>
      <jsp:include page="locale.jsp" />  
<%
  	Data data=Data.getInstance(request.getRealPath(request.getContextPath()));
          Map<String,String[]> parametermap=request.getParameterMap();
          request.setCharacterEncoding("UTF-8");
          response.setCharacterEncoding("UTF-8");
          User user=(User)session.getAttribute("login");
          ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
          GameSet gameset;
          if(parametermap.containsKey("gameset")){
          	gameset=data.getGamesetUUIDToGameSet().get(request.getParameter("gameset"));
          	System.out.println(gameset.getCards());
          	/*Collections.sort(gameset.getCards(), new Comparator<Karte>() {
          	    public int compare(Karte s1, Karte s2) {
          	        return s1.getName().compareTo(s2.getName());
          	    }
          	});*/
          	System.out.println(parametermap.toString());
          	Karte newcard=new Karte();
          	Map<String,String> frequestmap;
          	if(user!=null && user.getAdmin()){
          		frequestmap=new FileUploader().uploadFiles(request.getRealPath(request.getContextPath())+File.separator+"data"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator,
          		"gameset-upload",gameset.getLanguage()+File.separator+gameset.getLanguage()+"_"+gameset.getGamesetid(),request.getParameter("card")+".png",pageContext.getServletContext(), (Locale)session.getAttribute("gamesetlang"), request);
          		System.out.println(frequestmap.toString());
          		if(parametermap.containsKey("rearrangecharsex") && parametermap.containsKey("cards")){
          	List<Karte> newcardlist=new LinkedList<Karte>();
          	String[] carduuids=request.getParameterValues("cards");
          	String[] actions=request.getParameterValues("actions");
          	System.out.println(carduuids[0]);
          	int i=0;
          	for(String uuid:carduuids){
          		for(String actionid:actions){
          			gameset.getUuidToCard().get(uuid).setPosition(i++);
          			System.out.println(gameset.getUuidToCard().get(uuid).getName());
          			newcardlist.add(gameset.getUuidToCard().get(uuid));
          		}
          	}
          	gameset.setCards(newcardlist);
          		}else if(frequestmap.containsKey("addcharex") && frequestmap.containsKey("gameset") && frequestmap.containsKey("card")){
          	newcard.setCardid(request.getParameter("card"));
          	newcard.setBalancevalue(Integer.valueOf(frequestmap.get("balancevalue")));
          	newcard.setCalleveryone(Boolean.valueOf(frequestmap.get("calleveryone")));
          	newcard.setCurrentamount(Integer.valueOf(frequestmap.get("minamount")));
          	newcard.setMinamount(Integer.valueOf(frequestmap.get("minamount")));
          	newcard.setMaxamount(Integer.valueOf(frequestmap.get("maxamount")));
          	newcard.setDeadchars(Boolean.valueOf(frequestmap.get("deadchars")));
          	newcard.setDescription(frequestmap.get("description"));
          	newcard.setImg(newcard.getCardid()+".png");
          	newcard.setDeathdelay(Integer.valueOf(frequestmap.get("deathdelay")));
          	newcard.setExtra(Integer.valueOf(frequestmap.get("extra")));
          	newcard.setFixeddeath(Integer.valueOf(frequestmap.get("fixeddeath")));
          	newcard.setGroup(ManageGroups.getInstance(request.getContextPath()).get(gameset.getGamesetid(), frequestmap.get("group")));
          	newcard.setName(frequestmap.get("name"));
          	newcard.setNopoints(Boolean.valueOf(frequestmap.get("nopoints")));
          	newcard.setPosition(Integer.valueOf(frequestmap.get("position")));
          	newcard.setRound(Integer.valueOf(frequestmap.get("round")));
          	newcard.setWinningAlive(Integer.valueOf(frequestmap.get("winningalive")));
          	newcard.setWinningDead(Integer.valueOf(frequestmap.get("winningdead")));
          	newcard.setWinsalone(Boolean.valueOf(frequestmap.get("winsalone")));
          	ManageCards.getInstance(request.getRealPath(request.getContextPath())).add(request.getParameter("gameset"), newcard);
              		//ManageGameSets.getInstance().saveGameSet(gameset.getGamesetid());
          		}else if(frequestmap.containsKey("editcharex") && frequestmap.containsKey("gameset") && frequestmap.containsKey("card")){		
          	newcard=ManageCards.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"));			
          	newcard.setBalancevalue(Integer.valueOf(frequestmap.get("balancevalue")));
          	newcard.setCalleveryone(Boolean.valueOf(frequestmap.get("calleveryone")));
          	newcard.setCurrentamount(Integer.valueOf(frequestmap.get("minamount")));
          	newcard.setMinamount(Integer.valueOf(frequestmap.get("minamount")));
          	newcard.setMaxamount(Integer.valueOf(frequestmap.get("maxamount")));
          	newcard.setDeadchars(Boolean.valueOf(frequestmap.get("deadchars")));
          	newcard.setDescription(frequestmap.get("description"));
          	newcard.setDeathdelay(Integer.valueOf(frequestmap.get("deathdelay")));
          	newcard.setExtra(Integer.valueOf(frequestmap.get("extra")));
          	newcard.setName(frequestmap.get("name"));
          	newcard.setImg(newcard.getCardid()+".png");
          	newcard.setFixeddeath(Integer.valueOf(frequestmap.get("fixeddeath")));
          	newcard.setGroup(ManageGroups.getInstance(request.getContextPath()).get(gameset.getGamesetid(), frequestmap.get("group")));
          	newcard.setNopoints(Boolean.valueOf(frequestmap.get("nopoints")));
          	newcard.setPosition(Integer.valueOf(frequestmap.get("position")));
          	newcard.setRound(Integer.valueOf(frequestmap.get("round")));
          	newcard.setWinningAlive(Integer.valueOf(frequestmap.get("winningalive")));
          	newcard.setWinningDead(Integer.valueOf(frequestmap.get("winningdead")));
          	newcard.setWinsalone(Boolean.valueOf(frequestmap.get("winsalone")));
          	newcard.setCardid(frequestmap.get("card"));
          	System.out.println(frequestmap.get("gameset")+" - "+frequestmap.get("card")+" - "+newcard);
          	ManageCards.getInstance(request.getContextPath()).update(frequestmap.get("gameset"),frequestmap.get("card"), newcard);
              		ManageGameSets.getInstance(request.getRealPath(request.getContextPath())).saveGameSet(gameset.getGamesetid());
          		}else if(parametermap.containsKey("removechar") && parametermap.containsKey("gameset") && parametermap.containsKey("card")){
          	ManageCards.getInstance(request.getRealPath(request.getContextPath())).remove(request.getParameter("gameset"), request.getParameter("card"));
          		}
          	}
          }else{
          	gameset=new GameSet();
          }
  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=gameset.getTitle()%> - <%=bundle.getString("charview") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<h1><%=gameset.getTitle()%> - <%=bundle.getString("charview") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test='<%=parametermap.containsKey("gameset")%>'>
<c:choose>
      <c:when test="<%=gameset.getCards().isEmpty()%>">
      <table height="100%">
      <tr><td style="font-weight:bold;font-size:25pt;text-align:center">
      <%=bundle.getString("nocards") %></td></tr>
      <tr><th class="footer"><c:if test="<%=user!=null && user.getAdmin()%>">
      <form action="editcharacter.jsp?gameset=<%=gameset.getGamesetid() %>" method="post">
      <button type="submit"><%=bundle.getString("addchar") %></button></form></c:if></th></table>
      </c:when>
      <c:otherwise>
      <table><tr><th><%=bundle.getString("image") %></th><th><%=bundle.getString("name") %></th>
      <th><%=bundle.getString("description") %></th>
      <c:if test="<%=user!=null && user.getAdmin()%>"><th><%=bundle.getString("options") %></th></c:if></tr>
<%int i=0;for(Karte card:gameset.getCards()){ %>
<tr <%=i%2==0?"class=\"alt\"":"" %>><td><img src="<%=request.getContextPath()+File.separator+"data"+File.separator+"gamesets"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator+gameset.getLanguage()+"_"+gameset.getGamesetid()
		+File.separator+card.getCardid()+".png"%>"/></td><td><%="<a href=\"character.jsp?gameset="+gameset.getGamesetid()+"&card="+card.getCardid()+"\">"+card.getName()+"</a> ("+card.getGroup()+")" %></td>
		<td><%=card.getDescription() %></td>
		<c:if test="<%=user!=null && user.getAdmin()%>">
		<td><form action="editcharacter.jsp?gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>" method="post">
		<button type="submit"><%=bundle.getString("editchar") %></button></form><br>
		<form method="post" action="characters.jsp?removechar=1&gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>">
		<button type="submit"><%=bundle.getString("removechar") %></button></form></td></c:if></tr>
<%i++;} %>

<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer">
<form method="post" action="editcharacter.jsp?gameset=<%=request.getParameter("gameset")%>"><button type="submit"><%=bundle.getString("addchar") %></button></form></th></c:if>
<th class="footer"><form method="post" action="rearrangecharacters.jsp?gameset=<%=request.getParameter("gameset")%>"><button type="submit"><%=bundle.getString("rearrangecharacters") %></button></form></th><th class="footer"></th><th class="footer"></th></tr>

</table>
      </c:otherwise>
</c:choose>
</c:when>
<c:otherwise>
<table height="100%">
<tr><td><%=bundle.getString("nogameset") %></td></tr>
<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer">
<form method="post" action="editcharacter.jsp?gameset=<%=request.getParameter("gameset")%>"><button type="submit"><%=bundle.getString("addchar") %></button></form></th>
<th class="footer"><form method="post" action="rearrangecharacters.jsp?gameset=<%=request.getParameter("gameset")%>"><button type="submit"><%=bundle.getString("rearrangecharacters") %></button></form></th></c:if><th class="footer"></th><th class="footer"></th></tr>

</table>
</c:otherwise>
</c:choose>

</body>
</html>