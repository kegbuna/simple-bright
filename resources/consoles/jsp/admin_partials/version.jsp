<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="jarInfo" scope="session" class="com.kd.kineticSurvey.beans.JarInfo" />
<%
    String key = "Kinetic SR";
    String version = "";
    for (int i = 1; i < jarInfo.getJarCount()+1; i++) {
        if (key.equalsIgnoreCase(jarInfo.getJarKey(i))) {
            version = jarInfo.getJarVersion(i);
            break;
        }
    }
%>
<div>Version: <%= version %></div>
