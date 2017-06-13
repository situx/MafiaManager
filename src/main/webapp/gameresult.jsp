<%@page import="de.tt.data.GameResult"%>
<%@page import="de.tt.data.datamanagement.ManageCompetition"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
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
    Set<GameResult> resultlist=Data.getInstance(request.getContextPath()).getGameresults();
    %>
<LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("gameresult") %></title>
</head>
<body>
<h1><%=bundle.getString("gameresult") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table>
<tr><th><%=bundle.getString("game") %></th><th><%=bundle.getString("gameset") %></th>
<th><%=bundle.getString("winninggroup") %></th><th><%=bundle.getString("rounds") %></th></tr>
<%
int i=0;for(GameResult result:resultlist){%>
    <tr <%=i++%2==0?"class=\"alt\"":"" %>> 
    <td><a <%="href=\"gamereport.jsp?gameid="+result.getGameid()+"\""%>><%=result.getGametitle()+" ("+result.getGameid()+")" %></a>   
    <td><a href="gameset.jsp"><%=result.getGameset().getTitle() %></a></td>
    <td><%=result.getWinninggroup() %></td>
    <td>Rounds: <%=result.getRounds() %></td>
    </tr>
    <%} %>
<tr>
<th class="footer"></th>
<th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>
</table>
</body>
</html>