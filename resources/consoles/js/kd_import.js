/*
Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/
/**
 * This file is to be used for importing templates through
 * the Administrator Console in Kinetic Survey and Kinetic Request.
 * @module kd_templateimport
 *
 */

// setup shortcuts
if (typeof Dom == "undefined") { Dom = YAHOO.util.Dom; }
if (typeof Connect == "undefined") { Connect = YAHOO.util.Connect; }

if (typeof KD == "undefined") { KD = {}; }
if (typeof KD.consoles == "undefined") { KD.consoles = {}; }


if (! KD.consoles.Import) {

    /**
     * Import CLASS
     */
    KD.consoles.Import = (function() {

        // common variables
        var uploadFile = null,
            theForm = null,
            resetCreateDate = null;

        // variables from the jsp
        var oJspVars = {};
    
        // import administration function
        var functions = {
            /**
             * Initialize variables sent from the JSP page, and all other
             * common variables used in multiple functions.
             * @param o object containing jsp variables
             */
            init : function (o) {
                if (o) {
                    oJspVars = o;
                }
                uploadFile = Dom.get('UploadFileName');
                theForm = Dom.get('importUploadForm');
                resetCreateDate = Dom.get('ResetCreateDate');
            },
            getUploadSessionId : function () {
                if (KD.consoles.Import.getUploadFile()) {
                    Dom.get('importTemplateMessages').innerHTML = "";
                    KD.consoles.Import.submitForm(theForm);
                }
                return true;
            },
            getUploadFile : function () {
                if (uploadFile.value == null || uploadFile.value == "") {
                    alert("Please upload a zip file before continuing the import");
                    return false;
                }
                return true;
            },
            confirmImport : function () {
                if (confirm("Are you sure you want to overwrite the existing template?")) {
                    uploadFile.disabled = false;
                    resetCreateDate.disabled = false;
                    Dom.get('overwriteConfirm').value = "Confirm Overwrite";
                    KD.consoles.Import.getUploadSessionId();
                }
            },
            checkConfirmRequired : function () {
                var importErrorMsg = Dom.get('importTemplateMessages');
                if (importErrorMsg && importErrorMsg.innerHTML.length > 0) {
                    if (importErrorMsg.innerHTML.match(/WARNING/)) {
                        Dom.setStyle('importSubmitContainer', 'display', 'none');
                        Dom.setStyle('importConfirmContainer', 'display', 'inline');
                        uploadFile.disabled = true;
                        resetCreateDate.disabled = true;
                    } else {
                        KD.consoles.Import.resetForm();
                    }
                } else {
                    KD.consoles.Import.resetForm();
                }
            },
            checkSession : function() {
                KD.utils.ClientManager.checkSession(true);
                var response = KD.utils.ClientManager.sessionCheck;
                if (response.status !== 200) {
                    var message = response.statusText;
                    if (response.getResponseHeader != null && response.getResponseHeader['X-Error-Message'] != null){
                        message = response.getResponseHeader['X-Error-Message'];
                    }
                    KD.utils.ClientManager.registerInvalidSessionRequest('KINETIC_SR_TEMPLATE_IMPORT', null, null, null);
                    KD.utils.Action.handleHttpErrorCode(response.status, message);
                    return false;
                }
                return true
            },
            submitForm : function(theForm) {
                // check if session is still valid
                if (!KD.consoles.Import.checkSession()) { return; }

                // disable submit buttons
                var elements = theForm.getElementsByTagName('input');
                for (var i = 0; i < elements.length; i += 1) {
                    if (elements[i].getAttribute("type").toLowerCase() == "button") {
                        elements[i].disabled = true;
                    }
                }
                // show the 'importing - please wait' message
                Dom.setStyle('importWait', 'display', 'inline');
                
                var uploadHandler = {
                    upload: function(o) {
                        KD.consoles.Import.finishTemplateImport(o);
                    }
                };

                Connect.initHeader("X-Requested-With", "XMLHttpRequest");
                // indicate this is a file upload - second parameter
                Connect.setForm(theForm, true);
                Connect.asyncRequest('POST', 'ImportTemplate', uploadHandler);
            },
            finishTemplateImport : function(o) {
                // display the results
                Dom.get('importTemplateMessages').innerHTML = o.responseXML.body.innerHTML;

                // clear the overwrite confirm answer
                Dom.get('overwriteConfirm').value = "";

                // if the servlet is waiting for the user to confirm, hide the
                // import button and display the confirm/cancel buttons
                KD.consoles.Import.checkConfirmRequired();

                // hide the 'importing - please wait' message
                Dom.setStyle('importWait', 'display', 'none');

                // enable submit buttons
                var elements = theForm.getElementsByTagName('input');
                for (var i = 0; i < elements.length; i += 1) {
                    if (elements[i].getAttribute("type").toLowerCase() == "button") {
                        elements[i].disabled = false;
                    }
                }
            },
            clearFile : function () {
                Dom.get('importTemplateMessages').innerHTML = "";
                KD.consoles.Import.resetForm();
            },
            resetForm : function () {
                Dom.setStyle('importConfirmContainer', 'display', 'none');
                Dom.setStyle('importSubmitContainer', 'display', 'inline');
                uploadFile.form.reset();
                uploadFile.disabled = false;
                resetCreateDate.disabled = false;
            }
        };
    
        return functions;
    })();
}