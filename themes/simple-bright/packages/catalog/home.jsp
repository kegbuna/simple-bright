<%@page import="java.io.FileFilter" %>

<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>
<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>

<%@include file="framework/helpers/CatalogSearch.jspf"%>

<%-- Retrieve the Catalog --%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    Person user = Person.findByUsername(context, context.getUserName());
    // Preload the catalog child objects (such as Categories, Templates, etc) so
    // that they are available.  Preloading all of the related objects at once
    // is more efficient than loading them individually.
    catalog.preload(context);
    //loading in the broadcasts
    Broadcasts broadcasts = Broadcasts.findAvailable(context, context.getUserName());
    SubmissionConsole[] matchingTemplates  = SubmissionConsole.find(context, catalog, "'Submitter' = \"" + context.getUserName() +"\"", new String[]{"2"}, 0, 0, 1);


%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title>
            <%= bundle.getProperty("siteTitle")%> | Home
        </title>
        <!-- Page Stylesheets -->
       <!-- <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/package.css" type="text/css" /> -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/home.css" type="text/css" />
        <!-- need to include column display stuff TODO:: Separate out Search functions -->
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/package.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/catalog.js"></script>
	    <script type="text/javascript">
        $(document).ready(function (){

        });
	    </script>
    </head>
    <body id="home">
        <%@include file="../../common/interface/fragments/header.jspf" %>
        <div id="homeView" class="view-port">
            <section class="left-column">
                <h1 class="page-title">Online Service Desk</h1>
                <div class="entry-box">
                    <!--<h2 class="entry-box-title">Welcome, how can we help you?</h2>
                    <a href="<%=bundle.getProperty("incidentUrl")%>" class="incident-button">I have a problem!</a>
                    <a class="request-button">I need something new.</a>
                    <a></a>-->
                    <h4 class="entry-box-subtitle">Use the below buttons to get started!</h4>
                    <div>
                        <ul class="offering-list">
                            <li class="offering"><a class="incident-button offering-button" href="<%=bundle.getProperty("incidentUrl")%>"><i class="ticket-icon"></i>Report My Issue</a><p class="description">Experiencing IT downtime or another problem? Report it here.</p></li>
                            <li class="offering"><a class="request-button offering-button" href="<%=bundle.getProperty("appRequestUrl")%>"><i class="ticket-icon"></i>Clinical App Request</a><p class="description">Need access to clinical applications or reports? Ask us!</p></li>
                            <li class="offering"><a class="epic-button offering-button" href="<%=bundle.getProperty("epicRequestUrl")%>"><i class="ticket-icon"></i>Epic App Request</a><p class="description">Make all of your Epic related requests here.</p></li>
                        </ul>
                    </div>
                    <div>

                    </div>
                </div>
            </section>
            <aside class="right-column">
                <div class="info-box" id="AnnouncementsBox">
                    <div class="info-box-title">
                        <i class="fa fa-bullhorn"></i><h3>Announcements</h3>
                    </div>
                    <div class="info-box-content">
                <%  if (broadcasts.getLength() > 0)
                    {
                        for (int i=0; i<broadcasts.getLength(); i++)
                        {%>
                        <div class="info-box-item">
                            <div class="item-timestamp">
                                <%=((String)broadcasts.getStartDate(i).get("month")).substring(0, 3)%>
                                <%=broadcasts.getStartDate(i).get("day")%>
                            </div>
                            <div class="item-summary">
                                <a href="#" class=""><%=broadcasts.getFieldSubject(i)%></a>
                                <p class="hide item-message"><%=broadcasts.getFieldMessage(i)%></p>
                            </div>
                        </div>
                    <% }
                    }
                    else
                    {%>
                        <div class="info-box-item">
                            <h4>Nothing to show here</h4>
                        </div>
                    <% } %>
                    </div>
                </div>
                <div class="info-box" id="RecentRequestsBox">
                    <div class="info-box-title">
                        <i class="fa fa-clipboard"></i><a href="<%=bundle.getProperty("submissionsUrl")%>"><h3>Recently Submitted</h3></a>
                    </div>
                    <div class="info-box-content">
                        <%  if (matchingTemplates != null)
                        {
                            for (int i=0; i<matchingTemplates.length; i++)
                            {%>
                        <div class="info-box-item">
                            <div class="item-timestamp" style="margin-right: 35px;">
                                <%=matchingTemplates[i].getCreateDate()%>
                            </div>
                            <div class="item-summary">
                                <a href="<%=matchingTemplates[i].getReviewLink(bundle.applicationPath(), bundle.getProperty("reviewJsp"))%>"><%=matchingTemplates[i].getRequestDisplayName()%></a>
                            </div>
                        </div>
                        <% }
                        }
                        else
                        {%>
                        <div class="info-box-item">
                            Nothing to show here
                        </div>
                        <% } %>
                    </div>
                </div>
                <div class="info-box" id="YouShouldKnowBox">
                    <div class="info-box-title">
                        <i class="fa fa-lightbulb-o"></i><h3>You Should Know</h3>
                    </div>
                    <div class="info-box-content">
                        <%  //TODO:: Get these articles loading properly
                            if (false)
                        {
                            for (int i=0; i<matchingTemplates.length; i++)
                            {%>
                        <div class="info-box-item">
                            <div class="item-timestamp">
                                <%=matchingTemplates[i].getCreateDate()%>
                            </div>
                            <div class="item-summary">
                                <a><%=matchingTemplates[i].getRequestDisplayName()%></a>
                            </div>
                        </div>
                        <% }
                        }
                        else
                        {%>
                        <div class="info-box-item">
                            Nothing to show here
                        </div>
                        <% } %>
                    </div>
                </div>
            </aside>

        </div>
        <%@include file="../../common/interface/fragments/footer.jspf"%>
    </body>
</html>