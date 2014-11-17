<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.kd.ksr.cache.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kinetic Cache Manager: Dataset Cache</title>
        <style type="text/css">
            table {width: 100%;}
            table th {text-align: left; vertical-align: bottom;}
            table tr {text-align: left; vertical-align: top;}

            .hidden {display: none;}
        </style>
        <script type="text/javascript">
            function flushCache() {
                document.forms["clearForm"].submit();
            }
        </script>
    </head>
    <body>
        <h1>Dataset Cache <a href="<%=request.getContextPath()%>/CacheManager">Home</a> <a href="<%=request.getContextPath()%>/CacheManager?cache=dataset">Refresh</a></h1>
        <h3>Note: Dataset Cache is a bit special in that it only ever queries for dataset items that have been modified after its last query.  Therefore, individual datasets can't be removed (since the cache would not automatically replace them).</h3>
        <form action="<%=request.getContextPath()%>/CacheManager" class="hidden" method="post" name="clearForm">
            <input id="action" name="action" type="hidden" value="flushCache"/>
            <input id="cache" name="cache" type="hidden" value="dataset"/>
        </form>

        <div>Last Updated: <%= request.getAttribute("lastUpdated")%></div>

        <h2>Cache Statistics</h2>
        <table>
            <tr>
                <th>(Not Implemented)<br/>Average Access Time</th>
                <th>(Not Implemented)<br/>Average Retrieval Time</th>
                <th>Count</th>
                <th>(Not Implemented)<br/>Size</th>
            </tr>
            <tr>
                <td><%= DatasetCache.getAverageAccessTime() %> (<%=DatasetCache.getTotalAccessTime()%>/<%=DatasetCache.getTotalAccessCount()%>)</td>
                <td><%= DatasetCache.getAverageRetrievalTime() %> (<%=DatasetCache.getTotalAccessTime()%>/<%=DatasetCache.getTotalAccessCount()%>)</td>
                <td><%= DatasetCache.getCount() %></td>
                <td><%= DatasetCache.getSize() %></td>
            </tr>
        </table>

        <h2>Cache Items <a href="javascript:void(0);" onclick="flushCache();">Flush All</a></h2>
        <table>
            <tr>
                <th>Name</th>
                <th>Dataset Item Count</th>
            </tr>
            <% for (Map<String,String> attributeMap : (List<Map<String,String>>)request.getAttribute("datasetMapList")) { %>
            <tr>
                <td><%= attributeMap.get("Name") %></td>
                <td><%= attributeMap.get("Dataset Item Count") %></td>
            </tr>
            <% } %>
        </table>
    </body>
</html>