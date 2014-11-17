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
    ResultGroup base = profile.graph().child("Display Page").subgroup(templateIdMap);

    // Define the field values
    String QUESTION_ANSWER_DATA_TYPE = "700000002";
    String QUESTION_ADVANCED_DEFAULT_USED = "700005001";
    String PAGE_TEMPLATE_ID = "700000800";
    String INSTANCE_ID = "179";
    String QUESTION_NAME = "700001833";

    // Declare the maps used to store Template structure information
    Map<String,List<SimpleEntry>> pageAdvancedDefaultQuestionsMap = new LinkedHashMap();
    Map<String,List<SimpleEntry>> pageDynamicListQuestionsMap = new LinkedHashMap();
    Map<String,List<SimpleEntry>> pageDynamicTextQuestionsMap = new LinkedHashMap();

    // Retrieve the pages associated to this template
    String pageQualification = "'"+PAGE_TEMPLATE_ID+"' = \""+template.getInstanceId()+"\" AND '700001202' = \"Page\"";
    SimpleEntry[] pageEntries = helper.getSimpleEntryList("KS_SRV_ContentsElementHTML", pageQualification, new String[]{INSTANCE_ID});
    Page[] pages = new Page[pageEntries.length];
    for(int i=0;i<pages.length;i++) {
        pages[i] = PageCache.getPageByInstanceId(template.getInstanceId(), pageEntries[i].getEntryFieldValue(INSTANCE_ID));
    }

    // For each of the pages
    for(int i=0;i<pages.length;i++) {
        // Store the list of dynamic text elements for that page
        List<SimpleEntry> dynamicTextList = Arrays.asList(pages[i].getDynamicTextElements());
        pageDynamicTextQuestionsMap.put(pages[i].getInstanceId(), dynamicTextList);

        // Declare the list of advanced default and dynamic list questions and
        // add them to the page value mappings
        List<SimpleEntry> advancedDefaultList = new ArrayList();
        pageAdvancedDefaultQuestionsMap.put(pages[i].getInstanceId(), advancedDefaultList);
        List<SimpleEntry> dynamicListQuestionList = new ArrayList();
        pageDynamicListQuestionsMap.put(pages[i].getInstanceId(), dynamicListQuestionList);

        // Populate the lists of advanced default and dynamic list questions
        SimpleEntry[] questions = pages[i].getPageQuestions();
        for(SimpleEntry question : questions) {
            // Retrieve the desired values from the question
            String advancedDefault = question.getEntryFieldValue(QUESTION_ADVANCED_DEFAULT_USED);
            String dataType = question.getEntryFieldValue(QUESTION_ANSWER_DATA_TYPE);
            // If the question is marked as an advanced default, add it to the advanced default collection
            if (advancedDefault.equals("True")) {advancedDefaultList.add(question);}
            // If the question is of type Dynamic List, add it to the dynamic list collection
            if (dataType.equals("Dynamic List")) {dynamicListQuestionList.add(question);}
        }
    }
%>

<h2>Display Page</h2>
<table style="width: 100%;">
    <tr>
        <th>Type</th>
        <th>Name</th>
        <th>Instance Id</th>
        <th class="total">Total (Average * Count)</th>
    </tr>
    <% 
        for (Page templatePage : pages) {
            Map<String,String> pageIdMap = new HashMap();
            pageIdMap.put("Page Id", templatePage.getInstanceId());
            ResultGroup pageResults = base.subgroup(pageIdMap);
    %>
    <tr class="page">
        <td class="type">Page</td>
        <td class="name"><%= templatePage.getName() %></td>
        <td class="id"><%= templatePage.getInstanceId() %></td>
        <td class="results"><%= pageResults.metricsString() %></td>
    </tr>
    <%
        for (SimpleEntry advancedDefault : pageAdvancedDefaultQuestionsMap.get(templatePage.getInstanceId())) {
            Map<String,String> questionIdMap = new HashMap();
            questionIdMap.put("Question Id", advancedDefault.getEntryFieldValue(INSTANCE_ID));
            ResultGroup questionResults = pageResults.descendant("Advanced Default Question");
    %>
    <tr class="child">
        <td class="type">Dynamic Default</td>
        <td class="name"><%= advancedDefault.getEntryFieldValue(QUESTION_NAME) %></td>
        <td class="id"><%= advancedDefault.getEntryFieldValue(INSTANCE_ID) %></td>
        <td class="results"><%= questionResults.metricsString() %></td>
    </tr>
    <% } %>
    <%
        for (SimpleEntry dynamicList : pageDynamicListQuestionsMap.get(templatePage.getInstanceId())) {
            Map<String,String> questionIdMap = new HashMap();
            questionIdMap.put("Question Id", dynamicList.getEntryFieldValue(INSTANCE_ID));
            ResultGroup questionResults = pageResults.descendant("Dynamic List Question");
    %>
    <tr class="child">
        <td class="type">Dynamic List</td>
        <td class="name"><%= dynamicList.getEntryFieldValue(QUESTION_NAME) %></td>
        <td class="id"><%= dynamicList.getEntryFieldValue(INSTANCE_ID) %></td>
        <td class="results"><%= questionResults.metricsString() %></td>
    </tr>
    <% } %>
    <%
        for (SimpleEntry dynamicText : pageDynamicTextQuestionsMap.get(templatePage.getInstanceId())) {
            Map<String,String> questionIdMap = new HashMap();
            questionIdMap.put("Question Id", dynamicText.getEntryFieldValue(INSTANCE_ID));
            ResultGroup questionResults = pageResults.descendant("Dynamic Text Question");
    %>
    <tr class="child">
        <td class="type">Dynamic Text</td>
        <td class="name"><%= dynamicText.getEntryFieldValue("1002") %></td>
        <td class="id"><%= dynamicText.getEntryFieldValue(INSTANCE_ID) %></td>
        <td class="results"><%= questionResults.metricsString() %></td>
    </tr>
    <% } %>
    <%
        ResultGroup renders = pageResults.descendant("Display Page - Render JSP");
        for (ResultValue value : renders.values()) {
    %>
    <tr class="child">
        <td class="type">Rendering</td>
        <td class="id" colspan="2"><%= value.getAttribute("JSP Page") %></td>
        <td class="results"><%= value.metricsString() %></td>
    </tr>
    <% } %>
    <% } %>
</table>