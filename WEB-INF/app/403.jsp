<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    // Check to see if there are any reasons for denial (these are likely added to the session after
    // a failed KSL evaluation).
    java.util.List<String> reasonsForDenial = (java.util.List<String>)session.getAttribute("Reasons For Denial");    
    java.util.List<String> escapedReasonsForDenial = new java.util.ArrayList<String>();
    if (reasonsForDenial != null) {
        for (String reasonForDenial : reasonsForDenial) {
            escapedReasonsForDenial.add(StringEscapeUtils.escapeHtml4(reasonForDenial));
        }
    }
%>
<tag:error>
    <jsp:attribute name="title">We're sorry, but something went wrong (403)</jsp:attribute>
    <jsp:attribute name="bodyClass">error-page-403</jsp:attribute>
    <jsp:attribute name="content">
    <% if (reasonsForDenial != null) { %>
        You are not authorized to access the requested resource: <%=StringUtils.join(escapedReasonsForDenial, " ")%>.
    <% } else { %>
        <%= StringUtils.isBlank((String)request.getAttribute("javax.servlet.error.message")) ?
                "We're sorry, but something went wrong (403)" : 
                StringEscapeUtils.escapeHtml4((String)request.getAttribute("javax.servlet.error.message"))
        %>
    <% } %>
    </jsp:attribute>
</tag:error>