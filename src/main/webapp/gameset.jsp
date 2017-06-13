<%@page import="de.tt.data.FileUploader"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="de.tt.Utils.Tuple"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Locale"%>
<%@page import="java.io.File"%>
<%@page import="de.tt.data.datamanagement.ManageGameSets"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
 <%@ page import="de.tt.data.Data" %>
 <%@ page import="de.tt.data.User" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
    <%@ page import="java.util.ResourceBundle" %>
    <%@ page import="java.util.Map" %>
<jsp:include page="locale.jsp" />    
  <%
      	Data data=Data.getInstance(request.getRealPath(request.getContextPath()));
                          User user=(User) session.getAttribute("login");
                          request.setCharacterEncoding("UTF-8");
                          response.setCharacterEncoding("UTF-8");
                          Locale locale=(Locale)session.getAttribute("locale");
                          System.out.println(locale.getLanguage());
                          ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",locale);
                          Map<String,String[]> requestmap=request.getParameterMap();
                          ManageGameSets manage=ManageGameSets.getInstance(request.getPathTranslated());
                          if(session.getAttribute("gamesetlang")==null){
                        	  session.setAttribute("gamesetlang", locale);
                          }
                          if(requestmap.containsKey("gamesetlang")){
                        	  session.setAttribute("gamesetlang", new Locale(request.getParameter("gamesetlang"),request.getParameter("gamesetlang").toUpperCase()));
                          }
                          Locale gamesetloc=(Locale)session.getAttribute("gamesetlang");
                          if(user!=null && (user.getAdmin() || user.getEdit())){
                        	  	System.out.println("User yeah!");
                            	if(requestmap.containsKey("addgamesetex")){
                            		System.out.println("Contains AddGameSetEx");

                            		Map<String,String> frequestmap=new FileUploader().uploadFiles(request.getRealPath(request.getContextPath())+File.separator+"data"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator,
                            				"gameset-upload",
                            				((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+request.getParameter("gameset")
                            				,((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+request.getParameter("gameset")+".png",pageContext.getServletContext(), (Locale)session.getAttribute("gamesetlang"), request);
                            		System.out.println(frequestmap.toString());
                            		GameSet gameset=new GameSet();
                            		gameset.setGamesetid(frequestmap.get("gameset"));
                            		gameset.setLanguage(frequestmap.get("language"));
                            		gameset.setFromPlayers(Integer.valueOf(frequestmap.get("minplayers")));
                            		gameset.setToPlayers(Integer.valueOf(frequestmap.get("maxplayers")));
                            		gameset.setTitle(frequestmap.get("title"));
                            		gameset.setIntrotitle(frequestmap.get("introtitle"));
                            		gameset.setOutrotitle(frequestmap.get("outrotitle"));
                            		gameset.setIntrotext(frequestmap.get("introtext"));
                            		gameset.setOutrotext(frequestmap.get("outrotext"));
                            		gameset.setHasBalance(Boolean.valueOf(frequestmap.get("balancevalue")));
                            		System.out.println("Locale: "+frequestmap.get("locale"));
                            		/*String result=gameset.getGamesetid()+".png";
                            		result=result.substring(8,result.length()-8);
                            		gameset.setGamesetImg(result.substring(result.lastIndexOf(File.separator)+1));
                            		System.out.println(result.substring(result.lastIndexOf(File.separator)+1));
                            		result=gameset.getGamesetid()+".png";
                            		result=result.substring(8,result.length()-8);
                            		gameset.setGamesetImg(result.substring(result.lastIndexOf(File.separator)+1));
                            		System.out.println(result.substring(result.lastIndexOf(File.separator)+1));
                            		*/
                            		System.out.println(gameset.toString());
                            		ManageGameSets.getInstance(request.getPathTranslated()).add(gameset);
                            		ManageGameSets.getInstance(request.getPathTranslated()).saveGameSet(gameset.getGamesetid());
                        	}else if(requestmap.containsKey("editgamesetex")){
                        		System.out.println("Contains editgamesetex");

                        		Map<String,String> frequestmap=new FileUploader().uploadFiles(request.getRealPath(request.getContextPath())+File.separator+"data"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator,
                        		"gameset-upload",
                        		((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+request.getParameter("gameset")
                        		,((Locale)session.getAttribute("gamesetlang")).getLanguage()+"_"+request.getParameter("gameset")+".png",pageContext.getServletContext(), (Locale)session.getAttribute("gamesetlang"), request);
                        		System.out.println(frequestmap.toString());

                        		GameSet gameset=manage.get(frequestmap.get("gameset"));
                        		gameset.setGamesetid(frequestmap.get("gameset"));
                        		gameset.setLanguage(frequestmap.get("language"));
                        		gameset.setFromPlayers(Integer.valueOf(frequestmap.get("minplayers")));
                        		gameset.setToPlayers(Integer.valueOf(frequestmap.get("maxplayers")));
                        		gameset.setTitle(frequestmap.get("title"));
                        		gameset.setIntrotitle(frequestmap.get("introtitle"));
                        		gameset.setOutrotitle(frequestmap.get("outrotitle"));
                        		gameset.setIntrotext(frequestmap.get("introtext"));
                        		gameset.setOutrotext(frequestmap.get("outrotext"));
                        		gameset.setHasBalance(Boolean.valueOf(frequestmap.get("balance")));
                        		gameset.setLanguage(frequestmap.get("language"));
                        		gameset.setGamesetImg(frequestmap.get("language")+"_"+frequestmap.get("gameset"));
                        		/*System.out.println(result.substring(result.lastIndexOf(File.separator)+1));
                        		result=frequestmap.get("backimg");
                        		result=result.substring(8,result.length()-8);*/
                        		gameset.setBackImg(frequestmap.get("language")+"_"+frequestmap.get("gameset")+"_back");
                        		//System.out.println(result.substring(result.lastIndexOf(File.separator)+1));
                        		manage.update(frequestmap.get("gameset"),gameset);
                        		manage.saveGameSet(frequestmap.get("gameset"));
                        	}else if(requestmap.containsKey("removegamesetex") && requestmap.containsKey("gameset")){
                        		manage.remove(request.getParameter("gameset"));
                        	}
                        }
      %>
<title><%=bundle.getString("gameset") %></title>
</head>
<body>
<h1><%=bundle.getString("gameset") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />

<table><tr><th><%=bundle.getString("image") %></th><th><%=bundle.getString("gamesetname") %></th><th><%=bundle.getString("players") %></th><th><%=bundle.getString("options") %></th><th  align="right">
<form method="post" action="gameset.jsp">
<select name="gamesetlang">
<%List<Locale> list = Arrays.asList(SimpleDateFormat.getAvailableLocales());
Set<Tuple<String,String>> locales=new TreeSet<Tuple<String,String>>();
for(Locale loc:list){
	locales.add(new Tuple<String,String>(loc.getDisplayLanguage(locale),loc.getLanguage()));
}
for(Tuple<String,String> loc:locales){ %>
<option value="<%=loc.getTwo()%>"<%=loc.getTwo().equals(gamesetloc.getLanguage())?"selected":" " %>>
<%=loc.getOne() %></option>
<%} %>
</select>
<button type="submit">
Go</button>
</form></th></tr>
Path: 
<%=request.getRealPath(request.getContextPath()) %>
User:
<%=user.toString() %>
Gameset Amount:
<%=data.getGameSets(gamesetloc).size() %>
Gamesetloc:
<%=gamesetloc %>
<%  System.out.println(gamesetloc.getLanguage());
int i=0;for(GameSet gameset:data.getGameSets(gamesetloc)){ %>
<tr <%=i%2==0?"class=\"alt\"":"" %>><td  rowspan="<%=user!=null && (user.getAdmin() || user.getEdit())?"5":"4"%>">
<c:choose>
<c:when test="<%=(user!=null && (user.getAdmin() || user.getEdit())) %>">
<a href="<%=request.getContextPath()%>/rest/lndwa/download/<%=gameset.getGamesetid()%>/<%=gamesetloc.getLanguage()  %>/<%=locale.getLanguage() %>
?context=<%=request.getContextPath()%>">
<img src="<%=request.getContextPath()+"/data/gamesets/"+gamesetloc.getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()+".png"%>"/></a>
</c:when>
<c:otherwise>
<img src="<%=request.getContextPath()+"/data/gamesets/"+gamesetloc.getLanguage()+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()
+"/"+gameset.getLanguage()+"_"+gameset.getGamesetid()+".png"%>"/>
</c:otherwise>
</c:choose>
</td><td rowspan="<%=user!=null && (user.getAdmin() || user.getEdit())?"5":"4"%>"><b><%=gameset.getTitle() %></b></td>
<td rowspan="<%=user!=null && (user.getAdmin() || user.getEdit())?"5":"4"%>">
<%=gameset.getFromPlayers()%>-<%=gameset.getToPlayers()%> <%=bundle.getString("players") %></td>
<td colspan="2" align="right"><a href="characters.jsp?gameset=<%=gameset.getGamesetid()%>"><%=bundle.getString("characters") %></a></td></tr>
<tr <%=i%2==0?"class=\"alt\"":"" %>><td colspan="2"  align="right">
<a href="events.jsp?gameset=<%=gameset.getGamesetid()%>"><%=bundle.getString("events") %></a></td></tr>
<tr <%=i%2==0?"class=\"alt\"":"" %>><td colspan="2"  align="right">
<a href="groups.jsp?gameset=<%=gameset.getGamesetid()%>"><%=bundle.getString("groups") %></a></td></tr>
<tr <%=i%2==0?"class=\"alt\"":"" %>><td colspan="2"  align="right">
<a href="preset.jsp?gameset=<%=gameset.getGamesetid()%>"><%=bundle.getString("presets") %></a></td></tr>
<c:if test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<tr <%=i%2==0?"class=\"alt\"":"" %>>
<td colspan="2"  align="right"><a href="editgameset.jsp?gameset=<%=gameset.getGamesetid()%>"><%=bundle.getString("editgameset") %></a><br>
<a href="gameset.jsp?removegamesetex=1&gameset=<%=gameset.getGamesetid()%>"><%=bundle.getString("removegameset") %></a></td></tr></c:if>
<%i++;}%>

<tr><th class="footer">
<c:if test="<%=user!=null && (user.getAdmin() || user.getEdit())%>"><form action="editgameset.jsp">
<button type="submit"><%=bundle.getString("addgameset") %></button></form></c:if>
<th class="footer"></th><th class="footer"></th><th class="footer"></th><th class="footer"></th></tr>

</table>
</body>
</html>