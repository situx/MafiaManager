<%@page import="java.util.Locale"%>
<%@ page import="java.util.ResourceBundle" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="de.tt.data.User" %>
<%ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
User user=(User)session.getAttribute("login");%>
<table>
<tr><th><a href="index.jsp"><%=bundle.getString("home") %></a></th>
<th><a href="gameset.jsp"><%=bundle.getString("gameset") %></a></th>
<th><a href="players.jsp"><%=bundle.getString("players") %></a></th>
<th><a href="competitions.jsp"><%=bundle.getString("competitions") %></a></th>
<th><a href="statistics.jsp"><%=bundle.getString("statistics") %></a></th>
<c:if test="<%=user!=null && user.getAdmin() %>">
<th><a href="options.jsp"><%=bundle.getString("options") %></a></th>
<th><a href="users.jsp"><%=bundle.getString("users") %></a></th>
</c:if></tr>
</table>