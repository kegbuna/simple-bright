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
    Profile globalProfile = Profiler.getGlobalProfile();
    Recording activeRecording = Profiler.getActiveRecording();
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
            <div class="title">Kinetic Performance Manager</div>
            <div class="action">
                <a href="<%=request.getAttribute("RequestUri")%>">Refresh</a>
            </div>
            <div class="clear"></div>
        </div>
        
        <div class="section">
            <div class="title" style="width: 300px;">Global Profile (<%= Profiler.isGlobalAnalyticsEnabled() ? "Enabled" : "Disabled"%>)</div>
            <div class="action">
                <a href="<%=request.getAttribute("RequestUri")%>?rid=Global">View</a>
                <a href="<%=request.getAttribute("RequestUri")%>?action=clear">Clear</a>
            </div>
            <div class="clear"></div>
            <% if (Profiler.isGlobalAnalyticsEnabled()) { %>
            <div><a href="<%=request.getAttribute("RequestUri")%>?action=disable">Disable</a> global profiling.</div>
            <% } else { %>
            <div><a href="<%=request.getAttribute("RequestUri")%>?action=enable">Enable</a> global profiling.</div>
            <% } %>
        </div>


        <div class="section">
            <div class="title">Recordings</div>
            <div class="action">
                <% if (activeRecording == null) { %>
                <a href="<%=request.getAttribute("RequestUri")%>?action=startRecording">Start</a>
                <% } else { %>
                <a href="<%=request.getAttribute("RequestUri")%>?action=endRecording&id=<%=activeRecording.getId()%>">End</a>
                <% } %>
                <a href="<%=request.getAttribute("RequestUri")%>?action=clearRecordings">Clear All</a>
            </div>
            <div class="clear"></div>
            <div class="note">Recordings take up memory, and should be deleted when they are no longer necessary.</div>

            <% if (Profiler.hasRecordings()) { %>
            <table width="100%" style="padding-top:1em;">
                <tr>
                    <th>Id</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th width="200"></th>
                </tr>
                <% for (Recording recording : Profiler.getRecordings()) { %>
                <tr>
                    <td><%= recording.getId() %></td>
                    <td><%= recording.getStartDate() %></td>
                    <td>
                        <% if (recording.getEndDate() != null) { %>
                            <%= recording.getEndDate() %>
                        <% } else { %>
                        <div style="font-style: italic;">Active</div>
                        <% } %>
                    </td>
                    <td>
                        <a href="<%=request.getAttribute("RequestUri")%>?rid=<%=recording.getId()%>">View</a>
                        <a href="<%=request.getAttribute("RequestUri")%>?action=deleteRecording&id=<%=recording.getId()%>">Delete</a>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <div>There are no stored recordings.</div>
            <% } %>
        </div>
        
        <%
            Map<String, Template> templateMap = new TreeMap();
            for (ResultGroup group : globalProfile.list().children()) {
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
    </body>
</html>
