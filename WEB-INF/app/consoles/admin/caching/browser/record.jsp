<%@page import="com.kd.ksr.profiling.Profiler"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    String displayName = (String)request.getAttribute("displayName");
    String className = (String)request.getAttribute("className");
    String id = (String)request.getAttribute("id");
    Map<String,Object> data = (Map<String,Object>)request.getAttribute("data");
%>
<tag:application>
    <jsp:attribute name="title">Kinetic | Caching</jsp:attribute>
    <jsp:attribute name="navigationCategory">Admin</jsp:attribute>
    <jsp:attribute name="content">
    <section class="content">
    <div class="container-fluid main-inner">
    <div class="row">
        <%-- LEFT SIDEBAR --%>
        <div class="col-xs-2 sidebar">
            <jsp:include page="/WEB-INF/app/consoles/_shared/leftNavigation/admin.jsp">
                <jsp:param name="navigationItem" value="Caching"/>
            </jsp:include>
        </div>
        <div class="col-xs-10">
            <div class="row">
                <%-- CENTER CONTENT --%>
                <div class="col-xs-9">
                    <%-- BREADCRUMBS --%>
                    <ol class="breadcrumb">
                        <%=breadcrumb("Caches", request.getContextPath()+"/app/admin/caching/browser")%>
                        <%=breadcrumb(escape(displayName), request.getContextPath()+"/app/admin/caching/browser/"+className)%>
                        <%=breadcrumb(escape(id))%>
                    </ol>
                    
                    <%-- PAGE HEADER --%>
                    <div class="page-header">
                        <h1>
                            <strong><%=escape(displayName)%> Record</strong>
                        </h1>
                    </div>
                    <%-- SESSION MESSAGE --%>
                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                    
                    <%-- MAIN CONTENT --%>
                    <pre id="record-content"></pre>
                </div>
                <%-- RIGHT SIDEBAR --%>
                <div class="col-xs-3 sidebar pull-right">
                    <jsp:include page="/WEB-INF/app/consoles/_shared/help.jsp">
                        <jsp:param name="helpType" value="Admin Consoles" />
                        <jsp:param name="helpUrl" value="http://help.kineticdata.com/ksr52/consoles/admin" />
                    </jsp:include>
                    <jsp:include page="/WEB-INF/app/consoles/admin/caching/_helpText.jsp"/>
                </div>
            </div>
        </div>
    </div>
    </div>
    </section>
    <script type="text/javascript">
        // On page load.
        $(function() {
            $('#record-content').text(JSON.stringify(<%=JsonUtils.toJsonString(data)%>, undefined, 2));
        });
    </script>
    </jsp:attribute>
</tag:application>  