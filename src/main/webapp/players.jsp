<%@page import="java.util.Locale"%>
<%@page import="de.tt.data.datamanagement.ManagePlayers"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page import="com.example.LNDWA.cards.Player" %>
     <%@ page import="de.tt.data.User" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.List" %>
  <%@ page import="java.util.Map" %>
    <jsp:include page="locale.jsp" /> 
    <%
     	ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
                   User user=(User)session.getAttribute("login");
                   request.setCharacterEncoding("UTF-8");
                   response.setCharacterEncoding("UTF-8");
                   Map<String,String[]> requestmap=request.getParameterMap();
                   ManagePlayers manage=ManagePlayers.getInstance(request.getContextPath());

                   System.out.println(requestmap);
                   if(user!=null && (user.getAdmin() || user.getEdit())){
                   	System.out.println("User yeah!");
                   	if(requestmap.containsKey("addplayerex")){
                   		System.out.println("Contains AddPlayerEx");
               	if(requestmap.containsKey("firstname") && requestmap.containsKey("lastname")){
               		System.out.println("Add player");
               		manage.add(new Player(request.getParameter("lastname"),request.getParameter("firstname")));
               		}
               	}else if(requestmap.containsKey("editplayerex")){
               		System.out.println("Contains editplayerex");
               		if(requestmap.containsKey("firstname") && requestmap.containsKey("lastname") && requestmap.containsKey("player")){
               	System.out.println("Update player");
               	manage.update(request.getParameter("player"), new Player(request.getParameter("lastname"),request.getParameter("firstname")));
               		}
               	}
               }
                   List<Player> playerlist=ManagePlayers.getInstance(request.getContextPath()).getAll();
     %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
<title><%=bundle.getString("players") %></title>
</head>
<body>
<h1><%=bundle.getString("players") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<tr><th><%=bundle.getString("players") %></th><th>Last Game (Points)</th>
<th><%=bundle.getString("points") %></th><c:if test="<%=user!=null && user.getAdmin()%>"><th><%=bundle.getString("options") %></c:if></tr>
<%
int i=0;for(Player player:playerlist){%>
    <tr <%=i%2==0?"class=\"alt\"":"" %>>    
    <td><a <%="href=\"game.jsp?player="+player.getPlayerid()+"\""%>><%=player.getFirstname()%> <%=player.getName()%></a></td>
    <td><%=player.getGames().isEmpty()?bundle.getString("nogame"):player.getGames().get(player.getGames().size()-1).toString() %></td>
    <td><%=player.getTotal()%></td>
    <c:if test="<%=user!=null && (user.getAdmin() || user.getEdit())%>"><td>
		<a href="editplayer.jsp?player=<%=player.getPlayerid()%>"><%=bundle.getString("editplayer") %></a></td></c:if></tr>
<%i++;}%>
<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer"><form action="editplayer.jsp" method="post"><button type="submit"><%=bundle.getString("addplayer") %></button></form></th></c:if>
<th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>
</table>
	
</body>
</html>