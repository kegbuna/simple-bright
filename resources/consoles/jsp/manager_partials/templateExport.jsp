<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext" />

<%
String successMessage = (String)request.getAttribute("exportSuccessMessage");
String errorMessage = (String)request.getAttribute("exportErrorMessage");
// determine previously selected values for convenience
String selectedApplication = (String)request.getSession().getAttribute("selectedApplication");
if (selectedApplication == null) {
    selectedApplication = "";
}
String selectedCategoryId = (String)request.getSession().getAttribute("selectedCategoryId");
if (selectedCategoryId == null) {
    selectedCategoryId = "";
}
// determine if the category/catalog selection should be displayed
String categoryFormDisplay = (selectedApplication == null || selectedApplication.length() == 0) ? "none" : "block";
// determine the label for category/catalog based on the selected application
String categoryLabel = "";
if (selectedApplication.equalsIgnoreCase("Kinetic Request")) {
    categoryLabel = "Catalog";
}
if (selectedApplication.equalsIgnoreCase("Kinetic Survey")) {
    categoryLabel = "Category";
}
// determine if the template selection should be displayed
String templateFormDisplay = (selectedCategoryId == null || selectedCategoryId.length() == 0) ? "none" : "block";
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
            // changing the button properties causes the button to jump in IE
            // for some reason - this code moves it back.
            var origPos = button['getBoundingClientRect']();
            
            button.value = "Exporting...";
            button.disabled = true;
            var newPos = button['getBoundingClientRect']();
            button.style.top = (origPos['top'] - newPos['top'] - 16) + 'px';
            
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
<div id="export">
	<div class="wrapper">
		<h3>Export Template</h3>
		<div class="window">
            <ul>
                <li class="dark">
                   <form name="exportApplicationForm" method="post" action="ExportTemplate">
                        <label for="application">Application</label>
                        <select name="application" id="application" onchange="KD.consoles.Export.selectApplication(this.value);">
                            <option value=""></option>
                            <%=request.getSession().getAttribute("applicationOptions") %>
                        </select>
                        <input type="hidden" name="curActive" value="export"/>
                    </form>
                </li>
                <li class="light" style="display:<%=categoryFormDisplay%>">
                    <form id="exportCategoryForm" name="exportCategoryForm" method="post" action="ExportTemplate">
                        <label id="categoryLabel" for="categoryInstanceId"><%=categoryLabel%></label>
                        <select name="categoryInstanceId" id="categoryInstanceId" onchange="KD.consoles.Export.selectCategory(this.value);">
                            <option value=""></option>
                            <%=request.getSession().getAttribute("categoryOptions") %>
                        </select>
                        <input type="hidden" name="curActive" value="export"/>
                    </form>
                </li>
                <li class="dark noPad" style="display:<%=templateFormDisplay%>">
                    <form id="exportTemplateForm" name="exportTemplateForm" method="post" action="ExportTemplate">
                        <ul>
                            <li class="dark">
                                <label for="templateInstanceId">Template:</label>
                                <select name="templateInstanceId" id="templateInstanceId">
                                    <option value=""></option>
                                    <%=request.getSession().getAttribute("templateOptions") %>
                                </select>
                                <input type="hidden" name="ACTION" value="exportTemplate"/>
                            </li>
                            <li class="light">
                                <ul>
                                    <li>Options to include:</li>
                                    <li class="exportOpt">
                                        <input name="inclCategory" type="checkbox" class="checkbox" id="inclCategory" value="yes">
                                        <%=categoryLabel%> Definition
                                    </li>
                                    <li class="exportOpt">
                                        <input name="inclDataSet" type="checkbox" class="checkbox" id="inclDataSet" value="yes">
                                        Data Set
                                    </li>
                                    <li class="exportOpt">
                                        <input name="inclMsgTemplates" type="checkbox" class="checkbox" id="inclMsgTemplates" value="yes">
                                        Related Message Templates (by <%=categoryLabel%>)
                                    </li>
                                </ul>
                            </li>
                            <li class="dark">
                                <input class="button" type="submit" name="Submit" value="Export" onclick="KD.consoles.Export.exportTemplate(this);"/>
                            </li>
                        </ul>
                    </form>
                </li>
            </ul>
		</div>
	</div>
	<% if(!errorMessage.equals("")) { %>
		<div class="errorMessage">
			<img src="<%= request.getContextPath() %>/resources/consoles/images/Symbol Error.png"/>
			<%= errorMessage %>
		</div>
	<% } %>
	<% if(!successMessage.equals("")) { %>
		<div class="wrapper">
			<h3>Export Results</h3>
			<div class="window">
				<ul><li class="light"><%= successMessage %></li></ul>
			</div>
		</div>
	<% } %>
</div>