<%@page import="de.tt.data.FileUploader"%>
<%@page import="de.tt.data.datamanagement.ManageActions"%>
<%@page import="de.tt.data.datamanagement.ManageGroups"%>
<%@page import="de.tt.data.datamanagement.ManageAbilities"%>
<%@page import="de.tt.data.datamanagement.ManageCards"%>
<%@page import="de.tt.data.User"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ page import="de.tt.data.Data" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Karte" %>
  <%@ page import="com.example.LNDWA.cards.Group" %>
  <%@ page import="com.example.LNDWA.cards.Ability" %>
  <%@ page import="com.example.LNDWA.cards.Action" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.Map" %>
  <%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
  <jsp:include page="locale.jsp" />  
<%
  	Map<String,String[]> requestmap=request.getParameterMap();
                  request.setCharacterEncoding("UTF-8");
                  response.setCharacterEncoding("UTF-8");
                  System.out.println(requestmap.toString());
                  User user=(User)session.getAttribute("login");
                  GameSet gameset=ManageGameSets.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"));
                  Karte card =gameset.getUuidToCard().get(request.getParameter("card"));
                  ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
                  
                  int i=0;
  %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="js/jquery-1.9.1.js"></script>
<script language="javascript">
//<![CDATA[ 
$(window).load(function(){
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#charimg').attr('src', e.target.result);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    $("#imginput").change(function(){
        readURL(this);
    });
});//]]>
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("charinfo")%> - <%=card.getName()%></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body <%=request.getParameter("file")!=null?"onload=\"setresult()\"":" " %>>
<h1><%=bundle.getString("charinfo") %> - <%=card.getName()%></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null%>">
<form method="post" action="characters.jsp?gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>" enctype="multipart/form-data" >
<table border="0">
<tr><th>Property</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("name") %></td>
<td><%=card.getName() %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("group") %></td>
<td><select name="group" disabled="disabled"><%=card.getGroup().getGroupname()+"("+card.getGroup().getGroupIdentifier()+")" %></option>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("picture") %></td>
<td>
<img src="<%=!"".equals(card.getImg())?"data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
		+"/"+card.getCardid()+".png":""%>" id="charimg"/>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("minamount") %></td>
<td><%=card.getMinamount() %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("maxamount") %></td>
<td><%=card.getMaxamount()==-1?"unlimited":card.getMaxamount() %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("balancevalue") %></td>
<td><%=card.getBalancevalue() %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("round") %></td>
<td>
<%=card.getRound()==0?"true":"false" %>
<div id="content" style="position:relative">
<div class="help-tip">
<p>
<%=bundle.getString("everyRound")%><br>
</p>
</div></div>
<%=card.getRound()==-1?"true":"false" %>
<%=bundle.getString("noround")%><br>
<%=card.getRound()>0?"true":"false" %>
<%=bundle.getString("xround")%>
<%=card.getRound()<-1?"true":"false" %>
<%=bundle.getString("everyXRound")%>
<%=card.getRound() %><br>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("position") %></td>
<td><%=card.getPosition() %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("position2") %></td>
<td><%=card.getPosition2()==-1?"None":card.getPosition2() %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("calleveryone") %></td>
<td><%=card.getCalleveryone()?"checked":"unchecked" %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("deadcards") %></td>
<td><%=card.getDeadchars()?"checked":"unchecked" %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("nopoints") %></td>
<td><%=card.getNopoints()?"checked":"unchecked" %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("winsalone") %></td>
<td><%=card.getWinsalone()?"checked":"unchecked" %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("fixeddeath") %></td>
<td><%=card.getFixeddeath()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("winningalivepoints") %></td>
<td><%=card.getWinningAlive()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("winningpointsdead") %></td>
<td><%=card.getWinningDead()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("extra") %></td>
<td><%=card.getExtra() %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("deathdelay") %></td>
<td><%=card.getDeathdelay()%></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("description") %></td>
<td><%=card.getDescription() %></td></tr>
<%for(Action action:card.getActionlist().values()){ %>
<tr <%=i%2==0?"class=\"alt\"":"" %>><td><%=action.getTitle()+" ("+action.getPosition()+")"+bundle.getString("round")+" "+action.getRound()%></td>
<td>		<a href="editaction.jsp?gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>&action=<%=action.getId()%>"><%=bundle.getString("editaction") %></a><br>
		<a href="editcharacter.jsp?removeaction=1&gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>&action=<%=action.getId()%>"><%=bundle.getString("removeaction") %></a></td></tr>
<%i++;}
for(Ability ability:card.getabblist()){ %> 
<tr <%=i%2==0?"class=\"alt\"":"" %>><td>
<img border="1" src="<%=request.getContextPath()+"/data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+
				gameset.getLanguage()+"_"+gameset.getGamesetid()+"/overlay/"+ability.getAbilityId()+".png"%>"/></td><td><%=ability.getDescription()%><br>
		<a href="editability.jsp?gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>&ability=<%=ability.getAbilityId()%>"><%=bundle.getString("editability") %></a><br>
		<a href="editcharacter.jsp?removeability=1&gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>&ability=<%=ability.getAbilityId()%>"><%=bundle.getString("removeability") %></a></td></tr>
<%i++;} %>
</table>
<input type="hidden" value="<%=card.getCardid()%>" name="card"/>
<input type="hidden" value="<%=gameset.getGamesetid()%>" name="gameset"/>
<input type="hidden" value="1" name="<%=requestmap.containsKey("card")?"editcharex":"addcharex"%>"/>
</form>
</c:when><c:otherwise><table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr></table></c:otherwise>
</c:choose>
</body>
</html>