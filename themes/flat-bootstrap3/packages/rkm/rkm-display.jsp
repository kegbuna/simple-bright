<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>
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
                <h2 class="article-title">Knowledge Article</h2>
                <div class="row">
                <%-- Include the article type file. --%>
                <%
                    String paramId = request.getParameter("articleId");
                    if (request.getParameter("type") != null)
                    {
                        String articleType = request.getParameter("type");
                        String pageUrl = "interface/callbacks/" + articleType + ".html.jsp";

                %>  <%@include file="interface/callbacks/problemSolution.html.jsp" %>
                    <%@include file="interface/callbacks/knownError.html.jsp" %>
                    <%@include file="interface/callbacks/decisionTree.html.jsp" %>
                    <%@include file="interface/callbacks/howTo.html.jsp" %>
                    <%@include file="interface/callbacks/reference.html.jsp" %>
                <% } %>
                </div>
                <div class="row">
                    <div class="text-center col-md-10 knowledge-buttons" style="margin-bottom: 20px;">
                        <h4> Was this article helpful?</h4>
                        <a id="increaseRel" class="btn btn-success">Yes</a>
                        <a id="returnHome" class="btn btn-primary" href="DisplayPage?name=BedBath-KnowledgePage">No - Search Again</a>
                       <!-- <a class="btn btn-primary">No - Create Ticket</a>-->
                    </div>
                </div>
                <script>
                    var $increaseRel = $('#increaseRel');
                    $increaseRel.on('click', function()
                    {
                        $increaseRel.html('<i class="fa-spin fa-spinner fa"></i>');
                        $.ajax(
                        {
                            url: 'DisplayPage?name=incrementRelevance&articleId=<%=paramId%>',
                            type: 'GET',
                            error: function(data)
                            {
                                $increaseRel.text('Something went wrong. Unable to Process.');
                            },
                            success: function(data)
                            {
                                $increaseRel.addClass('disabled');
                                $increaseRel.text('Thanks!');
                            }
                        });
                    });
                </script>
            </div>
            <%@include file="../../common/interface/fragments/footer.jspf"%>
        </div>
    </body>
</html>