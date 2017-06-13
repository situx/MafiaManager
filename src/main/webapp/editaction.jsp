<%@page import="java.util.Locale"%>
<%@page import="java.io.File"%>
<%@page import="de.tt.data.datamanagement.ManageCards"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@page import="de.tt.data.datamanagement.ManageActions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ page import="de.tt.data.Data" %>
      <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Karte" %>
  <%@ page import="com.example.LNDWA.cards.Action" %>
    <%@ page import="com.example.LNDWA.cards.Group" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.Map" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <jsp:include page="locale.jsp" /> 
<%
 	Map<String,String[]> parametermap=request.getParameterMap();
   ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
   User user=(User)session.getAttribute("login");
   request.setCharacterEncoding("UTF-8");
   GameSet gameset=new GameSet();
   Karte card=new Karte();
   Action action=new Action();
   if(user!=null){
   	gameset=ManageGameSets.getInstance(request.getPathTranslated()).get(request.getParameter("gameset"));
   	card=ManageCards.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"));
   	if(parametermap.containsKey("gameset") && parametermap.containsKey("card") && parametermap.containsKey("action")){
   		action=ManageActions.getInstance(request.getPathTranslated()).get(request.getParameter("gameset"), request.getParameter("card"), request.getParameter("action"));
   }
   }
   System.out.println(action);
   int i=0;
 %>
<title><%=(request.getParameter("action")!=null)?bundle.getString("editaction"):bundle.getString("addaction") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">

</head>
<body>
<h1><%=(request.getParameter("action")!=null)?bundle.getString("editaction"):bundle.getString("addaction") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />

<c:choose>
<c:when test="<%=user!=null && user.getAdmin()%>">
<form method="post" action="editcharacter.jsp" >
<table border="0">
<tr><th>Property</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("title")%></td>
<td><input type="text" name="title" value="<%=action.getTitle() %>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("gamemaster")%></td>
<td><textarea name="gamemaster"><%=action.getGamemaster() %></textarea></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("player") %></td>
<td><textarea name="player"><%=action.getPlayer()%></textarea></td></tr>
<tr<%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("round") %></td>
<td><input type="number" step="1" value="<%=action.getRound() %>" name="round" required/></td></tr>
<tr<%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("position")%></td>
<td><input type="number" step="1" min="0" value="<%=action.getPosition() %>" name="position" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("ondead") %></td>
<td><input type="checkbox" name="active" <%=action.getOndead()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("wakesupwith") %></td>
<td><select name="group" multiple><%for(Karte cardd:gameset.getCards()){ %>
<option value="<%=cardd.getCardid()%>" style="background-image:url(<%=!"".equals(card.getImg())?"data"+File.separator+"gamesets"+File.separator+((Locale)session.getAttribute("locale")).getLanguage()+File.separator+gameset.getSourcefile().substring(gameset.getSourcefile().lastIndexOf(File.separator)+1,gameset.getSourcefile().lastIndexOf('_'))
		+File.separator+card.getImg()+".png":""%>);" <%=action.getWakesupwith().contains(cardd.getCardid())?"selected":"" %>>
<%=cardd.getName()+"("+cardd.getGroup().getGroupIdentifier()+")" %></option>
<%} %></select></td></tr>
<tr><th class="footer">
<input type="hidden" name="gameset" value="<%=request.getParameter("gameset")%>"/>
<input type="hidden" name="card" value="<%=card.getCardid()%>"/>
<input type="hidden" name="action" value="<%=action.getId()%>"/>
<input type="hidden" name="<%=parametermap.containsKey("action")?"editactionex":"addactionex" %>" value="1"/>
<button type="submit" value="Save Action"><%=bundle.getString("saveaction") %></button></th><th class="footer"></th></tr>
</table>
</form>
</c:when>
<c:otherwise>
<table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr></table></c:otherwise>
</c:choose>
</body>
</html>