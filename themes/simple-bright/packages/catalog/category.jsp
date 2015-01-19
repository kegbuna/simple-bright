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
    Category currentCategory = catalog.getCategoryByName(request.getParameter("category"));
    Category[] allCats = catalog.getAllCategories(context);
    // Get map of description templates
    Map<String, String> templateDescriptions = new java.util.HashMap<String, String>();
    if (currentCategory != null) {
        templateDescriptions = DescriptionHelper.getTemplateDescriptionMap(context, catalog);
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title>
            <%= bundle.getProperty("siteTitle")%>
            <% if(currentCategory != null) {%>
                |&nbsp;<%= currentCategory.getName()%>
            <% }%>
        </title>
        <!-- Package Stylesheets -->
        <!--<link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/package.css" type="text/css" />-->
        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/category.css" type="text/css" />
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/package.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/category.js"></script>
    </head>
    <body>
        <%@include file="../../common/interface/fragments/header.jspf"%>
        <div class="view-port">
        <%
            for (Category currentCat : allCats)
            {
        %>
            <br><%=currentCat.getFullName()%>
            <% Template[] currentTemplates = currentCat.getTemplates();
                for (Template currentTemplate : currentTemplates)
                {
            %>
                <br><%=currentTemplate.getName()%>
            <%
                }
            %>
        <%
            }
        %>
        </div>
        <%@include file="../../common/interface/fragments/footer.jspf"%>
    </body>
</html>