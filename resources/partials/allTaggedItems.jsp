<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%-- Format a list of KS_SRV_SurveyTemplateAttrInst_join entries in boxes by Keyword including link to the template and title --%>
<% java.util.List resultsList=(java.util.List)request.getAttribute("resultsList");
if(resultsList != null){

    com.kd.arsHelpers.SimpleEntry entry=(com.kd.arsHelpers.SimpleEntry)resultsList.get(0); %>
      <div id="tagList_layer" class="standard_box fullTagBox">
        <div class="standard_box"><%= entry.getEntryFieldValue("700401930")%><strong><span class="tagLabel">Entries that match the selected tag</span></strong>
        <hr style="height:1px;"/>
          <%= entry.getEntryFieldValue("700401901")%></div>
        <%

 java.util.Iterator iter = resultsList.iterator();
 while(iter.hasNext()){
    entry=(com.kd.arsHelpers.SimpleEntry)iter.next();%>
    <p><a href="<%=entry.getEntryFieldValue("700002489")%>"><%= entry.getEntryFieldValue("700001000")%></a>
    <br /><%= entry.getEntryFieldValue("700001010")%></p>
    <%}%>
    </div>
<%} else{%>
<p>No results found</p>
<%} %>
