<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="de.tt.view.Ranking" %>
<%@ page import="de.tt.data.Data" %>
<%@ page import="com.example.LNDWA.cards.Player" %>
  <%@ page import="java.util.ResourceBundle" %>
  <jsp:include page="locale.jsp" />  
  <%ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("ranking") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<h1><%=bundle.getString("ranking") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<tr><th><%=bundle.getString("rank") %></th><th><%=bundle.getString("players") %></th><th>Last Game (Points)</th><th><%=bundle.getString("points") %></th></tr>
<%Data data=Data.getInstance(request.getContextPath());
int i=0;for(Player player:new Ranking(request.getContextPath()).getPlayerMap()){%>
    <tr <%=i%2==0?"class=\"alt\"":"" %>><td><%=i+1 %>.</td>     
    <td><a <%="href=\"game.jsp?player="+player.getPlayerid()+"\""%>><%=player.getFirstname()%> <%=player.getName()%></a></td>
    <td><%=player.getGames().isEmpty()?bundle.getString("nogame"):player.getGames().get(player.getGames().size()-1).toString() %></td><td><%=player.getTotal()%></td></tr>
<%i++;}%>
<tr><th class="footer"></th>
<th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>
</table>

</body>
</html>