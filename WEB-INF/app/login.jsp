<%@page import="com.kd.kineticSurvey.impl.RemedyHandler"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@include file="/WEB-INF/app/framework/authenticatorMessages.jspf" %>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<tag:login>
    <jsp:attribute name="title">Kinetic | Login</jsp:attribute>
    <jsp:attribute name="content">
        <div class="col-xs-12">
            <div id="login-box">
                <div class="row">
                    <div class="col-xs-12">
                        <div id="login-box-inner">
                            <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                            <h2>Sign in</h2>
                            <form accept-charset="UTF-8" action="<%=request.getContextPath()+"/KSAuthenticationServlet"%>" class="new_user" id="new_user" method="post"
                                  data-disable-on-submit="disable-on-submit">
                                <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
                                <input type="hidden" id="loginSessionID" name="sessionID" value="<%=UserContext.getCustomerSessionInstanceID()%>"/>
                                <input type="hidden" id="originatingPage" name="originatingPage" value="<%=StringEscapeUtils.escapeXml(UserContext.getOriginatingPage())%>"/>
                                <p>ARS Server: <%= "true".equals(RemedyHandler.INITIAL_STARTUP) ? "Unconfigured" : RemedyHandler.DEFAULT_SERVER %></p>
                                
                                <div class="form-group">
                                    <label for="UserName">Login</label>
                                    <input autofocus="autofocus" class="form-control" id="UserName" name="UserName" type="text"  value="<%=escape(request.getParameter("UserName"))%>">
                                </div>
                                <div class="form-group">
                                    <label for="Password">Password</label>
                                    <input autocomplete="off" class="form-control" id="Password" name="Password" type="password">
                                </div>
                                <input class="btn btn-default" name="commit" type="submit" value="Sign in">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </jsp:attribute>
</tag:login>