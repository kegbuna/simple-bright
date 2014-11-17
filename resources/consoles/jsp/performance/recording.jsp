<%-- 
    Document   : performanceManager
    Created on : Aug 15, 2011, 4:58:05 PM
    Author     : ben.christenson
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.kd.ksr.beans.Template"%>
<%@page import="com.kd.ksr.cache.TemplateCache"%>
<%@page import="com.kd.ksr.profiling.*"%>
<%@page import="com.kineticdata.profiling.Profile"%>
<%@page import="com.kineticdata.profiling.ResultGroup"%>
<%@page import="com.kineticdata.profiling.ResultValue"%>
<%@page import="java.util.*"%>
<%
    Recording recording = (Recording)request.getAttribute("recording");
    if (recording == null) {
        out.println("Unable to locate recording with specified Id.");
        return;
    }

    String rid = recording.getId();
    String view = (String)request.getAttribute("view");
    if (view == null || view.equals("")) {view = "graph";}

    Profile profile = recording.getProfiler().buildProfile();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Performance Manager</title>
        <style type="text/css">
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
            .section .title {float:left; font-size: 1.5em;color: #00427E;}

            a {color: #D95900;}
        </style>
    </head>
    <body>
        <% if (request.getAttribute("warning") != null) { %>
        <div class="warning"><%= request.getAttribute("warning") %></div>
        <% } %>

        <div class="header">
            <div class="title">Kinetic Performance Recording</div>
            <div class="action">
                <a href="<%=request.getAttribute("RequestUri")%>">Home</a>
                <a href="<%=request.getAttribute("RequestUri")%>?<%=request.getAttribute("QueryString")%>">Refresh</a>
            </div>
            <div class="clear"></div>
        </div>

        <table width="100%" style="padding-top:1em;">
            <tr>
                <th>Id</th>
                <th>Start Date</th>
                <th>End Date</th>
            </tr>
            <tr>
                <td><%= rid %></td>
                <td><%= recording.getStartDate() %></td>
                <td>
                    <% if (recording.getEndDate() != null) { %>
                        <%= recording.getEndDate() %>
                    <% } else { %>
                    <div style="font-style: italic;">Active</div>
                    <% } %>
                </td>
            </tr>
        </table>

        <%
            Map<String, Template> templateMap = new HashMap();
            for (ResultGroup group : profile.list().children()) {
                for (ResultValue value : group.values()) {
                    String templateId = value.getAttribute("Template Id");
                    if (templateId != null && !templateMap.containsKey(templateId)) {
                        Template template = TemplateCache.getTemplateByInstanceId(templateId);
                        templateMap.put(templateId, template);
                    }
                }
            }
            if (!templateMap.isEmpty()) {
        %>
        <div class="section">
            <div class="title">Profiled Service Items</div>
            <div class="clear"></div>
            <table width="100%">
                <tr>
                    <th>Name</th>
                    <th>Id</th>
                    <th width="200"></th>
                </tr>
                <% for (Template template : templateMap.values()) { %>
                <tr>
                    <td><%= template.getName() %></td>
                    <td><%= template.getInstanceId() %></td>
                    <td><a href="<%=request.getAttribute("RequestUri")%>?srv=<%=template.getInstanceId()%>">View</a></td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } %>
        
        <div class="section">
            <div class="title">Recording Profile</div>
            <div class="clear"></div>
            <div style="padding-bottom: 1em;">
                <a href="<%=request.getAttribute("RequestUri")%>?rid=<%=rid%>&view=graph">Graph</a>
                <a style="padding-left: 1em;" href="<%=request.getAttribute("RequestUri")%>?rid=<%=rid%>&view=groupedGraph">Graph (Grouped)</a>
                <a style="padding-left: 1em;" href="<%=request.getAttribute("RequestUri")%>?rid=<%=rid%>&view=list">List</a>
                <a style="padding-left: 1em;" href="<%=request.getAttribute("RequestUri")%>?rid=<%=rid%>&view=groupedList">List (Grouped)</a>
            </div>
            <div class="clear"></div>
            <% if ("groupedGraph".equals(request.getAttribute("view"))) { %>
                <div><b>Call Graph (Grouped)</b></div>
                <div class="monospace pre"><% profile.printGroupedCallGraph(new java.io.PrintWriter(out)); %></div>
            <% } else if ("list".equals(request.getAttribute("view"))) { %>
                <div><b>Call List</b></div>
                <div class="monospace pre"><% profile.printCallList(new java.io.PrintWriter(out)); %></div>
            <% } else if ("groupedList".equals(request.getAttribute("view"))) { %>
                <div><b>Call List (Grouped)</b></div>
                <div class="monospace pre"><% profile.printGroupedCallList(new java.io.PrintWriter(out)); %></div>
            <% } else { %>
                <div><b>Call Graph</b></div>
                <div class="monospace pre"><% profile.printCallGraph(new java.io.PrintWriter(out)); %></div>
            <% } %>
            <% if (profile.graph().children().size() == 0) { %>
                <div>There is no profile information available.</div>
            <% } %> 
        </div>
    </body>
</html>
