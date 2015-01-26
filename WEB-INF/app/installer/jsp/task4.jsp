<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Load previously submitted task4 server property values
    Map<String,String> task4ServerPropertiesMap = (Map<String,String>)session.getAttribute(SetupWizardServlet.HttpAttribute.PROPERTIES_CONFIG_TASK4);
    if (task4ServerPropertiesMap == null) { task4ServerPropertiesMap = new LinkedHashMap<String,String>(); }
    
    String task4ServerName = task4ServerPropertiesMap.get("serverName");
    if (StringUtils.isBlank(task4ServerName)) { task4ServerName = "Kinetic Task 4"; }
    
    String task4ServerUrl = task4ServerPropertiesMap.get("webURL");
    if (StringUtils.isBlank(task4ServerUrl)) { task4ServerUrl = "http://task4.mycompany.com:8080/kinetic-task"; }
    
    String task4AuthToken = task4ServerPropertiesMap.get("authToken");
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="POST">
            <div class="title">
                Kinetic Setup - Kinetic Task 4
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
                        If Kinetic Task v4 is not used by Kinetic Request, this step can simply be skipped.
                    </p>
                    <p>
                        The Kinetic Task v4 configuration consists of an entry that contains a name used to
                        identity the Task 4 server, a URL that maps to the Kinetic Task v4 web application,
                        and the Source Name used by this instance of Kinetic Request.
                    </p>
                </div>
                <hr/>
                <div>
                    <div class="form-group">
                        <label for="task4Server[serverName]">Kinetic Task v4 Server Name</label>
                        <input class="form-control" type="text"
                               name="task4Server[serverName]"
                               value="<%=escape(task4ServerName)%>">
                    </div>
                    <div class="form-group">
                        <label for="task4Server[webURL]">Kinetic Task v4 Web Server URL</label>
                        <input class="form-control" type="text"
                               name="task4Server[webURL]"
                               value="<%=escape(task4ServerUrl)%>">
                    </div>
                    <div class="form-group">
                        <label for="task4Server[authToken]">Authentication Token</label>
                        <input class="form-control" type="text"
                               name="task4Server[authToken]"
                               value="<%=escape(task4AuthToken)%>">
                    </div>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=escape(session.getAttribute("CsrfToken"))%>"/>
            <div class="actions">
                <button class="btn btn-link pull-left" value="Skip optional steps">Skip optional steps</button>
                <button class="btn" type="button" value="Back To Task3">Previous</button>
                <button class="btn btn-primary" type="submit" value="Task">Continue</button>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
