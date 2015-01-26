<%@page import="com.kineticdata.ksr.models.Template"%>
<%@page import="com.kd.ksr.profiling.Profiler"%>
<%@page import="com.kd.ksr.profiling.Recording"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%
    Recording recording = (Recording)request.getAttribute("recording");
    Template template = (Template)request.getAttribute("template");
    
    boolean recordingIsGlobal = recording == Profiler.getGlobalRecording();
    boolean recordingIsActive = recording.isActive() && (!recordingIsGlobal || Profiler.isGlobalAnalyticsEnabled());
    
    // Determine the page
    String pageName = request.getRequestURI().endsWith("Graph.jsp") ? "graph" : null;
%>

<%-- ACTIONS --%>
<div class="pull-right btn-group">
    <button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown">
        Actions <span class="caret"></span>
    </button>
    <ul class="dropdown-menu" role="menu">
    <% if (recordingIsGlobal) { %>
        <li><a data-submit-form="clear-server-recording" href="javascript:void(0);">Clear</a></li>
    <% } else { %>
        <% if (recording.isActive()) { %>
        <li><a data-submit-form="new-recording" href="javascript:void(0);">Stop & New</a></li>
        <% } else { %>
        <li><a data-submit-form="new-recording" href="javascript:void(0);">New</a></li>
        <% } %>
        <li><a data-submit-form="delete-recording" href="javascript:void(0);">Delete</a></li>
    <% } %>
    </ul>
</div>
<script>
    $(function() {
        $('[data-submit-form]').click(function() {
            $('#'+$(this).data('submit-form')).submit();
        });
    });
</script>

<%-- REFRESH --%>
<a class="btn btn-primary btn-sm pull-right" 
   style="margin-right: 15px;"
   href="">
    <i class="fa fa-refresh fa-lg"></i>
    Refresh
</a>

<%-- STOP RECORDING --%>
<% if (recordingIsActive) { %>
<div class="pull-right">
    <%
        String action;
        if (recordingIsGlobal) {
            action = request.getContextPath()+"/app/diagnostics/server-monitoring/stop";
        } else {
            action = request.getContextPath()+"/app/diagnostics/session-monitoring/"+escape(recording.getId()+"/stop");
        }
    %>
    <form action="<%=action%>" 
          class="pull-right" 
          style="margin-right: 15px;"
          data-disable-on-submit="disable-on-submit" 
          method="post">
        <button type="submit" class="btn btn-sm btn-danger">
            <i class="fa fa-clock-o fa-lg"></i>
            Stop Recording
        </button>
        <% if (template != null) { %>
            <input type="hidden" id="templateId" name="templateId" value="<%=escape(template.getInstanceId())%>"/>
        <% } else if (pageName != null) { %>
            <input type="hidden" id="page" name="page" value="<%=escape(pageName)%>"/>
        <% } %>
        <% if (session.getAttribute("CsrfToken") != null) { %>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
        <% } %>
    </form>
</div>
<% } %>

<%-- HIDDEN FORMS --%>
<div class="hidden">
    <form id="clear-server-recording" action="<%=request.getContextPath()%>/app/diagnostics/server-monitoring/clear" method="POST">
        <% if (template != null) { %>
        <input type="hidden" id="templateId" name="templateId" value="<%=escape(template.getInstanceId())%>"/>
        <% } else if (pageName != null) { %>
        <input type="hidden" id="page" name="page" value="<%=escape(pageName)%>"/>
        <% } %>
        <% if (session.getAttribute("CsrfToken") != null) { %>
        <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
        <% } %>
    </form>
    <form id="delete-recording" action="<%=request.getContextPath()%>/app/diagnostics/session-monitoring/<%=escape(recording.getId())%>/delete" method="POST">
        <% if (session.getAttribute("CsrfToken") != null) { %>
        <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
        <% } %>
    </form>
    <form id="new-recording"action="<%=request.getContextPath()%>/app/diagnostics/session-monitoring/start" method="POST">
        <% if (session.getAttribute("CsrfToken") != null) { %>
        <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
        <% } %>
    </form>
</div>
    