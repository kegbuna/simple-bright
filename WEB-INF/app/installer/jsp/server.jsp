<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String message = (String)request.getAttribute("message");
    Exception connectException = (Exception)request.getAttribute("connectException");
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <div class="title">
            Kinetic Setup - Remedy Server Information
        </div>
        <form action="server" method="POST">
            <div class="message">
                <div class="instructions">
                    <p>
                        Enter the Remedy server information where Kinetic Request and Survey reside.  The 
                        server will be only be checked for an existing installation of Kinetic Request and
                        Survey.  No changes will be made at this time.
                    </p>
                    <div class="well well-sm">
                        <strong>The Web User ID must be the login for a Remedy Administrator account.</strong>
                    </div>
                </div>
                <% if (message != null) { %>
                <div class="alert alert-danger alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><%= message %></h4>
                    <% if (connectException != null) { %>
                    <div class="alert-details"><%=connectException.getMessage()%></div>
                    <% } %>
                </div>
                <% } %>
                <div id="arsProperties"></div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
            <div class="actions">
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/app/installer/local-admin">Previous</a>
                <button class="btn btn-primary" type="submit" value="Continue">Continue</button>
            </div>
        </form>
        <script type="text/javascript">
            // On page load
            $(function() {
                kinetic.ConfigurableProperties({
                    container: '#arsProperties',
                    prefix: 'Ars',
                    properties: <%= JsonUtils.toJsonString(request.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_ARS)) %>,
                    renderFormElement: KineticSr.app.renderConfigurablePropertyFormElement,
                    renderGroupElement: KineticSr.app.renderConfigurablePropertyGroupElement
                });
            });
        </script>
    </jsp:attribute>
</tag:installer>
