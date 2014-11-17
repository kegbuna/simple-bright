<%@page contentType="text/plain; charset=UTF-8"
%><%@page import="com.kd.ksr.profiling.*"
%><%@page import="com.kineticdata.profiling.Profile"
%><%
    String recordingId = request.getParameter("recordingId");
    Profile profile = null;
    if (recordingId != null) {
        Recording recording = Profiler.getRecording(recordingId);
        if (recording != null) {
            profile = recording.getProfiler().buildProfile();
        }
    } else {
        profile = Profiler.getGlobalProfile();
    }

    if (recordingId != null && profile == null) {
        out.write("Unable to retrieve profile information for recording "+recordingId+".");
    } else {
        out.write("Profile Statistics");
        if (recordingId != null) {out.write(" ("+recordingId+")");}
        out.write("\n\n");
        profile.printStatistics(new java.io.PrintWriter(out));
    }
%>