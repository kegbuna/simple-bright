<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>

<%-- Retrieve the Catalog --%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc) so
    // that they are available.  Preloading all of the related objects at once
    // is more efficient than loading them individually.
    catalog.preload(context);
    Person user = Person.findByUsername(context, context.getUserName());
    String submissionType = request.getParameter("type");
    String submissionStatus = request.getParameter("status");
    // Determine if the type exists and is set and is a real type
    if(submissionType == null || !submissionType.equals("requests") && !submissionType.equals("approvals")) {
        submissionType = "requests";
    }
    Integer open = openRequests;
    Integer closed = closedRequests;
    Integer all = allRequests;
    String pageTitle = "Requests";
    String pageSubTitle = "Ticket History";
    String statusButtonClass = "btn btn-success";
    if (submissionType.equals("approvals"))
    {
        pageTitle = "Approvals";
        pageSubTitle = "Approval History";
        open = openApprovals;
        closed = closedApprovals;
    }
    if (submissionStatus == null)
    {
        submissionStatus = "Open";
    }


%>
<!DOCTYPE html>
<html>
    <head>
        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title>
            <%= bundle.getProperty("siteTitle")%>&nbsp;|
            <% if(submissionType.equals("requests")) {%>
                My&nbsp;Requests&nbsp;(<%= totalRequests%>)
            <% } else if(submissionType.equals("approvals")) {%>
                My&nbsp;Approvals&nbsp;(<%= totalApprovals%>)
            <%}%>
        </title>
        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/jquery.qtip.css" type="text/css" />
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/footable.core.css" type="text/css" />
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/package.css" type="text/css" />
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/submissionsBBB.css" type="text/css" />
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/footable.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/moment.min.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/jquery.qtip.min.js"></script>
        <!-- need to include column display stuff TODO:: Move datatable functions out -->
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/submissionsDataTable.js"></script>
        <script type="text/javascript">
        </script>
    </head>
    <body>
        <%@include file="../../common/interface/fragments/header.jspf"%>
        <div class="view-port">
            <%@include file="../../common/interface/fragments/navigationSlide.jspf"%>
            <div class="content-slide" data-target="div.navigation-slide">
                <div class="container">
                    <h2 class="page-title"><%=pageSubTitle%></h2>
                    <div id="filterBar" class="col-xs-12">
                        <div class="col-xs-12">
                            <div class="col-sm-4 filter-field">
                                <span style="font-size: 1.5em; font-weight: 600;">Status: </span>
                                <select id="statusFilter" class="form-control">
                                    <option value="All">All</option>
                                    <option value="Open" selected>Open</option>
                                    <option value="Closed">Closed</option>
                                    <% if (!pageTitle.equals("Approvals"))
                                    {%>
                                    <option value="Draft">Draft</option>
                                    <%}%>
                                </select>
                            </div>
                            <!--<div class="col-sm-1">
                                <span style="font-size: 1.5em; font-weight: 600;">Store #: </span>
                            </div>-->
                            <% if (user.getClientType().equals("Store"))
                            {%>
                            <div class="col-md-4 filter-field">
                                <span style="font-size: 1.5em; font-weight: 600;">Store #: </span>
                                <input name="Store Number" id="storeNumber" value="<%=context.getUserName()%>" class="form-control" type="number" placeholder="Store #">
                            </div>
                            <!--<div class="col-sm-1">
                                <span style="font-size: 1.5em; font-weight: 600;">Ticket #: </span>
                            </div>-->
                            <div class="col-md-4 filter-field">
                                <span style="font-size: 1.5em; font-weight: 600;">Ticket #: </span>
                                <input name="Ticket Number" id="ticketNumber" class="form-control" type="text" placeholder="Ticket #">
                            </div>
                            <%}
                            else
                            {%>
                            <div class="col-md-4 filter-field">
                                <span style="font-size: 1.5em; font-weight: 600;">Ticket #: </span>
                                <input name="Ticket Number" id="ticketNumber" class="form-control" type="text" placeholder="Ticket #">
                            </div>
                            <%}%>
                            <span id="filterButtonHolder" class="">
                                    <button class="btn btn-primary" >Search <i class="fa fa-search"></i></button>
                            </span>
                        </div>
                        <small class="text-danger col-xs-12" style="margin-left: 15px;">Use the above filters to search tickets. By default, tickets for your store will show.</small>
                    </div>
                    <table id="submissionTable" width="100%" class="table table-condensed table-responsive table-bordered table-striped">
                        <thead>
                            <tr>
                                <td>Ticket ID</td>
                                <td>Ticket Summary</td>
                                <td>Requested For</td>
                                <td>Submit Date</td>
                                <td>Status</td>
                            </tr>
                        </thead>
                    </table>
                </div>
                <%@include file="../../common/interface/fragments/footer.jspf"%>
            </div>
        </div>
    </body>
</html>