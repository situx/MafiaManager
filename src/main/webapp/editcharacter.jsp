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
                  GameSet gameset=ManageGameSets.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"));

                  ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
                  User user=(User)session.getAttribute("login");
                  Karte card=new Karte();
                  if(user!=null && (user.getAdmin() || user.getEdit())){
                  String newimagepath="";
                  Map<String,String> frequestmap=new TreeMap<String,String>();
                  if(requestmap.containsKey("addabilityex") || requestmap.containsKey("editabilityex")){
                  	frequestmap=new FileUploader().uploadFiles(File.separator+"home"+File.separator+"timo"+File.separator+"workspace"+File.separator+"LNDWAWeb"+File.separator+"WebContent"+File.separator+"data"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator,
                  		"gameset-upload",gameset.getLanguage()+File.separator+gameset.getLanguage()+"_"+gameset.getGamesetid()+File.separator+"overlay"+File.separator,request.getParameter("ability")+".png",pageContext.getServletContext(), (Locale)session.getAttribute("gamesetlang"), request);
                  }
                  System.out.println(frequestmap.toString());
                  if(requestmap.containsKey("addabilityex") && requestmap.containsKey("gameset") && requestmap.containsKey("card")){
                  	card=ManageCards.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"));
                  	Ability ability=new Ability();
                  	ability.setAbilityId(frequestmap.get("ability"));
                  	ability.setaktiv(Boolean.valueOf(frequestmap.get("active")));
                  	ability.setAvailableFrom(Integer.valueOf(frequestmap.get("availablefrom")));
                  	ability.setAvailableUntil(Integer.valueOf(frequestmap.get("availableuntil")));
                  	List<Group> changegrouplist=new LinkedList<Group>();
                  	if(request.getParameterValues("changegroup")!=null){
                  		for(String group:request.getParameterValues("changegroup")){
                  	changegrouplist.add(new Group(group));
                  		}
                  	}
                  	ability.setChangeGroup(changegrouplist);
                  	ability.setConcerns(Integer.valueOf(frequestmap.get("concerns")));
                  	ability.setDescription(frequestmap.get("description"));
                  	ability.setDuration(Integer.valueOf(frequestmap.get("duration")));
                  	ability.setFks(Integer.valueOf(frequestmap.get("amount")));
                  	ability.setDelay(Integer.valueOf(frequestmap.get("delay")));
                  	ability.setImage(frequestmap.get("ability"));
                  	ability.setKilling(Boolean.valueOf(frequestmap.get("killing")));
                  	ability.setCounterKilling(Boolean.valueOf(frequestmap.get("counterkilling")));
                  	ability.setMustuseability(Boolean.valueOf(request.getParameter("mustuse")));
                  	ability.setProbability(Integer.valueOf(frequestmap.get("probability")));
                  	ability.setSelf(Boolean.valueOf(frequestmap.get("self")));
                  	ability.setSwitchchar(Boolean.valueOf(frequestmap.get("switchchar")));
                  	ability.setSwitchnewchar(frequestmap.get("switchnewchar"));
                  	System.out.println(request.getParameter("gameset")+" "+request.getParameter("card")+" "+card);
                  	System.out.println(card.getabblist().toString());
                  	ManageAbilities.getInstance(request.getRealPath(request.getContextPath())).add(request.getParameter("gameset"), request.getParameter("card"), ability);
                  }else if(requestmap.containsKey("editabilityex") && requestmap.containsKey("gameset") && requestmap.containsKey("card")){
                  	card=ManageCards.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"));
                  	Ability ability=ManageAbilities.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"), request.getParameter("ability"));
                  	ability.setaktiv(Boolean.valueOf(frequestmap.get("active")));
                  	ability.setAvailableFrom(Integer.valueOf(frequestmap.get("availablefrom")));
                  	ability.setAvailableUntil(Integer.valueOf(frequestmap.get("availableuntil")));
                  	List<Group> changegrouplist=new LinkedList<Group>();
                  	if(request.getParameterValues("changegroup")!=null){
                  		for(String group:request.getParameterValues("changegroup")){
                  	changegrouplist.add(new Group(group));
                  		}
                  	}
                  	ability.setChangeGroup(changegrouplist);
                  	ability.setConcerns(Integer.valueOf(frequestmap.get("concerns")));
                  	ability.setDescription(frequestmap.get("description"));
                  	ability.setDuration(Integer.valueOf(frequestmap.get("duration")));
                  	ability.setFks(Integer.valueOf(frequestmap.get("amount")));
                  	ability.setDelay(Integer.valueOf(frequestmap.get("delay")));
                  	ability.setImage(frequestmap.get("image"));
                  	ability.setKilling(Boolean.valueOf(frequestmap.get("killing")));
                  	ability.setCounterKilling(Boolean.valueOf(frequestmap.get("counterkilling")));
                  	ability.setMustuseability(Boolean.valueOf(frequestmap.get("mustuse")));
                  	ability.setProbability(Integer.valueOf(frequestmap.get("probability")));
                  	ability.setSelf(Boolean.valueOf(frequestmap.get("self")));
                  	ability.setSwitchchar(Boolean.valueOf(frequestmap.get("switchchar")));
                  	ability.setSwitchnewchar(frequestmap.get("switchnewchar"));
                  	ManageAbilities.getInstance(request.getRealPath(request.getContextPath())).update(request.getParameter("gameset"), request.getParameter("card"), ability.getAbilityId(),ability);
                  }
                  else if(requestmap.containsKey("addactionex") && requestmap.containsKey("gameset") && requestmap.containsKey("card")){
                  	card=ManageCards.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"));
                  	Action action=new Action();
                  	action.setGamemaster(request.getParameter("gamemaster"));
                  	action.setPlayer(request.getParameter("player"));
                  	action.setOndead(Boolean.valueOf(request.getParameter("ondead")));
                  	action.setPosition(Integer.valueOf(request.getParameter("position")));
                  	action.setRound(Integer.valueOf(request.getParameter("round")));
                  	action.setTitle(request.getParameter("title"));	
                  	ManageActions.getInstance(request.getRealPath(request.getContextPath())).add(request.getParameter("gameset"), request.getParameter("card"),action);
                  }
                  else if(requestmap.containsKey("editactionex") && requestmap.containsKey("gameset") && requestmap.containsKey("card")){
                  	card=ManageCards.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"));
                  	Action action=ManageActions.getInstance(request.getContextPath()).get(request.getParameter("gameset"), request.getParameter("card"), request.getParameter("ability"));
                  	action.setGamemaster(request.getParameter("gamemaster"));
                  	action.setPlayer(request.getParameter("player"));
                  	action.setOndead(Boolean.valueOf(request.getParameter("ondead")));
                  	action.setPosition(Integer.valueOf(request.getParameter("position")));
                  	action.setRound(Integer.valueOf(request.getParameter("round")));
                  	action.setTitle(request.getParameter("title"));	
                  	ManageActions.getInstance(request.getPathTranslated()).update(request.getParameter("gameset"), request.getParameter("card"), action.getId(),action);
                  }else if(requestmap.containsKey("card") && requestmap.containsKey("gameset") && requestmap.containsKey("removeability")){
                  	ManageAbilities.getInstance(request.getRealPath(request.getContextPath())).remove(request.getParameter("gameset"), request.getParameter("card"), request.getParameter("ability"));
                  	card=ManageCards.getInstance(request.getPathTranslated()).get(request.getParameter("gameset"), request.getParameter("card"));
                  }else if(requestmap.containsKey("card") && requestmap.containsKey("gameset")){
                  	card=ManageCards.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"), request.getParameter("card"));
                  }
                  }
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
<title><%=(request.getParameter("card")!=null)?bundle.getString("editchar"):bundle.getString("addchar") %> - <%=card.getName()%></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body <%=request.getParameter("file")!=null?"onload=\"setresult()\"":" " %>>
<h1><%=(request.getParameter("card")!=null)?bundle.getString("editchar"):bundle.getString("addchar") %> - <%=card.getName()%></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<form method="post" action="characters.jsp?gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>" enctype="multipart/form-data" >
<table border="0">
<tr><th>Property</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("name") %></td>
<td><input type="text" name="name" value="<%=card.getName() %>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("group") %></td>
<td><select name="group"><%for(Group group:gameset.getGroups()){ %>
<option value="<%=group.getGroupId()%>" <%=group.equals(card.getGroup())?"selected":"" %>><%=group.getGroupname()+"("+group.getGroupIdentifier()+")" %></option>
<%} %></select><a href="editgroup.jsp?gameset=<%=gameset.getGamesetid()%>"><%=bundle.getString("addgroup") %></a></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("picture") %></td>
<td>
<img src="<%=!"".equals(card.getImg())?"data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
		+"/"+card.getCardid()+".png":""%>" id="charimg"/>
<br>
		<input type="file" id="imginput" name="card_img" accept="image/*" value="Upload"/>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("minamount") %></td><td><input type="number" min="1" step="1"  value="<%=card.getMinamount() %>" name="minamount"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("maxamount") %></td><td><input type="number" min="1" step="1"  value="<%=card.getMaxamount() %>" name="maxamount"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("balancevalue") %></td><td><input type="number" min="0" step="1"  value="<%=card.getBalancevalue() %>" name="balancevalue"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("round") %></td>
<td>
<input type="radio" value="0" <%=card.getRound()==0?"checked":"unchecked" %>/>
<%=bundle.getString("everyRound")%><br>
<input type="radio" value="-1" <%=card.getRound()==-1?"checked":"unchecked" %>/>
<%=bundle.getString("noround")%><br>
<input type="radio" value="0" <%=card.getRound()>0?"checked":"unchecked" %>/>
<%=bundle.getString("xround")%>
<input type="number" step="1" min="1" value="<%=card.getRound() %>" name="round"/><br>
<input type="radio" value="0" <%=card.getRound()<-1?"checked":"unchecked" %>/>
<%=bundle.getString("everyXRound")%>
<input type="number" step="1" min="2" value="<%=card.getRound() %>" name="round"/><br>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("position") %></td>
<td><input type="number" step="1" min="0" value="<%=card.getPosition() %>" name="position"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("position2") %></td>
<td><input type="number" step="1" min="-1" value="<%=card.getPosition2() %>" name="position2"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("calleveryone") %></td>
<td><input type="checkbox" name="calleveryone" <%=card.getCalleveryone()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("deadcards") %></td>
<td><input type="checkbox" name="deadchars" <%=card.getDeadchars()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("nopoints") %></td>
<td><input type="checkbox" name="nopoints" <%=card.getNopoints()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("winsalone") %></td>
<td><input type="checkbox" name="winsalone" <%=card.getWinsalone()?"checked":"unchecked" %>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("fixeddeath") %></td>
<td><input type="number" step="1" min="-1" name="fixeddeath" value="<%=card.getFixeddeath()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("winningalivepoints") %></td>
<td><input type="number" min="1" step="1" name="winningalive" value="<%=card.getWinningAlive()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("winningpointsdead") %></td>
<td><input type="number" min="1" step="1" name="winningdead" value="<%=card.getWinningDead()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("extra") %></td>
<td><input type="number" step="1" min="0" name="extra" value="<%=card.getExtra() %>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("deathdelay") %></td>
<td><input type="number" min="0" step="1" name="deathdelay" value="<%=card.getDeathdelay()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("description") %></td>
<td><textarea type="text" name="description"><%=card.getDescription() %></textarea></td></tr>
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
<tr>
<th class="footer"><input type="hidden" name="gameset" value="<%=gameset.getGamesetid()%>"/>
<input type="hidden" name="preset" value="<%=card.getCardid()%>"/>
<button type="submit" value="Save character"><%=bundle.getString("savechar") %></button></th>
<th class="footer">
<a href="editaction.jsp?gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>"><%=bundle.getString("addaction") %></a>
<a href="editability.jsp?gameset=<%=gameset.getGamesetid()%>&card=<%=card.getCardid()%>"><%=bundle.getString("addability") %></a>
</th>
</tr>
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