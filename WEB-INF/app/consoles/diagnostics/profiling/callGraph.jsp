<%@page import="com.kineticdata.profiling.Profile"%>
<%@page import="com.kineticdata.profiling.Profiler"%>
<%@page import="com.kd.ksr.profiling.Recording"%>
<%@page import="java.io.PrintWriter"%>
<%
    Recording recording = (Recording)request.getAttribute("recording");
    Profile profile = recording.getProfiler().buildProfile();
%>
<% if (profile.list().getChildren().isEmpty()) { %>
<pre>No call data available.</pre>
<% } else { %>
<pre><% profile.printCallGraph(new PrintWriter(out, true)); %></pre>
<% } %>