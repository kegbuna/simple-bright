<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%-- Format a list of KS_RQT_SurveyTemplateAttrInst_Category_join entries in boxes by category including link to the template and title --%>
<% java.util.List resultsList=(java.util.List)request.getAttribute("resultsList");
com.kd.kineticSurvey.beans.UserContext userContext = (com.kd.kineticSurvey.beans.UserContext) request.getSession().getAttribute("UserContext");
if(resultsList != null){

    com.kd.arsHelpers.SimpleEntry entry=(com.kd.arsHelpers.SimpleEntry)resultsList.get(0);
    String category=entry.getEntryFieldValue("700401900");%>
      <div id="<%=category%>_layer" class="standard_box fullCategoryBox">
        <div class="fullCategoryHeader standard_box"><%= entry.getEntryFieldValue("700401930")%><strong><span style="margin-left:10px;" class="fullCategoryLabel"><%=category%></span></strong>
        <hr style="height:1px;"/>
         <div class="fullCategoryDescription"> <%= entry.getEntryFieldValue("700401901")%></div></div>
        <%
 java.util.Iterator iter = resultsList.iterator();
 while(iter.hasNext()){
    entry=(com.kd.arsHelpers.SimpleEntry)iter.next();
    //Only show if Public when not authenticated
    String assigneeGroup = entry.getEntryFieldValue("112");
    if (!userContext.isAuthenticated() && !assigneeGroup.equals("0;")){
      continue;
    }%>
    <p><a href="<%=entry.getEntryFieldValue("700002489")%>"><%= entry.getEntryFieldValue("700001000")%></a>
    <br /><%= entry.getEntryFieldValue("700001010")%></p>
    <%}%>
    </div>
    <p style="font-size:.8em;"><a href="Javascript:catalogUtils.resetCatalogItems();">Back to Service Catalog</a></p>
<%} else{%>
<p>No results found</p>
<%} %>
