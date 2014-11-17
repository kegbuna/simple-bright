<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.kd.ksr.cache.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cache Manager</title>
        <style type="text/css">
            table {width: 100%;}
            table th {text-align: left; vertical-align: bottom;}
            table tr {text-align: left; vertical-align: top;}

            .hidden {display: none;}
        </style>
    </head>
    <body>
        <h1>Kinetic Cache Manager <a href="<%=request.getContextPath()%>/CacheManager">Refresh</a></h1>

        <table>
            <tr>
                <td colspan="*"><h3>Caches</h3></td>
            </tr>
            <tr>
                <th>Cache</th>
                <th>(Not Implemented)<br/>Average Access Time</th>
                <th>(Not Implemented)<br/>Average Retrieval Time</th>
                <th>Count</th>
                <th>(Not Implemented)<br/>Size</th>
            </tr>
            <tr>
                <td><a href="<%=request.getContextPath()%>/CacheManager?cache=catalog">Catalog Cache</a></td>
                <td><%= CatalogCache.getAverageAccessTime() %> (<%=CatalogCache.getTotalAccessTime()%>/<%=CatalogCache.getTotalAccessCount()%>)</td>
                <td><%= CatalogCache.getAverageRetrievalTime() %> (<%=CatalogCache.getTotalAccessTime()%>/<%=CatalogCache.getTotalAccessCount()%>)</td>
                <td><%= CatalogCache.getCount() %></td>
                <td><%= CatalogCache.getSize() %></td>
            </tr>
            <tr>
                <td><a href="<%=request.getContextPath()%>/CacheManager?cache=dataset">Dataset Cache</a></td>
                <td><%= DatasetCache.getAverageAccessTime() %> (<%=DatasetCache.getTotalAccessTime()%>/<%=DatasetCache.getTotalAccessCount()%>)</td>
                <td><%= DatasetCache.getAverageRetrievalTime() %> (<%=DatasetCache.getTotalAccessTime()%>/<%=DatasetCache.getTotalAccessCount()%>)</td>
                <td><%= DatasetCache.getCount() %></td>
                <td><%= DatasetCache.getSize() %></td>
            </tr>
            <tr>
                <td><a href="<%=request.getContextPath()%>/CacheManager?cache=template">Template Cache</a></td>
                <td><%= TemplateCache.getAverageAccessTime() %> (<%=TemplateCache.getTotalAccessTime()%>/<%=TemplateCache.getTotalAccessCount()%>)</td>
                <td><%= TemplateCache.getAverageRetrievalTime() %> (<%=TemplateCache.getTotalAccessTime()%>/<%=TemplateCache.getTotalAccessCount()%>)</td>
                <td><%= TemplateCache.getCount() %></td>
                <td><%= TemplateCache.getSize() %></td>
            </tr>
            <tr>
                <td><a href="<%=request.getContextPath()%>/CacheManager?cache=page">Template Page Cache</a></td>
                <td><%= PageCache.getAverageAccessTime() %> (<%=PageCache.getTotalAccessTime()%>/<%=PageCache.getTotalAccessCount()%>)</td>
                <td><%= PageCache.getAverageRetrievalTime() %> (<%=PageCache.getTotalAccessTime()%>/<%=PageCache.getTotalAccessCount()%>)</td>
                <td><%= PageCache.getCount() %></td>
                <td><%= PageCache.getSize() %></td>
            </tr>
            <tr>
                <td colspan="*"><h3>Temporary Caches</h3></td>
            </tr>
            <tr>
                <th>Cache</th>
                <th>(Not Implemented)<br/>Average Access Time</th>
                <th>(Not Implemented)<br/>Average Retrieval Time</th>
                <th>Count</th>
                <th>(Not Implemented)<br/>Size</th>
            </tr>
            <tr>
                <td><a href="<%=request.getContextPath()%>/CacheManager?cache=answer">Answer Cache</a></td>
                <td><%= AnswerCache.getAverageAccessTime() %> (<%=AnswerCache.getTotalAccessTime()%>/<%=AnswerCache.getTotalAccessCount()%>)</td>
                <td><%= AnswerCache.getAverageRetrievalTime() %> (<%=AnswerCache.getTotalAccessTime()%>/<%=AnswerCache.getTotalAccessCount()%>)</td>
                <td><%= AnswerCache.getCount() %></td>
                <td><%= AnswerCache.getSize() %></td>
            </tr>
        </table>
    </body>
</html>
