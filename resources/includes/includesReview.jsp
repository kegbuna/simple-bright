<%-- CSS --%>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/resources/js/yui/build/calendar/assets/calendar.css"%>"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/resources/js/yui/build/container/assets/container.css"%>"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/resources/css/ks_basic.css"%>"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/resources/css/kd_review.css"%>"/>
<% if((customerSurvey.getStylesheetFileName() != null) &&  (customerSurvey.getStylesheetFileName().trim().length() > 0)){%>
<link href="<%= customerSurvey.getStylesheetFileName() %>" rel="stylesheet" type="text/css"/>
<%}%>

<%-- Scripts --%>
<% 
  String debugParam = (String)request.getParameter("debugjs");
  boolean debug = false;
  if (debugParam != null) {
      debug = Boolean.valueOf(debugParam).booleanValue();
  }
%>
<% if (debug) { %>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/yahoo/yahoo.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/dom/dom.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/event/event.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/connection/connection.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/animation/animation.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/dragdrop/dragdrop.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/element/element.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/calendar/calendar.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/button/button.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/container/container.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/kd_actions.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/kd_utils.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/kd_client.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/kd_review.js"%>"></script>
<% } else { %>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/yahoo-dom-event/yahoo-dom-event.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/connection/connection-min.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/animation/animation-min.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/dragdrop/dragdrop-min.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/element/element-min.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/calendar/calendar-min.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/button/button-min.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/container/container-min.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/kd_core.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/kd_review-min.js"%>"></script>
<% } %>
<% if((customerSurvey.getJavascriptFileName() != null) &&  (customerSurvey.getJavascriptFileName().trim().length() > 0)){%>
<script type="text/javascript" src="<%= customerSurvey.getJavascriptFileName() %>"></script>
<%}%>
