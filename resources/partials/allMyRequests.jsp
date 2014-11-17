<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%--Format a list KS_RQT_CustomerSurvey_Task_join entries into a request and related tasks --%>
<% java.util.List resultsList = (java.util.List) request.getAttribute("resultsList");
            if (resultsList != null) {
                com.kd.arsHelpers.SimpleEntry anEntry = (com.kd.arsHelpers.SimpleEntry) resultsList.get(0);
%>
<div class="allMyRequests standard_box"><b>My Service Items</b>
    <div class="allRequestsTable">
        <table width="98%" border="0" cellpadding="2" cellspacing="0" class="standard_table">
            <tr>
                <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">Date</div></th>
                <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">Name</div></th>
                <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">Status</div></th>
                <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">ID</div></th>
                <th bgcolor="#999999" scope="col" class="requestsHeader"><div align="left">More</div></th>
            </tr>
            <%
              String lastCustId = "";
              String thisReqId;
              String nextCustId = "";
              String oddEven = "odd";
              for (int i = 0; i < resultsList.size(); i++) {

                  com.kd.arsHelpers.SimpleEntry entry = (com.kd.arsHelpers.SimpleEntry) resultsList.get(i);
                  thisReqId = entry.getEntryFieldValue("536870913");
                  String idLink = thisReqId;
                  String approval = entry.getEntryFieldValue("700088475");

                  //Use the Originating ID-Display field if present.  Useful so approvals show the Request's request ID.
                  String origIdDisplay = entry.getEntryFieldValue("700088607");
                  if (origIdDisplay != null && origIdDisplay.length() > 0) {
                      idLink = origIdDisplay;
                  }
                  String status = entry.getEntryFieldValue("7");


                  /*Formatting for an approval row*/
                  if (((approval != null && approval.length() > 0) && (!status.equalsIgnoreCase("Completed"))) || (status != null && status.equalsIgnoreCase("In Progress"))) {
                      if (approval != null && approval.length() > 0) {
                          approval = " approvalRow";
                      }
                      idLink = "<a href='DisplayPage?csrv=" + java.net.URLEncoder.encode(entry.getEntryFieldValue("179"), "UTF-8") + "'>" + idLink + "</a>";
                  }
                  /*End approval formatting*/

                  if (i + 1 < resultsList.size()) {
                      nextCustId = ((com.kd.arsHelpers.SimpleEntry) resultsList.get(i + 1)).getEntryFieldValue("536870913");
                  } else {
                      nextCustId = "";
                  }

                  if (!lastCustId.equalsIgnoreCase(thisReqId)) {
                      /*Create New Customer Request Row */
                      String more = "";
            if (!entry.getEntryFieldValue("700000030").equals("")) {
                more = "<img class='imageElement moreIcon' onclick='catalogUtils.toggleDetail(\"row_" + thisReqId + "\", this);' alt='more' src='resources/catalogIcons/arrowRight.gif' style='margin:0px;padding:0px;cursor:pointer;'>";
            }%>

            <tr style="" id="row_<%=thisReqId%>" class="row_<%=oddEven%><%=approval%>">
                <td><%= entry.getEntryFieldValue("3")%></td>
                <td><%= entry.getEntryFieldValue("700001000")%></td>
                <td><%= entry.getEntryFieldValue("700002400")%></td>
                <td><%= idLink%></td>
                <td><%= more%></td>
            </tr>
            <% if (oddEven.equals("odd")) {
                      oddEven = "even";
                  } else {
                      oddEven = "odd";
                  }
              }
              /*Create the task info related to the customer request*/%>

            <%if (!thisReqId.equalsIgnoreCase(lastCustId)) {%>
            <tr  class="taskDetailsRow" style="display:none;">
                <td colspan="5">
                    <div class="standard_box" id="tasksFor_<%=thisReqId%>">
                        <%}

      /*Task Details Begin*/%>
                        <span><b>Task: </b><%= entry.getEntryFieldValue("700000030")%></span><br />
                        <span><b>Last Update:</b><%= entry.getEntryFieldValue("700066406")%></span>
                        <span><b>Status: </b><%= entry.getEntryFieldValue("536870932")%></span><br />
                        <%if (entry.getEntryFieldValue("700088102") != null && entry.getEntryFieldValue("700088102").length() > 0) {%>
                        <span><b>Approver: </b><%= entry.getEntryFieldValue("700088101")%> <%= entry.getEntryFieldValue("700088102")%> </span><br/>
                        <%}%>
                        <span><b>Notes: </b><%= entry.getEntryFieldValue("700066400")%></span><br/>
                        <hr />
                        <%/*Task Details End*/

      if (!thisReqId.equalsIgnoreCase(nextCustId)) {%>
                    </div>
                </td>
            </tr>
            <%}%>

            <%lastCustId = entry.getEntryFieldValue("536870913");
    }%>
        </table>
    </div>
    <p style="font-size:1em;"><a href="Javascript:location.href=location.href;">Back to Service Catalog</a></p>
</div>
<%} else {%>
<div class="myServiceItems standard_box" id ="noItemsFound"><b>You have no open service items or approvals</b></div>
<%}%>
