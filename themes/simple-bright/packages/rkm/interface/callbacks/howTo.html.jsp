<%@page contentType="text/html; charset=UTF-8"%>

<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else if (articleType.equals("HowTo"))
    {
        String articleId = request.getParameter("articleId");
        HowTo howTo = HowTo.findById(serverUser, articleId);
%>
<div class="article">
    <% if (howTo.getQuestion() != null) { %>
    <div class="field">
        <div class="label">Question</div>
        <div class="value"><%= howTo.getQuestion() %></div>
    </div>
    <% } %>
    <% if (howTo.getAnswer() != null) { %>
    <div class="field">
        <div class="label">Answer</div>
        <div class="value"><%= howTo.getAnswer() %></div>
    </div>
    <% } %>
    <% if (howTo.getTechnicalNotes() != null) { %>
    <div class="field">
        <div class="label">Technical Notes</div>
        <div class="value"><%= howTo.getTechnicalNotes() %></div>
    </div>
    <% } %>
</div>
<%
   }
%>