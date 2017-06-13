<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Options</title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body>
    <jsp:include page="locale.jsp" /> 
  <%@ page import="java.util.ResourceBundle" %>
  <%ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));%>
  <h1><%=bundle.getString("options") %></h1>
  <jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table><tr><th><%=bundle.getString("options") %></th></tr>
<tr><td><a href="">Reset Players</a></td></tr>
<tr><td><a href="">Reset Games</a></td></tr>
<tr><td><a href="musicmanagement.jsp">Music Management</a></td></tr>
<tr><th></th></tr>
</table>
</body>
</html>