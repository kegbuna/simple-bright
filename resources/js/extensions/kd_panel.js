/*
Copyright (c) 2012, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/

/**
 * <p>
 * Provides extended functionality to the YAHOO.widget.Panel class.  Essentially
 * adds an icon to the lower-right hand corner of the panel that allows the user
 * to click on the icon, and resize the panel.
 * </p>
 * <p>
 * A resizable panel is used on laucher pages to display the details about an
 * individual request.
 * </p>
 *
 * @module panel
 */

(function () {
    /**
     * <p>
     * ResizePanel is an implementation of YAHOO.widget.Panel that behaves like
     * an OS window, with a draggable header and an optional close icon at the top right,
     * and also provides resizing by adding a drag icon to the bottom right.
     * </p>
     *
     * @namespace YAHOO.widget
     * @class ResizePanel
     * @extends YAHOO.widget.Panel
     * @constructor
     * @param {String | HTMLElement} el The element ID representing the ResizePanel
     * OR The element representing the ResizePanel.
     * @param {Object} userConfig The configuration object literal containing the
     * configuration that should be set for this ResizePanel.
     * See configuration documentation for more details.
     * @return void
     */
    YAHOO.widget.ResizePanel = function(el, userConfig) {
        if (arguments.length > 0) {
            YAHOO.widget.ResizePanel.superclass.constructor.call(this, el, userConfig);
        }
    }

    /**
     * CSS class name identifying the element that contains the resize panel
     * @property CSS_PANEL_RESIZE
     * @type String
     * @default yui-resizepanel
     */
    YAHOO.widget.ResizePanel.CSS_PANEL_RESIZE = "yui-resizepanel";

    /**
     * CSS class name identifying the element that contains the resize handle icon
     * @property CSS_RESIZE_HANDLE
     * @type String
     * @default resizehandle
     */
    YAHOO.widget.ResizePanel.CSS_RESIZE_HANDLE = "resizehandle";

    YAHOO.extend(YAHOO.widget.ResizePanel, YAHOO.widget.Panel, {
        /**
         * The Panel initiaization method, which is executed for Panel and all of
         * its subclasses.  This method is automatically called by the constructor,
         * and sets up all DOM references for pre-existing markup, and creates
         * required markup if it is not already present.
         * @method init
         * @param {String | HTMLElement} el The element ID representing the ResizePanel
         * OR The element representing the ResizePanel.
         * @param {Object} userConfig The configuration object literal containing the
         * configuration that should be set for this ResizePanel.
         * See configuration documentation for more details.
         * @return void
         */
        init: function(el, userConfig) {
            YAHOO.widget.ResizePanel.superclass.init.call(this, el);
            this.beforeInitEvent.fire(YAHOO.widget.ResizePanel);

            var Dom = YAHOO.util.Dom,
                Event = YAHOO.util.Event,
                oInnerElement = this.innerElement,
                oResizeHandle = document.createElement("DIV"),
                sResizeHandleId = this.id + "_resizehandle";

            oResizeHandle.id = sResizeHandleId;
            oResizeHandle.className = YAHOO.widget.ResizePanel.CSS_RESIZE_HANDLE;
            Dom.addClass(oInnerElement, YAHOO.widget.ResizePanel.CSS_PANEL_RESIZE);
            this.resizeHandle = oResizeHandle;

            function initResizeFunctionality() {
                var me = this,
                    oHeader = this.header,
                    oBody = this.body,
                    oFooter = this.footer,
                    nStartWidth,
                    nStartHeight,
                    aStartPos,
                    nBodyBorderTopWidth,
                    nBodyBorderBottomWidth,
                    nBodyTopPadding,
                    nBodyBottomPadding,
                    nBodyOffset;

                oInnerElement.appendChild(oResizeHandle);
                this.ddResize = new YAHOO.util.DragDrop(sResizeHandleId, this.id);
                this.ddResize.setHandleElId(sResizeHandleId);
                this.ddResize.onMouseDown = function(e) {
                    nStartWidth = oInnerElement.offsetWidth;
                    nStartHeight = oInnerElement.offsetHeight;

                    if (YAHOO.env.ua.ie && document.compatMode == "BackCompat") {
                        nBodyOffset = 0;
                    } else {
                        nBodyBorderTopWidth = parseInt(Dom.getStyle(oBody, "borderTopWidth"), 10),
                        nBodyBorderBottomWidth = parseInt(Dom.getStyle(oBody, "borderBottomWidth"), 10),
                        nBodyTopPadding = parseInt(Dom.getStyle(oBody, "paddingTop"), 10),
                        nBodyBottomPadding = parseInt(Dom.getStyle(oBody, "paddingBottom"), 10),
                        nBodyOffset = nBodyBorderTopWidth + nBodyBorderBottomWidth + nBodyTopPadding + nBodyBottomPadding;
                    }

                    me.cfg.setProperty("width", nStartWidth + "px");
                    aStartPos = [Event.getPageX(e), Event.getPageY(e)];
                };

                this.ddResize.onDrag = function(e) {
                    var aNewPos = [Event.getPageX(e), Event.getPageY(e)],
                        nOffsetX = aNewPos[0] - aStartPos[0],
                        nOffsetY = aNewPos[1] - aStartPos[1],
                        nNewWidth = Math.max(nStartWidth + nOffsetX, 10),
                        nNewHeight = Math.max(nStartHeight + nOffsetY, 10),
                        nBodyHeight = (nNewHeight - (oFooter.offsetHeight + oHeader.offsetHeight + nBodyOffset));

                    me.cfg.setProperty("width", nNewWidth + "px");

                    if (nBodyHeight < 0) {
                        nBodyHeight = 0;
                    }

                    oBody.style.height =  nBodyHeight + "px";
                };
            }


            function onBeforeShow() {
               initResizeFunctionality.call(this);
               this.unsubscribe("beforeShow", onBeforeShow);
            }


            function onBeforeRender() {
                if (!this.footer) {
                    this.setFooter("");
                }

                if (this.cfg.getProperty("visible")) {
                    initResizeFunctionality.call(this);
                } else {
                    this.subscribe("beforeShow", onBeforeShow);
                }
                this.unsubscribe("beforeRender", onBeforeRender);
            }


            this.subscribe("beforeRender", onBeforeRender);
            if (userConfig) {
                this.cfg.applyConfig(userConfig, true);
            }
            this.initEvent.fire(YAHOO.widget.ResizePanel);
        },

        /**
         * Generates a name for this panel, which is a concatenation of 'ResizePanel'
         * with the id of the element where it is contained.
         * @method toString
         * @return {String} The name of this resize panel
         */
        toString: function() {
            return "ResizePanel " + this.id;
        }
    });
})();
