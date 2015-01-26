<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Load previously submitted application configuration values
    Map<String,String> configurationValuesMap = (Map<String,String>)session.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_CONFIG);
    if (configurationValuesMap == null) { configurationValuesMap = new LinkedHashMap<String,String>(); }
    
    // Determine the default task version
    String defaultTaskVersion = configurationValuesMap.get("defaultTaskVersion");
    if (defaultTaskVersion == null) { defaultTaskVersion = "Kinetic Task 4+"; }
    
    // Load the ARS Properties
    Map<String,String> arsPropertiesMap = (Map<String,String>)session.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_ARS);
    String escalationServer = arsPropertiesMap.get("Server Name");
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="POST">
            <div class="title">
                Kinetic Setup - Default Task Engine
            </div>
            <div class="message">
                <div class="instructions">
                    <p>
                        The default task engine setting simply initializes new service items to a specific
                        task service or task engine.  The value can always be changed on the service item
                        after it has been created.
                    </p>
                </div>
                <hr/>
                <div>
                    <div class="form-group">
                        <label for="configurationValue[defaultTaskVersion]">Default Task Version</label>
                        <select class="form-control" name="configurationValue[defaultTaskVersion]"
                                id="configurationValue[defaultTaskVersion]">
                            <option value="Legacy" <%="Legacy".equals(defaultTaskVersion) ? "selected" : ""%>>Legacy Task Service</option>
                            <option value="Kinetic Task 2/3" <%="Kinetic Task 2/3".equals(defaultTaskVersion) ? "selected" : ""%>>Kinetic Task 3</option>
                            <option value="Kinetic Task 4+" <%="Kinetic Task 4+".equals(defaultTaskVersion) ? "selected" : ""%>>Kinetic Task 4</option>
                        </select>
                    </div>
                </div>
            </div>

            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=escape(session.getAttribute("CsrfToken"))%>"/>
            <div class="actions">
                <button class="btn btn-link pull-left" value="Skip optional steps">Skip optional steps</button>
                <button class="btn" type="button" value="Back To Task4">Previous</button>
                <button class="btn btn-primary" type="submit" value="Install Summary">Continue</button>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
