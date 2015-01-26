<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String installedReleaseDate = request.getAttribute("installed-release-date") == null ? "Unknown"
        : (String)request.getAttribute("installed-release-date");
    String installedVersion = request.getAttribute("installed-version") == null ? "Unknown"
        : (String)request.getAttribute("installed-version");
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <div class="title">
            Kinetic Setup - Cannot Proceed
        </div>
        <div class="message">
            <div class="instructions">
                <h4>
                    Cannot proceed to use this Remedy server.
                </h4>
                <p>
                    A newer version of Kinetic Request and Survey is already installed on this server.
                </p>
                <ul class="well well-sm list-unstyled">
                    <li>Installed Version: <%=escape(installedVersion)%></li>
                    <li>Release Date: <%=escape(installedReleaseDate)%></li>
                </ul>
                <hr/>
                <p>
                    Click 'Previous' to setup Kinetic Request and Survey on a different Remedy server, or 
                    contact Kinetic Data support to receive a new version.
                </p>
            </div>
        </div>
        <div class="actions">
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/app/installer/server">Previous</a>
        </div>
    </jsp:attribute>
</tag:installer>
