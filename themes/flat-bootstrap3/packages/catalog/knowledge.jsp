<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>
<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>

<%@include file="framework/helpers/CatalogSearch.jspf"%>
<%-- Retrieve the Catalog --%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc) so
    // that they are available.  Preloading all of the related objects at once
    // is more efficient than loading them individually.
    catalog.preload(context);
    Category currentCategory = catalog.getCategoryByName(request.getParameter("category"));
    // Get map of description templates
    Map<String, String> templateDescriptions = new java.util.HashMap<String, String>();
    if (currentCategory != null) {
        templateDescriptions = DescriptionHelper.getTemplateDescriptionMap(context, catalog);
    }
    String responseMessage;
    List<Template> templates = new ArrayList();
    org.json.JSONArray articles = new org.json.JSONArray();
    org.json.JSONObject articleData = null;
    Template[] matchingTemplates = templates.toArray(new Template[templates.size()]);
    try
    {
        // Retrieve the search terms from the request parameters.
        String mustHave = "%";
        if (request.getParameter("q") != null)
        {
            mustHave = request.getParameter("q");
        }

        String mayHave = "";
        String mustNotHave = null;

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
    }
    if (matchingTemplates.length == 0 && articles.length() == 0) {
        responseMessage = "No results were found.";
    }

    String currentSearch = request.getParameter("q");
    if (currentSearch == null)
    {
        currentSearch = "";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title>
            <%= bundle.getProperty("siteTitle")%> | Knowledge Base
        </title>
        <!-- Package Stylesheets -->
        <!--<link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/package.css" type="text/css" />-->
        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/category.css" type="text/css" />
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/search.css" type="text/css" />
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/knowledge.css" type="text/css" />
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/package.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/category.js"></script>
        <!-- need to include column display stuff TODO:: Move knowledge functions out -->
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>

        <script type="text/javascript">
            var initialKData = <%=articles%>;
            var articleData;
            //initial sort is alpha as opposed to weight (hits * relevance)
            initialKData.sort(function(a, b)
            {
                return a['Article Title'] > b['Article Title'];
            });

            $(document).ready(function ()
            {
                $ksr = $('#knowledgeSearchResults');
                $ksr.html('');
                for (var index in initialKData)
                {
                    articleData = initialKData[index];
                    var html = '<li class="border-top clearfix list-group-item"><div class="template-icon">';
                    html +='<a class="" href="' + BUNDLE.config.rkmDisplayUrl + '&type=' + articleData['Source'].split(' ').join('') + "&articleId=" + articleData['Article ID'] + '">';
                    html +='<span class="fa fa-stack fa-lg icon"><i class="fa fa-stack-2x fa-lightbulb-o"></i></span></div><div class="template-content"><h3 style="margin-top:20px; margin-bottom: 5px;">';
                    html += articleData["Article Title"] + '</h3></a><p>';
                    html += articleData["Summary"] + '</p></div></li>';
                    $ksr.append(html);
                }
                $('#knowledgeSearchButton').on("click",function (e)
                {
                    searchKnowledge();
                });

                $('#knowledgeSearchInput').on('keydown', function(e)
                {
                    //console.log(e.keyCode);
                    if (e.keyCode == 13)
                    {
                        searchKnowledge();
                    }
                });

                function searchKnowledge()
                {
                    var currentUrl = Column.Helpers.Url.updateQueryStringParameter(window.location.href,"q", $('#knowledgeSearchInput').val());
                    window.history.replaceState(null, null, currentUrl);
                    var url = "DisplayPage?name=BedBath-KS";
                    url += "&mustHave=" + $('#knowledgeSearchInput').val();
                    $ksr = $('#knowledgeSearchResults');
                    $ksr.html('<div class="col-xs-12" style="text-align: center"><i class="fa fa-spinner fa-5x load-mask fa-spin"></i></div>');
                    $.ajax(
                    {
                        url: url,
                        method: 'GET',
                        success: function(data)
                        {
                            data = JSON.parse(data);
                            var articleData;
                            //console.log(data);
                            $ksr.html('');
                            if (data[0].hasOwnProperty('error'))
                            {
                                $ksr.html('<div class="col-xs-12" style="text-align: center; font-size: 2em">' + data[0]['error'] + '</div>');
                                //console.log('it does have it');
                            }
                            else
                            {

                                for (var index in data)
                                {
                                    articleData = data[index];
                                    var html = '<li class="border-top clearfix list-group-item"><div class="template-icon">';
                                    html +='<a class="" href="' + BUNDLE.config.rkmDisplayUrl + '&type=' + articleData['Source'].split(' ').join('') + "&articleId=" + articleData['Article ID'] + '">';
                                    html +='<span class="fa fa-stack fa-lg icon"><i class="fa fa-stack-2x fa-lightbulb-o"></i></span></div><div class="template-content"><h3 style="margin-top:20px; margin-bottom: 5px;">';
                                    html += articleData["Article Title"] + '</h3></a><p>';
                                    html += articleData["Summary"] + '</p></div></li>';
                                    $('#knowledgeSearchResults').append(html);
                                }
                            }

                        },
                        error: function(data)
                        {
                            alert('Something went wrong with the search. Notify your administrator.');
                        }
                    });
                }
            });
        </script>
    </head>
    <body>
        <div class="view-port">
            <%@include file="../../common/interface/fragments/navigationSlide.jspf"%>
            <div class="content-slide" data-target="div.navigation-slide">
                <%@include file="../../common/interface/fragments/header.jspf"%>
                <div class="pointer-events container">
                    <div class="category-header row col-sm-12 col-md-12">
                        <h2>Knowledge Base</h2>
                        <div class="col-md-2 category-icon text-center">
                            <div class="icon">
                                <i class="fa fa-5x fa-inverse fa-lightbulb-o"></i>
                            </div>
                        </div>
                        <div class="col-md-9 category-description">
                            <p>Welcome to the Knowledge Base. Use the search below to find an article related to your problem or question.</p>
                        </div>
                    </div>
                    <div id ="knowledgeSearchGroup" style="margin: 0 20px 0 0;" class="input-group col-sm-11 animated fadeInDown">
                        <input id ="knowledgeSearchInput" type="text" value="<%=currentSearch%>" class="form-control" placeholder="Search the Knowledge Base...">
                        <span class="input-group-btn">
                            <button id="knowledgeSearchButton" class="btn btn-default" type="button"><i class="fa fa-search"></i></button>
                        </span>
                    </div>
                    <ul id="knowledgeSearchResults" class="templates list-group col-xs-12">
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
                                        </span>
                                </div>
                            <div class="template-content">
                                <h3 style="margin-top:20px; margin-bottom: 5px;">
                                    <%= articleData.get("Article Title")%>
                                </h3>
                                <p>
                                    <%= articleData.get("Summary")%>
                                </p>
                            </div>
                        </li>
                        <% }%>
                    </ul>
                </div>
                <%@include file="../../common/interface/fragments/footer.jspf"%>
            </div>
        </div>
    </body>
</html>