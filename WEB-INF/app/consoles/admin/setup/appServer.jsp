<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:application>
    <jsp:attribute name="title">Kinetic | App Server</jsp:attribute>
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
                                        <li class="active"><a href="<%=request.getContextPath()%>/app/admin/setup/app-server">App Server</a></li>
                                        <li><a href="<%=request.getContextPath()%>/app/admin/setup/ars-server">ARS Server</a></li>
                                        <li><a href="<%=request.getContextPath()%>/app/admin/setup/licensing">Licensing</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                                        <div class="row active tab-pane fade in" id="system">
                                            <div class="col-xs-12">
                                                <form action="<%=request.getContextPath()%>/app/admin/setup/app-server" id="systemProperties" method="post" role="form"
                                                      data-disable-on-submit="disable-on-submit">
                                                    <div id="serverProperties"></div>

                                                    <div class="form-buttons">
                                                        <button class="btn btn-primary" type="submit">Save System Properties</button>
                                                    </div>
                                                    <% if (session.getAttribute("CsrfToken") != null) { %>
                                                        <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
                                                    <% } %>
                                                </form>
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
        <script type="text/javascript">
            // On page load
            $(function() {
                kinetic.ConfigurableProperties({
                    container: '#serverProperties',
                    prefix: 'Server',
                    properties: <%= JsonUtils.toJsonString(request.getAttribute("serverProperties")) %>,
                    renderFormElement: KineticSr.app.renderConfigurablePropertyFormElement,
                    renderGroupElement: KineticSr.app.renderConfigurablePropertyGroupElement
                });
            });
        </script>
    </jsp:attribute>
</tag:application>