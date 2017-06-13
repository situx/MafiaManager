<%@page import="java.util.Locale"%>
<%@page import="de.tt.data.datamanagement.ManageUsers"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ page import="java.util.ResourceBundle" %>
        <%@ page import="java.util.Map" %>
        <%@ page import="de.tt.data.User" %>
          <jsp:include page="locale.jsp" />
    <%  ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
    ManageUsers manage=ManageUsers.getInstance(request.getRealPath(request.getContextPath()));
    Map<String,String[]> parametermap=request.getParameterMap();
    if(parametermap.containsKey("login") && parametermap.containsKey("username") && parametermap.containsKey("password")){
    	if(manage.login(request.getParameter("username"), request.getParameter("password"))){
    		session.setAttribute("login", manage.getUser(request.getParameter("username")));
    		if(manage.getUser(request.getParameter("username")).getAdmin()){
    			session.setAttribute("admin", true);
    		}else{
    			session.setAttribute("admin", false);
    		}
    	}
    }%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Werw&ouml;lfe Status Page</title>
</head>
<body>
<h1>Werw&ouml;lfe Status Page</h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />

<h2 style="text-align:center"><%=bundle.getString("login") %></h2>
<form method="post" action="index.jsp?login=true">
<table style="width:150px; text-align:center">
<tr><th colspan="2"></th></tr><tr>
<td><%=bundle.getString("username") %></td>
<td><input type="email" name="username" placeholder="test@test.de"/></td></tr>
<tr><td><%=bundle.getString("password") %></td>
<td><input type="password" name="password"/></td></tr>
<tr><td></td><td><button type="submit"><%=bundle.getString("login") %></button></td>
<td><button type="submit">New Account</button></td></tr>
</table>
</form>
</body>
</html>