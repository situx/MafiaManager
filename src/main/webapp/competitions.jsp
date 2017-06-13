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
Collections.sort(files);
    Map<String,String[]> parametermap=request.getParameterMap();
    List<Competition> competitions=ManageCompetition.getInstance(request.getContextPath()).getAll();%>
<LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("competition") %></title>
</head>
<body>
<h1><%=bundle.getString("competition") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test='<%=(competitions!=null && !competitions.isEmpty())%>'>
<c:choose>
      <c:when test="<%=competitions.isEmpty()%>">
      <table height="100%">
      <tr><td style="font-weight:bold;font-size:25pt;text-align:center">
      <%=bundle.getString("nocards") %></td></tr>
      <tr><th class="footer"><c:if test="<%=user!=null && user.getAdmin()%>">
      <!-- <form action="editcompetition.jsp?competition=<%=competitions.toString() %>" method="post">
      <button type="submit"><%=bundle.getString("addcompetition") %></button></form> --></c:if></th></table>
      </c:when>
      <c:otherwise>
      <table><tr><th><%=bundle.getString("image") %></th><th><%=bundle.getString("competition") %></th>
      <th><%=bundle.getString("date") %></th><th><%=bundle.getString("description") %></th>
      <c:if test="<%=user!=null && user.getAdmin()%>"><th><%=bundle.getString("options") %></th></c:if></tr>
<%int i=0;for(Competition comp:competitions){ %>
<tr <%=i%2==0?"class=\"alt\"":"" %>>
<td><img src="<%=request.getContextPath()+File.separator+"data"+File.separator+comp.getCompetitionid()+".png"%>"/></td>
<td><a href="competition.jsp?competition=<%=comp.getCompetitionid()%>"><%=comp.getName() %></a></td>
		<td><%=DateFormat.getDateInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(comp.getStart())+
		" "+DateFormat.getTimeInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(comp.getStart())
				+" - <br>"+DateFormat.getDateInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(comp.getEnd())+
				" "+DateFormat.getTimeInstance(DateFormat.LONG, (Locale)session.getAttribute("locale")).format(comp.getEnd())
				%></td><td><%=comp.getDescription() %></td>
		<c:if test="<%=user!=null && user.getAdmin()%>">
		<td><form action="editcompetition.jsp?competition=<%=comp.getCompetitionid()%>" method="post">
		<button type="submit"><%=bundle.getString("editcompetition") %></button></form><br>
		<form method="post" action="competition.jsp?removecompetition=1&competition=<%=comp.getCompetitionid()%>">
		<button type="submit"><%=bundle.getString("removecompetition") %></button></form></td></c:if></tr>
<%i++;} %>

<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer">
<form method="post" action="editcompetition.jsp?competition=<%=request.getParameter("gameset")%>">
<button type="submit"><%=bundle.getString("addcompetition") %></button></form></th></c:if>
<th class="footer"></th><th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>

</table>
      </c:otherwise>
</c:choose>
</c:when>
<c:otherwise>
<table height="100%">
<tr><td><%=bundle.getString("nogameset") %></td></tr>
<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer">
<form method="post" action="editcompetition.jsp?competition=<%=request.getParameter("gameset")%>">
<button type="submit"><%=bundle.getString("addcompetition") %></button></form></th>
<th class="footer"></th></c:if><th class="footer"></th><th class="footer"></th></tr>

</table>
</c:otherwise>
</c:choose>
</body>
</html>