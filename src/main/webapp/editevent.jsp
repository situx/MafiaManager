<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="de.tt.data.datamanagement.ManageEvents" %>
  <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.Event" %>
  <%@ page import="java.util.Map" %>
  <%@ page import="java.util.ResourceBundle" %>
    <jsp:include page="locale.jsp" /> 
<%
 	ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
 Map<String,String[]> parametermap=request.getParameterMap();
 User user=(User)session.getAttribute("login");
 request.setCharacterEncoding("UTF-8");
 Event event=new Event();
 if(user!=null && (user.getAdmin() || user.getEdit())){
 	if(parametermap.containsKey("event") && parametermap.containsKey("gameset")){
 		event=ManageEvents.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("event"));
 	}
 }
 %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=parametermap.containsKey("event") && parametermap.containsKey("gameset")?bundle.getString("editevent")+" - "+event.getTitle():bundle.getString("addevent") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<h1><%=parametermap.containsKey("event")?bundle.getString("editevent")+" - "+event.getTitle():bundle.getString("addevent") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && user.getAdmin()%>">
<form action="events.jsp<%=parametermap.containsKey("event")?"?editeventex=1":"?addeventex=1"%>" method="post" >
<table border="0">
<%int i=0; %>
<tr><th><%=bundle.getString("options") %></th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("name") %></td>
<td><input type="text" name="title" value="<%=event.getTitle() %>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("probability") %></td>
<td><input type="number" name="probability" step="1" min="0" max="100" value="<%=event.getProbability() %>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("active") %></td>
<td><input type="checkbox" name="active" <%=event.getActive()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("description") %></td>
<td><textarea name="description"><%=event.getDescription()%></textarea></td></tr>
<c:if test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<tr><th class="footer">
<input type="hidden" name="gameset" value="<%=request.getParameter("gameset")%>"/>
<input type="hidden" name="event" value="<%=event.getId()%>"/>
<button type="submit"><%=bundle.getString("saveevent") %></button>
</th>
<th class="footer"></th></tr></c:if>
</table>
</form>
</c:when>
<c:otherwise>
<table>
<tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr>
</table>
</c:otherwise>
</c:choose>
</body>
