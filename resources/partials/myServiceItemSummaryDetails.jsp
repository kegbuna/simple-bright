<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%--Format a list of KS_SRV_CustomerSurvey entries in a table  --%>
<% java.util.List resultsList=(java.util.List)request.getAttribute("resultsList");
if(resultsList != null){
    String partial = "selectedRequests";
%>
   <table width="100%" border="0" cellpadding="2" cellspacing="0" class="serviceItemStatistics">
  <% com.kd.arsHelpers.SimpleEntry entry=(com.kd.arsHelpers.SimpleEntry)resultsList.get(0); %>
    <tr class="serviceItemStatistic">
      <td width="24%" class="statItem"> My Service Items</td>
      <%String openCount = (String)entry.getEntryFieldValue("700001001");
      	if (openCount != null && openCount.trim().length() >0 && !openCount.trim().equals("0")) { %>
	      <td width="19%" class="statItem"> <span style="display:block;" class='summaryItem' onclick='catalogUtils.showSelectedRequests(true, false, this, "<%=partial%>")'>In Progress(<%= entry.getEntryFieldValue("700001001")%>)</span></td>
      <%}%>
      <%String closedCount = (String)entry.getEntryFieldValue("700001002");
      	if (closedCount != null && closedCount.trim().length() >0 && !closedCount.trim().equals("0")) { %>
	      <td width="19%" class="statItem"> <span style="display:block;" class='summaryItem' onclick='catalogUtils.showSelectedRequests(false, false, this, "<%=partial%>")'>Closed(<%= entry.getEntryFieldValue("700001002")%>)</span></td>
      <%}%>
      <%String forAppCount = (String)entry.getEntryFieldValue("700001003");
      	if (forAppCount != null && forAppCount.trim().length() >0 && !forAppCount.trim().equals("0")) { %>
      		<td width="19%" class="statItem"> <span style="display:block;" class='summaryItem' onclick='catalogUtils.showSelectedRequests(true, true, this, "<%=partial%>")'>Needing approval(<%= entry.getEntryFieldValue("700001003")%>)</span></td>
      <%}%>
      <%String appCount = (String)entry.getEntryFieldValue("700001005");
      	if (appCount != null && appCount.trim().length() >0 && !appCount.trim().equals("0")) { %>
	      <td width="19%" class="statItem"> <span style="display:block;" class='summaryItem' onclick='catalogUtils.showSelectedRequests(false, true, this, "<%=partial%>")'>Completed Approval(<%= entry.getEntryFieldValue("700001005")%>)</span></td>
      <%}%>
    </tr>
    </table>
<%} %>
