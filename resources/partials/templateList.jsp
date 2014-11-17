<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%-- Format a list of KS_SRV_SurveyTemplate entries in an unordered list including link to the template and title --%>
<% java.util.List resultsList=(java.util.List)request.getAttribute("resultsList");%>
<img alt="close" src="resources/catalogIcons/closeX.gif" style="float:right; cursor:pointer;" onclick="javascript:this.parentNode.className='search_noItems'">
<% if(resultsList != null){
%>
<ul class="searchReturn">
  <% java.util.Iterator iter = resultsList.iterator();
  while(iter.hasNext()){
    com.kd.arsHelpers.SimpleEntry entry=(com.kd.arsHelpers.SimpleEntry)iter.next();
    entry.getEntryFieldValue("700002489");
    %>
    <li><a href="<%=entry.getEntryFieldValue("700002489")%>" title="<%= com.kd.kineticSurvey.impl.SurveyUtilities.fixForHTML(entry.getEntryFieldValue("700001010"))%>"><%= entry.getEntryFieldValue("700001000")%></a></li>
    <%}%>
    </ul>
<%} else{%>
<p><b>No results found</b></p>
<%} %>
