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
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/package.css" type="text/css" />
        <link rel="stylesheet" href="//cdn.datatables.net/1.10.4/css/jquery.dataTables.min.css" type="text/css" />
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/moment.min.js"></script>
        <!-- need to include column display stuff TODO:: Move datatable functions out -->
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
        <script type="text/javascript" src="//cdn.datatables.net/1.10.4/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/submissionsDataTable.js"></script>
        <script type="text/javascript">
        </script>
    </head>
    <body>
        <%@include file="../../common/interface/fragments/header.jspf"%>
        <div class="view-port">
            <div class="container">
                <h3 class="page-title"><%=pageSubTitle%></h3>
                <table id="submissionTable" width="100%" class="table table-condensed table-responsive table-bordered table-striped">
                </table>
            </div>
            <%@include file="../../common/interface/fragments/footer.jspf"%>
        </div>
    </body>
</html>