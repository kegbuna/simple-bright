<%@page import="com.kd.ksr.profiling.Profiler"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    
%>
<tag:application>
    <jsp:attribute name="title">Kinetic | Server Monitoring</jsp:attribute>
    <jsp:attribute name="navigationCategory">Diagnostics</jsp:attribute>
    <jsp:attribute name="content">
    <section class="content">
    <div class="container-fluid main-inner">
    <div class="row">
        <%-- LEFT SIDEBAR --%>
        <div class="col-xs-2 sidebar">
            <jsp:include page="/WEB-INF/app/consoles/diagnostics/_leftNavigation.jsp">
                <jsp:param name="navigationItem" value="Server Monitoring"/>
            </jsp:include>
        </div>
        <div class="col-xs-10">
            <div class="row">
                <%-- CENTER CONTENT --%>
                <div class="col-xs-9">
                    <%-- PAGE HEADER --%>
                    <div class="page-header">
                        <h3>
                            Server Monitoring
                            <%-- Start Recording Button --%>
                            <% if (!Profiler.isGlobalAnalyticsEnabled()) {%>
                            <form action="<%=request.getContextPath()%>/app/diagnostics/server-monitoring/start" 
                                  class="pull-right" 
                                  data-disable-on-submit="disable-on-submit" 
                                  method="post">
                                <button type="submit" class="btn btn-sm btn-success">
                                    <i class="fa fa-clock-o fa-lg"></i>
                                    Start Recording
                                </button>
                                <% if (session.getAttribute("CsrfToken") != null) { %>
                                  <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
                                <% } %>
                            </form>
                            <% } %>
                        </h3>
                    </div>
                    <%-- SESSION MESSAGE --%>
                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                    
                    <%-- PAGE CONTENT --%>
                    <div class="tab-content">
                        <%-- BUTTON CONTROLS --%>
                        <jsp:include page="profiling/_buttonControls.jsp"/>
                        
                        <%-- TABS --%>
                        <ul class="nav nav-pills sub-nav">
                            <li class="active">
                                <a href="<%=request.getContextPath()%>/app/diagnostics/server-monitoring">Profiled Templates</a>
                            </li>
                            <li>
                                <a href="<%=request.getContextPath()%>/app/diagnostics/server-monitoring/call-graph">Call Graph</a>
                            </li>
                        </ul>
                            
                        <%-- TAB CONTENT --%>
                        <jsp:include page="profiling/profiledTemplates.jsp"/>
                    </div>
                </div>
                <%-- RIGHT SIDEBAR --%>
                <div class="col-xs-3 sidebar pull-right">
                    <jsp:include page="/WEB-INF/app/consoles/_shared/help.jsp">
                        <jsp:param name="helpType" value="Diagnostic Consoles" />
                        <jsp:param name="helpUrl" value="http://help.kineticdata.com/ksr52/consoles/diagnostics" />
                    </jsp:include>
                    <jsp:include page="/WEB-INF/app/consoles/diagnostics/_serverHelpText.jsp"/>
                </div>
            </div>
        </div>
    </div>
    </div>
    </section>
    </jsp:attribute>
</tag:application>  