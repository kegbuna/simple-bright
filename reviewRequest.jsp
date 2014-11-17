<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<jsp:useBean id="RequestPages" scope="request" class="java.util.Vector"/>
<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%@include file="resources/partials/reviewFunctions.jsp"%>
<%
    com.kd.kineticSurvey.beans.CustomerSurveyReview customerSurvey = null;
    if (RequestPages.size() > 0) {
        customerSurvey = (com.kd.kineticSurvey.beans.CustomerSurveyReview) RequestPages.get(0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta http-equiv="X-Frame-Options" content="sameorigin"/>
        <title><%=customerSurvey.getSurveyTemplateName()%></title>
        <link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>

        <%@ include file="resources/includes/includesReview.jsp" %>
        <script type="text/javascript">KD.utils.ClientManager.enforceSameOriginFrame();</script>

        <%--Include Remedy-created style/javascript info--%>
        <%
            java.util.Iterator itrStyles = RequestPages.iterator();
            while (itrStyles.hasNext()) {
                com.kd.kineticSurvey.beans.CustomerSurveyReview cs = (com.kd.kineticSurvey.beans.CustomerSurveyReview) itrStyles.next(); %>
        <%= cs.getStyleInfo() %>
        <% } %>

        <script type="text/javascript">
            function ks_initSessionVars() {
                clientManager.authenticated=<%=UserContext.isAuthenticated()%>;
                clientManager.authenticationType='<%=UserContext.getAuthenticationType()%>';
                clientManager.catalogName='<%=StringEscapeUtils.escapeXml(customerSurvey.getCategory())%>';
                clientManager.categoryId='<%=customerSurvey.getCategoryId()%>';
                clientManager.customerSurveyId='<%=customerSurvey.getCustomerSurveyInstanceID()%>';
                clientManager.errorMessage='<%=StringEscapeUtils.escapeXml(customerSurvey.getErrorMessage()+UserContext.getErrorMessage())%>';
                clientManager.isAuthenticationRequired='<%=customerSurvey.isAuthenticationRequired()%>';
                clientManager.isNewPage='TRUE';
                clientManager.maxCharsOnSubmit=<%=customerSurvey.getMaxCharsOnSubmit()%>;
                clientManager.originatingPage='';
                clientManager.sessionId='<%=customerSurvey.getCustomerSessionInstanceID()%>';
                clientManager.submitType='ReviewRequest'
                clientManager.successMessage='<%=StringEscapeUtils.escapeXml(customerSurvey.getSuccessMessage()+UserContext.getSuccessMessage())%>';
                clientManager.templateId='<%=customerSurvey.getSurveyTemplateInstanceID()%>';
                clientManager.userName='<%=StringEscapeUtils.escapeXml(UserContext.getUserName())%>';
                clientManager.webAppContextPath='<%=request.getContextPath()%>';
            }
            function customInitialization() {
            }
            
            var pageIds = [];
            <%
                if (customerSurvey.getLoadAllPages()) {
                    java.util.Iterator loadEvents = RequestPages.iterator();
                    while (loadEvents.hasNext()) {
                        com.kd.kineticSurvey.beans.CustomerSurveyReview cs = (com.kd.kineticSurvey.beans.CustomerSurveyReview) loadEvents.next();
            %>
                pageIds.push("<%=cs.getSanitizedPageId()%>");
            <%
                    }
                }
            %>
                var clientManager = KD.utils.ClientManager;
                var reviewObj = { clientManager: clientManager, loadAllPages: <%=customerSurvey.getLoadAllPages()%>, pageIds: pageIds };
                KD.utils.Action.addListener(window, "load", KD.utils.Review.init, reviewObj, true);
        </script>
        <%=customerSurvey.getCustomHeaderContent()%>
    </head>
    <body class="loadAllPages_<%=customerSurvey.getLoadAllPages()%>">
        <div id="reviewContent">
            <%
            String renderClass = new String();
            if (!customerSurvey.getLoadAllPages()) { %>
            <%= renderPageTabs(RequestPages, renderClass) %>
            <% } else { %>
            <%= renderPages(RequestPages, renderClass) %>
            <% } %>
            <input type="hidden" name="templateID" id= "templateID" value="<%=customerSurvey.getSurveyTemplateInstanceID()%>"/>
            <input type="hidden" name="pageID" id="pageID" value=""/>
        </div>
    </body>
</html>
<% } else { %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>Review Request</title>
    </head>
    <body>
        <div>This request could either not be found, or it did not have any valid content pages.</div>
    </body>
</html>
<% } %>
