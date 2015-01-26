<%@page import="java.net.URI"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%
    Map responseObject = (Map)request.getAttribute("responseObject");
    List<Map> treesList = (List<Map>)responseObject.get("trees");
    String message = (String)request.getAttribute("message");
    String sourceName = (String)request.getAttribute("sourceName");
    String sourceGroup = (String)request.getAttribute("sourceGroup");
    String taskServerBaseUrl = (String)request.getAttribute("taskServerBaseUrl");
    String treesJson = JSONValue.toJSONString(treesList);
    
    boolean hasCreateTree = false;
    boolean hasCompleteTree = false;
    for (Map tree : treesList) {
        if ("Create".equals(tree.get("name"))) { hasCreateTree = true; }
        else if ("Complete".equals(tree.get("name"))) { hasCompleteTree = true; }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=8" />
        <script type="text/javascript" src="<%=request.getContextPath()%>/app/thirdparty/jquery/jquery.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/app/thirdparty/jquery/jquery-ui/jquery-ui-1.10.3.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/app/thirdparty/jquery-datatables/jquery.dataTables.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/app/thirdparty/jquery-datatables/dataTables.bootstrap.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/app/thirdparty/bootstrap/bootstrap.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/app/thirdparty/momentjs/moment.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/app/thirdparty/underscorejs/underscore.min.js"></script>
        <link href="<%=request.getContextPath()%>/app/thirdparty/bootstrap/bootstrap.min.css" media="all" rel="stylesheet" />
        <style type="text/css">
            html {
                overflow-y: scroll;
            }
            body {
                padding: 0.75em;
                width: 615px;
                min-height: 200px;
                height: auto !important;
                height: 200px;
            }
            tbody {
                vertical-align: top;
            }
            .dropdown-menu>li>a.disabled-link,
            .dropdown-menu>li>a.disabled-link:visited ,
            .dropdown-menu>li>a.disabled-link:active,
            .dropdown-menu>li>a.disabled-link:hover {
                background-color: white;
                cursor: default;
                color:#aaa !important;
            }
            .alert {
                margin-bottom: 0.75em;
                padding: 0.75em;
            }
            .btn-default {
                background-color: #eee;
            }
            .column-type {
                width: 8em;
            }
            .column-updated {
                width: 18em;
            }
            .time-ago {
                cursor: default;
            }
            #treesTable {
                margin-top: 0.75em;
                width: 100%;
            }
        </style>
        <title>Task Trees</title>
    </head>
    <body>
        
        <input id="task-server-base-url" type="hidden" value="<%=escape(taskServerBaseUrl)%>"/>
        
        <% if (message != null) { %>
        <div class="row">
            <div class="col-xs-12">
                <div class="alert alert-warning" role="alert"><%=escape(message)%></div>
            </div>
        </div>
        <% } %>
        <div class="row">
            <div class="col-xs-12">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
                        Add <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a class="<%= hasCompleteTree ? "disabled-link" : null%>" href="<%=escape(taskServerBaseUrl)%>/app/trees/new?source=<%=encode(sourceName)%>&group=<%=encode(sourceGroup)%>&name=Complete" target="_blank">Complete Tree</a></li>
                        <li><a class="<%= hasCreateTree ? "disabled-link" : null%>"href="<%=escape(taskServerBaseUrl)%>/app/trees/new?source=<%=encode(sourceName)%>&group=<%=encode(sourceGroup)%>&name=Create" target="_blank">Create Tree</a></li>
                        <li><a href="<%=escape(taskServerBaseUrl)%>/app/trees/new?source=<%=encode(sourceName)%>&group=<%=encode(sourceGroup)%>" target="_blank">Custom Tree</a></li>
                        <li class="divider"></li>
                        <li><a href="<%=escape(taskServerBaseUrl)%>/app/routines/local/new?source=<%=encode(sourceName)%>&group=<%=encode(sourceGroup)%>" target="_blank">Local Routine</a></li>
                    </ul>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-xs-12">
                <table id="treesTable">
                    <colgroup>
                        <col class="column-type">
                        <col class="column-name">
                        <col class="column-updated">
                    </colgroup>
                </table>
            </div>
        </div>
        
        <script type="text/javascript">
            $(".disabled-link").click(function(event) {
                event.preventDefault();
            });
            
            $(function() {
                var formatTimestamp = function(element) {
                    // Ensure that the timestamp is not evaluated more than once.
                    if ($(element).data('toggle') !== 'tooltip') {
                        // Create a span that will hold the time content.  This is necessary because the tooltip creates
                        // an additonal element and if you don't wrap it with something the styling in places this
                        // function is called gets strange.
                        var span = $('<span>');
                        // Get the original iso8601 date from the text of the element.
                        var iso8601date = $(element).text();
                        // Set the text of the span to the time ago format.
                        $(span).text(moment(iso8601date).fromNow());
                        // Configure a tooltip that will show the date in a normal date format.
                        $(span).attr('title', moment(iso8601date).format('MMMM Do YYYY, h:mm:ss A'));
                        $(span).addClass('time-ago');
                        $(span).data('toggle', 'tooltip');
                        $(span).data('placement', 'top');
                        $(span).tooltip();    
                        // Replace the content of the element with the span created above.
                        $(element).html(span);
                    }
                };
                
                $("#treesTable").dataTable({
                    autoWidth: false,
                    columns: [
                        { data: 'type', title: 'Type' },
                        { data: 'name', title: 'Name',
                            createdCell: function(element, cellData, rowData) {
                                var href;
                                if (rowData.type === 'Tree') {
                                    href = $('#task-server-base-url').val()+"/app/trees/"+rowData.id;
                                } else {
                                    href = $('#task-server-base-url').val()+"/app/routines/"+rowData.id;
                                }
                                
                                var link = $('<a>')
                                    .attr('href', href)
                                    .attr('target', '_blank')
                                    .text($(element).text());
                                $(element).html(link);
                            }
                        },
                        { data: 'updatedAt', title: 'Updated', 
                            createdCell: function(element, cellData, rowData) {
                                formatTimestamp(element);
                                $(element).append(" by ").append(rowData.updatedBy);
                            }
                        }
                    ],
                    data: <%=treesJson%>,
                    dom: '<"wrapper">t',
                    order: [[0, 'desc'], [1, 'asc']]
                });
            });
        </script>
    </body>
</html>
