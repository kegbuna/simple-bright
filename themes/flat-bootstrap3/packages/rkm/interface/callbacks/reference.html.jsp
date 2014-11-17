<%@page contentType="text/html; charset=UTF-8"%>

<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else if (articleType.equals("Reference"))
    {
        String articleId = request.getParameter("articleId");
        Reference reference = Reference.findById(serverUser, articleId);
%>
<div class="article">
    <% if (reference.getReference() != null) { %>
    <div class="field">
        <div class="label">Reference</div>
        <div class="value"><%= reference.getReference() %></div>
    </div>
    <% } %>
</div>
<%
   }
%>