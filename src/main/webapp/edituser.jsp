<%@page import="java.util.Locale"%>
<%@page import="de.tt.data.datamanagement.ManageUsers"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  	<%@ page import="de.tt.data.datamanagement.ManagePlayers" %>
  	<%@ page import="de.tt.data.User" %>
  	<%@ page import="com.example.LNDWA.cards.Player" %>
      <%@ page import="java.util.ResourceBundle" %>
      <%@ page import="java.util.Map" %>
        <jsp:include page="locale.jsp" />
<%ManageUsers manage=ManageUsers.getInstance(request.getContextPath());
User user=(User) session.getAttribute("login");
User newuser=new User();
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
Map<String,String[]> requestmap=request.getParameterMap();
ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
if(requestmap.containsKey("user")){
	newuser=manage.getUser(request.getParameter("user"));
}%>
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
<c:when test="<%=user!=null && (user.getAdmin())%>">
<form action="users.jsp" method="post">
<table>
<tr><th>Property</th><th>Value</th></tr>
<tr><td><%=bundle.getString("username") %></td>
<td><input type="email" name="username" value="<%=newuser.getUsername()%>" required/></td></tr>
<tr><td><%=bundle.getString("password") %></td>
<td><input type="password" name="password" value="<%=newuser.getPassword()%>" required/></td></tr>
<tr><td><%=bundle.getString("admin") %></td>
<td><input type="checkbox" name="admin" <%=newuser.getAdmin()?"checked":"unchecked" %>/></td></tr>
<tr><td><%=bundle.getString("edit") %></td>
<td><input type="checkbox" name="edit" <%=newuser.getEdit()?"checked":"unchecked" %>/></td></tr>
<tr><th class="footer"><button type="submit"><%=bundle.getString("saveuser") %></button>
<input type="hidden" name="user" value="<%=newuser.getUsername()%>"/>
<input type="hidden" name="<%=requestmap.containsKey("user")?"edituserex":"adduserex" %>" value="1"/></th><th class="footer"></th></tr>
</table>
</form>
</c:when>
<c:otherwise><table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr><tr><th></th></tr></table></c:otherwise>
</c:choose>
</body>
</html>