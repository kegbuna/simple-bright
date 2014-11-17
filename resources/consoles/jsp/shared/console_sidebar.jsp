<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.kd.kineticSurvey.impl.LicenseValidation" %>
<jsp:useBean id="remedyHandler" scope="request" class="com.kd.kineticSurvey.impl.RemedyHandler" />
<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext" />
<%
String pageName = (String)request.getAttribute("pageName");
String kineticTaskServer = (String) session.getAttribute("kineticTaskServer");
boolean isAdmin = false;
if (UserContext != null && UserContext.getArContext() != null) {
    isAdmin = com.kd.kineticSurvey.impl.SurveyUtilities.isAdminUser(UserContext.getArContext());
}
%>
<div class="yui-b">
    <ul id="sidebar">
        <%if (isAdmin) {%>
        <%if (!pageName.equalsIgnoreCase("Admin Console")){ %>
        <li class="header">Administration</li>
        <li class="link">
          <a href="<%=request.getContextPath()%>/AdminConsole">Admin Console</a>
        </li>
        <%} %>
        <%if (kineticTaskServer != null && kineticTaskServer.length() > 0){ %>
        <li class="header">Kinetic Task</li>
        <li class="link">
          <a href="<%=kineticTaskServer%>AdminConsole" target="_blank">Task Administration</a>
        </li>
        <li class="link">
          <a href="<%=kineticTaskServer%>ConfigurationConsole" target="_blank">Task Configuration</a>
        </li>
        <li class="link">
          <a href="<%=kineticTaskServer%>ManagementConsole" target="_blank">Task Management</a>
        </li>
        <%} %>
        <% } %>

        <!-- START TOMCAT ADMINISTRATION LINKS -->
        <!--<<START_TOMCAT_LINKS>><li class="header">Tomcat Admin</li><<END_TOMCAT_LINKS>>-->
        <!--<<START_TOMCAT_ADMIN_LINK>><li class="link"><a href="http://<<WEB_SERVER>>/admin" target="_blank">Admin App</a></li><<END_TOMCAT_ADMIN_LINK>>-->
        <!--<<START_TOMCAT_MANAGER_LINK>><li class="link"><a href="http://<<WEB_SERVER>>/manager/html" target="_blank">Manager App</a></li><<END_TOMCAT_MANAGER_LINK>>-->
        <!-- END TOMCAT ADMINISTRATION LINKS -->
    </ul>
</div>
