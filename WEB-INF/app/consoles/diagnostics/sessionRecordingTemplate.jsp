<%@page import="com.kineticdata.ksr.models.Template"%>
<%@page import="com.kd.ksr.profiling.Recording"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    Recording recording = (Recording)request.getAttribute("recording");
    Template template = (Template)request.getAttribute("template");
    String templateTitle = template.getCatalogName() + " > " + template.getName();
%>
<tag:application>
    <jsp:attribute name="title">Kinetic | Session Monitoring</jsp:attribute>
    <jsp:attribute name="navigationCategory">Diagnostics</jsp:attribute>
    <jsp:attribute name="content">
    <section class="content">
    <div class="container-fluid main-inner">
    <div class="row">
        <%-- LEFT SIDEBAR --%>
        <div class="col-xs-2 sidebar">
            <jsp:include page="/WEB-INF/app/consoles/diagnostics/_leftNavigation.jsp">
                <jsp:param name="navigationItem" value="Session Monitoring"/>
            </jsp:include>
        </div>
        <div class="col-xs-10">
            <div class="row">
                <%-- CENTER CONTENT --%>
                <div class="col-xs-9">
                    <%-- BREADCRUMBS --%>
                    <ol class="breadcrumb">
                        <%=breadcrumb("Session Monitoring", request.getContextPath()+"/app/diagnostics/session-monitoring")%>
                        <%=breadcrumb(escape(recording.getDisplayId()), request.getContextPath()+"/app/diagnostics/session-monitoring/"+escape(recording.getId()))%>
                        <%=breadcrumb(escape(templateTitle))%>
                    </ol>
                    
                    <%-- PAGE HEADER --%>
                    <div class="page-header">
                        <div class="row">
                            <div class="col-xs-7">
                                <h1>
                                    <strong><%=escape(template.getName())%></strong>
                                </h1>
                            </div>
                            <div class="col-xs-5">
                                <dl class="dl-horizontal dl-small-label">
                                    <dt>Started</dt>
                                    <dd><span class="time-ago"><%=recording.getStartTimeIso8601()%></span></dd>
                                    <dt>Stopped</dt>
                                    <dd>
                                    <% if (recording.isActive()) { %>
                                        <span>-</span>
                                    <% } else { %>
                                        <span class="time-ago"><%=recording.getEndTimeIso8601()%></span></dd>
                                    <% } %>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <%-- SESSION MESSAGE --%>
                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                    
                    <%-- BUTTON CONTROLS --%>
                    <jsp:include page="profiling/_buttonControls.jsp"/>
                    <%-- PAGE CONTENT --%>
                    <jsp:include page="profiling/profiledTemplate.jsp"/>
                </div>
                <%-- RIGHT SIDEBAR --%>
                <div class="col-xs-3 sidebar pull-right">
                    <jsp:include page="/WEB-INF/app/consoles/_shared/help.jsp">
                        <jsp:param name="helpType" value="Diagnostic Consoles" />
                        <jsp:param name="helpUrl" value="http://help.kineticdata.com/ksr52/consoles/diagnostics" />
                    </jsp:include>
                    <jsp:include page="/WEB-INF/app/consoles/diagnostics/_sessionHelpText.jsp"/>
                </div>
            </div>
        </div>
    </div>
    </div>
    </section>
    </jsp:attribute>
</tag:application>  