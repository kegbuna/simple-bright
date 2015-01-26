<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Load previously submitted application configuration values
    Map<String,String> configurationValuesMap = (Map<String,String>)session.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_CONFIG);
    if (configurationValuesMap == null) { configurationValuesMap = new LinkedHashMap<String,String>(); }
    
    String midtierUrl = configurationValuesMap.get("midtierServer");
    if (StringUtils.isBlank(midtierUrl)) { midtierUrl = "http://midtier.mycompany.com:8080/arsys/"; }
    
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="POST">
            <div class="title">
                Kinetic Setup - Mid-Tier URL
            </div>
            <div class="message">
                <div class="instructions">
                    <div class="well well-sm">
                        <strong>The following information is optional and can be changed after installation.</strong>
                    </div>
                    <p>
                        The Mid-Tier URL can be used when constructing Kinetic Request and Kinetic Survey
                        email messages to provide a link for the end user.
                    </p>
                </div>
                <hr/>
                <div>
                    <div class="form-group">
                        <label for="configurationValue[midtierServer]">Mid-Tier Web Server URL</label>
                        <input class="form-control" type="text"
                               name="configurationValue[midtierServer]"
                               value="<%=escape(midtierUrl)%>">
                    </div>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=escape(session.getAttribute("CsrfToken"))%>"/>
            <div class="actions">
                <button class="btn btn-link pull-left" value="Skip optional steps">Skip optional steps</button>
                <button class="btn" type="button" value="Back To License">Previous</button>
                <button class="btn btn-primary" type="submit" value="Task3">Continue</button>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
