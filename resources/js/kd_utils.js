/*
Copyright (c) 2012, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/

// setup shortcuts
if (typeof Dom == "undefined") {
    Dom = YAHOO.util.Dom;
}

if (typeof KD == "undefined") {
    KD = {};
}
if (typeof KD.utils == "undefined") {
    KD.utils = {};
}

// Helper method for Date objects
Date.prototype.setISO8601 = function (dtString) {
    var
    offset = 0,
    date,
    time,
    parts = new Array(),
    re = "^([0-9]{4})-?(0[1-9]|1[0-2])-?([12][0-9]|0[1-9]|3[01])(T?([01][0-9]|2[0-3]):?([0-5][0-9]):?([0-5][0-9])?.?([0-9]{3})?([zZ]|([\+-])([01][0-9]|2[0-3]):?([0-5][0-9])?)?)?$",
    groups = dtString.match(new RegExp(re));

    // If the year was not provided, do nothing
    if (KD.utils.Util.isBlank(groups[1])) {
        return;
    }
    // If the month was not provided, do nothing
    if (KD.utils.Util.isBlank(groups[2])) {
        return;
    }
    // If the day was not provided, do nothing
    if (KD.utils.Util.isBlank(groups[3])) {
        return;
    }
    // Required date parts
    parts[0] = parseInt(groups[1], 10);
    parts[1] = parseInt(groups[2], 10) - 1;
    parts[2] = parseInt(groups[3], 10);
    // Optional time parts
    parts[3] = !KD.utils.Util.isBlank(groups[5]) ? parseInt(groups[5], 10) : 0;
    parts[4] = !KD.utils.Util.isBlank(groups[6]) ? parseInt(groups[6], 10) : 0;
    parts[5] = !KD.utils.Util.isBlank(groups[7]) ? parseInt(groups[7], 10) : 0;
    parts[6] = !KD.utils.Util.isBlank(groups[8]) ? Number("0." + groups[8]) * 1000 : 0;
    // Create a temp date object with the parts obtained from the regex
    date = new Date(parts[0],parts[1],parts[2],parts[3],parts[4],parts[5],parts[6]);
    // Adjust offset for the timezone provided in the date/time string
    if (!KD.utils.Util.isBlank(groups[9])) {
        offset = (Number(groups[11]) * 60) + Number(groups[12]);
        offset *= ((groups[10] == '-') ? 1 : -1);
    }
    // Only adjust for local timezone is a complete date/time string was supplied
    if (!KD.utils.Util.isBlank(groups[5])) {
        offset -= date.getTimezoneOffset();
    }
    time = (Number(date) + (offset * 60 * 1000));
    this.setTime(Number(time));
}
// Helper method for String objects
String.prototype.startsWith = function(str) {
    return (this.match("^"+str)==str);
}


if (!KD.utils.Util) {

    /**
     * Common utility methods used in Kinetic Survey and Kinetic Request
     * @namespace KD.utils
     * @class Util
     * @static
     */
    KD.utils.Util = new function () {

        /**
         * Cache of labels or ids to DOM elements
         * @property labelIDCache
         * @private
         */
        this.labelIDCache = {};
        /**
         * Pass in an object to see its properties in an alert.
         * @method debugProperties
         * @param {Object} obj Any object
         * @return {String} An alert with the object properties
         */
        this.debugProperties = function (obj) {
            if (obj) {
                var props="Object Properties Available:\n";
                props += "Name: "+obj.name +"\n";
                props += "ID: "+obj.id +"\n";
                props += "Type: "+obj.type + "\n";
                for (var prop in obj){
                    props += prop + "="+ eval("obj."+prop)+"\n";
                }
                alert(props);
            }else{
                alert("The object sent was null");
            }
        };

        /**
         * Get the instance Id of the element from the element ID
         * @method getIDPart
         * @param {String} id The element's id attribute value
         * @return {String} The instanceId portion of the full id
         */
        this.getIDPart = function (id){
            if (!id) {
                return null;
            }
            if (id.indexOf("QLAYER")!=-1) {
                return id.substring("QLAYER_".length);
            }
            if (id.indexOf("QLABEL")!=-1) {
                return id.substring("QLABEL_".length);
            }
            if (id.indexOf("QANSWER")!=-1) {
                return id.substring("QANSWER_".length);
            }
            if (id.indexOf("QLAYER")!=-1) {
                return id.substring("QLAYER_".length);
            }
            if (id.indexOf("DYNAMIC_TEXT")!=-1) {
                return id.substring("DYNAMIC_TEXT_".length);
            }
            if (id.indexOf("IMAGE")!=-1) {
                return id.substring("IMAGE_".length);
            }
            if (id.indexOf("BUTTON")!=-1) {
                return id.substring("BUTTON_".length);
            }
            if (id.indexOf("SRVQSTN")!=-1) {
                return id.substring("SRVQSTN_".length);
            }
            if (id.indexOf("SECTION")!=-1) {
                return id.substring("SECTION_".length);
            }
            if (id.indexOf("PAGE")!=-1) {
                return id.substring("PAGE_".length);
            }
            if (id.indexOf("month_") != -1) {
                return id.substring("month_".length);
            }
            if (id.indexOf("day_") != -1) {
                return id.substring("day_".length);
            }
            if (id.indexOf("year_") != -1) {
                return id.substring("year_".length);
            }
            if (id.indexOf("hour_") != -1) {
                return id.substring("hour_".length);
            }
            if (id.indexOf("min_") != -1) {
                return id.substring("min_".length);
            }
            if (id.indexOf("ampm_") != -1) {
                return id.substring("ampm_".length);
            }
            return id;
        };

        /**
         * Pass in an HTML element or event object to get the related source element.
         * Useful if a function doesn't know whether an element or event has triggered the function.
         * @method getElementFromObject
         * @param {Event | HTMLElement} obj The object to retrieve the element from
         * @return {HTMLElement} An element object (if event) or the object itself if something other than an event.
         */
        this.getElementFromObject = function(obj){
            return YAHOO.util.Event.getTarget(obj);
        };

        /**
         * Prepends zeros on the front of an object to make the string representation
         * of the object the required length.  This method will not trim the value
         * if it exceeds the total number of digits to start with.
         * @method padZeros
         * @param {Number | String} obj Typically a number or a string representaion
         * of the number to prepend with zeros.
         * @param {Number} totalDigits The total number of digits to return
         * @return {String} A string with padded zeros to meet the required length.
         */
        this.padZeros = function(obj, totalDigits){
            if (obj == null || typeof obj == 'undefined') { return obj; }
            obj = obj.toString();
            var pd = '';
            if (totalDigits > obj.length) {
                for (var i=0; i < (totalDigits-obj.length); i++){
                    pd += '0';
                }
            }
            return pd + obj.toString();
        };

        /**
         * Returns the id of the element that matches the supplied label
         * @method locateIDByLabel
         * @param {HTMLElement} parent Element where the search starts from
         * @param {String} label The menu label name of the element to find
         * @param {Boolean} fullID (optional) true to return the full element id, or false to return just the instanceID part
         * @return {String} The id attribute for this element
         */
        this.locateIDByLabel = function (parent, label, fullID) {
            if(parent && label){
                var children = parent.childNodes;
                for (var idx=0; idx < children.length; idx++) {

                    if (children[idx].attributes && children[idx].getAttribute("label")==label) {
                        if(fullID){
                            return children[idx].getAttribute("id");
                        }else {
                            return KD.utils.Util.getIDPart(children[idx].getAttribute("id"));
                        }
                    }

                    if (children[idx].childNodes && children[idx].childNodes.length > 0) {
                        var id = KD.utils.Util.locateIDByLabel(children[idx], label, fullID);
                        if (id != "") return id;
                    }
                }
            }
            return "";
        };

        /**
         * Registers a key/element pair in a cache to avoid multiple DOM lookups
         * @method registerInCache
         * @private
         * @param {HTMLElement} element The element to register
         * @param {Boolean} update Bypasses checking if the element already exists in the cache
         */
        this.registerInCache = function (element, update) {
            var label, id, idPart, i, qEls, el_label, type = '',
                forceUpdate = typeof update === 'undefined' ? false : update;

            // return if the element is null
            if (!element) { return; }

            try {
                if (element.id) {
                    id = element.id;
                    type = KD.utils.Util.getPrefixFromId(element.id) || '';
                }

                // register the element by label
                label = element.getAttribute("label");
                if (label && label.length > 0) {
                    if (forceUpdate || !KD.utils.Util.loadFromCache(label)) {
                        KD.utils.Util.setInCache(label, element);
                    }
                    if (forceUpdate || !KD.utils.Util.loadFromCache(type + label)) {
                        KD.utils.Util.setInCache(type + label, element);
                    }
                }

                // register the element by id
                if (id && id.length > 0) {
                    idPart = KD.utils.Util.getIDPart(id);
                    if (forceUpdate || !KD.utils.Util.loadFromCache(id)) {
                        KD.utils.Util.setInCache(id, element);
                    }
                    if (forceUpdate || !KD.utils.Util.loadFromCache(idPart)) {
                        KD.utils.Util.setInCache(idPart, element);
                    }

                    if (element.id.indexOf("QLAYER_") != -1 || element.id.indexOf("QANSWER_") != -1) {
                        qEls = YAHOO.util.Dom.getElementsBy(function(obj) {
                            return (obj.id && obj.id.length > 0) ? true : false;
                        }, '*', element);

                        // register the question layer child elements
                        for (i = 0; i < qEls.length; i++) {
                            // ensure that each child element has a label attribute
                            el_label = qEls[i].getAttribute("label");
                            if (!el_label) {
                                qEls[i].setAttribute("label", label);
                            }
                            KD.utils.Util.registerInCache(qEls[i]);
                        }
                    }
                }
            } catch (e) {/*ignore*/}
        };

        /**
         * Updates a registered key/element pair in the cache to avoid multiple
         * DOM lookups
         * @method updateInCache
         * @param {HTMLElement} element The element to register
         */
        this.updateInCache = function (element) {
            KD.utils.Util.registerInCache(element, true);
        };

        /**
         * For internal private use only.
         * A hashmap entry containing the element label and id.
         * @method labelCache
         * @private
         * @param {String} key The cache key that identifies the element
         * @param {HTMLElement} element The element that is to be cached
         */
        this.labelCache = function (key, element) {
            this.key = key;
            this.element = element;
        };

        /**
         * For internal private use only.
         * Adds the element's label/id to an internal cache.
         * @method setInCache
         * @private
         * @param {String} key The cache key that identifies the element
         * @param {String} element The element that is to be cached
         */
        this.setInCache = function (key, element) {
            KD.utils.Util.labelIDCache[key] = element;
        };

        /**
         * Indicates if the element cache is empty
         * @method isCacheIDEmpty
         * @return {Boolean} true if cache is empty, else false
         */
        this.isCacheIDEmpty = function () {
            return isEmpty(KD.utils.Util.labelIDCache);
        };

        /**
         * For internal private use only.
         * Loads an element from the cache if it exists.
         * @method loadFromCache
         * @private
         * @param {String} label The menu label name of the element
         * @return {HTMLElement} The element that exists in the cache, or null.
         */
        this.loadFromCache = function (label) {
            return KD.utils.Util.labelIDCache[label];
        };

        /**
         * Gets the id prefix for the supplied id
         * @method getPrefixFromId
         * @param {String} id The id of the element
         * @return {String} The prefix used to describe this element type
         */
        this.getPrefixFromId = function (id) {
            var i, prefix = '';
            if (id) {
                i = id.indexOf("_");
                if (i > -1) {
                    prefix = id.slice(0, i + 1);
                    if (prefix == "DYNAMIC_") {
                        prefix = "DYNAMIC_TEXT_";
                    }
                }
            }
            return prefix;
        };

        /**
         * Gets the id prefix for an element type.
         * @method getPrefixFromType
         * @param {String} type The type of element
         * @return {String} The prefix used to describe this element type
         */
        this.getPrefixFromType = function(type){
            if(!type){
                return "no type given";
            }
            if (type.indexOf("Question") != -1){
                return "QLAYER_";
            }
            if (type.indexOf("Section") != -1 ){
                return "SECTION_";
            }
            if (type.indexOf("Page") != -1){
                return "PAGE_";
            }
            if (type.indexOf("Dynamic Text") != -1){
                return "DYNAMIC_TEXT_";
            }
            if (type.indexOf("Button") != -1){
                return "BUTTON_";
            }
            if (type.indexOf("Image") != -1){
                return "IMAGE_";
            }

            return "unknown prefix";
        };

        /**
         * Gets the menu label from the answer element
         * @method getLabelFromAnswerEl
         * @param {HTMLElement} answerEl The answer element
         * @return {String} The string value of the menu label for this answer
         */
        this.getLabelFromAnswerEl = function(answerEl){
            var thisEl = answerEl;
            var theLabel = "";
            while(thisEl){
                theLabel=thisEl.parentNode.getAttribute("label");
                if(theLabel && theLabel != ""){
                    return theLabel;
                }else{
                    thisEl = thisEl.parentNode;
                }
            }
            return null;
        };

        /**
         * Gets the question label from the answer element
         * @method getLabelValueFromAnswerEl
         * @param {HTMLElement} answerEl The answer element
         * @return {String} The string value of the question label for this answer
         */
        this.getLabelValueFromAnswerEl = function(answerEl){
            var thisEl = answerEl, questionId;
            questionId = this.getIDPart(thisEl.id);
            return this.getQuestionLabelValue(questionId);
        };

        /**
         * Gets the ID of the question element
         * @method getQuestionId
         * @param {String} label_id Either the menu label or the instanceId of the question
         * @return {String} The instance id of the question, or null
         */
        this.getQuestionId = function(label_id) {
            var id, q = this.getElementObject(label_id);
            if (q) {
                id = this.getIDPart(q.id);
            }
            return id;
        };

        /**
         * Gets the HTML element object for the supplied label.
         * For optimum performance, provide the type of element you are looking for:
         *   QLAYER_, SRVQSTN_, DYNAMIC_TEXT_, etc...
         * @method getElementObject
         * @param {String} label_id Either the menu label or the instanceId of the element
         * @param {String} type (optional) The type of element to search for
         * @return {HTMLElement} The DOM element for this label or id
         */
        this.getElementObject = function(label_id, type) {
            // determine the type of element if possible
            if (!type) {
                type = KD.utils.Util.getPrefixFromType(KD.utils.ClientManager.getElementType(label_id));
                if (type == 'no type given') {
                    type = '';
                }
            }

            var obj = KD.utils.Util.loadFromCache(type + label_id);
            return obj;
        };

        /**
         * Get the object that represents the Answer layer (which contains the Input field(s)).
         * @method getAnswerLayer
         * @param {String} label_id Either the menu label name (Not the question name) OR the instanceID for the question
         * @return {HTMLElement} The div element that wraps the answer input element
         */
        this.getAnswerLayer = function(label_id) {
            var obj = KD.utils.Util.getElementObject(label_id, "QANSWER_");
            if (obj && obj != "") {
            } else {
                alert("function ks_getAnswerLayer - Unable to locate the Object for: "+label_id);
            }
            return obj;
        };

        /**
         * Get the object that represents the Question label layer (DIV).
         * @method getQuestionLabel
         * @param {String} label_id Either the menu label name (Not the question name) OR the instanceID for the question
         * @return {HTMLElement} The div element that represents the question label
         */
        this.getQuestionLabel = function(label_id) {
            var obj = KD.utils.Util.getElementObject(label_id, "QLABEL_");
            if (obj && obj != "") {
            } else {
                alert("function getQuestionLabel - Unable to locate the Object for: "+label_id);
            }
            return obj;
        };

        /**
         * Get the value of the question label that is presented to the user.
         * @method getQuestionLabelValue
         * @param {String|HTMLElement} label Either the menu label name (Not the question name)
         *                                OR the instanceID for the question, OR the question
         *                                label element
         * @return {String} The value of the question label displayed to the user
         */
        this.getQuestionLabelValue = function(label) {
            var obj, value = "";
            if (label && label.nodeType && label.nodeType == 1) {
                obj = label;
            } else {
                obj = KD.utils.Util.getElementObject(label, "QLABEL_");
            }
            if (obj && obj != "") {
                value = KD.utils.Util.trimString(obj.innerHTML);
            }
            return value;
        };

        /**
         * Get the object that represents the Question layer (Label and Answer layers and Input field(s)).
         * @method getQuestionLayer
         * @param {String} label_id Either the menu label name (Not the question name) OR the instanceID for the question
         * @return {HTMLElement} The div element that represents the question layer
         */
        this.getQuestionLayer = function(label_id) {
            var obj = KD.utils.Util.getElementObject(label_id, "QLAYER_");
            if (obj && obj != "") {
            } else {
                alert("function ks_getQuestionLayer - Unable to locate the Object for: "+label_id);
            }
            return obj;
        };

        /**
         * Get the HTML input element(s) of the Question
         * @method getQuestionInput
         * @param {String} label_id Either the menu label name (Not the question name) OR the instanceID for the question
         * @return {HTMLElement | Array} The input element, or array of input elements (for radio buttons or checkboxes)
         */
        this.getQuestionInput = function(label_id) {
            var i, j, nodes,
                nodeTypes = ["input", "select", "textarea"], // identifies what element types are valid question inputs
                ret = new Array(),
                obj = KD.utils.Util.getElementObject(label_id, "QANSWER_");

            if (obj) {
                // get the form elements by tag name so we don't depend on the DOM structure
                for (i = 0; i < nodeTypes.length; i += 1) {
                    nodes = obj.getElementsByTagName(nodeTypes[i]);
                    for (j = 0; j < nodes.length; j += 1) {
                        if (nodes[j].id.startsWith("SRVQSTN_")) {
                            ret.push(nodes[j]);
                        }
                    }
                }
            } else {
                //Try getting it directly--used for checkboxes
                obj = Dom.get("SRVQSTN_"+label_id);
                if (obj) {
                    return obj;
                } else {
                    return null;
                }
            }
            if(ret.length == 1){
                return ret[0];
            }
            if (ret && ret != "") {
            } else {
                alert("function getQuestionInput - Unable to locate any input elements for :" + label_id);
            }
            return ret;
       };

        /**
         * Get the value of the Input element of the question
         * @method getQuestionValue
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @return {String} A string value of the question
         */
        this.getQuestionValue = function (label_id) {
            var els = KD.utils.Util.getQuestionInput(label_id);
            if (els){
                if (!KD.utils.Util.isArray(els)){
                    els=[els];  //If this is a single item, only need to run once, but treat as an array
                }
                var thisVal="";
                var qstnType="";
                for (var i=0; i<els.length; i++){
                    //Date Display Only
                    var cls=els[i].className;
                    var thisID=els[i].getAttribute("id");
                    //Date Hidden
                    if (cls && (cls == "dateHidden" || cls == "dtHidden")){
                        qstnType="Date";
                        thisVal= els[i].value;
                        break;
                    }
                    //Checkbox--Get all values
                    if (els[i].type && (els[i].type && els[i].type.toUpperCase() == "CHECKBOX") && els[i].checked == true){
                        qstnType="Checkbox";
                        thisVal+=els[i].value+", ";
                        thisVal=KD.utils.Util._unescapeSpecialChars(thisVal);
                        continue;
                    //Radio
                    }else if (els[i].type && els[i].type.toUpperCase() == "RADIO" && els[i].checked == true){
                        thisVal= els[i].value;
                        thisVal=KD.utils.Util._unescapeSpecialChars(thisVal);
                        break;
                    //Select
                    }else if (els[i].tagName.toUpperCase()=="SELECT") {
                        thisVal= els[i].value;
                        thisVal=KD.utils.Util._unescapeSpecialChars(thisVal);
                        break;
                    //Text/Textarea
                    }else if ((els[i].tagName.toUpperCase()=="INPUT" && els[i].type.toUpperCase() == "TEXT")|| els[i].tagName.toUpperCase()=="TEXTAREA") {
                        thisVal= els[i].value;
                        break;
                    }
                }
                //Remove last comma
                if (qstnType=="Checkbox" && thisVal.indexOf(",") != -1){
                    thisVal = KD.utils.Util.trimString(thisVal);
                    thisVal = thisVal.substring(0,thisVal.length-1);
                }
                return thisVal;
            }else {
                alert("function KD.utils.Util.getQuestionValue - Unable to locate the Object for: "+label_id);
                return "";
            }
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
            var nullThis=false;
            if (value == null || typeof value == "undefined" || value == "undefined" || value == "$\NULL$" || value == "$NULL$"){
                nullThis=true;
            }
            var els = KD.utils.Util.getQuestionInput(label_id);

            if (els){
                // DATE FIELDS
                if (KD.utils.Util._isDateQuestion(els) || KD.utils.Util._isDateTimeQuestion(els)) {
                    if (nullThis || value == "") {
                        KD.utils.Action.setDateFields(label_id, null, true);
                    } else {
                        var dateArr = [];
                        if (typeof value == "string") {
                            // Is ISO8601 - Kinetic Request Date/Time answers (yyyy-MM-dd'T'HH:mm:ssZ)
                            if (value.indexOf("-") != -1) {
                                var utcDate = new Date();
                                utcDate.setISO8601(value);
                                dateArr[0] = utcDate.getFullYear();  // local year
                                dateArr[1] = utcDate.getMonth()+1;   // local month
                                dateArr[2] = utcDate.getDate();      // local day
                                if (value.indexOf("T") != -1) {
                                    dateArr[3] = utcDate.getHours();    // local hours
                                    dateArr[4] = utcDate.getMinutes();  // local minutes
                                    dateArr[5] = utcDate.getSeconds();  // local seconds
                                }
                            }
                            // Is NOT ISO8601 - Remedy Date/Time fields (MM/dd/yyyy HH:mm:ss)
                            else if (value.indexOf("/") != -1) {
                                var dtParts = value.split(" ");
                                var remedyDateArr = dtParts[0].split("/");
                                // put the Remedy date parts in the correct order
                                dateArr[0] = remedyDateArr[2];  // year
                                dateArr[1] = remedyDateArr[0];  // month
                                dateArr[2] = remedyDateArr[1];  // day
                                if (dtParts.length == 2) {
                                    var tParts = dtParts[1].split(":");
                                    dateArr = dateArr.concat(tParts);
                                }
                            }
                            // Is NOT a valid date string
                            else {
                                KD.utils.Action.setDateFields(label_id, null, true);
                                return null;
                            }
                        } else if (KD.utils.Util.isArray(value)) {
                            dateArr = value;
                        }
                        KD.utils.Action.setDateFields(label_id, dateArr);
                    }
                    return null;
                }
                if (KD.utils.Util.isArray(els)){
                    //RADIOS
                    for (var i=0; i<els.length; i++){
                        if (nullThis){
                            els[i].checked=false;
                            continue;
                        }
                        value = KD.utils.Util._escapeSpecialChars(value);
                        if (els[i].value == value){
                            els[i].checked=true;
                            return null;
                        }
                    }
                }
                //CHECKBOX OR SINGLE RADIO
                else if (els.type && els.type.toUpperCase()=="CHECKBOX" || els.type.toUpperCase()=="RADIO"){
                    if (nullThis){
                        els.checked=false;
                        return null;
                    }
                    value = KD.utils.Util._escapeSpecialChars(value);
                    if (els.value == value){
                        els.checked=true;
                    }
                    return null;
                }
                //SELECT
                else if (els.nodeName.toUpperCase()=="SELECT" && els.options.length>0){
                    if (nullThis){
                        els.selectedIndex=0;
                        els.options[0].setAttribute('selected', "true");
                        return null;
                    }
                    value = KD.utils.Util._escapeSpecialChars(value);
                    for(i=0;i< els.options.length;i++){
                        if(els.options[i].value==value){
                            els.options[i].setAttribute("selected","true");
                            els.selectedIndex=i;
                            return null;
                        }
                    }
                }
                //TEXT
                else {
                    if (nullThis){
                        value ="";
                    }else if (els.nodeName.toUpperCase()=="TEXTAREA"){
                        value = value.replace(/%0A/gi, "\n");
                        value = value.replace(/%0D/gi, "\n");
                    }
                    els.value = value;

                    // set the file link on attachment questions
                    if (els.getAttribute('fileTypesAllowed') != null) {
                        KD.utils.Action._setFileLink(els);
                    }
                }
            }
            else {
                alert("function KD.utils.Util.setQuestionValue - Unable to locate the Object for: "+label_id);
                return false;
            }
            return true;
        };

        /**
         * Get the DIV object that represents the Dynamic Text element
         * @method getTextObject
         * @param {String} label_id Either the menu label name (Not the question name) OR the instanceID for the question
         * @return {HTMLElement} The div element that represents the Dynamic Text object
         */
        this.getTextObject = function(label_id) {
            var obj = KD.utils.Util.getElementObject(label_id, "DYNAMIC_TEXT_");
            if (obj && obj != "") {
            } else {
                alert("function ks_getTextObject - Unable to locate the Object for: "+label_id);
            }
            return obj;
        };

        /**
         * Get the DIV object that represents an Image
         * @method getImageObject
         * @param {String} label_id Either the menu label name (Not the question name) OR the instanceID for the question
         * @return {HTMLElement} The div element that represents the Image element
         */
        this.getImageObject = function(label_id) {
            var obj = KD.utils.Util.getElementObject(label_id, "IMAGE_");
            if (obj && obj != "") {
            } else {
                alert("function ks_getImageObject - Unable to locate the Object for: "+label_id);
            }
            return obj;
        };

        /**
         * Get the DIV object that represents a Button
         * @method getButtonObject
         * @param {String} label_id Either the label name OR the instanceID for the button
         * @return {HTMLElement} The div element that wraps the button element
         */
        this.getButtonObject = function(label_id) {
            var obj = KD.utils.Util.getElementObject(label_id, "BUTTON_");
            if (obj && obj != "") {
            } else {
                alert("function getButtonObject - Unable to locate the Object for: "+label_id);
            }
            return obj;
        };

        /**
         * Checks to see if an object is an array.
         * @method isArray
         * @param {Object} obj Any object
         * @return {Boolean} true if the object is an array, else false
         */
        this.isArray = function(obj) {
            if (obj == null) {
                return false;
            }
            return obj.constructor == Array;
        };

        /**
         * Trims leading and trailing whitespace from a string
         * @method trimString
         * @param {String} sInString The string to trim
         * @return {String} The string with all leading and trailing whitespace removed.
         */
        this.trimString = function(sInString){
            sInString = sInString.replace( /^\s+/g, "" );// strip leading
            return sInString.replace( /\s+$/g, "" );// strip trailing
        };

        /**
         * Checks if a value is "null" or has some sort of value.
         *
         * Examples of Blank items:
         *   null
         *   undefined
         *   empty string: ""
         *   new Array();
         *   new Object();
         *
         * @param {Object | Array | String} value The value to check
         * @return {boolean} true if the value is blank, else false
         */
        this.isBlank = function (value) {
            // null or undefined
            if (value == null || typeof value == 'undefined') {
                return true;
            }
            // Array
            if (KD.utils.Util.isArray(value)) {
                return value.length == 0;
            }
            // Object
            if (value.constructor == Object) {
                var hasProperty = false;
                for (var name in value) {
                    if (value.hasOwnProperty(name) && !KD.utils.Util.isBlank(value[name])) {
                        hasProperty = true;
                        break;
                    }
                }
                return !hasProperty;
            }
            // Other
            return value.toString().length == 0;
        }

        /**
         * Get the character code of the key that was pressed
         * @method getKeyPressed
         * @param {Event} evt The event triggered by the key press
         * @return {String} The character code representing the pressed key that triggered this event.
         */
        this.getKeyPressed = function(evt){
            var key = YAHOO.util.Event.getCharCode(evt);
            return key;
        };

        /**
         * Determines the type of element for the supplied id:
         *   Question, Section, Page, Dynamic Text, etc...
         * @method getElementType
         * @param {String} elId The id of the HTML element
         * @return {String} The descriptive text for the element type
         */
        this.getElementType = function(elId) {
            if (elId.indexOf("QLAYER_") != -1 || elId.indexOf("SRVQSTN_") != -1 || elId.indexOf("QLABEL_") != -1 || elId.indexOf("QANSWER_") != -1){
                return "Question";
            }
            if (elId.indexOf("SECTION_") != -1 ){
                return "Section";
            }
            if (elId.indexOf("PAGE_") != -1){
                return "Page";
            }
            if (elId.indexOf("DYNAMIC_TEXT") != -1){
                return "Dynamic Text";
            }
            if (elId.indexOf("BUTTON_") != -1){
                return "Button";
            }
            if (elId.indexOf("IMAGE_") != -1){
                return "Image";
            }

            return "unknown type"
        };

        /**
         * Finds the checkbox item's parent element id
         * @method getCheckboxParentId
         * @param {HTMLElement} answerEl The DOM element that represents the checkbox
         * @return {String} The id of the checkbox item's parent element
         */
        this.getCheckboxParentId = function(answerEl){
            var thisEl = answerEl;
            var parentId = "";

            // verify this is a checkbox question
            if (thisEl && thisEl.type.toLowerCase() == "checkbox") {
                while (thisEl) {
                    parentId = thisEl.parentNode.getAttribute("id");
                    if (parentId && parentId != "") {
                        parentId = parentId.replace("QANSWER_", "");
                        parentId = parentId.replace("QLABEL_", "");
                        return parentId;
                    } else {
                        thisEl = thisEl.parentNode;
                    }
                }
                return null;
            }
            return null;
        };

        /**
         * Sets the specified cookie name with a value, and expiration time
         * @method setCookie
         * @param {String} cookieName The name of the cookie
         * @param {String} cookieValue The values to store in the cookie
         * @param {Number} time The duration (milliseconds) to set the cookie before it expires
         * @return void
         */
        this.setCookie = function (cookieName, cookieValue, time) {
            var today = new Date();
            var expire = new Date();
            expire.setTime(today.getTime() + time);
            document.cookie = cookieName+"="+escape(cookieValue)
            + ";expires="+expire.toGMTString();
        };

        /**
         * Returns the cookie value starting at the specified offset index
         * @method getCookieVal
         * @param {Number} offset The offset index
         * @return {String} The unescaped string value of the cookie starting at
         * the offset index
         */
        this.getCookieVal = function(offset) {
            var endstr = document.cookie.indexOf (";", offset);
            if (endstr == -1)
                endstr = document.cookie.length;
            return unescape(document.cookie.substring(offset, endstr));
        };

        /**
         * Retrieves a cookie with the specified name.
         * @method getCookie
         * @param {String} name The name of the cookie to retrieve
         * @return {String} The value of the cookie, or null if not found
         */
        this.getCookie = function (name) {
            var arg = name + "=";
            var alen = arg.length;
            var clen = document.cookie.length;
            var i = 0;
            while (i < clen) {
                var j = i + alen;
                if (document.cookie.substring(i, j) == arg)
                    return KD.utils.Util.getCookieVal (j);
                i = document.cookie.indexOf(" ", i) + 1;
                if (i == 0) break;
            }
            return null;
        };

        /**
         * Deletes the specified cookie.
         * @method deleteCookie
         * @private
         * @param {String} name The name of the cookie to delete
         * @param {String} path (optional) Used to set the path parameter
         * @param {String} domain (optionsl) Used to set the domain parameter
         * @return void
         */
        this.deleteCookie = function (name, path, domain) {
            if (KD.utils.Util.getCookie(name)) {
                document.cookie = name + "=" +
                ((path) ? "; path=" + path : "") +
                ((domain) ? "; domain=" + domain : "") +
                "; expires=Thu, 01-Jan-70 00:00:01 GMT";
            }
        };

        /**
         * Resets the cookie for the page.
         * If one has not yet been created, the page is reloaded.
         * @method unloadCookie
         * @private
         * @return void
         */
        this.unloadCookie = function() {
            var pageID = Dom.get("pageID").value;
            KD.utils.Util.deleteCookie("KDCACHE-CHECK"+pageID);
            KD.utils.Util.setCookie("KD_PAGE", pageID, 5000);
        };

        /**
         * Resets the cookie for the page.
         * If one has not yet been created, the page is reloaded.
         * @method resetCachePageValues
         * @return void
         */
        this.resetCachePageValues = function() {
            KD.utils.Util.unloadCookie();
        };

        /**
         * Checks if a cookie exists for the page.
         * @method checkCachePageLoad
         * @return void
         */
        this.checkCachePageLoad = function () {
            window.history.forward(1);
            var fromPage = KD.utils.Util.getCookie("KD_PAGE");
            if (fromPage && fromPage != "") {
                KD.utils.Util.deleteCookie("KD_PAGE");
                return;
            } else {
                KD.utils.Util.checkCacheLoadStatus();
            }
        };

        /**
         * Checks if the cache cookie exists for the page.
         * If one has not yet been created, the page is reloaded.
         * @method checkCacheLoadStatus
         * @private
         * @return void
         */
        this.checkCacheLoadStatus = function () {
            var pageID = Dom.get("pageID").value;
            if (!KD.utils.Util.getCookie("KDCACHE-CHECK"+pageID)) {
                window.location.reload();
            }
        };

        /**
         * Makes a clone of all an objects properties
         * @method cloneObj
         * @private
         * @param {Object} obj Any object
         * @param {Boolean} deep (optional) True to do a deep copy
         * @return {Object} The cloned copy of the original object.
         */
        this.cloneObj = function (obj, deep) {
            if (obj == null || typeof(obj) != "object") {
                return obj;
            }
            var newObj = new Object();
            for (var prop in obj) {
                try {
                    if (deep) {
                        newObj[prop] = KD.utils.Util.cloneObj(obj[prop]);
                    } else {
                        newObj[prop] = obj[prop];
                    }
                } catch (e) {}
            }
            return newObj;
        };

        /**
         * Checks to see if a question expects a date type answer.
         * @method isDate
         * @param {HTMLElement} el DOM element to check.  Should be a question element.
         * @return {Boolean} A boolean check: true if question is a date type, otherwise false.
         */
        this.isDate = function (el) {
            if (el) {
                var id = KD.utils.Util.getIDPart(el.id);
                if(Dom.get('year_'+id)){
                    return true;
                }
            }
            return false;
        };

        /**
         * Escapes characters in a string that are marked as 'special'
         * @method _escapeSpecialChars
         * @private
         * @param {String} val A string to check for characters that need escaping
         * @return {String} The string with special characters escaped
         */
        this._escapeSpecialChars = function (val) {
            if (!val) {
                return val;
            }

            var specialChars = {
                "'": "%27"
            };
            var re;

            for(var key in specialChars) {
                re = new RegExp(key, "g");
                val = val.toString().replace(re, specialChars[key]);
            }
            return val;
        };

        /**
         * Unescapes characters in a string that were marked as 'special'
         * @method _unescapeSpecialChars
         * @private
         * @param {String} val A string to check for escaped special characters
         * @return {String} The string with special characters unescaped
         */
        this._unescapeSpecialChars = function (val) {
            if (!val) {
                return val;
            }

            var specialChars = {
                "%27": "'"
            };
            var re;

            for(var key in specialChars) {
                re = new RegExp(key, "g");
                val = val.toString().replace(re, specialChars[key]);
            }
            return val;
        };

        /**
         * Retrieves all the URL parameters
         * @method getParameters
         * @return {Object} Associative array of all the parameters from the URL string
         */
        this.getParameters = function () {
            var parms = {}, sUrl, pairs, pair, i;

            // Get the URL parameters
            sUrl = window.location.search;
            if (sUrl) {
                // cut off the question mark (?) and split the parameters
                sUrl = sUrl.substr(1);
                pairs = sUrl.split('&');

                // associate each parameter name with it's value
                for (i = 0; i < pairs.length; i += 1) {
                    pair = pairs[i].split('=');
                    parms[pair[0]] = pair[1];
                }
            }
            return parms;
        };

        /**
         * Retrieves the value of a URL parameter
         * @method getParameter
         * @param {String} key The name of the URL parameter to retrieve
         * @return {String} The value of the parameter, or null if it doesn't exist
         */
        this.getParameter = function (key) {
            var retVal = null;
            var parms = this.getParameters();
            if (parms[key]) {
                retVal = parms[key];
            }
            return retVal;
        };


        /**
         * Determine if a checkbox item is checked
         * @method isCheckboxItemChecked
         * @param {String} label_id Either the Label name (Not the question name) OR the InstanceID for the Question
         * @param {String} cb_item The label of the cb item to test
         * @return {Boolean} true if the item is checked, otherwise false
         */
        this.isCheckboxItemChecked = function (label_id, cb_item) {
            var cb = KD.utils.Util.getQuestionInput(label_id);
            if (cb) {
                for (var i=0; i<cb.length; i++) {
                    if (cb[i].value === cb_item && cb[i].checked) {
                        return true;
                    }
                }
            }
            return false;
        };

        /**
         * Pass in an HTML element or ID to get an array of all elements that
         * belong to the class name.
         * @method getElementsByClassName
         * @param {String} className The class name to match against
         * @param {String} tag (optional) The tag name of the elements being collected
         * @param {String | HTMLElement} root (optional) The HTMLElement or an ID to use as the starting point
         * @param {Function} apply (optional) A function to apply to each element when found
         * @return {Array} An array of elements that have the given class name
         */
        this.getElementsByClassName = function (className, tag, root, apply) {
            return Dom.getElementsByClassName(className, tag, root, apply);
        };

        /**
         * Determines whether an HTMLElement has the given className
         * @method hasClass
         * @param {String | HTMLElement | Array} el The element or collection to test
         * @param {String} className The class name to search for
         * @return {Boolean | Array} A boolean value or array of boolean values
         */
        this.hasClass = function (el, className) {
            return Dom.hasClass(el, className);
        };

        /**
         * Adds a class name to a given element or collection of elements
         * @method addClass
         * @param {String | HTMLElement | Array} el The element or collection to add the class to
         * @param {String} className The class name to add to the class attribute
         * @return {Boolean | Array} A pass/fail boolean or array of booleans
         */
        this.addClass = function (el, className) {
            return Dom.addClass(el, className);
        };

        /**
         * Removes a class name from a given element or collection of elements
         * @method removeClass
         * @param {String | HTMLElement | Array} el The element or collection to remove the class from
         * @param {String} className The class name to remove from the class attribute
         * @returns {Boolean | Array} A pass/fail boolean or array of booleans
         */
        this.removeClass = function (el, className) {
            return Dom.removeClass(el, className);
        };

        /**
         * Determines what type of form element a given DOM element is
         * @method getAnswerType
         * @param {HTMLElement} answerField The HTMLElement to check
         * @return {String} The type of element: text, textarea, select, date
         */
        this.getAnswerType = function (answerField) {
            answerField = Dom.get(answerField);
            if (answerField == null) {
                return null;
            }
            return KD.utils.Util.isDate(answerField) ?
                "date" : answerField.nodeName.toString().toLowerCase() == "select" ?
                "select" : answerField.type;
        };

        /**
         * Formats a 24 hour time value to 12 hour AM/PM format.
         * @method formatTime
         * @param {String} value The string representation of the 24 hour time portion: hh:mm:ss
         * @return {String} The 12 hour string representation of the 24 hour time: hh:mm:ss a
         */
        this.formatTime = function (value) {
            if (value == null || value == "" || value.indexOf("M") != -1) {
                return value;
            }
            var ampm = 'AM';
            var parts = value.split(':');
            var h = parseInt(parts[0], 10);
            if (h >= 12) {
                h -= 12;
                ampm = 'PM';
                if (h == 0) {
                    h = 12;
                }
            }
            parts[0] = h;
            return (parts.join(':') + ' ' + ampm);
        };

        /**
         * Formats the value for a Date question in ISO 8601 format.
         * @method formatDate
         * @param {Array} values The date parts array: year (4 digit), month (1-12), day (1-31)
         * @return {String} The string representation of the date parts: yyyy-mm-dd
         */
        this.formatDate = function (values) {
            var y, m, d, dt, dsep = '-';
            // need three date parts
            if (values && values.length && values.length >= 3) {
                // year
                y = parseInt(values[0], 10);
                if (!(y.toString().length == 4)) {
                    return '';
                }

                // month
                m = parseInt(values[1], 10);
                if (m > 0 && m <= 12) {
                    m = KD.utils.Util.padZeros(m, 2);
                } else {
                    return '';
                }

                // day
                d = parseInt(values[2], 10);
                if (d > 0 && d <= 31) {
                    d = KD.utils.Util.padZeros(d, 2);
                } else {
                    return '';
                }

                // build up the full date string
                dt = y + dsep + m + dsep + d;

            } else {
                dt = "";
            }
            return dt;
        };

        /*
         * Returns an array of date/time parts from a date or date/time question
         * @method parseDtString
         * @param {String} dtStr The date/time string to parse.  Expected to be in format: yyyy-mm-ddThh:mm:ssZ
         * @return {Array} The integer values of the date/time parts referenced to UTC [YYYY,MM,DD,hh,mm,ss]
         */
        this.parseDtString = function (dtStr) {

            var localDate, dateParts, i, parts = [];

            if (dtStr == "") {
                return parts;
            }

            if (dtStr.indexOf("T") != -1) {
                localDate = new Date();
                localDate.setISO8601(dtStr);
                parts[parts.length] = localDate.getUTCFullYear();
                parts[parts.length] = localDate.getUTCMonth() + 1;
                parts[parts.length] = localDate.getUTCDate();
                parts[parts.length] = localDate.getUTCHours();
                parts[parts.length] = localDate.getUTCMinutes();
                parts[parts.length] = localDate.getUTCSeconds();
            } else {
                dateParts = dtStr.split("-");
                if (dateParts.length > 0) {
                    // convert all the date/time parts to integers
                    for (i = 0; i < dateParts.length; i++) {
                        parts[parts.length] = parseInt(dateParts[i], 10);
                    }
                }
            }
            return parts;
        };

        /*
         * Returns an array of date/time parts
         * @method getDtParts
         * @param {Date} dt The date object to get the parts of
         * @return {Array} The integer values of the date parts referenced to local timezone [yyyy,mm,dd,hh,mm,ss]
         */
        this.getDtParts = function (dt) {
            var parts = [];
            if (!(dt instanceof Date)) {
                return [];
            }
            // get the local date components
            parts[0] = dt.getFullYear();
            parts[1] = dt.getMonth() + 1;
            parts[2] = dt.getDate();
            parts[3] = dt.getHours();
            parts[4] = dt.getMinutes();
            parts[5] = dt.getSeconds();
            return parts;
        };

        /*
         * Returns an array of date/time parts referenced to UTC
         * @method getUTCDtParts
         * @param {Date} dt The date object to get the parts of
         * @return {Array} The integer values of the date parts referenced to UTC [yyyy,mm,dd,hh,mm,ss]
         */
        this.getUTCDtParts = function (dt) {
            var parts = [];
            if (!(dt instanceof Date)) {
                return [];
            }
            // get the UTC date components
            parts[0] = dt.getUTCFullYear();
            parts[1] = dt.getUTCMonth() + 1;
            parts[2] = dt.getUTCDate();
            parts[3] = dt.getUTCHours();
            parts[4] = dt.getUTCMinutes();
            parts[5] = dt.getUTCSeconds();
            return parts;
        };

        /*
         * Returns the supplied date object offset by the local timezone
         * @method localFromUTC
         * @param {Date | String} utc The date object, or ISO8601 date string to use as the starting reference
         * @return {Date} The supplied date object offset by the local timezone
         */
        this.localFromUTC = function (utc) {
            var offset, local, utcParts,
                dt = utc;
            if (typeof dt == "string") {
                utcParts = this.parseDtString(dt);
                dt = new Date(utcParts[0], utcParts[1] - 1, utcParts[2], utcParts[3], utcParts[4], utcParts[5]);
            }

            if (dt instanceof Date) {
                offset = dt.getTimezoneOffset() * 60 * 1000;
                local = new Date(dt.getTime() - offset);
                return local;
            } else {
                return utc;
            }
        };

        /*
         * Returns the UTC representation of the supplied date
         * @method utcFromLocal
         * @param {Date} dt The date object to use as the starting reference
         * @return {Date} The UTC representation of the supplied local date
         */
        this.utcFromLocal = function (dt) {
            if (dt instanceof Date) {
                var offset = dt.getTimezoneOffset() * 60 * 1000;
                var utc = new Date(dt.getTime() + offset);
                return utc;
            } else {
                return dt;
            }
        };

        /**
         * Formats the value for a Date question in the user's local timezone.
         * @method formatLocalDate
         * @param {Date | Array} value The Date object or Array of date parts: year (4 digit), month (1-12), day (1-31)
         * @return {String} The local string representation of the date parts
         */
        this.formatLocalDate = function (value) {
            var dt, h, m, s, local;

            if (value instanceof Date) {
                local = value;
            } else {
                // need at least the three date parts
                if (value && value.length && value.length >= 3) {
                    dt = KD.utils.Util.formatDate(value);
                    if (dt == "") {
                        return dt;
                    }

                    // convert to a Date object
                    local = new Date(
                            parseInt(value[0], 10),
                            parseInt(value[1], 10) - 1,
                            parseInt(value[2], 10),
                            0, 0, 0);
                } else {
                    local = "";
                }
            }

            // return if local is not a date object
            if (local == null || local == "") {
                return "";
            }

            // now format the local date string
            dt = local.toLocaleDateString();
            return dt;
        };

        /**
         * Formats the value for a Date/Time question in the user's local timezone.
         * @method formatLocalDateTime
         * @param {Date | Array} value The Date object or Array of date parts: year (4 digit), month (1-12), day (1-31), hours (0-23), minutes (0-59), sec (0-59)
         * @param {Boolean} friendly (optional) true to display a user friendly string (default), or false to display ISO-8601 format
         * @return {String} The local string representation of the date parts
         */
        this.formatLocalDateTime = function (value, friendly) {
            var dt, h, m, s, local,
                tsep = ':',
                friendlyFormat = friendly === false ? false : true;

            if (value instanceof Date) {
                local = value;
            } else {
                // need at least the three date parts
                if (value && value.length && value.length >= 3) {
                    dt = KD.utils.Util.formatDate(value);
                    if (dt == "") {
                        return dt;
                    }

                    // hours
                    h = parseInt(value[3], 10);
                    if (h < 0 || h >= 24) {
                        h = 0;
                    }
                    if (isNaN(h)) {
                        return "";
                    }

                    // minutes
                    m = parseInt(value[4], 10);
                    if (m < 0 || m >= 60) {
                        m = 0;
                    }
                    if (isNaN(m)) {
                        return "";
                    }

                    // seconds
                    s = parseInt(value[5], 10);
                    if (s < 0 || s >= 60) {
                        s = 0;
                    }
                    if (isNaN(s)) {
                        return "";
                    }

                    // convert to a Date object
                    local = new Date(
                            parseInt(value[0], 10),
                            parseInt(value[1], 10) - 1,
                            parseInt(value[2], 10),
                            h, m, s);
                } else {
                    local = "";
                }
            }

            // return if local is not a date object
            if (local == null || local == "") {
                return "";
            }

            // now format the local date/time string
            if (friendlyFormat) {
                dt = local.toLocaleDateString() + ' ' + local.toLocaleTimeString();
            } else {
                // get the UTC components
                var localDtParts = KD.utils.Util.getDtParts(local);

                // convert the date/time string to UTC
                dt = KD.utils.Util.formatDate(localDtParts) + 'T' +
                     KD.utils.Util.padZeros(localDtParts[3], 2) + tsep +
                     KD.utils.Util.padZeros(localDtParts[4], 2) + tsep +
                     KD.utils.Util.padZeros(localDtParts[5], 2);

                var offset = local.getTimezoneOffset();
                var offsetSign = offset > 0 ? '-' : '+';
                var offsetH = parseInt(Math.abs(offset) / 60, 10);
                var offsetM = parseInt(Math.abs(offset) % 60, 10);

                // add the timezone offset
                dt += offsetSign +
                        KD.utils.Util.padZeros(offsetH, 2) + tsep +
                        KD.utils.Util.padZeros(offsetM, 2);
            }
            return dt;
        };

        /**
         * Formats the value for a Date/Time question to UTC in ISO 8601 format.
         * @method formatUTCDateTime
         * @param {Array} values Array of date parts: year (4 digit), month (1-12), day (1-31), hours (0-23), minutes (0-59), sec (0-59)
         * @return {String} The string representation of the date parts: yyyy-mm-ddThh:mm:ssZ
         */
        this.formatUTCDateTime = function (values) {
            var dt, h, m, s, tsep = ':';

            // need at least the three date parts
            if (values && values.length && values.length >= 3) {
                dt = KD.utils.Util.formatDate(values);
                if (dt == "") {
                    return dt;
                }

                // hours
                h = parseInt(values[3], 10);
                if (h < 0 || h >= 24) {
                    h = 0;
                }
                if (isNaN(h)) {
                    return "";
                }

                // minutes
                m = parseInt(values[4], 10);
                if (m < 0 || m >= 60) {
                    m = 0;
                }
                if (isNaN(m)) {
                    return "";
                }

                // seconds
                s = parseInt(values[5], 10);
                if (s < 0 || s >= 60) {
                    s = 0;
                }
                if (isNaN(s)) {
                    return "";
                }

                // convert to a Date object
                var local = new Date(
                        parseInt(values[0], 10),
                        parseInt(values[1], 10) - 1,
                        parseInt(values[2], 10),
                        h, m, s);

                // get the UTC components
                var utcDtParts = KD.utils.Util.getUTCDtParts(local);

                // convert the date/time string to UTC
                dt = KD.utils.Util.formatDate(utcDtParts) + 'T' +
                     KD.utils.Util.padZeros(utcDtParts[3], 2) + tsep +
                     KD.utils.Util.padZeros(utcDtParts[4], 2) + tsep +
                     KD.utils.Util.padZeros(utcDtParts[5], 2) + 'Z';
            } else {
                dt = "";
            }
            return dt;
        };

        /**
         * Formats the input date as a simple date/time string format.
         * @method formatSimpleDateTime
         * @param {Date} dt The date object to format
         * @param {String} sep (optional) The date separator character - default (/)
         * @return {String} The formatted date:  yyyy/mm/dd hh:mm:ss a
         */
        this.formatSimpleDateTime = function (dt, sep) {
            sep = sep || "/";
            var y = dt.getFullYear(),
                M = KD.utils.Util.padZeros(dt.getMonth() + 1, 2),
                d = KD.utils.Util.padZeros(dt.getDate(), 2),
                h = dt.getHours(),
                m = KD.utils.Util.padZeros(dt.getMinutes(), 2),
                s = KD.utils.Util.padZeros(dt.getSeconds(), 2),
                a = 'AM';

            if (h >= 12) {
                a = 'PM';
                if (h > 12) {
                    h += -12
                }
            }
            h = KD.utils.Util.padZeros(h, 2);
            return y + sep + M + sep + d + ' ' + h + ':' + m + ':' + s + ' ' + a;
        };

        /**
         * Retrieves the user's Locale value from their local workstation
         * @method getLocale
         * @return locale value such as en, en-AU, en-US, etc...
         */
        this.getLocale = function () {
            if ( navigator ) {
                if ( navigator.userLanguage ) {
                    // IE6/7/8 use this value
                    return navigator.userLanguage;
                }
                else if ( navigator.browserLanguage ) {
                    return navigator.browserLanguage;
                }
                else if ( navigator.systemLanguage ) {
                    return navigator.systemLanguage;
                }
                else if ( navigator.language ) {
                    // Chrome uses this, and is set by Tools->Options->Change Font and Languages->Chrome Language Settings.
                    // Firefox uses this, and is derived from the OS Regional Settings
                    return navigator.language;
                }
            }
            return null;
        };

        /**
         * Removes the specified attribute from the element if it is blank
         * @method removeBlankAttribute
         * @param el The question form element
         * @param attName The name of the attribute to remove if it does not contain a value
         */
        this.removeBlankAttribute = function (el, attName) {
            var att;
            if (el && attName) {
                att = el.getAttribute(attName);
                if (att == null || att.length == 0) {
                    el.removeAttribute(attName);
                }
            }
        };

        /**
         * Removes all blank "required" attributes from question elements to make them HTML5 friendly
         * @method removeBlankRequiredAttributes
         */
        this.removeBlankRequiredAttributes = function () {
            var
            a = "required",
            c = "answerValue",
            f = Dom.get("pageQuestionsForm");

            // input
            KD.utils.Util.getElementsByClassName(c, "input", f, function(o) {
                KD.utils.Util.removeBlankAttribute(o, a);
            });
            // textarea
            KD.utils.Util.getElementsByClassName(c, "textarea", f, function(o) {
                KD.utils.Util.removeBlankAttribute(o, a);
            });
            // select
            KD.utils.Util.getElementsByClassName(c, "select", f, function(o) {
                KD.utils.Util.removeBlankAttribute(o, a);
            });
        };

        /**
         * Checks if any of an array of elements contains the specified class name.
         *
         * @private
         * @method _checkClassName
         * @param els {HTMLElement | HTMLElement Array} elements to check
         * @param className {String} the class name to check
         * @return true if any of the elements in the array contain the specified class, else false
         */
        this._checkClassName = function (els, className) {
            var result = false;
            // convert to an array if not alread
            if (!KD.utils.Util.isArray(els)) { els = new Array(els); }

            var test = KD.utils.Util.hasClass(els, className);
            for (var i = 0; i < test.length; i++) {
                if (test[i]) {
                    result = true;
                    break;
                }
            }
            return result;
        };

        /**
         * Determine if an element or elements belong to a date question
         *
         * @private
         * @method _isDateQuestion
         * @param els {HTMLElement | HTMLElement Array} elements to check
         */
        this._isDateQuestion = function (els) {
            return KD.utils.Util._checkClassName(els, "dateHidden");
        };

        /**
         * Determine if an element or elements belong to a date question
         *
         * @private
         * @method _isDateQuestion
         * @param els {HTMLElement | HTMLElement Array} elements to check
         */
        this._isDateTimeQuestion = function (els) {
            return KD.utils.Util._checkClassName(els, "dtHidden");
        };

    };
}


/**
 * A Java-like Hash implementation that will not have collision problems
 * present using associative arrays/standard Array class and prototype.
 * @namespace KD.utils
 * @class Hash
 * @constructor
 */
KD.utils.Hash = function () {
    /**
     * The number of items in the hash.
     * @property length
     * @private
     * @type Number
     * @default 0
     */
    this.length = 0;

    /**
     * The items in the hash.
     * @property items
     * @private
     * @type Array
     */
    this.items = new Array();

    for (var i = 0; i < arguments.length; i += 2) {
        if (typeof(arguments[i + 1]) != 'undefined') {
            this.items[arguments[i]] = arguments[i + 1];
            this.length++;
        }
    }

    /**
     * Deletes an item from the Hash
     * @method removeItem
     * @param {Object} in_key The key for the item to remove
     * @return {Object} The object in the hash represented by the key
     */
    this.removeItem = function (in_key) {
        var tmp_value;
        if (typeof(this.items[in_key]) != 'undefined') {
            this.length--;
            tmp_value = this.items[in_key];
            delete this.items[in_key];
        }
        return tmp_value;
    };

    /**
     * Retrieves an item from the Hash
     * @method getItem
     * @param {Object} in_key The key for the item to retrieve
     * @return {Object} The object in the hash represented by the key
     */
    this.getItem = function (in_key) {
        return this.items[in_key];
    };

    /**
     * Adds or replaces an item in the Hash
     * @method setItem
     * @param {Object} in_key The unique key that represents an item in the hash
     * @param {Object} in_value The value object represented by the key
     * @return {Object} The value of the object just added/updated in the hash
     */
    this.setItem = function (in_key, in_value) {
        if (typeof(in_value) != 'undefined') {
            if (typeof(this.items[in_key]) == 'undefined') {
                this.length++;
            }

            this.items[in_key] = in_value;
        }

        return in_value;
    };

    /**
     * Checks if the hash contains an entry for the supplied key
     * @method hasItem
     * @param {Object} in_key The unique key that represents an item in the hash
     * @return {Boolean} true if the key was found in the hash, else false
     */
    this.hasItem = function (in_key) {
        return typeof(this.items[in_key]) != 'undefined';
    };
};

/**
 * For Internal Use Only
 * A singleton utility class that includes the important fields for the form:
 * required fields, pattern match fields, event fields.
 * @private
 */
KD.utils.Client = function () {
    /**
     * Required questions on the current page.
     * {[field,message],...}
     *
     * @property requiredFields
     * @type Hash
     * @private
     */
    this.requiredFields = new KD.utils.Hash();

    /**
     * Questions that use pattern validation
     * {[field, pattern, message],...}
     *
     * @property patternFields
     * @type Hash
     * @private
     */
    this.patternFields = new KD.utils.Hash();

    /**
     * Elements that have client-side events.
     * {[field, event, action]}
     *
     * @property eventFields
     * @type Hash
     * @private
     */
    this.eventFields = new KD.utils.Hash();
};
