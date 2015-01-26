<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.kineticdata.core.v1.utils.JsonUtils"%>
<%
    ArrayList<LinkedHashMap<String,Object>> ajaxEventsData = 
        (ArrayList<LinkedHashMap<String,Object>>)request.getAttribute("ajaxEventsData");
%>
<% if (ajaxEventsData.size() > 0) { %>
<h3>Ajax Events</h3>
<table class="table table-hover" id="ajax-events-table" style="width:100%;"></table>
<script>
    $(function() {
        $('#ajax-events-table').DataTable({
            autoWidth: false,
            dom: '<"wrapper">t',
            data: <%=JsonUtils.toJsonString(ajaxEventsData)%>,
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
                { data: 'eventName', title: 'Event Name', width: '50%', sortable: false },
                { data: 'eventType', title: 'Type', width: '25%', sortable: false, 
                    createdCell: function(td, cellData, row) {
                        $(td).append($('<br>')).append(row['type']);
                    } 
                },
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
<% } %>