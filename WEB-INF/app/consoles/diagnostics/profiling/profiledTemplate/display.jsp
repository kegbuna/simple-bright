<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.kineticdata.core.v1.utils.JsonUtils"%>
<%
    ArrayList<LinkedHashMap<String,Object>> displayData = 
        (ArrayList<LinkedHashMap<String,Object>>)request.getAttribute("displayData");
%>
<h3>Display</h3>
<table class="table table-hover" id="display-table" style="width:100%;"></table>
<script>
    $(function() {
        $('#display-table').DataTable({
            autoWidth: false,
            dom: '<"wrapper">t',
            data: <%=JsonUtils.toJsonString(displayData)%>,
            order: [[0, 'asc']],
            pageLength: 10000,
            createdRow: function(tr, row) {
                if (row['type'] !== 'Page') {
                    $(tr).addClass('child');
                } else {
                    $(tr).addClass('parent');
                }
            },
            headerCallback: function(thead) {
                $(thead).children().last()
                    .wrapInner($('<span>')
                        .addClass('pull-right'));
                $(thead).children().last().prev()
                    .wrapInner($('<span>')
                        .addClass('pull-right'));
            },
            columns: [
                { data: 'sortOrder', title: 'Order', visible: false, type: 'num' },
                { data: 'name', title: 'Name', width: '50%', sortable: false },
                { data: 'type', title: 'Type', width: '25%', sortable: false },
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