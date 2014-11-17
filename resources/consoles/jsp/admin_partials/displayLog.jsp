<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="propertiesInfo" scope="request" class="com.kd.kineticSurvey.beans.CurrentProperties" />
<div id="logSettings">
    <div class="wrapper">
        <h3>
            Logger Settings
            <span style="float:right;">
                Download:
                <a href="LogCopyDownload?type=application" style="color: #F0BD99;" target="_blank">Application Log</a>
                |
                <a href="LogCopyDownload?type=poller" style="color: #F0BD99;" target="_blank">Task Poller Log</a>
                |
                <a href="LogCopyDownload?type=all" style="color: #F0BD99;">All (zip)</a>
            </span>
        </h3>
        <div class="window">
            <table>
                <tr class="light">
                    <th>Log Level</th>
                    <td><%=propertiesInfo.getProperty("DEFAULT_LOG_LEVEL")%></td>
                </tr>
                <tr class="dark">
                    <th>Max Log Size (Bytes)</th>
                    <td><%=propertiesInfo.getProperty("MAX_LOG_SIZE")%></td>
                </tr>
                <tr class="light">
                    <th>Log Output Directory</th>
                    <td><%=propertiesInfo.getProperty("LOG_OUTPUT_DIRECTORY")%></td>
                </tr>
                <% if (!"".equals(propertiesInfo.getProperty("LOGGING_PROPERTY_FILE"))) { %>
                <tr class="dark">
                    <th>Log Properties File</th>
                    <td><%=propertiesInfo.getProperty("LOGGING_PROPERTY_FILE")%></td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</div>