<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <div class="title">
            Kinetic Setup
        </div>
        <div class="message">
            <p>
                This wizard will walk you through changing the Remedy server to setup this
                version of Kinetic Request and Survey.
            </p>
        </div>
        <div class="actions">
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/app/admin">Cancel</a>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/app/installer/setup">Continue</a>
        </div>
    </jsp:attribute>
</tag:installer>
