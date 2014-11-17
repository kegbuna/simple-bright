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

    //getting recent requests
    String[] sortFields = new String[1];
    sortFields[0] = "3";
    String qualification = "'Submitter' = \"" + context.getUserName()+ "\" AND 'Submit Type' = $NULL$ AND 'CustomerSurveyStatus' = \"Completed\"";
    SubmissionConsole[] submissions = SubmissionConsole.find(context, catalog, qualification, sortFields, 5, 0, 2);
    SubmissionConsole currentSubmission;

    // Get map of description templates
    Map<String, String> templateDescriptions = DescriptionHelper.getTemplateDescriptionMap(context, catalog);
    // Get popular requests

    List<String> globalTopTemplates = SubmissionStatisticsHelper.getMostCommonTemplateNames(systemContext, new String[] {customerRequest.getCatalogName()}, templateTypeFilterTopSubmissions, 20);
	Category[] categories = catalog.getRootCategories(context);
	ArrayList colors = new ArrayList();

    String[] querySegments = new String[0];

    org.json.JSONArray articles = new org.json.JSONArray();
    org.json.JSONObject articleData = null;
    CatalogSearch catalogSearch = new CatalogSearch(context, catalog.getName(), querySegments);
    List<Template> templates = new ArrayList();

    Template[] matchingTemplates = templates.toArray(new Template[templates.size()]);

    String responseMessage = null;
    String searchableAttributeString = bundle.getProperty("searchableAttributes");
    // Initialize the searchable attributes array
    String[] searchableAttributes = new String[0];
    Pattern combinedPattern = Pattern.compile("");

    matchingTemplates = catalogSearch.getMatchingTemplates(searchableAttributes);
    combinedPattern = catalogSearch.getCombinedPattern();

    /*try
    {
        // Retrieve the search terms from the request parameters.
        String mustHave = "";
        String mayHave = "%";
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
    }
    if (matchingTemplates.length == 0 && articles.length() == 0) {
        responseMessage = "No results were found.";
    }
*/
    //This will replace the Report a Problem text based on client type
    String reportAProblem, RAPTitle, RAPLink;
    if (user.getClientType().equals("Store"))
    {
        reportAProblem = "Use this button to create a new ticket to order replacement equipment for the approved categories. <p>All other issues need to be called in to the Support Center at 1-888-4-HELP-97.</p>";
        RAPTitle = "Create a Self Service Ticket";
        RAPLink = "DisplayPage?name=StoreEquipmentRequest";
    }
    else
    {
        RAPTitle = "Report an Incident";
        reportAProblem = "Click here to report any non-critical issue. Critical issues should be called into the Support Center by calling 908-855-4314.";
        RAPLink = "DisplayPage?name=ReportAnIncident";
    }

    //some on screen text values
    String seeMore = "more ";


    File images = new File("webapps/catalog/resources/images/carousel");
    File carouselConfig = new File("webapps/catalog/resources/images/carousel/carousel.json");
    BufferedReader configReader = new BufferedReader(new FileReader(carouselConfig));
    String configString = "";
    String readLine;
    while ((readLine = configReader.readLine()) != null)
    {
        configString += readLine;
    }
    org.json.JSONObject configJson = new org.json.JSONObject(configString);
    org.json.JSONObject configLinks = configJson.getJSONObject("links");

    final class ImageFileFilter implements FileFilter
    {
        private final String[] okFileExtensions =
                new String[] {"jpg", "png", "gif"};

        public boolean accept(File file)
        {
            for (String extension : okFileExtensions)
            {
                if (file.getName().toLowerCase().endsWith(extension))
                {
                    return true;
                }
            }
            return false;
        }
    }


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
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/jquery.ba-hashchange.min.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/ColKineticHelper.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/BBBHome.js"></script>
	    <script type="text/javascript">
        $(document).ready(function (){

        });
	    </script>
    </head>
    <body>
        <%@include file="../../common/interface/fragments/header.jspf" %>
        <div id="homeView" class="view-port">

            <div class="pageColumn col-lg-8 col-md-8 col-sm-12">
                <div id="homeCarousel">
                <% int imageCount = 0; String indicatorClass = "active"; String imageLink = "";
                for (File currentFile: images.listFiles(new ImageFileFilter()))
                {
                    //TODO:: come up with a way to remove the link completely, probably by including href attrib in the string assignment
                    if (configLinks.has(currentFile.getName()))
                        imageLink = "href=\"" + (String)configLinks.get(currentFile.getName()) + "\"";
                    else
                        imageLink = "";
                %>
                    <a <%=imageLink%>><img class="homePageImage animated <% if (imageCount !=0){out.println("hide");} %>" src="<%=bundle.applicationPath()%>/resources/images/carousel/<%=currentFile.getName()%>"></a>
                <% imageCount++;
                }%>
                </div>
                <div class="carouselPages">
                    <div class="carouselPageLinks clearfix">
                        <% for (int i=0; i<imageCount; i++)
                        {
                            if (i > 0)
                            {
                                indicatorClass = "";
                            }
                        %>
                            <a href="#" class="carousel-ticker <%=indicatorClass%>"><i data-index="<%=i%>" class="fa fa-circle carousel-icon "></i></a>
                        <%}%>
                    </div>
                </div>
                <script type="text/javascript">
                    $(document).ready(function()
                    {
                        var carousel = $('#homeCarousel');
                        var cImages = carousel.find('img');
                        var cIndexes = $('.carouselPages').find('.carousel-ticker');
                        //console.log(cIndexes);
                        var currentImage = 0;
                        var previousImage = 0;
                        if (cImages.length < 2)
                        {
                            cIndexes.parent().hide();
                            carousel.css('margin-bottom', '20px');
                        }
                        else
                        {
                            repeat(currentImage);
                        }
                        function repeat(index)
                        {
                            index++;
                            if (index == cImages.length)
                            {
                                index=0;
                            }
                            setTimeout(function ()
                            {
                                currentImage = index;
                                changeImage();
                                repeat(index);
                                //console.log(index);
                            }, 15000);
                        }
                        function changeImage(index)
                        {
                            if (typeof index != "undefined")
                            {
                                currentImage = index;
                            }
                            //console.log(previousImage);
                            $(cImages[previousImage])
                                    .removeClass('fadeInRight')
                                    .addClass('fadeOutLeft');
                            $(cIndexes[previousImage]).removeClass('active');
                            //console.log($(cIndexes[previousImage]));
                            setTimeout(function()
                            {
                                $(cImages[previousImage]).addClass('hide');
                                $(cImages[currentImage])
                                        .removeClass('hide fadeOutLeft')
                                        .addClass('fadeInRight');
                                previousImage = currentImage;
                                $(cIndexes[currentImage]).addClass('active');
                            },750);
                        }

                        cIndexes.on('click', function(e)
                        {
                            e.preventDefault();
                            changeImage($(this).index());
                        });
                    });
                </script>

                <div id ="searchGroup" class="input-group col-sm-12 pull-right animated fadeInDown">
                    <input type="text" class="form-control" placeholder="How may we help you?">
                    <span class="input-group-btn">
                        <button class="btn btn-default" type="button"><i class="fa fa-2x fa-search"></i></button>
                    </span>
                </div>
                <div class=" col-sm-12 holder rap">
                    <div class="col-sm-12" title="">
                        <a  class="tile-link" href="<%=RAPLink%>">
                            <div class="">
                                <div class="tile-header">
                                    <div class="tile-icon ">
                                        <i class="fa fa-wrench fa-2x text-primary"></i>
                                    </div>
                                    <div class="tile-title">
                                        <%=RAPTitle%>
                                    </div>
                                </div>
                                <div class="tile-content">
                                    <p><%=reportAProblem %></p>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class=" col-sm-12 holder">
                    <% Category currentCat;

                    if (!user.getClientType().equals("Store"))
                    {
                        for (int x=0; x<categories.length; x++)
                        {
                        currentCat = categories[x];
                        %>
                    <div class="col-md-6 col-xs-12 category" title="<%=currentCat.getDescription()%>">
                        <a  class="tile-link" href="DisplayPage?name=Flat-Category&category=<%=currentCat.getFullName()%>" >
                            <div class="tile-box">
                                <div class="tile-icon">
                                    <i class="fa fa-<%=currentCat.getFullName().replaceAll("\\s+", "")%> fa-2x fa-inverse" style="color: <% //(String)currentColors.remove(0)%>"></i>
                                </div>
                                <div class="tile-content">
                                    <p class="tile-title"><%=currentCat.getName()%></p>
                                    <!--<%=currentCat.getDescription()%>-->
                                </div>
                            </div>
                        </a>
                    </div>
                    <% } %>
                    <div class="col-md-6 col-xs-12 category" title="Knowledge Articles">
                        <a  class="tile-link" href="DisplayPage?name=Flat-KnowledgePage" >
                            <div class="tile-box">
                                <div class="tile-icon">
                                    <i class="fa fa-lightbulb-o fa-2x fa-inverse" style="color: <% //(String)currentColors.remove(0)%>"></i>
                                </div>
                                <div class="tile-content">
                                    <p class="tile-title">Knowledge Articles</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <%}
                    else
                    {%>
                    <div class="col-md-6 col-xs-12 category" title="Store Knowledge Articles">
                        <a  class="tile-link" href="DisplayPage?name=Flat-KnowledgePage" >
                            <div class="tile-box">
                                <div class="tile-icon">
                                    <i class="fa fa-lightbulb-o fa-2x fa-inverse" style="color: <% //(String)currentColors.remove(0)%>"></i>
                                </div>
                                <div class="tile-content">
                                    <p class="tile-title">Store Knowledge Articles</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6 col-xs-12 category" title="Ticket Look Up">
                        <a  class="tile-link" href="DisplayPage?name=Flat-Submissions&type=requests" >
                            <div class="tile-box">
                                <div class="tile-icon">
                                    <i class="fa fa-search fa-2x fa-inverse" style="color: <% //(String)currentColors.remove(0)%>"></i>
                                </div>
                                <div class="tile-content">
                                    <p class="tile-title">Ticket Look Up</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <%}%>
                </div>
            </div>
            <!-- Start of the Right Column -->
            <div class="pageColumn col-lg-4 col-md-4 col-sm-12 pull-right animated fadeInRight">
                <div id="systemStatusHolder" class="rightContentBox">
                    <h4 class="elementLabel">System Status</h4>
                <% if (broadcasts.getLength() > 0)
                   { %>
                    <ul id="Broadcasts" class="list-group animated">
                    <%  String broadcastClass = "text-success";
                        for (int i=0; i<broadcasts.getLength(); i++)
                        {
                    %>
                        <a href="#" class="broadcast-link">
                            <li class="list-group-item">
                                <i class="fa <%=broadcasts.getClass(i)%> fa-li fa-circle"></i><%=broadcasts.getFieldSubject(i)%>
                                <div data-index="<%=i%>" class="broadcast-message animated hide">
                                    <div class="broadcast-header ">
                                        <span class="broadcast-close">
                                            <i class="fa fa-times-circle fa-lg"></i>
                                        </span>
                                    </div>
                                    <div class="broadcast-content">
                                        <p><b><%=broadcasts.getFieldSubject(i)%></b></p>
                                        <p>Priority: <b><%=broadcasts.getFieldPriority(i)%></b></p>
                                        <p><%=broadcasts.getFieldMessage(i)%></p>
                                    </div>
                                </div>
                            </li>
                        </a>
                        <%}
                    %>
                    </ul>
                   <%}
                   else
                   {%>
                   <p>There are no available broadcasts at this time.</p>
                   <%}%>
                </div>
                <% if (!user.getClientType().equals("Store"))
                { %>
                <div id="topKnowHolder" class="rightContentBox animated fadeInRight">
                    <h4 class="knowledgeSectionTitle elementLabel">Top Knowledge Articles</h4>
                    <% if (matchingTemplates.length > 0)
                    {%>
                    <ul class="list-group">
                        <% for (int i=0; i< articles.length() && i<5; i++)
                        {
                            articleData = (org.json.JSONObject)articles.get(i);
                            String articleId = (String)articleData.get("Article ID");
                            String articleSource = (String)articleData.get("Source");

                        %>
                        <li class="list-group-item"><a href="<%= bundle.getProperty("rkmDisplayUrl") + "&type=" + articleSource.replaceAll("\\s", "") + "&articleId=" + articleId %>"><i class="fa fa-lightbulb-o fa-li"></i><span class="reqLabel"><%= articleData.get("Article Title")%></span></a></li>
                        <%}%>
                    </ul>
                    <%}%>
                    <div class="sideLink"><a href="<%=bundle.getProperty("knowledgeUrl")%>"><%=seeMore%><i class="fa fa-long-arrow-right"></i></a></div>
                </div>
                <%}%>
                <% if (!user.getClientType().equals("Store"))
                {%>
                <div id="topReqHolder" class="rightContentBox animated fadeInRight">
                    <h4 class="elementLabel">Top Requests</h4>
                    <%if(globalTopTemplates.size() > 0)
                    { %>
                    <ul class="list-group">
                    <%
                        int topTemplateCount = 0;
                        for(String templateName : globalTopTemplates)
                        {
                            if (topTemplateCount == 5)
                            {
                                break;
                            }
                            Template popularRequest = catalog.getTemplateByName(templateName);
                            //top requests returns null objects i guess for templates that this user can't see
                            if (popularRequest != null)
                            {
                                topTemplateCount++;
                    %>
                        <li class="list-group-item"><a href="<%=popularRequest.getAnonymousUrl()%>"><i class="fa fa-file-text-o fa-li"></i><span class="reqLabel"><%=popularRequest.getName()%></span></a></li>
                    <%      }
                        }%>
                    </ul><%
                    } else
                    {%>
                    <p>There are no available top requests.</p>
                    <%}%>
                </div>
                <% } %>
                <div id="recentRequests" class="rightContentBox animated fadeInRight">
                    <h4 class="elementLabel">Recently Submitted</h4>
                    <ul class="list-group">
                        <%  if (submissions.length == 0)
                        { %><li>There are no recent requests.</li>
                        <% }
                            for (int i=0; i<submissions.length; i++)
                            {
                                currentSubmission = submissions[i];
                        %>
                        <li class="list-group-item"> <a href="DisplayPage?name=Flat-SubmissionsActivity&id=<%=currentSubmission.getId()%>"><span class="reqLabel"><%=currentSubmission.getCreateDate()%></span> - <%=currentSubmission.getRequestDisplayName()%></a></li>
                        <%}%>
                    </ul>
                    <div class="sideLink"><a href="<%=bundle.getProperty("submissionsUrl") + "&type=requests"%>"><%=seeMore%><i class="fa fa-long-arrow-right"></i></a></div>
                </div>
                <% if (user.getClientType().equals("Store"))
                { %>
                <div id="topKnowHolder" class="rightContentBox animated fadeInRight">
                    <h4 class="knowledgeSectionTitle elementLabel">Top Knowledge Articles</h4>
                    <% if (matchingTemplates.length > 0)
                    {%>
                    <ul class="list-group">
                        <% for (int i=0; i< articles.length() && i<5; i++)
                        {
                            articleData = (org.json.JSONObject)articles.get(i);
                            String articleId = (String)articleData.get("Article ID");
                            String articleSource = (String)articleData.get("Source");

                        %>
                        <li class="list-group-item"><a href="<%= bundle.getProperty("rkmDisplayUrl") + "&type=" + articleSource.replaceAll("\\s", "") + "&articleId=" + articleId %>"><i class="fa fa-lightbulb-o fa-li"></i><span class="reqLabel"><%= articleData.get("Article Title")%></span></a></li>
                        <%}%>
                    </ul>
                    <%}%>
                    <div class="sideLink"><a href="<%=bundle.getProperty("knowledgeUrl")%>"><%=seeMore%><i class="fa fa-long-arrow-right"></i></a></div>
                </div>
                <%}%>
            </div>
            <%@include file="../../common/interface/fragments/footer.jspf"%>
        </div>


    </body>
</html>