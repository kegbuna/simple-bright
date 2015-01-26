<%@page import="com.kd.kineticSurvey.impl.RemedyHandler"%>
<%@page import="com.kd.kineticSurvey.beans.UserContext"%>
<% 
    UserContext userContext = (UserContext)session.getAttribute("UserContext");
    boolean isRequestManager = userContext != null && userContext.isRequestManager();
    boolean isManager = userContext != null && userContext.isManager();
    boolean isMigrator = userContext != null && userContext.isMigrator();
    boolean isConfigUser = userContext != null && userContext.isConfigurationUser();
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<ul class="nav nav-pills nav-stacked">
    <% if (isConfigUser || isManager) { %>
    <li class="<%="Setup".equals(request.getParameter("navigationItem")) ? "active" : ""%>"><a href="<%=request.getContextPath()%>/app/admin/setup">Setup</a></li>
    <% } %>
    <% if (RemedyHandler.CREATOR_SLEEP_DELAY > 0 && isRequestManager) { %>
    <li class="<%="Legacy Task Service".equals(request.getParameter("navigationItem")) ? "active" : ""%>"><a href="<%=request.getContextPath()%>/app/admin/legacy-task-service">Legacy Task Service</a></li>
    <% } %>
    <% if (isMigrator) { %>
    <li><hr class="navigation-divider"/></li>
    <li class="<%="Export".equals(request.getParameter("navigationItem")) ? "active" : ""%>"><a href="<%=request.getContextPath()%>/app/admin/export">Export</a></li>
    <li class="<%="Import".equals(request.getParameter("navigationItem")) ? "active" : ""%>"><a href="<%=request.getContextPath()%>/app/admin/import">Import</a></li>
    <% } %>
    <% if (isConfigUser || isManager) { %>
    <li><hr class="navigation-divider"/></li>
    <li class="<%="Caching".equals(request.getParameter("navigationItem")) ? "active" : ""%>"><a href="<%=request.getContextPath()%>/app/admin/caching">Caching</a></li>
    <li class="<%="Environment".equals(request.getParameter("navigationItem")) ? "active" : ""%>"><a href="<%=request.getContextPath()%>/app/admin/environment">Environment</a></li>
    <li class="<%="Logs".equals(request.getParameter("navigationItem")) ? "active" : ""%>"><a href="<%=request.getContextPath()%>/app/admin/logs">Logs</a></li>
    <% } %>
</ul>