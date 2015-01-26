<%@page import="com.kineticdata.ksr.Version"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String installedReleaseDate = request.getAttribute("installed-release-date") == null ? "Unknown"
        : (String)request.getAttribute("installed-release-date");
    String installedVersion = request.getAttribute("installed-version") == null ? "Unknown"
        : (String)request.getAttribute("installed-version");
    Integer fullAnswerFieldLength = (Integer)request.getAttribute("full-answer-field-length");
    String fullAnswerFieldCharacters = null;
    if (fullAnswerFieldLength != null) {
        fullAnswerFieldCharacters = fullAnswerFieldLength == 0 ? "unlimited" : String.valueOf(fullAnswerFieldLength.intValue());
    }
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:installer>
    <jsp:attribute name="content">
        <form action="process" method="post">
            <div class="title">
                Kinetic Setup - Upgrade
            </div>
            <div class="message">
                <div class="instructions">
                    <h4>
                        An older version of Kinetic Request and Survey is already installed on 
                        Remedy server: <%=escape(request.getAttribute("server"))%>.
                    </h4>
                    <ul class="list-unstyled well well-sm">
                        <li><strong>Release Date: <%=escape(installedReleaseDate)%></strong></li>
                        <li><strong>Version <%=escape(installedVersion)%></strong></li>
                    </ul>
                    <h4>
                        This installation of Kinetic Request and Survey is:
                    </h4>
                    <ul class="list-unstyled well well-sm">
                        <li><strong>Release Date: <%=escape((String)Version.getReleaseDate())%></strong></li>
                        <li><strong>Version: <%=escape((String)Version.getVersion())%></strong></li>
                    </ul>
                    <hr/>
                    <h4>Automatic Upgrade</h4>
                    <p>
                        The Remedy server can be upgraded automatically from this setup program.
                    </p>
                    <p>
                        This will involve overwriting all existing Kinetic Request and Survey workflow
                        objects, as well as import any new data records that are required by the applications.
                    </p>
                    <% if (!StringUtils.equals("4000", fullAnswerFieldCharacters)) { %>
                    <div class="bs-callout bs-callout-danger">
                        <h4>Warning</h4>
                        <p>
                            The 'Full Answer' field length on the KS_SRV_SurveyAnswer form has been changed to
                            a length of <%=fullAnswerFieldCharacters%> characters.  Continuing with this 
                            upgrade will change the 'Full Answer' field back to 4000 characters.  This will
                            truncate any submitted answers that are longer than this.
                        </p>
                        <p>
                            <strong>
                                You must take manual action to avoid data loss before continuing with this
                                upgrade.
                            </strong>
                        </p>
                    </div>
                    <% } %>
                    <p>
                        Clicking the 'Continue' button below will start the upgrade process.
                    </p>
                </div>
            </div>
            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
            <div class="actions">
                <% if (!StringUtils.equals("4000", fullAnswerFieldCharacters)) { %>
                <button class="btn btn-primary" type="button" value="Previous">Previous</button>
                <button class="btn" type="submit" value="Upgrade">Continue</button>
                <% } else { %>
                <button class="btn" type="button" value="Previous">Previous</button>
                <button class="btn btn-primary" type="submit" value="Upgrade">Continue</button>
                <% } %>
            </div>
        </form>
    </jsp:attribute>
</tag:installer>
