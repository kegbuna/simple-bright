<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title><%= bundle.getProperty("companyName") + " " + bundle.getProperty("catalogName")%></title>

        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>

        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/rkm.css" type="text/css" />

        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/rkm.js"></script>
    </head>

    <body>
        <div id="bodyContainer" class="view-port">
            <%@include file="../../common/interface/fragments/header.jspf"%>
            <div id="contentBody">
                <div class="header">
                    <div class="search">
                        <form id="searchTerms">
                            <input type="search" name="mustHave" id="mustHave" value="" />
                            <input type="submit" id="searchButton" value="Search" />
                            <img class="hidden spinner" src="<%= bundle.bundlePath()%>common/resources/images/spinner_00427E_FFFFFF.gif">
                        </form>
                    </div>
                    <div class="clear"></div>
                </div>
                <div id="messages"></div>
                <div id="results"></div>
            </div>
            <%@include file="../../common/interface/fragments/footer.jspf"%>
        </div>
    </body>
</html> 