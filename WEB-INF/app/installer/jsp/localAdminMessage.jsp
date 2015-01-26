<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
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
        <div class="title">
            Kinetic Setup - Local Configuration Administrator
        </div>
        <%
            if (isDefaultCredentials) {
        %>
        <div class="message">
            <div class="instructions">
                <div class="bs-callout bs-callout-danger">
                    <h4>Warning</h4>
                    <div>
                        The local administrator account is still using the default credentials<br/>
                        <strong>'admin', 'admin'</strong>.
                    </div>
                </div>
                <p>
                    You may continue to setup the application, but it is highly recommended that 
                    you go back and change the credentials for the local administrator account to
                    prevent unauthorized users from making changes to the web application.
                </p>
            </div>
        </div>
        <div class="actions">
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/app/installer/local-admin">Previous</a>
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/app/installer/server">Continue</a>
        </div>
        <% } else { %>
        <div class="message">
            <div class="instructions">
                <div>
                    <p class="alert alert-warning">
                        Local Administrator credentials have been changed!
                    </p>
                    <p>
                        Your changes to the local administrator user have been applied.
                    </p>
                    <p>
                        If you need to make changes to this account in the future, you can do so in the setup 
                        properties on the Administrator Console.
                    </p>
                </div>
            </div>
        </div>
        <div class="actions">
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/app/installer/local-admin">Previous</a>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/app/installer/server">Continue</a>
        </div>
        <% } %>
    </jsp:attribute>
</tag:installer>
