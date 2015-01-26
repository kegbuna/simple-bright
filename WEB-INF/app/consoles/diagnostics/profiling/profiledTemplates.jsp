<%@page import="com.kineticdata.ksr.models.Template"%>
<%@page import="com.kineticdata.profiling.ResultValue"%>
<%@page import="com.kineticdata.profiling.Profile"%>
<%@page import="com.kd.ksr.profiling.Recording"%>
<%@page import="com.kineticdata.profiling.ResultGroup"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.kineticdata.core.v1.utils.JsonUtils"%>
<%
    ArrayList<LinkedHashMap<String,Object>> data = (ArrayList<LinkedHashMap<String,Object>>)request.getAttribute("data");
%>
<table class="table table-hover" id="profiled-templates-table" style="width:100%;"></table>
<script>
    $(function() {
        $('#profiled-templates-table').DataTable({
            autoWidth: false,
            dom: '<"wrapper">t',
            language: {
                emptyTable: "No templates have been accessed during this recording."
            },
            data: <%=JsonUtils.toJsonString(data)%>,
            columns: [
                { data: 'catalogName', title: 'Catalog', width: '33%' },
                { data: 'templateName', title: 'Template', width: '67%',
                    createdCell: function(td, cellData, row) {
                        $(td).html($('<a>')
                            .attr('href', document.URL+"/"+row['id'])
                            .text(cellData));
                    }
                }
            ]
        });
    });
</script>