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
    Template thisTemplate = catalog.getTemplateById(customerRequest.getTemplateId());
    SimpleEntry[] pages = thisTemplate.getPages(context, thisTemplate.getId());
    SimpleEntry previousPage = pages[0];
    SimpleEntry nextPage = pages[0];

    for (int i=1; i<pages.length; i++)
    {
        if (pages[i].getEntryFieldValue("700001203").equals(customerRequest.getPageName()))
        {
            previousPage = pages[i-1];
            //make sure we have a next page
            if (i < pages.length-1)
            {
                nextPage = pages[i+1];
            }
            break;
        }
    }
    String previousID = previousPage.getEntryFieldValue("700002303");
    String previousName = previousPage.getEntryFieldValue("700001203");
    String nextName = nextPage.getEntryFieldValue("700001203");
    String nextID = nextPage.getEntryFieldValue("700002303");

    // Let's see if we can establish an array of question values, maybe we can then leverage them later in javascript
    SimpleEntry[] questions = ArsBase.find(context, "KS_SRV_CustomerSurveyQuestionAnswerJoin", "'CustomerSurveyInstanceId' = \"" + customerRequest.getCsrv() + "\"", new String[]{"700000003", "700002832"});
    org.json.simple.JSONObject jsonQuestions = new org.json.simple.JSONObject();
    for (SimpleEntry question : questions)
    {
        jsonQuestions.put(question.getEntryFieldValue("700000003"), question.getEntryFieldValue("700002832"));
    }


%>
<!DOCTYPE html>
<html>
    <head>
        <%-- Include the bundle common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title>
            <%= bundle.getProperty("siteTitle")%>&nbsp;|&nbsp;<%= customerRequest.getTemplateName()%>
        </title>
        <script type="text/javascript">
            var previousPageID = "<%=previousID%>";
            var previousPageName = "<%=previousName%>";
            var nextPageID = "<%=nextID%>";
            var nextPageName = "<%=nextName%>";
            var answeredQuestions = <%=jsonQuestions.toJSONString()%>;
        </script>
        <%-- Include the application head content. --%>
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
        <%@include file="../../core/interface/fragments/displayHeadContent.jspf"%>

        <!-- Package Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/displayPackage.css" type="text/css" />
        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/display.css" type="text/css" />
        <!-- Utilities -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/searchableDropdown.js"></script>
        <!-- Package Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/package.js"></script>
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/display.js"></script>

        <script type="text/javascript">
        </script>
        <%-- Include the form head content, including attached css/javascript files and custom header content --%>
        <%@include file="../../core/interface/fragments/formHeadContent.jspf"%>
    </head>
    <body>
        <%@include file="../../common/interface/fragments/header.jspf"%>
        <div class="view-port">
            <%@include file="../../common/interface/fragments/navigationSlide.jspf"%>
            <div class="content-slide" data-target="div.navigation-slide">
                <div class="pointer-events">
                    <header class="container">
                        <h2 class="request-title text-center">
                            <%= customerRequest.getTemplateName()%>
                        </h2>
                        <div id="pageIndicator" class="request-page-list">
                            <%
                                String pageClass = "completed";
                                boolean passedCurrentPage = false;
                            for (int i=0; i<pages.length;i++)
                            {
                                if (pages[i].getEntryFieldValue("700001203").equals(customerRequest.getPageName()))
                                {
                                    pageClass = "active";
                                    passedCurrentPage = true;
                                }
                                else if (!passedCurrentPage)
                                {
                                    pageClass = "completed";
                                }
                                else
                                {
                                    pageClass="";
                                }
                            %>
                            <div class="request-page <%=pageClass%>" data-pageId="<%=pages[i].getEntryFieldValue("179")%>">
                                <h5><%=pages[i].getEntryFieldValue("700001203")%></h5>
                            </div>
                            <%}%>
                        </div>
                        <hr class="soften" style="display:none;">
                    </header>
                    <section class="container">
                        <%@include file="../../core/interface/fragments/displayBodyContent.jspf"%>
                    </section>
                </div>
                <%@include file="../../common/interface/fragments/footer.jspf"%>
            </div>
        </div>
    </body>
</html>