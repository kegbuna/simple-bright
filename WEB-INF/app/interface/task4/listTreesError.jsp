<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = "An unexpected error was encountered retrieving the tree list from Kinetic Task.";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style type="text/css">
            body {
                width: 600px;
            }
        </style>
        <title>Task Trees</title>
    </head>
    <body>
        <h1>Error</h1>
        <p><%=escape(errorMessage)%></p>
    </body>
</html>
