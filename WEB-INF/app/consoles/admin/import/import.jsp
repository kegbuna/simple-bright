<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.kd.kineticSurvey.migration.MigrationConstants,com.kineticdata.ksr.web.CsrfToken"%>
<%
    String importFile = (String) session.getAttribute("importFile");
    session.removeAttribute("importFile");
    session.removeAttribute("importSession");
    String overwriteMsg = MigrationConstants.TEMPLATE_EXISTS_OVERWRITE_MSG;
%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<link href="<%=request.getContextPath()+"/app/resources/css/importOverwrite.css"%>" rel="stylesheet" type="text/css"/>
<script src="<%= request.getContextPath()+"/resources/js/yui/build/yahoo-dom-event/yahoo-dom-event.js" %>" type="text/javascript"></script>
<script src="<%= request.getContextPath()+"/resources/js/yui/build/calendar/calendar-min.js" %>" type="text/javascript"></script>
<script src="<%= request.getContextPath()+"/resources/js/yui/build/connection/connection-min.js" %>" type="text/javascript"></script>
<script src="<%= request.getContextPath()+"/resources/js/kd_core.js" %>" type="text/javascript"></script>
<script src="<%= request.getContextPath()+"/app/resources/javascript/templateImport.js"%>" type="text/javascript"></script>
<script type="text/javascript">
    // get the jsp variables and pass to javascript
    var obj = { overwriteMsg: "<%= overwriteMsg%>" };
    YAHOO.util.Event.onContentReady('importUploadForm', KD.consoles.Import.init, obj);
</script>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:application>
    <jsp:attribute name="title">Kinetic | Import</jsp:attribute>
    <jsp:attribute name="navigationCategory">Admin</jsp:attribute>
    <jsp:attribute name="content">
        <section class="content">
            <div class="container-fluid main-inner">
                <div class="row">
                    <div class="col-xs-2 sidebar">
                        <jsp:include page="/WEB-INF/app/consoles/_shared/leftNavigation/admin.jsp">
                            <jsp:param name="navigationItem" value="Import"/>
                        </jsp:include>
                    </div>
                    <div class="col-xs-10 tab-content">
                        <div class="tab-pane active fade in">
                            <div class="row">
                                <div class="col-xs-9">
                                    <div class="page-header">
                                        <h3>Import</h3>
                                    </div>
                                    <div class="tabContent">
                                        <div class="row active tab-pane fade in" id="importTab">
                                            <div class="col-xs-12">
                                                <div class="form">
                                                    <form id="importUploadForm" method="post" enctype="multipart/form-data" action="ImportTemplate" accept-charset="UTF-8">
                                                       <input type="hidden" name="<%=CsrfToken.REQUEST_PARAMETER_NAME%>" value="<%=session.getAttribute(CsrfToken.SESSION_ATTRIBUTE_NAME)%>" />
                                                       <input type="hidden" name="overwriteConfirm" id="overwriteConfirm" value=""/>
                                                        <ul class="list-unstyled">
                                                            <li>
                                                                <label for="UploadFileName" id="UploadFileNameLabel">Template Import File</label>
                                                                <input type="file" 
                                                                       accept="application/zip"
                                                                       name="UploadFileName" id="UploadFileName" />
                                                            </li>
                                                            <li style="margin:1em 0;">
                                                                <input type="checkbox" value="true" name="ResetCreateDate" id="ResetCreateDate">
                                                                <label for="ResetCreateDate">Use current time for new records? (default uses the Create Date specified in the import file)</label>
                                                            </li>
                                                            <li>
                                                                <div id="importErrorMessage"></div>
                                                            </li>
                                                            <li>
                                                                <span id="importSubmitContainer">
                                                                    <input type="button" class="btn btn-primary" name="Submit" id="importSubmit" value="Import" onclick="KD.consoles.Import.getUploadSessionId();"/>
                                                                </span>
                                                                <span id="importConfirmContainer" style="display:none;">
                                                                    <input type="button" class="btn btn-primary" name="Confirm" id="importConfirm" value="Overwrite Existing Template" onclick="KD.consoles.Import.confirmImport();"/>
                                                                    <input type="button" class="btn" name="Cancel" id="importCancel" value="Cancel" onclick="KD.consoles.Import.clearFile();"/>
                                                                </span>
                                                                <span id="importWait" style="display:none;">Please wait, importing files...&nbsp;<img src="<%=request.getContextPath()%>/app/resources/images/loading.gif"/></span>
                                                            </li>
                                                        </ul>
                                                    </form>
                                                </div>
                                                <div id="importSuccessMessage"></div>
                                            </div>
                                        </div>
                                    </div>
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