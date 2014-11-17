<%--
 Copyright (c) 2013, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="propertiesInfo" scope="request" class="com.kd.kineticSurvey.beans.CurrentProperties" />
<jsp:useBean id="logViewer" scope="session" class="com.kd.kineticSurvey.beans.LogViewer" />
<%@ page import="com.kd.kineticSurvey.impl.SurveyLogger"%>
<%@ page import="com.kd.kineticSurvey.record.KineticRecordPollerAdmin"%>
<%
String curClass = "light";
logViewer.initialize(SurveyLogger.getPollerLoggingFile());
%>
<div id="poller">
    <div class="wrapper">
        <h3>Description</h3>
        <div class="window">
            <ul>
                <li class="light">
                    Tasks are stopped and started from this page.
                    Tasks in Kinetic Request give you the ability to extend the functionality of your service items.
                    You can use tasks to add approvals, or create entries in other Remedy forms, or other systems.
                    (Important note for users of multiple webservers:
                    You must go to each individual server to stop and start Tasks for that server.)
                </li>
            </ul>
        </div>
    </div>
    <div class="wrapper">
        <h3>Settings</h3>
        <div class="window">
            <table>
                <% if (propertiesInfo.getProperty("CREATOR_SLEEP_DELAY").equals("0")) {%>
                <tr class="light">
                    <th>Current Status</th>
                    <td>Disabled</td>
                </tr>
                <% } else {%>
                <tr class="light">
                    <th>Service</th>
                    <td>Kinetic Record Poller</td>
                </tr>
                <tr class="dark">
                    <th>Current Status</th>
                    <td><%=KineticRecordPollerAdmin.getRecordPoller().getState()%></td>
                </tr>
                <tr class="light">
                    <th>Change Status</th>
                    <td>
                        <form action="TaskManagerServlet" method="post" style.display="inline">
                            <input type="hidden" name="curActive" value="task_manager" />
                            <input type="submit" name="operation" value="Start" />
                            <input type="submit" name="operation" value="Stop" />
                        </form>
                    </td>
                </tr>
                <% }%>
            </table>
        </div>
    </div>

    <% if (!propertiesInfo.getProperty("CREATOR_SLEEP_DELAY").equals("0")) {%>
    <div class="wrapper">
        <h3><span style="margin-left:-40px;"><a href="LogCopyDownload?type=poller" class="download">Download Complete Log</a></span></h3>
    </div>
    <% } %>
</div>