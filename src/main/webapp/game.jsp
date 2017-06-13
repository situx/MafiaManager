<%@page import="java.util.Locale"%>
<%@page import="de.tt.data.datamanagement.ManagePlayers"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <jsp:include page="locale.jsp" />
  <%
  	ManagePlayers manage=ManagePlayers.getInstance(request.getContextPath());
  Player player=manage.get(request.getParameter("player"));
    ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
  %> 
<title><%=bundle.getString("player") %></title>
</head>
<%@ page import="com.example.LNDWA.cards.Player" %>
<%@ page import="com.example.LNDWA.cards.Game" %>
<%@ page import="de.tt.view.Ranking" %>
<%@ page import="java.util.ResourceBundle" %>
<body>
<h1><%=player.getFirstname()%> <%=player.getName() %> - <%=bundle.getString("game") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<tr><th><%=bundle.getString("game") %></th><th><%=bundle.getString("character") %></th><th><%=bundle.getString("points") %></th></tr>
<%int i=0;for(Game game:player.getGames()){%>
    <tr <%=i%2==0?"class=\"alt\"":"" %>>      
    <td><%=game.getGameid()%></td>
    <td><%=game.getCharacter()%></td>
    <td><%=game.getPoints() %></td>
	</tr>
<%}%>
<tr><th></th><th></th><th></th></tr>
</table>
</body>
</html>