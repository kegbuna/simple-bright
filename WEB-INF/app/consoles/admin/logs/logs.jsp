<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:application>
    <jsp:attribute name="title">Kinetic | Logs</jsp:attribute>
    <jsp:attribute name="navigationCategory">Admin</jsp:attribute>
    <jsp:attribute name="content">
        <section class="content">
            <div class="container-fluid main-inner">
                <div class="row">
                    <div class="col-xs-2 sidebar">
                        <jsp:include page="/WEB-INF/app/consoles/_shared/leftNavigation/admin.jsp">
                            <jsp:param name="navigationItem" value="Logs"/>
                        </jsp:include>
                    </div>
                    <div class="col-xs-10 tab-content">
                        <div class="tab-pane active fade in">
                            <div class="row">
                                <div class="col-xs-9">
                                    <div class="page-header">
                                        <h3>Logs</h3>
                                    </div>
                                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                                    <div class="list-group">
                                        <dl class="list-group-item">
                                            <dt><a href="<%=request.getContextPath()%>/app/logs/application" target="_blank">Application Log</a></dt>
                                            <dd>Information related to the Kinetic Request application.</dd>
                                        </dl>
                                        <dl class="list-group-item">
                                            <dt><a href="<%=request.getContextPath()%>/app/logs/installation" target="_blank">Installation Log</a><dt>
                                            <dd>Information related to the installation.</dd>
                                        </dl>
                                        <dl class="list-group-item">
                                            <dt><a href="<%=request.getContextPath()%>/app/logs/web-access" target="_blank">Web Access Log</a><dt>
                                            <dd>Log containing information about all web requests.</dd>
                                        </dl>
                                        <dl class="list-group-item">
                                            <dt><a href="<%=request.getContextPath()%>/app/logs/all">Download All Logs (.zip)</a><dt>
                                            <dd>Packages all the log files into a single zip file.</dd>
                                        </dl>
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