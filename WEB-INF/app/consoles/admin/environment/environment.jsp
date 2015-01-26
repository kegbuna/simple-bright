<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<% 
    Map<String,Map<String,Object>> environmentInfo = (Map<String,Map<String,Object>>)request.getAttribute("environmentInfo");
%>
<tag:application>
    <jsp:attribute name="title">Kinetic | Environment</jsp:attribute>
    <jsp:attribute name="navigationCategory">Admin</jsp:attribute>
    <jsp:attribute name="content">
        <section class="content">
            <div class="container-fluid main-inner">
                <div class="row">
                    <div class="col-xs-2 sidebar">
                        <jsp:include page="/WEB-INF/app/consoles/_shared/leftNavigation/admin.jsp">
                            <jsp:param name="navigationItem" value="Environment"/>
                        </jsp:include>
                    </div>
                    <div class="col-xs-10 tab-content">
                        <div class="tab-pane active fade in">
                            <div class="row">
                                <div class="col-xs-9">
                                    <div class="page-header">
                                        <h3>Environment</h3>
                                    </div>
                                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                                    <% for (Map.Entry<String,Map<String,Object>> infoGroup : environmentInfo.entrySet()) { %>
                                    <h4><%=escape(infoGroup.getKey())%></h4>
                                    <dl class="dl-horizontal dl-stripe">
                                        <% for (Map.Entry<String,Object> infoItem : infoGroup.getValue().entrySet()) { %>
                                            <dt><%=escape(infoItem.getKey())%></dt>
                                            <% if (infoItem.getValue() instanceof String[]) { %>
                                                <% String[] values = (String[])infoItem.getValue(); %>
                                                <% for (int i=0;i<values.length;i++) { %>
                                                <dd<%=(i==0) ? " class=\"primaryEnvValue\"" : ""%>>
                                                    <%=escape(values[i])%>
                                                </dd>
                                                <% } %>
                                            <% } else { %>
                                            <dd><%=escape(infoItem.getValue())%></dd>
                                            <% } %>
                                        <% } %>
                                    </dl>
                                    <% } %>
                                </div>
                                <div class="col-xs-3 sidebar pull-right">
                                    <jsp:include page="/WEB-INF/app/consoles/_shared/help.jsp">
                                        <jsp:param name="helpType" value="Admin Consoles" />
                                        <jsp:param name="helpUrl" value="http://help.kineticdata.com/ksr52/consoles/admin" />
                                    </jsp:include>
                                    <jsp:include page="_helpText.jsp"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </jsp:attribute>
</tag:application>