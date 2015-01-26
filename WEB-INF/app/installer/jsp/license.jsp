<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Load previously submitted application configuration values
    Map<String,String> configurationValuesMap = (Map<String,String>)session.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_CONFIG);
    if (configurationValuesMap == null) { configurationValuesMap = new LinkedHashMap<String,String>(); }
    
    String requestLicense = configurationValuesMap.get("licenseRequest");
    if (requestLicense == null) { requestLicense = "myRequestLicense"; }
    
    String surveyLicense = configurationValuesMap.get("licenseSurvey");
    if (surveyLicense == null) { surveyLicense = "mySurveyLicense"; }
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="POST">
            <div class="title">
                Kinetic Setup - Licenses
            </div>
            <div class="message">
                <div class="instructions">
                    <div class="well well-sm">
                        <strong>The following information is optional and can be changed after installation.</strong>
                    </div>
                    <p>
                        If you received any application license keys from Kinetic Data, paste the keys into the
                        input fields below.  If you did not receive any license keys, you can still continue with
                        the installation, but you will need to contact 
                        <a href="mailto:support@kineticdata.com">support@kineticdata.com</a> to obtain the
                        necessary license keys.
                    </p>
                    <p>
                        Neither application will function until it has a valid license key.
                    </p>
                </div>
                <hr/>
                <div>
                    <div class="form-group">
                        <label for="configurationValue[licenseRequest]">Kinetic Request License Key</label>
                        <input class="form-control" type="text"
                                  name="configurationValue[licenseRequest]"
                                  value="<%=escape(requestLicense)%>">
                    </div>
                    <div class="form-group">
                        <label for="configurationValue[licenseSurvey]">Kinetic Survey License Key</label>
                        <input class="form-control" type="text"
                                  name="configurationValue[licenseSurvey]"
                                  value="<%=escape(surveyLicense)%>">
                    </div>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=escape(session.getAttribute("CsrfToken"))%>"/>
            <div class="actions">
                <button class="btn btn-link pull-left" value="Skip optional steps">Skip optional steps</button>
                <button class="btn" type="button" value="Back To Server">Previous</button>
                <button class="btn btn-primary" type="submit" value="Midtier">Continue</button>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
