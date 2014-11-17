<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.kd.ksr.cache.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kinetic Cache Manager: Answer Cache</title>
        <style type="text/css">
            table {width: 100%;}
            table th {text-align: left; vertical-align: bottom;}
            table tr {text-align: left; vertical-align: top;}

            .hidden {display: none;}
        </style>
        <script type="text/javascript">
            function removeCacheItem(templateId, pageId, submissionId) {
                document.getElementById('templateId').value = templateId;
                document.getElementById('pageId').value = pageId;
                document.getElementById('submissionId').value = submissionId;
                document.forms["clearForm"].submit();
            }
        </script>
    </head>
    <body>
        <h1>Answer Cache <a href="<%=request.getContextPath()%>/CacheManager">Home</a> <a href="<%=request.getContextPath()%>/CacheManager?cache=answer">Refresh</a></h1>
        <h3>Note: This cache should remain empty except for the page submissions that are actively being processed.</h3>
        <form action="<%=request.getContextPath()%>/CacheManager" class="hidden" method="post" name="clearForm">
            <input id="action" name="action" type="hidden" value="removeCacheItem"/>
            <input id="cache" name="cache" type="hidden" value="answer"/>
            <input id="templateId" name="templateId" type="hidden"/>
            <input id="pageId" name="pageId" type="hidden"/>
            <input id="submissionId" name="submissionId" type="hidden"/>
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
                <td><%= AnswerCache.getAverageAccessTime() %> (<%=AnswerCache.getTotalAccessTime()%>/<%=AnswerCache.getTotalAccessCount()%>)</td>
                <td><%= AnswerCache.getAverageRetrievalTime() %> (<%=AnswerCache.getTotalAccessTime()%>/<%=AnswerCache.getTotalAccessCount()%>)</td>
                <td><%= AnswerCache.getCount() %></td>
                <td><%= AnswerCache.getSize() %></td>
            </tr>
        </table>

        <h2>Cache Items</h2>
        <table>
            <tr>
                <th>Submission</th>
                <th>Template</th>
                <th>Page</th>
                <th>Age</th>
                <th>Action</th>
            </tr>
            <% for (Map<String,String> attributeMap : (List<Map<String,String>>)request.getAttribute("pageMapList")) { %>
            <tr>
                <td><%= attributeMap.get("Submission Id") %></td>
                <td><%= attributeMap.get("Template Name") %> (<%= attributeMap.get("Template Id") %>)</td>
                <td><%= attributeMap.get("Page Name") %> (<%= attributeMap.get("Page Id") %>)</td>
                <td><%= attributeMap.get("Age") %>ms</td>
                <td><a href="javascript:void(0);" onclick="removeCacheItem('<%= attributeMap.get("Template Id") %>', '<%= attributeMap.get("Page Id") %>', '<%= attributeMap.get("Submission Id") %>');">Flush</a></td>
            </tr>
            <% } %>
        </table>
    </body>
</html>