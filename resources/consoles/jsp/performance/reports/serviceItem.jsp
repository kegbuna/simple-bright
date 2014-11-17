<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.kd.arsHelpers.*"%>
<%@page import="com.kd.kineticSurvey.impl.*"%>
<%@page import="com.kd.ksr.beans.*"%>
<%@page import="com.kd.ksr.cache.*"%>
<%@page import="com.kd.ksr.profiling.*"%>
<%@page import="com.kineticdata.profiling.Profile"%>
<%@page import="java.util.*"%>
<%
    // Retrieve the template
    Template template = (Template)request.getAttribute("Template");
    // If the template doesn't exist, print an error message and prevent further
    // rendering.
    if (template == null) {
        out.println("Unable to locate template with specified Id.");
        return;
    }

    // Retrieve the profile
    Profile profile = (Profile)request.getAttribute("profile");

    // Retrieve the recording
    Recording recording = (Recording)request.getAttribute("recording");

    // Initialize a ArsPrecisionHelper with default context to retrieve the
    // structural information about the template
    ArsPrecisionHelper helper = new ArsPrecisionHelper(RemedyHandler.getDefaultHelperContext());

    // Store the necessary information in the request so that "sub-pages" have
    // access to it.
    request.setAttribute("Template", template);
    request.setAttribute("Profile", profile);
    request.setAttribute("Helper", helper);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Performance Manager</title>
        <style>
            .child .type, .child .name, .child .id {padding-left: 10px;}

            .monospace, .id {font-family: monospace;}
            .results {font-family: monospace; white-space: pre;text-align: right;}

            h2 {color: #00427E; padding: 0; margin: 0; font-size: 1.5em;padding-top: 1em;}

            th.total {text-align: right;}

            body {font-family: sans-serif;}
            th {text-align: left;}

            .clear {clear: both;}
            .monospace {font-family: monospace;}
            .pre {white-space: pre;}
            .note {color: #666; font-style: italic;}
            .warning {background: #FF9999; border: 1px solid red;text-align: center;}

            .action {float:left; margin-left: 1em;}
            .title {color: #D95900;}
            .header .action {line-height: 2em;}
            .header .title {float:left; font-size: 2em; font-weight: bold; }
            .section {margin-top: 1em; }
            .section .action {line-height: 1.5em;}
            .section .title {float:left; font-size: 1.5em;}

            a {color: #D95900;}
        </style>

    </head>
    <body>
        <% if (request.getAttribute("warning") != null) { %>
        <div class="warning"><%= request.getAttribute("warning") %></div>
        <% } %>

        <div class="header">
            <div class="title">Kinetic Template Performance</div>
            <div class="action">
                <a href="<%=request.getAttribute("RequestUri")%>">Home</a>
                <% if (recording != null) { %>
                <a href="<%=request.getAttribute("RequestUri")%>?rid=<%=recording.getId()%>">Recording</a>
                <% } %>
                <a href="<%=request.getAttribute("RequestUri")%>?<%=request.getAttribute("QueryString")%>">Refresh</a>
            </div>
            <div class="clear"></div>
        </div>

        <div>
            <b>Catalog:</b>
            <%= template.getEntry().getEntryFieldValue("600000500")%>
            (<span class="monospace"><%= template.getEntry().getEntryFieldValue("700001923")%></span>)
        </div>
        <div>
            <b>Template:</b>
            <%= template.getName() %>
            (<span class="monospace"><%= template.getInstanceId()%></span>)
        </div>

        <jsp:include page="serviceItem/displayPage.jsp"/>

        <jsp:include page="serviceItem/simpleDataRequest.jsp"/>

        <jsp:include page="serviceItem/submitPage.jsp"/>

        <jsp:include page="serviceItem/previousPage.jsp"/>
    </body>
</html>
