<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="userContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext" />
<%
userContext = (com.kd.kineticSurvey.beans.UserContext) session.getAttribute("UserContext");
String successMessage = userContext.getSuccessMessage();
String errorMessage = userContext.getErrorMessage();
%>

<% if (!successMessage.equals("")) {%>
<div class="wrapper">
    <h3>Import Results</h3>
    <div class="window">
        <ul><li class="light"><%= successMessage%></li></ul>
    </div>
</div>
<% }%>
<% if (!errorMessage.equals("")) {%>
<div class="errorMessage">
    <img src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Error.png" alt="error"/>
    <span id="importErrorMessage"><%= errorMessage%></span>
</div>
<% }
userContext.setErrorMessage("");
userContext.setSuccessMessage("");
%>
