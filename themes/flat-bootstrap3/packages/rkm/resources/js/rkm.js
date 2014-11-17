jQuery(document).ready(function() {
    // This object maps the source type returned by the multi query jsp to a
    // camel-case version used in css classes and jsp names.
    var sourceMap = {
        "Decision Tree": "decisionTree",
        "How To": "howTo",
        "Known Error": "knownError",
        "Problem Solution": "problemSolution",
        "Reference": "reference"
    };
    
    // Here we set the focus to the input box that gathers the search terms
    jQuery("form#searchTerms input#mustHave").focus();
    
    // On submit of the search terms form we call the RKMQuery jsp which returns
    // a json result that represents the matching articles.  We use this json
    // result to generate an html table.  Each row in the table has a clicked
    // handler bound to it that retrieves the article (defined below).
    jQuery("form#searchTerms").submit(function() {
        jQuery("#results").empty();
        jQuery("#messages").empty();
        if ( jQuery(this).find("input#mustHave").val() === "" ) {
            jQuery("#messages").append('<div class="message">Please enter search terms</div>');
            jQuery("#messages .message").show();
        } else {
            jQuery("form#searchTerms .spinner, form#searchTerms #searchButton").toggle();
        BUNDLE.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/RKMQuery.json.jsp",
            data: jQuery(this).serialize(),
            success: function(data) {
                var results = jQuery.parseJSON(data);
                jQuery("form#searchTerms .spinner, form#searchTerms #searchButton").toggle();
                jQuery("#messages").append('<div class="message">Your search returned ' + results.length + ' results</div>');
                jQuery("#messages .message").show();
                for (var i in results) {
                    var resultDiv = jQuery('<div class="result"></div>');
                    resultDiv.data("article-id", results[i]["Article ID"]);
                    resultDiv.data("article-type", sourceMap[results[i]["Source"]]);
                    resultDiv.append('<div class="icon '+ sourceMap[results[i]["Source"]] +
                        '" title="' + results[i]["Source"] + '"></div>');
                    resultDiv.append('<div class="middleCol">' +
                        '<div class="title">' + 
                        '<div class="sprite expand"></div>' +
                        '<div class="sprite contract"></div>' +
                        '<div class="titleText">' + results[i]["Article Title"] + '</div>' +
                        '<div class="clear"></div>' +
                        '</div>' +
                        '<div class="clear"></div>' +
                        '<div class="summary">' + results[i]["Summary"] + '</div></div>');
                    resultDiv.append('<div class="rightCol"><div class="created"' +
                        'title="' + results[i]["Created Date"] + '">' +
                        results[i]["Created Ago"] + ' ago</div></div>');
                    resultDiv.append('<div class="clear"></div>');
                    jQuery(resultDiv).find(".middleCol .title").click(toggleArticle);
                    jQuery("#results").append(resultDiv);
                    
                }
            },
            error: function(data) {
                jQuery("#messages").append('<div class="message error">An error occurred during the search</div>');
                jQuery("#messages .message").show();
            }
        });
        }
        return false;
    });
});

function toggleArticle() {
    // Retrieve the result dom element that this link refers to.
    var resultDiv = jQuery(this).parents("#results .result");
    
    // Retrieve parameters used in the call from data attributes of the clicked
    // dom element.
    var articleType = resultDiv.data("article-type");
    var articleId = resultDiv.data("article-id");

    // If the article has not been retrieve do an ajax call to retrieve the
    // article partial and append it to the result div, then show it.  Otherwise
    // we simple show the article that is already there.
    if ( resultDiv.find(".article").length === 0 ) {
        BUNDLE.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/" + articleType + '.html.jsp',
            data: { articleId: articleId },
            success: function(data) {
                resultDiv.find(".middleCol").append(data);
                var articleButtons = jQuery('<div class="buttons"></div>');
                var commentUrl = BUNDLE.config["commentUrl"] + "&id=" + articleId;
                var commentAnchor = jQuery('<a href="' + commentUrl + '"></a>');
                var commentButton = jQuery('<img alt="Comment" class="button comment" src="' +
                    BUNDLE.packagePath + 'resources/images/comments.png"/ title="Comment">');
                commentAnchor.append(commentButton)
                articleButtons.append(commentAnchor);
                var useButton = jQuery('<img alt="Use" class="button use" src="' +
                    BUNDLE.packagePath +'resources/images/blog_accept.png"/ title="Use">');
                var useMessage = jQuery('<span class="hidden">Feedback submitted</span>');
                useButton.click(function() {
                    BUNDLE.ajax({
                       url: BUNDLE.packagePath + 'interface/callbacks/incrementRelevance.jsp',
                       data: {
                           articleId: jQuery(this).parents("#results .result").data("article-id")
                       },
                       success: function(data) {
                           jQuery(useButton).fadeOut(function() {
                               jQuery(useMessage).fadeIn();
                           });
                       }
                   }) 
                });
                articleButtons.append(useButton);
                articleButtons.append(useMessage);
                resultDiv.find(".article").append(articleButtons);
                resultDiv.find(".article").slideToggle();
                resultDiv.find(".title .sprite").toggle();
				jQuery(resultDiv).find("img").each(function(){
						
						var src = "DownloadAttachment/" 
						+ jQuery(this).attr("arschema") 
						+ "/" 
						+ jQuery(this).attr("arattid") 
						+ "/"
						+ jQuery(this).attr("arentryid");
						  jQuery(this).attr("src", src);
				});
            }
        });
    } else {
        resultDiv.find(".article").slideToggle();
        resultDiv.find(".title .sprite").toggle();
    }
}