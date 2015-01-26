<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="addWebServer" method="post">
            <div class="title">
                Kinetic Setup - Add Web Server
            </div>
            <div class="message">
                <div class="instructions">
                    <div>
                        <p>
                            Kinetic Request and Survey is already installed on this Remedy server.
                        </p>
                        <p>
                            Simply click the 'Continue' button to add this Kinetic Request and Survey web
                            server to the Remedy server.  No changes will be made to the Remedy server.
                        </p>
                    </div>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
            <div class="actions">
                <button class="btn" type="button" value="Previous">Previous</button>
                <button class="btn btn-primary" type="submit" value="Continue">Continue</button>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
