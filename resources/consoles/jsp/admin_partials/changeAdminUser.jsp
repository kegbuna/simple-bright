<%--
 Copyright (c) 2013, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="propertiesInfo" scope="request" class="com.kd.kineticSurvey.beans.CurrentProperties" />
<%
    String errorMessage = (String) request.getAttribute("configErrorMessage");
%>
<script src="<%= request.getContextPath() + "/resources/consoles/js/toolTip.js"%>" type="text/javascript"></script>
<div id="config">
    <% if (!errorMessage.equals("")) {%>
    <div class="errorMessage">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Error.png"/>
        <%= errorMessage%>
    </div>
    <% } %>
    <form action="Config" method="post">
        <div class="wrapper">
            <h3>Configuration Administrator Credentials
                <img id="configAdminCredentialDetails" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
            </h3>
            <div class="window">
                <table>
                    <tr class="light">
                        <th>Username*</th>
                        <td><input type="text" size="60" name="CONFIG_ADMIN_USER" value="<%=propertiesInfo.getProperty("CONFIG_ADMIN_USER")%>"></td>
                    </tr>
                    <tr class="dark">
                        <th>Current Password*</th>
                        <td><input type="password" size="60" name="CONFIG_ADMIN_PWD_OLD" autocomplete="off" placeholder="Current Password"></td>
                    </tr>
                    <tr class="light">
                        <th>New Password*</th>
                        <td><input type="password" size="60" name="CONFIG_ADMIN_PWD" autocomplete="off" placeholder="New Password"></td>
                    </tr>
                    <tr class="dark">
                        <th>Confirm New Password*</th>
                        <td><input type="password" size="60" name="CONFIG_ADMIN_PWD_CONFIRM" autocomplete="off" placeholder="Confirm New Password"></td>
                    </tr>
                </table>
            </div>
        </div>
        <ul>
            <li><input type="submit" name="ChangeAdminUser" value="Change Admin User"/> or <a href="AdminConsole">Cancel</a></li>
        </ul>
    </form>
</div>
