<%@page import="java.util.Locale"%>
<%@page import="de.tt.Utils.Utils"%>
<%@page import="de.tt.data.datamanagement.ManageUsers"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page import="com.example.LNDWA.cards.Player" %>
     <%@ page import="de.tt.data.User" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.List" %>
  <%@ page import="java.util.Map" %>
    <jsp:include page="locale.jsp" /> 
    <%
     	ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
         User user=(User)session.getAttribute("login");
         request.setCharacterEncoding("UTF-8");
         response.setCharacterEncoding("UTF-8");
         Map<String,String[]> requestmap=request.getParameterMap();
     	ManageUsers manage=ManageUsers.getInstance(request.getContextPath());
         System.out.println(requestmap);
         List<User> userlist=ManageUsers.getInstance(request.getContextPath()).getUsers();
         if(user!=null && user.getAdmin()){
         	if(requestmap.containsKey("adduserex")){
     	manage.add(new User(request.getParameter("username"),request.getParameter("password"),Boolean.valueOf(request.getParameter("admin")),Boolean.valueOf(request.getParameter("edit"))));
         	}else if(requestmap.containsKey("edituserex")){
         		User newuser=new User(request.getParameter("username"),request.getParameter("password"),Boolean.valueOf(request.getParameter("admin")),Boolean.valueOf(request.getParameter("edit")));
     	manage.updateUser(request.getParameter("user"), newuser);	
     		}
     }
     %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
<title><%=bundle.getString("players") %></title>
</head>
<body>
<h1><%=bundle.getString("players") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && user.getAdmin()%>">
<table>
<tr><th><%=bundle.getString("username") %></th><th><%=bundle.getString("password") %></th>
<th><%=bundle.getString("admin") %></th><th><%=bundle.getString("edit") %></th>
<th><%=bundle.getString("options") %></tr>
<%
int i=0;for(User currentuser:userlist){%>
    <tr <%=i%2==0?"class=\"alt\"":"" %>>    
    <td><%=currentuser.getUsername()%><input type="hidden" name="username" value="<%=user.getUsername() %>"/></td>
    <td><input type="text" name="password" value="<%=currentuser.getPassword()%>"/></td>
    <td><input type="checkbox" name="admin" <%=currentuser.getAdmin()?"checked":"unchecked"%>/></td>
    <td><input type="checkbox" name="edit" <%=currentuser.getEdit()?"checked":"unchecked"%>/></td>
    <td><a href="edituser.jsp?user=<%=currentuser.getUsername() %>"><%=bundle.getString("saveuser") %></a>
    </tr>
<%i++;}%>
<tr>
<th class="footer"><form action="edituser.jsp" method="post">
<button type="submit"><%=bundle.getString("adduser") %></button></form></th>
<th class="footer"></th><th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>
</table>
</c:when>
<c:otherwise>
      <table height="100%">
      <tr><td style="font-weight:bold;font-size:25pt;text-align:center">
      <%=bundle.getString("notloggedin") %></td></tr>
      <tr><th class="footer" colspan="5"></th></table>
</c:otherwise>
</c:choose>	
</body>
</html>