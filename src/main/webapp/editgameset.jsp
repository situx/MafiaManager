<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TreeSet"%>
<%@page import="de.tt.Utils.Tuple"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Edit GameSet</title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
  <%@ page import="de.tt.data.Data" %>
  <%@ page import="de.tt.data.User" %>
  <%@ page import="de.tt.data.datamanagement.ManageGameSets" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="java.util.ResourceBundle" %>
    <%@ page import="java.util.Map" %>
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
    function readURL2(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#charimg2').attr('src', e.target.result);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    $("#imginput").change(function(){
        readURL(this);
    });
    $("#imginput2").change(function(){
        readURL2(this);
    });
});//]]>
</script>
</head>
  <jsp:include page="locale.jsp" />
<%
	Data data=Data.getInstance(request.getContextPath());
ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
User user=(User)session.getAttribute("login");
request.setCharacterEncoding("UTF-8");
Map<String,String[]> requestmap=request.getParameterMap();
GameSet gameset=new GameSet();
if(requestmap.containsKey("gameset")){
	gameset=ManageGameSets.getInstance(request.getContextPath()).get(request.getParameter("gameset"));	
}
int i=0;
%>
<body>
<h1><%=bundle.getString("editgameset") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<form action="gameset.jsp<%=requestmap.containsKey("gameset")?"?editgamesetex=1":"?addgamesetex=1" %>&gameset=<%=gameset.getGamesetid() %>" method="post" enctype="multipart/form-data">
<table><tr><th>Option</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td>Title:</td><td><input type="hidden" name="gameset" value="<%=gameset.getGamesetid()%>"/>
<input type="text" name="title" value="<%=gameset.getTitle()%>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("minplayers") %></td>
<td><input type="number" step="1"  name="minplayers" value="<%=gameset.getFromPlayers()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("maxplayers") %></td>
<td><input type="number" step="1"  name="maxplayers" value="<%=gameset.getToPlayers()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("introtitle") %></td>
<td><input type="text"  name="introtitle" value="<%=gameset.getIntrotitle()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("editintrotext") %></td>
<td><textarea name="introtext"><%=gameset.getIntrotext()%></textarea></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("outrotitle") %></td>
<td><input type="text" name="outrotitle" value="<%=gameset.getOutrotitle()%>"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("editoutrotext") %></td>
<td><textarea name="outrotext"><%=gameset.getOutrotext()%></textarea></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("locale") %></td>
<td><select name="language">
<%List<Locale> list = Arrays.asList(SimpleDateFormat.getAvailableLocales());
Set<Tuple<String,String>> locales=new TreeSet<Tuple<String,String>>();
for(Locale loc:list){
	locales.add(new Tuple<String,String>(loc.getDisplayLanguage((Locale)session.getAttribute("locale")),loc.getLanguage()));
}
for(Tuple<String,String> loc:locales){ %>
<option value="<%=loc.getTwo()%>"<%=(!requestmap.containsKey("gameset") 
		&& loc.getTwo().equals(((Locale)session.getAttribute("gamesetlang")).getLanguage())) || (requestmap.containsKey("gameset") 
		&& loc.getTwo().equals(gameset.getLanguage()))?"selected":" " %>>
<%=loc.getOne() %></option>
<%} %>
</select></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("balancevalue") %></td>
<td><input type="checkbox" name="balancevalue" <%=gameset.getHasBalance()?"checked":"unchecked"%>/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td>GamesetImage:</td><td><img src="<%=gameset.getSourcefile().equals("")?" ":("data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+gameset.getGamesetid()+"/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+gameset.getGamesetid()+
		".png")%>" id="charimg"/><br><input type="file" accept="image/png" value="Upload" id="imginput" name="gameset_img"/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td>Back Image:</td><td><img src="<%=gameset.getSourcefile().equals("")?" ":("data/gamesets/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+gameset.getGamesetid()+"/"+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+gameset.getGamesetid()+"_back"+
		".png")%>" id="charimg2"/><br><input type="file" accept="image/png" value="Upload" id="imginput2" name="gamesetback_img"/></td></tr>
<tr><th class="footer">

<button type="submit"><%=bundle.getString("savegameset") %></button></th><th></th></tr>
</table>
</form>
</c:when>
<c:otherwise>
<table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr>
</table>
</c:otherwise>
</c:choose>

</body>
</html>