
<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>

<%-- 
    Include the CatalogSearch fragment that defines the CatalogSearch class that
    will be used to retrieve and filter the catalog data.
--%>
<%@include file="framework/helpers/CatalogSearch.jspf"%>

<%-- Retrieve the Catalog --%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc) so
    // that they are available.  Preloading all of the related objects at once
    // is more efficient than loading them individually.
    catalog.preload(context);

    // Get map of description templates
    Map<String, String> templateDescriptions = DescriptionHelper.getTemplateDescriptionMap(context, catalog);

    // Define variables
    String[] querySegments;
    String responseMessage = null;

    org.json.JSONArray articles = new org.json.JSONArray();
    org.json.JSONObject articleData = null;

    List<Template> templates = new ArrayList();
    Template[] matchingTemplates = templates.toArray(new Template[templates.size()]);
    Pattern combinedPattern = Pattern.compile("");
    // Retrieve the searchableAttribute property
    String searchableAttributeString = bundle.getProperty("searchableAttributes");
    // Initialize the searchable attributes array
    String[] searchableAttributes = new String[0];
    if(request.getParameter("q") != null) {
        // Build the array of querySegments (query string separated by a space)
        querySegments = request.getParameter("q").split(" ");
        // Display an error message if there are 0 querySegments or > 10 querySegments
        if (querySegments.length == 0 || querySegments[0].length() == 0) {
            responseMessage = "Please enter a search term.";
        } else if (querySegments.length > 10) {
            responseMessage = "Search is limited to 10 search terms.";
        } else {
            // Default the searchableAttribute property to "Keyword" if it wasn't specified
            if (searchableAttributeString == null) {searchableAttributeString = "Keyword";}
            // If the searchableAttributeString is not empty
            if (!searchableAttributeString.equals("")) {
                searchableAttributes = searchableAttributeString.split("\\s*,\\s*");
            }
            CatalogSearch catalogSearch = new CatalogSearch(context, catalog.getName(), querySegments);
            //Category[] matchingCategories = catalogSearch.getMatchingCategories();
            matchingTemplates = catalogSearch.getMatchingTemplates(searchableAttributes);
            combinedPattern = catalogSearch.getCombinedPattern();

           /* try
            {
                // Retrieve the search terms from the request parameters.
                String mustHave = request.getParameter("q");
                String mayHave = request.getParameter("mayHave");
                String mustNotHave = request.getParameter("mustNotHave");

                // Perform the multi form search and write the result to the out
                // stream.
                MultiFormSearch mfs = new MultiFormSearch(mustHave, mayHave, mustNotHave, systemUser);
                String jsonData = mfs.search(serverUser);
                articles = new org.json.JSONArray(jsonData);

                //out.println(jsonData);
            } catch (Exception e) {
                // Write the exception to the kslog and re-throw it
                //logger.error("Exception in RKMQuery.json.jsp", e);
                throw e;
            }*/
            if (matchingTemplates.length == 0 && articles.length() == 0) {
                responseMessage = "No results were found.";
            }
        }
    } else {
        responseMessage = "Please Start Your Search";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <!-- need to include column display stuff TODO:: Separate out Search functions -->
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
        <title>
            <%= bundle.getProperty("siteTitle") %>&nbsp;|&nbsp;Search Results
            <% if(request.getParameter("q") != null && !request.getParameter("q").equals("")) {%>
                for&nbsp;'<%= request.getParameter("q") %>'
            <% }%>
        </title>
        <!-- Page Stylesheets -->
        <!--<link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/package.css" type="text/css" />-->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/search.css" type="text/css" />
    </head>
    <body>
    <%@include file="../../common/interface/fragments/header.jspf"%>
        <div class="view-port">
            <% if(responseMessage != null) {%>
                <header class="container">
                    <h2>
                        <%= responseMessage %>
                    </h2>
                    <hr class="soften">
                </header>
            <% } else {%>
                <header class="container">
                    <h2>
                        Results found for '<%= request.getParameter("q")%>'.
                    </h2>
                    <hr class="soften">
                </header>
                <section class="container">
                    <ul class="templates list-group">
                        <% for (int i = 0; i < matchingTemplates.length; i++) {%>
                            <li class="border-top clearfix list-group-item">
                                <a class="" href="<%= matchingTemplates[i].getAnonymousUrl()%>">
                                <div class="template-icon">
                                        <span class="fa fa-stack fa-lg icon">
                                            <i class="fa fa-stack-2x fa-file-text-o"></i>
                                            <i class="fa fa-stack-1x fa-check text-primary"></i>
                                        </span>

                                </div>
                                <div class="template-content">
                                    <h3>
                                        <%= matchingTemplates[i].getName()%>
                                    </h3>
                                    <p>
                                        <%= matchingTemplates[i].getDescription()%>
                                    </p>
                                    <% if (templateDescriptions.get(matchingTemplates[i].getId()) != null ) { %>
                                        <a class="read-more" href="<%= bundle.applicationPath()%>DisplayPage?srv=<%= templateDescriptions.get(matchingTemplates[i].getId()) %>">
                                            Read More
                                        </a>
                                    <% }%>
                                    <ul class="keywords unstyled clearfix hidden-xs">
                                        <% for (String attributeName : searchableAttributes) {%>
                                            <% if (matchingTemplates[i].hasTemplateAttribute(attributeName)) {%>
                                                <li class="keyword">
                                                    <div class="keyword-name">
                                                        <strong>
                                                            <%= attributeName %>(s):
                                                        </strong>
                                                    </div>
                                                    <ul class="keyword-values unstyled">
                                                        <% for (String attributeValue : matchingTemplates[i].getTemplateAttributeValues(attributeName)) {%>
                                                            <li class="keyword-value">
                                                                <%= attributeValue%>
                                                            </li>
                                                        <% }%>
                                                    </ul>
                                                </li>
                                            <% }%>
                                        <% }%>
                                    </ul>
                                </div>
                                <div class="pull-right">
                                    <div class="hidden-xs">
                                        <!-- Load description attributes config stored in package config -->
                                        <% for (String attributeDescriptionName : attributeDescriptionNames) {%>
                                            <% if (matchingTemplates[i].hasTemplateAttribute(attributeDescriptionName)) { %>
                                                <p>
                                                    <strong><%= attributeDescriptionName%>:</strong> <%= matchingTemplates[i].getTemplateAttributeValue(attributeDescriptionName) %>
                                                </p>
                                            <% }%>
                                        <%}%>
                                    </div>
                                </div>
                                </a>
                            </li>
                        <% }%>
                    </ul>
                    <ul class="templates list-group">
                        <% for (int i = 0; i < articles.length(); i++) {
                            articleData = (org.json.JSONObject)articles.get(i);
                            String articleId = (String)articleData.get("Article ID");
                            String articleSource = (String)articleData.get("Source");

                        %>
                        <li class="border-top clearfix list-group-item">
                            <a class="" href="<%= bundle.getProperty("rkmDisplayUrl") + "&type=" + articleSource.replaceAll("\\s", "") + "&articleId=" + articleId %>">
                                <div class="template-icon">
                                    <span class="fa fa-stack fa-lg icon">
                                        <i class="fa fa-stack-2x fa-lightbulb-o"></i>
                                        <!--<i class="fa fa-stack-1x fa-check text-primary"></i>-->
                                    </span>
                                </div>
                                <div class="template-content">
                                    <h3>
                                        <%= articleData.get("Article Title")%>
                                    </h3>
                                    <p>
                                        <%= articleData.get("Summary")%>
                                    </p>
                                </div>
                            </a>
                        </li>
                        <% }%>
                    </ul>
                </section>
                <% }%>
            <%@include file="../../common/interface/fragments/footer.jspf"%>
        </div>
    </body>
</html>