<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<jsp:useBean id="ReviewPage" scope="request" class="com.kd.kineticSurvey.beans.CustomerSurveyReview"/>

<%=ReviewPage.getQuestions()%>
