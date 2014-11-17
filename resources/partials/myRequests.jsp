<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%--Format a list of KS_SRV_CustomerSurvey entries in a table  --%>
<% java.util.List resultsList=(java.util.List)request.getAttribute("resultsList");
if(resultsList != null){
%>
   <table width="100%" border="0" cellpadding="2" cellspacing="0" class="standard_table">
      <tr>
        <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">Date</div></th>
        <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">Name</div></th>
        <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">Status</div></th>
        <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">ID</div></th>
      </tr>
  <% java.util.Iterator iter = resultsList.iterator();
  String oddEven="odd";
  while(iter.hasNext()){
    com.kd.arsHelpers.SimpleEntry entry=(com.kd.arsHelpers.SimpleEntry)iter.next(); %>
    <tr class="row_<%=oddEven%>">
      <td><%= entry.getEntryFieldValue("3")%></td>
      <td><%= entry.getEntryFieldValue("700001000")%></td>
      <td><%= entry.getEntryFieldValue("700002400")%></td>
      <td><a href="#"><%= entry.getEntryFieldValue("536870913")%></a></td>
    </tr>
    <% if(oddEven.equals("odd")){oddEven="even";}else{oddEven="odd";}
  }%>
    </table>
<%} else{%>
<p>No results found</p>
<%} %>
