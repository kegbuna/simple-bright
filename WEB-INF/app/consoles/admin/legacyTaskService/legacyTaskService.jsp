<%@page import="com.kd.kineticSurvey.record.KineticRecordPollerAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    String status = KineticRecordPollerAdmin.getRecordPoller().getState();
%>
<tag:application>
    <jsp:attribute name="title">Kinetic | Logs</jsp:attribute>
    <jsp:attribute name="navigationCategory">Admin</jsp:attribute>
    <jsp:attribute name="content">
        <section class="content">
            <div class="container-fluid main-inner">
                <div class="row">
                    <div class="col-xs-2 sidebar">
                        <jsp:include page="/WEB-INF/app/consoles/_shared/leftNavigation/admin.jsp">
                            <jsp:param name="navigationItem" value="Legacy Task Service"/>
                        </jsp:include>
                    </div>
                    <div class="col-xs-10 tab-content">
                        <div class="tab-pane active fade in">
                            <div class="row">
                                <div class="col-xs-9">
                                    <div class="page-header">
                                        <h3>Legacy Task Service</h3>
                                    </div>
                                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                                    <div class="row">
                                        <div class="col-xs-4">
                                            <dl>
                                                <dt>Service</dt>
                                                <dd>Legacy Task Service</dd>
                                            </dl>
                                        </div>
                                        <div class="col-xs-4">
                                            <dl>
                                                <dt>Current Status</dt>
                                                <dd>
                                                    <%=escape(status)%>
                                                </dd>
                                            </dl>
                                        </div>
                                        <div class="col-xs-4">
                                            <% if (status.equals("RUNNING")) {%>
                                            <form action="<%=request.getContextPath()%>/TaskManagerServlet" method="post"
                                                  data-disable-on-submit="disable-on-submit">
                                                <input type="hidden" name="operation" value="Stop">
                                                <input type="submit" class="btn btn-primary" value="Stop">
                                                <button class="btn btn-primary" type="button" disabled>Start</button>
                                                <% if (session.getAttribute("CsrfToken") != null) { %>
                                                    <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
                                                <% } %>
                                            </form>
                                            <% } else if (status.equals("STOPPED") || status.equals("BUILT")) {%>
                                            <form action="<%=request.getContextPath()%>/TaskManagerServlet" method="post"
                                                  data-disable-on-submit="disable-on-submit">
                                                <input type="hidden" name="operation" value="Start">
                                                <button class="btn btn-primary" type="button" disabled>Stop</button>
                                                <input type="submit" class="btn btn-primary" value="Start">
                                                <% if (session.getAttribute("CsrfToken") != null) { %>
                                                    <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
                                                <% } %>
                                            </form>
                                            <%}%>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-3 sidebar pull-right">
                                    <jsp:include page="/WEB-INF/app/consoles/_shared/help.jsp">
                                        <jsp:param name="helpType" value="Admin Consoles" />
                                        <jsp:param name="helpUrl" value="http://help.kineticdata.com/ksr52/consoles/admin" />
                                    </jsp:include>
                                    <jsp:include page="_helpText.jsp"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </jsp:attribute>
</tag:application>