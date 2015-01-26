<%@page import="com.kd.kineticSurvey.beans.LicenseInfo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<% 
    LicenseInfo requestLicence = (LicenseInfo)request.getAttribute("requestLicence");
    LicenseInfo surveyLicence = (LicenseInfo)request.getAttribute("surveyLicence");
%>
<tag:application>
    <jsp:attribute name="title">Kinetic | Licensing</jsp:attribute>
    <jsp:attribute name="navigationCategory">Admin</jsp:attribute>
    <jsp:attribute name="content">
        <section class="content">
            <div class="container-fluid main-inner">
                <div class="row">
                    <div class="col-xs-2 sidebar">
                        <jsp:include page="/WEB-INF/app/consoles/_shared/leftNavigation/admin.jsp">
                            <jsp:param name="navigationItem" value="Setup"/>
                        </jsp:include>
                    </div>
                    <div class="col-xs-10 tab-content">
                        <div class="tab-pane active fade in" id="properties">
                            <div class="row">
                                <div class="col-xs-9">
                                    <div class="page-header">
                                        <h3>Setup</h3>
                                    </div>
                                    <ul class="nav nav-pills sub-nav" id="propertiesTabs">
                                        <li><a href="<%=request.getContextPath()%>/app/admin/setup/app-server">App Server</a></li>
                                        <li><a href="<%=request.getContextPath()%>/app/admin/setup/ars-server">ARS Server</a></li>
                                        <li class="active"><a href="<%=request.getContextPath()%>/app/admin/setup/licensing">Licensing</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                                        <div class="row active tab-pane fade in" id="system">
                                            <div class="col-xs-12">
                                                <% if (!requestLicence.getLicenseKey().isEmpty()) { %>
                                                <h4>Request License</h4>
                                                <dl class="dl-horizontal dl-stripe" style="word-break: break-all;">
                                                    <dt>Application Name</dt>
                                                    <dd><%=requestLicence.getApplicationName()%></dd>
                                                    <dt>Key</dt>
                                                    <dd><%=requestLicence.getLicenseKey()%></dd>
                                                    <dt>License Site</dt>
                                                    <dd><%=requestLicence.getLicenseSite()%></dd>
                                                    <dt>Server Name</dt>
                                                    <dd><%=requestLicence.getServerName()%></dd>
                                                    <dt><%=requestLicence.getExpirationType()%></dt>
                                                    <dd><%=requestLicence.getLicenseValue()%></dd>
                                                </dl>
                                                <% } %>
                                                <% if (!surveyLicence.getLicenseKey().isEmpty()) { %>
                                                <h4>Survey License</h4>
                                                <dl class="dl-horizontal dl-stripe" style="word-break: break-all;">
                                                    <dt>Application Name</dt>
                                                    <dd><%=surveyLicence.getApplicationName()%></dd>
                                                    <dt>Key</dt>
                                                    <dd><%=surveyLicence.getLicenseKey()%></dd>
                                                    <dt>License Site</dt>
                                                    <dd><%=surveyLicence.getLicenseSite()%></dd>
                                                    <dt>Server Name</dt>
                                                    <dd><%=surveyLicence.getServerName()%></dd>
                                                    <dt><%=surveyLicence.getExpirationType()%></dt>
                                                    <dd><%=surveyLicence.getLicenseValue()%></dd>
                                                </dl>
                                                <% } %>
                                                
                                                <% if (requestLicence.getLicenseKey().isEmpty() && surveyLicence.getLicenseKey().isEmpty()) { %>
                                                <p>No licenses present.</p>
                                                <% } %>
                                            </div>
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