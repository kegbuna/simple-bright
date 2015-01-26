<jsp:useBean id="customerSurvey" scope="request" class="com.kd.kineticSurvey.beans.CustomerSurvey"/>
<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>

<%
    response.setHeader("CACHE-CONTROL","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
    response.setDateHeader ("EXPIRES", 0); //prevents caching at the proxy server
    response.setHeader("PRAGMA","NO-CACHE");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title><%= customerSurvey.getSurveyTemplateName()%></title>
        <link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>

        <%@ include file="resources/includes/includesTemplate.jsp" %>
        <script type="text/javascript">KD.utils.ClientManager.enforceSameOriginFrame();</script>

        <%--Include Remedy-created style/javascript info--%>
        <jsp:getProperty name="customerSurvey" property="styleInfo"/>
        <script type="text/javascript">
            function ks_initSessionVars(){
                clientManager.authenticated=<%=UserContext.isAuthenticated()%>;
                clientManager.authenticationType='<%=UserContext.getAuthenticationType()%>';
                clientManager.catalogName='<%=StringEscapeUtils.escapeXml(customerSurvey.getCategory())%>';
                clientManager.categoryId='<%=customerSurvey.getCategoryId()%>';
                clientManager.customerSurveyId='<%=customerSurvey.getCustomerSurveyInstanceID()%>';
                clientManager.errorMessage='<%=StringEscapeUtils.escapeXml(customerSurvey.getErrorMessage()+UserContext.getErrorMessage())%>';
                clientManager.isAuthenticationRequired='<%=customerSurvey.isAuthenticationRequired()%>';
                clientManager.isNewPage=<%=customerSurvey.getIsNewPage()%>;
                clientManager.maxCharsOnSubmit=<%=customerSurvey.getMaxCharsOnSubmit()%>;
                clientManager.originatingPage='<%=StringEscapeUtils.escapeXml(UserContext.getOriginatingPage())%>';
                clientManager.sessionId='<%=customerSurvey.getCustomerSessionInstanceID()%>';
                clientManager.submitType='<%=customerSurvey.getSubmitType()%>'
                clientManager.successMessage='<%=StringEscapeUtils.escapeXml(customerSurvey.getSuccessMessage()+UserContext.getSuccessMessage())%>';
                clientManager.templateId='<%=customerSurvey.getSurveyTemplateInstanceID()%>';
                clientManager.userName='<%=StringEscapeUtils.escapeXml(UserContext.getUserName())%>';
                clientManager.webAppContextPath='<%=request.getContextPath()%>';
            }

            function customInitialization() {
            }

            var clientManager= KD.utils.ClientManager;
            KD.utils.Action.addListener(window, "load", clientManager.init, clientManager, true);
            KD.utils.Action.addListener(window, "load", KD.utils.Util.checkCachePageLoad, clientManager, true);
            KD.utils.Action.addListener(window, "unload", KD.utils.Util.resetCachePageValues, clientManager, true);

            <%-- ReviewRequest override, used to avoid the need to have to maintain existing service item to remove the iFrame callback event --%>
                KD.utils.Action.addListener(window, "load", purgeReviewRequestCallback);
                function purgeReviewRequestCallback() {
                    var iFrameObj = document.getElementById('reviewRequest');
                    if (iFrameObj) {
                        YAHOO.util.Event.purgeElement(iFrameObj);
                    }
                }
            <%-- END ReviewRequest override--%>

        </script>

        <jsp:getProperty name="customerSurvey" property="customHeaderContent"/>

    </head>
    <body>
        <noscript>
            <div class="noscript">Javascript must be enabled in your browser to use this application.</div>
        </noscript>
        <form name='pageQuestionsForm' id='pageQuestionsForm' class='pageQuestionsForm' method='post' action='SubmitPage'>
            <jsp:getProperty name="customerSurvey" property="questions"/>

            <% if (request.getParameter("srv") != null) {%>
            <input type="hidden" name="srv" value="<%=customerSurvey.getSurveyTemplateInstanceID()%>"/>
            <%}%>
            <% if (request.getParameter("csrv") != null) {%>
            <input type="hidden" name="csrv" value="<%=customerSurvey.getCustomerSurveyInstanceID()%>"/>
            <%}%>

            <input type="hidden" name="templateID" id="templateID" value="<%=customerSurvey.getSurveyTemplateInstanceID()%>"/>
            <input type="hidden" name="sessionID" id="sessionID" value="<%=customerSurvey.getCustomerSessionInstanceID()%>"/>
            <input type="hidden" name="surveyRequestID" id="surveyRequestID" value="<%=customerSurvey.getCustomerSurveyRequestID()%>"/>
            <input type="hidden" name="pageID" id="pageID" value="<%=customerSurvey.getPageInstanceID()%>"/>
            <input type="hidden" name="queryString" id="queryString" value="<%=StringEscapeUtils.escapeXml(request.getQueryString())%>"/>
        </form>
        <jsp:setProperty name="UserContext" property="errorMessage" value=""/>
    </body>
</html>
