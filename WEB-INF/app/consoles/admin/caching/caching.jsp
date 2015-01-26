<%@page import="com.kd.ksr.profiling.Profiler"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    List<Map<String,Object>> cacheDetails = (List<Map<String,Object>>)request.getAttribute("cacheDetails"); 
    String total = (String)request.getAttribute("total");
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
                    <%-- PAGE HEADER --%>
                    <div class="page-header">
                        <h3>
                            Caching
                        </h3>
                    </div>
                    <%-- SESSION MESSAGE --%>
                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                    
                    <div class="row">
                        <div class="col-xs-8"></div>
                        <div class="col-xs-4">
                            <ul class="pull-right list-inline">
                                <li><strong>Total Size:</strong> <%=escape(total)%></li>
                                <li></li>
                            </ul>
                        </div>
                    </div>
                    
                    <%-- MAIN CONTENT --%>
                    <table class="table table-hover" id="caching-table" style="width:100%;"></table>
                </div>
                <%-- RIGHT SIDEBAR --%>
                <div class="col-xs-3 sidebar pull-right">
                    <jsp:include page="/WEB-INF/app/consoles/_shared/help.jsp">
                        <jsp:param name="helpType" value="Admin Consoles" />
                        <jsp:param name="helpUrl" value="http://help.kineticdata.com/ksr52/consoles/admin" />
                    </jsp:include>
                    <jsp:include page="_helpText.jsp"/>
                </div>
            </div>
        </div>
    </div>
    </div>
    </section>
    <script type="text/javascript">
        // On page load.
        $(function() {
            $('table#caching-table').dataTable({
                autoWidth: false,
                dom: '<"wrapper">t',
                data: <%=JsonUtils.toJsonString(cacheDetails)%>,
                order: [[ 0, "asc" ]],
                pageLength: 10000,
                columns: [
                    { data: 'name', title: 'Structure', width: '50%' },
                    { data: 'count', title: 'Count', width: '25%', 'orderSequence': ['desc', 'asc'] },
                    { data: 'size', title: 'Size', width: '25%', 'orderSequence': ['desc', 'asc'], 
                        createdCell: function(td, cellData, rowData) {
                            $(td).text(rowData['sizeString']);
                        }
                    }
                ]
            });
        });
    </script>
    </jsp:attribute>
</tag:application>  