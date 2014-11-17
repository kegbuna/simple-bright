<%@page contentType="text/plain; charset=UTF-8"
%><%@page import="com.kd.arsHelpers.*"
%><%@page import="java.util.*"
%><%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%><%
    List<SimpleEntry> results = (List)request.getAttribute("resultsList");
    if (results == null) {
        out.print("There are no matching results.");
    } else {
        for(SimpleEntry result : results) {
            if (result != results.get(0)) {out.println("");}
            Object[] keys = result.getEntryItems().keySet().toArray();
            for(Object key : keys) {
                if (key != keys[0]) {out.print(", ");}
                out.print(result.getEntryFieldValue(key.toString()));
            }
        }
    }
%>