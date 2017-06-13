<%@page import="java.util.Locale"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@page import="de.tt.data.datamanagement.ManageEvents"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
             <%@ page import="de.tt.data.Data" %>
                          <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Event" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.Map" %>
  <jsp:include page="locale.jsp" />  
<%
  	Event newevent=new Event();

        User user=(User)session.getAttribute("login");
        request.setCharacterEncoding("UTF-8");
        Map<String,String[]> parametermap=request.getParameterMap();
        ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
        if(user!=null && (user.getAdmin() || user.getEdit())){
        	if(parametermap.containsKey("addeventex") && parametermap.containsKey("gameset") && parametermap.containsKey("event")){
        		newevent.setActive(Boolean.valueOf(request.getParameter("active")));
        		newevent.setDescription(request.getParameter("description"));
        		newevent.setProbability(Integer.valueOf(request.getParameter("probability")));
        		newevent.setTitle(request.getParameter("title"));
        		newevent.setId(request.getParameter("event"));
        		System.out.println(newevent.toString());
        		System.out.println(request.getParameter("gameset"));
        		ManageEvents.getInstance(request.getContextPath()).add(request.getParameter("gameset"), newevent);
        	}else if(parametermap.containsKey("editeventex") && parametermap.containsKey("gameset") && parametermap.containsKey("event")){
        		newevent.setActive(Boolean.valueOf(request.getParameter("active")));
        		newevent.setDescription(request.getParameter("description"));
        		newevent.setProbability(Integer.valueOf(request.getParameter("probability")));
        		newevent.setTitle(request.getParameter("title"));
        		newevent.setId(request.getParameter("event"));
        		ManageEvents.getInstance(request.getContextPath()).update(request.getParameter("gameset"),request.getParameter("event"), newevent);
        	}else if(parametermap.containsKey("removeevent") && parametermap.containsKey("gameset") && parametermap.containsKey("event")){
        		ManageEvents.getInstance(request.getContextPath()).remove(request.getParameter("gameset"), request.getParameter("event"));
        	}
        }
        GameSet gameset=ManageGameSets.getInstance(request.getContextPath()).get(request.getParameter("gameset"));
  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("event") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css"> 
</head>
<body>
<h1><%=bundle.getString("event") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
      <c:when test="<%=gameset.getEvents().isEmpty()%>">
      <table height="100%"><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("noevents") %></td></tr>
      <tr><th><c:if test="<%=user!=null && user.getAdmin()%>"><form method="post" action="editevent.jsp?gameset=<%=gameset.getGamesetid()%>">
<button type="submit"><%=bundle.getString("addevent") %></button>
</form></c:if></th></tr></table>
      </c:when>
      <c:otherwise>
<table><tr><th><%=bundle.getString("name") %></th><th><%=bundle.getString("description") %></th>
<c:if test="<%=user!=null && user.getAdmin()%>"><th><%=bundle.getString("options") %></th></c:if></tr>
<%int i=0;for(Event event:gameset.getEvents()){ %>
<tr <%=i%2==0?"class=\"alt\"":"" %>><td><b><%=event.getTitle() %></b></td><td><%=event.getDescription() %></td>
<c:if test="<%=user!=null && user.getAdmin()%>"><td><form method="post" action="editevent.jsp?gameset=<%=gameset.getGamesetid()%>&event=<%=event.getId()%>">
<button type="submit"><%=bundle.getString("editevent") %></button></form>
<form method="post" action="events.jsp?removeevent=1&gameset=<%=gameset.getGamesetid()%>&event=<%=event.getId()%>">
<button type="submit"><%=bundle.getString("removeevent") %></button></form>
</td></c:if></tr>
<%i++;} %>

<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><form method="post" action="editevent.jsp?gameset=<%=gameset.getGamesetid()%>">
<th class="footer"><button type="submit"><%=bundle.getString("addevent") %></button></th>
</form></c:if><th></th><th></th></tr>

</table>
</c:otherwise>
</c:choose>


</body>
