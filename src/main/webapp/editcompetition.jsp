<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.io.File"%>
<%@ page import="de.tt.data.User" %>
<%@ page import="com.example.LNDWA.cards.Competition" %>
<%@page import="de.tt.data.datamanagement.ManageCompetition"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="locale.jsp" />
    <%
    	User user=(User)session.getAttribute("login");
        ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
        String sep=File.separator; 
        File filepath=new File(request.getRealPath(request.getContextPath()).substring(0,request.getRealPath(request.getContextPath()).lastIndexOf('/'))+"/data"+sep+"music"); 
    List<String> files=Arrays.asList(filepath.list());
    Collections.sort(files);
    Map<String,String[]> requestmap=request.getParameterMap();
    SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat format2=new SimpleDateFormat("hh:mm");
    Competition competition=new Competition();
    ManageCompetition manage=ManageCompetition.getInstance(request.getContextPath());
    if(requestmap.containsKey("competition")){
    	competition=manage.get(request.getParameter("competition"));
    }
    %>
<LINK href="style/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("editcompetition") %></title>
<script src="js/jquery-1.9.1.js"></script>
<script language="javascript">
//<![CDATA[ 
$(window).load(function(){
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#compimg').attr('src', e.target.result);
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
<h1><%=bundle.getString("editcompetition") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:choose>
<c:when test="<%=user!=null && (user.getAdmin() || user.getEdit())%>">
<form action="players.jsp" method="post">
<table>
<%int i=0; %>
<tr><th>Property</th><th>Value</th></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("compfinished") %></td>
<td><input type="checkbox" value="0" <%=competition.getFinished()?"checked":"unchecked" %>/>
<%=bundle.getString("compfinished")%><br></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("name") %></td>
<td><input type="text" name="name" value="<%=competition.getName()%>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("description") %></td>
<td><input type="text" name="description" value="<%=competition.getDescription()%>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("location") %></td>
<td><input type="text" name="location" value="<%=competition.getLocation()%>" required/></td></tr>
<tr><td><%=bundle.getString("image") %></td><td>
<img src="<%=!"".equals(competition.getImg())?"data/competitions/"+competition.getCompetitionid()+".png":""%>" id="compimg"/>
<br>
		<input type="file" id="imginput" name="comp_img" accept="image/*" value="Upload"/>
</td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("registerdeadline") %></td>
<td><input type="datetime-local" name="deadline" autocomplete="on" value="<%=format.format(competition.getRegisterdeadline())+"T"+format2.format(competition.getRegisterdeadline())%>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("starttime") %></td>
<td><input type="datetime-local" name="start" value="<%=format.format(competition.getStart())+"T"+format2.format(competition.getStart())%>" required/></td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td><%=bundle.getString("endtime") %></td>
<td><input type="datetime-local" name="end" value="<%=format.format(competition.getEnd())+"T"+format2.format(competition.getEnd())%>" required/></td></tr>
<tr><th class="footer"><button type="submit"><%=bundle.getString("savecompetition") %></button>
<input type="hidden" name="competition" value="<%=competition.getCompetitionid()%>"/>
<input type="hidden" name="<%=requestmap.containsKey("competition")?"editcompetitionex":"addcompetitionex" %>" value="1"/></th><th class="footer"></th></tr>
</table>
</form>
</c:when>
<c:otherwise><table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr><tr><th></th></tr></table></c:otherwise>
</c:choose>
</body>
</html>