<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="post">
            <div class="title">
                Kinetic Setup - Install
            </div>
            <div class="message">
                <div class="instructions">
                    <h4>
                        Kinetic Request and Survey have not been installed on this Remedy server.
                    </h4>
                    <hr/>
                    <h4>Automatic Installation</h4>
                    <p>
                        This setup program can automatically install all the Remedy workflow objects and data
                        records to the Remedy server.
                    </p>
                    <p>
                        Click the 'Continue' button below to configure the application before installing
                        the Remedy objects and data, or click the 'Skip optional steps' link to continue
                        with the installation, but skip the configuration steps that can be configured 
                        within Remedy at a later time.
                    </p>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
            <div class="actions">
                <button class="btn btn-link pull-left" type="submit" value="Skip optional steps">Skip optional steps</button>
                <button class="btn" type="button" value="Previous">Previous</button>
                <button class="btn btn-primary" type="submit" value="License">Continue</button>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
