<%@page import="com.example.LNDWA.cards.Player"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="de.tt.data.GameResult"%>
<%@page import="com.example.LNDWA.cards.Game"%>
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
<%@ page import="com.example.LNDWA.cards.Competition" %>
<%@ page import="de.tt.data.User" %>
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
SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat format2=new SimpleDateFormat("hh:mm");
Collections.sort(files);
    Map<String,String[]> requestmap=request.getParameterMap();
    Competition competition=ManageCompetition.getInstance(request.getContextPath()).get(request.getParameter("competition"));%>
<LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("competition") %></title>
</head>
<body>
<h1><%=bundle.getString("competition") %> - <%=competition.getName()%></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<%int i=0; %>
<tr><th>Property</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("compfinished") %></td>
<td><input type="checkbox" value="0" <%=competition.getFinished()?"checked":"unchecked" %> disabled/>
<%=bundle.getString("compfinished")%><br></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("name") %></td>
<td><%=competition.getName()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("description") %></td>
<td><%=competition.getDescription()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("location") %></td>
<td><%=competition.getLocation()%></td></tr>
<tr><td><%=bundle.getString("image") %></td><td>
<img src="<%=!"".equals(competition.getImg())?"data/competitions/"+competition.getCompetitionid()+".png":""%>" id="compimg"/>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("registerdeadline") %></td>
<td><%=DateFormat.getDateInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(competition.getRegisterdeadline())+
" "+DateFormat.getTimeInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(competition.getRegisterdeadline()) %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("starttime") %></td><td><%=DateFormat.getDateInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(competition.getStart())+
		" "+DateFormat.getTimeInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(competition.getStart())%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("endtime") %></td><td><%=DateFormat.getDateInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(competition.getEnd())+
" "+DateFormat.getTimeInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(competition.getEnd()) %></td></tr>
<tr><th class="footer" colspan="2"></th></tr>
</table>
<br/><br/>
<table>
<tr><th colspan="4"><%=bundle.getString("competition") %> <%=bundle.getString("ranking") %></th></tr>
<%i=0;
Map<Player,Integer> rank=competition.getRanking();
for(Player player:rank.keySet()){ %>
    <tr <%=i++%2==0?"class=\"alt\"":"" %>> 
    <td><%=player.getFirstname()+" "+player.getName() %></td>   
    <td><%=rank.get(player).toString() %></td>
    </tr>
<%i++;} %>
<tr><th class="footer" colspan="5"></th></tr>
</table>
<br/><br/>
<table>
<tr><th colspan="4"><%=bundle.getString("game") %></th></tr>
<%i=0;for(GameResult result:competition.getGames()){ %>
    <tr <%=i++%2==0?"class=\"alt\"":"" %>> 
    <td><a <%="href=\"gamereport.jsp?gameid="+result.getGameid()+"\""%>><%=result.getGametitle()+" ("+result.getGameid()+")" %></a>   
    <td><a href="gameset.jsp"><%=result.getGameset().getTitle() %></a></td>
    <td><%=result.getWinninggroup() %></td>
    <td>Rounds: <%=result.getRounds() %></td>
    </tr>
<%i++;} %>
<tr><th class="footer" colspan="5"></th></tr>
</table>

</body>
</html>