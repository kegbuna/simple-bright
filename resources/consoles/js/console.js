/*
Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/
// setup shortcuts
if (typeof Dom == "undefined") { Dom = YAHOO.util.Dom; }
if (typeof Connect == "undefined") { Connect = YAHOO.util.Connect; }


// shared functions
function init(curActive) {
    if(curActive=='null') {
        if(curActive=='' || curActive == null){
            var tab = Dom.getFirstChild("tabs");
            if(tab == null){
                adjustSidebarHeight();
                return;
            }
           var curTab = tab.id.split("tab")[0];
        }
        tabSelect(curActive);
    } else {
        adjustSidebarHeight(curActive)
    }
}

function adjustSidebarHeight(targetId, notTabLayer) {
    var misc = Dom.get('misc');
    var layerId = targetId+'div';
    var offset = 0;
    if(notTabLayer){
        layerId = targetId;
        offset = 16;
    }
    var div = Dom.get(layerId);
    if(misc == null || div == null){
        return;
    }
    var h1 = misc.offsetHeight;
    var h2 = div.offsetHeight;
    var docHeight = Dom.getViewportHeight();
    var sidebarHeight=docHeight-Dom.getY('sidebar');
    if((h1+h2) > sidebarHeight){
        sidebarHeight=(h1+h2);
    }
    sidebarHeight -= offset;
    Dom.setStyle(Dom.get('sidebar'),'height',sidebarHeight+'px');
}

function tabSelect(targetId, parentEl, subDivClass) {
    var tabsId="tabs";
    var contentClass="div";
    //For subTabs
    if(parentEl != null && parentEl != ""){
        tabsId = parentEl;
    }
    if (subDivClass !=null && subDivClass != ""){
        contentClass = subDivClass;
    }

    var targetTab = Dom.get(targetId+'tab');
    //Bad URL Anchor
    if(targetTab == null){
        targetTab = Dom.getFirstChild(parentEl);
        targetId=targetTab.getAttribute("id").replace(/tab/, "");
    }
    var targetDiv = Dom.get(targetId+'div');

    Dom.get(tabsId).getElementsByTagName("li")
    var tabArray = Dom.get(tabsId).getElementsByTagName("li");
    Dom.removeClass(tabArray, "activeTab");

    var divArray = Dom.getElementsByClassName(contentClass);
    Dom.removeClass(divArray, "activeDiv");

    Dom.addClass(targetTab, "activeTab");
    Dom.removeClass(targetTab, "hover");
    Dom.addClass(targetDiv, "activeDiv");

    adjustSidebarHeight(targetId);
}

function tabHover(curTab) {
    if(curTab.className!="activeTab") {
        Dom.addClass(curTab, "hover");
    }
}
function tabUnhover(curTab) {
    if(curTab.className!="activeTab") {
        Dom.removeClass(curTab, "hover");
    }
}


function showLoader(loaderLayer, cssClass){
    if (loaderLayer == null){
        loaderLayer = "ajaxLoader"
        };
    var divEl = Dom.get(loaderLayer);
    divEl.style.display="block";
    divEl.innerHTML = '<div class="ajaxLoaderSymbol '+cssClass+'"><img alt="ajax loader" src="resources/catalogIcons/ajax-loader-orange.gif"/>loading...<div>';
}

function hideLoader(loaderLayer){
    if (loaderLayer == null){
        loaderLayer = "ajaxLoader"
        };
    var divEl = Dom.get(loaderLayer);
    divEl.style.display = "none";
}

function buildMessageLayer(message, layer){
    layer.innerHTML = "<div class='consoleMessage'>"+message+"</div>";
}

function setSelectValue(elId, value){
    var el = Dom.get(elId);
    for(var i=0;i< el.options.length;i++){
        if(el.options[i].value==value){
            el.options[i].setAttribute("selected","true");
            el.selectedIndex=i;
            return;
        }
    }
}

/** REQUEST MANAGER FUNCTIONS **/
function animateAccordian(id, animObj, contentsPrefix){
    var sign = "+";
    var toNbr = 0;
    var fromNbr = 0;
    var addClass = "plus";
    var rmvClass = "plus";
    if (contentsPrefix == null || contentsPrefix == ""){
        contentsPrefix = "list_";
    }
    var list = Dom.get(contentsPrefix+id);
    var listHt = getHeight(list);
    //Need this to see if its animated
    if (animObj.isAnimated()){
        return false;
    }

    /*Expanding*/
    if(Dom.get("plusMinus_"+id).innerHTML == "+"){
        sign = "-";
        addClass="minus";
        toNbr = listHt;
        if (toNbr == 0){
            toNbr = list.getAttribute("origHeight");
        }
        Dom.setStyle(list,"height", "0px");
        Dom.setStyle(list, "display", "block");
    /*Contracting*/
    } else {
        var fromNbr = listHt;
        list.setAttribute("origHeight", listHt);
        var rmvClass="minus";
    }
    animObj.init(list, {
        height: {
            from: fromNbr,
            to: toNbr
        }
    }, .5, YAHOO.util.Easing.easeOut);

    animObj.animate();
    animObj.onComplete.subscribe(function(e,parms){
        var el = Dom.get("plusMinus_"+id);
        el.innerHTML = sign;
        Dom.addClass(el, addClass);
        Dom.removeClass(el, rmvClass);
    });
}

function getHeight(el) {
    var clipped = false;
    if (el.style.display == 'none') {
        clipped = true;
        var _pos = Dom.getStyle(el, 'position');
        var _vis = Dom.getStyle(el, 'visiblity');
        var _wid = Dom.getStyle(el, 'width');
        Dom.setStyle(el, 'width', getComputedWidth(el));
        Dom.setStyle(el, 'position', 'absolute');
        Dom.setStyle(el, 'visiblity', 'hidden');
        Dom.setStyle(el, 'display', 'block');

    }
    var height = Dom.getStyle(el, "height");
    if (height == 'auto') {
        //For IE
        Dom.setStyle(el, 'zoom', '1');
        height = el.clientHeight;
    }
    if (clipped) {
        Dom.setStyle(el, 'display', 'none');
        Dom.setStyle(el, 'visiblity', _vis);
        Dom.setStyle(el, 'position', _pos);
        Dom.setStyle(el, 'width', _wid);
    }
    //Strip the px from the style
    return parseInt(height);
}

function getComputedWidth(el){
    var width = Dom.getStyle(el, "width");
    while (el && (width == 'auto') || width == '0px'){
        if (el.nodeName.toUpperCase() =="HTML"){
            return Dom.getClientWidth();
        }
        el = el.parentNode;
        width = Dom.getStyle(el, "width");
    }
    return width;
}

function setServiceItemsMenu(catalogId, catalogs, selectEl){
    selectEl = Dom.get(selectEl);
    /*Clear Old Values*/
    for (var h=selectEl.options.length-1; h>=0; h--) {
        selectEl.remove(h);
    }

    var blankOption = document.createElement("option");
    blankOption.setAttribute("value", "");
    blankOption.appendChild(document.createTextNode("-Select Service-"));
    selectEl.appendChild(blankOption);
    for (var i in catalogs){
        var catalog = catalogs[i];
        if (catalog.catalogId == catalogId){
            for (var si in catalog.serviceItems){
                var svc = catalog.serviceItems[si];
                var newOption = document.createElement("option");
                newOption.setAttribute("value", svc.id);
                newOption.appendChild(document.createTextNode(decodeURIComponent(svc.serviceName)));
                selectEl.appendChild(newOption);
            }
        }
    }
}

function handleReportDataRetrievalSuccess(response) {
    showFlashReport(response.argument.report, response.responseText, response.argument.reportLayer);
}

function handleReportDataRetrievalFailure(response) {
    var message = response.statusText;
    if (response.getResponseHeader != null && response.getResponseHeader['X-Error-Message'] != null){
        message =   response.getResponseHeader['X-Error-Message'];
    }
    KD.utils.Action.handleHttpErrorCode(response.status, message);
}

function showServiceDetails(serviceId){
    tabSelect('serviceViewSub', 'viewByTabs', 'managerSub');
    showServiceDetailsReport(serviceId);
    var curActive = Dom.getElementsByClassName("active", "div", "serviceItemList", function(el){
        Dom.removeClass(el, "active");
    });
    Dom.addClass("item_"+serviceId, "active");
}

function clearServiceDetails(){
    Dom.get("serviceItemDetails").innerHTML = '<p id="emptyServiceDetail">-select "more..." from a service item to view details-</p>';
}

function showServiceDetailsReport(serviceId){
    showLoader("serviceItemDetails", "ajaxLoaderSpacer");
    if(serviceId != null && serviceId != ""){
        serviceId = encodeURIComponent(serviceId);
        var sUrl = "RequestOverviewServlet?format=requestOverviewBasic&srid="+serviceId;
        var callback = {
            success:addServiceDetails,
            failure: function(response){
                hideLoader("ajaxLoader"); handleReportDataRetrievalFailure(response);
            }
            };
        Connect.initHeader("X-Requested-With", 'XMLHttpRequest');
        var request = Connect.asyncRequest('GET', sUrl, callback);
    }
}

function addServiceDetails(o){
    Dom.get("serviceItemDetails").innerHTML = o.responseText;
    adjustSidebarHeight("reportsWrapperLayer", true);
}

function showVolumeReport(){
    var reportLayer = Dom.get('volumeReport');
    if (!validateVolume()){
        buildMessageLayer("Please select a Catalog and a Report", reportLayer);
        return false;
    }
    var report = volumeReports.getItem(Dom.get("volumeReportList").value);
    var catId = encodeURIComponent(Dom.get("catalogList").value);
    report.dataUnits = determineTimeUnit(Dom.get("volumeTimeCriteria"));
    report.timeCriteria = Dom.get("volumeTimeCriteria").value;
    Dom.setStyle("reportsWrapperLayer", "display", "block");
    tabSelect('catalogViewSub', 'viewByTabs', 'managerSub');

    var groupBy = encodeURIComponent(report.groups);
    var reportName = encodeURIComponent(report.remedyReportName);
    var timeCriteria = encodeURIComponent(report.timeCriteria);
    var dataUnits = encodeURIComponent(report.dataUnits);

    showLoader("volumeReport", "ajaxLoaderSpacer");
    Connect.initHeader("X-Requested-With", 'XMLHttpRequest');
    Connect.asyncRequest(
        'GET',
        'ReportRequestServlet?' + "categoryId="+catId+"&targetReport="+reportName+"&groupFields="+groupBy+"&timeCriteria="+timeCriteria+"&dataUnits="+dataUnits,
        {
            success:handleReportDataRetrievalSuccess,
            failure:function(response){
                hideLoader("volumeReport");handleReportDataRetrievalFailure(response);
            },
            argument:{
                report: report,
                reportLayer: reportLayer
            }
            }
        );
}

function validateVolume(){
    var volList = Dom.get("volumeReportList");
    var catList = Dom.get("catalogList");
    if(volList.value == null || volList.value == "" || catList.value == null || catList.value == ""){
        return false;
    }
    return true;
}

function showServiceItems(){
    var reportParams = Dom.get("dashboardParams");
    reportParams.style.display="block";
    setSelectValue("volumeTimeCriteria", "7Days");
    setSelectValue("volumeReportList", "Service Items Trending");

    showLoader();
    var catId = encodeURIComponent(Dom.get("catalogList").value);
    if(catId != null && catId != ""){
        var report = encodeURIComponent("Service Items By Catalog");
        var sUrl = "ReportRequestServlet?targetReport="+report+"&format=serviceItemList&categoryId="+catId;
        var callback = {
            success:addServiceItems,
            failure: function(response){
                hideLoader("ajaxLoader"); handleReportDataRetrievalFailure(response)
                }
            };
        Connect.initHeader("X-Requested-With", "XMLHttpRequest");
        var request = Connect.asyncRequest('GET', sUrl, callback);
    }
    clearServiceDetails();
}

function addServiceItems(o){
    if(o.responseText != undefined){
        Dom.setStyle("emptyConsole", "display", "none");
        hideLoader();
        showVolumeReport();
        Dom.get("serviceItems").innerHTML = o.responseText;
        adjustSidebarHeight("service_items");
    }
}

/** SUBMISSION CONSOLE FUNCTIONS **/

function showHideCriteria(criteriaEl){
    var el = Dom.get(criteriaEl + "Checkbox");
    var isChecked = el.checked;
    var criteriaLayer = Dom.get(criteriaEl + "SearchLayer");
    if (isChecked){
        criteriaLayer.style.display = "block";
    }else{
        criteriaLayer.style.display = "none";
        clearValues(criteriaLayer);
    }
}

function validSearch(){
    return true;
//Check params that there is something
}

function doSubmissionSearch(){
    showLoader();
    Dom.get('messagesLayer').innerHTML = "";
    if(validSearch()){
        var report = encodeURIComponent("Get Customer Submissions");
        var sUrl = "ReportRequestServlet?targetReport="+report;
        var callback = {
            success:showSubmissionTable,
            failure: function(response){
                hideLoader("ajaxLoader"); handleReportDataRetrievalFailure(response)
                }
            };
        Connect.initHeader("X-Requested-With", "XMLHttpRequest");
        Connect.setForm('submissionSearchForm');
        var request = Connect.asyncRequest('POST', sUrl, callback);
    }else{
        Dom.get('messagesLayer').innerHTML = "You must enter some search criteria";
    }
}

function clearValues(parentEl){
    var els = Dom.getChildren(parentEl);
    for (var i = 0; i <els.length; i++){
        if((els[i].nodeName.toUpperCase()=="SELECT" && els[i].options.length>0)){
            els[i].selectedIndex=0; els[i].options[0].selected=true; continue;
        }
        if(els[i].nodeName.toUpperCase()=="INPUT"){
            els[i].value = "";
        }
    }
}

function showSubmissionTable(response,param){
    hideLoader("ajaxLoader");
    var layer = Dom.get('customerSubmissionDetails');
    var recordXMLArray=KD.utils.Action.getMultipleRequestRecords(response);
    layer.removeChild(layer.firstChild);
    layer.appendChild(KD.utils.Action.showResultsAsTable(recordXMLArray, "submissionsTable", "resultsTable"));
}
