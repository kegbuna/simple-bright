/*
Copyright (c) 2012, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/

/**
 * Provides funtionality for Catalog Portal or Launcher pages.
 * @module catalog
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

if (!KD.utils.CatalogUtils) {

    /**
     * Methods used for managing a launcher (portal) page in Kinetic Request.
     * @namespace KD.utils
     * @class CatalogUtils
     * @static
     */
    KD.utils.CatalogUtils = new function () {
        /**
         * @property showingApprovals
         * @type Boolean
         * @default false
         * @private
         */
        this.showingApprovals=false;

        /**
         * @property showingOpenItems
         * @type Boolean
         * @default false
         * @private
         */
        this.showingOpenItems=false;

        /**
         * @property currentSummaryEl
         * @type HTMLElement
         * @private
         */
        this.currentSummaryEl = null;

        /**
         * @property categoryItemsHTML
         * @type HTMLElement
         * @private
         */
        this.categoryItemsHTML = null;

        /**
         * @property selectedRequests
         * @type Object
         * @private
         */
        this.selectedRequests={};


        /**
         * A simple data request that returns a list of all category items for a
         * specified category.
         * @method getAllCategoryItems
         * @param {String} category The instanceId of the category
         * @param {String} partial (optional) Name of the partial to render the results in
         * @return void
         */
        this.getAllCategoryItems = function (category, partial) {
            var serviceItems = Dom.get('serviceItems'), //Retrieve the custom event to get the SDR Id
            dynTextLayer = serviceItems.parentNode,
            instanceId = KD.utils.Util.getIDPart(dynTextLayer.id),
            myPartial = 'allCategoryItems';

            if (partial && partial.length > 0) {
                myPartial=partial;
            }
            if (instanceId) {
                // Save current serviceItems HTML
                this.categoryItemsHTML = serviceItems.innerHTML;
                var clientAction = KD.utils.ClientManager.customEvents.getItem(instanceId)[0];//Should only have one action
                // TODO:  NEED A CUSTOM EVENT FOR THIS TO WORK WITH ACTIONS OTHER THAN _custom
                // clientAction.action.call(KD.utils.Action, null, clientAction);
                var connection = new KD.utils.Callback(KD.utils.Action._addInnerHTML,KD.utils.Action._addInnerHTML,['serviceItems']);
                KD.utils.Action.makeAsyncRequest('allItemsForCategory', clientAction.actionId, connection, 'category='+category, myPartial);
            } else {
                alert("No instance Id found");
            }
        };

        /**
         * A simple data request that returns all submitted requests for a user.
         * @method getAllMyRequests
         * @param {String} actionId (optional) Not used
         * @param {String} paramString (optional) An optional string of additional
         * parameters to be passed to the simple data request.
         * @param {String} partial (optional) Name of the partial to render the results in
         * @return void
         */
        this.getAllMyRequests = function (actionId, paramString, partial) {
            var catUtils = KD.utils.CatalogUtils,
            myPartial = 'allMyRequests';

            if (partial && partial.length > 0) {
                myPartial = partial;
            }
            catUtils.showSelectedRequests(catUtils.showingOpenItems, catUtils.showingApprovals, catUtils.currentSummaryEl, myPartial, paramString);
        };

        /**
         * A simple data request to retrieve submitted user requests that fall in a
         * specific classification: Open, Closed, Awaiting Approval, Approved
         *
         * @method showSelectedRequests
         * @param {Boolean} isOpen Query parameter value for the 'Request Status' field
         * @param {Boolean} isApproval Query parameter value for the 'Submit Type' field
         * @param {HTMLElement} clickedEl Element that was clicked to execute to this method
         * @param {String} partial (optional) Name of the partial to render the results in
         * @param {String} paramString (optional) An optional string of additional
         * parameters to be passed to the simple data request.
         * @return void
         */
        this.showSelectedRequests = function (isOpen, isApproval, clickedEl, partial, paramString) {
            var options = {
                isOpen: isOpen,
                isApproval: isApproval,
                isActionPending: false,
                clickedEl: clickedEl,
                partial: partial,
                paramString: paramString
            };

            KD.utils.CatalogUtils._showSelectedRequests(options);
        }

        this._showSelectedRequests = function (options) {
            var isOpen, isApproval, isActionPending, clickedEl, partial, paramString;
            isOpen = options.isOpen || false;
            isApproval = options.isApproval || false;
            isActionPending = options.isActionPending || false;
            clickedEl = options.clickedEl;
            partial = options.partial;
            paramString = options.paramString;

            // Retrieve the custom event to get the SDR Id
            var submitType = 'Request',
                actionPending = "Not Pending",
                currentStyle = clickedEl.className,
                myPartial = 'requestsWithTasks',
                status = 'Open',
                myRequests = Dom.get('selectedServiceItems'),
                dynTextLayer = myRequests.parentNode,
                instanceId = KD.utils.Util.getIDPart(dynTextLayer.id),
                clientAction = null,
                connection = null,
                tempClass = "",
                params = "";

            if (isApproval) {
                submitType = "Approval";
            }
            if (isActionPending) {
                actionPending = "Pending";
            }
            if (partial && partial.length > 0) {
                myPartial = partial;
            }
            if (!isOpen) {
                status = "Closed";
            }
            if (paramString && paramString.length > 0) {
                if (paramString.indexOf("?") === 0) {
                    paramString = paramString.slice(1);
                }
                if (paramString.indexOf("&") !== 0) {
                    paramString = '&' + paramString;
                }
                params = paramString || "";
            }
            if (instanceId) {
                clientAction = KD.utils.ClientManager.customEvents.getItem(instanceId)[0];//Should only have one custom event
                connection = new KD.utils.Callback(KD.utils.Action._addInnerHTML,KD.utils.Action._addInnerHTML,['selectedServiceItems'], true);
                KD.utils.Action.makeAsyncRequest(myPartial, clientAction.actionId, connection, 'status='+status+'&submitType='+submitType+'&actionPending='+actionPending+params, myPartial);
                KD.utils.CatalogUtils.resetActiveClass(clickedEl.parentNode.parentNode);
                tempClass = currentStyle.split("_active")[0];//grab beginning in case its already active
                clickedEl.className = tempClass + "_active";
            } else {
                alert("No instance Id found");
            }
            KD.utils.CatalogUtils.showingApprovals = isApproval;
            KD.utils.CatalogUtils.showingOpenItems = isOpen;
            KD.utils.CatalogUtils.currentSummaryEl = clickedEl;
        };

        /**
         * Retrieves and displays the details of a submitted request along with
         * all the task details for that request.
         * @method showSelectedRequest
         * @param {HTMLElement} clickedEl Element that was clicked to execute to this method
         * @param {String} rqtId InstanceId of the submitted request to display
         * @param {String} partial (optional) Name of the partial to render the results in
         * @param {String} paramString (optional) An optional string of additional
         * parameters to be passed to the simple data request.
         * @return void
         */
        this.showSelectedRequest = function (clickedEl, rqtId, partial, paramString) {
            //Retrieve the custom event to get the SDR Id
            var myPartial = 'selectedRequest',
            selReqId = 'selectedRequestOrig',
            selReqText,
            dynTextLayer,
            sdrId,
            clientAction = null,
            connection = null,
            paramStr = "",
            params;

            if (partial && partial.length > 0) {
                myPartial = partial;
            }

            if (paramString && paramString.length > 0) {
                if (paramString.indexOf("?") === 0) {
                    paramString = paramString.slice(1);
                }
                if (paramString.indexOf("&") !== 0) {
                    paramString = '&' + paramString;
                }
                paramStr = paramString || "";

                // determine which task engine this service item uses:
                // if paramUseKineticTask == true then use Kinetic Task Engine
                // if paramUseKineticTask != true then use old Task Record Creator
                params = paramStr.split("&");
                for (var i=0; i<params.length; i+=1) {
                    var param = params[i].split("=");
                    if (param && param[0] === "paramUseKineticTask") {
                        if (param[1] && param[1] === "true") {
                            selReqId = 'selectedRequest';
                        }
                        break;
                    }
                }
            }

            selReqText = Dom.get(selReqId);
            if (selReqText) {
                dynTextLayer = selReqText.parentNode;
                sdrId = KD.utils.Util.getIDPart(dynTextLayer.id);

                // build up the panel to display the requested service item
                this._buildPanel(rqtId, selReqText);

                // get the service item data from the server, and update the panel body
                if (sdrId) {
                    clientAction = KD.utils.ClientManager.customEvents.getItem(sdrId)[0];//Should only have one custom event
                    connection = new KD.utils.Callback(KD.utils.Action._addInnerHTML,KD.utils.Action._addInnerHTML,['panel_body_'+rqtId], true);
                    KD.utils.Action.makeAsyncRequest(myPartial, clientAction.actionId, connection, paramStr, myPartial);
                } else {
                    alert("No record found");
                }
                KD.utils.CatalogUtils.currentSummaryEl = clickedEl;
            }
        };

        /**
         * Opens a new panel window to display the selected request details in
         * @method _buildPanel
         * @private
         * @param {String} id InstanceId of the submitted request to display
         * @param {String} elId The id of the element to display the panel in.
         * Essentially sets the innerHTML property of this element to the panel.
         * @return void
         */
        this._buildPanel = function(id, elId) {
            var oPanel, panelCfg, panelBody;

            oPanel = this.selectedRequests["panel_" + id];
            if (oPanel == null) {
                panelCfg = {
                    width:"860px",
                    x:30,
                    y:30,
                    zIndex:10000,
                    visible:false,
                    draggable:true,
                    close:true,
                    /*modal:true,*/
                    /*constraintoviewport:true,*/
                    underlay:"shadow",
                    iframe:true
                };

                oPanel = new YAHOO.widget.ResizePanel("panel_" + id, panelCfg);
                oPanel.setHeader("Service Item Details");
                oPanel.setBody("<div><img alt='' src='resources/catalogIcons/ajax-loader.gif' style='margin:10px;padding:0px;' /><span>Loading your service item.</span></div>");
                oPanel.render(elId);

                // give the panel body an id to grab onto
                panelBody = KD.utils.Util.getElementsByClassName("bd", "div", "panel_" + id)[0];
                if (panelBody) {
                    panelBody.id = "panel_body_" + id;
                }

                // add this panel to the selectedRequests object
                this.selectedRequests["panel_" + id] = oPanel;
            }

            // show the panel
            oPanel.show();
        };

        /**
         * Removes '_active' from the end of any class names for the specified element.
         * Will also remove '_active' from any class names of the specified element's
         * child nodes as well.
         * @method resetActiveClass
         * @param {HTMLElement} el The element to remove the active class name from
         * @return void
         */
        this.resetActiveClass = function (el) {
            var currentStyle = el.className,
            tempStyle = null,
            i = 0;

            if (currentStyle && currentStyle != "") {
                tempStyle = currentStyle.split("_active")[0];
                if (currentStyle != tempStyle) {
                    el.className = tempStyle;
                }
            }
            if (el.hasChildNodes) {
                for (i = 0; i < el.childNodes.length; i += 1) {
                    KD.utils.CatalogUtils.resetActiveClass(el.childNodes[i]);
                }
            }
        };

        /**
         * Toggle the detail row of a submitted request when the request item
         * is clicked.
         * @method toggleDetail
         * @param {String} id The instanceId of the submitted request
         * @param {HTMLElement} arrowImg The DOM element of the arrow indicator
         * @return void
         */
        this.toggleDetail = function (id, arrowImg) {
            var thisRow = Dom.get(id),
            nextRow = thisRow.nextSibling;

            while (nextRow.innerHTML == null) {
                nextRow = nextRow.nextSibling;
            }
            if (nextRow) {
                arrowImg.src = "resources/catalogIcons/arrowDown.gif";
                if (nextRow.style.display == 'none') {
                    try {
                        nextRow.style.display = 'table-row';
                    } catch (e) {
                        nextRow.style.display = 'block';
                    }
                } else {
                    nextRow.style.display = 'none';
                    arrowImg.src = "resources/catalogIcons/arrowRight.gif";
                }
            }
        };

        /**
         * Resets the items in a service catalog category to the original values.
         * @method resetCatalogItems
         * @return void
         */
        this.resetCatalogItems = function () {
            var serviceItems = Dom.get('serviceItems');
            serviceItems.innerHTML = this.categoryItemsHTML;
        };
    };
}
