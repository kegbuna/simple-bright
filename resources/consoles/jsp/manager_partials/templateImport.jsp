<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="migConstants" scope="request" class="com.kd.kineticSurvey.migration.MigrationConstants" />
<jsp:useBean id="remedyHandler" scope="request" class="com.kd.kineticSurvey.impl.RemedyHandler" />
<%
        String importFile = (String) session.getAttribute("importFile");
        session.removeAttribute("importFile");
        session.removeAttribute("importSession");
        String overwriteMsg = migConstants.TEMPLATE_EXISTS_OVERWRITE_MSG;
%>

<script type="text/javascript">
    // get the jsp variables and pass to javascript
    var obj = {};
    obj.overwriteMsg = "<%= overwriteMsg%>";
    YAHOO.util.Event.onContentReady('importUploadForm', KD.consoles.Import.init, obj);
</script>
<div id="import">
    <div class="wrapper">
        <h3>Import Template</h3>
        <div class="window" id="importUpload">
            <form id="importUploadForm" method="post" enctype="multipart/form-data" action="ImportTemplate" accept-charset="UTF-8">
                <input type="hidden" name="overwriteConfirm" id="overwriteConfirm" value=""/>
                <ul>
                    <li class="light">
                        <label for="UploadFileName" id="UploadFileNameLabel">Template Import File</label>
                        <input type="file" accept=".zip" name="UploadFileName" id="UploadFileName" />
                    </li>
                    <li class="dark">
                        <input type="checkbox" value="true" name="ResetCreateDate" id="ResetCreateDate">
                        <label for="ResetCreateDate">Use current time for new records? (default uses the Create Date specified in the import file)</label>
                    </li>
                    <li class="light">
                        <span id="importSubmitContainer">
                            <input type="button" name="Submit" id="importSubmit" value="Import" onclick="KD.consoles.Import.getUploadSessionId();"/>
                        </span>
                        <span id="importConfirmContainer" style="display:none;">
                            <input type="button" name="Confirm" id="importConfirm" value="Overwrite Existing Template" onclick="KD.consoles.Import.confirmImport();"/>
                            <input type="button" name="Cancel" id="importCancel" value="Cancel" onclick="KD.consoles.Import.clearFile();"/>
                        </span>
                        <span id="importWait" style="display:none;">Please wait, importing files...&nbsp;<img src='resources/loading.gif'/></span>
                    </li>
                </ul>
            </form>
        </div>
    </div>
    <div id="importTemplateMessages"></div>
</div>