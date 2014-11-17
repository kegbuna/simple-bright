if(typeof Dom=="undefined"){Dom=YAHOO.util.Dom;}if(typeof KD=="undefined"){KD={};}if(typeof KD.utils=="undefined"){KD.utils={};}if(!KD.utils.CatalogUtils){KD.utils.CatalogUtils=new function(){this.showingApprovals=false;this.showingOpenItems=false;this.currentSummaryEl=null;this.categoryItemsHTML=null;this.selectedRequests={};this.getAllCategoryItems=function(g,d){var e=Dom.get("serviceItems"),b=e.parentNode,f=KD.utils.Util.getIDPart(b.id),a="allCategoryItems";if(d&&d.length>0){a=d;}if(f){this.categoryItemsHTML=e.innerHTML;var h=KD.utils.ClientManager.customEvents.getItem(f)[0];var c=new KD.utils.Callback(KD.utils.Action._addInnerHTML,KD.utils.Action._addInnerHTML,["serviceItems"]);KD.utils.Action.makeAsyncRequest("allItemsForCategory",h.actionId,c,"category="+g,a);}else{alert("No instance Id found");}};this.getAllMyRequests=function(e,c,b){var d=KD.utils.CatalogUtils,a="allMyRequests";if(b&&b.length>0){a=b;}d.showSelectedRequests(d.showingOpenItems,d.showingApprovals,d.currentSummaryEl,a,c);};this.showSelectedRequests=function(d,a,e,b,f){var c={isOpen:d,isApproval:a,isActionPending:false,clickedEl:e,partial:b,paramString:f};KD.utils.CatalogUtils._showSelectedRequests(c);};this._showSelectedRequests=function(b){var k,l,m,r,a,c;k=b.isOpen||false;l=b.isApproval||false;m=b.isActionPending||false;r=b.clickedEl;a=b.partial;c=b.paramString;var j="Request",h="Not Pending",i=r.className,f="requestsWithTasks",n="Open",s=Dom.get("selectedServiceItems"),d=s.parentNode,p=KD.utils.Util.getIDPart(d.id),e=null,g=null,o="",q="";if(l){j="Approval";}if(m){h="Pending";}if(a&&a.length>0){f=a;}if(!k){n="Closed";}if(c&&c.length>0){if(c.indexOf("?")===0){c=c.slice(1);}if(c.indexOf("&")!==0){c="&"+c;}q=c||"";}if(p){e=KD.utils.ClientManager.customEvents.getItem(p)[0];g=new KD.utils.Callback(KD.utils.Action._addInnerHTML,KD.utils.Action._addInnerHTML,["selectedServiceItems"],true);KD.utils.Action.makeAsyncRequest(f,e.actionId,g,"status="+n+"&submitType="+j+"&actionPending="+h+q,f);KD.utils.CatalogUtils.resetActiveClass(r.parentNode.parentNode);o=i.split("_active")[0];r.className=o+"_active";}else{alert("No instance Id found");}KD.utils.CatalogUtils.showingApprovals=l;KD.utils.CatalogUtils.showingOpenItems=k;KD.utils.CatalogUtils.currentSummaryEl=r;};this.showSelectedRequest=function(d,a,m,e){var n="selectedRequest",l="selectedRequestOrig",k,h,p,o=null,b=null,g="",f;if(m&&m.length>0){n=m;}if(e&&e.length>0){if(e.indexOf("?")===0){e=e.slice(1);}if(e.indexOf("&")!==0){e="&"+e;}g=e||"";f=g.split("&");for(var j=0;j<f.length;j+=1){var c=f[j].split("=");if(c&&c[0]==="paramUseKineticTask"){if(c[1]&&c[1]==="true"){l="selectedRequest";}break;}}}k=Dom.get(l);if(k){h=k.parentNode;p=KD.utils.Util.getIDPart(h.id);this._buildPanel(a,k);if(p){o=KD.utils.ClientManager.customEvents.getItem(p)[0];b=new KD.utils.Callback(KD.utils.Action._addInnerHTML,KD.utils.Action._addInnerHTML,["panel_body_"+a],true);KD.utils.Action.makeAsyncRequest(n,o.actionId,b,g,n);}else{alert("No record found");}KD.utils.CatalogUtils.currentSummaryEl=d;}};this._buildPanel=function(e,a){var d,c,b;d=this.selectedRequests["panel_"+e];if(d==null){c={width:"860px",x:30,y:30,zIndex:10000,visible:false,draggable:true,close:true,underlay:"shadow",iframe:true};d=new YAHOO.widget.ResizePanel("panel_"+e,c);d.setHeader("Service Item Details");d.setBody("<div><img alt='' src='resources/catalogIcons/ajax-loader.gif' style='margin:10px;padding:0px;' /><span>Loading your service item.</span></div>");d.render(a);b=KD.utils.Util.getElementsByClassName("bd","div","panel_"+e)[0];if(b){b.id="panel_body_"+e;}this.selectedRequests["panel_"+e]=d;}d.show();};this.resetActiveClass=function(d){var b=d.className,a=null,c=0;if(b&&b!=""){a=b.split("_active")[0];if(b!=a){d.className=a;}}if(d.hasChildNodes){for(c=0;c<d.childNodes.length;c+=1){KD.utils.CatalogUtils.resetActiveClass(d.childNodes[c]);}}};this.toggleDetail=function(f,c){var d=Dom.get(f),a=d.nextSibling;while(a.innerHTML==null){a=a.nextSibling;}if(a){c.src="resources/catalogIcons/arrowDown.gif";if(a.style.display=="none"){try{a.style.display="table-row";}catch(b){a.style.display="block";}}else{a.style.display="none";c.src="resources/catalogIcons/arrowRight.gif";}}};this.resetCatalogItems=function(){var a=Dom.get("serviceItems");a.innerHTML=this.categoryItemsHTML;};};}