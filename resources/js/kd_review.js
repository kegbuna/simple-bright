/*
Copyright (c) 2012, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/

/**
 * <p>
 * Provides extended functionality to Kinetic Survey and Kinetic Request by
 * providing the ability to review a request or survey in its entirety before
 * submitting the form.
 * </p>
 * <p>
 * The review servlet allows the user to customize how the review is displayed by
 * allowing the user to specify the JSP that renders the request, and whether it
 * should display all pages of the original request stacked one after another, or
 * as indvidual page tabs.
 * </p>
 * <p>
 * The review servlet can be used by itself as the main display page, or it can
 * be embedded in another service item and displayed within an iFrame element.
 * </p>
 *
 * @module review
 */

(function () {
    // internal shorthand
    var K = KD.utils,
        Dom = YAHOO.util.Dom,
        Connect = YAHOO.util.Connect;

    /**
     * <p>
     * The review request allows submitted requests to be loaded and displayed
     * for read-only viewing.  Requests can be displayed in a page all by themselves,
     * or from within another service item or page using an iFrame element that
     * calls the review servlet.
     * </p>
     * <p>
     * If the request has multiple pages, each page will be displayed separately
     * in its own tab unless instructed otherwise.
     * </p>
     *
     * @namespace KD.utils
     * @class Review
     * @static
     */
    K.Review = {

        /**
         * Node ID of the currently displayed page tab.  Is of the form:
         * pageHolder_PAGEINSTANCEID
         * @property currentDisplayedPageID
         * @type String
         * @private
         * @default ""
         */
        currentDisplayedPageID : "",

        /**
         * Partial ID of the clicked page tab.  On page load, will be the partial
         * ID of the first page tab.  If of the same form as currentDisplayedPageID,
         * but without the pageHolder_ prefix.
         * @property currentPageID
         * @type String
         * @private
         * @default ""
         */
        currentPageID : "",

        /**
         * HTMLElement of the currently displayed page tab.
         * @property currPageObj
         * @type HTMLElement
         * @private
         * @default null
         */
        currPageObj : null,

        /**
         * HTMLElement of the request page
         * @property pageDocument
         * @type HTMLElement
         * @private
         * @default null
         */
        pageDocument : null,

        /**
         * Indicates the height of the largest page tab.  Used when all the
         * pages should be rendered with the same height.
         * @property largestHeight
         * @type Int
         * @private
         * @default 0
         */
        largestHeight : 0,


        /**
         * Initializes the review request by first initializing KD.utils.ClientManager,
         * then running the javascript for the first review page, then setting
         * all input fields to readonly and finally setting the page tab height.
         * @method init
         * @param {Event} evt The event that triggered this method.
         */
        init : function (evt) {
            clientManager.init();

            if (this.reviewObj && this.reviewObj.loadAllPages == true) {
                // run the events for all the pages, and then resize the full height
                if (this.reviewObj.pageIds) {
                    var pageIds = this.reviewObj.pageIds;
                    for (var i = 0; i < pageIds.length; i += 1) {
                        try {
                            eval('(' + pageIds[i] + '_ks_actionsInit()' + ')');
                        } catch (e) {
                            /* wasn't able to run the javascript functions for the page */
                        }
                    }
                }
                K.Review.setToReadOnly(Dom.get('reviewContent'));
                K.Review.setFullHeight();
            } else {
                // just run the events for one page, and then resize the height to that page
                try {
                    K.Review.currentPageID = K.Review.setCurrentPageID(K.Review.currentDisplayedPageID);
                    eval('(' + K.Review.currentPageID + '_ks_actionsInit()' + ')');
                } catch (ex) {
                /* wasn't able to run the javascript functions for the page */
                }
                K.Review.setToReadOnly(K.Review.currentDisplayedPageID);
                K.Review.setHeight();
            }
        },

        /**
         * Sets all question inputs on the page to read-only.
         * @method setToReadOnly
         * @param {HTMLElement | String} root Parent node to start setting form answers
         * to read-only.  Accepts either the node element or id of the node.
         */
        setToReadOnly : function (root) {
            var objs = K.Util.getElementsByClassName("questionAnswer", "*", root),
                i,
                label;

            for (i = 0; i < objs.length; i += 1) {
                label = objs[i].getAttribute("label");
                K.Action.setReadOnly(label);
            }
        },

        /**
         * Resize the page tab height after the iFrame finishes rendering the
         * page contents.
         * @method setHeight
         * @param {Boolean} allSameSize Set true to render all pages the same height.
         */
        setHeight : function (allSameSize) {
            var iFrameObj = parent.document.getElementById('reviewRequest'),
                offset,
                navBar = document.getElementById('globalnav');
            if ( navBar != null ) {
                offset = navBar.clientHeight;
            } else {
                offset = 0;
            }

            if (!K.Review.currPageObj) {
                K.Review.currPageObj = Dom.get(K.Review.currentDisplayedPageID);
            }
            if (K.Review.currPageObj && K.Review.currPageObj.clientHeight > K.Review.largestHeight) {
                K.Review.largestHeight = K.Review.currPageObj.clientHeight;
            }
            if (iFrameObj) {
                iFrameObj.style.height = allSameSize === true ?
                /* keep all page tabs the same height */
                K.Review.largestHeight + offset + 'px' :
                /* each page tab will resize to its own height */
                K.Review.currPageObj.clientHeight + offset + 'px';
            }
        },

        /**
         * Resize the reviewRequest div to the height of all the pages combined
         * since all pages are being displayed at once.
         * @method setFullHeight
         */
        setFullHeight: function () {
            var iFrameObj = parent.document.getElementById("reviewRequest"),
                offset = 20,
                cHeight;

            // check if calling ReviewRequest from an IFrame
            if (iFrameObj) {
                if (iFrameObj.document) { /*IE*/
                    var o = document.getElementById("reviewContent");
                    cHeight = o.offsetHeight;
                } else {
                    cHeight = iFrameObj.contentDocument.body.clientHeight;
                }
                iFrameObj.style.height = cHeight + offset + "px";
            }
        },

        /**
         * Gets the content for a survey/request page, then calls the appropriate
         * callback method to display the information.
         * @method showPage
         * @param {HTMLElement} el The page tab li element that called this method.
         * @param {String} pageID The sanitized id of the page to fetch.
         * @param {String} instanceID The instance ID part of the pageID
         */
        showPage : function (el, pageID, instanceID) {
            var myContext = "/kinetic",
                objs = K.Util.getElementsByClassName("selectedTab", "a", document),
                pageObj, path, callback, response, message, valid = true;

            // clear all page tabs, and then set the clicked page tab
            if (objs.length > 0) {
                objs[0].className = "";
            }
            el.className = "selectedTab";

            // set the web application context (default is "/kinetic")
            if (K.ClientManager.webAppContextPath) {
                myContext = K.ClientManager.webAppContextPath;
            }

            // hide the currently displayed page
            K.Review.currPageObj = Dom.get(K.Review.currentDisplayedPageID);
            K.Review.currPageObj.style.display = "none";

            // get the contents for the clicked page, and show it
            K.Review.currentPageID = K.Review.setCurrentPageID(pageID);
            pageObj = Dom.get(pageID);
            pageObj.style.display = "block";

            // keep track of the new displayed page
            K.Review.currentDisplayedPageID = pageID;
            K.Review.currPageObj = pageObj;

            // Check to see if the page's content has already been loaded.
            // This is done by iterating through the page element's children looking for an
            // element with the class "templateContent".  If that element exists, the content
            // has already been loaded.
            //
            var loaded = false;
            var pageChildren = Dom.getChildren(pageObj);
            for (var i in pageChildren) {
                if (Dom.hasClass(pageChildren[i], "templateContent")) {
                    loaded = true;
                    break;
                }
            }

            // if the page hasn't been loaded yet, fetch the contents
            if (!loaded) {
                // build up the ajax path
                path = myContext +
                    '/ReviewRequestPage?csrv=' + encodeURIComponent(clientManager.customerSurveyId) +
                    '&pageInstanceID=' + encodeURIComponent(instanceID);

                // build up the callback object
                callback = {
                    success: K.Review.handlePageSuccess,
                    failure: K.Review.handlePageFailure,
                    argument: { clickedPageId: pageID }
                };

                // if authentication is required, check if session is still valid
                if (KD.utils.ClientManager.isAuthenticationRequired === "true") {
                    KD.utils.ClientManager.checkSession();
                    response = KD.utils.ClientManager.sessionCheck;
                    if (response.status !== 200) {
                        message = response.statusText;
                        if (response.getResponseHeader != null && response.getResponseHeader['X-Error-Message'] != null){
                            message = response.getResponseHeader['X-Error-Message'];
                        }
                        // register the request
                        KD.utils.ClientManager.registerInvalidSessionRequest(
                            'REVIEW_REQUEST_' + pageID, 'GET', path, callback);
                        KD.utils.Action.handleHttpErrorCode(response.status, message);
                        valid = false;
                    }
                }
                if (valid) {
                    K.ClientManager.isLoading=false;
                    // send the ajax request along with the callback object
                    Connect.asyncRequest('GET', path, callback);
                }
            } else {
                // page has already been fetched, just set the height
                K.Review.setHeight();
            }
        },

        /**
         * Callback handler when Ajax request succeeds.  Replaces the innerHTML
         * of the page tab with the rendered page.
         * @method handlePageSuccess
         * @param {Object} o YUI Connection Manager response object returned
         * from the Ajax request.
         */
        handlePageSuccess : function (o) {
            var clickedPageId, clickedPageObj, pageId, pageDocument;

            clickedPageId = o.argument['clickedPageId'];
            if (clickedPageId) {
                clickedPageObj = Dom.get(clickedPageId);
            }
            if (clickedPageObj && o.responseText !== undefined) {
                // display the page results
                clickedPageObj.innerHTML = o.responseText;

                // register this page in the Client Manager
                pageId = K.Review.setCurrentPageID(clickedPageId);

                // initialize
                clientManager.init();

                // run the javascript events for the page
                eval('(' + pageId + '_ks_actionsInit()' + ')');

                // set all input fields to readonly and set the page height
                K.Review.setToReadOnly(clickedPageObj);
                K.Review.setHeight();
            }
        },

        /**
         * Callback handler when Ajax request fails or times out.  Replaces the
         * innerHTML of the page tab with the rendered page.
         * @method handlePageFailure
         * @param {Object} o YUI Connection Manager response object returned
         * from the Ajax request.
         */
        handlePageFailure : function (o) {
            var clickedPageId, clickedPageObj;

            clickedPageId = K.Review.currentDisplayedPageID;
            if (clickedPageId) {
                clickedPageObj = Dom.get(clickedPageId);
            }
            if (clickedPageObj && o.responseText !== undefined) {
                clickedPageObj.innerHTML = "<li>Transaction id: " + o.tId + "</li>";
                clickedPageObj.innerHTML += "<li>HTTP status: " + o.status + "</li>";
                clickedPageObj.innerHTML += "<li>Status code message: " + o.statusText + "</li>";
                K.Review.setHeight();
            }
            K.ClientManager.isLoading=false;
        },


        /**
         * Strips the prefix from the pageInstanceID value.
         * @private
         * @method setCurrentPageID
         * @param {String} pageId The instance id of the page element
         * @return {String} The page instance id with the "pageHolder_" prefix
         * removed.
         */
        setCurrentPageID : function (pageId) {
            var id = '';
            if (pageId && pageId.length > 0) {
                id = pageId.slice("pageHolder_".length);
            }
            return id;
        }
    };

})();
