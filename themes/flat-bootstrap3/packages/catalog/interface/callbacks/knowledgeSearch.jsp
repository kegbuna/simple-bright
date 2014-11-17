<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%@include file="../../framework/helpers/CatalogSearch.jspf"%>
<%
if (context == null) {
    ResponseHelper.sendUnauthorizedResponse(response);
} else {
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
String mustHave = request.getParameter("mustHave");
String mayHave = request.getParameter("mayHave");
String mustNotHave = null;

// Perform the multi form search and write the result to the out
// stream.
MultiFormSearch mfs = new MultiFormSearch(mustHave, mayHave, mustNotHave, systemUser);
String jsonData = mfs.search(serverUser);
    articles = new org.json.JSONArray(jsonData);
    if (articles.length() > 0)
    {
        out.print(articles);
    }

//out.println(jsonData);
} catch (Exception e) {
// Write the exception to the kslog and re-throw it
//logger.error("Exception in RKMQuery.json.jsp", e);
throw e;
}
    if (matchingTemplates.length == 0 && articles.length() == 0)
    {
        responseMessage = "[{\"error\":\"No Results Found!\"}]";
        out.print(responseMessage);
    }
}
%>