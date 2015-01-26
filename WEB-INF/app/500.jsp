<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:error>
    <jsp:attribute name="title">Error (500)</jsp:attribute>
    <jsp:attribute name="bodyClass">error-page-500</jsp:attribute>
    <jsp:attribute name="content">We're sorry, but something went wrong (500)</jsp:attribute>
</tag:error>