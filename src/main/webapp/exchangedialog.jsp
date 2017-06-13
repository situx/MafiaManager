<%@page import="com.example.LNDWA.cards.Preset"%>
<%@page import="com.example.LNDWA.cards.Karte"%>
<%@page import="com.example.LNDWA.cards.Group"%>
<%@page import="com.example.LNDWA.cards.GameSet"%>
<%@page import="java.util.List"%>
<%@page import="de.tt.data.Data"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@page import="de.tt.data.User"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Locale"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.ResourceBundle"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <jsp:include page="locale.jsp" /> 
    <%ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
    Map<String,String[]> parametermap=(Map<String,String[]>)request.getParameterMap();
    User user=(User)session.getAttribute("login");
    Locale locale=(Locale)session.getAttribute("gamesetlang");
    request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("exchangedialog") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css"> 
  <link rel="stylesheet" href="style/jquery-ui.css">
  <script src="js/jquery-1.10.2.js"></script>
  <script src="js/jquery-ui.js"></script>
  
  <script>
  $( "#sortable1, #sortable2" ).sortable({
	  connectWith: ".connectedSortable"
  }).disableSelection();
  </script>
  <style>
  #sortable1, #sortable2 { list-style-type: none; margin: 0; padding: 0 0 2.5em; float: left; margin-left:auto; margin-right:auto; width:85% }
  #sortable1 li, #sortable2 li { margin: 0 5px 5px 5px; padding: 5px; font-size: 1.2em; width: 100%; }
  </style>
</head>
<body>
<h1><%=bundle.getString("exchangedialog") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<form method="post" action="exchangedialog.jsp">
<table>
<tr><td><input type="radio" name="group1" value="Groups"><%=bundle.getString("groups") %></td>
<td><input type="radio" name="group2" value="Exchange"><%=bundle.getString("groups") %></td></tr>
<tr><td>
<input type="radio" name="group1" value="Cards" checked> <%=bundle.getString("characters") %></td>
<td><input type="radio" name="group2" value="Copy"><%=bundle.getString("groups") %></td></tr>
<tr><td><input type="radio" name="group1" value="Presets"> <%=bundle.getString("preset") %></td></tr>
<tr><td>
<select>
<%List<GameSet> gamesets=Data.getInstance(request.getContextPath()).getGameSets((Locale)session.getAttribute("locale"));
 for(GameSet gameset:gamesets){%>
 <option value="<%=gameset.getGamesetid()%>" <%=gameset.getGamesetid().equals(request.getParameter("gameset"))?"selected":"" %>><%=gameset.getTitle() %></option>
 <%} %>
</select>
</td><td><select>
<%for(GameSet gameset:gamesets){%>
 <option value="<%=gameset.getGamesetid()%>" <%=gameset.getGamesetid().equals(request.getParameter("gameset2"))?"selected":"" %>><%=gameset.getTitle() %></option>
 <%} %>
</select></td></tr>
<tr><td>
<ul  id="sortable1" class="connectedSortable">
<c:if test="<%=parametermap.containsKey("groups") && !parametermap.containsKey("cards") && !parametermap.containsKey("presets") %>">
    <%for(GameSet gameset:gamesets){%>
    <c:if test="<%=gameset.getGamesetid().equals(request.getParameter("gameset")) %>">
    	<%for(Group group:gameset.getGroups()){ %>
    	<li class="ui-state-default"><%=group.getGroupname() %></li>
    	<%} %>
    </c:if>
 <%} %>
</c:if>
<c:if test="<%=!parametermap.containsKey("groups") && parametermap.containsKey("cards") && !parametermap.containsKey("presets") %>">
        <%for(GameSet gameset:gamesets){%>
    <c:if test="<%=gameset.getGamesetid().equals(request.getParameter("gameset")) %>">
    	<%for(Karte card:gameset.getCards()){ %>
    	<li class="ui-state-default"><%=card.getName() %></li>
    	<%} %>
    </c:if>
 <%} %>
</c:if>
<c:if test="<%=!parametermap.containsKey("groups") && !parametermap.containsKey("cards") && parametermap.containsKey("presets") %>">
        <%for(GameSet gameset:gamesets){%>
    <c:if test="<%=gameset.getGamesetid().equals(request.getParameter("gameset")) %>">
    	<%for(Preset preset:gameset.getPresets().values()){ %>
    	<li class="ui-state-default"><%=preset.getPresetName() %></li>
    	<%} %>
    </c:if>
 <%} %>
</c:if>
</ul></td><td><ul id="sortable2"  class="connectedSortable">
<c:if test="<%=parametermap.containsKey("groups") && !parametermap.containsKey("cards") && !parametermap.containsKey("presets") %>">
    <%for(GameSet gameset:gamesets){%>
    <c:if test="<%=gameset.getGamesetid().equals(request.getParameter("gameset2")) %>">
    	<%for(Group group:gameset.getGroups()){ %>
    	<li class="ui-state-default"><%=group.getGroupname() %></li>
    	<%} %>
    </c:if>
 <%} %>
</c:if>
<c:if test="<%=!parametermap.containsKey("groups") && parametermap.containsKey("cards") && !parametermap.containsKey("presets") %>">
        <%for(GameSet gameset:gamesets){%>
    <c:if test="<%=gameset.getGamesetid().equals(request.getParameter("gameset2")) %>">
    	<%for(Karte card:gameset.getCards()){ %>
    	<li class="ui-state-default"><%=card.getName() %></li>
    	<%} %>
    </c:if>
 <%} %>
</c:if>
<c:if test="<%=!parametermap.containsKey("groups") && !parametermap.containsKey("cards") && parametermap.containsKey("presets") %>">
        <%for(GameSet gameset:gamesets){%>
    <c:if test="<%=gameset.getGamesetid().equals(request.getParameter("gameset2")) %>">
    	<%for(Preset preset:gameset.getPresets().values()){ %>
    	<li class="ui-state-default"><%=preset.getPresetName() %></li>
    	<%} %>
    </c:if>
 <%} %>
</c:if></ul></td></tr>
<tr><th class="footer"><button type="submit"><%=bundle.getString("save") %></button>
<button type="submit"><%=bundle.getString("reload") %></button></th>
<th class="footer"></th></tr>
</table>
</form>
</body>
</html>