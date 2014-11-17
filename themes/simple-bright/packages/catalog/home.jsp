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
    <body>
        <%@include file="../../common/interface/fragments/header.jspf" %>
        <div id="homeView" class="view-port">

        </div>
        <%@include file="../../common/interface/fragments/footer.jspf"%>
    </body>
</html>