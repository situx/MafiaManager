<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <jsp:include page="locale.jsp" /> 
<title>Player</title>
</head>
<%@ page import="com.example.LNDWA.cards.Player" %>
<%@ page import="com.example.LNDWA.cards.Game" %>
<%@ page import="de.tt.view.Ranking" %>
<%@ page import="java.util.ResourceBundle" %>
<body>
<% Ranking ranking;
if(session.getAttribute("ranking")!=null){
	ranking=(Ranking)session.getAttribute("ranking");
}else{
	ranking=new Ranking(request.getContextPath());
}
Player player=ranking.getUUIDToPlayer().get(request.getParameter("player"));
  ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));%>
<h1><%=player.getFirstname()%> <%=player.getName() %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<tr><th>Game</th><th>Character</th><th>Score</th><th>Options</th></tr>
<%int i=0;for(Game game:player.getGames()){%>
    <tr <%=i%2==0?"class=\"alt\"":"" %>>      
    <td><%=player.getFirstname()%></td>
    <td><%=player.getName()%></td>
    <td><%=player.getGames().isEmpty()?bundle.getString("nogame"):player.getGames().get(player.getGames().size()-1).points %></td>
	</tr>
<%}%>
</table>
</body>
</html>