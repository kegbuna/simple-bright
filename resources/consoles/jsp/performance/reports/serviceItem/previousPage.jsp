<%@page import="com.kd.arsHelpers.*"%>
<%@page import="com.kd.kineticSurvey.impl.*"%>
<%@page import="com.kd.ksr.beans.*"%>
<%@page import="com.kd.ksr.cache.*"%>
<%@page import="com.kd.ksr.profiling.*"%>
<%@page import="com.kineticdata.profiling.Profile"%>
<%@page import="com.kineticdata.profiling.ResultGroup"%>
<%@page import="com.kineticdata.profiling.ResultValue"%>
<%@page import="java.util.*"%>
<%
    // Retrieve the necessary values
    Template template = (Template)request.getAttribute("Template");
    Profile profile = (Profile)request.getAttribute("Profile");
    ArsPrecisionHelper helper = (ArsPrecisionHelper)request.getAttribute("Helper");

    // Build the base ResultGroup
    Map<String,String> templateIdMap = new HashMap();
    templateIdMap.put("Template Id", template.getInstanceId());
    ResultGroup base = profile.graph().child("Previous Page").subgroup(templateIdMap);

    // Retrieve a list of template pages
    Page[] pages = PageCache.getPagesByTemplateId(template.getInstanceId());
    List<Page> templatePages = new ArrayList();
    for (Page templatePage : pages) {
        if ("Enable".equals(templatePage.getPreviousPageEnabled())) {
            templatePages.add(templatePage);
        }
    }

    // If there are any pages
    if (!templatePages.isEmpty()) {
%>
    <h2>Previous Page</h2>
    <table style="width: 100%;">
        <tr>
            <th>Page Name</th>
            <th>Page Id</th>
            <th class="total">Total (Average * Count)</th>
        </tr>
    <%
        for (Page templatePage : templatePages) {
            Map<String,String> pageIdMap = new HashMap();
            pageIdMap.put("Page Id", templatePage.getInstanceId());
            ResultGroup group = base.subgroup(pageIdMap);
    %>
        <tr>
            <td><%= templatePage.getName() %></td>
            <td><%= templatePage.getInstanceId() %></td>
            <td class="results"><%= group.metricsString() %></td>
        </tr>
    <% } %>
    </table>
<% } %>