<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%--Format a Sithco Person entry for display as a partial --%>
<% java.util.List resultsList=(java.util.List)request.getAttribute("resultsList");
if(resultsList != null){
com.kd.arsHelpers.SimpleEntry entry=(com.kd.arsHelpers.SimpleEntry)resultsList.get(0);%>
<b>Name: </b><br/>
<%=entry.getEntryFieldValue("240000004")%> <%=entry.getEntryFieldValue("240000003")%><br/>
<b>Email: </b><br/>
<%=entry.getEntryFieldValue("260000002")%><br/>
<b>Phone: </b><br/>
<%=entry.getEntryFieldValue("240000002")%><br/>
<b>Department:</b><br/>
<%=entry.getEntryFieldValue("200000006")%> <br/>
<%}else{%>
<p>You were not found in the Sithco Person form. </p>
<p>
<a href="DisplayPage?name=sithcoPerson">Update My Record</a>
</p>
<%}%>
