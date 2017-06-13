<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Locale"%>
<%@page import="java.io.File"%>
<%@page import="de.tt.data.datamanagement.ManagePresets"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="de.tt.data.datamanagement.ManageGroups" %>
  <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Preset" %>
  <%@ page import="java.util.Map" %>
  <%@ page import="java.util.ResourceBundle" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="locale.jsp" />  
  <%
    	ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
        Map<String,String[]> parametermap=request.getParameterMap();
        User user=(User)session.getAttribute("login");
        request.setCharacterEncoding("UTF-8");
        GameSet gameset=new GameSet();
        List<Preset> presetlist=new LinkedList<Preset>();
        if(user!=null && (user.getAdmin() || user.getEdit())){
        	if(parametermap.containsKey("addpresetex") && parametermap.containsKey("gameset")){
        		Preset pres=new Preset();
        		pres.setPresetName(request.getParameter("presettitle"));
        		pres.setGamesetid(request.getParameter("gameset"));
        		//pres.setPresetId(UUID.randomUUID().toString());
        		//pres.setCardlist(request.getParameterValues("cardamount"));
        	}else if(parametermap.containsKey("editpresetex") && parametermap.containsKey("gameset") && parametermap.containsKey("preset")){
        		Preset pres=ManagePresets.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"), request.getParameter("preset"));
        		pres.setPresetName(request.getParameter("presettitle"));
        		pres.setGamesetid(request.getParameter("gameset"));
        	}else if(parametermap.containsKey("gameset")){
        		gameset=ManageGameSets.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"));

        	}
        }else if(parametermap.containsKey("gameset")){
        	gameset=ManageGameSets.getInstance(request.getRealPath(request.getContextPath())).get(request.getParameter("gameset"));
        }

        System.out.println(gameset.getPresets());
    %> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("presets") %></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css"> 
</head>
<body>
<h1><%=bundle.getString("presets") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
      <c:when test="<%=gameset.getPresets().isEmpty()%>">
      <table height="100%">
      <tr><td style="font-weight:bold;font-size:25pt;text-align:center">
      <%=bundle.getString("nocards") %></td></tr>
      <tr><th class="footer"><c:if test="<%=user!=null && user.getAdmin()%>">
      <form action="editpreset.jsp?gameset=<%=gameset.getGamesetid() %>" method="post">
      <button type="submit"><%=bundle.getString("addpreset") %></button></form></c:if></th></table>
      </c:when>
      <c:otherwise>
      <table><tr><th><%=bundle.getString("image") %></th><th><%=bundle.getString("name") %></th>
      <th><%=bundle.getString("description") %></th>
      <c:if test="<%=user!=null && user.getAdmin()%>"><th><%=bundle.getString("options") %></th></c:if></tr>
<%int i=0;
List<Preset> presets=new LinkedList<Preset>(gameset.getPresets().values());
Collections.sort(presets, new Comparator<Preset>() {
    public int compare(Preset s1, Preset s2) {
    	int result=s1.getPlayer().compareTo(s2.getPlayer());
    	if(result==0){
    		result=s1.getPresetName().compareTo(s2.getPresetName());
    	}
        return result;
    }
});
for(Preset preset:presets){ 
System.out.println(preset.getCardlist().toString());%>
<tr <%=i%2==0?"class=\"alt\"":"" %>>
<td><img border="1" src="<%="data"+File.separator+"gamesets"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator+
((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+gameset.getGamesetid()
+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+gameset.getGamesetid()+".png"%>"/></td><td><%=preset.getPresetName()+"("+preset.getPlayer()+")" %></td>
		<td><%
		String result="";
		for(String cardid:preset.getCardlist().keySet()){
			if(gameset.getUuidToCard().get(cardid)!=null){
				out.print("<a href=\"character.jsp?gameset="+gameset.getGamesetid()+"&card="+cardid+"\">"
			+gameset.getUuidToCard().get(cardid).getName()+"</a> ("+preset.getCardlist().get(cardid)+") ");
			}
			//result+=;
		}
		%>	</td>
		<c:if test="<%=user!=null && user.getAdmin()%>">
		<td><form action="editpreset.jsp?gameset=<%=gameset.getGamesetid()%>&preset=<%=preset.getPresetId()%>" method="post">
		<button type="submit"><%=bundle.getString("editpreset") %></button></form><br>
		<form method="post" action="presets.jsp?removechar=1&gameset=<%=gameset.getGamesetid()%>&preset=<%=preset.getPresetId()%>">
		<button type="submit"><%=bundle.getString("removepreset") %></button></form></td></c:if></tr>
<%i++;} %>

<tr>
<c:if test="<%=user!=null && user.getAdmin()%>"><th class="footer">
<form method="post" action="editpreset.jsp?gameset=<%=request.getParameter("gameset")%>"><button type="submit"><%=bundle.getString("addpreset") %></button></form></th></c:if>
<th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>

</table>
      </c:otherwise>
</c:choose>
</body>
</html>