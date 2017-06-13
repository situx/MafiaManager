<%@page import="de.tt.data.Statistics"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@page import="de.tt.data.datamanagement.ManagePlayers"%>
<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="de.tt.view.Ranking" %>
<%@ page import="de.tt.data.Data" %>
<%@ page import="de.tt.data.GameResult" %>
  <%@ page import="java.util.ResourceBundle" %>
  <jsp:include page="locale.jsp" />  
  <%ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
  Statistics stat=new Statistics(request.getPathTranslated());
  int i=0;
  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("statistics") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<h1><%=bundle.getString("statistics") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<tr><th><a href="gameresult.jsp"><%=bundle.getString("gameresult") %></a></th><th><a href="ranking.jsp"><%=bundle.getString("ranking") %></a></th></tr>
<tr><th><%=bundle.getString("option") %></th><th><%=bundle.getString("players") %></th></tr>
<tr><th class="footer"></th>
<th class="footer"></th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("players") %></td><td><%=ManagePlayers.getInstance(request.getContextPath()).getAll().size()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("maxpointsperplayer") %></td><td><%=stat.getMaxPointsPerPlayer()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("numberofgames") %></td><td><%=stat.getNumberOfGames()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("avgpointsperplayer") %></td><td><%=stat.getAvgPointsPerPlayer()%></td></tr>
<tr><th class="footer"></th><th class="footer"></th></tr>

</table>

</body>
</html>