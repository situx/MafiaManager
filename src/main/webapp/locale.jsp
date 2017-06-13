<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
if(session.getAttribute("locale")==null){
	  session.setAttribute("locale",request.getLocale());
}
if(request.getParameter("changelanguage")!=null && request.getParameter("language")!=null){
	System.out.println("Change Language");
	session.setAttribute("locale", new Locale(request.getParameter("language"),request.getParameter("language").toUpperCase()));
}
if(session.getAttribute("locale")==null){
	session.setAttribute("locale",request.getLocale());
}%>