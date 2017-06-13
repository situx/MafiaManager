<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ResourceBundle"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
      <%@ page import="de.tt.data.User" %>
      <%@ page import="de.tt.data.FileUploader" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

    <%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="locale.jsp" />  
<%ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
Map<String,String[]> parametermap=request.getParameterMap();
User user=(User)session.getAttribute("login");
String sep=File.separator;
request.setCharacterEncoding("UTF-8");
if(parametermap.containsKey("delete") && parametermap.containsKey("file")){
	File file=new File(pageContext.getServletContext().getInitParameter("music-upload")+request.getParameter("file"));
	if(file.exists()){
		file.delete();
	}
}
int j=0;%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("musicman")
%></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<h1><%=bundle.getString("musicman") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<c:if test='<%=(user!=null && user.getAdmin()) && request.getContentType()!=null &&request.getContentType().indexOf("multipart/form-data") >= 0 %>'>
<table>
<%FileUploader uploader=new FileUploader();%>
<%=uploader.uploadFiles(request.getRealPath(request.getContextPath())+sep+"data",
		"music-upload","",null,pageContext.getServletContext(), (Locale)session.getAttribute("locale"), request).get("file")%>
</table>
</c:if>
<c:choose>
<c:when test='<%=user!=null && user.getAdmin()%>'>
<%File filepath=new File(request.getRealPath(request.getContextPath())+sep+"/data"+sep+"music");
List<String> files=Arrays.asList(filepath.list());%> 
<table border="0">
<tr><th>File</th><th>Value</th></tr>
<%Collections.sort(files);
for(String fil:files){ %>
<tr <%=j++%2==0?"class=\"alt\"":"" %>><td>
<%=fil%><br>
<audio controls>
<source src='<%=request.getContextPath()+"/data/music/"+fil %>' type="audio/mpeg"></source>
</audio></td>
<td><form action="musicmanagement.jsp" method="post">
<input type="hidden" name="file" value="<%=fil %>"/>
<input type="hidden" name="delete" value="1"/>
<button type="submit"><%=bundle.getString("deletefile") %></button></form>
</td></tr>
<%} %>
<tr><th class="footer"><form action="musicmanagement.jsp" method="post"
                        enctype="multipart/form-data">
<input type="file" name="file" size="50" />
<br />
<input type="submit" value="Upload File" />
</form></th><th class="footer"></th></tr>
</table>
</c:when>
<c:otherwise>
<table><tr><td style="font-weight:bold;font-size:25pt;text-align:center"><%=bundle.getString("notloggedin") %></td></tr>
<tr><th></th></tr></table></c:otherwise>
</c:choose>

</body>
</html>