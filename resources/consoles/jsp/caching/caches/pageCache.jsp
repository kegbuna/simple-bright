<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.kd.ksr.cache.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kinetic Cache Manager: Page Cache</title>
        <style type="text/css">
            table {width: 100%;}
            table th {text-align: left; vertical-align: bottom;}
            table tr {text-align: left; vertical-align: top;}

            .hidden {display: none;}
        </style>
        <script type="text/javascript">
            function flushCache() {
                document.forms["flushForm"].submit();
            }
            function removeCacheItem(templateId, pageId) {
                document.getElementById('templateId').value = templateId;
                document.getElementById('pageId').value = pageId;
                document.forms["clearForm"].submit();
            }
        </script>
    </head>
    <body>
        <h1>Page Cache <a href="<%=request.getContextPath()%>/CacheManager">Home</a> <a href="<%=request.getContextPath()%>/CacheManager?cache=page">Refresh</a></h1>
        <form action="<%=request.getContextPath()%>/CacheManager" class="hidden" method="post" name="flushForm">
            <input id="action" name="action" type="hidden" value="flushCache"/>
            <input id="cache" name="cache" type="hidden" value="page"/>
        </form>
        <form action="<%=request.getContextPath()%>/CacheManager" class="hidden" method="post" name="clearForm">
            <input id="action" name="action" type="hidden" value="removeCacheItem"/>
            <input id="cache" name="cache" type="hidden" value="page"/>
            <input id="templateId" name="templateId" type="hidden"/>
            <input id="pageId" name="pageId" type="hidden"/>
        </form>

        <h2>Cache Statistics</h2>
        <table>
            <tr>
                <th>(Not Implemented)<br/>Average Access Time</th>
                <th>(Not Implemented)<br/>Average Retrieval Time</th>
                <th>Count</th>
                <th>(Not Implemented)<br/>Size</th>
            </tr>
            <tr>
                <td><%= PageCache.getAverageAccessTime() %> (<%=PageCache.getTotalAccessTime()%>/<%=PageCache.getTotalAccessCount()%>)</td>
                <td><%= PageCache.getAverageRetrievalTime() %> (<%=PageCache.getTotalAccessTime()%>/<%=PageCache.getTotalAccessCount()%>)</td>
                <td><%= PageCache.getCount() %></td>
                <td><%= PageCache.getSize() %></td>
            </tr>
        </table>

        <h2>Cache Items <a href="javascript:void(0);" onclick="flushCache();">Flush All</a></h2>
        <table>
            <tr>
                <th>Template</th>
                <th>Page</th>
                <th>Modified At</th>
                <th>Action</th>
            </tr>
            <% for (Map<String,String> attributeMap : (List<Map<String,String>>)request.getAttribute("pageMapList")) { %>
            <tr>
                <td><%= attributeMap.get("Template Name") %> (<%= attributeMap.get("Template Id") %>)</td>
                <td><%= attributeMap.get("Page Name") %> (<%= attributeMap.get("Page Id") %>)</td>
                <td><a href="javascript:void(0);" onclick="removeCacheItem('<%= attributeMap.get("Template Id") %>', '<%= attributeMap.get("Page Id") %>');">Flush</a></td>
            </tr>
            <% } %>
        </table>
    </body>
</html>