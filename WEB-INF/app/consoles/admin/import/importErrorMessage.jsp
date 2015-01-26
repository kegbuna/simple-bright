<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="com.kd.kineticSurvey.beans.UserContext"%>
<%
    UserContext userContext = (UserContext) session.getAttribute("UserContext");
    String errorMessage = userContext.getErrorMessage();
    java.util.List<String> errors = (java.util.List<String>)session.getAttribute("errors");
    // Clear the messages from UserContext
    userContext.setErrorMessage("");
%>
<div class="alerts">
    <% if (org.apache.commons.lang3.StringUtils.isNotBlank(errorMessage)) { %>
        <div class="alert alert-danger">
            <%= errorMessage %>
            <% if (errors != null && !errors.isEmpty()) { %>
            <ul>
                <% for (String error : errors) { %>
                <li><%=org.apache.commons.lang3.StringEscapeUtils.escapeHtml4(error)%></li>
                <% } %>
            </ul>
            <% } %>
        </div>
    <% } %>
</div>
