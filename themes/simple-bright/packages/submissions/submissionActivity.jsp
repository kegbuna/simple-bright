<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8" %>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf" %>

<%-- Retrieve the Catalog --%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc) so
    // that they are available.  Preloading all of the related objects at once
    // is more efficient than loading them individually.
    catalog.preload(context);

    // Define vairables we are working with
    String templateId = null;
    SubmissionConsole submission = null;
    Template submissionTemplate = null;
    CycleHelper zebraCycle = new CycleHelper(new String[]{"odd", "even"});
    if (context == null)
    {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else
    {
        templateId = customerSurvey.getSurveyTemplateInstanceID();
        submission = SubmissionConsole.findByInstanceId(context, catalog, request.getParameter("id"));
        submissionTemplate = submission.getTemplate();
        if (submissionTemplate == null)
        {
            throw new Exception("Either the template no longer exists or bundle not configured to correct catalog");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <%-- Include the common content. --%>
    <%@include file="../../common/interface/fragments/head.jspf" %>
    <title>
        <%= bundle.getProperty("siteTitle")%>&nbsp;|&nbsp;<%= submission.getOriginatingForm()%>&nbsp;|&nbsp;Submission&nbsp;Activity
    </title>
    <!-- need to include column display stuff TODO:: Separate out Search functions -->
    <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
    <!-- Page Stylesheets -->
    <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/submissionActivity.css" type="text/css"/>
    <!-- Page Javascript -->
    <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/moment.min.js"></script>
    <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/submissionActivity.js"></script>
</head>
<body>
<div class="view-port">
    <%@include file="../../common/interface/fragments/navigationSlide.jspf" %>
    <div class="content-slide" data-target="div.navigation-slide">
        <%@include file="../../common/interface/fragments/header.jspf" %>
        <div class="pointer-events">
            <header class="container col-md-12 col-lg-11" style="float: none;">
                <h2 class="page-title submission-title">Ticket Details (<%= submission.getRequestDisplayName()%>)</h2>
                <div class="request-status">
                    <h3>
                        <%= submission.getValidationStatus()%>
                    </h3>
                </div>
                <div class="border-top border-left border-right clearfix">

                    <div class="request-information">
                        <div class="left">
                            <div class="wrap">
                                <div class="submitted-label">
                                    Submitted On:&nbsp;
                                </div>
                                <div class="submitted-value">
                                    <%= DateHelper.formatDate(submission.getCompletedDate(), request.getLocale())%>
                                </div>
                            </div>
                            <% if (submission.getRequestStatus().equals("Closed"))
                            {%>
                            <div class="closed-label">
                                Closed On:&nbsp;
                            </div>
                            <div class="closed-value">
                                <%= DateHelper.formatDate(submission.getRequestClosedDate(), request.getLocale())%>
                            </div>
                            <%}%>
                            <div class="wrap">
                                <div class="request-id-label">
                                    Ticket ID#:&nbsp;
                                </div>
                                <div class="request-id-value">
                                    <%= submission.getOriginatingRequestId()%>
                                </div>
                            </div>
                            <div class="wrap">
                                <div class="requested-for-label">
                                    Requested For:&nbsp;
                                </div>
                                <div class="requested-for-value">
                                    <%=submission.getFirstName()%>&nbsp;<%=submission.getLastName()%>
                                </div>
                            </div>
                        </div>
                        <div class="left middle border-left hide">
                            <h3>
                                Service Requested
                            </h3>

                            <div class="content-wrap">
                                <% if (submissionTemplate.hasTemplateAttribute("ServiceItemImage"))
                                {%>
                                <div class="image">
                                    <img width="40"
                                         src="<%= ServiceItemImageHelper.buildImageSource(submissionTemplate.getTemplateAttributeValue("ServiceItemImage"), bundle.getProperty("serviceItemImagePath"))%>">
                                </div>
                                <%}%>
                                <div class="originating-name">
                                    <%= submission.getOriginatingForm()%>
                                </div>
                            </div>
                        </div>
                        <div class="right">
                            <% if (!submission.getType().equals(bundle.getProperty("autoCreatedRequestType")))
                            {%>
                            <a class="view-submitted-form templateButton btn btn-primary" target="_self"
                               href="<%= bundle.applicationPath()%>ReviewRequest?csrv=<%=submission.getId()%>&excludeByName=Review%20Page&reviewPage=<%= bundle.getProperty("reviewJsp")%>">
                                View Submitted Form
                            </a>
                            <%}%>
                        </div>
                    </div>
                </div>
            </header>
            <section class="container col-md-12" style="float: none;">
                <div class="border clearfix">
                    <div class="submission-activity">
                        <!-- Start Tasks -->
                        <ul class="list-group activities col-xs-10">
                            <% if (submission.getValidationStatus().equals("Cancelled"))
                            {%>
                            <!-- Start display cancelled request notes -->
                            <li class="list-group-item cancelled">
                                <header class="clearfix">
                                    <h4>
                                        Request Cancelled
                                    </h4>
                                </header>
                                <hr class="soften"/>
                                <%= submission.getNotesForCustomer()%>
                            </li>
                            <!-- End display cancelled request notes -->
                            <%} else
                            {%>
                            <!--<h2 style="color: #384A9C; margin-bottom: 0;">System Tickets:</h2>-->
                            <%}%>
                <% for (String treeName : submission.getTaskTreeExecutions(context).keySet())
                {

                %>
                    <% for (Task task : submission.getTaskTreeExecutions(context).get(treeName))
                    {%>
                            <%
                                //out.println(task.getName() + " " + task.getResult("Work Order ID") + " " + task.getDefName());
                            // Define ticket related data
                            String incidentId = null;
                            Incident incident = null;
                            String changeId = null;
                            Change change = null;
                            String workOrderId = null;
                            WorkOrder workOrder = null;
                            int worklogCount = 0;
                            BridgeList<IncidentWorkLog> iWorkLogs = IncidentWorkLog.findByIncidentId(context, templateId, incidentId);
                            BridgeList<ChangeWorkLog> cWorkLogs = ChangeWorkLog.findByChangeId(context, templateId, changeId);
                            BridgeList<WorkOrderWorkLog> wWorkLogs = WorkOrderWorkLog.findByWorkOrderId(context, templateId, workOrderId);

                            // Define and Get ticket records if they actually exist for current task
                            if (task.getDefName().equals(bundle.getProperty("incidentHandler")) || task.getDefName().equals("incident"))
                            {
                                incidentId = task.getResult("Incident Number");
                                incident = Incident.findById(context, templateId, incidentId);
                                iWorkLogs = IncidentWorkLog.findByIncidentId(context, templateId, incidentId);
                                worklogCount = iWorkLogs.size();
                            %>
                            <div class="ticket-header">
                                <div class="ticket-title">
                                    <h3 class="ticket-id"><b><%//=incident.getId()%> <%=incident.getSummary()%></b> <span class="ticket-status"><%=incident.getStatus() %></span></h3>
                                    <p><b>Assigned To: </b><%=incident.getAsgrp()%></p>
                                    <div class="ticket-worklogs-header">
                                        <div class="ticket-worklogs-controls">
                                            <span class="btn btn-primary toggle-worklogs" data-ticket="<%=incident.getId()%>"><span class="toggle-text">View</span> Comments: <b><%=worklogCount%></b> <i class="fa fa-lg fa-file-text-o"></i></span>  <span style="display:none;" class="btn btn-success new-worklog" data-ticket="<%=incident.getId()%>">Add New <i class="fa fa-lg fa-plus"></i></span>
                                        </div>
                                    </div>
                                    <div id="WLPanel-<%=incident.getId()%>" class="ticket-worklogs-new col-xs-12 col-md-4 hide animated">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <h3 class="panel-title"><b>Add Comment</b></h3>
                                            </div>
                                            <form>
                                                <div class="panel-body">
                                                    <div class="">
                                                        <textarea type="text" class="form-control worklog-text" rows="3"></textarea>
                                                    </div>

                                                    <div class="">
                                                        <button class="btn btn-success worklog-submit " value="Submit">Submit</button>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                            } else if (task.getDefName().equals(bundle.getProperty("changeHandler")))
                            {
                                changeId = task.getResult("Change Number");
                                change = Change.findById(context, templateId, changeId);
                                cWorkLogs = ChangeWorkLog.findByChangeId(context, templateId, changeId);
                                worklogCount = cWorkLogs.size();
                            %>
                            <div class="ticket-header">
                                <div lass="ticket-title">
                                    <h3 class="ticket-id">Change - <%=change.getId()%></h3>
                                    <h4 class="ticket-status">Status - <%=change.getStatus() %></h4>
                                </div>
                            </div>
                            <%
                            } else if (task.getDefName().equals(bundle.getProperty("workOrderHandler")))
                            {
                                //out.print(task.getName());
                                workOrderId = task.getResult("Work Order ID");
                                workOrder = WorkOrder.findById(context, templateId, workOrderId);
                                wWorkLogs = WorkOrderWorkLog.findByWorkOrderId(context, templateId, workOrderId);
                                if (wWorkLogs != null)
                                {
                                    worklogCount = wWorkLogs.size();
                                }
                                else
                                {
                                    worklogCount = 0;
                                }

                            %>
                            <div class="ticket-header">
                                <div class="ticket-title">
                                    <h3 class="ticket-id"><b><%//=incident.getId()%> <%=workOrder.getSummary()%></b> <span class="ticket-status"><%=workOrder.getStatus() %></span></h3>
                                    <!-- <h3 class="ticket-summary">Summary - <b><%=workOrder.getSummary()%></b></h3> -->
                                    <p><b>Assigned To: </b><%=workOrder.getAssignedGroup()%></p>
                                    <div class="ticket-worklogs-header">
                                        <div class="ticket-worklogs-controls">
                                            <span class="btn btn-primary toggle-worklogs" data-ticket="<%=workOrder.getId()%>"><span class="toggle-text">View</span> Comments: <b><%=worklogCount%></b> <i class="fa fa-lg fa-file-text-o"></i></span>  <%if (thisUser.getClientType() != "Store") {%><span class="btn btn-success new-worklog" data-ticket="<%=workOrder.getId()%>">Add New <i class="fa fa-lg fa-plus"></i></span><%}%>
                                        </div>
                                    </div>
                                    <div id="WLPanel-<%=workOrder.getId()%>" data-form="WOI:WorkInfo" data-field="1000002607" class="ticket-worklogs-new col-xs-12 col-md-4 hide animated">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <h3 class="panel-title"><b>Add Comment</b></h3>
                                            </div>
                                            <div class="panel-body">
                                                <div class="">
                                                    <textarea type="text" class="form-control worklog-text" data-field="1000000151" rows="3"></textarea>
                                                </div>
                                                <div class="">
                                                    <div class="btn btn-success worklog-submit" data-ticket="<%=workOrder.getId()%>">Submit</div>
                                                    <div class="btn btn-danger worklog-cancel" data-ticket="<%=workOrder.getId()%>">Cancel</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                            }
                            String ticketId = null;

                            if (incident != null)
                            {
                                ticketId = incident.getId();

                            } else if (change != null)
                            {
                                ticketId = change.getId();

                            } else if (workOrder != null)
                            {
                                ticketId = workOrder.getId();

                            }

                        %>
                        <div id="Worklogs-<%=ticketId%>" class="ticket-worklogs animated col-xs-11 co-md-8 hide">
                            <!-- Start Worklogs -->
                            <%@include file="interface/fragments/worklogs.jspf" %>
                            <!-- End Worklogs -->
                        </div>
                <%  }%>
            <%  }%>
                        </ul>
                    </div>
                </div>
            </section>
        </div>
        <section class="container">
            <%@include file="../../core/interface/fragments/displayBodyContent.jspf"%>
        </section>
        <%@include file="../../common/interface/fragments/footer.jspf" %>
    </div>
</div>
</body>
</html>
