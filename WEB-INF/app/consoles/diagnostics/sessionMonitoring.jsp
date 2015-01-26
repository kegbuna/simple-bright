<%@page import="com.kd.ksr.profiling.Recording"%>
<%@page import="com.kd.ksr.profiling.Profiler"%>
<%@page import="com.kineticdata.profiling.Profile"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    // Obtain a reference to the active recording
    Recording activeRecording = Profiler.getActiveRecording();
    // Build the profiles
    ArrayList<LinkedHashMap<String,Object>> profiles = new ArrayList<LinkedHashMap<String,Object>>();
    for (final Recording recording : Profiler.getRecordings()) {
        profiles.add(new LinkedHashMap<String,Object>() {{
            put("id", recording.getId());
            put("displayId", recording.getDisplayId());
            put("startTime", recording.getStartTimeIso8601());
            put("endTime", recording.getEndTimeIso8601());
        }});
    }
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
                    <%-- PAGE HEADER --%>
                    <div class="page-header">
                        <h3>
                            Session Monitoring
                            <%-- Start Recording Button --%>
                            <% if (activeRecording == null) { %>
                            <form action="<%=request.getContextPath()%>/app/diagnostics/session-monitoring/start" 
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
                    <div class="tab-content" style="padding-bottom:20px;">
                        <div class="pull-right btn-group">
                            <button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" <%=profiles.isEmpty() ? "disabled" : "" %>>
                                Actions <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu">
                                <li><a data-submit-form="delete-all" href="javascript:void(0);">Delete All</a></li>
                            </ul>
                        </div>
                        <form id="delete-all"
                              class="hidden"
                              action="<%=request.getContextPath()%>/app/diagnostics/session-monitoring/delete-all" 
                              method="POST">
                            <% if (session.getAttribute("CsrfToken") != null) { %>
                            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
                            <% } %>
                        </form>
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
                        
                        <% if (activeRecording != null) { %>
                        <form action="<%=request.getContextPath()%>/app/diagnostics/session-monitoring/<%=escape(activeRecording.getId())%>/stop" 
                              class="pull-right" 
                              style="margin-right: 15px;"
                              data-disable-on-submit="disable-on-submit" 
                              method="post">
                            <button type="submit" class="btn btn-sm btn-danger">
                                <i class="fa fa-clock-o fa-lg"></i>
                                Stop Recording
                            </button>
                            <input type="hidden" id="page" name="page" value="list"/>
                            <% if (session.getAttribute("CsrfToken") != null) { %>
                                <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
                            <% } %>
                        </form>
                        <% } %>
                        
                        <%-- TABS --%>
                        <ul class="nav nav-pills sub-nav"></ul>
                        
                        <table class="table table-hover" id="profiled-templates-table" style="width:100%;"></table>
                        <script>
                            $(function() {
                                $('#profiled-templates-table').DataTable({
                                    autoWidth: false,
                                    dom: '<"wrapper">t',
                                    language: {
                                        emptyTable: "No recordings have been started."
                                    },
                                    data: <%=JsonUtils.toJsonString(profiles)%>,
                                    order: [[ 1, "desc" ]],
                                    columns: [
                                        { data: 'id', title: 'Recording', width: '34%',
                                            createdCell: function(td, cellData, row) {
                                                $(td).html($('<a>')
                                                    .attr('href', document.URL+"/"+cellData)
                                                    .text(row['displayId']));
                                            }
                                        },
                                        { data: 'startTime', title: 'Started', width: '33%',
                                            createdCell: KineticSr.app.formatTimestamp},
                                        { data: 'endTime', title: 'Ended', width: '33%',
                                            createdCell: function(td, cellData) {
                                                cellData ? KineticSr.app.formatTimestamp(td, cellData) : $(td).html("-");
                                            }
                                        }
                                    ]
                                });
                            });
                        </script>
                    </div>
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