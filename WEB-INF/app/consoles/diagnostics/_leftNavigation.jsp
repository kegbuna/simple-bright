<%@page import="com.kd.kineticSurvey.impl.RemedyHandler"%>
<%@page import="com.kd.kineticSurvey.beans.UserContext"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<ul class="nav nav-pills nav-stacked">
    <li class="<%="Session Monitoring".equals(request.getParameter("navigationItem")) ? "active" : ""%>">
        <a href="<%=request.getContextPath()%>/app/diagnostics/session-monitoring">Session Monitoring</a>
    </li>
    <li class="<%="Server Monitoring".equals(request.getParameter("navigationItem")) ? "active" : ""%>">
        <a href="<%=request.getContextPath()%>/app/diagnostics/server-monitoring">Server Monitoring</a>
    </li>
    <li><hr class="navigation-divider"/></li>
    <li class="<%="Latency".equals(request.getParameter("navigationItem")) ? "active" : ""%>">
        <a href="<%=request.getContextPath()%>/app/diagnostics/latency">Latency</a>
    </li>
</ul>