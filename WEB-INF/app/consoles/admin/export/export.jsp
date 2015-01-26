<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="userContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext" />
<%
userContext = (com.kd.kineticSurvey.beans.UserContext) session.getAttribute("UserContext");
// Make sure the user context messages are cleared
userContext.setSuccessMessage("");
userContext.setErrorMessage("");
session.setAttribute("UserContext", userContext);
// Get the messages
String sessionMessage = (String)session.getAttribute("message");
String sessionMessageType = (String)session.getAttribute("messageType");
// Clear the messages from the session
session.removeAttribute("message");
session.removeAttribute("messageType");

// list of applications
String applicationOptions = (String)session.getAttribute("applicationOptions");
// list of application categories / catalogs
String categoryOptions = (String)session.getAttribute("categoryOptions");
// list of templates
String templateOptions = (String)session.getAttribute("templateOptions");

// determine previously selected values for convenience
String selectedApplication = (String)session.getAttribute("selectedApplication");
if (selectedApplication == null) {
    selectedApplication = "";
}
String selectedCategoryId = (String)session.getAttribute("selectedCategoryId");
if (selectedCategoryId == null) {
    selectedCategoryId = "";
}
// determine if the category/catalog selection should be displayed
String categoryFormDisplay = selectedApplication.length() == 0 ? "none" : "block";
// determine the label for category/catalog based on the selected application
String categoryLabel = "";
if (selectedApplication.equalsIgnoreCase("Kinetic Request")) {
    categoryLabel = "Catalog";
}
if (selectedApplication.equalsIgnoreCase("Kinetic Survey")) {
    categoryLabel = "Category";
}
// determine if the template selection should be displayed
String templateFormDisplay = selectedCategoryId.length() == 0 ? "none" : "block";
%>

<!--[if lte IE 7]>
<style>
    div#export input.checkbox,
    div#export input.button {position:relative;top:-16px;}
</style>
<![endif]-->
<script>
    if(typeof KD==="undefined"){KD={};}
    if(typeof KD.consoles==="undefined"){KD.consoles={};}
    KD.consoles.Export = new function () {
        
        /* User selected an application */
        var selectApp = function (value) {
            document.exportApplicationForm.submit();
        };
        
        /* User selected a category or catalog */
        var selectCat = function (value) {
            document.exportCategoryForm.submit();
        };
        
        var exportTemplate = function (button) {
            button.value = "Exporting...";
            button.disabled = true;
            // show the 'importing - please wait' message
            document.getElementById("wait").style.display = "inline";
            // submit the form
            button.form.submit();
        };
        
        // return the functions that can be called
        return {
            selectApplication: selectApp,
            selectCategory: selectCat,
            exportTemplate: exportTemplate
        };
    };
</script>

<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<tag:application>
    <jsp:attribute name="title">Kinetic | Export</jsp:attribute>
    <jsp:attribute name="navigationCategory">Admin</jsp:attribute>
    <jsp:attribute name="content">
        <section class="content">
            <div class="container-fluid main-inner">
                <div class="row">
                    <div class="col-xs-2 sidebar">
                        <jsp:include page="/WEB-INF/app/consoles/_shared/leftNavigation/admin.jsp">
                            <jsp:param name="navigationItem" value="Export"/>
                        </jsp:include>
                    </div>
                    <div class="col-xs-10 tab-content">
                        <div class="tab-pane active fade in">
                            <div class="row">
                                <div class="col-xs-9">
                                    <div class="page-header">
                                        <h3>Export</h3>
                                    </div>
                                    <div class="tabContent">
                                        <div class="row active tab-pane fade in" id="exportTab">
                                            <div class="col-xs-12">
                                                <div class="form">
                                                    <form name="exportApplicationForm" method="post" action="ExportTemplate">
                                                         <input type="hidden" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>" />
                                                         <label for="application">Application</label>
                                                         <select name="application" class="form-control" id="application" onchange="KD.consoles.Export.selectApplication(this.value);">
                                                             <option value=""></option>
                                                             <%=applicationOptions%>
                                                         </select>
                                                     </form>
                                                </div>
                                                <div class="form" style="display:<%=categoryFormDisplay%>">
                                                    <form id="exportCategoryForm" name="exportCategoryForm" method="post" action="ExportTemplate">
                                                        <input type="hidden" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>" />
                                                        <label for="categoryInstanceId"><%=categoryLabel%></label>
                                                        <select name="categoryInstanceId" class="form-control" id="categoryInstanceId" onchange="KD.consoles.Export.selectCategory(this.value);">
                                                            <option value=""></option>
                                                            <%=categoryOptions%>
                                                        </select>
                                                    </form>
                                                </div>
                                                <div class="form" style="display:<%=templateFormDisplay%>">
                                                    <form id="exportTemplateForm" name="exportTemplateForm" method="post" action="ExportTemplate">
                                                        <input type="hidden" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>" />
                                                        <input type="hidden" name="ACTION" value="exportTemplate"/>
                                                        <label for="templateInstanceId">Template</label>
                                                        <select name="templateInstanceId" class="form-control" id="templateInstanceId">
                                                            <option value=""></option>
                                                            <%=templateOptions%>
                                                        </select>
                                                        <div style="margin:1em 0;padding:1em;border:2px solid #ddd;">
                                                            <h4>Options to include:</h4>
                                                            <ul class="list-unstyled">
                                                                <li>
                                                                    <input name="inclCategory" type="checkbox" class="" id="inclCategory" value="yes">
                                                                    <label for="inclCategory"><%=categoryLabel%> Definition</label>
                                                                </li>
                                                                <li>
                                                                    <input name="inclDataSet" type="checkbox" class="" id="inclDataSet" value="yes">
                                                                    <label for="inclDataSet">Data Set</label>
                                                                </li>
                                                                <li>
                                                                    <input name="inclMsgTemplates" type="checkbox" class="" id="inclMsgTemplates" value="yes">
                                                                    <label for="inclMsgTemplates">Related Message Templates (by <%=categoryLabel%>)</label>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        <input class="btn btn-primary" type="submit" name="Submit" value="Export" onclick="KD.consoles.Export.exportTemplate(this);"/>
                                                        <span id="wait" style="display:none;">Please wait, exporting files...&nbsp;<img src="<%=request.getContextPath()%>/app/resources/images/loading.gif"/></span>
                                                    </form>
                                                </div>
                                                <%@include file="exportMessage.jspf" %>
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