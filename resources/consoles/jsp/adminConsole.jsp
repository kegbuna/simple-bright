<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<!DOCTYPE html>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext" />
<jsp:useBean id="licenseInfo" scope="request" class="com.kd.kineticSurvey.beans.LicenseInfo" />
<%@ page import="java.util.HashMap"%>
<%
        response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
        response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
        response.setHeader("Pragma","no-cache");

        request.setAttribute("pageName", "Admin Console");
%>

<%!
    private String getKsrVersion() {
        String key = "Kinetic SR";
        String version = "";
        String E_API = "AR API Not Found";
        String E_API_JNI = "AR JNI API Not Found";
        String E_UNKNOWN = "Unknown";
        com.kd.kineticSurvey.beans.JarInfo jarInfo = new com.kd.kineticSurvey.beans.JarInfo();
        for (int i = 1; i < jarInfo.getJarCount()+1; i++) {
            if (key.equalsIgnoreCase(jarInfo.getJarKey(i))) {
                try {
                    version = jarInfo.getJarVersion(i);
                } catch (UnsatisfiedLinkError e1) {
                    version = E_API_JNI;
                } catch (NoClassDefFoundError e2) {
                    version = E_API;
                } catch (Throwable t) {
                    version = E_UNKNOWN;
                }
                break;
            }
        }
        return version;
    }
%>

<% 
        String ksrVersion = getKsrVersion();
        String authType = (String) request.getAttribute("authType");
        String curActive = (String) request.getAttribute("curActive");
        String configPage = (String) request.getAttribute("configPage");
        boolean isAdmin = false;
        try {
            isAdmin = UserContext.getArContext().isAdminUser();
        } catch (Exception e) {
            isAdmin = false;
        }

        String[] idArray;
        String[] idArrayConfig = {"web_properties", "logging", "loaded_libraries"};
        String[] idArrayManager = {"import", "export"};
        String[] idArrayArAdmin = {"web_properties", "task_manager", "import",
            "export", "logging", "loaded_libraries", "license_info"};
        if (authType.equalsIgnoreCase(com.kd.kineticSurvey.authentication.Authenticator.AUTH_TYPE_CONFIG)) {
            idArray = idArrayConfig;
        } else {
            if (isAdmin) {
                idArray = idArrayArAdmin;
            } else {
                idArray = idArrayManager;
            }
        }
        
        if (ksrVersion.equals("AR API Not Found") || ksrVersion.equals("AR JNI API Not Found")) {
            if ("web_properties".equals(idArray[0])) {
                String[] temp = new String[idArray.length - 1];
                for (int index = 0; index < idArray.length - 1; index++) {
                    temp[index] = idArray[index+1];
                }
                idArray = new String[temp.length];
                idArray = temp;
            }
        }
        if (curActive == null || curActive.length() == 0) {
            curActive = idArray[0];
        }
            
        HashMap jspById = new HashMap();

        if (configPage != null) {
            if (configPage.equals("edit")) {
                jspById.put("web_properties", "admin_partials/editProperties.jsp");
            }
            else if (configPage.equals("changeRemedy")) {
                jspById.put("web_properties", "admin_partials/changeRemedy.jsp");
            }
            else if (configPage.equals("changeAdminUser")) {
                jspById.put("web_properties", "admin_partials/changeAdminUser.jsp");
            }
            else {
                jspById.put("web_properties", "admin_partials/displayProperties.jsp");
            }
        } else {
            jspById.put("web_properties", "admin_partials/displayProperties.jsp");
        }
        jspById.put("task_manager", "admin_partials/adminPoller.jsp");
        jspById.put("import", "manager_partials/templateImport.jsp");
        jspById.put("export", "manager_partials/templateExport.jsp");
        jspById.put("logging", "admin_partials/displayLog.jsp");
        jspById.put("license_info", "admin_partials/licenseInfo.jsp");
        jspById.put("loaded_libraries", "admin_partials/displayVersions.jsp");

        HashMap titleById = new HashMap();
        titleById.put("web_properties", "Properties");
        titleById.put("task_manager", "Task Manager");
        titleById.put("import", "Import");
        titleById.put("export", "Export");
        titleById.put("logging", "Logging");
        titleById.put("license_info", "Licensing");
        titleById.put("loaded_libraries", "Dependencies");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=8" />
        <meta http-equiv="X-Frame-Options" content="sameorigin"/>
        <link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
        <title>Kinetic SR :: Admin Console</title>
        <jsp:include page="shared/standardIncludes.jsp"/>
        <script type="text/javascript">KD.utils.ClientManager.enforceSameOriginFrame();</script>
        <script src="<%= request.getContextPath() + "/resources/consoles/js/kd_import.js"%>" type="text/javascript"></script>
        <script type="text/javascript">
            function adminInit() {
                tabSelect('<%=curActive%>');
            }

            /**
             * Pointer to the original KD.utils.Action.setQuestionValue function
             */
            var originalSetQuestionValue = KD.utils.Action.setQuestionValue;
            
            /**
             * Overrides the original KD.utils.Action.setQuestionValue so the alert
             * message doesn't pop up on the AdminConsole
             * @param label_id : Either the Label name (Not the question name) OR the InstanceID for the Question
             * @param value : The string value that is to be set
             * @return none
             */
            KD.utils.Action.setQuestionValue = function(label_id, value){
                if (KD.utils.Util.getQuestionInput(label_id)) {
                    originalSetQuestionValue(label_id, value);
                }
            }
        </script>
    </head>
    <body onLoad="adminInit();">
        <div id="doc3" class="yui-t1">
            <div id="hd">
                <img src="<%=request.getContextPath() + "/resources/consoles/images/V45_AdminConsole_KinPowered.gif"%>" alt="Kinetic Powered" />
                <span class="title">Kinetic Survey/Request Administration Console</span>
                <span class="version"><%=ksrVersion%></span>
            </div>
            <div id="bd">
                <div id="yui-main">
                    <div class="yui-b">
                        <div class="yui-g">
                            <div id="misc">
                                <table>
                                    <tr>
                                        <th class="dataLabel">Logged in as:</th>
                                        <td class="dataField"><jsp:getProperty name="UserContext" property="userName"/></td>
                                        <td><a href="KSAuthenticationServlet?Logout=true">Logout</a></td>
                                    </tr>
                                    <tr>
                                        <th class="dataLabel">Remedy Server:</th>
                                        <td class="dataField"><jsp:getProperty name="UserContext" property="arServer"/></td>
                                        <% if (licenseInfo != null && licenseInfo.getLicenseName().trim().length() > 0) {
            licenseInfo.setLicenseName("Manager License Key");
            if (licenseInfo.getLicenseKey().trim().length() > 0 && authType.equalsIgnoreCase(com.kd.kineticSurvey.authentication.Authenticator.AUTH_TYPE_CONFIG)) {%>
                                        <td><a href="KSAuthenticationServlet?Logout=true">Login As Remedy Admin</a></td>
                                        <% }%>
                                        <% }%>
                                    </tr>
                                    <tr>
                                        <th class="dataLabel">Web Server:</th>
                                        <td class="dataField"><%= request.getServerName()%></td>
                                    </tr>
                                </table>
                                <ul id="tabs" class="tabContainer">
                                    <% for (int i = 0; i < idArray.length; i++) {%>
                                    <% String curId = idArray[i];%>
                                    <% if (curId.equals(curActive)) {%>
                                    <li class="activeTab" id="<%= curId%>tab"
                                        onclick="tabSelect('<%= curId%>');"
                                        onmouseover="tabHover(this);"
                                        onmouseout="tabUnhover(this);"><%= (String) titleById.get(curId)%></li>
                                    <% } else {%>
                                    <li id="<%= curId%>tab"
                                        onclick="tabSelect('<%= curId%>');"
                                        onmouseover="tabHover(this);"
                                        onmouseout="tabUnhover(this);"><%= (String) titleById.get(curId)%></li>
                                    <% }%>
                                    <% }%>
                                </ul>
                                <div id="tab_bottom" class="clear"></div>
                            </div>
                            <% for (int i = 0; i < idArray.length; i++) {%>
                            <% String curId = idArray[i];%>
                            <% if (curId.equals(curActive)) {%>
                            <div class="div activeDiv" id="<%= curId%>div">
                                <jsp:include page="<%= (String)jspById.get(curId) %>" />
                            </div>
                            <% } else {%>
                            <div class="div" id="<%= curId%>div">
                                <jsp:include page="<%= (String)jspById.get(curId) %>" />
                            </div>
                            <% }%>
                            <% }%>
                        </div>
                    </div>
                </div>
                <jsp:include page="shared/console_sidebar.jsp" />
            </div>
            <div id="ft"></div>
        </div>
    <jsp:setProperty name="UserContext" property="errorMessage" value=""/>
    </body>
</html>
