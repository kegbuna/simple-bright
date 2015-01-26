<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:error>
    <jsp:attribute name="title">We're sorry, but something went wrong (400)</jsp:attribute>
    <jsp:attribute name="bodyClass">error-page-400</jsp:attribute>
    <jsp:attribute name="content">
        <%= StringUtils.isBlank((String)request.getAttribute("javax.servlet.error.message")) ?
                "We're sorry, but something went wrong (400)" : 
                StringEscapeUtils.escapeHtml4((String)request.getAttribute("javax.servlet.error.message"))
        %>
    </jsp:attribute>
</tag:error>