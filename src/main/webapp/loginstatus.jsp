<%@page import="de.tt.Utils.Tuple"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Collections"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="de.tt.data.BreadCrumbManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="java.util.ResourceBundle" %>
        <%@ page import="de.tt.data.User" %>
<% User login=(User)session.getAttribute("login"); 
ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
BreadCrumbManager breadcrumbs;
if(session.getAttribute("breadcrumb")!=null){
	breadcrumbs=(BreadCrumbManager)session.getAttribute("breadcrumb");
}else{
	breadcrumbs=new BreadCrumbManager();
	session.setAttribute("breadcrumb",breadcrumbs);
}
if(request.getParameter("logout")!=null){
	session.setAttribute("login",null);
	breadcrumbs.clear();
}
breadcrumbs.addBreadCrumb(request.getRequestURL().toString()+request.getQueryString()!=null?"?"+request.getQueryString():" ", request.getRequestURL().substring(request.getRequestURL().lastIndexOf("/")+1,request.getRequestURL().lastIndexOf(".")));
session.setAttribute("breadcrumb",breadcrumbs);
%>
<table style="border: 0px solid black;">
<c:choose>
<c:when test="<%=login!=null%>">
<tr><th colspan=3 class=footer> <%=bundle.getString("welcome")+" "+login.getUsername()%></th>
<th align=right><form method="post" action="<%=request.getRequestURL() %>?logout=true"><button type="submit">
<%=bundle.getString("logout") %></button></form></th></tr>
</c:when>
<c:otherwise>
<tr><th colspan=3 class=footer> <%=bundle.getString("welcome")+"! "+bundle.getString("youarenotloggedin")%><%=breadcrumbs.length() %></th>
<th align=right>
<form method="post" action="index.jsp"><button type=submit><%=bundle.getString("login") %></button></form>
</th></tr>
</c:otherwise>
</c:choose>
<tr align=left><th colspan="3">
<c:if test="<%=!breadcrumbs.isEmpty() %>">
<a href="<%=breadcrumbs.getBreadCrumb(0).getOne()%>"><%=bundle.getString(breadcrumbs.getBreadCrumb(0).getTwo()) %></a>
<%for(int i=1;i<breadcrumbs.length();i++){ %>
» <a href="<%=breadcrumbs.getBreadCrumb(i).getOne()%>"><%=bundle.getString(breadcrumbs.getBreadCrumb(i).getTwo()) %></a>
<%} %>
</c:if>
<th align=right>
<form method="post" action="<%=request.getRequestURL()+request.getQueryString()!=null?"?"+request.getQueryString():" "%>">
<a href="music.jsp" target="_blank"><img src="img/music.png" width=20 height=20/> </a><%=bundle.getString("language") %>
<select name="language">
<%Locale locale=(Locale)session.getAttribute("locale");
List<Locale> list = Arrays.asList(SimpleDateFormat.getAvailableLocales());
Set<Tuple<String,String>> locales=new TreeSet<Tuple<String,String>>();
for(Locale loc:list){
	locales.add(new Tuple<String,String>(loc.getDisplayLanguage(locale),loc.getLanguage()));
}
for(Tuple<String,String> loc:locales){ %>
<option value="<%=loc.getTwo()%>"<%=loc.getTwo().equals(locale.getLanguage())?"selected":" " %>>
<%=loc.getOne() %></option>
<%} %>
</select>
<input type="hidden" name="changelanguage"/>
<button type="submit"><%=bundle.getString("changelanguage") %></button>
</form></th></tr>
</table>