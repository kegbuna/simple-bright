<%-- This page is used for generic messages including errors and confirmation text
**** when a more specific error page or confirmation page attachment has not been specified
--%>
<jsp:useBean id="messageInfo" scope="session" class="com.kd.kineticSurvey.beans.Message" />
<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%@page contentType="text/html; charset=UTF-8"%>
<%
    response.setHeader("CACHE-CONTROL","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
    response.setDateHeader ("EXPIRES", 0); //prevents caching at the proxy server
    response.setHeader("PRAGMA","NO-CACHE");

    String pageName = "";
    String pageText = "";
    String headerFile = null;

    if (messageInfo != null) {
        pageName = messageInfo.getPageName();
        pageText = messageInfo.getMessageText();
        headerFile = messageInfo.getHeaderFile();
    }
    if (headerFile == null || headerFile.trim().length() == 0) {
        String path = request.getContextPath();
        headerFile = path + "/resources/poweredByKS.gif";
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <script type="text/javascript">
            try{top.document.domain;}catch(e){
                var f=function(){document.body.innerHTML="";};
                setInterval(f,1);
                if(document.body){document.body.onload=f;}
            }
        </script>
        <title><%=pageName%></title>
        <link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
    </head>
    <body bgcolor="#FFFFFF" text="#000000">
        <table width="85%" border="0" align="center">
            <%if (headerFile != null) {%>
            <tr>
                <td align="center" valign="middle">
                    <img src="<%=headerFile%>" alt="" vspace="5"/>
                </td>
            </tr>
            <%}%>
            <tr>
                <td align="center" valign="middle">
                    <p>&nbsp;</p>
                    <p><b><%=pageText%></b></p>
                </td>
            </tr>
        </table>
    </body>
    <jsp:setProperty name="UserContext" property="errorMessage" value=""/>
</html>
