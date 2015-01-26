<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%
    boolean install = SetupWizardServlet.Action.INSTALL.equals((String)session.getAttribute(SetupWizardServlet.HttpAttribute.SETUP_ACTION));
    String action = (String)request.getAttribute("action");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="POST">
            <div class="title">
                Kinetic Setup - Summary
            </div>
            <% if (install) { %>
            <div class="message">
                <div class="instructions">
                    <h4>
                        Kinetic Request and Survey Setup Summary.
                    </h4>
                    <hr/>
                    <div>
                        <h4>Continue Setup</h4>
                        <p>
                            All the information has been collected to install the application on this Remedy server.
                        </p>
                        <p>
                            Click the Install button to proceed with the installation, or the Previous button to go
                            back and change any information.
                        </p>
                    </div>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
            <div class="actions">
                 <% if ("install-skip-options".equals(action)) { %>
                <button class="btn" type="button" value="Back To Server">Previous</button>
                <% } else { %>
                <button class="btn" type="button" value="Back To Task">Previous</button>
                <% } %>
                <button class="btn btn-primary" type="submit" value="Install">Install</button>
            </div>
            <% } else { %>
            <div class="message">
                <div class="instructions">
                    <h4>
                        Kinetic Request and Survey Setup Summary.
                    </h4>
                    <hr/>
                    <div>
                        <h4>Continue Setup</h4>
                        <p>
                            This setup program is ready to upgrade the Remedy objects and data.
                        </p>
                        <p>
                            Click the Upgrade button to continue, or the Previous button to go back and 
                            change the information.
                        </p>
                    </div>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
            <div class="actions">
                <button class="btn" type="button" value="Back To Server">Previous</button>
                <button class="btn btn-primary" type="submit" value="Upgrade">Upgrade</button>
            </div>
            <% } %>
        </form>
    </jsp:attribute>
</tag:installer>
