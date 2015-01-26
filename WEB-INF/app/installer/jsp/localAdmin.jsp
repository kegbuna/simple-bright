<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String message = (String)request.getAttribute("message");
    // Load the configurable properties for the local administrator user
    Map<String,String> localAdminCredentials = (Map<String,String>)session.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_CONFIG_USER);
    String localAdminUsername = localAdminCredentials.get("CONFIG_ADMIN_USER");
    String localAdminPassword = localAdminCredentials.get("CONFIG_ADMIN_PWD");
    boolean isDefaultCredentials = ("admin".equals(localAdminUsername) && "admin".equals(localAdminPassword));
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="local-admin" method="POST">
            <div class="title">
                Kinetic Setup - Local Configuration Administrator
            </div>
            <div class="message">
                <div class="instructions">
                    <div>
                        <p>
                            The local configuration administrator is a user account that is local to this
                            web application instance.  This user is NOT a Remedy user account.
                        </p>
                        <p>
                            This user has access to some portions of the web Administration Console and 
                            the Setup program if you ever need to reconfigure the web application.
                        </p>
                    </div>
                    <div class="well well-lg">
                        <strong>Any changes made to the credentials will be applied immediately.</strong>
                    </div>
                </div>
                <hr/>
                <% if (message != null) { %>
                <div class="alert alert-danger alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><%= message %></h4>
                </div>
                <% } %>
                <div id="configUserProperties"></div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=escape(session.getAttribute("CsrfToken"))%>"/>
            <div class="actions">
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/app/installer/<%=(String)session.getAttribute(SetupWizardServlet.HttpAttribute.SETUP_START_ROUTE)%>">Previous</a>
                <button class="btn btn-primary" type="submit" value="Continue">Continue</button>
            </div>
        </form>
        <script type="text/javascript">
            // On page load
            $(function() {
                kinetic.ConfigurableProperties({
                    container: '#configUserProperties',
                    prefix: 'ConfigurationUser',
                    properties: <%=JsonUtils.toJsonString(request.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_CONFIG_USER))%>,
                    renderFormElement: KineticSr.app.renderConfigurablePropertyFormElement,
                    renderGroupElement: KineticSr.app.renderConfigurablePropertyGroupElement
                });
            });
        </script>
    </jsp:attribute>
</tag:installer>
