<%@page import="java.util.Locale"%>
<%@page import="java.io.File"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="de.tt.data.datamanagement.ManageGroups" %>
  <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.Group" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="java.util.Map" %>
  <%@ page import="java.util.ResourceBundle" %>
    <jsp:include page="locale.jsp" />  
  <%
    	ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
                Map<String,String[]> parametermap=(Map<String,String[]>)request.getParameterMap();
                User user=(User)session.getAttribute("login");
                Locale locale=(Locale)session.getAttribute("gamesetlang");
                request.setCharacterEncoding("UTF-8");
                System.out.println("Parametermap: "+parametermap.toString());
                GameSet gameset=new GameSet();
                if(user!=null && (user.getAdmin() || user.getEdit())){
                	if(parametermap.containsKey("gameset")){
                		gameset=ManageGameSets.getInstance(request.getContextPath()).get(request.getParameter("gameset"));
                	}	
                	if(parametermap.containsKey("addgroupex") && parametermap.containsKey("gameset") && parametermap.containsKey("group")){
                		Group group=new Group();
                		group.setGroupdescription(request.getParameter("description"));
                		group.setGroupId(request.getParameter("group"));
                		group.setGroupIdentifier(request.getParameter("groupidentifier"));
                		group.setGroupname(request.getParameter("groupname"));
                		group.setWinsgame(Boolean.valueOf(request.getParameter("canwin")));
                		ManageGroups.getInstance(request.getContextPath()).add(request.getParameter("gameset"), group);		
                	}
                	else if(parametermap.containsKey("editgroupex") && parametermap.containsKey("gameset") && parametermap.containsKey("group")){
                		Group group=ManageGroups.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("group"));
                		group.setGroupdescription(request.getParameter("description"));
                		group.setGroupId(request.getParameter("group"));
                		group.setGroupIdentifier(request.getParameter("groupidentifier"));
                		group.setGroupname(request.getParameter("groupname"));
                		group.setWinsgame(Boolean.valueOf(request.getParameter("canwin")));
                		ManageGroups.getInstance(request.getContextPath()).update(request.getParameter("gameset"),request.getParameter("group"), group);
                	}

                }
                System.out.println("GameSet"+request.getParameter("gameset"));
                if(parametermap.containsKey("gameset")){
                	gameset=ManageGameSets.getInstance(request.getContextPath()).get(request.getParameter("gameset"));
                }
                System.out.println(gameset.toString());
    %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <LINK href="style/style.css" rel="stylesheet" type="text/css"> 
<title><%=bundle.getString("groups") %></title>
</head>
<body>
<h1><%=bundle.getString("groups") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
      <c:when test="<%=gameset.getGroups().isEmpty()%>">
      <table height="100%">
      <tr><td style="font-weight:bold;font-size:25pt;text-align:center">
      <%=bundle.getString("nocards") %></td></tr>
      <tr><th class="footer"><c:if test="<%=user!=null && user.getAdmin()%>">
      <form action="editgroup.jsp?gameset=<%=gameset.getGamesetid() %>" method="post">
      <button type="submit"><%=bundle.getString("addgroup") %></button></form></c:if></th></table>
      </c:when>
      <c:otherwise>
      <table><tr><th><%=bundle.getString("name") %></th>
      <c:if test="<%=user!=null && user.getAdmin()%>"><th><%=bundle.getString("options") %></th></c:if></tr>
<%int i=0;System.out.println(gameset.getGroups().toString());for(Group group:gameset.getGroups()){ %>
<tr <%=i%2==0?"class=\"alt\"":"" %>>
		<td><img src="<%="data"+File.separator+"gamesets"+File.separator+locale.getLanguage()+File.separator+gameset.getSourcefile().substring(gameset.getSourcefile().lastIndexOf(File.separator)+1,gameset.getSourcefile().lastIndexOf('_'))
				+File.separator+group.getGroupIcon()+".png"%>" height="35" width="35"/><%=group.getGroupname()+"("+group.getGroupIdentifier()+")" %></td>
		<c:if test="<%=user!=null && user.getAdmin()%>"><td>
		<form method="post" action="editgroup.jsp?gameset=<%=gameset.getGamesetid()%>&group=<%=group.getGroupId()%>">
		<button type="submit"><%=bundle.getString("editgroup") %></button></form>
		<form method="post" action="characters.jsp?removechar=1&gameset=<%=gameset.getGamesetid()%>&group=<%=group.getGroupId()%>">
		<button type="submit"><%=bundle.getString("removegroup") %></button></form></td></c:if></tr>
<%i++;} %>

<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer">
<form method="post" action="editgroup.jsp?gameset=<%=request.getParameter("gameset")%>">
<button type="submit"><%=bundle.getString("addgroup") %></button></form></th></c:if>
<th class="footer"></th></tr>

</table>
      </c:otherwise>
</c:choose>

</body>
</html>