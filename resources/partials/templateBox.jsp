<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%-- Format a list of KS_RQT_SurveyTemplateAttrInst_Category_join entries in boxes by category including link to the template and title --%>
<%
  java.util.List resultsList = (java.util.List) request.getAttribute("resultsList");
  if (resultsList != null) {
    String lastCategory = "";
    String category = "";
    String nextCategory = "";
    int maxItemsPerCat = 0;
    int catCount = 0;
    String oddEven="odd";
    //Need counter for last/this/next
    for (int i = 0; i < resultsList.size(); i++) {
      com.kd.arsHelpers.SimpleEntry entry = (com.kd.arsHelpers.SimpleEntry) resultsList.get(i);
      category = entry.getEntryFieldValue("700401900");
      /* INITIALIZE & BEGIN CATEGORY BOX HEADER*/
      if (!lastCategory.equalsIgnoreCase(category)) {
        try{
          maxItemsPerCat = Integer.parseInt(entry.getEntryFieldValue("700401940"));
        }catch(NumberFormatException nfe){maxItemsPerCat=1000;}
        catCount = 1;
%>
<div id="<%=category%>_layer" class="category box_<%=oddEven%> standard_box">
  <div class="standard_box"><%= entry.getEntryFieldValue("700401930")%>    <strong>
      <span class="categoryLabel"><a href="Javascript:doItemsForCategory(document.location.pathname.substring(0,document.location.pathname.lastIndexOf('/', document.location.pathname.length)), '<%=category %>');"><%=category %></a></span>
    </strong>
  </div>
  <blockquote>
<% if(oddEven.equals("odd")){oddEven="even";}else{oddEven="odd";}
  }
      /* END CATEGORY BOX HEADER*/
      /*BEGIN SERVICE ITEM DISPLAY*/
      if (catCount <= maxItemsPerCat) {
%>
  <p>
    <a href="<%=entry.getEntryFieldValue("700002489")%>" title="<%= com.kd.kineticSurvey.impl.SurveyUtilities.fixForHTML(entry.getEntryFieldValue("700001010"))%>"><%= entry.getEntryFieldValue("700001000")%>    </a>
  </p>
<%
  }
      /* END SERVICE ITEM DISPLAY */
      /* BEGIN CATEGORY BOX CLOSURE */
      if (i + 1 < resultsList.size()) {
    nextCategory = ((com.kd.arsHelpers.SimpleEntry) resultsList.get(i + 1)).getEntryFieldValue("700401900");
  }
  else {
    nextCategory = "";
  }
  if (!category.equalsIgnoreCase(nextCategory)) {
    if (catCount > maxItemsPerCat) {
%>
  <a href="Javascript:doItemsForCategory(document.location.pathname.substring(0,document.location.pathname.lastIndexOf('/', document.location.pathname.length)), '<%=category %>');">more...</a>
<%}%>
</blockquote>
</div>
<%
  /*END CATEGORY BOX CLOSURE*/
  }
      lastCategory = category;
  catCount += 1;
  }
  } else {
%>
<p>No results found</p>
<%}%>
