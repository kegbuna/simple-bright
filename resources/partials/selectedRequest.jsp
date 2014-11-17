<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%
    java.util.List resultsList = (java.util.List) request.getAttribute("resultsList");
    if (resultsList != null) {
        java.text.SimpleDateFormat simpleDateFormat = new java.text.SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
        java.text.DateFormat dateFormat = java.text.DateFormat.getDateTimeInstance(java.text.DateFormat.MEDIUM, java.text.DateFormat.MEDIUM, request.getLocale());

        // month name abbreviations
        String[] monthAbbrs = { "Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec" };

        // define field values for the customer request
        java.util.Hashtable<String,String> constants = new java.util.Hashtable<String,String>();
        constants.put("Version", "700071008");
        constants.put("UseKineticTask", "700073501");
        constants.put("CreatedAt", "3");
        constants.put("CustomerSurveyInstanceId", "179");
        constants.put("CustomerSurveyId", "536870913");
        constants.put("OrigIdDisplay", "700088607");
        constants.put("SubmitType", "700088475");
        constants.put("Status", "7");
        constants.put("TemplateName", "700001000");
        constants.put("ValidationStatus", "700002400");
        constants.put("NotesForCustomer", "600003021");
        constants.put("RequestStatus", "700089541");

        // get the first entry to obtain the base request information
        com.kd.arsHelpers.SimpleEntry baseEntry = (com.kd.arsHelpers.SimpleEntry) resultsList.get(0);
        java.util.Date createdAtDate = simpleDateFormat.parse(baseEntry.getEntryFieldValue(constants.get("CreatedAt")), new java.text.ParsePosition(0));
        java.util.Calendar createdAt = java.util.Calendar.getInstance();
        createdAt.setTime(createdAtDate);
%>
<div class="selReqWrapper">
<div class="selReq">
    <div class="selReqDetails">
        <div class="date">
            <div class="month"><%= monthAbbrs[createdAt.get(java.util.Calendar.MONTH)] %></div>
            <div class="day"><%= createdAt.get(java.util.Calendar.DATE) %></div>
            <div class="year"><%= createdAt.get(java.util.Calendar.YEAR) %></div>
        </div>
        <div class="head">
            <div>
                <span class="right"><%= baseEntry.getEntryFieldValue(constants.get("CustomerSurveyId"))%></span>
                <span><b><%= baseEntry.getEntryFieldValue(constants.get("TemplateName"))%></b></span>
            </div>
        </div>
        <div class="clear"></div>
        <div class="body">
            <div><b>Request ID: </b><%= baseEntry.getEntryFieldValue(constants.get("CustomerSurveyId"))%></div>
            <div><b>Requested At: </b><%= dateFormat.format(createdAtDate) %></div>
            <div><b>Status: </b><%=baseEntry.getEntryFieldValue(constants.get("ValidationStatus"))%></div>
            <% if (baseEntry.getEntryFieldValue(constants.get("NotesForCustomer"))!=null && baseEntry.getEntryFieldValue(constants.get("NotesForCustomer")).length()>0) {%>
            <div><b>Notes: </b><%= baseEntry.getEntryFieldValue(constants.get("NotesForCustomer"))%></div>
            <%}%>
        </div>
    </div>
<%
    // define field values for the correct task form
    java.util.Hashtable<String,java.util.ArrayList<String[]>> taskMsgs = null;
    String version = baseEntry.getEntryFieldValue(constants.get("Version"));
    String useKineticTask = baseEntry.getEntryFieldValue(constants.get("UseKineticTask"));

    if (useKineticTask == null || useKineticTask.trim().length() == 0) {
        // field mappings for CustomerSurvey_RQT_Task Join
        constants.put("TaskRequestId", "536870930");
        constants.put("TaskName", "700000030");
        constants.put("TaskNotes", "700066400");
        constants.put("TaskStatus", "536870932");
        constants.put("TaskUpdatedAt", "700066406");
        constants.put("ApproverLastName", "700088102");
        constants.put("ApproverFirstName", "700088101");
    } else {
        // field mappings for CustomerSurvey_TSK_Instance Join
        constants.put("TaskName", "700000810");
        constants.put("TaskNotes", "536870930");
        constants.put("TaskStatus", "536870931");
        constants.put("TaskUpdatedAt", "536870929");
        constants.put("ApproverLastName", "");
        constants.put("ApproverFirstName", "");
        constants.put("Visible","700000914");
        constants.put("TaskRequestId", "536870940");
        constants.put("TaskInstanceId", "536870921");
        constants.put("TaskMsgInstanceId", "536870936");
        constants.put("TaskMessage", "700066400");
        constants.put("TaskMessageDate", "536870939");

        // create a hashtable of task messages
        taskMsgs = new java.util.Hashtable<String,java.util.ArrayList<String[]>>();
        String taskId = null;
        String tempId = null;
        java.util.ArrayList<String[]> messages = null;
        com.kd.arsHelpers.SimpleEntry entry = null;
        for (int i = 0; i < resultsList.size(); i++) {
            entry = (com.kd.arsHelpers.SimpleEntry) resultsList.get(i);
            String taskMsg = entry.getEntryFieldValue(constants.get("TaskMessage"));
            if (taskMsg != null && taskMsg.length() > 0) {
                tempId = entry.getEntryFieldValue(constants.get("TaskInstanceId"));
                // create a new arraylist to hold messages for the new task
                if (!tempId.equals(taskId)) {
                    if (taskId != null && messages != null) {
                        messages.trimToSize();
                        if (messages.size() > 0) {
                            // add the previous task messages to the taskMsgs Hashtable
                            taskMsgs.put(taskId, messages);
                        }
                    }
                    taskId = tempId;
                    messages = new java.util.ArrayList<String[]>();
                }
                // store the task message as a String array: 0 = message date, 1 = message text
                String[] messageObj = new String[2];
                java.util.Date msgDate = simpleDateFormat.parse(entry.getEntryFieldValue(constants.get("TaskMessageDate")), new java.text.ParsePosition(0));
                messageObj[0] = dateFormat.format(msgDate);
                messageObj[1] = taskMsg;
                messages.add(messageObj);
            }
        }

        // add the last task messages to the taskMsgs Hashtable
        if (taskId != null && messages != null) {
            messages.trimToSize();
            if (messages.size() > 0) {
                taskMsgs.put(taskId, messages);
            }
        }
    }
%>
    <div class="selReqtasks">
<%
    // iterate over all the entries to display task details
    com.kd.arsHelpers.SimpleEntry taskEntry = null;
    String taskInstanceId = null;
    String taskId = null;
    String tempId = null;
    for (int i = 0; i < resultsList.size(); i++) {
        taskEntry = (com.kd.arsHelpers.SimpleEntry) resultsList.get(i);
        tempId = taskEntry.getEntryFieldValue(constants.get("TaskRequestId"));

        // check if this task is visible on the portal
        String visible = "Yes";
        if (constants.containsKey("Visible")) {
            visible = taskEntry.getEntryFieldValue(constants.get("Visible"));
            // if constants contains the Visible property, then it also has TaskInstanceId
            taskInstanceId = taskEntry.getEntryFieldValue(constants.get("TaskInstanceId"));
        }

        if (visible != null && visible.equalsIgnoreCase("Yes") &&
                tempId != null && tempId.trim().length() > 0 && !tempId.equals(taskId)){
            taskId = tempId;
            java.util.Date taskDate = simpleDateFormat.parse(taskEntry.getEntryFieldValue(constants.get("TaskUpdatedAt")), new java.text.ParsePosition(0));
            java.util.Calendar taskCal = java.util.Calendar.getInstance();
            taskCal.setTime(taskDate);

            // begin a new task
%>
            <div class="task">
                <div class="date">
                    <div class="month"><%= monthAbbrs[taskCal.get(java.util.Calendar.MONTH)] %></div>
                    <div class="day"><%= taskCal.get(java.util.Calendar.DATE) %></div>
                    <div class="year"><%= taskCal.get(java.util.Calendar.YEAR) %></div>
                </div>
                <div class="head">
                    <div>Task:&nbsp;&nbsp;<b><%= taskEntry.getEntryFieldValue(constants.get("TaskName"))%></b></div>
                </div>
                <div class="body">
                    <div class="content">
                        <div><b>Description: </b><%= taskEntry.getEntryFieldValue(constants.get("TaskNotes"))%></div>
                        <div><b>Updated At: </b><%= dateFormat.format(taskDate)%></div>
                        <div><b>Task Status: </b><%= taskEntry.getEntryFieldValue(constants.get("TaskStatus"))%></div>
                        <%if (taskEntry.getEntryFieldValue(constants.get("ApproverLastName"))!=null && taskEntry.getEntryFieldValue(constants.get("ApproverLastName")).length()>0) {%>
                        <div><b>Approver: </b><%= taskEntry.getEntryFieldValue(constants.get("ApproverFirstName"))%> <%= taskEntry.getEntryFieldValue(constants.get("ApproverLastName"))%> </div>
                        <%}%>
                    </div>
                    <%if (taskInstanceId != null && taskMsgs != null && taskMsgs.containsKey(taskInstanceId)) {%>
                    <div class="taskMsgs">
                        <%
                        java.util.ArrayList<String[]> msgs = taskMsgs.get(taskInstanceId);
                        java.util.Iterator msgIter = msgs.iterator();
                        while (msgIter.hasNext()) {
                            String[] msg = (String[])msgIter.next();%>
                        <div class="taskMsg">
                            <div class="taskMsgDate"><%=msg[0]%></div>
                            <div class="taskMsgText"><%=msg[1]%></div>
                        </div>
                        <%}%>
                    </div>
                    <%}%>
                </div>
            </div>
<%
        }
    }
%>
    </div>
</div>
</div>
<%
    } else {
%>
<div class="selReqWrapper">
    <div class="selReq" style="text-align:center;"><b style="line-height:300px;">The requested item could not be found.</b></div>
</div>
<%
    }
%>
