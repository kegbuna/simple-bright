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
    ResultGroup submitPageBase = profile.graph().child("Submit Page").subgroup(templateIdMap);
    ResultGroup answerSubmissionBase = profile.graph().child("Answer Submission").subgroup(templateIdMap);

    // Retrieve a list of template pages
    Page[] pages = PageCache.getPagesByTemplateId(template.getInstanceId());
    List<Page> templatePages = new ArrayList();
    for (Page templatePage : pages) {
        if (!"Confirmation".equals(templatePage.getPageType())) {
            templatePages.add(templatePage);
        }
    }
%>

<h2>Submit Page</h2>
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
            ResultGroup pageResults = submitPageBase.subgroup(pageIdMap);
    %>
    <tr class="page" style="padding-top:1em;">
        <td class="name"><%= templatePage.getName() %></td>
        <td class="id"><%= templatePage.getInstanceId() %></td>
        <td class="results"><%= pageResults.metricsString() %></td>
    </tr>
    <% } %>
</table>

<div style="font-weight:bold; text-decoration: underline;margin-top: 1em;">Background Processing</div>
<table style="width: 100%;padding-left: 1em;">
    <tr>
        <th>Page Name</th>
        <th>Page Id</th>
        <th>Action</th>
        <th class="total">Total (Average * Count)</th>
    </tr>
    <%
        for (Page templatePage : templatePages) {
            Map<String,String> pageIdMap = new HashMap();
            pageIdMap.put("Page Id", templatePage.getInstanceId());
            ResultGroup pageResults = answerSubmissionBase.subgroup(pageIdMap);
    %>
    <tr class="page">
        <td class="name"><%= templatePage.getName() %></td>
        <td class="id"><%= templatePage.getInstanceId() %></td>
        <td class="type">Answer Submission</td>
        <td class="results"><%= pageResults.metricsString() %></td>
    </tr>
    <tr class="child">
        <td class="name"><%= templatePage.getName() %></td>
        <td class="id"><%= templatePage.getInstanceId() %></td>
        <td class="type">Answer Records</td>
        <td class="results"><%= pageResults.descendant("AnswerCreator#submitAnswers - Answer Record").metricsString() %></td>
    </tr>
    <tr class="child">
        <td class="name"><%= templatePage.getName() %></td>
        <td class="id"><%= templatePage.getInstanceId() %></td>
        <td class="type">Attachment Uploads</td>
        <td class="results"><%= pageResults.descendant("AnswerCreator#submitAnswers - Attachment").metricsString() %></td>
    </tr>
    <% } %>
</table>