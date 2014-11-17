<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="propertiesInfo" scope="request" class="com.kd.kineticSurvey.beans.CurrentProperties" />
<jsp:useBean id="LicenseInfo" scope="request" class="com.kd.kineticSurvey.beans.LicenseInfo" />
<jsp:useBean id="userContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%
    String headerFile;
    String reloadRequest;
    String loglevel;
    String title = "Edit Current Properties";
    String message = "";

    headerFile = request.getParameter("headerFile");
    reloadRequest = request.getParameter("reload");
    userContext = (com.kd.kineticSurvey.beans.UserContext) session.getAttribute("UserContext");
    loglevel = request.getParameter("loglevel");

    String successMessage = (String) request.getAttribute("configSuccessMessage");
    String errorMessage = (String) request.getAttribute("configErrorMessage");

    String pollerEnabled = "checked";
    if (propertiesInfo.getProperty("CREATOR_SLEEP_DELAY").equals("0")) {
        pollerEnabled = "";
    }
    String poller_display = "block";
    if (pollerEnabled.equals("")) {
        poller_display = "none";
    }
%>
<script src="<%= request.getContextPath() + "/resources/consoles/js/toolTip.js"%>" type="text/javascript"></script>
<script type="text/javascript">
    function editPollerSleepDelay(chkbox) {
        var poller_delay_div = document.getElementById("poller_sleep_delay");
        var poller_delay_input = document.getElementById("poller_delay_input");
        if (chkbox.checked) {
            poller_delay_div.style.display = "block";
            poller_delay_input.value="60";
        } else {
            poller_delay_div.style.display = "none";
            poller_delay_input.value="0";
        }
    }
</script>
<div id="config">
    <% if (!message.equals("")) {%>
    <div class="message">
        <%= message%>
    </div>
    <% }%>
    <% if (!successMessage.equals("")) {%>
    <div class="successMessage">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Check.png"/>
        <%= successMessage%>
    </div>
    <% }%>
    <% if (!errorMessage.equals("")) {%>
    <div class="errorMessage">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Error.png"/>
        <%= errorMessage%>
    </div>
    <% }%>
    <form action="Config" method="post">
        <ul>
            <li><input type="submit" name="UpdateProperties" value="Update Properties"/> or <a href="AdminConsole">Cancel</a></li>
        </ul>
        <div class="wrapper">
            <h3>Task Manager Settings
                <img id="taskManagerSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
            </h3>
            <div class="window">
                <table>
                    <tr class="light">
                        <th>Task Manager Service</th>
                        <td><input type="checkbox" id="poller_sleep_delay_chk" <%= pollerEnabled%> onclick="editPollerSleepDelay(this);"/> Enable</td>
                    </tr>
                </table>
                <div id="poller_sleep_delay" style="display:<%= poller_display%>">
                    <table>
                        <tr class="dark">
                            <th>Query*</th>
                            <td><textarea rows="3" cols="45" name="POLLER_QUERY"><%=propertiesInfo.getProperty("POLLER_QUERY")%></textarea></td>
                        </tr>

                        <tr class="light">
                            <th>Sleep Delay*</th>
                            <td><input id="poller_delay_input" type="text" size="60" name="CREATOR_SLEEP_DELAY" value="<%=propertiesInfo.getProperty("CREATOR_SLEEP_DELAY")%>"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="wrapper">
            <h3>Default Logger Settings
                <img id="defaultLoggerSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
            </h3>
            <div class="window">
                <table>
                    <tr class="light"><th>Log Level*</th>
                        <td>
                            <select name="DEFAULT_LOG_LEVEL">
                                <option value="OFF" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("OFF")) {%><%= "selected"%><%}%>>Off</option>
                                <option value="FATAL" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("FATAL")) {%><%= "selected"%><%}%>>Fatal</option>
                                <option value="ERROR" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("ERROR")) {%><%= "selected"%><%}%>>Error</option>
                                <option value="WARN" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("WARN")) {%><%= "selected"%><%}%>>Warn</option>
                                <option value="INFO" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("INFO")) {%><%= "selected"%><%}%>>Info</option>
                                <option value="DEBUG" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("DEBUG")) {%><%= "selected"%><%}%>>Debug</option>
                                <option value="TRACE" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("TRACE")) {%><%= "selected"%><%}%>>Trace</option>
                                <option value="ALL" <%if (propertiesInfo.getProperty("DEFAULT_LOG_LEVEL").equals("ALL")) {%><%= "selected"%><%}%>>All</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="dark">
                        <th>Max Log Size (Bytes)*</th>
                        <td><input type="text" size="60" name="MAX_LOG_SIZE" value="<%=propertiesInfo.getProperty("MAX_LOG_SIZE")%>"></td>
                    </tr>
                    <tr class="light">
                        <th>Log Output Directory</th>
                        <td><input type="text" size="60" name="LOG_OUTPUT_DIRECTORY" value="<%=propertiesInfo.getProperty("LOG_OUTPUT_DIRECTORY")%>"></td>
                    </tr>
                    <tr class="dark">
                        <th>Log Properties File</th>
                        <td><input type="text" size="60" name="LOGGING_PROPERTY_FILE" value="<%=propertiesInfo.getProperty("LOGGING_PROPERTY_FILE")%>"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="wrapper">
            <h3>Miscellaneous Settings
                <img id="miscellaneousSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
            </h3>
            <div class="window">
                <table>
                    <tr class="light">
                        <th>Max Chars on Submit*</th>
                        <td><input type="text" size="60" name="MAX_CHARS_ON_SUBMIT" value="<%=propertiesInfo.getProperty("MAX_CHARS_ON_SUBMIT")%>"></td>
                    </tr>
                    <tr class="dark">
                        <th>Map Fields Count*</th>
                        <td><input type="text" size="60" name="MAP_FIELDS_COUNT" value="<%=propertiesInfo.getProperty("MAP_FIELDS_COUNT")%>"></td>
                    </tr>
                    <tr class="light">
                        <th>Max Cache Size*</th>
                        <td><input type="text" size="60" name="MAX_CACHE_SIZE" value="<%=propertiesInfo.getProperty("MAX_CACHE_SIZE")%>"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="wrapper">
            <h3>SSO Adapter Settings
                <img id="ssoAdapterSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>        
            </h3>
            <div class="window">
                <table>
                    <tr class="light">
                        <th>SSO Adapter Class</th>
                        <td><input type="text" size="60" name="SSO_ADAPTER_CLASS" value="<%=propertiesInfo.getProperty("SSO_ADAPTER_CLASS")%>"/></td>
                    </tr>
                    <tr class="dark">
                        <th>SSO Adapter Properties</th>
                        <td><input type="text" size="60" name="SSO_ADAPTER_PROPERTIES" value="<%=propertiesInfo.getProperty("SSO_ADAPTER_PROPERTIES")%>"/></td>
                    </tr>
                </table>
            </div>
        </div>
        <ul>
            <li><input type="submit" name="UpdateProperties" value="Update Properties"/> or <a href="AdminConsole">Cancel</a></li>
        </ul>
    </form>
</div>
