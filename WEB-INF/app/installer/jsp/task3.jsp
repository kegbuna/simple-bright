<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Load previously submitted application configuration values
    Map<String,String> configurationValuesMap = (Map<String,String>)session.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_CONFIG);
    if (configurationValuesMap == null) { configurationValuesMap = new LinkedHashMap<String,String>(); }

    String task3ServerUrl = configurationValuesMap.get("defaultTaskServer");
    if (StringUtils.isBlank(task3ServerUrl)) { task3ServerUrl = "http://task3.mycompany.com:8080/kineticTask/"; }
    
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="POST">
            <div class="title">
                Kinetic Setup - Kinetic Task 3
            </div>
            <div class="message">
                <div class="instructions">
                    <div class="well well-sm">
                        <strong>The following information is optional and can be changed after installation.</strong>
                    </div>
                    <p>
                        Kinetic Task is a separate application that integrates with Kinetic Request and
                        Survey.  It is a much more powerful task engine than the Legacy Task Service.
                    </p>
                    <p>
                        If Kinetic Task v3 is not used by Kinetic Request, this step can simply be skipped.
                    </p>
                    <p>
                        The Kinetic Task v3 Web Server URL is used in Kinetic Request to provide links directly
                        to the Kinetic Task web application.
                    </p>
                </div>
                <hr/>
                <div>
                    <div class="form-group">
                        <label for="configurationValue[defaultTaskServer]">Kinetic Task 3 Web Server URL</label>
                        <input class="form-control" type="text"
                               name="configurationValue[defaultTaskServer]"
                               value="<%=escape(task3ServerUrl)%>">
                    </div>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=escape(session.getAttribute("CsrfToken"))%>"/>
            <div class="actions">
                <button class="btn btn-link pull-left" value="Skip optional steps">Skip optional steps</button>
                <button class="btn" type="button" value="Back To Midtier">Previous</button>
                <button class="btn btn-primary" type="submit" value="Task4">Continue</button>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
