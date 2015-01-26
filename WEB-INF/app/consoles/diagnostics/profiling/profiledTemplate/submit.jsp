<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.kineticdata.core.v1.utils.JsonUtils"%>
<%
    ArrayList<LinkedHashMap<String,Object>> submitData = 
        (ArrayList<LinkedHashMap<String,Object>>)request.getAttribute("submitData");
%>
<h3>Page Submission</h3>
<table class="table table-hover" id="submit-table" style="width:100%;"></table>
<script>
    $(function() {
        $('#submit-table').DataTable({
            autoWidth: false,
            dom: '<"wrapper">t',
            data: <%=JsonUtils.toJsonString(submitData)%>,
            order: [],
            pageLength: 10000,
            headerCallback: function(thead) {
                $(thead).children().last()
                    .wrapInner($('<span>')
                        .addClass('pull-right'));
                $(thead).children().last().prev()
                    .wrapInner($('<span>')
                        .addClass('pull-right'));
            },
            columns: [
                { data: 'pageName', title: 'Page Name', width: '50%', sortable: false },
                { data: 'action', title: 'Action', width: '25%', sortable: false },
                { data: 'count', title: 'Count', width: '10%', sortable: false, 
                    createdCell: function(td, cellData) {
                        $(td).html($('<span>')
                            .addClass('monospace pull-right')
                            .text(cellData));
                    } 
                },
                { data: 'average', title: 'Average', width: '15%', sortable: false, 
                    createdCell: function(td, cellData) {
                        $(td).html($('<span>')
                            .addClass('monospace pull-right')
                            .text(Math.ceil(cellData))
                            .append(' ms'));
                    }
                }
            ]
        });
    });
</script>