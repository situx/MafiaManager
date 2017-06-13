<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="de.tt.data.datamanagement.ManageGroups" %>
  <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Group" %>
  <%@ page import="java.util.Map" %>
  <%@ page import="java.util.ResourceBundle" %>
      <jsp:include page="locale.jsp" /> 
  <%
   	ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
   Map<String,String[]> parametermap=request.getParameterMap();
   User user=(User)session.getAttribute("login");
   request.setCharacterEncoding("UTF-8");
   GameSet gameset=new GameSet();
   Group group=new Group();
   if(user!=null && (user.getAdmin() || user.getEdit())){
   	if(parametermap.containsKey("gameset") && parametermap.containsKey("group")){
   		group=ManageGroups.getInstance(request.getContextPath()).get(request.getParameter("gameset"),request.getParameter("group"));
   	}
   }
   %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <LINK href="style/style.css" rel="stylesheet" type="text/css"> 
<title><%=parametermap.containsKey("group")?bundle.getString("editgroup"):bundle.getString("addgroup") %></title>
</head>
<body>
<h1><%=parametermap.containsKey("group")?bundle.getString("editgroup"):bundle.getString("addgroup") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<%int i=0; %>
<c:choose>
<c:when test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<form method="post" action="groups.jsp">
<table border="0">
<tr <%=i++%2==0?"class=\"alt\"":"" %>><th><%=bundle.getString("options") %></th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("numberofgames") %></td>
<td><input type="text" name="groupname" value="<%=group.getGroupname() %>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("groupidentifier") %></td>
<td><input type="text" name="groupidentifier" maxlength="2" value="<%=group.getGroupIdentifier() %>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("canwin") %></td>
<td><input type="checkbox" name="canwin" <%=group.getWinsgame()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("description") %></td>
<td><textarea name="description"><%=group.getGroupdescription()%></textarea></td></tr>
<tr><th class="footer">
<input type="hidden" name="group" value="<%=group.getGroupId()%>"/>
<input type="hidden" name="gameset" value="<%=gameset.getGamesetid()%>"/>
<input type="hidden" name="<%=parametermap.containsKey("group")?"editgroupex":"addgroupex" %>" value="1"/>
<button type="submit"><%=bundle.getString("savegroup") %></button>
</th><th class="footer"></th></tr>
</table>
</form>
</c:when>
<c:otherwise>
<table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr></table>
</c:otherwise>
</c:choose>
</body>
</html>