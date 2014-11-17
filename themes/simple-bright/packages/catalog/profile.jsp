<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc) so
    // that they are available.  Preloading all of the related objects at once
    // is more efficient than loading them individually.
    catalog.preload(context);
    Person profileUser = Person.findByUsername(context, context.getUserName());
%>
<!DOCTYPE html>
<html>
    <head>
        <%-- Include the bundle common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title>
            <%= bundle.getProperty("siteTitle")%>&nbsp;|&nbsp;<%= customerRequest.getTemplateName()%>
        </title>
        <%-- Include the application head content. --%>
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
        <%@include file="../../core/interface/fragments/displayHeadContent.jspf"%>

        <!-- Package Stylesheets -->

        <!-- Page Stylesheets -->

        <!-- Utilities -->

        <!-- Package Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/package.js"></script>
        <!-- Page Javascript -->


        <script type="text/javascript">
        </script>
        <%-- Include the form head content, including attached css/javascript files and custom header content --%>
        <%@include file="../../core/interface/fragments/formHeadContent.jspf"%>
        <style type="text/css">
            .templateButton
            {
                display: none;
            }
        </style>
    </head>
    <body>
        <%@include file="../../common/interface/fragments/header.jspf"%>
        <div class="view-port">
            <%@include file="../../common/interface/fragments/navigationSlide.jspf"%>
            <div class="content-slide" data-target="div.navigation-slide">
                <div class="pointer-events">
                    <header class="container">
                        <h2 class="request-title">
                            <%= customerRequest.getTemplateName()%>
                        </h2>
                        <hr class="soften" style="display:none;">
                    </header>
                    <section class="container">
                        <h4><%=profileUser.getFullName()%></h4>
                        <h4><%=profileUser.getPhoneNumber()%></h4>
                        <h4><%=profileUser.getEmail()%></h4>
                        <h4><%=profileUser.getDepartment()%></h4>
                        <%@include file="../../core/interface/fragments/displayBodyContent.jspf"%>
                    </section>
                </div>
                <%@include file="../../common/interface/fragments/footer.jspf"%>
            </div>
        </div>

    </body>
</html>