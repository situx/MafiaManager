<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
          <jsp:include page="locale.jsp" />

    <%
    ResourceBundle bundle = ResourceBundle.getBundle("LNDWAWeb",(Locale)session.getAttribute("locale"));
    String sep=File.separator; 
    File filepath=new File(request.getRealPath(request.getContextPath()).substring(0,request.getRealPath(request.getContextPath()).lastIndexOf('/'))+"/data"+sep+"music"); 
List<String> files=Arrays.asList(filepath.list());
Collections.sort(files);%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Music Player</title>
  <LINK href="style/style.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="style/jquery-ui.css">
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
    <script src="js/jquery-1.10.2.js"></script>
  <script src="js/jquery-ui.js"></script>
  
    <meta charset="utf-8" />

        <script type="text/javascript">
        tracks = [<%int i=1;for(String fil:files){%>
    	{"track":<%=i++%>,"name":<%="\""+fil.substring(0,fil.lastIndexOf("."))+"\""%>
    	,"length":"00:00","file":<%="\""+fil.substring(0,fil.lastIndexOf("."))+"\""%>}
    	<%=i<files.size()+1?",":" "%>
    <%}%>
    ];
            jQuery(function($) {
                var supportsAudio = !!document.createElement('audio').canPlayType;
                if(supportsAudio) {
                    index = 0,
                    playing = false;
                    mediaPath = '<%=request.getContextPath()%>/data/music/',
                    extension = '',
                    trackCount = tracks.length,
                    npAction = $('#npAction'),
                    npTitle = $('#npTitle'),
                    audio = $('#audio1').bind('play', function() {
                        playing = true;
                        npAction.text('<%=bundle.getString("nowplaying")%>');
                    }).bind('pause', function() {
                        playing = false;
                        npAction.text('<%=bundle.getString("paused")%>');
                    }).bind('ended', function() {
                        npAction.text('<%=bundle.getString("paused")%>');
                        if((index + 1) < trackCount) {
                            index++;
                            loadTrack(index);
                            audio.play();
                        } else {
                            audio.pause();
                            index = 0;
                            loadTrack(index);
                        }
                    }).get(0),btnPrev = $('#btnPrev').click(function() {
                        if((index - 1) > -1) {
                            index--;
                            loadTrack(index);
                            if(playing) {
                                audio.play();
                            }
                        } else {
                            audio.pause();
                            index = trackCount-1;
                            loadTrack(trackCount-1);
                        }
                    }),
                    btnNext = $('#btnNext').click(function() {
                        if((index + 1) < trackCount) {
                            index++;
                            loadTrack(index);
                            if(playing) {
                                audio.play();
                            }
                        } else {
                            audio.pause();
                            index = 0;
                            loadTrack(index);
                        }
                    }),btnPlay = $('.btnPlay').click(function(id) {
                        var id = parseInt($(this).attr("name"));
                        if(id !== index) {
                            playTrack(id);
                        }
                    }),li = $('#plUL li').click(function() {
                        var id = parseInt($(this).index());
                        if(id !== index) {
                            playTrack(id);
                        }
                    }),
                    loadTrack = function(id) {
                        $('.plSel').removeClass('plSel');
                        $('#plUL li:eq(' + id + ')').addClass('plSel');
                        npTitle.text(tracks[id].name);
                        index = id;
                        audio.src = mediaPath + tracks[id].file + extension;
                    },
                    playTrack = function(id) {
                        loadTrack(id);
                        audio.play();
                    };
                    if(audio.canPlayType('audio/ogg')) {
                        extension = '.ogg';
                    }
                    if(audio.canPlayType('audio/mpeg')) {
                        extension = '.mp3';
                    }
                    loadTrack(index);
                }
                });
            function hide() {
                var showme = document.getElementById("plUL");
                showme.style.visibility = "visible";
            }
            Array.prototype.move = function (from, to) {
            	  this.splice(to, 0, this.splice(from, 1)[0]);
            	};
            
  $(function() {
	  $( "#sortable" ).sortable({
		  start: function(event, ui) {
		        ui.item.data('start_pos', ui.item.index());
		    },
		    stop: function(event, ui) {
		        var start_pos = ui.item.data('start_pos');
		        if (start_pos != ui.item.index()) {
		        	tracks.move(start_pos,ui.item.index());
		        	$( ".btnPlay" ).each(function( index ) {
		        		$( this ).prop('name', index);
		        		});
		        	if(start_pos==index){
		        		index=ui.item.index();
		        	}
		        }
		    }
		});
    $( "#sortable" ).disableSelection();
  });

  </script>
  <style>
  #sortable { list-style-type: none; margin: 0; padding: 0; width: 60%; }
  #sortable li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; font-size: 1.4em; height: 18px; }
  #sortable li span { position: absolute; margin-left: -1.3em; }
  </style>
  </head>
<body>
<%i=-2; %>
<table><tr <%=i++%2==0?"class=\"alt\"":"" %>><th>Music Player</th></tr>
<tr><td align="center">
<div id="cwrap">
    <div id="nowPlay">
        <h3 id="npAction"><%=bundle.getString("paused")%></h3>
        <div id="npTitle"></div>
    </div>
    <div id="audiowrap">
        <div id="audio0">
            <audio id="audio1" controls="controls" width="300">
                Your browser does not support the HTML5 Audio Tag.
            </audio>
        </div></div>
        <div id="extraControls">
            <button id="btnPrev" class="ctrlbtn">|&lt;&lt; <%=bundle.getString("prevtrack")%></button> 
            <button id="btnNext" class="ctrlbtn"><%=bundle.getString("nexttrack")%> &gt;&gt;|</button>
        </div>
    </div>
    <!--  <div id="plwrap">
        <div class="plHead">
            <div class="plHeadNum">Track</div>
            <div class="plHeadTitle">Title</div>
            <div class="plHeadLength">Length</div>
        </div>-->
        </td></tr>
<tr <%=i++%2==0?"class=\"alt\"":"" %>><td>
            <ul id="sortable">
            <%
i=0;
for(String fil:files){ %>
                        <li id="plUL li" class="ui-state-default" id="<%=i%>">
                        
                        <span class="ui-icon ui-icon-arrowthick-2-n-s"></span><%=fil %>
                        <button class="btnPlay" class="ctrlbtn" name="<%=i++%>">Play</button>
                        </li>

            <%} %></ul></td></tr>
</table>
</body>
</html>