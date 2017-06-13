<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  	<%@ page import="de.tt.data.datamanagement.ManagePlayers" %>
  	<%@ page import="de.tt.data.User" %>
  	<%@ page import="com.example.LNDWA.cards.Player" %>
      <%@ page import="java.util.ResourceBundle" %>
      <%@ page import="java.util.Map" %>
        <jsp:include page="locale.jsp" /> 
<%
 	ManagePlayers manage=ManagePlayers.getInstance(request.getContextPath());
 Player player=new Player();
 User user=(User) session.getAttribute("login");
 request.setCharacterEncoding("UTF-8");
 response.setCharacterEncoding("UTF-8");
 Map<String,String[]> requestmap=request.getParameterMap();
 ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
 if(requestmap.containsKey("player")){
 	player=manage.get(request.getParameter("player"));
 }
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Options</title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<h1><%=requestmap.containsKey("player")?bundle.getString("editplayer"):bundle.getString("addplayer") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<form action="players.jsp" method="post">
<table>
<%int i=0; %>
<tr><th>Property</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("firstname") %></td><td><input type="text" name="firstname" value="<%=player.getFirstname()%>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("playername") %></td><td><input type="text" name="lastname" value="<%=player.getName()%>" required/></td></tr>
<tr><th class="footer"><button type="submit"><%=bundle.getString("saveplayer") %></button>
<input type="hidden" name="player" value="<%=player.getPlayerid()%>"/>
<input type="hidden" name="<%=requestmap.containsKey("player")?"editplayerex":"addplayerex" %>" value="1"/></th><th class="footer"></th></tr>
</table>
</form>
</c:when>
<c:otherwise><table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr><tr><th></th></tr></table></c:otherwise>
</c:choose>
</body>
</html>