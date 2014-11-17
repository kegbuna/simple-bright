/*
Copyright (c) 2012, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/

// setup shortcuts
if (typeof Dom == "undefined") {
    Dom = YAHOO.util.Dom;
}

if (typeof Connect == "undefined") {
    Connect = YAHOO.util.Connect;
}

if (typeof KD == "undefined") {
    KD = {};
}

if (typeof KD.utils == "undefined") {
    KD.utils = {};
}

if (!KD.utils.Action) {

    /**
     * Action methods used in Kinetic Survey and Kinetic Request
     * @namespace KD.utils
     * @class Action
     * @static
     */
    KD.utils.Action = new function () {
        /**
         * Allows a service item to be submitted without validating all required
         * questions have values, and all questions with pattern matches contain
         * answers with the appropriate format.
         * @property byPassValidation
         * @type Boolean
         * @default false
         */
        this.byPassValidation = false;

        /**
         * Defines the background color used for read-only input fields
         * @property readOnlyColor
         * @type String
         * @default #E0E0E0
         */
        this.readOnlyColor = "#E0E0E0";

        /**
         * Defines the color used to highlight questions that failed validation
         * @property highlightColor
         * @type String
         * @default #FF0000
         */
        this.highlightColor = "#FF0000";

        /**
         * Holds SimpleDataRequest errors so they don't get shown again and again
         * when a connection goes down or for authentication.
         * Gets cleared as soon as a successful SDR is processed.
         * @property sdrErrors
         * @type Array
         */
        this.sdrErrors = null;


        /**
         * Validates the JSON library is loaded.  If not, displays an alert message
         * and throws an exception to halt processing.
         * @method validateJsonLoaded
         * @return void
         */
        this.validateJsonLoaded = function () {
            if (typeof YAHOO.lang.JSON === "undefined") {
                var eMsg = "The YUI JSON library is required for locking.  Please add it to your display page.";
                alert(eMsg);
                throw(eMsg);
            }
        };

        /**
         * Removes an element from the display of the page.  The space that this
         * element occuppied on the page will also be removed causing any lower
         * elements to shift up.
         * Uses the CSS property display:none;
         * @method removeElement
         * @param {String} label The instanceID of the element (GUID) or the label of the element.
         * @param {Boolean} keepValue (optional) Whether or not to clear the value of the question when removed.  Defaults to false.
         * @return void
         */
        this.removeElement = function (label, keepValue) {
            // default the label as the first argument
            var label_id = label;
            var isOptional = false;
            // if the argument is an array, the label id is the first item, and
            // the second item indicates whether the element should also be
            // made optional
            if (label.constructor == Array) {
                label_id = label[0];
                isOptional = label[1];
            }
            var qLayer=KD.utils.Util.getElementObject(label_id);
            if(qLayer){
                if(!keepValue){
                    var theEls=KD.utils.Util.getElementsByClassName('answerValue','*',qLayer);
                    for(var i=0;i<theEls.length;i++){
                        KD.utils.Action.setQuestionValue(KD.utils.Util.getIDPart(theEls[i].id),"$\NULL$");
                    }
                }
                qLayer.style.display="none";
                if (isOptional) {
                    KD.utils.Action.makeQuestionOptional(label_id);
                }
            }
        };

        /**
         * Inserts an element into the display of the page.  Elements below this
         * element will shift downward.
         * Uses the CSS property display:block;
         * @method insertElement
         * @param {String} label The instanceID of the element (GUID) or the label of the element.
         * @return void
         */
        this.insertElement = function (label) {
            /* default the label as the first argument */
            var label_id = label;
            var isRequired = false;
            /* if the argument is an array, the label id is the first item,
             * and the second item indicates whether the element should also be
             * made required
             */
            if (label.constructor == Array) {
                label_id = label[0];
                isRequired = label[1];
            }
            var qLayer=KD.utils.Util.getElementObject(label_id);
            if(qLayer){
                //If element is hidden, setting display to block still won't show element, need to set it.
                var visib=Dom.getStyle(qLayer, 'visibility');
                if(visib && visib.toUpperCase() == "HIDDEN"){
                    qLayer.style.visibility="visible";
                }
                //inserting only divs, so default to block. Will then override any style=none that may be in the css.
                qLayer.style.display="block";
                if (isRequired) {
                    KD.utils.Action.makeQuestionRequired(label_id);
                }
            }
        };

        /**
         * Hides an element on the page.  The element will still retain its
         * position on the page (leaving a blank space).
         * Uses the CSS property visibility:hidden;
         * @method hideElementInPlace
         * @param {String} label The instanceID of the element (GUID) or the label of the element.
         * @param {Boolean} keepValue (optional) true to keep field values when hidden, false to clear field values when hidden.
         * @return void
         */
        this.hideElementInPlace = function (label, keepValue) {
            /* default the label as the first argument */
            var label_id = label;
            var isOptional = false;
            /* if the argument is an array, the label id is the first item,
             * and the second item indicates whether the element should also be
             * made optional
             */
            if (label.constructor == Array) {
                label_id = label[0];
                isOptional = label[1];
            }
            var qLayer=KD.utils.Util.getElementObject(label_id);
            if(qLayer){
                if(!keepValue){
                    var theEls=KD.utils.Util.getElementsByClassName('answerValue','*',qLayer);
                    for (var i = 0; i < theEls.length; i++) {
                        KD.utils.Action.setQuestionValue(KD.utils.Util.getIDPart(theEls[i].id), "$\NULL$");
                    }
                }
                qLayer.style.visibility="hidden";
                if (isOptional) {
                    KD.utils.Action.makeQuestionOptional(label_id);
                }
            }
        };

        /**
         * Show an element on the page.  The element will still retain its position on the page.
         * Uses the CSS property visibility:inherit;
         * @method showElementInPlace
         * @param {String} label The instanceID of the element (GUID) or the label of the element.
         * @return void
         */
        this.showElementInPlace = function (label) {
            /* default the label_id as the first argument */
            var label_id = label;
            var isRequired = false;
            /* if the argument is an array, the label id is the first item,
             * and the second item indicates whether the element should also be
             * made required
             */
            if (label.constructor == Array) {
                label_id = label[0];
                isRequired = label[1];
            }
            var qLayer=KD.utils.Util.getElementObject(label_id);
            if (qLayer) {
                qLayer.style.visibility="inherit";
                if (isRequired) {
                    KD.utils.Action.makeQuestionRequired(label_id);
                }
            }
        };

        /**
         * Cross-browser function to add an event listener to an element.
         * @method addListener
         * @param {HTMLElement} object The DOM object to add the listener to.
         * @param {String} triggerEvent The event to fire (blur, focus, load, etc.)
         * @param {Function} fnctn The function to call when the event is fired
         * @return void
         */
        this.addListener = function (object, triggerEvent, fnctn) {
            YAHOO.util.Event.addListener(object, triggerEvent, fnctn);
        };

        /**
         * Highlight a question label. Typically used for a required field not
         * filled in, or pattern not matching.
         * @method highlightField
         * @param {HTMLElement} answerField The answer element for the question
         * @return void
         */
        this.highlightField = function (answerField) {
            var type = KD.utils.Util.getAnswerType(answerField);
            var answerFieldDiv = answerField.parentNode;
            KD.utils.Util.addClass(answerFieldDiv, 'requiredField');
            KD.utils.Util.addClass(answerFieldDiv, 'requiredField_' + type);

            //Use label so it is safe for checkboxes
            var labelObj=KD.utils.Util.getQuestionLabel(KD.utils.Util.getLabelFromAnswerEl(answerField));
            if (labelObj) {
                KD.utils.Util.addClass(labelObj, 'requiredLabel');
                KD.utils.Util.addClass(labelObj, 'requiredLabel_' + type);

                var origColor=labelObj.getAttribute("origStyleColor");
                if(origColor==null || origColor == ""){
                    labelObj.setAttribute("origStyleColor", (labelObj.style.color)?labelObj.style.color:"defaultColor");
                    labelObj.style.color = KD.utils.Action.highlightColor;
                }
            }
        };

        /**
         * Removes the highlighting from a question label, usually done after a
         * required field/pattern highlighting occurs.
         * @method resetRequiredField
         * @param {HTMLElement} answerField The answer element
         * @return void
         */
        this.resetRequiredField = function (answerField) {
            var type = KD.utils.Util.getAnswerType(answerField);
            var answerFieldDiv = answerField.parentNode;
            KD.utils.Util.removeClass(answerFieldDiv, 'requiredField');
            KD.utils.Util.removeClass(answerFieldDiv, 'requiredField_' + type);

            var labelObj=KD.utils.Util.getQuestionLabel(KD.utils.Util.getLabelFromAnswerEl(answerField));
            if(labelObj){
                KD.utils.Util.removeClass(labelObj, 'requiredLabel');
                KD.utils.Util.removeClass(labelObj, 'requiredLabel_' + type);

                var origStyle = labelObj.getAttribute("origStyleColor");
                if (origStyle=="defaultColor"){
                    origStyle = "";
                }
                labelObj.style.color = origStyle;
                labelObj.removeAttribute("origStyleColor");
            }
        };

        /**
         * Retrieves the errorValue attribute of a question. Falls back to the
         * question label if no required label is set.
         * This is the error message for a required field created for the question.
         * @method getErrorValue
         * @param {HTMLElement} answerField The answer element
         * @return {String} the errorValue attribute for the question
         */
        this.getErrorValue = function (answerField) {
            var errorVal = answerField.getAttribute("errorValue");
            if (errorVal == null || errorVal=="") {
                var labelObj=KD.utils.Util.getQuestionLabel(KD.utils.Util.getLabelFromAnswerEl(answerField));
                if (labelObj != null ){
                    // get the question label value
                    errorVal = KD.utils.Util.getQuestionLabelValue(labelObj);
                    if (errorVal == null || errorVal == "") {
                        // get the question menu label
                        errorVal= labelObj.getAttribute("label");
                    }
                }
            }
            return errorVal;
        };

        /**
         * Simply mimics the click event of a radio button question.
         * @method mimicRadioClick
         * @param {String} elementId The survey question Id (Example 'SRVQSTN_KS234234234')
         * @param {Number} elIndex The index (zero based) of the radio button to click.
         * @return void
         */
        this.mimicRadioClick = function (elementId, elIndex) {
            var myRadioElements=document.getElementsByName(elementId);
            myRadioElements[elIndex].click();
        };

        /**
         * Watch the length of a textarea field and stop the typing if longer
         * than desired length.  Automatically used for TEXTAREA fields which
         * have a max char value.
         * @method watchFieldLength
         * @param {HTMLElement} el The question element
         * @return void
         */
        this.watchFieldLength = function (el) {
            var limit=el.getAttribute("maxlength");
            if(limit){
                limit=parseInt(limit);
            } else{
                return;
            }
            if(el.value && el.value.length>limit){
                el.value=el.value.substring(0,limit);
            }
        };

        /**
         * INTERNAL USE ONLY
         * Loads the previous page in the request by first bypassing validation,
         * setting the form action to "PreviousPage", and then submitting the form.
         * @method loadPreviousPage
         * @private
         * @return void
         */
        this.loadPreviousPage = function () {
            var valid = true;

            // if authentication is required, check if session is still valid
            if (KD.utils.ClientManager.isAuthenticationRequired === "true") {
                KD.utils.Action.byPassValidation=true;

                // check if session is still valid
                KD.utils.ClientManager.checkSession();
                var response = KD.utils.ClientManager.sessionCheck;
                if (response.status !== 200) {
                    var message = response.statusText;
                    if (response.getResponseHeader != null && response.getResponseHeader['X-Error-Message'] != null){
                        message = response.getResponseHeader['X-Error-Message'];
                    }
                    KD.utils.ClientManager.registerInvalidSessionRequest("PREV_PAGE_REQUEST","", "", "");
                    KD.utils.Action.handleHttpErrorCode(response.status, message);
                    valid = false;
                }
            }

            /*Reset the buttons*/
            if(!valid){
                for (var i=0; i < KD.utils.ClientManager.submitButtons.length; i++) {
                    KD.utils.Action.enableButton(KD.utils.ClientManager.submitButtons[i]);
                }
                KD.utils.ClientManager.isSubmitting=false;
                return;
            }

            document.pageQuestionsForm.action = "PreviousPage";
            this.byPassValidation=true;
            document.pageQuestionsForm.submit();
        };

        /**
         * Validates all required questions have non-blank answers, and that all
         * pattern validation questions have the correct format if they contain
         * answers.
         * If any questions contain a problem, the form is not submitted, and the
         * user is presented with an alert describing the problems.  Questions with
         * problems are also highlighted so they can easily be distinguished.
         * @method validateForm
         * @param {Event} evt The event that triggered this function
         * @param {HTMLElement} form The DOM form element that contains all the page questions.
         * @return {Boolean} True if all questions are filled in correctly, else false.
         */
        this.validateForm = function (evt, form) {
            var trigger=YAHOO.util.Event.getTarget(evt);
            var pageId=Dom.get("pageID").value;
            var valid=true;
            var clientAction, fn;

            //Only allow submit from buttons, not returns
            if(!trigger.type  || (trigger.type && trigger.type.toUpperCase()!="BUTTON" && trigger.type.toUpperCase()!="SUBMIT")){
                try {
                    YAHOO.util.Event.stopEvent(evt);
                } catch (e) {}

                KD.utils.ClientManager.isSubmitting=false;
                return false;
            }

            if (KD.utils.Action.byPassValidation) {return true;}

            //check beforeSubmit actions
            var actions=KD.utils.ClientManager.customEvents.getItem(pageId+"-beforeSubmit");
            if(actions && actions.length >0){
                for(var k=0; k < actions.length; k++){
                    clientAction=actions[k];
                    fn=clientAction.action;
                    valid=fn.call(evt, evt, clientAction);
                    if(valid == null){
                        valid=true;
                    }
                    if(valid==false){
                        try {
                            YAHOO.util.Event.stopEvent(evt);
                        } catch (e) {}

                        //re-enable submit button(s)
                        for(var i=0; i < KD.utils.ClientManager.submitButtons.length; i++){
                            KD.utils.Action.enableButton(KD.utils.ClientManager.submitButtons[i]);
                        }
                        KD.utils.ClientManager.isSubmitting=false;
                        return false;
                    }
                }
            }
            valid=KD.utils.Action.validateFields(form.elements);
            //check submit actions
            if(valid){
                var submitActions=KD.utils.ClientManager.customEvents.getItem(pageId+"-submit");
                if(submitActions && submitActions.length >0){
                    for(var m=0; m < submitActions.length; m++){
                        clientAction=submitActions[m];
                        fn=clientAction.action;
                        valid=fn.call(evt, evt, clientAction);
                        if(valid == null){
                            valid=true;
                        }
                        if (valid == false){
                            break;
                        }
                    }
                }
            }
            /*Do session check*/
            if (valid) {
                // if authentication is required, check if session is still valid
                if (KD.utils.ClientManager.isAuthenticationRequired === "true") {
                    // check if session is still valid
                    KD.utils.ClientManager.checkSession();
                    var response = KD.utils.ClientManager.sessionCheck;
                    if (response.status !== 200) {
                        var message = response.statusText;
                        if (response.getResponseHeader != null && response.getResponseHeader['X-Error-Message'] != null){
                            message = response.getResponseHeader['X-Error-Message'];
                        }
                        KD.utils.ClientManager.registerInvalidSessionRequest("NEXT_PAGE_REQUEST","", "", "");
                        KD.utils.Action.handleHttpErrorCode(response.status, message);
                        valid = false;
                    }
                }
            }
            /*Reset the buttons*/
            if(!valid){
                try {
                    YAHOO.util.Event.stopEvent(evt);
                } catch (e) {}

                for (i = 0; i < KD.utils.ClientManager.submitButtons.length; i++) {
                    KD.utils.Action.enableButton(KD.utils.ClientManager.submitButtons[i]);
                }
                KD.utils.ClientManager.isSubmitting=false;
            }
            //If submitted from a non-submit button, do the submit
            if (valid && trigger.type && trigger.type.toUpperCase()=="BUTTON") {
                KD.utils.Action._clearTransientFields(form);
                form.submit();
            }
            return valid;
        };

        /**
         * INTERNAL USE ONLY
         * Validate an array of fields for required & pattern.  Will pop an alert
         * and color the labels to red if not valid.
         * @method validateFields
         * @private
         * @param {Array} fieldsArray This should be an array of input/select/text/textarea elements,
         * not layer elements.
         * @return {Boolean} true if all fields are valid, else false
         */
        this.validateFields = function (fieldsArray) {
            var valid = true;
            var nextElement = null;
            var firstErrorElement = null;
            var requiredFieldList='';
            var formatFieldList='';
            var requiredWarning=KD.utils.ClientManager.requiredWarningStr;
            var formatWarning=KD.utils.ClientManager.validFormatWarningStr;
            var maxCharsOnSubmit=KD.utils.ClientManager.maxCharsOnSubmit;
            var characterCount=0;
            var disabledFields=new Array();
            var checkedFields=new Array();
            var checkboxFields={};
            var fieldPrefix = "<li>";
            var fieldSuffix = "</li>";

            // Process all required checkbox questions first, and store the parentId
            // to indicate if any of the children have been checked
            //
            for (var f=0; f < fieldsArray.length; f++) {
                var cb = fieldsArray[f].type && fieldsArray[f].type.toLowerCase()=="checkbox";
                if (cb) {
                    var cbChecked = fieldsArray[f].checked;
                    var reqAttr = fieldsArray[f].getAttribute("required");
                    if (reqAttr && reqAttr.toLowerCase()=="true") {
                        var cbParentId = KD.utils.Util.getCheckboxParentId(fieldsArray[f]);
                        if (cbParentId) {
                            var cbParentExists = typeof checkboxFields[cbParentId] !== "undefined"
                            // update if this is first child, or if parent isn't already checked
                            if (!cbParentExists || (cbParentExists && checkboxFields[cbParentId] == false)) {
                                checkboxFields[cbParentId] = fieldsArray[f].checked;
                            }
                        }
                    }
                }
            }

            for (var i = 0; i < fieldsArray.length; i++) {
                nextElement = fieldsArray[i];
                if(nextElement.disabled == true && nextElement.type && nextElement.type.toUpperCase() != "SUBMIT" && nextElement.type.toUpperCase()!= "BUTTON"){
                    disabledFields.push(nextElement);
                }

                // if the question is transient, skip validation for it
                if (KD.utils.Action._isTransient(nextElement)) {
                    continue;
                }

                var foundValue=false;

                if(nextElement.type=="radio" || nextElement.type=="checkbox"){
                    if (nextElement.checked){
                        characterCount += nextElement.value.length;
                        foundValue=true;
                    }
                } else if(nextElement.type!="button" && nextElement.value.length >0){
                    characterCount += nextElement.value.length;
                    foundValue=true;
                }

                if (foundValue) {
                    characterCount += nextElement.name.length+1;
                }

                if (nextElement.getAttribute("required") == 'true' && checkedFields[nextElement.name]!="true") {
                    checkedFields[nextElement.name]="true";

                    if (nextElement.tagName.toLowerCase() == 'select') {
                        if (nextElement.options.length == 0 || nextElement.selectedIndex == null || nextElement.value==""){

                            requiredFieldList += fieldPrefix + KD.utils.Action.getErrorValue(nextElement) + fieldSuffix;
                            if (firstErrorElement==null){
                                firstErrorElement=nextElement;
                            }
                            KD.utils.Action.highlightField(nextElement);
                            valid=false;
                        } else {
                            KD.utils.Action.resetRequiredField(nextElement);
                        }
                    }
                    else if (nextElement.type.toLowerCase()=='radio'){
                        var radioGroup=document.getElementsByName(nextElement.name);
                        var isChecked = false;
                        for (var j=0;j<radioGroup.length;j++){
                            if(radioGroup[j].checked==true){
                                isChecked=true;
                            }
                        }
                        if (isChecked==false){
                            if (firstErrorElement==null){
                                firstErrorElement=radioGroup[0];
                            }
                            KD.utils.Action.highlightField(radioGroup[0]);
                            requiredFieldList += fieldPrefix + KD.utils.Action.getErrorValue(radioGroup[0]) + fieldSuffix;
                            valid=false;
                        } else {
                            KD.utils.Action.resetRequiredField(radioGroup[0]);
                        }

                    }
                    else if (nextElement.type.toLowerCase()=="checkbox"){
                        cbParentId = KD.utils.Util.getCheckboxParentId(nextElement);
                        if (cbParentId && typeof checkedFields[cbParentId]=="undefined") {
                            if (checkboxFields[cbParentId] != true) {
                                if (firstErrorElement==null){
                                    firstErrorElement=nextElement;
                                }
                                KD.utils.Action.highlightField(nextElement);
                                requiredFieldList += fieldPrefix + KD.utils.Action.getErrorValue(nextElement) + fieldSuffix;
                                valid=false;
                            }
                            checkedFields[cbParentId]="true";
                        }
                        if (cbParentId && checkboxFields[cbParentId] == true) {
                            KD.utils.Action.resetRequiredField(nextElement);
                        }
                    }
                    else if ((!nextElement.value || nextElement.value.length < 1) && nextElement.type.toLowerCase() != "checkbox") {
                        if (firstErrorElement==null){
                            firstErrorElement=nextElement;
                        }
                        var isDate=false;
                        var myParent=nextElement.parentNode;
                        for (var iIdx=0; iIdx<myParent.children.length; iIdx++) {
                            if (myParent.children[iIdx].id != undefined && myParent.children[iIdx].id.indexOf("year_")!=-1){
                                KD.utils.Action.highlightField(myParent.children[iIdx]);
                                isDate=true;
                                break;
                            }
                        }
                        if (!isDate) {
                            KD.utils.Action.highlightField( nextElement);
                        }
                        requiredFieldList += fieldPrefix + KD.utils.Action.getErrorValue(nextElement) + fieldSuffix;
                        valid=false;
                        continue;
                    } else {
                        KD.utils.Action.resetRequiredField(nextElement);
                    }
                }
                if (nextElement.value.length > 0 && nextElement.getAttribute("validationFormat")) {
                    var expStr = nextElement.getAttribute("validationFormat");
                    var exp = new RegExp(expStr);
                    if (exp.test(nextElement.value)==false) {
                        KD.utils.Action.highlightField(nextElement);
                        var validationText = nextElement.getAttribute("validationText");
                        if (validationText) {
                            formatFieldList += fieldPrefix + validationText + fieldSuffix;
                        }
                        valid=false;
                    } else {
                        KD.utils.Action.resetRequiredField(nextElement);
                    }
                } else if ((nextElement.value.length == 0 && nextElement.getAttribute("required") != 'true') && nextElement.getAttribute("validationFormat")) {
                    KD.utils.Action.resetRequiredField(nextElement);
                }

                // ensure date type questions contain a valid date
                if(nextElement.name && nextElement.name.indexOf('SRVQSTN_') != -1){
                    var isDateField = KD.utils.Util.isDate(nextElement);
                    if(isDateField){
                        var validDate = KD.utils.Action.validateDateField(nextElement);
                        if(!validDate){
                            if (firstErrorElement==null){
                                firstErrorElement=nextElement;
                            }
                            KD.utils.Action.highlightField( nextElement);

                            // get the date field label
                            var label = "";
                            var labelObj=KD.utils.Util.getQuestionLabel(
                                KD.utils.Util.getLabelFromAnswerEl(nextElement));
                            if (labelObj && labelObj.getAttribute('label')) {
                                label = labelObj.getAttribute('label');
                            }

                            // add the date field to the format field list string
                            formatFieldList += fieldPrefix + label + " is not a valid date" + fieldSuffix;
                            valid=false;
                        } else {
                            KD.utils.Action.resetRequiredField(nextElement);
                        }
                    }
                }

            }
            if (!valid) {
                var errorStr = "";
                if (requiredFieldList) {
                    errorStr += "<div class='warningTitle'><h3>" + requiredWarning +
                        "</h3><ul>" + requiredFieldList + "</ul></div>";
                }
                if (formatFieldList) {
                    errorStr += "<div class='warningTitle'><h3>" + formatWarning +
                        "</h3><ul>" + formatFieldList + "</ul></div>";
                }

                // display the fields that failed validation
                KD.utils.ClientManager.alertPanel(
                    {
                        header: 'Form Validation Errors',
                        body: errorStr,
                        element: firstErrorElement
                    }
                );
                return false;
            }

            if (characterCount > maxCharsOnSubmit) {
                KD.utils.ClientManager.alertPanel(
                    {
                        header: 'Form Error',
                        body: KD.utils.ClientManager.tooManyCharactersForSubmitStr,
                        element: null
                    }
                );
                return false;
            }
            /* Enable disabled radio buttons/checkboxes so they submit */
            for (j=0; j < disabledFields.length; j++){
                // make sure the element is a question
                if (disabledFields[j].id.indexOf("SRVQSTN_") != -1) {
                    disabledFields[j].disabled=false;
                }
            }
            return true;
        };

        /**
         * Validates a date question contains a valid date value
         * @method validateDateField
         * @private
         * @param {HTMLElement} el question element to validate
         * @return {Boolean} True if value date, otherwise false
         */
        this.validateDateField = function (el) {
            var elValue, dtParts, yr, mn, dy, d1, h, m, s;

            // expected value format:  2008-04-24  --> March 24, 2008
            if (el && el.value && el.value != null && el.value != "") {
                elValue = el.value;
                dtParts = KD.utils.Util.parseDtString(elValue);

                yr = dtParts[0];
                mn = dtParts[1] - 1;
                dy = dtParts[2];
                if (dtParts.length > 3) {
                    // date/time question
                    h = dtParts[3];
                    m = dtParts[4];
                    s = dtParts[5];
                    d1 = new Date(yr, mn, dy, h, m, s, 0);
                    if (d1.getFullYear() != yr || d1.getMonth() != mn || d1.getDate() != dy ||
                        d1.getHours() != h || d1.getMinutes() != m || d1.getSeconds() != s) {
                        return false;
                    }
                } else {
                    // date question
                    d1 = new Date(yr, mn, dy);
                    if (d1.getFullYear() != yr || d1.getMonth() != mn || d1.getDate() != dy) {
                        return false;
                    }
                }
            }
            return true;
        };

        /**
         * Ensures that transient form elements are cleared before form submission.
         * @method _clearTransientFields
         * @private
         * @param {HTMLElement | String} form element or id of the form element
         * being submitted
         * @return void
         */
        this._clearTransientFields = function (form) {
            var i, els;

            form = Dom.get(form);
            els = form.elements;

            // ensure each transient field is cleared before submitting the form
            for (i = 0; i < els.length; i += 1) {
                if (KD.utils.Action._isTransient(els[i])) {
                    els[i].value = "";
                }
            }
        };

        /**
         * Detects if the element is transient
         * @method _isTransient
         * @private
         * @param {HTMLElement} el form element to test
         * @return { boolean } true if the element is transient
         */
        this._isTransient = function (el) {
            var attValue, attName = "transient", testValue = "transient";

            // ensure each transient field is cleared before submitting the form
            attValue = el.getAttribute(attName);
            return (attValue && attValue.toLowerCase() === testValue);
        };

        /**
         * Set the value of the Input element of the question
         * @method setQuestionValue
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @param {String | Array} value Depends on the question type, but most accept
         * a string value.  Date and Date/Time questions accept an array of date parts in the following order:
         * [yyyy, mm, dd] and [yyyy, mm, dd, hh, mm, ss] respectively.  Setting the
         * value to null, "undefined", "$\NULL$" or "$NULL$" will clear the value.
         * @return {Boolean} True if the value was set, else false
         */
        this.setQuestionValue = function (label_id, value) {
            return KD.utils.Util.setQuestionValue(label_id, value);
        };

        /**
         * Get the value of the Input element of the question
         * @method getQuestionValue
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @return {String} A string value of the question
         */
        this.getQuestionValue = function (label_id) {
            return KD.utils.Util.getQuestionValue(label_id);
        };

        /**
         * Change the appearance of the provided Question element to Read Only/disabled
         * depending on question type.  When the form is submitted, disabled objects
         * will be re-enabled so they can be posted.
         * @method setReadOnly
         * @param {String | HTMLElement} label_id Either the Label name (Not the question name)
         * OR the InstanceID for the Question, or the DOM element for the question.
         * @return void
         */
        this.setReadOnly = function (label_id) {
            var elements = new Array();
            // retrieve the collection of dom elements for this item
            var element = KD.utils.Util.getElementObject(label_id);
            // If the element is a section
            if (KD.utils.Util.hasClass(element, "templateSection")) {
                element = KD.utils.Util.getElementObject(label_id, "SECTION_");
                if (element) {
                    // get the question layers in the section
                    elements = element.children;
                    for (var i=0;i<elements.length;i++) {
                        // call this function recursively with the question
                        this.setReadOnly(KD.utils.Util.getIDPart(elements[i].id));
                    }
                    return;
                }
            }
            // If the element is a question
            else if (KD.utils.Util.hasClass(element, "questionLayer")) {
                element = KD.utils.Util.getElementObject(label_id, "QANSWER_");
                if (element) {
                    // get the question answer elements
                    elements = element.children;
                    // convert the collection to an array
                    var els = new Array();
                    for (i=0;i<elements.length;i++) {
                        // If the question is a checkbox, get the checkbox answer element
                        if (KD.utils.Util.hasClass(elements[i], "answerCheckbox")) {
                            els[i] = elements[i].children[0];
                        }
                        else {
                            els[i] = elements[i];
                        }
                    }
                }
            }
            if (els){
                if (!KD.utils.Util.isArray(els)){
                    els=[els];  //If this is a single item, only need to run once, but treat as an array
                }
                //Handle Multiples for radio/checkboxes/dates
                for(i=0;i<els.length;i++){
                    var qst=els[i];
                    if(qst.tagName && (qst.tagName.toUpperCase()=="INPUT" || qst.tagName.toUpperCase()=="TEXTAREA")){
                        if (qst.type && (qst.type.toUpperCase() == "RADIO" || qst.type.toUpperCase() == "CHECKBOX") || qst.type.toUpperCase() == "SUBMIT" || qst.type.toUpperCase() == "BUTTON"){
                            qst.disabled=true;
                        }else {
                            qst.setAttribute("readOnly", "readOnly");
                            qst.style.backgroundColor=KD.utils.Action.readOnlyColor;
                            // disable calendar picker if a date or date/time question
                            if (KD.utils.Util.hasClass(qst, 'dateYear') || KD.utils.Util.hasClass(qst, 'dtYear')) {
                                var calParent = qst.parentNode;
                                var calPicker = calParent.getElementsByTagName('img')[0];
                                if (calPicker && calPicker.tagName && calPicker.tagName.toUpperCase() == "IMG") {
                                    calPicker.style.display = "none";
                                }
                            }
                        }
                    //Handle selection boxes
                    }else if(qst.tagName && qst.tagName.toUpperCase()=="SELECT"){
                        qst.disabled=true;
                    //qst.style.backgroundColor=KD.utils.Action.readOnlyColor;
                    //Handle array of radio buttons or checkboxes
                    }
                }

            }
            // handle the rest of the element types
            else if ((KD.utils.Util.getElementObject(label_id, "PAGE_")) ||
                (KD.utils.Util.getElementObject(label_id, "SECTION_")) ||
                (KD.utils.Util.getElementObject(label_id, "DYNAMIC_TEXT_")) ||
                (KD.utils.Util.getElementObject(label_id, "IMAGE_"))) {
                var nodeRef = ((KD.utils.Util.getElementObject(label_id, "PAGE_")) ||
                    (KD.utils.Util.getElementObject(label_id, "SECTION_")) ||
                    (KD.utils.Util.getElementObject(label_id, "DYNAMIC_TEXT_")) ||
                    (KD.utils.Util.getElementObject(label_id, "IMAGE_")));
                KD.utils.Action._iterActionCall.call(this, nodeRef, KD.utils.Action.setReadOnly);
            }
            else {
                alert("function setReadOnly - Unable to locate the Object for: "+label_id);
            }
        };

        /**
         * Change the appearance of the provided Question element to Read/Write
         * or Enabled depending on question type.  Radio button/checkbox items
         * will ALL be disabled for the id.
         * @method setReadWrite
         * @param {String | HTMLElement} label_id Either the Label name (Not the question name)
         * OR the InstanceID for the Question, or the DOM element for the question.
         * @return void
         */
        this.setReadWrite = function (label_id) {
            var elements = new Array();
            // retrieve the collection of dom elements for this item
            var element = KD.utils.Util.getElementObject(label_id);
            // If the element is a section
            if (KD.utils.Util.hasClass(element, "templateSection")) {
                element = KD.utils.Util.getElementObject(label_id, "SECTION_");
                if (element) {
                    // get the question layers in the section
                    elements = element.children;
                    for (var i=0;i<elements.length;i++) {
                        // call this function recursively with the question
                        this.setReadWrite(KD.utils.Util.getIDPart(elements[i].id));
                    }
                    return;
                }
            }
            // If the element is a question
            else if (KD.utils.Util.hasClass(element, "questionLayer")) {
                element = KD.utils.Util.getElementObject(label_id, "QANSWER_");
                if (element) {
                    // get the question answer elements
                    elements = element.children;
                    // convert the collection to an array
                    var els = new Array();
                    for (i=0;i<elements.length;i++) {
                        // If the question is a checkbox, get the checkbox answer element
                        if (KD.utils.Util.hasClass(elements[i], "answerCheckbox")) {
                            els[i] = elements[i].children[0];
                        }
                        else {
                            els[i] = elements[i];
                        }
                    }
                }
            }
            if (els){
                if (!KD.utils.Util.isArray(els)){
                    els=[els];  //If this is a single item, only need to run once, but treat as an array
                }
                //Handle Multiples for radio/checkboxes/dates
                for(i=0;i<els.length;i++){
                    var qst=els[i];
                    if(qst.tagName && (qst.tagName.toUpperCase()=="INPUT" || qst.tagName.toUpperCase()=="TEXTAREA") && !qst.getAttribute('fileTypesAllowed')){
                        if (qst.type && (qst.type.toUpperCase() == "RADIO" || qst.type.toUpperCase() == "CHECKBOX"|| qst.type.toUpperCase() == "SUBMIT" || qst.type.toUpperCase() == "BUTTON")){
                            qst.disabled=false;
                        }else {
                            qst.removeAttribute('readOnly');
                            qst.style.backgroundColor='';
                            // enable calendar picker if a date or date/time question
                            if (KD.utils.Util.hasClass(qst, 'dateYear') || KD.utils.Util.hasClass(qst, 'dtYear')) {
                                var calParent = qst.parentNode;
                                var calPicker = calParent.getElementsByTagName('img')[0];
                                if (calPicker && calPicker.tagName && calPicker.tagName.toUpperCase() == "IMG") {
                                    calPicker.style.display = "";
                                }
                            }
                            // if a date or date/time question, the question value must always be read-only
                            if (KD.utils.Util.hasClass(qst, 'dateHidden') || KD.utils.Util.hasClass(qst, 'dateLocal') ||
                                KD.utils.Util.hasClass(qst, 'dtHidden') || KD.utils.Util.hasClass(qst, 'dtLocal')) {
                                qst.setAttribute("readOnly", "readOnly");
                                qst.style.backgroundColor=KD.utils.Action.readOnlyColor;
                            }
                        }
                    //Handle selection boxes
                    }else if(qst.tagName && qst.tagName.toUpperCase()=="SELECT"){
                        qst.disabled=false;
                    //qst.style.backgroundColor=KD.utils.Action.readOnlyColor;
                    }
                }
            }
            // handle the rest of the element types
            else if ((KD.utils.Util.getElementObject(label_id, "PAGE_")) ||
                (KD.utils.Util.getElementObject(label_id, "SECTION_")) ||
                (KD.utils.Util.getElementObject(label_id, "DYNAMIC_TEXT_")) ||
                (KD.utils.Util.getElementObject(label_id, "IMAGE_"))) {
                var nodeRef = ((KD.utils.Util.getElementObject(label_id, "PAGE_")) ||
                    (KD.utils.Util.getElementObject(label_id, "SECTION_")) ||
                    (KD.utils.Util.getElementObject(label_id, "DYNAMIC_TEXT_")) ||
                    (KD.utils.Util.getElementObject(label_id, "IMAGE_")));
                KD.utils.Action._iterActionCall.call(this, nodeRef, KD.utils.Action.setReadWrite);
            }
            else {
                alert("function setReadWrite - Unable to locate the Object for: "+label_id);
            }
        };

        /**
         * Disable a button on the page so it can't be clicked or pressed
         * @method disableButton
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @return none
         */
        this.disableButton = function (label_id) {
            var div = KD.utils.Util.getButtonObject(label_id);
            if (div && div != "") {
                var input = div.getElementsByTagName("input");
                input[0].disabled = true;
            } else {
                alert("function disableButton - Unable to locate the Object for: "+label_id);
            }
        };

        /**
         * Enable a button on the page so it can be clicked or pressed
         * @method enableButton
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @return void
         */
        this.enableButton = function (label_id) {
            var div = KD.utils.Util.getButtonObject(label_id);
            if (div && div != "") {
                var input = div.getElementsByTagName("input");
                input[0].disabled = false;
            } else {
                alert("function enableButton - Unable to locate the Object for: "+label_id);
            }
        };

        /**
         * Disables all submit buttons on the form
         * @method disableSubmitButtons
         * @param {Event} e The event that triggered this function
         * @return void
         */
        this.disableSubmitButtons = function (e) {
            for (var i=0; i<KD.utils.ClientManager.submitButtons.length; i+=1) {
                KD.utils.Action.disableButton(KD.utils.ClientManager.submitButtons[i]);
            }
        };

        /**
         * Enables all submit buttons on the form
         * @method enableSubmitButtons
         * @param {Event} e The event that triggered this function
         * @return void
         */
        this.enableSubmitButtons = function(e){
            for (var i=0; i<KD.utils.ClientManager.submitButtons.length; i+=1) {
                KD.utils.Action.enableButton(KD.utils.ClientManager.submitButtons[i]);
            }
        };

        /**
         * Checks if an event or question requires a pattern, and if the value
         * meets the pattern.  Blank questions are not validated.  If the pattern
         * isn't met, the field will be highlighted.
         * @method checkPattern
         * @param {HTMLElement | Event} obj The element or event to validate
         * @return void
         */
        this.checkPattern = function (obj) {
            //check whether this is an event or an element
            var qstn = KD.utils.Util.getElementFromObject(obj);
            var valFormat=qstn.getAttribute("validationFormat");
            if (valFormat && valFormat != "") {
                var expStr = qstn.getAttribute("validationFormat");
                var exp = new RegExp(expStr);
                var qstnVal = KD.utils.Util.trimString(qstn.value);
                if (qstnVal != null && qstnVal.length > 0 && exp.test(qstnVal) == false) {
                    KD.utils.Action.highlightField(qstn);
                    var validationText = qstn.getAttribute("validationText");
                    KD.utils.ClientManager.alertPanel(
                        {
                            header: 'Invalid Formatted Field',
                            body: validationText,
                            element: null
                        }
                    );
                    // re-attach submit button event handlers
                    KD.utils.Action._enableButtonEvents();
                    return;
                }
                if ((qstnVal == null || qstnVal == "") || exp.test(qstnVal) == true) {
                    /* Clean up if valid or null */
                    KD.utils.Action.resetRequiredField(qstn);

                    // re-attach submit button event handlers
                    KD.utils.Action._enableButtonEvents();

                    // clear the patternError attribute
                    var patternError = qstn.getAttribute("patternError");
                    if (patternError) {
                        qstn.removeAttribute("patternError");
                    }
                }
            }
        };

        /**
         * Make a question required (client-side).
         * If the question isn't filled out, the field label will highlight
         * and pop an error message.
         * @method makeQuestionRequired
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @return void
         */
        this.makeQuestionRequired = function (label_id) {
            var els = KD.utils.Util.getQuestionInput(label_id);
            if (els){
                if (!KD.utils.Util.isArray(els)){
                    els=[els];  //If this is a single item, only need to run once, but treat as an array
                }
                //Handle Multiples for radio/checkboxes
                for(var i=0;i<els.length;i++){
                    var cls=els[i].className;
                    //Skip date display fields
                    if(cls != null && (cls.indexOf("dateYear") != -1 || cls.indexOf("dateMonth") != -1  || cls.indexOf("dateDay") != -1) || cls.indexOf("dateLocal") != -1){
                        continue;
                    }
                    //Skip date/time display fields
                    if(cls != null && (cls.indexOf("dtYear") != -1 || cls.indexOf("dtMonth") != -1  || cls.indexOf("dtDay") != -1 || cls.indexOf("dtHour") != -1 || cls.indexOf("dtMin") != -1 || cls.indexOf("dtAMPM") != -1 || cls.indexOf("dtLocal") != -1)){
                        continue;
                    }
                    els[i].setAttribute("required", "true");
                    var errorValue=els[i].getAttribute("errorValue");
                    if(!errorValue || errorValue==""){
                        //Use the label if there isn't a value set
                        els[i].setAttribute("errorValue", KD.utils.Util.getLabelValueFromAnswerEl(els[i]));
                    }
                }
                // add the preRequire classes
                KD.utils.ClientManager.setPreRequire(label_id);
            } else if ((KD.utils.Util.getElementObject(label_id, "PAGE_")) || (KD.utils.Util.getElementObject(label_id, "SECTION_"))) {
                // maybe we are dealing with a page or section
                var nodeRef = ((KD.utils.Util.getElementObject(label_id, "PAGE_")) || (KD.utils.Util.getElementObject(label_id, "SECTION_")));
                KD.utils.Action._iterActionCall.call(this, nodeRef, KD.utils.Action.makeQuestionRequired);
            }
        };

        /**
         * Make a question optional (client-side).
         * Note: If a question is set up to be required server-side in the
         * question definition, it cannot be made optional.
         * The server will check this on form submit and display an error.
         * @method makeQuestionOptional
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @return void
         */
        this.makeQuestionOptional = function (label_id) {
            var els = KD.utils.Util.getQuestionInput(label_id);
            if (els){
                if (!KD.utils.Util.isArray(els)){
                    els=[els];  //If this is a single item, only need to run once, but treat as an array
                }
                //Handle Multiples for radio/checkboxes
                for(var i=0;i<els.length;i++){
                    els[i].removeAttribute("required");
                }

                // clear the required label highlight
                KD.utils.Action.resetRequiredField(els[0]);

                // remove the preRequire classes
                KD.utils.ClientManager.clearPreRequire(label_id);
            } else if ((KD.utils.Util.getElementObject(label_id, "PAGE_")) || (KD.utils.Util.getElementObject(label_id, "SECTION_"))) {
                // maybe we are dealing with a page or section
                var nodeRef = ((KD.utils.Util.getElementObject(label_id, "PAGE_")) || (KD.utils.Util.getElementObject(label_id, "SECTION_")));
                KD.utils.Action._iterActionCall.call(this, nodeRef, KD.utils.Action.makeQuestionOptional);
            }
        };

        /**
         * Typically used when a form is re-displayed to hide/show elements needed.
         * @method applyValueActions
         * @param {HTMLElement} el The HTML element (INPUT, DIV, etc)
         * @param {Object} clientAction The ClientAction object defined for this event/action
         */
        this.applyValueActions = function (el ,clientAction) {
            if (!clientAction || !clientAction.action || !el || !el.type) {
                return;
            }
            var fire=false;

            if(el.type.toUpperCase()=="RADIO" && el.checked){
                fire=true;
            }else if(el.type.toUpperCase()=="CHECKBOX" && el.checked){
                fire=true;
            }else if((el.type.toUpperCase()=="TEXT" || el.tagName.toUpperCase()=="SELECT" || el.tagName.toUpperCase()=="TEXTAREA") && el.value && el.value != ""){
                fire=true;
            }
            if(fire){
                clientAction.action.apply(KD.utils.Action,[{
                    target:el,
                    type:clientAction.jsEvent
                },clientAction]);
            }
        };

        /**
         * Takes in a Kinetic SR standard XML from a SimpleDataRequest, and outputs
         * it as a table with no formatting/events.  Columns can be ordered, made
         * visible/hidden, and column labels can be changed.
         * @method showResultsAsAdvancedTable
         * @param {Array} recordXMLArray The array of Record XML elements
         * @param {Array} questions An array of question objects that are mapped with this table
         * @param {String} source A string indicating whether the data is from a "bridge" or "local" source.
         * @return {HTMLElement} An HTML table element.  The table will have no rows if the data set is empty.
         */
        this.showResultsAsAdvancedTable = function (recordXMLArray, questions, source) {
            var cols = [],
            visibleCols = [];

            // add the question ID as a property for easier access later
            for (var question in questions[0]) {
                questions[0][question]['qId'] = question;
                cols.push(questions[0][question]);
            }
            // columns should already be in the correct order,
            // but sort the table columns array by sort order attribute just in case
            cols.sort(function(a,b) {
                return a['sort_order']-b['sort_order'];
            });

            // we only want ot display the visible columns, or columns that haven't
            // been explicitly marked as not visible.
            for (var col in cols) {
                if (cols[col]['visible'] == "Yes" || cols[col]['visible'] == null ||
                    cols[col]['visible'] == "") {
                    visibleCols.push(cols[col]);
                }
            }

            // build the table
            var theTable=document.createElement('table');
            var theHead=document.createElement('thead');
            var theBody=document.createElement('tbody');
            var oddEven="odd";
            if (recordXMLArray && recordXMLArray.length > 0) {
                // Create Header
                var headerRow=document.createElement('tr');
                var headerFields = recordXMLArray[0].getElementsByTagName("field");
                for(var col in visibleCols) {
                    var qId = visibleCols[col]['qId'];
                    var thisCell=document.createElement('th');
                    var colLabel = KD.utils.Action._getAdvancedColumnLabel(visibleCols[col], source);
                    thisCell.appendChild(document.createTextNode(colLabel));
                    headerRow.appendChild(thisCell);
                }
                headerRow.id="headerRow";
                theHead.appendChild(headerRow);
                // End Header

                // Create Rows
                for (var i =0; i < recordXMLArray.length; i++) {
                    var thisRow=document.createElement('tr');
                    thisRow.id="row_"+i;
                    thisRow.className="record row_"+oddEven;
                    var fields = recordXMLArray[i].getElementsByTagName("field");

                    var values = {};
                    if (source == "bridge") {
                        // For each of the record fields
                        for(var fieldIndex=0;fieldIndex<fields.length;fieldIndex++) {
                            if (fields[fieldIndex].textContent) {
                                // IE
                                value = fields[fieldIndex].textContent;
                            } else {
                                // rest of the world
                                value = fields[fieldIndex].text;
                            }
                            values[fields[fieldIndex].getAttribute('id')] = value || "";
                        }
                    }


                    for (col in visibleCols) {
                        var qId = visibleCols[col]['qId'];
                        var map = visibleCols[col][qId];
                        var value;

                        if (source == "bridge") {
                            // Initialize the value
                            value = map;

                            // For each match of the attributes content
                            var attributePattern = /<%=\s*attribute\["(.+?)"\]\s*%>/;
                            var match = attributePattern.exec(value);
                            while (match != null) {
                                // Replace the attribute tag with the value
                                value = value.replace(match[0], values[match[1]]);
                                // Retrieve the next match
                                match = attributePattern.exec(value);
                            }
                        }
                        else {
                            value = KD.utils.Action._getAdvancedColumnValue(map, fields);
                        }

                        var thisCell=document.createElement('td');
                        thisCell.appendChild(document.createTextNode(value));
                        thisCell.id="r_"+i+"_c_"+col;
                        thisRow.appendChild(thisCell);
                    }
                    theBody.appendChild(thisRow);
                    if (oddEven=="odd") {
                        oddEven="even";
                    } else {
                        oddEven="odd";
                    }
                }
            }
            theTable.appendChild(theHead);
            theTable.appendChild(theBody);
            return theTable;
        };

        /**
         * FOR INTERNAL USE.
         * Gets the label defined for the column.
         * @method _getAdvancedColumnLabel
         * @private
         * @param {Object} col The object that contains the column properties
         * @param {String} source A string indicating whether the data is from a "bridge" or "local" source.
         * @return {String} the column label
         */
        this._getAdvancedColumnLabel = function (col, source) {
            // use the label specified unless blank
            var label = col['table_label'];
            if (label == null || KD.utils.Util.trimString(label) == '') {
                var questionId = col['qId'];
                var fieldMap = col[questionId];

                if (source == "bridge") {
                    var attributePattern = /<%=\s*attribute\["(.+?)"\]\s*%>/;
                    var match = attributePattern.exec(fieldMap);
                    if (match) {label = match[1];}
                }
                else {
                    var flds = fieldMap.split("</FLD>");
                    // just get the first field used, and set the label to the field name
                    for (var i=0; i < flds.length; i++) {
                        if (flds[i].indexOf("<FLD>") > -1) {
                            label = (flds[i].split(";")[0]).substring(flds[i].indexOf("<FLD>")+5);
                            break;
                        }
                    }
                }
            }
            return label;
        };

        /**
         * FOR INTERNAL USE.
         * Gets the value defined for the column.
         * @method _getAdvancedColumnValue
         * @private
         * @param {String} fieldMap The string representing the field mapping (FLD tag)
         * @param {Array} fields An array containing all the fields that make up this column.
         * @return {String} the column value
         */
        this._getAdvancedColumnValue = function (fieldMap, fields) {
            var fieldName = "",
            value = "",
            fieldValue = "",
            flds = fieldMap.split("</FLD>");

            for (var i = 0; i < flds.length; i++){
                //Just static text in this token
                if (flds[i].indexOf("<FLD>") == -1){
                    value += flds[i];
                } else {
                    //Get the static part out if there is some
                    var segs=flds[i].split("<FLD>");
                    if (segs.length>1) {
                        value += segs[0];
                    }

                    // Get the next field name
                    fieldName = (flds[i].split(";")[0]).substring(flds[i].indexOf("<FLD>")+5);

                    // Get the value for this field name
                    for (var j = 0; j < fields.length; j++) {
                        if (fields[j].getAttribute("id") == fieldName) {
                            if (fields[j].childNodes.length > 0) {
                                fieldValue = fields[j].firstChild.nodeValue;
                            } else {
                                fieldValue = "";
                            }
                        }
                    }

                    value += fieldValue;
                }
            }
            value = value.replace(/%0A/gi, "\n");
            value = value.replace(/%0D/gi, "\n");
            return KD.utils.Util.trimString(value);
        };

        /**
         * Takes in a Kinetic SR standard XML from a SimpleDataRequest, and
         * outputs it as a table with no formatting/events.
         * @method showResultsAsTable
         * @param {Array} recordXMLArray The array of Record XML elements
         * @param {String} tableId (optional) The id attribute to set for the generated table element
         * @param {String} tableClass (optional) The class name to set for the generated table element
         * @return {HTMLElement} An HTML table element.  The table will have no rows if the data set is empty.
         */
        this.showResultsAsTable = function (recordXMLArray, tableId, tableClass) {
            var theTable=document.createElement('table');
            var thisCell;
            if(tableId){
                theTable.setAttribute("id", tableId);
            }
            if(tableClass){
                theTable.className = tableClass;
            }
            var theBody=document.createElement('tbody');
            var oddEven="odd";
            if(recordXMLArray && recordXMLArray.length >0){
                /*Create Header*/
                var headerRow=document.createElement('tr');
                var headerFields = recordXMLArray[0].getElementsByTagName("field");
                for (var a = 0; a < headerFields.length; a++) {
                    thisCell=document.createElement('th');
                    thisCell.appendChild(document.createTextNode(headerFields[a].getAttribute("id")));
                    headerRow.appendChild(thisCell);
                }
                headerRow.id="headerRow";
                theBody.appendChild(headerRow);
                /*End Header */
                /*Create Rows*/
                for (var i =0; i < recordXMLArray.length; i++){
                    var thisRow=document.createElement('tr');
                    thisRow.id="row_"+i;
                    thisRow.className="record row_"+oddEven;
                    var fields = recordXMLArray[i].getElementsByTagName("field");
                    for (var k = 0; k < fields.length; k++) {
                        thisCell=document.createElement('td');
                        var fieldValue = "";
                        if (fields[k].firstChild){
                            fieldValue= fields[k].firstChild.nodeValue;
                        }
                        thisCell.appendChild(document.createTextNode(fieldValue));
                        thisCell.id="r_"+i+"_c_"+k;
                        thisRow.appendChild(thisCell);
                    }
                    theBody.appendChild(thisRow);
                    if(oddEven=="odd"){
                        oddEven="even";
                    }else{
                        oddEven="odd";
                    }
                }
            }
            theTable.appendChild(theBody);
            return theTable;
        };

        /**
         * Makes a call to SimpleDataRequest with the parameters provided.  This
         * is a simple wrapper to make an HttpXmlRequest (AJAX).
         *
         * By default, the simple data request is made as an asynchronous request.
         * This means that the browser will not be blocked while the request is
         * being made, so the user can do other things as the request is still running.
         * Synchronous requests will block the user from doing anything else until
         * the request returns.  Likewise, all other events will also be blocked
         * until the  request returns.
         *
         * Be careful when making synchronous requests.
         *
         * <p>
         * Parameters Example
         * <ul>
         * <li>EXAMPLE SDR Qualification: 'LoginId'="&lt;FLD&gt;;user;BASE&lt;/FLD&gt;" AND 'Type'="&lt;FLD&gt;;type;BASE&lt;/FLD&gt;"</li>
         * <li>EXAMPLE paramString: "user=joe&type=red"</li>
         * </ul>
         * </p>
         *
         * <p>
         * Format Example
         * By default the application looks in the appcontext/resources/partials/ directory on the web server.
         * If your JSP is located elsewhere, be sure to affix the appropriate path relative to appcontext/resources/partials/.
         * To load the JSP named 'my_results.jsp' in the webapp_context/resources/partials directory, just specify the value 'my_results' or 'my_results.jsp'.
         * To load the JSP named 'my_results.jsp' in the webapp_context/themes/my_company/partials directory, specify the value '../../themes/my_company/partials/my_results'
         * </p>
         *
         * <p>
         * Get List, or Get Entries:
         * By default, this value false to get the results as entries.
         * When retrieving the entries as a list, only the fields specified in the
         * Simple Data Request will be retrieved, not the full record.  This does have
         * performance benefits, but comes with some limitations:
         * <ul>
         * <li>Limitation: Workflow that fires on GET ENTRY will not be fired</li>
         * <li>Limitation: Status History fields cannot be retrieved</li>
         * <li>Limitation:  Attachment fields cannot be retrieved</li>
         * <li>Limitation:  ARS <= 6.3 - character fields > 255 characters cannot be retrieved</li>
         * <li>Limitation:  ARS >= 7.0 - unlimited character fields cannot be retrieved</li>
         * </ul>
         * </p>
         *
         * @method makeAsyncRequest
         * @param {String} requestName A name to identify the request
         * @param {String} dataRequestId The instanceId of the KS_SRV_SimpleDataRequest entry
         * @param {Object} callback A KD.utils.Callback object that handles the response from the SDR
         * @param {String} paramString (optional) Additional parameters used in the SDR qualification.
         * @param {String} format (optional) The name of the JSP to render the results.
         * @param {Boolean} useGetList (optional) Gets all records as a list, retrieving only the specified fields
         * @param {Boolean} synchronous (optional) By default the request is asynchronous.  Set to true for synchronous.
         * @return null
         */

        this.displayError = function(message, response) {
            KD.utils.ClientManager.alertPanel(
                {
                    header: 'Error',
                    body: '<b>The following error occurred:</b> ' + message,
                    element: null
                }
            );
        }

        this.makeAsyncBridgeRequest = function(source, sourceId, parameterString, callback) {
            // Ensure that the BridgeDataRequest urls are properly encoded
            source = encodeURIComponent(source);
            sourceId = encodeURIComponent(sourceId);

            // Build the bridge request path string
            var now = new Date();
            var path = "BridgeDataRequest"+
                "?formId="+KD.utils.ClientManager.templateId+
                "&source="+source+
                "&bridgedResourceId="+sourceId+
                parameterString+
                "&noCache="+now.getTime();

            var failureCallback = callback.failure;

            // Wrap the failure callback so that unauthorized responses are
            // automatically handled.
            var failureCallbackWrapper = function(response) {
                // If the user is not logged in, typically indicating a session
                // timeout.
                if (response.status == 401) {
                    // Register the unauthorized session request, this queues up
                    // multiple requests
                    KD.utils.ClientManager.registerUnauthorizedSessionRequest(sourceId, "GET", path, {
                        success: callback.success,
                        failure: failureCallbackWrapper,
                        argument: callback.argument

                    });
                    // If the simpleLogin element does not already exist,
                    // display the simple login dialog.  If it does already
                    // exist, the registered session request will be run, along
                    // with any other registered unauthorized requests, when the
                    // simpleLogin dialog is submitted successfully.
                    if (document.getElementById('simpleLogin') == null) {
                        KD.utils.Action.handleHttpErrorCode(response.status, "Not authorized.");
                    }
                }
                // If the failure was not due to a session timeout
                else {
                    // Pass the failure response through to the failure handler
                    failureCallback(response);
                }
            }

            // Overwrite the failure callback with the wrapped handler
            callback['failure'] = failureCallbackWrapper;

            // Make the request
            Connect.asyncRequest('GET', path, callback);
        };

        this.makeAsyncRequest = function (requestName, dataRequestId, callback, paramString, format, useGetList, synchronous) {
            if(KD.utils.Action.sdrErrors == null){
                KD.utils.Action.sdrErrors = new KD.utils.Hash();
            }
            //alert("Active: " + KD.utils.ClientManager.isActiveConnection(dataRequestId));
            if(paramString && paramString != "" && paramString.indexOf("&") != 0){
                paramString ="&"+paramString;
            }
            dataRequestId=encodeURIComponent(dataRequestId);
            requestName=encodeURIComponent(requestName);
            var sessionId=encodeURIComponent(KD.utils.ClientManager.sessionId);
            var now = new Date();
            var entryParam="";
            if(useGetList == true){
                entryParam="&useGetList=true"
            }
            var path = "SimpleDataRequest?requestName="+ requestName +"&dataRequestId="+ dataRequestId +"&sessionId="+sessionId +"&format="+ format + paramString+entryParam+"&noCache="+now.getTime();

            // register the parameters with the invalid session request manager
            KD.utils.ClientManager.registerInvalidSessionRequest(dataRequestId,'GET', path, callback);

            if (callback.includeLoadingImage) {
                var elId = null, el = null;
                if (KD.utils.Util.isArray(callback.argument[0])) {
                    elId = callback.argument[0][0];
                } else {
                    elId = callback.argument[0];
                }

                if (elId) {
                    el = Dom.get(elId);
                }
                if (el) {
                    el.innerHTML='<img src="./resources/catalogIcons/ajax-loader.gif" class="ajax_load_img">';
                }
            }

            // Determine whether to make the call.
            // If the same SDR is active and done with the same params, then don't make a call
            // If the SDR is active with "older" params, then abort that one and make a new call
            // If it's not active, then just make the call
            var isActive=KD.utils.ClientManager.isActiveConnection(dataRequestId);
            var isValid=true;
            if (isActive){
                var prevCall=KD.utils.ClientManager.getConnection(dataRequestId);
                if (prevCall[1]==paramString){
                    isValid=false;
                }else{
                    try{
                        prevCall[0].conn.abort(prevCall, callback, false);
                    }catch(error){
                    //just continue. issue in IE that won't allow aborts.  eventually output to a console if in debug mode
                    }
                }
            }
            if(isValid){
                //Wrap callback to handle session/other standard errors
                var fnctnError = callback.error;
                callback.failure = function(response){
                    var message = response.statusText;
                    if (response.getResponseHeader != null && response.getResponseHeader['X-Error-Message'] != null){
                        message = response.getResponseHeader['X-Error-Message'];
                    }

                    var connectionStatus = response.getResponseHeader['Connection'];
                    if (!KD.utils.Action.sdrErrors.getItem(response.status) || !connectionStatus || connectionStatus.indexOf("close")!=-1){
                        KD.utils.Action.sdrErrors.setItem(response.status, message);
                        if (!connectionStatus || connectionStatus.indexOf("close")!=-1){
                            // check is session is still valid
                            KD.utils.ClientManager.checkSession();
                            var sessionResponse = KD.utils.ClientManager.sessionCheck;
                            if (sessionResponse.status !== 200) {
                                if (callback.includeLoadingImage && el) {
                                    // clear the ajax-loader image if it is present
                                    el.innerHTML = "";
                                }
                                var sessionMessage = sessionResponse.statusText;
                                if (sessionResponse.getResponseHeader != null && sessionResponse.getResponseHeader['X-Error-Message'] != null){
                                    sessionMessage = sessionResponse.getResponseHeader['X-Error-Message'];
                                }
                                KD.utils.Action.handleHttpErrorCode(sessionResponse.status, sessionMessage);
                            }
                        } else {
                            KD.utils.Action.handleHttpErrorCode(response.status, sessionMessage);
                        }
                        return;
                    }

                    //Pass the error through to the operation-specific error
                    if(fnctnError){
                        fnctnError(response);
                    }
                }
                //Wrap the success callback to clear out errors
                var fnctnSuccess = callback.success;
                callback.success = function(response){
                    KD.utils.Action.sdrErrors = new KD.utils.Hash();
                    KD.utils.ClientManager.clearInvalidSessionRequest();
                    fnctnSuccess(response);
                }

                if (synchronous === true){
                    KD.utils.Action._makeSyncRequest(path, callback);
                } else {
                    // We can assume that the session has now been re-eastablished based on an SSO adapter
                    // As a result we want to recall the Data Request that initially failed.
                    var params = KD.utils.ClientManager.getInvalidSessionRequest();
                    // If recovered, run the last Datarequests again
                    if (params[1] !== null && params[2] !== null && params[3] !== null) {
                        Connect.setDefaultPostHeader(false);
                        Connect.initHeader("Cache-Control", "no-cache, no-store");
                        Connect.initHeader("Pragma", "no-cache");
                        Connect.initHeader("Expires", "-1");
                        Connect.asyncRequest(params[1],params[2],params[3]);
                    }
                }
            }
        };

        /*
         * INTERNAL USE ONLY
         *
         * Makes a synchronous call to SimpleDataRequest.  To use, first call
         * makeAsyncRequest with the synchronous parameter set to true.
         *
         * @method _makeSyncRequest
         * @private
         * @param {String} path The path with parameters built up in makeAsyncRequest
         * @param {Object} callback The KD.utils.Callback object handling the response
         * @return null
         */
        this._makeSyncRequest = function (path, callback) {
            var oXhr, // an object wrapper
            xhr, // the XMLHttpRequest object
            xhrTimeout, // a timeout function to abort hanged calls
            oResponse; // the server's response to the XMLHttpRequest call

            // create the XHR connection object
            oXhr = KD.utils.Action._createSyncXhr();

            if (oXhr) {
                xhr = oXhr.xhr;
                // open the request synchronously (last parameter)
                xhr.open('GET', path, false);

                // set a timer to handle timeout situations
                xhrTimeout = setTimeout(function() {
                    xhr.abort();
                }, callback.argument[0].timeout || 30000);

                // send the request to the server
                xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
                xhr.setRequestHeader("Cache-Control", "no-cache, no-store");
                xhr.setRequestHeader("Pragma", "no-cache");
                xhr.setRequestHeader("Expires", "-1");
                try {
                    xhr.send(null);
                } catch (e) {
                    // Connection Failure
                    callback.failure({
                        status: 0,
                        statusText: "Communication Failure",
                        argument: callback.argument
                    });
                }

                // process response
                if (xhr.readyState == 4) {
                    // clear the timeout so the call doesn't get aborted
                    clearTimeout(xhrTimeout);
                    // build the response object
                    oResponse = KD.utils.Action._buildSyncResponse(xhr, callback.argument);

                    // handle errors
                    if (xhr.status != 200) {
                        callback.failure(oResponse);
                        return;
                    }

                    if (callback.success === KD.utils.Action._setFieldsCallback) {
                        // Need to block until everything is finished.  Currently only
                        // set fields actions that return a single value are working.
                        // The tricky part here is for set fields external requests that
                        // return a list of entries, of which the user must choose one
                        // from the list.  We have to wait until the user is done choosing
                        // before continuing.  What do we do if the user just closes the
                        // selection window without picking a value?
                        callback.success(oResponse);
                    } else {
                        callback.success(oResponse);
                    }
                }

            } else { // Synchronous AJAX request could not be created
                // probably want to replace this alert with something else
                alert('Your browser does not support AJAX requests.');
            }
        };

        /**
         * Get an array of request records as a result of calling the standard SimpleDataRequest
         * @method getMultipleRequestRecords
         * @param {Object} o XmlHttpRequest response object
         * @return {Array} An array of record DOM elements
         */
        this.getMultipleRequestRecords = function (o) {
            var records, xml, parser, text;
            try{
                records = o.responseXML.getElementsByTagName("record");
                // check if this is IE and the responseXML is actually blank
                if (records.length == 0) {
                    if (o.responseXML != null && o.responseXML.xml != null && o.responseXML.xml.length == 0) {
                        throw "rebuild ie xml";
                    }
                }
            }catch(e){
                if (o.responseText && o.responseText.length > 0) {
                    text = o.responseText;
                    // remove all characters below decimal 32 (space),
                    // except Tab, LF, Vertical Tab, FF and CR
                    text = text.replace(/[^\u0009-\u000d\u0020-\uffff]*/gi, '');

                    // build up an XML document from the text
                    if (window.DOMParser) {
                        parser = new DOMParser();
                        xml = parser.parseFromString(text, "text/xml")
                    } else {
                        xml = new ActiveXObject("Microsoft.XMLDOM");
                        xml.async = "false";
                        xml.loadXML(text);
                    }
                    try {
                        // now get the records from the manually built-up document
                        records = xml.getElementsByTagName("record");
                    } catch (e2) {
                        // continue with a blank xml document - something was
                        // wrong with the data that it couldn't be converted
                        // into an xml document
                    }
                }
            }
            return records;
        };

        /**
         * Get single request record as a result of calling the standard SimpleDataRequest
         * @method getSingleRequestRecord
         * @param {Object} o XmlHttpRequest response object
         * @return {HTMLElement} A single record DOM element
         */
        this.getSingleRequestRecord = function (o) {
            try{
                return o.responseXML.getElementsByTagName("record")[0];
            }catch(e){//continue
            }
        };

        /**
         * Get the name of the current SimpleDataRequest.
         * @method getRequestName
         * @param {Object} o XmlHttpReqeust response object
         * @return {String} request Name
         */
        this.getRequestName = function (o) {
            try{
                return o.responseXML.getElementsByTagName("requestName")[0].firstChild.nodeValue;
            }catch(e){//continue
            }
        };

        /**
         * Opens the Date Picker.  Currently English-only.
         * @method openDatePicker
         * @param {Event} evt The event that triggered this function
         * @param {String} id The ID of the question element. (SRVQSTN_...).
         * @return void
         */
        this.openDatePicker = function (evt, id){
            new YAHOO.KD.widget.CalendarPicker(evt, id, "d");
        };

        /**
         * Opens the Date/Time Picker.  Currently English-only.
         * @method openDateTimePicker
         * @param {Event} evt The event that triggered this function
         * @param {String} id The ID of the question element. (SRVQSTN_...).
         * @return void
         */
        this.openDateTimePicker = function (evt, id) {
            new YAHOO.KD.widget.CalendarPicker(evt, id, "dt");
        };

        /**
         * Called when a date is selected in the calendar picker widget.  The question
         * input and selector fields are set to the value of the selected date.
         * @method dateSelected
         * @private
         * @param {Event} evt The event that triggered this function
         * @param {Array} dateArr An array of date parts that represent the date
         * chosen in the date or date/time picker. [yyyy, mm, dd] or [yyyy, mm, dd, hh, mm, ss]
         * @param {Array} params Array of additional parameters: [qstnId]
         * @return void
         */
        this.dateSelected = function (evt, dateArr, params){
            var datePart, nullDate = false, qstnId=params[0];
            if (dateArr && dateArr[0] && dateArr[0][0]) {
                datePart = dateArr[0][0];
            } else {
                datePart = dateArr;
            }
            if (datePart == null) {
                nullDate = true;
            }
            var hour = Dom.get("hour_" + qstnId);
            if (hour) {
                KD.utils.Action.setDateTimeFields(qstnId, datePart, nullDate);
            } else {
                KD.utils.Action.setDateFields(qstnId, datePart, nullDate);
            }
        };

        /**
         * Set the hidden date storage field when a date element changes.
         * @method updateDate
         * @private
         * @param {HTMLElement} el The Date question element
         * @return void
         */
        this.updateDate = function (el) {
            var qstnId=KD.utils.Util.getIDPart(el.id);
            var qstn=KD.utils.Util.getElementObject(qstnId, 'SRVQSTN_');
            var yr=Dom.get("year_" + qstnId).value;
            var month=Dom.get("month_" + qstnId).value;
            var day=Dom.get("day_" + qstnId).value;

            if (el.value == null || el.value == '') {
                KD.utils.Action.setDateFields(qstnId, null, true);
                return;
            }

            if (yr && month && month != "" && day && day != ""){
                KD.utils.Action.setDateFields(qstnId, [yr,month,day]);
            }
        };

        /**
         * Set the hidden date/time storage field when a date/time element changes.
         * @method updateDateTime
         * @private
         * @param {HTMLElement} el The Date/Time question element
         * @return void
         */
        this.updateDateTime = function (el) {
            var qstnId = KD.utils.Util.getIDPart(el.id);
            var qstn=KD.utils.Util.getElementObject(qstnId, 'SRVQSTN_');
            var yr = Dom.get("year_" + qstnId).value;
            var month = Dom.get("month_" + qstnId).value;
            var day = Dom.get("day_" + qstnId).value;
            var hour = Dom.get("hour_" + qstnId).value;
            var min = Dom.get("min_" + qstnId).value;
            var ampm = Dom.get("ampm_" + qstnId).value;
            var local = Dom.get("local_" + qstnId);

            // just clear the time fields if one was cleared
            if (el.id.indexOf("hour_") != -1 || el.id.indexOf("min_") != -1 || el.id.indexOf("ampm_") != -1) {
                if (el.value == null || el.value == '') {
                    KD.utils.Action.setDateTimeFields(qstnId, null, false, true);
                    return;
                }
            }
            // clear all the fields if a date field was cleared
            if (el.value == null || el.value == '') {
                KD.utils.Action.setDateTimeFields(qstnId, null, true);
                return;
            }

            var tempHr = 0;
            if (hour && hour != "") {
                tempHr = parseInt(hour, 10);
                if (tempHr < 12 && ampm === "PM") {
                    tempHr += 12;
                }
                if (tempHr >= 12 && ampm !== "PM") {
                    tempHr -= 12;
                }
            }
            var parts = [yr, month, day];
            parts[parts.length] = tempHr;
            parts[parts.length] = min || 0;
            parts[parts.length] = 0;
            KD.utils.Action.setDateTimeFields(qstnId, parts, false, false);
        };

        /**
         * FOR INTERNAL USE
         * Set the Year, Day, Month fields with the date array indicated.
         * If no array is included the value of the question will be used.  Otherwise, the current date.
         *
         * <p>
         * If you need to set the value of a Date question programatically,
         * use the <b>KD.utils.Action.setQuestionValue()</b> method.
         * </p>
         *
         * @method setDateFields
         * @private
         * @param {String} labelId Either the Label name (Not the question name) OR the InstanceID for the Date Question
         * @param {Array} dateArr [YYYY,MM,DD] (optional)
         * @param {Boolean} nullThis (optional) true to clear the date question
         * @return void
         */
        this.setDateFields = function(labelId, dateArr, nullThis){
            var qstn=KD.utils.Util.getElementObject(labelId, 'SRVQSTN_');
            if (!qstn) {
                alert("function setDateFields - Unable to locate any input elements for :" + labelId);
                return;
            }
            var qstnId=qstn.id.slice("SRVQSTN_".length);
            var hour = Dom.get("hour_" + qstnId);
            if (hour) {
                KD.utils.Action.setDateTimeFields(labelId, dateArr, nullThis);
                return;
            }
            var originalValue=qstn.value;
            var yr=Dom.get("year_" + qstnId);
            var month=Dom.get("month_" + qstnId);
            var day=Dom.get("day_" + qstnId);
            var local=Dom.get("local_" + qstnId);
            var date;

            if(qstn){
                if(nullThis){
                    qstn.value="";
                    yr.value="";
                    month.selectedIndex=null;
                    day.selectedIndex=null;
                    if (local) {
                        local.value = "";
                    }
                    if(originalValue && originalValue != ""){
                        KD.utils.Action._fireChange(qstn);
                    }
                    return;
                }
                if (!dateArr) {
                    if(qstn.value && qstn.value != "" && qstn.value.indexOf("-") != -1){
                        // get the date if it has already been set
                        dateArr = qstn.value.split("-");
                    } else if (month.options[0].value == "01") {
                        // this date question does not allow blank values, set to now
                        date = new Date();
                        dateArr = new Array();
                        dateArr[0] = date.getFullYear();
                        dateArr[1] = date.getMonth()+1;
                        dateArr[2] = date.getDate();
                    } else {
                        // value is blank, and question allows it
                        return
                    }
                } else if (dateArr.length<3) {
                    date = new Date();
                    dateArr = new Array();
                    dateArr[0] = date.getFullYear();
                    dateArr[1] = date.getMonth()+1;
                    dateArr[2] = date.getDate();
                }
                yr.value=dateArr[0];
                month.value=KD.utils.Util.padZeros(dateArr[1], 2);
                day.value=KD.utils.Util.padZeros(dateArr[2], 2);
                qstn.value = KD.utils.Util.formatDate(dateArr);
                if (local) {
                    local.value = KD.utils.Util.formatLocalDate(dateArr);
                }
                if(originalValue != qstn.value && clientManager.isLoading==false){
                    KD.utils.Action._fireChange(qstn);
                }
            }
        };

        /**
         * FOR INTERNAL USE
         * Set the Year, Day, Month, Hour, Minute, AMPM fields with the date/time array indicated.
         * If no array is included the value of the question will be used.  Otherwise, the current date.
         *
         * <p>
         * If you need to set the value of a Date/Time question programatically,
         * use the <b>KD.utils.Action.setQuestionValue()</b> method.
         * </p>
         *
         * @method setDateTimeFields
         * @private
         * @param {String} labelId Either the Label name (Not the question name) OR the InstanceID for the Date Question
         * @param {Array} localDateArr [YYYY,MM,DD,HH,mm,ss,'AM'|'PM'] (optional)
         * @param {Boolean} nullThis true to clear the date/time question
         * @param {Boolean} nullTime true to clear the time questions, and set the time portion of the hidden question
         *                   to midnight (only if the date is set)
         * @return void
         */
        this.setDateTimeFields = function (labelId, localDateArr, nullThis, nullTime) {
            var qstn=KD.utils.Util.getElementObject(labelId, 'SRVQSTN_');
            if (!qstn) {
                alert("function setDateTimeFields - Unable to locate any input elements for :" + labelId);
                return;
            }
            var qstnId=qstn.id.slice("SRVQSTN_".length);
            var originalValue=qstn.value;
            var yr=Dom.get("year_" + qstnId);
            var month=Dom.get("month_" + qstnId);
            var day=Dom.get("day_" + qstnId);
            var hour=Dom.get("hour_" + qstnId);
            var min=Dom.get("min_" + qstnId);
            var sec="00";
            var ampm=Dom.get("ampm_" + qstnId);
            var local=Dom.get("local_" + qstnId);
            var timeArr;
            var ampmValue = "AM";
            var date;
            var utcDateArr;
            var parts;

            if(qstn){
                // value is to be cleared
                if(nullThis){
                    qstn.value="";
                    yr.value="";
                    month.selectedIndex=null;
                    day.selectedIndex=null;
                    hour.selectedIndex=null;
                    min.selectedIndex=null;
                    sec="";
                    ampm.selectedIndex=null;
                    if (local) {
                        local.value = "";
                    }
                    if(originalValue && originalValue != ""){
                        KD.utils.Action._fireChange(qstn);
                    }
                    return;
                }
                // time fields are to be cleared
                if (nullTime) {
                    // just clear the time fields
                    hour.selectedIndex=null;
                    min.selectedIndex=null;
                    sec="";
                    ampm.selectedIndex=null;
                    if (qstn.value != null && qstn.value != "") {
                        if (qstn.getAttribute("required") == "true") {
                            parts = [yr.value, month.value, day.value];
                        } else {
                            parts = [yr.value, month.value, day.value, 0, 0, 0];
                        }
                        qstn.value = KD.utils.Util.formatUTCDateTime(parts);
                        if (local) {
                            local.value = KD.utils.Util.formatLocalDateTime(parts);
                        }
                    }
                    if(originalValue && originalValue != ""){
                        KD.utils.Action._fireChange(qstn);
                    }
                    return;
                }
                // local date array was provided, possibly even time
                if (localDateArr && localDateArr.length >= 3) {
                    if (ampm.value != "") {
                        ampmValue = ampm.value;
                    }

                    timeArr = new Array();
                    if (hour.value != "") {
                        timeArr[0] = hour.value;
                        if (hour.value < 12 && ampmValue == "PM") {
                            timeArr[0] = parseInt(timeArr[0], 10) + 12;
                        }
                        if (hour.value == 12 && ampmValue == "AM") {
                            timeArr[0] = 0;
                        }
                    } else {
                        timeArr[0] = 0;
                    }
                    if (min.value != "") {
                        timeArr[1] = min.value;
                    } else {
                        timeArr[1] = 0;
                    }
                    if (sec != "") {
                        timeArr[2] = sec;
                    } else {
                        timeArr[2] = 0;
                    }
                    var nH = parseInt(localDateArr[3], 10);
                    localDateArr[3] = isNaN(nH) ? timeArr[0] : nH;
                    var nM = parseInt(localDateArr[4], 10);
                    localDateArr[4] = isNaN(nM) ? timeArr[1] : nM;
                    var nS = parseInt(localDateArr[5], 10);
                    localDateArr[5] = isNaN(nS) ? sec :  nS;
                } else if (!localDateArr) {
                    // Date array wasn't provided, set fields from question value
                    if(qstn.value && qstn.value != "" &&
                        qstn.value.indexOf("-") != -1 && qstn.value.indexOf(":") != -1){
                        // get as many parts as possible
                        utcDateArr = KD.utils.Util.parseDtString(qstn.value);
                        // construct the UTC date
                        date = new Date();
                        date.setUTCFullYear(utcDateArr[0]);
                        date.setUTCMonth(utcDateArr[1]-1);
                        date.setUTCDate(utcDateArr[2]);
                        date.setUTCHours(utcDateArr[3]);
                        date.setUTCMinutes(utcDateArr[4]);
                        date.setUTCSeconds(utcDateArr[5]);
                        localDateArr = KD.utils.Util.getDtParts(date);
                    // Date array wasn't provided and the question value is blank
                    } else if (month.options[0].value == "01") {
                        // this date question does not allow blank values, set to now
                        date = new Date();
                        date.setSeconds(0);
                        date.setMilliseconds(0);
                        localDateArr = KD.utils.Util.getDtParts(date);
                    }else{
                        // value is blank, and question allows it
                        return;
                    }
                } else if (localDateArr.length < 3) {
                    // build up a new date object with the current timestamp
                    date = new Date();
                    date.setSeconds(0);
                    date.setMilliseconds(0);
                    localDateArr = KD.utils.Util.getDtParts(date);
                }

                ampmValue = parseInt(localDateArr[3], 10) >= 12 ? "PM" : "AM";
                localDateArr[6] = ampmValue;

                // reformat the hours
                var displayHr = parseInt(localDateArr[3], 10);
                if (displayHr > 12) {
                    displayHr -= 12;
                }
                if (displayHr == 0) {
                    displayHr = 12;
                }

                // set the selection fields
                yr.value=localDateArr[0];
                month.value=KD.utils.Util.padZeros(localDateArr[1], 2);
                day.value=KD.utils.Util.padZeros(localDateArr[2], 2);
                hour.value = KD.utils.Util.padZeros(displayHr, 2);
                min.value = KD.utils.Util.padZeros(localDateArr[4], 2);
                sec = KD.utils.Util.padZeros(localDateArr[5], 2);
                ampm.value = localDateArr[6];

                qstn.value = KD.utils.Util.formatUTCDateTime(localDateArr);
                if (local) {
                    local.value = KD.utils.Util.formatLocalDateTime(localDateArr);
                }
                if(originalValue != qstn.value && clientManager.isLoading==false){
                    KD.utils.Action._fireChange(qstn);
                }
            }
        };

        /**
         * Get a value of a field within a record based on the record item name
         * @method getRequestValue
         * @param {HTMLElemetn} record A record based on the result return from call the SimpleDataReqeuest
         * @param {String} name The name of the field in the record  (Such as "Last name")
         * @return {String} The value of the specified field name
         */
        this.getRequestValue = function (record, name) {
            if (record) {
                var fields = record.getElementsByTagName("field");
                for (var i = 0; i < fields.length; i++) {
                    if (fields[i].getAttribute("id")==name) {
                        if (fields[i].childNodes.length>0) {
                            return fields[i].firstChild.nodeValue;
                        } else {
                            return "";
                        }
                    }
                }
            }
            return "";
        };


        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Used for standard "pair" actions like hide/show, read/write, required/optional
         * Used for actions applied to parent elements like pages or sections.
         *
         * @method _iterActionCall
         * @private
         * @param {HTMLElement} nodeRef The reference node
         * @param {Function} fn The function to call for this event
         * @return void
         */
        this._iterActionCall = function (nodeRef, fn) {
            for (var j = 0; j < nodeRef.childNodes.length; j++) {
                var thisNode=nodeRef.childNodes[j];
                if ((thisNode.id) && (KD.utils.Util.getElementType(thisNode.id)) == "Question") {
                    var questionId = KD.utils.Util.getIDPart(thisNode.id)
                    fn.call(KD.utils.Action,questionId)
                } else if (thisNode.nodeName=="DIV") {
                    KD.utils.Action._iterActionCall(thisNode, fn)
                }
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Used for standard "pair" actions like hide/show, read/write, required/optional
         * Used for actions applied to parent elements like pages or sections.
         *
         * @method _standardActionCall
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @param {Function} fn The function to call for this event
         * @return void
         */
        this._standardActionCall = function (evt, clientAction, fn) {
            clientAction.currEvent=KD.utils.Util.cloneObj(evt);
            var obj=YAHOO.util.Event.getTarget(evt);
            var valid=true;
            if(clientAction.ifExpr){
                var expr=KD.utils.Util.trimString(clientAction.ifExpr);
                if(expr != ""){
                    valid=eval("("+expr+")");
                }
            }
            if(valid){
                var fields=clientAction.params;
                for (var i=0;i<fields.length; i++){
                    //eval("KD.utils.Action."+fn+"(fields[i]"));
                    fn.call(KD.utils.Action, fields[i]);
                }
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Sets the elements defined in the client-side event read-only.
         *
         * @method _makeReadOnly
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._makeReadOnly = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.setReadOnly);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Sets the elements defined in the client-side event writeable.
         *
         * @method _makeReadWrite
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._makeReadWrite = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.setReadWrite);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Makes the elements defined in the client-side event hidden.
         *
         * @method _hideInPlace
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._hideInPlace = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.hideElementInPlace);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Makes the elements defined in the client-side event visible.
         *
         * @method _showInPlace
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._showInPlace = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.showElementInPlace);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Inserts the elements defined in the client-side event (style="display:''");
         *
         * @method _insert
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._insert = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.insertElement);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Removes the elements defined in the client-side event (style="display:'none;'");
         *
         * @method _remove
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._remove = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.removeElement);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Makes all questions defined in the client-side event required.
         *
         * @method _makeRequired
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._makeRequired = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.makeQuestionRequired);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Makes all questions defined in the client-side event optional.
         *
         * @method _makeOptional
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._makeOptional = function (evt, clientAction){
            KD.utils.Action._standardActionCall(evt, clientAction,KD.utils.Action.makeQuestionOptional);
        };

        /*
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * For external set fields: the clientAction.params are [[qualParams],{SetFields-FieldMapping object}]
         *
         * @method _setFieldValues
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._setFieldValues = function (evt, clientAction) {
            var obj, valid, expr, qualParams, rqtParamString, connection;

            clientAction.currEvent = KD.utils.Util.cloneObj(evt);
            // possibly used internally in the eval expression
            obj = YAHOO.util.Event.getTarget(evt);

            // skip the event if using Review Request, because all the
            // answers are already populated
            if (clientManager.submitType !== 'ReviewRequest') {
                clientAction.currEvent = KD.utils.Util.cloneObj(evt);
                valid = true;
                if (clientAction.ifExpr) {
                    expr = KD.utils.Util.trimString(clientAction.ifExpr);
                    if (expr != "") {
                        valid = eval("("+expr+")");
                    }
                }
                if (valid) {
                    //Qual Params is an array of zero or more fields/variables to pass in to the asynch request
                    qualParams = clientAction.params[0];
                    rqtParamString = KD.utils.Action._buildParamString(qualParams);

                    if (clientAction.source == "bridge") {
                        KD.utils.Action.makeAsyncBridgeRequest(
                            'Set Fields - External',
                            clientAction.actionId,
                            rqtParamString,
                            {
                                success: KD.utils.Action._setFieldsCallback,
                                failure: function(response) {
                                    var message = response.getResponseHeader['X-Error-Message'];
                                    if (message == null) {
                                        message = "There was a problem executing a set fields event.";
                                    }
                                    KD.utils.Action.displayError(message, response);
                                },
                                argument: [clientAction]
                            }
                        )
                    } else {
                        connection = new KD.utils.Callback(KD.utils.Action._setFieldsCallback, KD.utils.Action._setFieldsCallback, clientAction);
                        KD.utils.Action.makeAsyncRequest('setFieldValues', clientAction.actionId, connection, rqtParamString, '', !clientAction.useGetEntry, clientAction.synchronous);
                    }
                }
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Builds up the request parameters (those passed in to the SDR qualification).
         * @method _buildParamString
         * @private
         * @param {Array} qualParams Array of <FLD>BASE|ANSWER</FLD> strings and retrieves the values from variables/questions.
         * @return {String} The parsed parameter string
         */
        this._buildParamString = function (qualParams) {
            var rqtParamString="", len = 0, thisParam, label, value, i;
            if (qualParams) {
                len = qualParams.length;
            }
            if (len > 0) {
                for(i = 0; i < len; i++) {
                    thisParam = qualParams[i];
                    if (thisParam) {
                        label = thisParam.split(";")[1];
                        value="";
                        //BASE Params are window js variable
                        if(thisParam.indexOf(";BASE</FLD>") > 0){
                            value=eval(label);
                            rqtParamString += "&"+encodeURIComponent(label)+"="+encodeURIComponent(value);
                        } else if (thisParam.indexOf(";ANSWER</FLD>") >0){
                            value=KD.utils.Action.getQuestionValue(label);
                            rqtParamString += "&"+encodeURIComponent(label)+"="+encodeURIComponent(value);
                        }
                    }
                }
            }
            return rqtParamString;
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * The function that is triggered when a Set Fields client-side action returns.
         * @method _setFieldsCallback
         * @private
         * @param {Object} o KD.utils.Callback object from the response object
         * @param {Number} recordIndex (optional) The selected index of the results table
         * @return void
         */
        this._setFieldsCallback = function (o, recordIndex) {
            var recordXML,
                clientAction=o.argument[0],
                records=KD.utils.Action.getMultipleRequestRecords(o),
                fMap, setFields, fireChange, setToNull, alertNoMatch, alertMsg,
                fireChangeArr, qstn, id, action, i, j, field, value,
                elements, bridgeAttributeValues, attributePattern, match;

            // The set fields list is the second clientAction parameter
            action=eval('('+clientAction.params[1]+')');

            if (records == null || records.length == 0) {
                if (action) {
                    // find out if this action clears field values on no match
                    setToNull = action.nullOnNoMatch;
                    // find out if this action alerts on no match
                    alertNoMatch = action.alertOnNoMatch;
                    alertMsg = action.alertMsg;

                    recordXML = "";
                }

                // alert if this event should alert user on no match
                if (alertNoMatch) {
                    if (alertMsg == null || alertMsg.length == 0) {
                        alertMsg = "No records matched the input value.";
                    }
                    alert(alertMsg);
                }

                // just return if no fields are being cleared.
                if (!setToNull) {
                    KD.utils.ClientManager.onSetFieldsReturn.fire(clientAction);
                    return;
                }
            }
            if (records.length > 1 && recordIndex == null) {
                recordXML = KD.utils.Action._openSelectionDialog(o);
                return;
            }
            if (records.length > 1 && recordIndex) {
                recordXML = records[recordIndex];
            } else {
                recordXML = recordXML || records[0];
            }

            if (action) {
                setFields=action.SetFields;
                fireChangeArr = [];
                bridgeAttributeValues = null;
                for (i=0; i<setFields.length;i++){
                    for (field in setFields[i]){
                        // if field is a string - simple mapping (pre ver 4.4)
                        if (typeof setFields[i][field] === "string") {
                            KD.utils.Action._handleSetReplace(field, setFields[i][field], recordXML);
                        }
                        // field is an array of field mapping objects (ver 4.4+)
                        else {
                            // get the field mapping
                            fMap = setFields[i][field][field];
                            // determine if this field value change should fire the change event
                            fireChange = setFields[i][field]["fire"];

                            // bridges need to handle field replacement a bit different than
                            // simple data request
                            if (clientAction.source === "bridge") {
                                // fmap looks like: <%=attribute["First Name"]%> <%=attribute["Last Name"]%>

                                // Parse the XML to get a list of attributes
                                if (bridgeAttributeValues == null) {
                                    bridgeAttributeValues = {};
                                    // ensure a record was returned
                                    if (recordXML != null) {
                                        elements = recordXML.getElementsByTagName('field');
                                        for (j = 0; j < elements.length; j += 1) {
                                            value = elements[j].textContent ?
                                                elements[j].textContent : elements[j].text;
                                            bridgeAttributeValues[elements[j].getAttribute('id')] = value;
                                        }
                                    }
                                }

                                // Build the result string
                                attributePattern = /<%=\s*attribute\["(.+?)"\]\s*%>/;
                                value = fMap;
                                match = attributePattern.exec(value);
                                while (match != null) {
                                    value = value.replace(match[0], bridgeAttributeValues[match[1]]);
                                    match = attributePattern.exec(value);
                                }
                                fMap = value;
                            }
                            KD.utils.Action._handleSetReplace(field, fMap, recordXML, setToNull);

                            // keep track of what questions need to fire the change event
                            if (fireChange === "true") {
                                fireChangeArr.push(field);
                            }
                            // fire the change event for questions set to fire immediately
                            if (fireChange === "immediate") {
                                qstn = KD.utils.Util.getQuestionInput(field);
                                if (qstn) {
                                    KD.utils.Action._fireChange(qstn);
                                }
                            }
                        }
                    }
                }
                // fire the change event on questions after all values have been
                // set in case the event uses the new question values.
                for (i=0; i<fireChangeArr.length;i++) {
                    id = fireChangeArr[i];
                    qstn = KD.utils.Util.getQuestionInput(id);
                    if (qstn) {
                        KD.utils.Action._fireChange(qstn);
                    }
                }
            }
            KD.utils.ClientManager.onSetFieldsReturn.fire(clientAction);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Opens the calendar date or date/time picker
         * @method _openCalendarPicker
         * @private
         * @param {Event} evt The event element that launced the calendar picker
         * @param {String} id The instanceId of the question element
         * @param {HTMLElement} calEl The DOM element that contains the calendar picker
         * @param {Object} cal The YAHOO Calendar object
         * @return void
         */
        this._openCalendarPicker = function (evt, id, calEl, cal) {
            var theQuestion=KD.utils.Util.getQuestionInput(id);
            var topPos=0;
            var clickXY=Dom.getXY(YAHOO.util.Event.getTarget(evt));
            if (clickXY[1]-150 > 0){
                topPos=clickXY[1]-150;
            }
            var leftPos=clickXY[0]+25;
            if (leftPos+150 > document.body.offsetWidth){
                leftPos=document.body.offsetWidth-150;
            }
            calEl.style.position="absolute";
            calEl.style.top=parseInt(topPos)+"px";
            calEl.style.left=parseInt(leftPos)+"px";

            var months=Dom.get("month_"+id).options;
            var months2= new Array();
            var offset = months.length - 12;
            for (var i=offset;i <months.length; i++){
                months2[i-offset]=months[i].text;
            }

            if(theQuestion.value && theQuestion.value != ""){
                var theDate=new Date();
                var parts = KD.utils.Util.parseDtString(theQuestion.value);
                if (parts.length > 0) {
                    theDate.setYear(parts[0]);
                    theDate.setMonth(parts[1]-1);//months needed for cal are 0-11
                    theDate.setDate(parts[2]);
                    cal.setYear(theDate.getFullYear());
                    cal.setMonth(theDate.getMonth());
                }

                // date/time question
                if (parts.length > 3) {
                    theDate.setHours(parts[3]);
                    theDate.setMinutes(parts[4]);
                    theDate.setSeconds(parts[5]);
                    cal.setHour(theDate.getHours());
                    cal.setMinute(theDate.getMinutes());
                    cal.setSecond(theDate.getSeconds());
                }
                cal.select(theDate);
            }
            cal.cfg.setProperty("HIDE_BLANK_WEEKS", true);
            cal.cfg.setProperty("MONTHS_LONG", months2);
            cal.cfg.setProperty("close", true);
            cal.selectEvent.subscribe(KD.utils.Action.dateSelected, [id, cal]);
            cal.render();
            cal.show();
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Opens the dialog to display the results table.  Includes formatting of the table and dialog.
         * @method _openSelectionDialog
         * @private
         * @param {Object} o The KD.utils.Callback response object
         * @return void
         */
        this._openSelectionDialog = function (o) {
            var recordXMLArray = KD.utils.Action.getMultipleRequestRecords(o),
            clientAction=o.argument[0],
            useAdvanced = true,
            classSuffix = '',
            resultsTable,
            action,
            setFields;

            // determine if displaying results as simple or advanced
            action=eval('('+clientAction.params[1]+')');
            if (action) {
                setFields=action.SetFields;
                if (setFields && setFields.length) {
                    try {
                        for (var field in setFields[0]) {
                            // if field is not a string - use advanced table (V4.4+)
                            if (typeof setFields[0][field] === "string") {
                                useAdvanced = false;
                            }
                            break;
                        }
                    } catch (e) {}
                }

                if (useAdvanced) {
                    classSuffix = 'Adv';
                    resultsTable = KD.utils.Action.showResultsAsAdvancedTable(recordXMLArray, setFields, clientAction.source);
                } else {
                    resultsTable = KD.utils.Action.showResultsAsTable(recordXMLArray);
                }

                resultsTable.className += " resultsTable" + classSuffix;
                var elementType=KD.utils.Util.getElementType(clientAction.elObj.id);
                var cfg = {
                    modal:true,
                    draggable:false
                };

                if (elementType && elementType.toUpperCase() != "PAGE") {
                    cfg.context = [clientAction.elObj,"tl","bl"];
                }
                if (elementType && elementType.toUpperCase() == "PAGE") {
                    cfg.xy = [50,10];
                }

                var myDialogId = "selectionLayer_" + clientAction.actionId;
                var myDialog = new YAHOO.widget.Panel(myDialogId, cfg);

                /*Set Up Listeners */
                var recRows = KD.utils.Util.getElementsByClassName('record', 'tr',resultsTable);
                for (var r=0; r<recRows.length; r++) {
                    YAHOO.util.Event.addListener(recRows[r],'click', KD.utils.Action._selectItem, [o,r,myDialog]);
                    YAHOO.util.Event.addListener(recRows[r],'mouseover', KD.utils.Action._mouseItem, [true]);
                    YAHOO.util.Event.addListener(recRows[r],'mouseout', KD.utils.Action._mouseItem, [false]);
                }
                /*End Listeners */

                clientAction.elObj.blur(); //Don't allow them to type anymore
                myDialog.setBody("<div class='multItemsHeader" + classSuffix + "'>Multiple Items Found (select one):</div>");

                //If the table is too small (one or two columns), increase size
                //to make it more visible.  Note that this should be done before
                //the results table is appended to the dialog to prevent a
                //display issue in IE7 (Standards Mode) where the dialog does
                //not resize properly when the table size is changed.
                if (resultsTable.offsetWidth < 225) {
                    resultsTable.style.width="225px";
                }

                myDialog.appendToBody(resultsTable);
                myDialog.render(document.body);

                // give focus to the panel
                try {
                    myDialog.focus();
                } catch (e) {}

                //If the dialog is over 60% of the screen show scroll bars
                var dlgWidth = (resultsTable.offsetWidth/Dom.getClientWidth());
                if (dlgWidth >0.60) {
                    myDialog.body.style.overflow="auto";
                    myDialog.body.style.width=String(Dom.getClientWidth()/2)+"px";
                }
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Highlight or remove highlight of a row
         * @method _mouseItem
         * @private
         * @param {Event} evt The row element that was moused over or moused out
         * @param {Array} args
         * @return void
         */
        this._mouseItem = function (evt, args) {
            var isMouseOver=args[0];
            var thisEl=YAHOO.util.Event.getTarget(evt);
            if(thisEl.nodeName=="TD"){
                thisEl=thisEl.parentNode;
            }
            if(thisEl.nodeName=="DIV"){
                thisEl=thisEl.parentNode.parentNode;
            }
            if (isMouseOver) {
                thisEl.setAttribute('previousClass',thisEl.className);
                thisEl.className="resultsTableHover";
            } else {
                var prevCls=thisEl.getAttribute('previousClass');
                if (prevCls != null) {
                    thisEl.className=prevCls;
                }
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Callback from clicking a row in the selection table or close button
         * @method _selectItem
         * @private
         * @param {String} type The type of event ("click")
         * @param {Array} args
         *         args[0] is the original callback object including the XML of the request
         *         args[1] is the row clicked
         *         args[2] is the dialog
         * @return void
         */
        this._selectItem = function (type, args) {
            var myDialog=args[2];
            myDialog.hide();
            if (args[0] != null && args[1] != null) {
                KD.utils.Action._setFieldsCallback(args[0], args[1]);
            }
            myDialog.destroy();
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Sets the field values for Set Fields - Internal client side events
         * @method _setInternalFieldValues
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._setInternalFieldValues = function (evt, clientAction) {
            var obj, valid, expr, action, setFields, i, field;

            clientAction.currEvent = KD.utils.Util.cloneObj(evt);
            // possibly used internally in the eval expression
            obj = YAHOO.util.Event.getTarget(evt);

            // skip the event if using Review Request, because all the
            // answers are already populated
            if (clientManager.submitType !== 'ReviewRequest') {
                valid = true;
                clientAction.currEvent = KD.utils.Util.cloneObj(evt);
                if (clientAction.ifExpr) {
                    expr = KD.utils.Util.trimString(clientAction.ifExpr);
                    if (expr != "") {
                        valid = eval("(" + expr + ")");
                    }
                }
                if (valid) {
                    try {
                        action = eval('(' + clientAction.params[1] + ')');
                    } catch(err) {
                        alert(err.description);
                    }
                    if (action) {
                        setFields = action.SetFields;
                        var fireChangeArr = [];
                        for (i = 0; i < setFields.length; i += 1) {
                            for (field in setFields[i]) {
                                // if field is a string - simple mapping (pre ver 4.4)
                                if (typeof setFields[i][field] === "string") {
                                    KD.utils.Action._handleSetReplace(field, setFields[i][field]);
                                } else {
                                    // field is an array of field mapping objects (ver 4.4+)
                                    var fMap = setFields[i][field][field];
                                    var fireChange = setFields[i][field]["fire"];
                                    KD.utils.Action._handleSetReplace(field, fMap);
                                    // keep track of what questions need to fire the change event
                                    if (fireChange === "true") {
                                        fireChangeArr.push(field);
                                    }
                                }
                            }
                        }
                        // fire the change event on questions after all values have been
                        // set in case the event uses the new question values.
                        for (i=0; i<fireChangeArr.length;i++) {
                            var id = fireChangeArr[i];
                            var qstn = KD.utils.Util.getQuestionInput(id);
                            if (qstn) {
                                KD.utils.Action._fireChange(qstn);
                            }
                        }
                    }
                }
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Runs the Simple Data Request for the Populate Menu action
         * @method _attachMenu
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._attachMenu = function (evt, clientAction) {
            var obj, valid, expr, action, attachMenu, selectObj, val, option,
                qualParams, rqtParamString, connection;

            clientAction.currEvent = KD.utils.Util.cloneObj(evt);
            // possibly used internally in the eval expression
            obj = YAHOO.util.Event.getTarget(evt);
            valid = true;
            if (clientAction.ifExpr) {
                expr = KD.utils.Util.trimString(clientAction.ifExpr);
                if (expr != "") {
                    valid = eval("(" + expr + ")");
                }
            }
            if (clientManager.submitType === 'ReviewRequest') {
                action = eval('(' + clientAction.params[1] + ')');
                if (action) {
                    attachMenu = action.AttachMenu[0];
                    selectObj = KD.utils.Util.getQuestionInput(attachMenu.AttachTo);
                    if (selectObj) {
                        val = selectObj.getAttribute('originalValue');
                        if (val && val != 'null') {
                            // create a new option to display the selected value
                            option = document.createElement('option');
                            option.text = val;
                            option.value = val;
                            // append to the list of existing options and select
                            try  {
                                selectObj.add(option, null); /* standards compliant */
                            } catch (ex)  {
                                selectObj.add(option); /* IE only */
                            }
                            // select the inserted option
                            try {
                                selectObj.options[selectObj.length - 1].setAttribute('selected', 'true');
                                selectObj.value = selectObj.options[selectObj.length - 1].value;
                            } catch (ex1) {
                            /* ignore */
                            }
                        }
                    }
                }
                valid = false;
            }
            if (valid) {
                //Qual Params is an array of zero or more fields/variables to pass in to the asynch request
                qualParams = clientAction.params[0];
                rqtParamString = KD.utils.Action._buildParamString(qualParams);

                if (clientAction.source == "bridge") {
                    KD.utils.Action.makeAsyncBridgeRequest(
                        'Populate Menu',
                        clientAction.actionId,
                        rqtParamString,
                        {
                            success: KD.utils.Action._attachMenuCallback,
                            failure: function(response) {
                                var message = response.getResponseHeader['X-Error-Message'];
                                if (message == null) {
                                    message = "There was a problem executing a set fields event.";
                                }
                                KD.utils.Action.displayError(message, response);
                            },
                            argument: [clientAction]
                        }
                    )
                } else {
                    connection = new KD.utils.Callback(KD.utils.Action._attachMenuCallback, KD.utils.Action._attachMenuCallback, clientAction);
                    clientAction.isOnLoad = clientManager.isLoading;
                    // always make synchronous calls when attaching a menu (last param set to true)
                    KD.utils.Action.makeAsyncRequest('attachMenu', clientAction.actionId, connection, rqtParamString, '', !clientAction.useGetEntry, true);
                }
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Callback for the Populate Menu action
         * @method _attachMenuCallback
         * @private
         * @param {Object} o The KD.utils.Callback resonse object
         * @return void
         */
        this._attachMenuCallback = function (o) {
            var clientAction=o.argument[0];
            var recordsXML=KD.utils.Action.getMultipleRequestRecords(o);
            //Only populate the menu if we find some records
            if(recordsXML){
                //The second parameter is the attach menu object
                var action=eval('('+clientAction.params[1]+')');
                if (action) {
                    var attachMenu=action.AttachMenu[0];
                    var optionValueField, optionTextField;

                    if (clientAction.source == "bridge") {
                        optionValueField = attachMenu.ValueField;
                        optionTextField = attachMenu.LabelField;
                    } else {
                        var oOptionValue = attachMenu.ValueField.split(";");
                        optionValueField = oOptionValue[1];
                        var oOptionLabel = attachMenu.LabelField.split(";");
                        optionTextField = oOptionLabel[1];
                    }

                    var targetList = KD.utils.Util.getQuestionInput(attachMenu.AttachTo);
                    // remove existing options
                    for (var h=targetList.options.length-1; h>=0; h--) {
                        targetList.remove(h);
                    }
                    // add a blank option
                    var blankOption = document.createElement("option");
                    blankOption.setAttribute("value", "");
                    targetList.appendChild(blankOption);
                    //Reset width to avoid IE bug
                    targetList.style.width = "1";
                    // add the unique option(s) found by the request
                    var uniqueValueHash=new KD.utils.Hash();
                    for (var i=0; i<recordsXML.length; i++) {
                        var optionValue = KD.utils.Util._escapeSpecialChars(KD.utils.Action.getRequestValue(recordsXML[i], optionValueField));
                        var optionText = KD.utils.Action.getRequestValue(recordsXML[i], optionTextField);
                        var checkExists=uniqueValueHash.getItem(optionValue+"--"+optionText);
                        if(checkExists == null){
                            var newOption = document.createElement("option");
                            newOption.setAttribute("value", optionValue);
                            newOption.appendChild(document.createTextNode(optionText));
                            targetList.appendChild(newOption);
                            uniqueValueHash.setItem(optionValue+"--"+optionText, optionValue);
                        }
                    }
                    //Reset width back to avoid IE bug
                    targetList.style.width = "auto";
                    //fire an onchange for the field menu attached to
                    targetList.setAttribute('menuAttached','true');
                }
                //Set the attached menu to the original value if this is an onload event
                KD.utils.Action.setQuestionValue(attachMenu.AttachTo, targetList.getAttribute("originalValue"));
            }
            KD.utils.ClientManager.onAttachMenu.fire(clientAction);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Callback for the Set Fields - External action
         * Take an element obj (or array for radios), substitute and &lt;FLD&gt; items and set the field
         *
         * @method _handleSetReplace
         * @private
         * @param {String} destElId The id of the question that will be set
         * @param {String} rawValue The raw value
         * @param {String} recordXML The XML of the selected record
         * @param {Boolean} setToNull True to clear the field value
         * @return void
         */
        this._handleSetReplace = function (destElId, rawValue, recordXML, setToNull) {
            var value = "";
            if (setToNull) {
                value = "$NULL$";
            } else {
                var flds=rawValue.split("</FLD>");
                for (var i=0; i<flds.length; i++){
                    //Just static text in this token
                    if (flds[i].indexOf("<FLD>")== -1){
                        value += flds[i];
                    } else{
                        //Get the static part out if there is some
                        var segs=flds[i].split("<FLD>");
                        if(segs.length>1){
                            value += segs[0];
                        }

                        //Get the instance ID out of the <FLD> area and get value
                        //EXTERNAL
                        if(recordXML){
                            var fieldName=(flds[i].split(";")[0]).substring(flds[i].indexOf("<FLD>")+5);
                            value += KD.utils.Action.getRequestValue(recordXML, fieldName);
                        //INTERNAL
                        }else{
                            var instId=flds[i].split(";")[1];
                            value += KD.utils.Action.getQuestionValue(instId);
                        }
                    }
                }
            }
            // convert intentional apostrophes to real apostrophes
            value = value.replace(/__&#39;__/gi, "'");
            // Set the question value
            KD.utils.Action.setQuestionValue(destElId, KD.utils.Util.trimString(value));
        };

        /**
         * <p>
         * Replaces the innerHTML of a DOM element with the results of a simple
         * data request.  The simple data request is typically rendered through
         * a JSP partial.
         * </p>
         *
         * <p>
         * The DOM element and the simple data request can be obtained from the
         * argument object.
         * <ul>
         * <li>DOM element: o.argument[0]</li>
         * <li>Simple Data Request results: o.responseText</li>
         * </ul>
         * </p>
         *
         * @method _addInnerHTML
         * @param {Object} o The KD.utils.Callback response from the Simple Data Reqeust.
         * @return void
         */
        this._addInnerHTML = function (o) {
            var elId=o.argument[0];
            if(elId && elId.length){
                elId = elId[0];
            }
            var el = Dom.get(elId);
            if(el){
                if(o.responseText && o.responseText.indexOf("<errorMessage>") != -1  && o.responseText.indexOf("invalid session") != -1){
                    var yes=confirm("Your session has timed out.  Would you like to reload the page?");
                    if (yes) {
                        window.location.reload(true);
                    }
                }
                var htmlString=o.responseText;
                el.innerHTML=htmlString;
            }
        };

        /**
         * Triggers the "onChange" event for the specified DOM element.
         *
         * Typically when the value of an input field is changed programatically,
         * the input field does not trigger the onChange event.  After setting
         * the value of the input field, call this method to programatically
         * trigger the onChange event.
         *
         * @method _fireChange
         * @param {HTMLElement} el The DOM element to fire the onChange event
         * @return void
         */
        this._fireChange = function (el) {
            if (el.dispatchEvent) {
                var evt = document.createEvent('HTMLEvents');
                evt.initEvent('change', true, true);
                el.dispatchEvent(evt);
            } else {
                el.fireEvent('onchange');
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Evaluates the custom client-side event to determine if the event needs
         * to run based on the ifExpression qualification.  If this evaluates to
         * true, then the custom code is executed.
         *
         * @method _customAction
         * @private
         * @param {Event} evt An event triggered by a DOM element
         * @param {Object} clientAction The custom client side action to execute
         * @return {Event} Executes the custom client side action
         */
        this._customAction = function (evt, clientAction) {
            clientAction.currEvent = KD.utils.Util.cloneObj(evt);
            if (evt) {
                var obj = YAHOO.util.Event.getTarget(evt);
            }
            var valid = true;
            try {
                if (clientAction.ifExpr) {
                    var expr = KD.utils.Util.trimString(clientAction.ifExpr);
                    if (expr != "") {
                        valid = eval("("+expr+")");
                    }
                }
                if (valid) {
                    return eval(clientAction.params[0]);
                }
            } catch(error){
                alert("There was an error with the custom javascript:"+error);
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Toggle between a file link and the input value for attachment questions.
         *
         * @method _setFileLink
         * @private
         * @param {HTMLElement} qstnEl The question input element
         * @return void
         */
        this._setFileLink = function (qstnEl) {
            var link=Dom.get(qstnEl.getAttribute("id")+"_link");
            if(link){
                var qstn=link.parentNode;
                qstn.removeChild(link);
            }
            if(qstnEl.value && qstnEl.value != ""){
                //Build link and layer
                link = document.createElement('a');
                link.setAttribute('id', qstnEl.getAttribute("id")+"_link");
                link.setAttribute('target','_blank');
                var sessionId=encodeURIComponent(KD.utils.ClientManager.sessionId);
                var now = new Date();
                var questionId=encodeURIComponent(KD.utils.Util.getIDPart(qstnEl.getAttribute("id")));
                var path = "SimpleDataRequest?requestName=getFile&dataRequestId=attachment&sessionId="+sessionId+"&questionId="+questionId+"&noCache="+now.getTime()+"&fileName="+encodeURIComponent(qstnEl.value);
                link.setAttribute('href', path);
                link.className="fileLink";
                link.style.marginRight="20px";
                var fileName=document.createTextNode(qstnEl.value);
                link.appendChild(fileName);
                qstnEl.originalDisplay=qstnEl.style.display;
                qstnEl.style.display="none";
                var qstnLyr=qstnEl.parentNode;
                var first = qstnLyr.firstChild;
                qstnLyr.insertBefore(link,first);
            } else{
                if(!qstnEl.originalDisplay || !qstnEl.originalDisplay ==""){
                    qstnEl.originalDisplay="inline";
                }
                qstnEl.style.display=qstnEl.originalDisplay;
            }
        };

        /**
         * Locks a Submission so only one user can modify it
         *
         * @method submissionLock
         * @param {String} csrv The instanceId of the submission
         * @param {Object} options (optional) Options for the request:
         *     responseFormat (json | xml) - default is json
         *     timeout    - default is 10000 ms
         *     confirm    - whether the user will be prompted to confirm or not
         *     confirmMsg - if user must confirm, the confirmation prompt
         *     success    - the callback function to run on success
         *     failure    - the callback function to run on failure
         *     argument   - array of arguments passed to the callback function,
         *                  the first element is typically the id of the html
         *                  element to display the response results, but the
         *                  callback function needs to know the order of the
         *                  arguments it is processing.
         * @return void
         */
        this.submissionLock = function (csrv, options) {
            options = KD.utils.Action._buildSubmissionLockOptions(options, "lock");
            KD.utils.Action._doSubmissionLockAction(csrv, options);
        };

        /**
         * Unlocks a Submission
         *
         * @method submissionUnlock
         * @param {String} csrv The instanceId of the submission
         * @param {Object} options (optional) Options for the request:
         *     responseFormat (json | xml) - default is json
         *     timeout    - default is 10000 ms
         *     confirm    - whether the user will be prompted to confirm or not
         *     confirmMsg - if user must confirm, the confirmation prompt
         *     success    - the callback function to run on success
         *     failure    - the callback function to run on failure
         *     argument   - array of arguments passed to the callback function,
         *                  the first element is typically the id of the html
         *                  element to display the response results, but the
         *                  callback function needs to know the order of the
         *                  arguments it is processing.
         * @return void
         */
        this.submissionUnlock = function (csrv, options) {
            options = KD.utils.Action._buildSubmissionLockOptions(options, "unlock");
            KD.utils.Action._doSubmissionLockAction(csrv, options);
        };

        /**
         * Checks if a submission is locked
         *
         * @method isSubmissionLocked
         * @param {String} csrv The instanceId of the submission
         * @param {Object} options (optional) Options for the request:
         *     responseFormat (json | xml) - default is json
         *     timeout    - default is 10000 ms
         *     confirm    - whether the user will be prompted to confirm or not
         *     confirmMsg - if user must confirm, the confirmation prompt
         *     success    - the callback function to run on success
         *     failure    - the callback function to run on failure
         *     argument   - array of arguments passed to the callback function,
         *                  the first element is typically the id of the html
         *                  element to display the response results, but the
         *                  callback function needs to know the order of the
         *                  arguments it is processing.
         * @return void
         */
        this.isSubmissionLocked = function (csrv, options) {
            options = KD.utils.Action._buildSubmissionLockOptions(options, "isLocked");
            KD.utils.Action._doSubmissionLockAction(csrv, options);
        }

        /**
         * Checks if a submission is locked by the current user
         *
         * @method isSubmissionLockedByMe
         * @param {String} csrv The instanceId of the submission
         * @param {Object} options (optional) Options for the request:
         *     responseFormat (json | xml) - default is json
         *     timeout    - default is 10000 ms
         *     confirm    - whether the user will be prompted to confirm or not
         *     confirmMsg - if user must confirm, the confirmation prompt
         *     success    - the callback function to run on success
         *     failure    - the callback function to run on failure
         *     argument   - array of arguments passed to the callback function,
         *                  the first element is typically the id of the html
         *                  element to display the response results, but the
         *                  callback function needs to know the order of the
         *                  arguments it is processing.
         * @return void
         */
        this.isSubmissionLockedByMe = function (csrv, options) {
            options = KD.utils.Action._buildSubmissionLockOptions(options, "isLockedByMe");
            KD.utils.Action._doSubmissionLockAction(csrv, options);
        }

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Attempts to lock a submission so only the user locking the submission
         * can make modifications to it.  The user attempting to lock the
         * submission must have permission to do so as defined by the service
         * item template.
         *
         * @method _submissionLock
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._submissionLock = function (evt, clientAction) {
            KD.utils.Action._submissionLockUnlockCheck(evt, clientAction);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Attempts to unlock a submission that may or may not have been locked.
         * The user attempting to unlock the submission must have permission to
         * do so as defined by the service item template.
         *
         * @method _submissionUnlock
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._submissionUnlock = function (evt, clientAction) {
            KD.utils.Action._submissionLockUnlockCheck(evt, clientAction);
        };

        /**
         * PRIVATE INTERNAL FUNCTION--CLIENT SIDE ACTIONS
         *
         * Builds the options object and adds the action option paramter.  If
         * the options are passed as a JSON string, utilizes the YUI JSON library
         * to parse the string to a js object.
         *
         * @method _buildSubmissionLockOptions
         * @private
         * @param {Object | String} options (optional) Options for the request:
         *     responseFormat (json | xml) - default is json
         *     timeout - default is 10000 ms
         *     confirm - whether the user should be prompted to confirm or not
         *     confirmMsg - if user must confirm, what the confirmation message will be
         * @param {String} action (optional) The action to perform on the
         *     SubmissionLock servlet
         * @return {Object} the built up options
         */
        this._buildSubmissionLockOptions = function (options, action) {
            if (typeof options === "string") {
                // validate the JSON library is loaded
                KD.utils.Action.validateJsonLoaded();
                // parse the options string
                options = YAHOO.lang.JSON.parse(options);
            }
            options = options || {};
            if (action) {
                options.action = action;
            }
            return options;
        };

        /**
         * PRIVATE INTERNAL FUNCTION
         *
         * Common code to check if the event RunIf qualification evaluates to
         * true before executing the event.
         *
         * @method _submissionLockUnlockCheck
         * @private
         * @param {Event} evt The event that triggered this action
         * @param {Object} clientAction The client side event action
         * @return void
         */
        this._submissionLockUnlockCheck = function (evt, clientAction) {
            clientAction.currEvent = KD.utils.Util.cloneObj(evt);
            var expr, options, valid = true;
            if (clientAction.ifExpr) {
                expr = KD.utils.Util.trimString(clientAction.ifExpr);
                if (expr != "") {
                    valid = eval("(" + expr + ")");
                }
            }
            if (valid) {
                // build the options and call the submission lock servlet
                options = KD.utils.Action._buildSubmissionLockOptions(clientAction.params[0]);
                KD.utils.Action._doSubmissionLockAction(clientManager.customerSurveyId, options);
            }
        };

        /**
         * Removes the submit buttons from the DOM for whatever reason
         *
         * @method _removeSubmitButtons
         * @return void
         */
        this._removeSubmitButtons = function () {
            var
            i = 0,
            buttons = KD.utils.Util.getElementsByClassName('templateButtonLayer', 'div', 'pageQuestionsForm');

            // first disable the button events to avoid a memory leak
            KD.utils.Action._disableButtonEvents();

            // remove the button layers
            for (i = 0; i < buttons.length; i += 1) {
                buttons[i].parentNode.removeChild(buttons[i]);
            }
        }

        /**
         * Removes the event listener on the submit button clicks.
         *
         * @method _disableButtonEvents
         * @param {Event} e The click event from the button element
         * @return void
         */
        this._disableButtonEvents = function (e) {
            var buttons = KD.utils.ClientManager.submitButtons,
            buttonDiv,
            buttonEls,
            theButton;

            KD.utils.ClientManager.buttonListeners = {};
            for (var i = 0; i < buttons.length;  i += 1) {
                buttonDiv = Dom.get("BUTTON_" + buttons[i]);
                buttonEls = KD.utils.Util.getElementsByClassName('templateButton', 'input', buttonDiv);
                if (buttonEls && buttonEls.length > 0) {
                    theButton = buttonEls[0];
                    YAHOO.util.Event.removeListener(theButton, "click");
                }
            }
        };

        /**
         * Adds the event listener on the submit button clicks.
         *
         * @method _enableButtonEvents
         * @param {Event} e The click event from the button element
         * @return void
         */
        this._enableButtonEvents = function (e) {
            var buttons = KD.utils.ClientManager.submitButtons,
            buttonDiv,
            buttonEls,
            theButton;

            for (var i = 0; i < buttons.length;  i += 1) {
                buttonDiv = Dom.get("BUTTON_" + buttons[i]);
                buttonEls = KD.utils.Util.getElementsByClassName('templateButton', 'input', buttonDiv);
                if (buttonEls && buttonEls.length > 0) {
                    theButton = buttonEls[0];
                    YAHOO.util.Event.addListener(theButton, 'click', KD.utils.Action._submitButtonClick,
                        [ theButton.form, KD.utils.Util.getIDPart(buttonDiv.id)], true);
                }
            }
            KD.utils.ClientManager.buttonListeners = {};
        };

        /**
         * Event handler for the submit button click.
         *
         * @method _submitButtonClick
         * @private
         * @param {Event} e The click event from the button element
         * @param {Array} parms An arary containing two parameter values:
         *   0 - the form to submit
         *   1 - the id of the button element that was clicked
         * @return void
         */
        this._submitButtonClick = function (e, parms) {
            if (KD.utils.ClientManager.isSubmitting != true) {
                var theForm = parms[0];
                var id = parms[1];
                KD.utils.ClientManager.isSubmitting = true;
                KD.utils.Action.disableButton(id);
                KD.utils.Action.validateForm(e, theForm);
            }
        };


        /* CUSTOM EVENT HANDLERS */

        /**
         * Event handler for the onSetFieldsReturn custom event
         *
         * @method _setFieldsEventHandler
         * @private
         * @param {Object} origAction
         * @param {Object} clientAction The KD.utils.ClientAction object
         * @param {Event} origEvent
         * @return void
         */
        this._setFieldsEventHandler = function(origAction, clientAction, origEvent){
            //Check if the event is tied to this element
            if(origAction.elementId==clientAction.elementId){
                clientAction.action.apply(KD.utils.Action,[origEvent,clientAction]);
            }else{
                return;
            }
        };

        /**
         * Event handler for the onAttachMenu custom event
         *
         * @method _attachMenuEventHandler
         * @private
         * @param {Object} origAction
         * @param {Object} clientAction The KD.utils.ClientAction object
         * @param {Event} origEvent
         * @return void
         */
        this._attachMenuEventHandler = function(origAction, clientAction, origEvent){
            //Check if the event is tied to this element
            var theEl=eval('('+origAction.params[1]+')');
            if(theEl && theEl.AttachMenu && theEl.AttachMenu[0].AttachTo ==clientAction.elementId){
                clientAction.action.apply(KD.utils.Action,[origEvent,clientAction]);
            }
        };

        /**
         * Event handler for the custom event
         *
         * @method _customEventHandler
         * @private
         * @param {String} type The type of event: click, load, blur, etc...
         * @param {Array} origItems
         * @param {Object} clientAction The KD.utils.ClientAction object
         * @return void
         */
        this._customEventHandler = function(type, origItems, clientAction){
            var origAction=origItems[0];
            if(!origAction){
                return;
            }
            var origEvent=origAction.currEvent;
            if(!origEvent){
                //Create a literal event object
                var theTarget=KD.utils.Util.getQuestionInput(origAction.elementId);
                origEvent={
                    button: 0,
                    which:1,
                    target:theTarget,
                    type: origAction.jsEvent
                };
            }
            if(type=="onSetFieldsReturn"){
                KD.utils.Action._setFieldsEventHandler(origAction, clientAction, origEvent);
            }else if(type == "onAttachMenu"){
                KD.utils.Action._attachMenuEventHandler(origAction, clientAction, origEvent);
            }
        };


        /**
         * PRIVATE INTERNAL FUNCTION
         *
         * Create an XmlHttpRequest object to make a synchronous AJAX request
         * and return the object.
         *
         * @method _createSyncXhr
         * @private
         * @return {XMLHttpRequest | ActiveXObject}
         */
        this._createSyncXhr = function() {
            var obj = {},
            oXhr = null,
            oAX = ["MSXML2.XMLHTTP.3.0", "MSXML2.XMLHTTP", "Microsoft.XMLHTTP"];

            // make call Synchronously
            try {
                // try creating an XMLHttpRequest object
                oXhr = new XMLHttpRequest();
            } catch (e) {
                // didn't work, try with an ActiveXObject object
                for (var i=0; i < oAX.length; i+=1) {
                    try {
                        oXhr = new ActiveXObject(oAX[i]);
                        break;
                    } catch (e2) {}
                }
            }
            obj.xhr = oXhr;
            return obj;
        };

        /**
         * PRIVATE INTERNAL FUNCTION
         *
         * Builds up the response object for synchronous xmlhttp requests
         *
         * @method _buildSyncResponse
         * @private
         * @param {XMLHttpRequest | ActiveXObject} xhr the XMLHttpRequest or ActiveXObject object
         * @param {Object} callbackArg the callback argument from the callback object
         * @return {Object} the response object with headers, status, response, and callback argument
         */
        this._buildSyncResponse = function(xhr, callbackArg) {
            var oRes = {},
            oHeader = {},
            headerStr,
            header,
            delimitPos;

            try
            {
                headerStr = xhr.getAllResponseHeaders();
                header = headerStr.split('\n');
                for(var i=0; i<header.length; i++){
                    delimitPos = header[i].indexOf(':');
                    if(delimitPos != -1){
                        oHeader[header[i].substring(0,delimitPos)] = header[i].substring(delimitPos+2);
                    }
                }
            }
            catch(e){}

            oRes.status = xhr.status;
            oRes.statusText = xhr.statusText;
            oRes.getResponseHeader = oHeader;
            oRes.getAllResponseHeaders = headerStr;
            oRes.responseText = xhr.responseText;
            oRes.responseXML = xhr.responseXML;

            if (typeof callbackArg != "undefined") {
                oRes.argument = callbackArg;
            }
            return oRes;
        };

        /**
         * Handles session check errors.
         * Either displays a simple login dialog if the status code is 401, otherwise
         * an alert message is displayed with the error message.
         *
         * @method handleHttpErrorCode
         * @param {Number} statusCode The status code in the response
         * @param {String} message The error message
         * @return void
         */
        this.handleHttpErrorCode = function (statusCode, message) {
            if (statusCode == 401) {
                KD.utils.ClientManager.renderSimpleLogin();
            } else if (statusCode == 0) {
                alert("The web server hasn't responded in a reasonable amount of time.\nPlease try the request again.");
            } else {
                alert('Error: ' + statusCode + '\n\n' + message);
            }
        };

        /**
         * PRIVATE INTERNAL FUNCTION
         *
         * Attempts to perform a submission locking action.  By default this
         * method attempts to lock the submission, but the action can be
         * specified by passing the action string to the configuration options
         * 'action' parameter.
         *
         * @method _doSubmissionLockAction
         * @private
         * @param {String} csrv The instance id of the submission record
         * @param {Object} cfg Configuration options for the connection
         * @return void
         */
        this._doSubmissionLockAction = function (csrv, cfg) {
            /**
            * A hashmap of configuration properties.  All properties are customizable
            * by the user implementation.
            * @property configObj
            * @type Object
            * @private
            */
            var configObj = {
                /* lock or unlock, defines what action needs to be performed */
                action: "lock",

                /* format of the response: json or xml */
                responseFormat: "json",

                /* calls the SubmissionLock servlet */
                url: "SubmissionLock",

                /* amount of time before the AJAX request aborts (milliseconds) */
                timeout: 10000,

                /* whether user confirmation is required after calling the function */
                confirm: false,

                /* message strings */
                confirmMsg: "Are you sure?",
                nullCsrvMsg: "A submission id is required",
                authErrorMsg: "User is not authenticated"
            };


            // replace the configuration object properties with user specifics
            for (var property in cfg) {
                configObj[property] = cfg[property];
            }

            // ensure a submission id was supplied
            if (csrv === "") {
                window.alert(configObj.nullCsrvMsg);
                return;
            }

            // call the url to lock the submission
            if (configObj.confirm === false || window.confirm(configObj.confirmMsg)) {
                /**
                * An object that wraps the AJAX call with the return handlers
                * @property AsyncRequest
                * @private
                */
                var AsyncRequest = {
                    /**
                    * Default handler for successful AJAX requests.  If an
                    * element was provided as an argument to the callback object,
                    * the response message will be rendered in the element, and
                    * depending on the response code, a class of either
                    * 'responseOK', or 'responseError' will be applied to the
                    * element.
                    *
                    * @method success
                    * @private
                    * @param {Object} o The AJAX response object
                    * @return {String} The response text
                    */
                    success: function (o) {
                        var el;
                        if (YAHOO.lang.isArray(o.argument)) {
                            el = YAHOO.util.Dom.get(o.argument[0]);
                        } else {
                            el = YAHOO.util.Dom.get(o.argument);
                        }
                        if (el) {
                            // validate the JSON library is loaded
                            KD.utils.Action.validateJsonLoaded();
                            // build the response object and render the message
                            var response = YAHOO.lang.JSON.parse(o.responseText);
                            if (response.responseCode === "200") {
                                // add the OK class and remove the Error class
                                KD.utils.Util.addClass(el, "responseOK");
                                KD.utils.Util.removeClass(el, "responseError");
                            } else {
                                // add the Error class and remove the OK class
                                KD.utils.Util.addClass(el, "responseError");
                                KD.utils.Util.removeClass(el, "responseOK");
                            }
                            el.innerHTML = response.responseMessage;
                        }
                        return o.responseText;
                    },
                    /**
                    * Default handler for failed AJAX requests.  If an
                    * element was provided as an argument to the callback object,
                    * the response message will be rendered in the element, and
                    * a class of 'responseError' will be applied to the element.
                    *
                    * @method failure
                    * @private
                    * @param {Object} o The AJAX response object
                    * @return {String} The response text
                    */
                    failure: function (o) {
                        this.success(o);
                    },
                    /**
                    * Starts the AJAX request
                    * @method start
                    * @parameter {Object} callback The callback configuration for the AJAX request
                    * @private
                    */
                    start: function (callback) {
                        // determine the response format - either XML or JSON
                        var responseFormat = configObj.responseFormat.toLowerCase() === "xml" ?
                            "application/xml" : "application/json";

                        // add the submission id to the AJAX request parameters
                        var parameters = "csrv=" + encodeURIComponent(csrv);
                        // add the action to the parameters
                        parameters += "&action=" + encodeURIComponent(configObj.action);
                        parameters += "&nocache=" + new Date().getTime();
                        // setup the connection and send
                        YAHOO.util.Connect.initHeader('Accept', responseFormat, true);
                        YAHOO.util.Connect.initHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
                        YAHOO.util.Connect.asyncRequest("POST", configObj.url, callback, parameters);
                    }
                };

                /*
                 * build the callback object from the event configuration options
                 *
                 * the configuration options may have been passed as a js object,
                 * a JSON string, or a KD.utils.Callback object.
                 *
                 * first check the properties defined in the KD.utils.Callback
                 * object:
                 *     success, failure, argument
                 *
                 * fallback to properties that would be configured in the js
                 * object or JSON string:
                 *     success, failure, argument, scope, timeout
                 *
                 * lastly, use the defaults defined in the default AsyncRequest
                 * object above.
                 */
                var callback = {
                    success:  window[configObj.success] || AsyncRequest.success,
                    failure:  window[configObj.failure] || AsyncRequest.failure,
                    scope:    configObj.success ? ((configObj.scope) ? configObj.scope : window) : AsyncRequest,
                    argument: configObj.argument || "message",
                    timeout:  configObj.timeout || 10000,
                    cache:    false
                };

                // make the AJAX request
                AsyncRequest.start(callback);

            }
        };

    };
}



if (!KD.utils.FileLoader) {
    /**
     * A FileLoader class to implement cross-browser functionality, and enforce
     * rules associated with the attachment question.
     * @namespace KD.utils
     * @class FileLoader
     * @constructor
     */
    KD.utils.FileLoader = new function () {
        /**
         * The DOM element that represents the attachment question
         * @property questionObj
         * @type HTMLElement
         */
        this.questionObj = null;

        /**
         * The id of the attachment question
         * @property questionId
         * @type String
         */
        this.questionId = null;

        /**
         * True to enforce that only certain file types may be uploaded, or
         * false to allow all attachments.
         * @property enforceFileTypes
         * @type Boolean
         * @default false
         */
        this.enforceFileTypes = false;

        /**
         * If file types are enforced, a comma-separated list of file extensions
         * that are allowed to be uploaded.
         * EX: .doc,.xml,.ppt
         * @property fileTypesAllowed
         * @type String
         */
        this.fileTypesAllowed = null;

        /**
         * The maximum fize size (bytes) allowed.
         * @property sizeLimit
         * @type Number
         */
        this.sizeLimit = null;

        /**
         * The context the web application uses on the web server. The default
         * Tomcat intallation uses "/kinetic"
         * @property contextPath
         * @type String
         */
        this.contextPath = null;

        /**
         * The pop-up window element generated to hold the file upload form.
         * @property loadFileWindow
         * @type Window
         */
        this.loadFileWindow = null;

        /**
         * Get the location of the center of the window in pixels, as well as
         * the width and height of the screen.
         * @method _getCenterWinFeatures
         * @private
         * @param {Number} windowWidth
         * @param {Number} windowHeight
         * @return {String} window properties (top, left, width, height) in pixels
         */
        this._getCenterWinFeatures = function(windowWidth, windowHeight) {
            var screenWidth = window.screen.availWidth;
            var screenHeight = window.screen.availHeight;
            var left = parseInt(screenWidth /2 ) - (windowWidth / 2);
            var top = parseInt(screenHeight / 2) - (windowHeight / 2);
            var features = ",width=" + windowWidth + ",height=" + windowHeight;
            features += ",top=" + top + ",left=" + left;
            return features;
        };

        /**
         * Creates the pop-up window that contains the file attachment form.
         * @method loadFile
         * @param {HTMLElement} attachQstn The attachment question element
         * @return {Boolean} false if a question was not suppled
         */
        this.loadFile = function (attachQstn) {
            if(!attachQstn) {
                alert("Must include a question object");
                return false;
            }

            this.questionId = attachQstn.id.substring(attachQstn.id.indexOf("_")+1,attachQstn.id.length);
            this.questionObj = KD.utils.Util.getQuestionInput(this.questionId);
            if (KD.utils.Util.isArray(this.questionObj)) {
                // find the text input field
                var i, inputType, length = this.questionObj.length;
                for (i = 0; i < length; i++) {
                    inputType = this.questionObj[i].getAttribute("type");
                    if (inputType && inputType.toUpperCase() == "TEXT") {
                        this.questionObj = this.questionObj[i];
                        break;
                    }
                }
            }
            if (this.questionObj.getAttribute("enforceFileTypes").toUpperCase() == "ENFORCE") {
                this.enforceFileTypes=true;
            }
            this.fileTypesAllowed=this.questionObj.getAttribute("fileTypesAllowed");
            this.sizeLimit=this.questionObj.getAttribute("sizeLimit");
            this.contextPath=KD.utils.ClientManager.webAppContextPath;

            var sFeatures=this._getCenterWinFeatures(500, 200);
            var path = this.contextPath + "/resources/uploadFile.html";
            if (this.loadFileWindow && !this.loadFileWindow.closed && this.loadFileWindow.location)
            {
                this.loadFileWindow.location.href = path;
            }
            else
            {
                this.loadFileWindow=window.open(path,'_blank',sFeatures);
                if (!this.loadFileWindow.opener) {
                    this.loadFileWindow.opener = self;
                }
            }
            if (window.focus) {
                this.loadFileWindow.focus();
            }
        };

        /**
         * Clears the answer value for the attachment question, clears the file
         * link, and returns the input to a file type input element.
         * @method clearFile
         * @param {HTMLElement} obj The question element
         * @return void
         */
        this.clearFile = function (obj) {
            this.questionID = obj.id.substring(obj.id.indexOf("_")+1,obj.id.length);
            this.questionObj = KD.utils.Util.getQuestionInput(this.questionID);
            if (KD.utils.Util.isArray(this.questionObj)) {
                // find the text input field
                var i, inputType, length = this.questionObj.length;
                for (i = 0; i < length; i++) {
                    inputType = this.questionObj[i].getAttribute("type");
                    if (inputType && inputType.toUpperCase() == "TEXT") {
                        this.questionObj = this.questionObj[i];
                        break;
                    }
                }
            }
            this.questionObj.value = '';
            KD.utils.Action._setFileLink(this.questionObj);
        };
    };
}

if (!KD.utils.Callback) {
    /**
     * YAHOO Connection callback object.
     *
     * @namespace KD.utils
     * @class Callback
     * @constructor
     * @param {Object} successObj The function that gets called if the Simple Data
     * Request finishes successfully.
     * @param {Object} errorObj The function that gets called if the Simple Data
     * Request fails or times out.
     * @param {Array} args (optional) Any additional arguments passed to the Simple Data Request
     * @param {Boolean} includeLoadingImage (optional) true to display a loading image
     * while the Simple Data Request is active, else false
     */
    KD.utils.Callback = function (successObj, errorObj, args, includeLoadingImage) {
        /**
         * The function that gets called if the Simple Data Request finishes successfully.
         * @property success
         * @type Object
         */
        this.success = successObj;

        /**
         * The function that gets called if the Simple Data Request fails or times out.
         * @property error
         * @type Object
         */
        this.error = errorObj;

        /**
         * Array of arguments for the callback.
         * @property argument
         * @type Array
         */
        this.argument = new Array(args);

        /**
         * Indicates whether a 'loading' image should be displayed while this Simple
         * Data Request is running.  The loading image will be hidden once the request
         * is finished.
         * @property includeLoadingImage
         * @type Boolean
         * @default false
         */
        this.includeLoadingImage=false;

        if (includeLoadingImage) {
            this.includeLoadingImage = includeLoadingImage;
        }
    };
}

(function () {
    YAHOO.namespace('KD.widget');

    YAHOO.KD.widget.CalendarPicker = function (evt, id, paramType) {
        var dialog, calendar,
            calType = paramType || "d",
            dialogId = "cal_" + id,
            calendarId = "calendarPanel_" + id;

        // Lazy Dialog Creation - Wait to create the Dialog, and setup document
        // click listeners, until the first time the button is clicked.
        if (!dialog) {

            function saveHandler(evt) {
                var selectedDateValue, dtparts = null;
                if (calendar.getSelectedDates().length > 0) {
                    selectedDateValue = calendar.getSelectedDates()[0];
                } else {
                    selectedDateValue = null;
                }
                if (selectedDateValue instanceof Date) {
                    dtparts = KD.utils.Util.getDtParts(selectedDateValue)
                }
                KD.utils.Action.dateSelected(evt, dtparts, [id]);
                dialog.hide();
            }

            function cancelHandler() {
                dialog.hide();
            }

            function clearHandler() {
                calendar.deselectAll();
                calendar.render();

            }

            function resetHandler() {
                // Reset the current calendar page to the select date, or
                // to today if nothing is selected.
                var selDates = calendar.getSelectedDates();
                var resetDate;

                if (selDates.length > 0) {
                    resetDate = selDates[0];
                } else {
                    resetDate = calendar.today;
                }
                calendar.cfg.setProperty("pagedate", resetDate);
                calendar.render();
            }

            var dialogOpts = {
                visible: false,
                context: [YAHOO.util.Event.getTarget(evt), "tl", "bl"],
                buttons:[
                    {text:"Save", handler: saveHandler, isDefault:true},
                    {text:"Cancel", handler: cancelHandler}
                ],
                draggable:false,
                close:true
            };
            var monthSelect = Dom.get("month_" + id);
            var allowBlank = monthSelect.options[0].value == "" ? true : false;
            if (allowBlank) {
                dialogOpts.buttons.push({text:"Clear", handler: clearHandler});
            }
            dialog = new YAHOO.widget.Dialog(id, dialogOpts);
            dialog.setHeader(KD.utils.Util.getQuestionLabelValue(id));
            dialog.setBody('<div id="'+calendarId+'"></div>');
            dialog.render(KD.utils.Util.getElementObject(id, "QLAYER_"));

            dialog.showEvent.subscribe(function() {
                if (YAHOO.env.ua.ie) {
                    dialog.fireEvent("changeContent");
                }
            });
        }

        // Lazy Calendar Creation - Wait to create the Calendar until the first
        // time the button is clicked.
        if (!calendar) {
            var config = {iframe: false, hide_blank_weeks: true, close: false};
            if (calType == "dt") {
                calendar = new YAHOO.KD.widget.Calendar(dialogId, calendarId, config);
            } else {
                calendar = new YAHOO.widget.Calendar(dialogId, calendarId, config);
            }

            calendar.renderEvent.subscribe(function() {
                // Tell Dialog it's contents have changed, which allows
                // container to redraw the underlay (for IE6/Safari2)
                dialog.fireEvent("changeContent");
            });

            // render the calendar in the dialog
            calendar.render();
        }


        // initalize the calendar widget to the selected date, or the current
        // date if it hasn't yet been set
        var d, qValue = KD.utils.Action.getQuestionValue(id);
        if (qValue != null && qValue.length > 0) {
            if (calType == "dt") {
                d = KD.utils.Util.utcFromLocal(qValue);
            } else {
                var parts = qValue.split("-");
                d = new Date(parts[0], parts[1]-1, parts[2]);
            }
        } else {
            // default the calendar widget to the current date and hour
            if (calType == "dt") {
                d = KD.utils.Util.utcFromLocal(new Date());
                d.setMinutes(0);
                d.setSeconds(0);
            } else {
                d = new Date();
            }
        }
        calendar.cfg.setProperty("pagedate", d);
        calendar.select(d);
        calendar.render();

        // show the dialog
        dialog.show();

    }


    /**
     * A calendar Date/Time widget that extends the YUI Calendar widget to include
     * user input fields to set the time.
     * @namespace YAHOO.KD.widget
     * @class Calendar
     * @extends YAHOO.widget.Calendar
     * @constructor
     * @param {String} id The instanceId of the question that this widget belongs to
     * @param {String} containerId The id of the container element that holds this calendar
     * @param {Object} config Configuration options for the calendar object
     */
    YAHOO.KD.widget.Calendar = function (id, containerId, config) {

        YAHOO.KD.widget.Calendar.prototype.hourEl = null;
        YAHOO.KD.widget.Calendar.prototype.minuteEl = null;
        YAHOO.KD.widget.Calendar.prototype.secondEl = null;
        YAHOO.KD.widget.Calendar.prototype.ampmEl = null;
        YAHOO.KD.widget.Calendar.prototype.time = [0,0,0];

        // call the constructor of the super class
        YAHOO.KD.widget.Calendar.superclass.constructor.call(this, id, containerId, config);

        /**
         * Renders the body of the calendar widget.  First builds up the month rows and columns,
         * then builds up a time display under the days.
         *
         * @method renderBody
         * @param {Date} workingDate A date object representing the starting year and month
         * @param {String} html A string of the built up html
         * @return {String} The resulting html string
         */
        YAHOO.KD.widget.Calendar.prototype.renderBody = function (workingDate, html) {
            // render the default calendar class
            YAHOO.KD.widget.Calendar.superclass.renderBody.call(this, workingDate, html);
            // now add the time portion
            html[html.length] = '<tbody>';
            html[html.length] = '<center>';
            html[html.length] = '<table id="time_' + this.id + '" border="0" cellpadding="0" cellspacing="2" width="182px">';
            html[html.length] = '<tbody>';
            html[html.length] = '<tr class="cal_time">';
            html[html.length] = '<td align="center"><input class="dt_hr_input" style="width:22px" name="hours" type="text" maxlength="2" size="1"></input></td>';
            html[html.length] = '<td align="center">:</td>';
            html[html.length] = '<td align="center"><input class="dt_min_input" style="width:22px" name="minutes" type="text" maxlength="2" size="1"></input></td>';
            html[html.length] = '<td align="center">:</td>';
            html[html.length] = '<td align="center"><input class="dt_sec_input" style="width:22px" name="seconds" type="text" maxlength="2" size="1"></input></td>';
            html[html.length] = '<td align="center"><select class="dt_ampm_select" style="position:relative;">' + this.ampmOpts() + '</select></td>';
            html[html.length] = '</tr>';
            html[html.length] = '</tbody>';
            html[html.length] = '</table>';
            html[html.length] = '</center>';
            html[html.length] = '</tbody>';
            return html;
        };

        // Apply event listeners
        YAHOO.KD.widget.Calendar.prototype.applyListeners = function () {
            // apply the default calendar listeners
            YAHOO.KD.widget.Calendar.superclass.applyListeners.call(this);

            // get the selected date so the time elements can be populated
            var selectedDates = this.getSelectedDates();
            var h = 12, m = 0, s = 0, ap = 'AM';

            // convert the hours and AM/PM indicator appropriately
            if (selectedDates.length > 0) {
                var selectedDate = selectedDates[0];
                var hr = selectedDate.getHours();
                if (hr > 12) {
                    h = hr - 12;
                    ap = 'PM';
                } else if (hr == 12) {
                    h = hr;
                    ap = 'PM';
                } else if (hr == 0) {
                    h = 12;
                } else {
                    h = hr;
                }
                m = selectedDate.getMinutes();
                s = selectedDate.getSeconds();
            }

            // get the time elements
            this.hourEl = YAHOO.util.Dom.getElementsByClassName("dt_hr_input", "input", this.oDomContainer)[0];
            this.minuteEl = YAHOO.util.Dom.getElementsByClassName("dt_min_input", "input", this.oDomContainer)[0];
            this.secondEl = YAHOO.util.Dom.getElementsByClassName("dt_sec_input", "input", this.oDomContainer)[0];
            this.ampmEl = YAHOO.util.Dom.getElementsByClassName("dt_ampm_select", "select", this.oDomContainer)[0];

            // add event listeners to the time inputs
            YAHOO.util.Event.addListener(this.hourEl, "change", this.setHoursListener, this, true);
            YAHOO.util.Event.addListener(this.minuteEl, "change", this.setMinutesListener, this, true);
            YAHOO.util.Event.addListener(this.secondEl, "change", this.setSecondsListener, this, true);
            YAHOO.util.Event.addListener(this.ampmEl, "change", this.setAmPmListener, this, true);

            // set the time element values
            this.hourEl.value = h
            this.minuteEl.value = this.padZero(m, 2);
            this.secondEl.value = this.padZero(s, 2);
            for (var i = 0; i < this.ampmEl.options.length; i += 1) {
                if (this.ampmEl.options[i].text == ap) {
                    this.ampmEl.selectedIndex = i;
                    break;
                }
            }

            // initialize the time portion of the date
            this.setHour(h);
            this.setMinute(m);
            this.setSecond(s);
        };

        /**
         * Builds the calendar's AM/PM selector options.
         * @method ampmOpts
         * @return {String} The AM and PM option elements
         */
        YAHOO.KD.widget.Calendar.prototype.ampmOpts = function () {
            var opts = [];
            opts[opts.length] = '<option value="AM">AM</option>';
            opts[opts.length] = '<option value="PM">PM</option>';
            return opts.join();
        };

        YAHOO.KD.widget.Calendar.prototype.setHoursListener = function (evt, cal) {
            var target = YAHOO.util.Event.getTarget(evt);
            if (target) {
                cal.setHour(target.value);
            }
        };

        YAHOO.KD.widget.Calendar.prototype.setMinutesListener = function (evt, cal) {
            var target = YAHOO.util.Event.getTarget(evt);
            if (target) {
                cal.setMinute(target.value);
            }
        };

        YAHOO.KD.widget.Calendar.prototype.setSecondsListener = function (evt, cal) {
            var target = YAHOO.util.Event.getTarget(evt);
            if (target) {
                cal.setSecond(target.value);
            }
        };

        YAHOO.KD.widget.Calendar.prototype.setAmPmListener = function (evt, cal) {
            var target = YAHOO.util.Event.getTarget(evt);
            if (target) {
                cal.setAmPm(target.value);
            }
        };

        /**
         * Sets the calendar's hour explicitly.
         * @method setHour
         * @param {Number} hour The numeric 1 or 2-digit hour
         */
        YAHOO.KD.widget.Calendar.prototype.setHour = function (hour) {
            var t = parseInt(hour, 10);
            if (isNaN(t)) {return;}
            if (t < 1 || t > 12) {return;}
            var apEl = YAHOO.util.Dom.getElementsByClassName("dt_ampm_select", "select", this.oDomContainer)[0];
            if (apEl == null) {
                return;
            }
            var ap = apEl.value;
            if (ap == "PM") {
                t += 12;
                if (t == 24) {
                    t = 12;
                }
            } else {
                if (t == 12) {
                    t = 0;
                }
            }
            this.time[0] = t;
            if (this.getSelectedDates().length > 0) {
                this.cfg.config.selected.value[0][3] = t;
            }
        };

        /**
         * Sets the calendar's minute explicitly.
         * @method setMinute
         * @param {Number} minute The numeric 1 or 2-digit minute
         */
        YAHOO.KD.widget.Calendar.prototype.setMinute = function (minute) {
            var t = parseInt(minute, 10);
            if (isNaN(t)) {return;}
            if (t < 0 || t > 59) {return;}
            this.time[1] = t;
            if (this.getSelectedDates().length > 0) {
                this.cfg.config.selected.value[0][4] = t;
            }
        };

        /**
         * Sets the calendar's seconds explicitly.
         * @method setSecond
         * @param {Number} second The numeric 1 or 2-digit seconds
         */
        YAHOO.KD.widget.Calendar.prototype.setSecond = function (second) {
            var t = parseInt(second, 10);
            if (isNaN(t)) {return;}
            if (t < 0 || t > 59) {return;}
            this.time[2] = t;
            if (this.getSelectedDates().length > 0) {
                this.cfg.config.selected.value[0][5] = t;
            }
        };

        /**
         * Sets the calendar's hour explicitly based on the AM/PM selector.
         * @method setAmPm
         * @param {String} ampm The string "AM" or "PM"
         */
        YAHOO.KD.widget.Calendar.prototype.setAmPm = function (ampm) {
            var ap = "AM";
            if (ampm == "AM" || ampm == "PM") {
                ap = ampm;
            }
            var hEl = YAHOO.util.Dom.getElementsByClassName("dt_hr_input", "input", this.oDomContainer)[0];
            if (hEl == null) {
                return;
            }
            var h = parseInt(hEl.value, 10);
            if (isNaN(h)) {return;}
            if (h < 1 || h > 12) {return;}
            if (ap == "PM") {
                h += 12;
                if (h == 24) {
                    h = 12;
                }
            } else {
                if (h == 12) {
                    h = 0;
                }
            }
            this.time[0] = h;
            this.cfg.config.selected.value[0][3] = h;
        };

        /**
         * Prefixes a numeric value with zeros to ensure the value holds the required
         * number of digits.
         * @method padZero
         * @param {Number} v The value to pad
         * @param {Number} n The total number or required digits
         */
        YAHOO.KD.widget.Calendar.prototype.padZero = function (v, n) {
            n = n || 2;
            if (v != null && v != undefined && v.toString().length < n) {
                for (var i = 0; i < n - v.toString().length; i += 1) {
                    v = '0' + v;
                }
            }
            return v;
        };


        YAHOO.KD.widget.Calendar.prototype._toDate = function (dateFieldArray) {
            if (dateFieldArray instanceof Date) {
                return dateFieldArray;
            } else {
                if (dateFieldArray && dateFieldArray.length == 3) {
                    return new Date(dateFieldArray[0],dateFieldArray[1]-1,dateFieldArray[2],dateFieldArray[3],dateFieldArray[4],dateFieldArray[5]);
                } else {
                    if (dateFieldArray) {
                        var utc = new Date(dateFieldArray[0],dateFieldArray[1]-1,dateFieldArray[2],dateFieldArray[3],dateFieldArray[4],dateFieldArray[5]);
                        var local = KD.utils.Util.localFromUTC(utc);
                        return local;
                    }
                }
            }
        };


        YAHOO.KD.widget.Calendar.prototype._toFieldArray = function (date) {
            var returnDate = [];

            if (date instanceof Date) {
                returnDate = [[date.getFullYear(), date.getMonth()+1, date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()]];
            } else if (YAHOO.lang.isString(date)) {
                returnDate = this._parseDates(date);
            } else if (YAHOO.lang.isArray(date)) {
                for (var i=0;i<date.length;++i) {
                    var d = date[i];
                    returnDate[returnDate.length] = [d.getFullYear(),d.getMonth()+1,d.getDate(),d.getHours(),d.getMinutes(),d.getSeconds()];
                }
            }
            return returnDate;
        };


        YAHOO.KD.widget.Calendar.prototype.getSelectedDates = function () {
            var returnDates = [];
            var selected = this.cfg.getProperty(YAHOO.widget.Calendar._DEFAULT_CONFIG.SELECTED.key);

            for (var d=0;d<selected.length;++d) {
                var dateArray = selected[d];

                var date = new Date(dateArray[0],dateArray[1]-1,dateArray[2],dateArray[3],dateArray[4],dateArray[5]);
                returnDates.push(date);
            }

            returnDates.sort( function(a,b) {return a-b;} );
            return returnDates;
        };


        YAHOO.KD.widget.Calendar.prototype.selectCell = function (cellIndex) {

            var cell = this.cells[cellIndex];
            var cellDate = this.cellDates[cellIndex];
            var dCellDate = this._toDate(cellDate);

            var selectable = YAHOO.util.Dom.hasClass(cell, this.Style.CSS_CELL_SELECTABLE);

            if (selectable) {
                this.beforeSelectEvent.fire();

                var cfgSelected = YAHOO.widget.Calendar._DEFAULT_CONFIG.SELECTED.key;
                var selected = this.cfg.getProperty(cfgSelected);
                var selectDate = cellDate.concat();

                selectDate[selectDate.length] = this.time[0];
                selectDate[selectDate.length] = this.time[1];
                selectDate[selectDate.length] = this.time[2];

                if (this._indexOfSelectedFieldArray(selectDate) == -1) {
                    selected[selected.length] = selectDate;
                }
                if (this.parent) {
                    this.parent.cfg.setProperty(cfgSelected, selected);
                } else {
                    this.cfg.setProperty(cfgSelected, selected);
                }
                this.renderCellStyleSelected(dCellDate,cell);
                this.selectEvent.fire([selectDate]);
                this.doCellMouseOut.call(cell, null, this);
            }
            return this.getSelectedDates();
        };

        YAHOO.KD.widget.Calendar.prototype.select = function (utc) {
            var aToBeSelected, cfgSelected, date,
                validDates = [],
                selected = [];

            date = KD.utils.Util.localFromUTC(utc);
            cfgSelected = this.cfg.config.selected.key;
            aToBeSelected = this._toFieldArray(date);
            // set the starting date so the calendar widget opens up to the selected date
            this.cfg.setProperty(YAHOO.widget.Calendar.DEFAULT_CONFIG.PAGEDATE.key, date);

            for (var a=0; a < aToBeSelected.length; ++a) {
                var toSelect = aToBeSelected[a];

                if (!this.isDateOOB(this._toDate(toSelect))) {
                    if (validDates.length === 0) {
                        this.beforeSelectEvent.fire();
                        selected = this.cfg.getProperty(cfgSelected);
                    }
                    validDates.push(toSelect);

                    if (this._indexOfSelectedFieldArray(toSelect) == -1) {
                        selected[selected.length] = toSelect;
                    }
                }
            }

            if (validDates.length > 0) {
                if (this.parent) {
                    this.parent.cfg.setProperty(cfgSelected, selected);
                } else {
                    this.cfg.setProperty(cfgSelected, selected);
                }
                this.selectEvent.fire(validDates);
            }

            return this.getSelectedDates();
        };
    };

    // make the YAHOO.KD.widget.Calendar class an extension of the YAHOO.widget.Calendar class
    YAHOO.lang.extend(YAHOO.KD.widget.Calendar, YAHOO.widget.Calendar);
})();
