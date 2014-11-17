<%-- This page is used to set the timezone offset for the client machine. --%>
<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");

String referer = (String) request.getSession().getAttribute("tzReferer");
request.getSession().removeAttribute("tzReferer");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <style type="text/css">
            .noscript {margin:0;margin-bottom:10px;padding:20px;font-size:18px;font-family:Arial, Helvetica, sans-serif;color:#000;background-color:#FFF5F5;border:2px solid #d00;text-align:center;}
        </style>
    </head>
    <body>
        <noscript>
            <div class="noscript">You must enable javascript in your browser to use this application.</div>
        </noscript>
        <div id="msg" class="msg"></div>
        <script type="text/javascript">
            (function(){
                var KD = {}; KD.utils = {};
                KD.utils.Session = {
                    establishSession: function () {
                        document.getElementById("msg").innerHTML = "Establishing session...";
                        var referer = "<%= referer %>";
                        // if the referrer is blank, check the history to see if the
                        // user clicked the back button
                        if (referer == null || referer == "null") {
                            // try to go forward in history - user may have hit browser back
                            window.history.forward();
                        } else {
                            var sep = (referer.indexOf("?") == -1) ? "?" : "&";
                            document.location = referer + sep + "tzOffset=" + escape(new Date().getTimezoneOffset());
                        }
                    }
                };
                KD.utils.Session.establishSession();
            })();
        </script>
    </body>
</html>
