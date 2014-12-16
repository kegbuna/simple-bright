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
                <div class="entry-box">
                    <!--<h2 class="entry-box-title">Welcome, how can we help you?</h2>
                    <a href="<%=bundle.getProperty("incidentUrl")%>" class="incident-button">I have a problem!</a>
                    <a class="request-button">I need something new.</a>
                    <a></a>-->
                    <h3>Welcome to Lahey Health's Self Help Center.</h3>
                    <h3>This is where you will find ways to help yourself with your IT needs.</h3>
                    <div>
                        <ul>
                            <li><p>Do you have a computer or application issue? Report it <a href="<%=bundle.getProperty("incidentUrl")%>">HERE</a></p></li>
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
                                <a><%=broadcasts.getFieldSubject(i)%></a>
                            </div>
                        </div>
                    <% }
                    } %>
                    </div>
                </div>
                <div class="info-box" id="RecentRequestsBox">
                    <div class="info-box-title">
                        <i class="fa fa-clipboard"></i><h3>Recently Submitted</h3>
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
                                <a><%=broadcasts.getFieldSubject(i)%></a>
                            </div>
                        </div>
                        <% }
                        } %>
                    </div>
                </div>
            </aside>

        </div>
        <%@include file="../../common/interface/fragments/footer.jspf"%>
    </body>
</html>