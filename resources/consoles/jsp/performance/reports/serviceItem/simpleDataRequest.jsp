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
    ResultGroup base = profile.graph().child("Simple Data Request").subgroup(templateIdMap);

    // Define the field values
    String INSTANCE_ID = "179";
    String ELEMENT_ID = "700000230";
    String TEMPLATE_ID = "700000800";
    String CONTENT_ELEMENT_NAME = "1002";
    String EVENT_NAME_ID = "700004582";
    String EVENT_SDR_ID = "700004630";
    String SDR_NAME_ID = "700000030";
    String SDR_TEMPLATE_ID = "700001001";

    // Retrieve a list of Simple Data Request entries
    SimpleEntry[] sdrEntries = helper.getSimpleEntryList(
        "KS_SRV_SimpleDataRequest",
        "'"+SDR_TEMPLATE_ID+"'=\""+template.getInstanceId()+"\"",
        new String[]{INSTANCE_ID, SDR_NAME_ID});

    if (sdrEntries.length > 0) {
        // Retrieve a list of Content Event entries
        SimpleEntry[] eventEntries = helper.getSimpleEntryList(
            "KS_SRV_ContentEvents",
            "'"+TEMPLATE_ID+"'=\""+template.getInstanceId()+"\"",
            new String[]{ELEMENT_ID, EVENT_NAME_ID, TEMPLATE_ID, EVENT_SDR_ID});
        //
        Map<String,SimpleEntry> eventEntryMap = new HashMap();
        Map<String,String> eventElementMap = new HashMap();
        for (SimpleEntry entry : eventEntries) {
            String elementId = entry.getEntryFieldValue(ELEMENT_ID);
            String sdrId = entry.getEntryFieldValue(EVENT_SDR_ID);
            eventEntryMap.put(sdrId, entry);
            if (!eventElementMap.containsKey(elementId)) {
                SimpleEntry contentEntry = helper.getSingleSimpleEntry(
                    "KS_SRV_ContentsElementHTML",
                    "'"+TEMPLATE_ID+"'=\""+template.getInstanceId()+"\" AND '"+ELEMENT_ID+"' = \""+elementId+"\"",
                    new String[] {CONTENT_ELEMENT_NAME});
                eventElementMap.put(elementId, contentEntry.getEntryFieldValue(CONTENT_ELEMENT_NAME));
            }
        }
%>
    <h2>Simple Data Requests</h2>
    <table style="width: 100%;">
        <tr>
            <th>Event Name</th>
            <th>Event Element Name</th>
            <th>Event Element Id</th>
            <th>SDR Name</th>
            <th>SDR Instance Id</th>
            <th class="total">Total (Average * Count)</th>
        </tr>
        <%
            for (SimpleEntry entry : sdrEntries) {
                SimpleEntry eventEntry = eventEntryMap.get(entry.getEntryFieldValue(INSTANCE_ID));
                Map<String,String> sdrIdMap = new HashMap();
                sdrIdMap.put("Id", entry.getEntryFieldValue(INSTANCE_ID));
                ResultGroup sdrGroup = base.subgroup(sdrIdMap);
        %>
        <tr>
            <td class="name"><%= eventEntry.getEntryFieldValue(EVENT_NAME_ID) %></td>
            <td class="name"><%= eventElementMap.get(eventEntry.getEntryFieldValue(ELEMENT_ID)) %></td>
            <td class="id"><%= eventEntry.getEntryFieldValue(ELEMENT_ID) %></td>
            <td class="name"><%= entry.getEntryFieldValue(SDR_NAME_ID) %></td>
            <td class="id"><%= entry.getEntryFieldValue(INSTANCE_ID) %></td>
            <td class="results"><%= sdrGroup.metricsString() %></td>
        </tr>
        <% } %>
    </table>
<% } %>