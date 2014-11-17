<%-- This page is used for the Session Check Filter.  Typically it returns nothing just a success code --%>
<%@page contentType="text/javascript"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
