<%@page import="com.example.LNDWA.cards.Game"%>
<%@page import="de.tt.Utils.Tuple"%>
<%@page import="de.tt.data.GameResult"%>
<%@page import="de.tt.data.datamanagement.ManageCompetition"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.File"%>
<%@ page import="de.tt.data.User" %>
<%@ page import="de.tt.data.Data" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.DateFormat.*" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="locale.jsp" />
    <%
	User user=(User)session.getAttribute("login");
    ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
    String sep=File.separator; 
    File filepath=new File(request.getRealPath(request.getContextPath()).substring(0,request.getRealPath(request.getContextPath()).lastIndexOf('/'))+"/data"+sep+"music"); 
List<String> files=Arrays.asList(filepath.list());
Collections.sort(files);
    Map<String,String[]> parametermap=request.getParameterMap();
    GameResult result=Data.getInstance(request.getContextPath()).getGameresults().iterator().next();
    %>
<LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("gamereport")+" "+result.getGametitle() %></title>
</head>
<body>
<h1><%=bundle.getString("gamereport")+" "+result.getGametitle()%></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<tr><th colspan="2"><%=result.getGametitle() %></tr>
<%
int i=0;%>
    <tr <%=i%2==0?"class=\"alt\"":"" %>>
    <td>Gameid:</td><td><%=result.getGameid() %></td></tr>
    <tr><td>Gametitle:</td><td><%=result.getGametitle() %></td></tr>
    <tr><td><%=bundle.getString("competition") %></td><td><a href="competition.jsp?competition=<%=result.getCompetition().toString()%>">
    <%=result.getCompetition().toString()%></a>   
    <tr><td>Time: </td><td><%=result.time %></td></tr>
    <tr><td>Rounds:</td><td> <%=result.getRounds() %></td></tr>
    <tr><th class="footer" colspan="2"></th></tr>
    </table><br/><br/>
    <%i=0; %>
    <table><tr><th colspan="4"><%=bundle.getString("players") %></th></tr>
    <tr><th><%=bundle.getString("character") %></th><th><%=bundle.getString("dead") %></th>
    <th><%=bundle.getString("winner") %></th><th><%=bundle.getString("points") %></th></tr>
        <%for(Game game:result.getGame()){ %>
    	<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=game.character %></td><td><%=game.dead %></td><td><%=game.won %></td>
    	<td><%=game.points%></td></tr>
    <%} %>
    <tr><th class="footer" colspan="4"></th></tr>
    </table><br/><br/>
    <%i=0; %>
    <table><tr><th colspan="2"><%=bundle.getString("gamelog") %></th></tr>
    <tr><th><%=bundle.getString("round") %></th><th><%=bundle.getString("event") %></th></tr>
        <%for(Tuple<String,Integer> tuple:result.getGamelog()){ %>
    	<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=tuple.getTwo() %></td><td><%=tuple.getOne() %></td></tr>
    <%} %>
    </table>
<table>
<tr>
<th class="footer"><a href="<%=request.getContextPath()%>/rest/lndwa/gameresult/<%=result.gameid %>/<%=((Locale)session.getAttribute("locale")).getLanguage().toString() %>?context=<%=request.getContextPath()%>">
Export</a></th>
<th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>
</table>
</body>
</html>