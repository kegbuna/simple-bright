<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="com.kd.kineticSurvey.beans.UserContext"%>
<%
    UserContext userContext = (UserContext) session.getAttribute("UserContext");
    String successMessage = userContext.getSuccessMessage();
    // Clear the messages from UserContext
    userContext.setSuccessMessage("");
%>
<div class="alerts">
    <% if (org.apache.commons.lang3.StringUtils.isNotBlank(successMessage)) { %>
        <div class="alert alert-success">
            <button class="close" data-dismiss="alert">&times;</button>
            <%= successMessage %>
        </div>
    <% } %>
</div>
