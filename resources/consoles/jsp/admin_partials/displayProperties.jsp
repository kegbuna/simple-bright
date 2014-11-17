<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%-- This page is used to display current properties and to reload properties
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="propertiesInfo" scope="request" class="com.kd.kineticSurvey.beans.CurrentProperties" />
<jsp:useBean id="LicenseInfo" scope="request" class="com.kd.kineticSurvey.beans.LicenseInfo" />
<jsp:useBean id="userContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%
    String reloadRequest;
    String loglevel;
    String title = "Current Property Display";
    String message = "";

    reloadRequest = request.getParameter("reload");
    loglevel = request.getParameter("loglevel");
    userContext = (com.kd.kineticSurvey.beans.UserContext) session.getAttribute("UserContext");
    String authType = (String) request.getAttribute("authType");

    String successMessage = (String) request.getAttribute("configSuccessMessage");
    String errorMessage = (String) request.getAttribute("configErrorMessage");

    String configMessage = "";
    if (authType.equalsIgnoreCase(com.kd.kineticSurvey.authentication.Authenticator.AUTH_TYPE_CONFIG)) {
        configMessage = "You are currently logged in locally as the configuration administrator. To fully connect, fill in the required web properties, log out, and log in as the remedy administrator.";
    }

    if (reloadRequest != null) {
        propertiesInfo.refreshProperties();
        title = "Properties Refreshed";
        message = "Property Refresh Complete";
        userContext.setErrorMessage("");
        userContext.setSuccessMessage("");
    }

    if (loglevel != null) {
        propertiesInfo.setLoggerLevel(loglevel);
        title = "Log Level Updated";
        message = "Log Level Update Complete";
        userContext.setErrorMessage("");
        userContext.setSuccessMessage("");
    }

    String seed_display = "";
    if (propertiesInfo.getProperty("ENCRYPT_PASSWORD").equals("false")) {
        seed_display = "none";
    }
%>
<script src="<%= request.getContextPath() + "/resources/consoles/js/toolTip.js"%>" type="text/javascript"></script>
<script type="text/javascript">
    function submitUpdateForm(formId) {
        document.getElementById(formId).submit();
    }
</script>
<div id="config">
    <% if (!configMessage.equals("")) {%>
    <div class="message">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Warning.png" alt="Warning"/>
        <%= configMessage%>
    </div>
    <% }%>
    <% if (!message.equals("")) {%>
    <div class="message">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Warning.png" alt="Warning"/>
        <%= message%>
    </div>
    <% }%>
    <% if (!successMessage.equals("")) {%>
    <div class="successMessage">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Check.png" alt="Check"/>
        <%= successMessage%>
    </div>
    <% }%>
    <% if (!errorMessage.equals("")) {%>
    <div class="errorMessage">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Error.png" alt="Error"/>
        <%= errorMessage%>
    </div>
    <% }%>
    <ul>
        <li>
            <form class="button" action="Config" method="post">
                <input type="hidden" name="curActive" value="web_properties" />
                <input type="hidden" name="configPage" value="edit" />
                <input type="submit" name="EditProperties" value="Edit Properties" />
            </form>
        </li>
    </ul>
    <div class="wrapper">
        <h3>Remedy Server Settings
            <img id="remedyServerAndUserSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
        </h3>
        <div class="window">
            <table>
                <tr class="light"><th>Server Name*</th>
                    <td><%=propertiesInfo.getProperty("DEFAULT_SERVER") + "&nbsp;"%>
                        <span style="margin-left:3em;"><a href="" onclick="submitUpdateForm('changeRemedyForm');return false;">Change Remedy Settings</a></span>
                    </td></tr>
                <tr class="dark"><th>TCP Port*</th>
                    <td><%=propertiesInfo.getProperty("DEFAULT_TCP") + "&nbsp;"%></td></tr>
                <tr class="light"><th>RPC Port*</th>
                    <td><%=propertiesInfo.getProperty("DEFAULT_RPC") + "&nbsp;"%></td></tr>
                <tr class="dark"><th>Answer Thread RPC Port*</th>
                    <td><%=propertiesInfo.getProperty("ANSWER_THREAD_RPC") + "&nbsp;"%></td></tr>
                <tr class="light"><th>API Connection Limit*</th>
                    <td><%=propertiesInfo.getProperty("API_CONNECTION_LIMIT") + "&nbsp;"%></td></tr>
                <tr class="dark"><th>API Impersonate User</th>
                    <td><%=propertiesInfo.getProperty("API_IMPERSONATE_USER") + "&nbsp;"%></td></tr>
                <tr class="light"><th>Default User*</th>
                    <td><%=propertiesInfo.getProperty("DEFAULT_USER") + "&nbsp;"%></td></tr>
            </table>
        </div>
    </div>
    <div class="wrapper">
        <h3>Configuration Administrator Credentials
            <img id="configAdminCredentials" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
        </h3>
        <div class="window">
            <table>
                <tr class="light"><th>Config Admin User*</th>
                    <td><%=propertiesInfo.getProperty("CONFIG_ADMIN_USER")%>
                        <span style="margin-left:3em;"><a href="" onclick="submitUpdateForm('changeAdminUserForm');return false;">Change Admin User</a></span>
                    </td></tr>
            </table>
        </div>
    </div>
    <div class="wrapper">
        <h3>Task Manager Settings
            <img id="taskManagerSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
        </h3>
        <div class="window">
            <table>
                <% if (propertiesInfo.getProperty("CREATOR_SLEEP_DELAY").equals("0")) {%>
                <tr class="light"><th>Task Manager Service</th>
                    <td>Disabled</td></tr>
                    <% } else {%>
                <tr class="light"><th>Task Manager Service</th>
                    <td>Enabled</td></tr>
                <tr class="dark"><th>Query*</th>
                    <td><%=propertiesInfo.getProperty("POLLER_QUERY") + "&nbsp;"%></td></tr>
                <tr class="light"><th>Sleep Delay*</th>
                    <td><%=propertiesInfo.getProperty("CREATOR_SLEEP_DELAY") + "&nbsp;"%></td></tr>
                    <% }%>
            </table>
        </div>
    </div>
    <div class="wrapper">
        <h3>Default Logger Settings
            <img id="defaultLoggerSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
        </h3>
        <div class="window">
            <table>
                <tr class="light"><th>Log Level*</th>
                    <td><%=propertiesInfo.getProperty("DEFAULT_LOG_LEVEL") + "&nbsp;"%></td></tr>
                <tr class="dark"><th>Max Log Size (Bytes)*</th>
                    <td><%=propertiesInfo.getProperty("MAX_LOG_SIZE") + "&nbsp;"%></td></tr>
                <tr class="light"><th>Log Output Directory</th>
                    <td><%=propertiesInfo.getProperty("LOG_OUTPUT_DIRECTORY") + "&nbsp;"%></td></tr>
                <tr class="dark"><th>Log Properties File</th>
                    <td><%=propertiesInfo.getProperty("LOGGING_PROPERTY_FILE") + "&nbsp;"%></td></tr>
            </table>
        </div>
    </div>
    <div class="wrapper">
        <h3>Miscellaneous Settings
            <img id="miscellaneousSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
        </h3>
        <div class="window">
            <table>
                <tr class="light"><th>Max Chars on Submit*</th>
                    <td><%=propertiesInfo.getProperty("MAX_CHARS_ON_SUBMIT") + "&nbsp;"%></td></tr>
                <tr class="dark"><th>Map Fields Count*</th>
                    <td><%=propertiesInfo.getProperty("MAP_FIELDS_COUNT") + "&nbsp;"%></td></tr>
                <tr class="light"><th>Max Cache Size*</th>
                    <td><%=propertiesInfo.getProperty("MAX_CACHE_SIZE") + "&nbsp;"%></td></tr>
            </table>
        </div>
    </div>
    <div class="wrapper">
        <h3>SSO Adapter Settings
            <img id="ssoAdapterSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>        
        </h3>
        <div class="window">
            <table>
                <tr class="light"><th>SSO Adapter Class</th>
                    <td><%=propertiesInfo.getProperty("SSO_ADAPTER_CLASS")%></td></tr>
                <tr class="dark"><th>SSO Adapter Properties</th>
                    <td><%=propertiesInfo.getProperty("SSO_ADAPTER_PROPERTIES")%></td></tr>
                <tr class="light" style="display:none;"><th>Use SSO for Consoles</th>
                    <td><%=propertiesInfo.getProperty("USE_SSO_FOR_CONSOLES") + "&nbsp;"%></td></tr>
                    <% if (propertiesInfo.getProperty("USE_SSO_FOR_CONSOLES").equals("true")) {%>
                <tr class="dark"><th>SSO Console URL</th>
                    <td><%=propertiesInfo.getProperty("SSO_CONSOLE_URL")%></td></tr>
                    <% }%>
            </table>
        </div>
    </div>
    <ul>
        <li>
            <form class="button" action="Config" method="post">
                <input type="hidden" name="curActive" value="web_properties" />
                <input type="hidden" name="configPage" value="edit" />
                <input type="submit" name="EditProperties" value="Edit Properties" />
            </form>
        </li>
    </ul>
    <form class="hidden" id="changeRemedyForm" action="Config" method="post">
        <input type="hidden" name="curActive" value="web_properties"/>
        <input type="hidden" name="configPage" value="changeRemedy"/>
    </form>
    <form class="hidden" id="changeAdminUserForm" action="Config" method="post">
        <input type="hidden" name="curActive" value="web_properties"/>
        <input type="hidden" name="configPage" value="changeAdminUser"/>
    </form>
</div>
