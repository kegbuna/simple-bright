/*
Copyright (c) 2012, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/

/**
 * <p>
 * Core client-side functionality for Kinetic Survey and Kinetic Request.
 * </p>
 * <p>
 * The files in this module should be included in all display pages.  Either each
 * file may be individually included, or just the kd_core.js may be included which
 * contains the minified contents of all three files.
 * <p>
 *
 * @module core
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

if (!KD.utils.ClientManager) {

    /**
     * A library of client properties and methods
     * @namespace KD.utils
     * @class ClientManager
     * @static
     */
    KD.utils.ClientManager = new function () {
        /**
         * @property _elements
         * @type Hash
         * @private
         */
        this._elements = new KD.utils.Hash();

        /**
         * @property _connections
         * @type Hash
         * @private
         */
        this._connections = new KD.utils.Hash();

        /**
         * @property _invalidSessionRequest
         * @type Array
         * @private
         */
        this._invalidSessionRequest = new Array();

        /**
         * @property _invalidSessionRequest
         * @type Array
         * @private
         */
        this._unauthorizedSessionRequests = {};

        /**
         * <p>
         * The unique sessionId identifying the users current session.
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.sessionId='&lt;jsp:getProperty name="customerSurvey" property="customerSessionInstanceID"/&gt;';
         * </code>
         * </p>
         *
         * @property sessionId
         * @type String
         */
        this.sessionId = "";

        /**
         * <p>
         * Any current error messages returned with a request
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.errorMessage = '&lt;jsp:getProperty name="customerSurvey" property="errorMessage"/&gt;';
         * </code>
         * </p>
         *
         * @property errorMessage
         * @type String
         */
        this.errorMessage = "";

        /**
         * <p>
         * Any current success messages returned with a request
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.errorMessage = '&lt;jsp:getProperty name="customerSurvey" property="successMessage"/&gt;';
         * </code>
         * </p>
         *
         * @property successMessage
         * @type String
         */
        this.successMessage = "";

        /**
         * <p>
         * Indicates if the current user has been authenticated
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.authenticated=&lt;%= UserContext.isAuthenticated()%&gt;;
         * </code>
         * </p>
         *
         * @property authenticated
         * @type Boolean
         * @default false
         */
        this.authenticated = false;

        /**
         * <p>
         * The authenticated user's Remedy login id
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.userName='&lt;%= UserContext.getUserName()%&gt;';
         * </code>
         * </p>
         *
         * @property userName
         * @type String
         */
        this.userName = "";

        /**
         * <p>
         * The instanceId of the template currently being viewed
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.templateId='&lt;jsp:getProperty name="customerSurvey" property="surveyTemplateInstanceID"/&gt;';
         * </code>
         * </p>
         *
         * @property templateId
         * @type String
         */
        this.templateId = "";

        /**
         * <p>
         * The instanceId of the base request record currently being viewed
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.customerSurveyId='&lt;jsp:getProperty name="customerSurvey" property="customerSurveyInstanceID"/&gt;';
         * </code>
         * </p>
         *
         * @property customerSurveyId
         * @type String
         */
        this.customerSurveyId = "";

        /**
         * <p>
         * The instanceId of the category this request record belongs to.  For
         * Kinetic Request, it represents the Service Catalog instanceId the
         * service item belongs to.
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.categoryId='&lt;jsp:getProperty name="customerSurvey" property="categoryId"/&gt;';
         * </code>
         * </p>
         *
         * @property categoryId
         * @type String
         */
        this.categoryId = "";

        /**
         * <p>
         * The value of the submit type.  This value is typically empty unless
         * the request is an approval or review request.
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.submitType='&lt;jsp:getProperty name="customerSurvey" property="submitType"/&gt;';
         * </code>
         * </p>
         *
         * @property submitType
         * @type String
         */
        this.submitType = "";

        /**
         * <p>
         * Used to indicate if the page currently being viewed has already been
         * submitted.
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.isNewPage=&lt;jsp:getProperty name="customerSurvey" property="isNewPage"/&gt;;
         * </code>
         * </p>
         *
         * @property isNewPage
         * @type Boolean
         * @default true
         */
        this.isNewPage = true;

        /**
         * <p>
         * The maximum amount of characters that can be submitted to the web
         * server at any one time.
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.maxCharsOnSubmit=&lt;jsp:getProperty name="customerSurvey" property="maxCharsOnSubmit"/&gt;;
         * </code>
         * </p>
         *
         * @property maxCharsOnSubmit
         * @type Number
         * @default 65535
         */
        this.maxCharsOnSubmit = (64 * 1024) - 1; // 65535

        /**
         * The message string displayed to the user if too many characters were
         * submitted.
         * @property tooManyCharactersForSubmitStr
         * @type String
         * @default A limit of 65535 characters for a submit is being applied. Please reduce the number of characters you are attempting to submit.
         */
        this.tooManyCharactersForSubmitStr = "A limit of " + this.maxCharsOnSubmit + " characters for a submit is being applied. Please reduce the number of characters you are attempting to submit.";

        /**
         * The error message title when required fields were not answered.
         * @property requiredWarningStr
         * @type String
         * @default Required fields missing
         */
        this.requiredWarningStr = "Required fields missing:";

        /**
         * The error message title when fields that have a pattern match applied
         * do not meet the required format.
         * @property validFormatWarningStr
         * @type String
         * @default Invalid formatted fields
         */
        this.validFormatWarningStr = "Invalid formatted fields:";

        /**
         * An array of the generated submit buttons for the page (both Submit and Previous)
         * @property submitButtons
         * @type Array
         */
        this.submitButtons = new Array();

        /**
         * Property to indicate whether the page is loading (true), or has finished loading (false).
         * @property isLoading
         * @type Boolean
         * @default false
         */
        this.isLoading = false;

        /**
         * Property to indicate whether the page is submitting answers (true).
         * @property isSubmitting
         * @type Boolean
         * @default false
         */
        this.isSubmitting = false;

        /**
         * A callback object containing information from the check session servlet.
         * From this property, it can be determined if the user's session is still
         * valid, or has expired.
         * @property sessionCheck
         * @type Object
         */
        this.sessionCheck = null;

        /**
         * <p>
         * The context the web application is running in the web server.  Using the
         * default Tomcat installation, the context is '/kinetic', but this may
         * vary by installation.
         * </p>
         * <p>
         * This property is typically set from within the <b>ks_initSessionVars()</b>
         * javascript function in the main JSP that renders the service item.<br/>
         * <code>
         * clientManager.webAppContextPath='&lt;%=request.getContextPath()%&gt;';
         * </code>
         * </p>
         *
         * @property webAppContextPath
         * @type String
         */
        this.webAppContextPath = "/kinetic";

        /**
         * A hash of custom events defined in the template.
         *   Key: Instance ID of the element it is tied to (only one custom event per element).
         *   Value: a clientAction object.
         * @property customEvents
         * @type Hash
         */
        this.customEvents = new KD.utils.Hash();

        /**
         * Custom event that fires on a field after that field has performed a Set Fields - External
         * event action.
         * @event onSetFieldsReturn
         */
        this.onSetFieldsReturn = null;

        /**
         * Custom event that fires when a list or dynamic list question as an menu attached
         * to it from a Populate Menu event action.
         * @event onAttachMenu
         */
        this.onAttachMenu = null;

        /**
         * Initializes the page elements, and sets up all the client-side events,
         * the user messages, and user session.  This method runs on page load.
         * @method init
         * @return void
         */
        this.init = function () {
            // tell the client manager the page is loading
            KD.utils.ClientManager.isLoading=true;

            // initalize session variables from the jsp
            if(window.ks_initSessionVars){
                ks_initSessionVars();
            }

            // register custom events
            KD.utils.ClientManager.onSetFieldsReturn = new YAHOO.util.CustomEvent("onSetFieldsReturn");
            KD.utils.ClientManager.onAttachMenu = new YAHOO.util.CustomEvent("onAttachMenu");

            // registers elements in the label cache and sets up the pattern validation
            KD.utils.ClientManager.initElements();

            // initialize messages and date questions
            KD.utils.ClientManager.initDateFields();
            KD.utils.ClientManager.checkMessages();
            // initialize the default login text
            KD.utils.ClientManager.initLogin();

            // add an event listener to validate the answers when the form is submitted
            var theForm=Dom.get('pageQuestionsForm');
            YAHOO.util.Event.addListener(theForm, 'submit', KD.utils.Action.validateForm, theForm, true);

            // prevent backspaces unless user is in approved field
            if (typeof window.event != 'undefined') { // IE
                    document.onkeydown = KD.utils.ClientManager.preventBackSpace;
            } else {
                    document.onkeypress = KD.utils.ClientManager.preventBackSpace;
            }

            // run the initialization hook for customers to run custom code after
            // everything else has been initialized
            if (typeof(customInitialization)=="function") {
            	customInitialization();
        	}

            // initialize the client side events defined for all elements in the form
            if(window.ks_actionsInit){
                ks_actionsInit();
            }

            // tell the client manager the page has been loaded
            KD.utils.ClientManager.isLoading=false;
        };

        /**
         * Processes all child nodes of an element to ensure all important
         * elements are cached in case the DOM was manipulated.
         * @method processNodIDElement
         * @private
         * @param {HTMLElement} nextElement
         */
		this.processNonIDElement = function (nextElement) {
            var qidx, childElement, childInstId;
            if (!nextElement) {
                return;
            }
            for (qidx = 0; qidx < nextElement.childNodes.length; qidx++) {
                childElement = nextElement.childNodes[qidx];
                if (!childElement) {
                    return;
                }
                childInstId = KD.utils.Util.getIDPart(childElement.id);

                if (!childInstId) {
                    //continue; // ignore items that we don't care about
					this.processNonIDElement(childElement);
                } else {
					this._elements.setItem(childInstId, KD.utils.Util.getElementType(childElement.id));
					KD.utils.Util.registerInCache(childElement);
					KD.utils.ClientManager.initPatternWatch(childElement);
					// preinitialize required questions
					KD.utils.ClientManager.setPreRequire(childElement);
				}
			}
		};

        /**
         * Registers all the page elements so they can be initialized:
         * required fields, pattern validation, etc...
         * @method registerItems
         * @private
         * @param {String} pageID InstanceId of the page that is currently being displayed
         * @param {HTMLElement} pageDocument DOM element of the 'PAGE_' element
         * @return void
         */
        this.registerItems = function (pageID, pageDocument) {
            var nextElement, instanceId, theForm, theButtons, i, qidx, childElement, childInstId;
            KD.utils.ClientManager._elements.setItem(pageID, KD.utils.Util.getElementType(pageDocument.id));

            for (i = 0; i < pageDocument.childNodes.length; i += 1) {
                nextElement = pageDocument.childNodes[i];
                if (!nextElement) {
                    continue;
                }

                instanceId = KD.utils.Util.getIDPart(nextElement.id);
                if (!instanceId) {
                    continue; // ignore items that we don't care about
                }

                if (nextElement.id && nextElement.id.indexOf("SECTION_") != -1) {
                    this._elements.setItem(KD.utils.Util.getIDPart(nextElement.id), KD.utils.Util.getElementType(nextElement.id));
					KD.utils.Util.registerInCache(nextElement);
                    // register all item within a section
                    for (qidx = 0; qidx < nextElement.childNodes.length; qidx++) {
                        childElement = nextElement.childNodes[qidx];
                        if (!childElement) {
                            continue;
                        }

                        childInstId = KD.utils.Util.getIDPart(childElement.id);
                        if (!childInstId) {
							this.processNonIDElement(childElement);
                        } else {
							this._elements.setItem(childInstId, KD.utils.Util.getElementType(childElement.id));
							KD.utils.Util.registerInCache(childElement);
							KD.utils.ClientManager.initPatternWatch(childElement);
							// preinitialize required questions
							KD.utils.ClientManager.setPreRequire(childElement);
						}
                    }
                } else if (nextElement.className && nextElement.className.indexOf("templateButtonLayer") != -1) {
                    this._elements.setItem(instanceId, KD.utils.Util.getElementType(nextElement.id));
					KD.utils.Util.registerInCache(nextElement);
                    this.submitButtons.push(instanceId);
                    theForm=Dom.get('pageQuestionsForm');
                    theButtons=Dom.getElementsByClassName('templateButton', 'input', nextElement);
                    YAHOO.util.Event.addListener(theButtons, 'click', KD.utils.Action._submitButtonClick, [theForm,instanceId], true);
                } else if (nextElement.id) {
                    this._elements.setItem(instanceId, KD.utils.Util.getElementType(nextElement.id));
					KD.utils.Util.registerInCache(nextElement);
					KD.utils.ClientManager.initPatternWatch(nextElement);
                    // preinitialize required questions
                    KD.utils.ClientManager.setPreRequire(nextElement);
                }
            }
        };

        /**
         * Initializes all the elements for the page currently being displayed.
         * @method initElements
         * @private
         * @return void
         */
        this.initElements = function () {
            var pageDocument,
                pageID,
                pageIdEl = Dom.get("pageID");

            // If the pageID element exists, get the value from it
            if (pageIdEl) {
                pageID = pageIdEl.value;
            }

            if (pageID && pageID.length > 10) {
                pageDocument = Dom.get("PAGE_" + pageID);
                this.registerItems(pageID, pageDocument);
            }
            // If the pageID element doesn't exist, get the templateContext elements
            else {
                /*On confirmation pages, may not have a page set in the hidden PageID field*/
                var pages=KD.utils.Util.getElementsByClassName("templateContent", "div");
                if (pages) {
                    for (var i = 0; i < pages.length; i++) {
                        pageDocument=pages[i];
                        if (pageDocument) {
                            pageID = pageDocument.id;
                            this.registerItems(KD.utils.Util.getIDPart(pageID), pageDocument);
                        }
                    }
                }
            }
        };

        /**
         * Checks if there is a "message" layer for including messages from
         * Remedy/web server such as "Successfully logged in".  Runs on load.
         * @method checkMessages
         * @return void
         */
        this.checkMessages = function () {
            var messageLayer=Dom.get('message');
            if(messageLayer){
                if (KD.utils.ClientManager.successMessage && KD.utils.ClientManager.successMessage != ""){
                    messageLayer.innerHTML= KD.utils.ClientManager.successMessage;
                    messageLayer.style.visibility="visible";
                    messageLayer.style.display="block";
                }
                if (KD.utils.ClientManager.errorMessage && KD.utils.ClientManager.errorMessage != ""){
                    messageLayer.innerHTML=KD.utils.ClientManager.errorMessage;
                    messageLayer.style.visibility="visible";
                    messageLayer.style.display="block";
                }
            }else if(KD.utils.ClientManager.errorMessage && KD.utils.ClientManager.errorMessage != ""){
                alert(KD.utils.ClientManager.errorMessage);
            }
        };

        /**
         * Initializes all date questions on the page.  This retrieves the saved
         * value string, and sets the date/time components to their proper values.
         * @method initDateFields
         * @private
         * @return void
         */
        this.initDateFields = function(){
            var yearEls=KD.utils.Util.getElementsByClassName("dateYear", "input");
            for (var i=0; i<yearEls.length; i++){
                var instId=yearEls[i].id.substring(5);
                if(instId){
                    KD.utils.Action.setDateFields(instId);
                }
            }
            yearEls = KD.utils.Util.getElementsByClassName("dtYear", "input");
            for (i = 0; i < yearEls.length; i++) {
                instId = yearEls[i].id.substring(5);
                if (instId) {
                    KD.utils.Action.setDateTimeFields(instId);
                }
            }
        };

        /**
         * Replaces the text "--loginName--" with the authenticated user name
         * in the DOM element "authenticatedName".
         * Only if the user is authenticated.
         * @method initLogin
         * @return void
         */
        this.initLogin = function () {
            var loginForm=Dom.get("loginForm");
            var loginInfo=Dom.get('authenticatedName');
            if(KD.utils.ClientManager.authenticated){
                if(loginForm){
                    loginForm=loginForm.parentNode;
                    var parent=loginForm.parentNode;
                    parent.removeChild(loginForm);
                }
                if (loginInfo){
                    var login=loginInfo.innerHTML;
                    login=login.replace(/--loginName--/i, KD.utils.ClientManager.userName);
                    loginInfo.innerHTML=login;
                }
            }else{
                if(loginInfo){
                    var par=loginInfo.parentNode;
                    par.removeChild(loginInfo);
                }
                var originatingPage=Dom.get('originatingPage');
                if (originatingPage){
                    originatingPage.value=this.originatingPage;
                }
                var authenticationType=Dom.get('authenticationType');
                if (authenticationType){
                    authenticationType.value=this.authenticationType;
                }
                var sessionFld=Dom.get('loginSessionID');
                if(sessionFld){
                    sessionFld.value=Dom.get("sessionID").value;
                }
            }
        };

        /**
         * Returns the element type given an instance Id.
         * @method getElementType
         * @param {String} instId The instance ID of an element on the page
         * @return {String} the element type
         */
        this.getElementType = function(instId){
            return this._elements.getItem(instId);
        };

        /**
         * Clears the invalid session requests array
         * @method clearInvalidSessionRequest
         * @return void
         */
        this.clearInvalidSessionRequest = function () {
            KD.utils.ClientManager._invalidSessionRequest = new Array();
        };

        /**
         * Retrieve the array of invalid session requests
         * @method getInvalidSessionRequest
         * @return {Array} Array of invalid session requests
         */
        this.getInvalidSessionRequest = function () {
            return KD.utils.ClientManager._invalidSessionRequest;
        };

        /**
         * Registers an invalid session request so it can be tracked.
         * @method registerInvalidSessionRequest
         * @param {String} dataReqInstId The identifier string of the request
         * @param {String} post Request method (POST | GET | PUT | DELETE)
         * @param {String} path URL path of the request
         * @param {Object} callback Callback object for the request.
         * @return void
         */
        this.registerInvalidSessionRequest = function (dataReqInstId, post, path, callback){
            var paramsArray = new Array();
            paramsArray[0]=dataReqInstId;
            paramsArray[1]=post;
            paramsArray[2]=path;
            paramsArray[3]=callback;

            KD.utils.ClientManager._invalidSessionRequest=paramsArray;
        };

        /**
         * Registers an unauthorized session request so it can be tracked and
         * re-attempted once a simple login is successful.
         * @method registerUnauthorizedSessionRequest
         * @param {String} dataReqInstId The identifier string of the request
         * @param {String} method Request method (POST | GET | PUT | DELETE)
         * @param {String} path URL path of the request
         * @param {Object} callback Callback object for the request.
         * @return void
         */
        this.registerUnauthorizedSessionRequest = function(dataReqInstId, method, path, callback) {
            KD.utils.ClientManager._unauthorizedSessionRequests[dataReqInstId] = [
                dataReqInstId, method, path, callback
            ]
        }

        /**
         * Monitors active Simple Data Request Connections to avoid getting results
         * back out of order, particularly on keypress events.
         * @method setNewConnection
         * @param {String} dataReqInstId The Simple Data Request instance Id
         * @param {Array} paramsArray [YUI connection object, requestParamString]
         * @return void
         */
        this.setNewConnection = function (dataReqInstId, paramsArray) {
            if (dataReqInstId != null && paramsArray != null && paramsArray.length >0){
                KD.utils.ClientManager._connections.setItem(dataReqInstId, paramsArray);
            }
        };

        /**
         * Determine whether the Simple Data Request is active (not yet returned a response)
         * @method isActiveConnection
         * @param {String} dataReqInstId The Simple Data Request instance Id
         * @return {Boolean} true if the connection is still active
         */
        this.isActiveConnection = function(dataReqInstId){
            var conn = KD.utils.ClientManager._connections.getItem(dataReqInstId);
            var isActive = false;
            if(conn != null && conn.length >0){
                isActive = Connect.isCallInProgress(conn[0]);
            }
            return isActive;
        };

        /**
         * Returns a connection object which includes the YUI connection, along
         * with the params used for connection.  The params are useful if
         * comparing whether a new request is the same as an old one.
         * @method getConnection
         * @param {String} dataReqInstId The Simple Data Request instance Id
         * @return {Array} Returns an array of connection info [YUI connection object, requestParamString]
         */
        this.getConnection = function (dataReqInstId) {
            var conn;
            if (dataReqInstId != null){
                conn = KD.utils.ClientManager._connections.getItem(dataReqInstId);
            }
            return conn;
        };

        /**
         * Registers a client-side event action as a custom event to the ClientManager
         * object.
         * @method addAction
         * @param {Object} clientAction The client-side event action to register
         * @return void
         */
        this.addAction = function(clientAction){
            //Special custom events
            if(clientAction.jsEvent=="*custom*" || clientAction.jsEvent=="submit" || clientAction.jsEvent=="beforeSubmit"){
                var id=clientAction.elementId;
                if(clientAction.jsEvent=="submit"|| clientAction.jsEvent=="beforeSubmit"){
                    id=id+"-"+clientAction.jsEvent
                }
                KD.utils.ClientManager.addCustomEvent(id, clientAction);
                return;
            }
            //Generic custom events
            if(clientAction.jsEvent=="setFieldsReturn" || clientAction.jsEvent=="attachMenu"){
                var customEvent=KD.utils.ClientManager.onSetFieldsReturn;
                if(clientAction.jsEvent=="attachMenu"){
                    customEvent=KD.utils.ClientManager.onAttachMenu;
                }
                customEvent.subscribe(function(type, origItems, clientAction){
                    KD.utils.Action._customEventHandler(type, origItems,clientAction)
                }, clientAction);
                return;
            }
            //Standard Events
            YAHOO.util.Event.addListener(clientAction.elObj, clientAction.jsEvent, function(e){
                clientAction.action.apply(KD.utils.Action,[e,this])
            }, clientAction, true);
            //If the objects have a value, fire the action now for page re-loads, approvals, back button
            var objs=new Array();
            if(KD.utils.Util.isArray(clientAction.elObj)){
                objs=clientAction.elObj;
            }else{
                objs.push(clientAction.elObj);
            }
            for(var i = 0; i < objs.length; i++){
                KD.utils.Action.applyValueActions(objs[i],clientAction);
            }
        };

        /**
         * Custom Events are tied to Dynamic Text Elements.  They are useful for
         * triggering something when a dynamic text element is interacted with,
         * such as on an innerHTML update in a service catalog.  Only one
         * customEvent per dynamic text element is stored.
         * @method addCustomEvent
         * @param {String} id
         * @param {Object} clientAction A KD.utils.ClientAction object
         * @return void
         */
        this.addCustomEvent = function (id, clientAction) {
            var actions=KD.utils.ClientManager.customEvents.getItem(id);
            if(actions && actions.length > 0){
                actions.push(clientAction);
            }else{
                actions=[clientAction];
            }
            KD.utils.ClientManager.customEvents.setItem(id, actions);
        };

        /**
         * Determines if the element has a pattern associated with it, and sets
         * up the events to check the pattern when the field is changed.  Also
         * sets up events listeners to monitor the number of characters entered in
         * textarea fields, and attachment fields to monitor the types of files
         * being uploaded.
         * @method initPatternWatch
         * @private
         * @param {HTMLElement} el The element to initialize the pattern match on
         * @return void
         */
        this.initPatternWatch = function (el) {
            var inputEl=KD.utils.Util.getQuestionInput(KD.utils.Util.getIDPart(el.id));
            if (inputEl && !inputEl.length){ //If this is an array of radio buttons exit, as we don't do patterns for them
                var pattern=inputEl.getAttribute('validationFormat');
                if(pattern && pattern != ""){
                    YAHOO.util.Event.addListener(inputEl, 'focus', KD.utils.Action._disableButtonEvents);
                    YAHOO.util.Event.addListener(inputEl, 'blur', KD.utils.Action.checkPattern);
                }
                //Watch typing for textarea fields w/max characters set
                else if(inputEl.tagName && inputEl.tagName.toUpperCase()=="TEXTAREA" && inputEl.getAttribute("maxlength")){
                   YAHOO.util.Event.addListener(inputEl, 'keyup', function(e,parms){
                        KD.utils.Action.watchFieldLength(parms)
                    }, inputEl);
                    YAHOO.util.Event.addListener(inputEl, 'change', function(e,parms){
                        KD.utils.Action.watchFieldLength(parms)
                    }, inputEl);
                }
            }
            //Watch for attachments
            if (inputEl && !KD.utils.Util.isArray(inputEl)) {
                if (inputEl.getAttribute('fileTypesAllowed') != null) {
                    YAHOO.util.Event.addListener(inputEl, 'change', function(e,parms){
                        KD.utils.Action._setFileLink(parms)
                    }, inputEl);
                    KD.utils.Action._setFileLink(inputEl);
                }
            }
        };

        /**
         * Displays messages to the user in a modal panel instead of a javascript
         * alert box.  This gives the benefit of displaying HTML formatted strings.
         * @method alertPanel
         * @private
         * @param {Object} options Defines the text information to display
         *     header: {String} The text to diaplay in the Panel header
         *     body:   {String} The text to display in the Panel body
         *     element: {HTMLElement} A form field to set the focus to on close
         * @return void
         */
        this.alertPanel = function (options) {
            if (options == null) {
                options = {
                    header: 'Alert',
                    body: '',
                    element: null
                };
            }
            var validationPanelId = 'validationAlert';
            var validationPanelEl = Dom.get(validationPanelId);
            var validationPanelOkId = 'validationAlertOk';
            try {
                if (!validationPanelEl) {
                    // create the validation alert container, and append to the dom
                    validationPanelEl = document.createElement('div');
                    validationPanelEl.id = validationPanelId;
                    document.body.appendChild(validationPanelEl);

                    // create the validation alert panel
                    var validationPanel = new YAHOO.widget.Panel(validationPanelId,
                        {
                            visible: false,
                            close: false,
                            draggable: true,
                            fixedcenter: true,
                            constraintoviewport: true,
                            zindex: 2,
                            iframe: true,
                            modal: true
                        }
                    );
                    // subscribe to the validation panel's hideEvent handler to
                    // set focus to the first field with an error
                    validationPanel.hideEvent.subscribe(function() {
                        if (options.element &&
                            options.element.focus &&
                            options.element.style &&
                            options.element.style.visiblity != "hidden" &&
                            options.element.style.display != "none") {
                            try {
                                // set focus back to a form field
                                options.element.focus();
                                options.element.select();
                            } catch (error) {}
                        }
                    });

                    // create the validation alert panel ok button
                    var validationPanelOkEl = document.createElement('input');
                    validationPanelOkEl.id = validationPanelOkId;
                    validationPanelOkEl.type = "button";
                    validationPanelOkEl.value = "OK";
                    validationPanelOkEl.onclick = function() {
                        validationPanel.hide();
                        validationPanel.destroy();
                    };
                }

                // set the content of the validation alert panel
                validationPanel.setHeader(options.header || "Form Errors: ");
                // replace all line feeds with html breaks
                validationPanel.setBody((options.body || "").replace(/\n/g, '<br/>'));
                // put an OK button in the footer
                validationPanel.setFooter(validationPanelOkEl);
                validationPanel.render(document.body);
                validationPanel.show();
            } catch (e) {
                // remove the element so it can be created the next time it is needed
                var el = Dom.get(validationPanelId);
                if (el) {
                    document.removeChild(el);
                }
            }
        };

        /**
         * Displays a simple, modal login dialog to allow a user to reestablish
         * a session after a timeout without having to redirect to a login page
         * and lose all changes on the current form.
         * @method renderSimpleLogin
         * @param {Object} options Options to define how the login dialog appears:
         *     showAuthStr: true|false (default false)
         *     showUserName: true|false (default false)
         * @return void
         */
        this.renderSimpleLogin = function (options) {
            // build up the html for the dialog form
            KD.utils.ClientManager.buildSimpleLogin(options);

            // dialog button handlers
            var handleCancel = function() {
                // re-enable the main form submit buttons
                KD.utils.ClientManager.isSubmitting=false;
                for (var i = 0; i < KD.utils.ClientManager.submitButtons.length; i += 1) {
                    KD.utils.Action.enableButton(KD.utils.ClientManager.submitButtons[i]);
                }
                // cancel and destroy the dialog
                this.cancel();
                this.destroy();
            }
            var handleSubmit = function() {
                Connect.initHeader("X-Requested-With", "XMLHttpRequest");
                this.submit();
                this.show();  // keep the dialog open, and let the callback handle it
            }

            // render the form in a YUI dialog container
            var simpleLogin = new YAHOO.widget.Dialog("simpleLogin",
            {
                width: "300px",
                fixedcenter: true,
                visible: false,
                constraintoviewport: true,
                close: false,
                modal: true,
                postmethod: 'async',
                buttons: [
                {
                    text: "Login",
                    handler: handleSubmit,
                    isDefault: true
                },

                {
                    text: "Cancel",
                    handler: handleCancel
                }
                ]
            } );

            // callbacks for the XhrRequest object
            var handleSuccess = function(o) {
                // re-enable the main form submit buttons
                KD.utils.ClientManager.isSubmitting=false;
                for (var i = 0; i < KD.utils.ClientManager.submitButtons.length; i += 1) {
                    KD.utils.Action.enableButton(KD.utils.ClientManager.submitButtons[i]);
                }
                var params = KD.utils.ClientManager.getInvalidSessionRequest();
                // If there was an invalid session stored
                if (params.length > 0) {
                    // If recovered, run the last Datarequests again
                    if (params[0]==="PREV_PAGE_REQUEST") {
                        KD.utils.Action.disableSubmitButtons();
                        KD.utils.Action.loadPreviousPage();
                    } else if (params[0]==="NEXT_PAGE_REQUEST"){
                        KD.utils.Action.disableSubmitButtons();
                        document.pageQuestionsForm.submit();
                    } else if (params[1] !== null && params[2] !== null && params[3] !== null) {
                        Connect.asyncRequest(params[1],params[2],params[3]);
                    } else {
                        // did not recognize the type of action, do nothing special
                    }
                }

                // For each of the queued unauthorized session requests
                for (var requestId in KD.utils.ClientManager._unauthorizedSessionRequests) {
                    // Obtain the Async request parameters for the request
                    var requestParams = KD.utils.ClientManager._unauthorizedSessionRequests[requestId];
                    // Re-attempt the request
                    Connect.asyncRequest(requestParams[1],requestParams[2],requestParams[3]);
                }

                // hide and destroy the dialog
                simpleLogin.hide();
                simpleLogin.destroy();
            };
            var handleFailure = function(o) {
                // display error messages
                var statusCode = null;
                if (o && o.status) {
                    statusCode = o.status;
                }
                var errorMessage = null;
                if (o && o.getResponseHeader && o.getResponseHeader['X-Error-Message']) {
                    errorMessage = o.getResponseHeader['X-Error-Message'];
                } else {
                    errorMessage = "Error: " + statusCode;
                }

                var msgEl = Dom.get('simpleLoginMsg');
                if (msgEl) {
                    msgEl.innerHTML = errorMessage;
                    Dom.setStyle(msgEl, 'display', 'block');
                } else {
                    alert(errorMessage);
                }

                var pwdInput = Dom.get('simpleLoginPass');
                if (pwdInput) {
                    pwdInput.value = "";
                    pwdInput.select();
                    pwdInput.focus();
                }
            };

            // define the callback object
            simpleLogin.callback = {
                success: handleSuccess,
                failure: handleFailure,
                timeout: 30000
            };

            // validate the user at least entered a login id
            simpleLogin.validate = function() {
                var data = this.getData();
                if (data.UserName == "") {
                    alert("Please enter your Login ID");
                    return false;
                } else {
                    return true;
                }
            };

            // render and display the dialog, then focus on first input field
            simpleLogin.render();
            simpleLogin.show();
            simpleLogin.focusFirst();
            var userInput = Dom.get("simpleLoginUser");
            var passInput = Dom.get("simpleLoginPass");
            if (userInput && userInput.getAttribute("readOnly") != "true") {
                userInput.select();
                userInput.focus();
            } else {
                passInput.select();
                passInput.focus();
            }
        };

        /**
         * Returns information about a required question so class names can be
         * applied to the question's various layer elements.
         * @method _findPreRequireObject
         * @private
         * @param {HTMLElement} qEl
         * @return {Object} the type of element
         */
        this._findPreRequireObject = function (qEl) {
            if (typeof qEl == "string") {
                qEl = KD.utils.Util.getQuestionLayer(qEl);
            }
            if (qEl == null || qEl == "undefined" || !qEl.children) {
                return null;
            }
            var inputField=null;
            var dateInput=null;
            var type;
            var aIdx, iIdx;

            // Find Input
            for (aIdx=0; aIdx<qEl.children.length; aIdx++) {
                if (qEl.children[aIdx].id != undefined && qEl.children[aIdx].id.indexOf("QANSWER_")!=-1){
                    var children = qEl.children[aIdx].children;
                    for (iIdx=0; iIdx<children.length; iIdx++) {
                        if (children[iIdx].id != undefined && children[iIdx].id.indexOf("year_")!=-1){
                            dateInput=children[iIdx];
                        }
                        if (children[iIdx].id != undefined && children[iIdx].id.indexOf("SRVQSTN_")!=-1){
                            inputField = children[iIdx];
                            break;
                        }
                    }
                    if (inputField == null) {
                        // see if a checkbox question
                        children = qEl.children[aIdx].children[0].children;
                        for (iIdx=0; iIdx<children.length; iIdx++) {
                            if (children[iIdx].id != undefined && children[iIdx].id.indexOf("SRVQSTN_")!=-1){
                                inputField = children[iIdx];
                                break;
                            }
                        }
                    }
                }
            }
            type = dateInput ? "date" : KD.utils.Util.getAnswerType(inputField);
            var retVal = {'qElement': qEl, 'qInput': inputField, 'type': type, 'dateInput': dateInput};
            return retVal;
        };

        /**
         * Adds class names to the various question elements to indicate the question
         * is required.
         *   Question Layer:  'preRequiredLayer',  'preRequiredLayer_' + type
         *   Question Label:  'preRequiredLabel',  'preRequiredLabel_' + type
         *   Answer Layer:    'preRequiredAnswer', 'preRequireAnswer_' + type
         *   Answer Input:    'preRequiredInput',  'preRequiredInput_' + type
         *
         * @method setPreRequire
         * @param {String | HTMLElement} qElement the question element, question id, or question label
         * @return void
         */
        this.setPreRequire = function (qElement) {
            var oInput = KD.utils.ClientManager._findPreRequireObject(qElement);
            if (oInput == null) {
                return;
            }
            var type = oInput.type;
            var inputField = oInput.qInput;
            var dateInput = oInput.dateInput;
            var qEl = oInput.qElement;
            var iIdx;

            if (inputField && inputField.getAttribute("required") == 'true') {
                KD.utils.Util.removeClass(qEl, 'preRequiredRemovedLayer');
                KD.utils.Util.addClass(qEl, 'preRequiredLayer');
                KD.utils.Util.addClass(qEl, 'preRequiredLayer_'+type);

                for (iIdx=0; iIdx<qEl.children.length; iIdx++) {
                    if (qEl.children[iIdx].id != undefined && qEl.children[iIdx].id.indexOf("QLABEL_")!=-1){
                        KD.utils.Util.removeClass(qEl.children[iIdx], 'preRequiredRemovedLabel');
                        KD.utils.Util.addClass(qEl.children[iIdx], 'preRequiredLabel');
                        KD.utils.Util.addClass(qEl.children[iIdx], 'preRequiredLabel_'+type);
                        break;
                    }
                }

                for (iIdx=0; iIdx<qEl.children.length; iIdx++) {
                    if (qEl.children[iIdx].id != undefined && qEl.children[iIdx].id.indexOf("QANSWER_")!=-1){
                        KD.utils.Util.removeClass(qEl.children[iIdx], 'preRequiredRemovedAnswer');
                        KD.utils.Util.addClass(qEl.children[iIdx], 'preRequiredAnswer');
                        KD.utils.Util.addClass(qEl.children[iIdx], 'preRequiredAnswer_'+type);
                        break;
                    }
                }

                var inputEl = dateInput ? dateInput : inputField;
                KD.utils.Util.removeClass(inputEl, 'preRequiredRemovedInput');
                KD.utils.Util.addClass(inputEl, 'preRequiredInput');
                KD.utils.Util.addClass(inputEl, 'preRequiredInput_'+type);
            }
        };

        /**
         * Removes class names from the various question elements when a question is
         * no longer required.  This will remove any styling that was applied to
         * the required questions based on the pre-required class names.
         * @method clearPreRequire
         * @param {String | HTMLElement} qElement the question element, question id, or question label
         * @return void
         */
        this.clearPreRequire = function (qElement) {
            var oInput = KD.utils.ClientManager._findPreRequireObject(qElement);
            if (oInput == null) {
                return;
            }
            var type = oInput.type;
            var inputField = oInput.qInput;
            var dateInput = oInput.dateInput;
            var qEl = oInput.qElement;
            var iIdx;

            if (inputField) {
                KD.utils.Util.removeClass(qEl, 'preRequiredLayer');
                KD.utils.Util.removeClass(qEl, 'preRequiredLayer_'+type);
                KD.utils.Util.addClass(qEl, 'preRequiredRemovedLayer');

                for (iIdx=0; iIdx<qEl.children.length; iIdx++) {
                    if (qEl.children[iIdx].id != undefined && qEl.children[iIdx].id.indexOf("QLABEL_")!=-1){
                        KD.utils.Util.removeClass(qEl.children[iIdx], 'preRequiredLabel');
                        KD.utils.Util.removeClass(qEl.children[iIdx], 'preRequiredLabel_'+type);
                        KD.utils.Util.addClass(qEl.children[iIdx], 'preRequiredRemovedLabel');
                        break;
                    }
                }

                for (iIdx=0; iIdx<qEl.children.length; iIdx++) {
                    if (qEl.children[iIdx].id != undefined && qEl.children[iIdx].id.indexOf("QANSWER_")!=-1){
                        KD.utils.Util.removeClass(qEl.children[iIdx], 'preRequiredAnswer');
                        KD.utils.Util.removeClass(qEl.children[iIdx], 'preRequiredAnswer_'+type);
                        KD.utils.Util.addClass(qEl.children[iIdx], 'preRequiredRemovedAnswer');
                        break;
                    }
                }

                var inputEl = dateInput ? dateInput : inputField;
                KD.utils.Util.removeClass(inputEl, 'preRequiredInput');
                KD.utils.Util.removeClass(inputEl, 'preRequiredInput_'+type);
                KD.utils.Util.addClass(inputEl, 'preRequiredRemovedInput');
            }
        };

        /**
         * Constructs the simple, modal login dialog to allow a user to reestablish
         * a session after a timeout without having to redirect to a login page
         * and lose all changes on the current form.
         * @method buildSimpleLogin
         * @private
         * @param {Object} options Options to define how the login dialog appears:
         *     showAuthStr: true|false (default false)
         *     showUserName: true|false (default false)
         * @return void
         */
        this.buildSimpleLogin = function (options){
            var showAuthStr = false;
            var showUserName = false;
            if (options) {
                if (options.showAuthStr && options.showAuthStr != "") {
                    showAuthStr = options.showAuthStr;
                }
                if (options.showUserName && options.showUserName != "") {
                    showUserName = options.showUserName;
                }
            }


            if (Dom.get('simpleLogin') === null) {
                // outer div to contain the form elements
                var outerdiv = document.createElement('div');
                outerdiv.id = "simpleLogin";
                outerdiv.className = " yui-skin-sam simpleLoginLayer";

                // heading
                var hd = document.createElement('div');
                hd.className = "hd";
                hd.innerHTML = "Your session has expired. Please login.";
                outerdiv.appendChild(hd);

                var bd = document.createElement('div');
                bd.className = "bd";
                outerdiv.appendChild(bd);

                // error message
                var msg = document.createElement('div');
                msg.id = "simpleLoginMsg";
                Dom.setStyle(msg, 'display', 'none');
                bd.appendChild(msg);

                // form
                var form = document.createElement('form');
                form.name = "Login";
                form.action = "KSAuthenticationServlet";
                form.method = "POST";
                bd.appendChild(form);

                // username label and input field
                var userdiv = document.createElement('div');
                userdiv.className = "UserLayer";
                var userLeftDiv = document.createElement('div');
                userLeftDiv.className = "leftCol";
                var userRightDiv = document.createElement('div');
                userRightDiv.className = "rightCol";
                var userlabel = document.createElement('label');
                userlabel.className = "simpleLoginLabel";
                userlabel.innerHTML = "Login ID";
                var userinput = document.createElement('input');
                userinput.id = "simpleLoginUser"
                userinput.name = "UserName";
                userinput.type = "text";
                userinput.className = "simpleLoginInput";
                userLeftDiv.appendChild(userlabel);
                userRightDiv.appendChild(userinput);
                userdiv.appendChild(userLeftDiv);
                userdiv.appendChild(userRightDiv);
                form.appendChild(userdiv);

                if (!showUserName && KD.utils.ClientManager.userName != null && KD.utils.ClientManager.userName.length > 0) {
                    // Preset and disable the user login name.
                    // We don't want to allow the user to enter another login name
                    userinput.value = KD.utils.ClientManager.userName;
                    userinput.setAttribute("readOnly", "readOnly");
                    userinput.style.backgroundColor=KD.utils.Action.readOnlyColor;
                }

                // password label and input field
                var passdiv = document.createElement('div');
                passdiv.className = "PasswordLayer";
                var passLeftDiv = document.createElement('div');
                passLeftDiv.className = "leftCol";
                var passRightDiv = document.createElement('div');
                passRightDiv.className = "rightCol";
                var passlabel = document.createElement('label');
                passlabel.className = "simpleLoginLabel";
                passlabel.innerHTML = "Password";
                var passinput = document.createElement('input');
                passinput.id = "simpleLoginPass"
                passinput.name = "Password";
                passinput.type = "password";
                passinput.className = "simplePassInput";
                passLeftDiv.appendChild(passlabel);
                passRightDiv.appendChild(passinput);
                passdiv.appendChild(passLeftDiv);
                passdiv.appendChild(passRightDiv);
                form.appendChild(passdiv);

                // authentication string label and input field
                if (showAuthStr) {
                    var authdiv = document.createElement('div');
                    var authlabel = document.createElement('label');
                    authlabel.className = "simpleLoginLabel";
                    authlabel.innerHTML = "Authentication";
                    var authinput = document.createElement('input');
                    authinput.id = "simpleLoginAuth"
                    authinput.name = "Authentication";
                    authinput.type = "text";
                    authinput.className = "simpleLoginInput";
                    authdiv.appendChild(authlabel);
                    authdiv.appendChild(authinput);
                    form.appendChild(authdiv);
                }
                // insert the form into the document body
                document.body.insertBefore(outerdiv, document.body.childNodes[0]);
            }
        };

        /**
         * Checks if the current session is still active.  Returns status code
         * 200 for a valid session, and 401 for a non-valid session.
         * @method checkSession
         * @param {Boolean} authenticate (optional) true to force an authentication
         * @return {Object} Callback object
         */
        this.checkSession = function (authenticate) {
            KD.utils.ClientManager.sessionCheck = null;
            var auth = authenticate === true ? '&auth=forced' : '';
            var tzMinutes = new Date().getTimezoneOffset();
            var sUrl = "resources/includes/sessionCheck.jsp?tzOffset="+tzMinutes+"&srv="+encodeURIComponent(KD.utils.ClientManager.templateId)+auth;
            var callback = {
                success: function (o) {
                    KD.utils.ClientManager.sessionCheck = o;
                },
                failure: function (o) {
                    KD.utils.ClientManager.sessionCheck = o;
                },
                argument: [{
                    timeout: 5000
                }]
            };
            KD.utils.Action._makeSyncRequest(sUrl, callback);
        };

        /**
         * Prevents backspace button triggering the browser Back page functionality
         * @method preventBackspace
         * @param {Event} e The event or object that triggered this function
         * @return void
         */
        this.preventBackSpace = function (e) {
            var evt, obj, roAtt, tag, type, readOnly = false;
            if (typeof window.event != 'undefined') { // IE
                evt = window.event;
            } else {
                evt = YAHOO.util.Event.getEvent(e);
            }

            // just return if the event couldn't be determined
            if (!evt) {
                return;
            }

            // check if the keypress was a backspace
            // only allow backspaces in text, password, and textarea fields that are
            // not readonly
            if (YAHOO.util.Event.getCharCode(evt) == 8) { // Backspace
                obj = YAHOO.util.Event.getTarget(evt);
                if (obj) {
                    roAtt = obj.getAttribute('readOnly');
                    if (roAtt && (roAtt == "readOnly" || roAtt == true)) {
                        readOnly = true;
                    }
                    tag = obj.tagName;
                    type = obj.type;
                    if (
                        !readOnly &&
                        (
                            (tag &&
                                // textarea
                                ((tag.toUpperCase() == "TEXTAREA") ||
                                // text or password
                                ((tag.toUpperCase() == "INPUT") &&
                                (type && (type.toUpperCase()=="TEXT" || type.toUpperCase()=="PASSWORD"))))
                            )
                        )
                    ) {
                        // allow the backspace because it is happening in a
                        // field that allows backspaces
                        return;
                    }
                }
                // prevent the backspace, because it was pressed outside of
                // a form field that allows backspaces
                YAHOO.util.Event.stopEvent(evt);
            }
        };

        /**
         * Prevents loading the page in an iFrame outside of the application's
         * domain.
         * @method enforceSameOriginFrame
         * @return void
         */
        this.enforceSameOriginFrame = function () {
            try {
                top.document.domain;
            } catch (e) {
                var f = function () {
                    document.body.innerHTML="";
                    document.head.innerHTML="";
                };
                setInterval(f,1);
                if (document.body) {
                    document.body.onload = f;
                }
            }
        };
    };
}

/**
 * The ClientAction class defines properties of all client-side actions
 * in Kinetic Request.
 * @namespace KD.utils
 * @class ClientAction
 * @constructor
 */
KD.utils.ClientAction = function (config) {
    /**
     * The id of the element this action is associated with
     * @property elementId
     * @type String
     */
    this.elementId = null;

    /**
     * The DOM element this action is associated with
     * @property elObj
     * @type HTMLElement
     */
    this.elObj = null;

    /**
     * The type of event that triggers this action
     * @property jsEvent
     * @type String
     */
    this.jsEvent = null;

    /**
     * The action that this event performs: Set Fields - External, Hide/Show, Custom, etc...
     * @property action
     * @type String
     */
    this.action = null;

    /**
     * The qualification used to determine if this action should run when
     * the event is triggered.
     * @property ifExpr
     * @type String
     */
    this.ifExpr = null;

    /**
     * The instanceId of the Simple Date Request record.
     * @property actionId
     * @type String
     */
    this.actionId = null;

    /**
     * Addional parameters to be passed to the Simple Data Request.
     * @property params
     * @type String
     */
    this.params = null;

    /**
     * The most recent event to act.
     * @property currEvt
     * @type Event
     */
    this.currEvt = null;

    /**
     * Determines whether this AJAX request should be made synchronously (blocking).
     * @property synchronous
     * @type String
     */
    this.synchronous = null;

    /**
     * Specifies the source to use for the client action.  "bridge"|"local"
     * (default "local").
     * @property source
     * @type String
     */
    this.source = null;

    /**
     * Determines if this request should trigger the "Get Entry" Remedy workflow.
     * @property useGetEntry
     * @type String
     */
    this.useGetEntry = null;

    /**
     * The timeout of the AJAX request in milliseconds.  If this amount of time
     * is exceeded, the request will terminate as a failed request, and trigger
     * the function defined in the callback's failure property.
     * @property timeout
     * @type Number
     */
    this.timeout = null;

    if (config) {
        this.elementId=config.elementId;
        this.jsEvent=config.jsEvent;
        this.action=config.action;
        this.ifExpr=config.ifExpr;
        this.actionId=config.actionId;
        this.params=config.params;
        this.elObj=KD.utils.Util.getQuestionInput(this.elementId);
        this.source = config.source || "local";
        this.synchronous=config.synchronous;
        this.useGetEntry=config.useGetEntry;
        this.timeout=config.timeout;
        if (!this.elObj) {
            var elId=KD.utils.Util.getPrefixFromType(KD.utils.ClientManager.getElementType(this.elementId))+this.elementId;
            this.elObj=Dom.get(elId);
        }
    }
};

/**
 * <p>
 * TODO: Document kd_bridges.js
 * </p>
 *
 * @module bridges
 * @requires yahoo, json
 */

// Ensure the namespaces have been created
if (typeof KD.bridges == "undefined") {KD.bridges = {}};

// If the KD.bridges.BridgeManager class has not been defined yet.
if (!KD.bridges.BridgeManager) {
    /**
     * A static class that exposes Kinetic bridging global configuration and
     * wraps functionality from external libraries (so that future changes are
     * abstracted from the core classes).
     *
     * @namespace KD.bridges
     * @class BridgeManager
     * @static
     */
    KD.bridges.BridgeManager = function() {}
    /**
     * TODO: Document KD.bridges.BridgeManager.bridgeRequest
     *
     * @method bridgeRequest
     * @return void
     * @param method
     * @param path
     * @param {Object} options
     */
    KD.bridges.BridgeManager.bridgeRequest = function(method, path, options) {
        // Validate that the YUI Connect library has been loaded
        if (typeof YAHOO === "undefined" ||
            typeof YAHOO.util === "undefined" ||
            typeof YAHOO.util.Connect === "undefined")
        {
            var message = "The YUI Connection library is required for "+
                "bridging.  Please ensure the YUI connection_core.js, "+
                "connection_core-min.js, connection.js, or connection-min.js "+
                "file is being loaded by the page.";
            alert(message);
            throw(message);
        }
        // Make the asynchronous request
        YAHOO.util.Connect.asyncRequest(method, path, options);
    }

    /**
     * TODO: Document KD.bridges.BridgeManager.defaultFailureCallback
     *
     * @method defaultFailureCallback
     * @parameter {Object} response
     */
    KD.bridges.BridgeManager.defaultFailureCallback = function(response) {
        // Declare the message
        var message = "There was a problem executing the bridge request.\n";
        // If it was an HTTP error
        if (response.status != 200) {
            // Append the HTTP error code information to the message
            message += "("+response.status+") "+response.statusText;
        }
        // If it was an API error
        else {
            // Append the API error response to the message
            message += "\n"+response.responseMessage;
        }
        // Alert the message and re-throw it
        alert(message);
        throw(message);
    }

    /**
     * TODO: Document KD.bridges.BridgeManager.parseJson
     *
     * @method parseJson
     * @return {Object}
     */
    KD.bridges.BridgeManager.parseJson = function(string) {
        // Validate that the YUI JSON library has been loaded
        if (typeof YAHOO === "undefined" ||
            typeof YAHOO.lang === "undefined" ||
            typeof YAHOO.lang.JSON === "undefined")
        {
            var message = "The YUI JSON library is required for bridging.  "+
                "Please ensure the YUI json.js or json-min.js file is being "+
                "loaded by the page.";
            alert(message);
            throw(message);
        }
        // Return the json object
        return YAHOO.lang.JSON.parse(string);
    }
    /**
     * TODO: Document KD.bridges.BridgeManager.stringify
     *
     * @method stringify
     * @return {String}
     */
    KD.bridges.BridgeManager.stringify = function(object) {
        // Validate that the YUI JSON library has been loaded
        if (typeof YAHOO === "undefined" ||
            typeof YAHOO.lang === "undefined" ||
            typeof YAHOO.lang.JSON === "undefined")
        {
            var message = "The YUI JSON library is required for bridging.  "+
                "Please ensure the YUI json.js or json-min.js file is being "+
                "loaded by the page.";
            alert(message);
            throw(message);
        }
        // Return the json object
        return YAHOO.lang.JSON.stringify(object);
    }

    KD.bridges.BridgeManager.keys = Object.keys || function(obj) {
        if (obj !== Object(obj)) throw new TypeError('Invalid object');
        var keys = [];
        for (var key in obj) if (Object.prototype.hasOwnProperty.call(obj, key)) keys[keys.length] = key;
        return keys;
    }
}

if (!KD.bridges.BridgeConnector) {
    /**
     * <p>
     * TODO: Document KD.bridges.BridgeConnector
     * </p>
     *
     * TODO: Explaination
     * <br/>
     * <code>
     * var connector = new KD.bridges.BridgeConnector();
     * </code>
     *
     * <br/>
     * TODO: Explaination
     * <br/>
     * <code>
     * var connector = new KD.bridges.BridgeConnector({
     *   templateId: "KS0a4f032ec51ba30eea41b8425b21df8e4",
     *   webAppRoot: "/kinetic/"
     * });
     * </code>
     * 
     * <br/>
     * TODO: Explaination
     * <br/>
     * <code>
     * var connector = new KD.bridges.BridgeConnector({
     *   catalogName: "ACME3",
     *   tempateName: "iPad Request",
     *   webAppRoot: "/kinetic/"
     * });
     * </code>
     *
     * @namespace KD.bridges
     * @class BridgeConnector
     * @constructor
     * @param {Object} properties
     */
    KD.bridges.BridgeConnector = function (properties) {
        // Create a private reference to the public object
        var self = this;

        // Default the config parameter if it wasn't provided
        properties = properties || {};

        // Default the properties if they were not defined
        if (properties.templateId == undefined || properties.webAppRoot == undefined) {
            if (typeof KD == "undefined" ||
                typeof KD.utils == "undefined" ||
                typeof KD.utils.ClientManager == "undefined"
            ) {
                throw new Error("KD.utils.ClientManager does not exist, "+
                    "unable to automatically obtain configuration values.");
            } else {
                // If the template id was not specified, default it to the
                // ClientManager value.
                if (properties.templateId == undefined && 
                    (properties.catalogName == undefined && properties.templateName == undefined)
                ) {
                    properties.templateId = KD.utils.ClientManager.templateId;
                }
                // If the web app root was not specified, default it to the
                // ClientManager value.
                if (properties.webAppRoot == undefined) {
                    properties.webAppRoot = KD.utils.ClientManager.webAppContextPath;
                }
            }
        }

        /**
         * TODO: Document KD.bridges.BridgeConnector.templateId
         *
         * @property templateId
         * @type String
         * @default <code>KD.utils.ClientManager.templateId</code>
         */
        this.templateId = properties['templateId'];
        
        /**
         * TODO: Document KD.bridges.BridgeConnector.catalogName
         *
         * @property catalogName
         * @type String
         */
        this.catalogName = properties['catalogName'];
        
        /**
         * TODO: Document KD.bridges.BridgeConnector.templateName
         *
         * @property catalogName
         * @type String
         */
        this.templateName = properties['templateName'];
        
        
        /**
         * TODO: Document KD.bridges.BridgeConnector.webAppRoot
         *
         * @property webAppRoot
         * @type String
         */
        this.webAppRoot = properties['webAppRoot'];
        // Ensure that the web app root includes a trailing slash
        if (this.webAppRoot.charAt(this.webAppRoot.length-1) != "/") {
            this.webAppRoot = this.webAppRoot + "/";
        }

        /**
         * TODO: Document KD.bridges.BridgeConnector.count
         *
         * @method count
         * @param {String} model DESCRIPTION.
         * @param {String} qualification DESCRIPTION.
         * @param {Object} config DESCRIPTION.
         */
        this.count = function(model, qualification, config) {
            // Validate the request
            validateRequest(model, qualification, config);
            // Build the request path
            var path = generateRequestPath('count', model, qualification, config);
            // Build the request options
            var options = generateBridgeRequestOptions(config, function(data) {
                return new KD.bridges.Count(data.value, data.metadata);
            });
            // Make the bridge request
            KD.bridges.BridgeManager.bridgeRequest('GET', path, options);
        }

        /**
         * TODO: Document KD.bridges.BridgeConnector.retrieve
         *
         * @method retrieve
         * @param {String} model DESCRIPTION.
         * @param {String} qualification DESCRIPTION.
         * @param {Object} config DESCRIPTION.
         */
        this.retrieve = function(model, qualification, config) {
            // Validate the request
            validateRequest(model, qualification, config);
            // Build the request path
            var path = generateRequestPath('retrieve', model, qualification, config);
            // Build the request options
            var options = generateBridgeRequestOptions(config, function(data) {
                return new KD.bridges.Record(data.attributes, data.metadata);
            });
            // Make the bridge request
            KD.bridges.BridgeManager.bridgeRequest('GET', path, options);
        }

        /**
         * TODO: Document KD.bridges.BridgeConnector.search
         *
         * @method search
         * @param {String} model DESCRIPTION.
         * @param {String} qualification DESCRIPTION.
         * @param {Object} config DESCRIPTION.
         */
        this.search = function(model, qualification, config) {
            // Validate the request
            validateRequest(model, qualification, config);
            // Build the request path
            var path = generateRequestPath('search', model, qualification, config);
            // Build the request options
            var options = generateBridgeRequestOptions(config, function(data) {
                return new KD.bridges.RecordList(data.fields, data.records, data.metadata);
            });
            // Make the bridge request
            KD.bridges.BridgeManager.bridgeRequest('GET', path, options);
        }

        /**
         * @method buildMapParameters
         * @private
         */
        var buildMapParameters = function(mapName, map) {
            var results = "";
            for(var name in (map || {})) {
                results += "&"+mapName+"[\""+name+"\"]="+map[name];
            }
            return results;
        }

        /**
         * @method generateBridgeRequestOptions
         * @private
         */
        var generateBridgeRequestOptions = function(config, handler) {
            return {
                // If an HTTP 200 status was returned
                success: function(response) {
                    // Log the response
                    if (config["debug"] && typeof console !== 'undefined') {console.log("RESPONSE: "+response.responseText);}

                    // Parse the response text
                    var object = KD.bridges.BridgeManager.parseJson(response.responseText)
                    // If the API request was made successfully
                    if (object.responseCode == 200) {
                        // Build the results object
                        var result = handler(object.data);
                        // Call success handler
                        config["success"](result);
                    }
                    // If the API request was not made successfully
                    else {
                        // Add the response information to the reulting object
                        response.responseCode = object.responseCode;
                        response.responseMessage = object.responseMessage;
                        // Call failure handler
                        config["failure"](response);
                    }
                },
                // If an HTTP status code other than 200 was returned
                failure: function(response) {
                    // Log the response
                    if (config["debug"] && typeof console !== 'undefined') {console.log("RESPONSE: "+response.responseText);}

                    // Call failure handler
                    config["failure"](response)
                }
            }
        }

        /**
         * @method generateRequestPath
         * @private
         */
        var generateRequestPath = function(action, model, qualification, config) {
            // Build the base path
            var path;
            if (self.catalogName !== undefined && self.templateName !== undefined) {
                path = self.webAppRoot+
                    "BridgeDataRequest"+
                    "?action="+action+
                    "&catalogName="+self.catalogName+
                    "&formName="+self.templateName+
                    "&model="+model+
                    "&qualification="+qualification;
            } else {
                path = self.webAppRoot+
                    "BridgeDataRequest"+
                    "?action="+action+
                    "&formId="+self.templateId+
                    "&model="+model+
                    "&qualification="+qualification;
            }
            // If attributes were specified, build the attributes parameter
            if (config["attributes"] != null) {
                path += "&attributes="+config["attributes"].join(",");
            }
            // Append the parameters parameter
            path += buildMapParameters("parameter", config["parameters"]);
            // Append the metadata parameter
            path += buildMapParameters("metadata", config["metadata"]);
            // Append a date time stamp to avoid caching
            path += "&noCache="+new Date().getTime();
            // Return the path
            return path;
        }

        /**
         * @method validateRequest
         * @private
         */
        var validateRequest = function(model, qualification, config) {
            // Default the config object
            config = config || {};
            // Default the configuration parameters
            config["failure"] = config["failure"] || KD.bridges.BridgeManager.defaultFailureCallback;

            // Validate the parameters
            if (!(typeof model == "string")) {
                throw new TypeError("The 'model' parameter must be a valid string.");
            } else if (!(typeof qualification == "string")) {
                throw new TypeError("The 'qualification' parameter must be a valid string.");
            }
            // Validate configuration values
            if (!(typeof config["success"] == "function")) {
                throw new TypeError("The 'success' config value must be a valid function.");
            }
        }
    }
}

if (!KD.bridges.Count) {
    /**
     * TODO: Document KD.bridges.Count
     *
     * @namespace KD.bridges
     * @class Count
     * @constructor
     * @param value {number}
     * @param metadata {Object}
     */
    KD.bridges.Count = function (value, metadata) {
        /**
         * TODO: Document KD.bridges.Count#value
         *
         * @property value
         * @default null
         */
        if (value == 0) {this.value = 0;}
        else {this.value = value || null;}
        /**
         * TODO: Document KD.bridges.Count#metadata
         *
         * @property metadata
         * @default {}
         */
        this.metadata = metadata || {};

        /**
         * TODO: Document KD.bridges.Count#toJson
         *
         * @method toJson
         * @return {string}
         */
        this.toJson = function() {
            return KD.bridges.BridgeManager.stringify(this.toObject());
        }

        /**
         * TODO: Document KD.bridges.Count#toObject
         *
         * @method toObject
         * @return {Object}
         */
        this.toObject = function() {
            var obj = {value: this.value};
            if (KD.bridges.BridgeManager.keys(this.metadata).length > 0) {
                obj.metadata = this.metadata;
            }
            return obj;
        }

        /**
         * TODO: Document KD.bridges.Count#toString
         *
         * @method toString
         * @return {string}
         */
        this.toString = function() {
            return "[object KD.bridges.Count]";
        }
    }
}

if (!KD.bridges.Record) {
    /**
     * TODO: Document KD.bridges.Record
     *
     * @namespace KD.bridges
     * @class Record
     * @constructor
     * @param attributes {Object}
     * @param metadata {Object}
     */
    KD.bridges.Record = function (attributes, metadata) {
        /**
         * TODO: Document KD.bridges.Record#attributes
         *
         * @property attributes
         * @default null
         */
        this.attributes = attributes || null;
        /**
         * TODO: Document KD.bridges.Record#metadata
         *
         * @property metadata
         * @default {}
         */
        this.metadata = metadata || {};

        /**
         * TODO: Document KD.bridges.Record#exists
         *
         * @method exists
         * @return {boolean}
         */
        this.exists = function() {
            return (this.attributes) ? true : false;
        }

        /**
         * TODO: Document KD.bridges.Record#toJson
         *
         * @method toJson
         * @return {string}
         */
        this.toJson = function() {
            return KD.bridges.BridgeManager.stringify(this.toObject());
        }

        /**
         * TODO: Document KD.bridges.Record#toObject
         *
         * @method toObject
         * @return {Object}
         */
        this.toObject = function() {
            var obj = {attributes: this.attributes};
            if (KD.bridges.BridgeManager.keys(this.metadata).length > 0) {
                obj.metadata = this.metadata;
            }
            return obj;
        }

        /**
         * TODO: Document KD.bridges.Record#toString
         *
         * @method toString
         * @return {string}
         */
        this.toString = function() {
            return "[object KD.bridges.Record]";
        }
    }
}

if (!KD.bridges.RecordList) {
    /**
     * TODO: Document KD.bridges.RecordList
     *
     * @namespace KD.bridges
     * @class RecordList
     * @constructor
     * @param fields {Array}
     * @param records {Object}
     * @param metadata {Object}
     */
    KD.bridges.RecordList = function (fields, records, metadata) {
        /**
         * TODO: Document KD.bridges.RecordList#records
         *
         * @property fields
         * @property records
         * @default []
         */
        this.fields = fields;
        this.records = [];
        if (records) {
            for (var i=0;i<records.length;i++) {
                if (typeof records[i] == "KD.bridges.Record") {
                    this.records.push(records[i]);
                } else if (typeof records[i] == "object") {
                    var attributes = {};
                    for (var fieldIndex=0;fieldIndex<fields.length;fieldIndex++) {
                        attributes[fields[fieldIndex]] = records[i][fieldIndex];
                    }
                    this.records.push(new KD.bridges.Record(attributes));
                }
            }
        }
        /**
         * TODO: Document KD.bridges.RecordList#metadata
         *
         * @property metadata
         * @default {}
         */
        this.metadata = metadata || {};

        /**
         * TODO: Document KD.bridges.RecordList#first
         *
         * @method first
         * @return {KD.bridges.Record}
         */
        this.first = function() {
            return this.records[0] || null;
        }

        /**
         * TODO: Document KD.bridges.RecordList#get
         *
         * @method get
         * @param index {number}
         * @return {KD.bridges.Record}
         */
        this.get = function(index) {
            return this.records[index] || null;
        }

        /**
         * TODO: Document KD.bridges.RecordList#last
         *
         * @method last
         * @return {KD.bridges.Record}
         */
        this.last = function() {
            return this.records[this.records.length-1] || null;
        }

        /**
         * TODO: Document KD.bridges.RecordList#toJson
         *
         * @method toJson
         * @return {string}
         */
        this.toJson = function() {
            return KD.bridges.BridgeManager.stringify(this.toObject());
        }

        /**
         * TODO: Document KD.bridges.RecordList#toObject
         *
         * @method toObject
         * @return {Object}
         */
        this.toObject = function() {
            // Build the metadata
            var obj = {
                fields: this.fields,
                records: []
            };
            for (var i=0;i<this.records.length;i++) {
                var record = this.records[i].toObject();
                var values = [];
                for (var fieldIndex=0;fieldIndex<this.fields.length;fieldIndex++) {
                    values.push(record.attributes[this.fields[fieldIndex]]);
                }
                obj.records.push(values);
            }
            if (KD.bridges.BridgeManager.keys(this.metadata).length > 0) {
                obj.metadata = this.metadata;
            }
            return obj;
        }

        /**
         * TODO: Document KD.bridges.RecordList#toString
         *
         * @method toString
         * @return {string}
         */
        this.toString = function() {
            return "[object KD.bridges.RecordList]";
        }
    }
}