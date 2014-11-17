<%--
 Copyright (c) 2013, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="propertiesInfo" scope="request" class="com.kd.kineticSurvey.beans.CurrentProperties" />
<%
    String errorMessage = (String) request.getAttribute("configErrorMessage");
    String passwordsEncrypted = "";
    String seed_display = "none";
    if (propertiesInfo.getProperty("ENCRYPT_PASSWORD").equals("true")) {
        passwordsEncrypted = "checked";
        seed_display = "block";
    }
    String apiImpersonateUser = "checked";
    if (!propertiesInfo.getProperty("API_IMPERSONATE_USER").equals("true")) {
        apiImpersonateUser = "";
    }
%>
<script src="<%= request.getContextPath() + "/resources/consoles/js/toolTip.js"%>" type="text/javascript"></script>
<script type="text/javascript">
    function confirmSubmit(el) {
        var
        returnValue = true,
        value = el.form['DEFAULT_PWD'].value;
        if ( value == null || value.length === 0) {
            returnValue = confirm("The web user password is blank, continue?");
        }
        return returnValue;
    }
    function setEncryptPassword() {
        var cb = document.getElementById("encrypt_password_chk");
        var txt = document.getElementById("encrypt_password");
        if (cb && cb.checked) {
            txt.value = "true";
        } else {
            txt.value = "false";
        }
    }
    function checkEncryptPasswords(chkbox) {
        setEncryptPassword();
        editEncryptionSeed(chkbox);
    }
    function editEncryptionSeed(chkbox) {
        var encryption_seed_div = document.getElementById("encryption_seed");
        if (chkbox.checked) {
            encryption_seed_div.style.display = "block";
        } else {
            encryption_seed_div.style.display = "none";
        }
    }
    function checkApiImpersonateUser(chkbox) {
        var txt = document.getElementById("api_impersonate_user");
        if (chkbox.checked) {
            txt.value = "true";
        } else {
            txt.value = "false";
        }
    }
</script>
<div id="config">
    <% if (!errorMessage.equals("")) {%>
    <div class="errorMessage">
        <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Error.png"/>
        <%= errorMessage%>
    </div>
    <% } %>
    <form action="Config" method="post">
        <div class="wrapper">
            <h3>Remedy Server Settings
                <img id="remedyServerSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
            </h3>
            <div class="window">
                <table>
                    <tr class="light">
                        <th>Server Name*</th>
                        <td><input type="text" size="60" name="DEFAULT_SERVER" value="<%=propertiesInfo.getProperty("DEFAULT_SERVER")%>"></td>
                    </tr>
                    <tr class="dark">
                        <th>TCP Port</th>
                        <td><input type="text" size="60" name="DEFAULT_TCP" value="<%=propertiesInfo.getProperty("DEFAULT_TCP")%>"></td>
                    </tr>
                    <tr class="light">
                        <th>RPC Port</th>
                        <td><input type="text" size="60" name="DEFAULT_RPC" value="<%=propertiesInfo.getProperty("DEFAULT_RPC")%>"></td>
                    </tr>
                    <tr class="dark">
                        <th>Answer Thread RPC Port</th>
                        <td><input type="text" size="60" name="ANSWER_THREAD_RPC" value="<%=propertiesInfo.getProperty("ANSWER_THREAD_RPC")%>"></td>
                    </tr>
                    <tr class="light">
                        <th>API Connection Limit</th>
                        <td><input type="text" size="60" name="API_CONNECTION_LIMIT" value="<%=propertiesInfo.getProperty("API_CONNECTION_LIMIT")%>">
                            <span class="orange">&nbsp*Requires a restart of the web application.</span></td>
                    </tr>
                    <tr class="dark">
                        <th>API Impersonate User</th>
                        <td><input type="checkbox" name ="API_IMPERSONATE_USER_CHK" id="api_impersonate_user_chk" <%= apiImpersonateUser%> onclick="checkApiImpersonateUser(this);"/></td>
                    </tr>
                </table>
                <div style="display:none">
                    <table>
                        <tr>
                            <th>API Impersonate User</th>
                            <td><input type="text" size="60" name="API_IMPERSONATE_USER" id="api_impersonate_user" value="<%=propertiesInfo.getProperty("API_IMPERSONATE_USER")%>"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="wrapper">
            <h3>Web User Settings
                <img id="webUserSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
            </h3>
            <div class="window">
                <table>
                    <tr class="light">
                        <th>Web User ID*</th>
                        <td><input type="text" size="60" name="DEFAULT_USER" value="<%=propertiesInfo.getProperty("DEFAULT_USER")%>"></td>
                    </tr>
                    <tr class="dark">
                        <th>Web User Password*</th>
                        <td><input type="password" size="60" name="DEFAULT_PWD" autocomplete="off" placeholder="Password"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="wrapper">
            <h3>Encryption Settings
                <img id="encryptionSettings" class="helpImg" src="<%= request.getContextPath()%>/resources/consoles/images/SymbolHelp.gif" alt="Help"/>
            </h3>
            <div class="window">
                <table>
                    <tr class="light">
                        <th>Encrypt Password</th>
                        <td><input type="checkbox" name="ENCRYPT_PASSWORD_CHK" id="encrypt_password_chk" <%= passwordsEncrypted%> onclick="checkEncryptPasswords(this);"></td>
                    </tr>
                </table>
                <div style="display:none">
                    <table>
                        <tr class="dark">
                            <th>Encrypt Password</th>
                            <td><input type="text" size="60" name="ENCRYPT_PASSWORD" id="encrypt_password" value="<%=propertiesInfo.getProperty("ENCRYPT_PASSWORD")%>"></td>
                        </tr>
                    </table>
                </div>
                <div id="encryption_seed" style="display:<%= seed_display%>">
                    <table>
                        <tr class="dark">
                            <th>Encryption Seed</th>
                            <td><input type="text" size="60" name="ENCRYPTION_SEED" value="<%=propertiesInfo.getProperty("ENCRYPTION_SEED")%>" autocomplete="off"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <ul>
            <li>
                <input type="submit" name="ChangeRemedy" value="Change Remedy Settings" onclick="return confirmSubmit(this);"/> or <a href="AdminConsole">Cancel</a>
            </li>
        </ul>
    </form>
</div>
