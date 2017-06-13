<%@page import="de.tt.data.datamanagement.ManagePlayers"%>
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
        <%@ page import="com.google.gson.Gson" %>
  <%@ page import="com.example.LNDWA.cards.GameSet" %>
  <%@ page import="com.example.LNDWA.cards.Karte" %>
  <%@ page import="com.example.LNDWA.cards.Group" %>
    <%@ page import="com.example.LNDWA.cards.Player" %>
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
Gson gson=new Gson();
  	Map<String,String[]> requestmap=request.getParameterMap();
                  request.setCharacterEncoding("UTF-8");
                  response.setCharacterEncoding("UTF-8");
                  System.out.println(requestmap.toString());
                  User user=(User)session.getAttribute("login");
                  String[] cards=requestmap.get("cards");
                  String[] excards=requestmap.get("extracards");
                  Data data=Data.getInstance(request.getRealPath(request.getContextPath()));
                  GameSet gameset=data.getGamesetUUIDToGameSet().get(request.getParameter("gameset"));
                  List<Karte> chosencards=new LinkedList<Karte>();
                  List<Karte> extracards=new LinkedList<Karte>();
                  if(cards!=null){
                	  for(String card:cards){
                    	  chosencards.add(gameset.getUuidToCard().get(card));
                	  }
                  }else{
                	  chosencards=gameset.getCards();
                  }
                  if(excards!=null){
                	  for(String card:excards){
                    	  extracards.add(gameset.getUuidToCard().get(card));
                	  }
                  }
                  Collections.sort(chosencards, new Comparator<Karte>() {
                	    public int compare(Karte s1, Karte s2) {
                	        return s1.getPosition().compareTo(s2.getPosition());
                	    }
                	});
                  List<Action> actions=new LinkedList<Action>();
                  for(Karte card:gameset.getCards()){
                  	//if(card.getActionlist().isEmpty()){
                  	//	posToCardAction.put(card.getPosition(),new Tuple<Karte,Action>(card,null));
                  	//}else{
                  		for(Action action:card.getActionlist().values()){
                  			actions.add(action);
                  	//	}
                  	}
                  }
                  ManagePlayers manageplayers=ManagePlayers.getInstance(request.getContextPath());
                  List<Player> players=ManagePlayers.getInstance(request.getContextPath()).getAll();
                 
                  ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));

                  int i=0;
  %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="js/jquery-1.9.1.js"></script>
<script src="js/jquery-ui.js"></script>
<script language="javascript">
//<![CDATA[
var actiontitles=[        
<% for (i=0; i<actions.size(); i++) { %>
"<%= actions.get(i).getTitle() %>"
<%if((i+1)<actions.size()){%>
,
<%}%>
<% } %>]
var actiontexts=[
<% for (i=0; i<actions.size(); i++) { %>
"<%= actions.get(i).getGamemaster() %>"
<%if((i+1)<actions.size()){%>
,
<%}%>
<% } %>]
var gameset=JSON.parse('<%=gameset.toJSON()%>')
var chosencards=JSON.parse('<%=gson.toJson(chosencards)%>')
var actioncounter=-1
var currentaction=null
var activelist=[]
var currentabbconcerns=0
var abouttodie=[]
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
    $("#nextround").click(function(){
    	$('#round').val($('#round').val()+1)
    	$('#curposition').val(-1)
    	actioncounter=-1
    	//Check for winning condiions otherwise continue
    });
    $("#next").click(function(){
        $('.cardimg').off()
        $('img[cardimgpos='+(parseInt($('#curposition').val()))+"]").css('border', "solid 2px black");
        $('#curposition').val(parseInt($('#curposition').val())+1)
        while($('#curposition').val()<chosencards.length && (chosencards[$('#curposition').val()]['round']==-1 
        		|| chosencards[$('#curposition').val()]['dead'] || (chosencards[$('#curposition').val()]['round']!=$('#round').val() && chosencards[$('#curposition').val()]['round']!=0)) ){
            //alert(chosencards[$('#curposition').val()]['name']+" skipped")
        	$('#curposition').val(parseInt($('#curposition').val())+1)
            actioncounter=actioncounter+1;
        }
        actioncounter=actioncounter+1;
        $('img[cardimgpos='+(parseInt($('#curposition').val()))+"]").css('border', "solid 2px blue");
        if($('#curposition').val()>=chosencards.length){
            $('#actiontitle').html(gameset['outrotitle'])
            $('#actiontext').html(gameset['outrotext'])
            $('#next').prop("disabled",true);
            $('#nextround').prop("disabled",true);
            var executeondead=false
            for(var card in abouttodie){
            	alert(abouttodie[card])
            	for(var uuid in abouttodie[card]["uuidToAbility"]){
            		if(abouttodie[card]["uuidToAbility"][uuid]["ondead"] && abouttodie[card]["uuidToAbility"][uuid]["active"]){
            			alert("Need to execute "+abouttodie[card]["uuidToAbility"][uuid])
            			executeondead=true
            			currentabb=abouttodie[card]["uuidToAbility"][uuid]
            			$('.cardimg').mousedown(function() {
                            isDragging = false;
                        })
                        .mousemove(function() {
                            isDragging = true;
                         }).mouseup(function(){
                        	 var elem = $( this );
                        	 executeAbilities(elem)
                         });
            			break
            		}
            	}
            	if(executeondead)
            		break
           		abouttodie[card]['dead']=true;
           		$("img[cardimgid='"+abouttodie[card]['cardid']+"']").addClass("grayscale")
        		$("img[cardimgid='"+abouttodie[card]['cardid']+"']").css('border', "solid 2px gray");
           		$("img[cardimgid='"+abouttodie[card]['cardid']+"']").parent().appendTo('#deadcards')
            }
            
            abouttodie=[]
            var groups={}
            for(var card in chosencards){
            	if(chosencards[card]['dead']==false && chosencards[card]['group']!=undefined 
            			&& chosencards[card]['group']['winsgame']){
            		//alert(JSON.stringify(chosencards[card])+"is alive")
            		groups[chosencards[card]['group']['groupId']]=true
            	}
            }
            if(!executeondead){
            alert("Groups: "+JSON.stringify(groups))
            if(Object.keys(groups).length==1){
            	alert("Game Over - "+JSON.stringify(groups));
            }else{
            $('.cardimg').mousedown(function() {
                isDragging = false;
            })
            .mousemove(function() {
                isDragging = true;
             }).mouseup(function(){
            	//alert(JSON.stringify($(this).parent()))
            	if(chosencards[$(this).attr("cardimgpos")]['dead']==false && !isDragging){
            		chosencards[$(this).attr("cardimgpos")]['dead']=true;
            		$(this).addClass("grayscale")
            		$(this).css('border', "solid 2px gray");
                    $('#next').prop("disabled",false);
                    $('#nextround').prop("disabled",false);
	           		$(this).parent().appendTo('#deadcards')
            	}
            });
            
        	}}
        }else{
            $('#actiontitle').html(actiontitles[actioncounter])
            $('#actiontext').html(actiontexts[actioncounter])
            //alert("Card "+JSON.stringify(chosencards[$('#curposition').val()]))
            if(chosencards[$('#curposition').val()]['uuidToAbility']!=undefined){
            currentabb=chosencards[$('#curposition').val()]['uuidToAbility'][Object.keys(chosencards[$('#curposition').val()]['uuidToAbility'])[0]]
            //alert(JSON.stringify(currentabb))
            concerns=currentabb['concerns']
            if(currentabb['active'] && !currentabb['ondead'] && currentabb['currentamount']>0
            		&& currentabb['availableFrom']>=$('#round').val() 
            		&& (currentabb['availableUntil']<=$('#round').val() 
            				|| currentabb['availableUntil']==-1)){
            	//alert("Click function for abb")
                $('.cardimg').mousedown(function() {
                    isDragging = false;
                })
                .mousemove(function() {
                    isDragging = true;
                 }).mouseup(function(){
                	 var elem = $( this );
                	 executeAbilities(elem)
                 });
            }else{
            	alert("Condition failed to enter click")
            }
            if(currentabb['mustuse']){
                $('#next').prop("disabled",false);
            }
        	}

        }


    });
});//]]>
$( function() {
  $( ".draggable" ).draggable();
} );
function assignActivatedClasses(){
	
}
function executeAbilities(node){
	if(currentabb["killing"]){                			
		abouttodie.push(chosencards[$(node).attr("cardimgpos")])
		$(node).css('border', "solid 2px red");
        $('#next').prop("disabled",false);
        $('#nextround').prop("disabled",false);
        $('.cardimg').off()
	}else if(currentabb["check"]["hascheck"]){
		if(currentabb["check"]["group"] && currentabb["check"]["onlycheck"]){
			var result=chosencards[$(node).attr("cardimgpos")]["group"]["groupId"]==currentabb["check"]["value"] 
			if(result){
				alert("Check positive")
			}else{
				alert("Check negative")
			}
    		$('#next').prop("disabled",false);
            $('#nextround').prop("disabled",false);
		}else if(!currentabb["check"]["group"] && currentabb["check"]["onlycheck"]){
			var result=chosencards[$(node).attr("cardimgpos")]["cardId"]==currentabb["check"]["value"] 
			if(result){
				alert("Check positive")
			}else{
				alert("Check negative")
			}
    		$('#next').prop("disabled",false);
            $('#nextround').prop("disabled",false);
		}
	}else if(currentabb["counterKilling"]){
		//delete abouttodie[$(this)]
		//chosencards[$(this).attr("cardimgpos")]['dead']=false;
		//$(this).removeClass("grayscale")
		$(node).css('border', "solid 2px green");
        $('#next').prop("disabled",false);
        $('#nextround').prop("disabled",false);
	}else if(currentabb["switchchar"]){
		chosencards[$(node).attr("cardimgpos")]["group"]=[]                			
	}else if(currentabb["switchnewchar"]){
		$('#next').prop("disabled",false);
        $('#nextround').prop("disabled",false);
        $('.cardimg').off()           			
	}else if(currentabb["changeGroup"]!=[] && currentabb["currentamount"]>0){
		chosencards[$(node).attr("cardimgpos")]["group"]=[]
		chosencards[$(node).attr("cardimgpos")]["group"]=currentabb["changeGroup"]
		$("groupspan_"+$(node).attr("cardimgpos")).html(currentabb["changeGroup"]["groupIdentifier"])
		$('#next').prop("disabled",false);
        $('#nextround').prop("disabled",false);
        $('.cardimg').off()
	}else{
		$("abbspan_"+$(node).attr("cardimgpos")).html(currentabb["description"])
	}
	if(currentabb["ondead"]){
		currentabb["active"]=false
	}
	$('#next').prop("disabled",false);
    $('#nextround').prop("disabled",false);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=bundle.getString("gameboard")%></title>
 <LINK href="style/style.css" rel="stylesheet" type="text/css">
 <style>
  .draggable { width: 150px; height: 150px; padding: 0.5em; }
  .container .row {margin:20px;text-align:center;}
.container .row img {margin:0 20px;}
.grayscale {
    -webkit-filter: grayscale(100%); /* Chrome, Safari, Opera */
    filter: grayscale(100%);
}
  </style>
</head>
<body <%=request.getParameter("file")!=null?"onload=\"setresult()\"":" " %>>
<h1><%=bundle.getString("gameboard") %></h1>
<jsp:include page="loginstatus.jsp" />
<jsp:include page="menu.jsp" />
<table width="100%">
<tr><td id="actiontitle"><%=gameset.getIntrotitle() %></td>
<td><button type="button" id="next">Next</button></td></tr>
<tr><td id="actiontext"><%=gameset.getIntrotext() %></td>
<td><button type="button" id="nextround" disabled>Next Round</button></td></tr>
<tr><td colspan="2">GameStats: Cards:<%=chosencards.size() %></td></tr>
<tr><td id="gameboard" colspan="1" rowspan="2" valign="top"><div class="container">
<%
i=0;
int j=0;
for(Karte card:chosencards){ %>
<%if(j==0){ %>
<div class="row">
<%} %>
<div id="<%=i++%>" class="ui-widget-content draggable" cardid="<%=card.getCardid() %>" cardpos="<%=card.getPosition() %>">
  <p><img border="1" class="cardimg" src="<%=request.getContextPath()+File.separator+"data"+File.separator+"gamesets"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator+gameset.getLanguage()+"_"+gameset.getGamesetid()
			+File.separator+card.getCardid()+".png"%>" width=100 height=100 cardimgid="<%=card.getCardid() %>" cardimgpos="<%=card.getPosition() %>"/> 
			<span name="cardname_<%=card.getCardid() %>"><%=card.getName() %></span> 
			(<span id="groupspan_<%=card.getCardid() %>"><%=card.getGroup().getGroupIdentifier() %></span>)
			<span id="abbspan_<%=card.getCardid() %>"></span></p>
</div>
<%if(j==3){%>
</div>	
<%j=0;}j++;%>
<%}%>
</div>
</td><td valign="top">Extracards<div class="container">
<%
i=0;
j=0;
for(Karte card:extracards){ %>
<%if(j==0){ %>
<div class="row">
<%} %>
<div id="<%=i++%>"class="ui-widget-content draggable" cardid="<%=card.getCardid() %>" cardpos="<%=card.getPosition() %>">
  <p><img border="1" class="cardimg" src="<%=request.getContextPath()+File.separator+"data"+File.separator+"gamesets"+File.separator+((Locale)session.getAttribute("gamesetlang")).getLanguage()+File.separator+gameset.getLanguage()+"_"+gameset.getGamesetid()
			+File.separator+card.getCardid()+".png"%>" width=100 height=100 cardimgid="<%=card.getCardid() %>" cardimgpos="<%=card.getPosition() %>"/> <span name="cardname_<%=card.getCardid() %>"><%=card.getName() %></span> (<span id="groupspan_<%=card.getCardid() %>"><%=card.getGroup().getGroupIdentifier() %></span>) 
			<span id="abbspan_<%=card.getCardid() %>"></span></p>
</div>
<%if(j==3){%>
</div>	
<%j=0;}j++;%>
<%}%>
</div></td></tr><tr><td valign="top" id="deadcards">Dead Cards</td></tr><tr><td colspan="2">
<input type="hidden" id="curposition" value="-1"/>
<input type="hidden" id="round" value="1"/>
</td></tr>
</table>
</body>