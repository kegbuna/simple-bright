<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%-- Format a list of KS_RQT_SurveyTemplateAttrInst_Category_join entries in boxes by category including link to the template and title --%>
<%
  java.util.List resultsList = (java.util.List) request.getAttribute("resultsList");
  com.kd.kineticSurvey.beans.UserContext userContext = (com.kd.kineticSurvey.beans.UserContext) request.getSession().getAttribute("UserContext");
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
      //Only show if Public when not authenticated
      String group = entry.getEntryFieldValue("112");
      if (!userContext.isAuthenticated() && !group.equals("0;")){
      continue;
    }
      category = entry.getEntryFieldValue("700401900");
      /* INITIALIZE & BEGIN CATEGORY BOX HEADER*/
      if (!lastCategory.equalsIgnoreCase(category)) {
        try{
          maxItemsPerCat = Integer.parseInt(entry.getEntryFieldValue("700401940"));
        }catch(NumberFormatException nfe){maxItemsPerCat=1000;}
        catCount = 1;
%>
<div id="<%=category%>_layer" class="categoryBox box_<%=oddEven%>">
<div class="categoryLabel primaryColorHeader"><a class="catLink" href="Javascript:catalogUtils.getAllCategoryItems('<%=category %>');"><%=category %></a></div>
  	<div class="categoryIconLayer"><%= entry.getEntryFieldValue("700401930")%></div>
  	<div class="categoryLabelLayer">
		<%= entry.getEntryFieldValue("700401901") %>
  	</div>
	<div style="float:left;">
	<ul>
<% if(oddEven.equals("odd")){oddEven="even";}else{oddEven="odd";}
  }
      /* END CATEGORY BOX HEADER*/
      /*BEGIN SERVICE ITEM DISPLAY*/
      if (catCount <= maxItemsPerCat) {
%>
  <li>
    <a href="<%= request.getContextPath() %>/DisplayPage?srv=<%=entry.getEntryFieldValue("179")%>" title="<%= com.kd.kineticSurvey.impl.SurveyUtilities.fixForHTML(entry.getEntryFieldValue("700001010"))%>"><%= entry.getEntryFieldValue("700001000")%></a>
  </li>
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
  if (!category.equalsIgnoreCase(nextCategory)) {%>
</ul>
<% if (catCount > maxItemsPerCat) {%>
<div style="text-align:right;"><a class="moreLink" href="Javascript:catalogUtils.getAllCategoryItems('<%=category %>')">more...</a></div>
<%} %>
</div>
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
