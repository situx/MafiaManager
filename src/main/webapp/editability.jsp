<%@page import="java.util.Locale"%>
<%@page import="java.io.File"%>
<%@page import="de.tt.data.datamanagement.ManageCards"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@page import="de.tt.data.datamanagement.ManageAbilities"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ page import="de.tt.data.Data" %>
      <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Karte" %>
  <%@ page import="com.example.LNDWA.cards.Ability" %>
    <%@ page import="com.example.LNDWA.cards.Group" %>
  <%@ page import="java.util.ResourceBundle" %>
  <%@ page import="java.util.Map" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="locale.jsp" />  
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
	Map<String,String[]> parametermap=request.getParameterMap();
ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
User user=(User)session.getAttribute("login");
request.setCharacterEncoding("UTF-8");
GameSet gameset=new GameSet();
Karte card=new Karte();
Ability ability=new Ability();
if(user!=null){
	gameset=ManageGameSets.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"));
	card=ManageCards.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"));
	if(parametermap.containsKey("gameset") && parametermap.containsKey("card") && parametermap.containsKey("ability")){
		ability=ManageAbilities.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"), request.getParameter("card"), request.getParameter("ability"));
}
}
int i=0;
%>
<title><%=(request.getParameter("ability")!=null)?bundle.getString("editability"):bundle.getString("addability") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
 <script src="js/jquery-1.9.1.js"></script>
<script>
function activateConstraint(active){
	if(active){
		document.getElementsByName("group").checked=true;
		document.getElementsByName("ability").checked=true;
		document.getElementsByName("usedonabb").checked=true;
		document.getElementsByName("count").enabled=true;
	}else{
		document.getElementsByName("group").checked=false;
		document.getElementsByName("ability").checked=false;
		document.getElementsByName("usedonabb").checked=false;
		document.getElementsByName("count").checked=false;
	}
}

</script>
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
</head>
<body>
<h1><%=(request.getParameter("ability")!=null)?bundle.getString("editability"):bundle.getString("addability") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && user.getAdmin()%>">
<form method="post" action="editcharacter.jsp" >
<table border="0">
<tr><th>Property</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("name")%></td>
<td><input type="text" value="<%=ability.getDescription() %>" name="description"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("picture") %></td>
<td><img src="<%=request.getContextPath()+"/data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator+gameset.getLanguage()+"_"+gameset.getGamesetid()+"/overlay/"+
		ability.getAbilityId()+".png"%>" id="charimg"/><br><input id="imginput" type="file" accept="image/png" value="Upload"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("amount") %></td>
<td><input type="number" step="1"  value="<%=ability.getFks()%>" name="amount"/><%=bundle.getString("abilityamountdesc") %></td></tr>
<tr<%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("availableFrom") %></td>
<td><input type="number" step="1" min="0" value="<%=ability.getAvailableFrom() %>" name="availablefrom"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("availableUntil") %></td>
<td><input type="number" step="1" min="-1" value="<%=ability.getAvailableUntil() %>" name="availableuntil"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("concerns") %></td>
<td><label><input type="number" step="1" min="0" value="<%=ability.getConcerns() %>" name="concerns"/><%=bundle.getString("concernsdesc") %></label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("duration") %></td>
<td><label><input type="number" step="1" min="1" value="<%=ability.getDuration() %>" name="duration"/><%=bundle.getString("abilitydurationdesc") %></label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("delay") %></td>
<td><input type="number" step="1" min="0" value="<%=ability.getDelay() %>" name="delay"/><%=bundle.getString("round") %></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("probability") %></td>
<td><label><input type="number" step="1" min="0" value="<%=ability.getProbability()%>" name="probability"/><%=bundle.getString("abilityprobabilitydesc") %></label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("switchnewchar") %></td>
<td><input type="text" value="<%=ability.getSwitchnewchar()%>" name="switchnewchar"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("changegroup") %></td>
<td><select name="changegroup" multiple><%for(Group group:gameset.getGroups()){ %>
<option value="<%=group.getGroupId()%>" <%=ability.getChangeGroup().contains(group)?"selected":"" %>><%=group.getGroupname()+"("+group.getGroupIdentifier()+")"%></option><%} %></select>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("active") %></td>
<td><input type="checkbox" name="active" <%=ability.getActive()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("counterkilling") %></td>
<td><label><input  type="checkbox" name="counterkilling" 
<%=ability.getCounterKilling()?"checked":"unchecked" %>>Set this option if the ability can heal or protect a character.<br>Example: Witch</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("killing") %></td>
<td><label><input type="checkbox" name="killing" <%=ability.getKilling()?"checked":"unchecked" %>/>
Set this option if the ability can cause the death of one character.<br>Example: Werewolve</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("mustuse") %></td>
<td><label><input type="checkbox" name="mustuse" <%=ability.getMustuseability()?"checked":"unchecked" %>/>
<%=bundle.getString("mustusedesc") %></label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("useonself") %></td>
<td><label><input type="checkbox" <%=ability.getSelf()?"checked":"unchecked" %> name="self"/>
<%=bundle.getString("selfdesc") %></label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("alwayschooseother") %></td>
<td><label><input type="checkbox" <%=ability.getAlwaysChooseOther()?"checked":"unchecked" %> name="self"/>
<%=bundle.getString("alwayschooseother") %></label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("switchchar") %></td>
<td><label><input type="checkbox" name="switchchar" <%=ability.getSwitchchar()?"checked":"unchecked" %>/>
Set this option if the ability can in any way exchange some characters in the game.<br>Example: Alchemist</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("abilityondead") %></td>
<td><label><input type="checkbox" name="ondead" <%=ability.getOndead()?"checked":"unchecked" %>/><%=bundle.getString("ondeaddesc") %></label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>>
<td><%=bundle.getString("constraint") %></td>
<td><input type="checkbox" name="hascheck" onclick="activateConstraint(true)"<%=ability.getCheck().hasCheck()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("group") %></td>
<td><label><input type="checkbox" name="group" <%=ability.getCheck().getGroup()?"checked":"unchecked" %>/>
Group Concern</label><select name="group" multiple><%for(Group group:gameset.getGroups()){ %>
<option value="<%=group.getGroupId()%>" >
<%=group.getGroupname()+"("+group.getGroupIdentifier()+")" %></option>
<%} %></select></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("onlycheck") %></td>
<td><label><input type="checkbox" name="onlycheck" <%=ability.getCheck().getOnlyCheck()?"checked":"unchecked" %>/>
Only Check</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("ability") %></td>
<td><label><input type="checkbox" name="ability" <%=ability.getCheck().getAbility()?"checked":"unchecked" %>/>
Ability</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("count") %></td>
<td><label><input type="checkbox" name="count" <%=ability.getCheck().getCount()?"checked":"unchecked" %>/>
Count</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("usedonabb") %></td>
<td><label><input type="checkbox" name="usedonabb" <%=ability.getCheck().getUsedonabb()?"checked":"unchecked" %>/>
Used On Abb</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("direction") %></td>
<td><label><input type="checkbox" name="direction" <%=ability.getCheck().getDirection()?"checked":"unchecked" %>/>
Direction</label></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("not") %></td>
<td><label><input type="checkbox" name="not" <%=ability.getCheck().getNot()?"checked":"unchecked" %>/>
Negation</label></td></tr>
<tr><th class="footer">
<input type="hidden" name="gameset" value="<%=request.getParameter("gameset")%>"/>
<input type="hidden" name="card" value="<%=card.getCardid()%>"/>
<input type="hidden" name="ability" value="<%=ability.getAbilityId()%>"/>
<input type="hidden" name="<%=parametermap.containsKey("ability")?"editabilityex":"addabilityex" %>" value="1"/>
<button type="submit" value="Save Ability"><%=bundle.getString("saveability") %></button></th><th class="footer"></th></tr>
</table>
</form>
</c:when>
<c:otherwise>
<table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr></table></c:otherwise>
</c:choose>

</body>
</html>