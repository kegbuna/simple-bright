<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="propertiesInfo" scope="request" class="com.kd.kineticSurvey.beans.CurrentProperties" />
<jsp:useBean id="LicenseInfo" scope="request" class="com.kd.kineticSurvey.beans.LicenseInfo" />
<jsp:useBean id="userContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%
	String reloadRequest;
	String loglevel;
	String title = "Current Property Display";
	String message ="";

	reloadRequest = request.getParameter("reload");
	loglevel = request.getParameter("loglevel");
	userContext = (com.kd.kineticSurvey.beans.UserContext)session.getAttribute("UserContext");
%>
<%
	if (reloadRequest != null) {
		propertiesInfo.refreshProperties();
		title = "Properties Refreshed";
		message = "Property Refresh Complete";
		userContext.setErrorMessage("");
		userContext.setSuccessMessage("");
	}
	if (loglevel != null) {
		propertiesInfo.setLoggerLevel(loglevel);
		title = "Log Level Updated";
		message = "Log Level Update Complete";
		userContext.setErrorMessage("");
		userContext.setSuccessMessage("");
	}
%>
<div id="license">
	<% String [] licKeys = {"Survey License Key", "Request License Key"};
   	for (int i = 0; i < licKeys.length; i++) {
      LicenseInfo.setLicenseName(licKeys[i]);
	  if (LicenseInfo.getLicenseKey().length() > 0) { %>
	<div class="wrapper">
		<h3><%= licKeys[i] %></h3>
		<div class="window">
			<table>
				<tr class="light">
					<th>Key</th>
					<td class="HardBreak"><jsp:getProperty name="LicenseInfo" property="licenseKey"/></td>
				</tr>
				<tr class="dark">
					<th>License Site</th>
					<td><jsp:getProperty name="LicenseInfo" property="licenseSite"/></td>
				</tr>
				<tr class="light">
					<th>Server Name</th>
					<td><jsp:getProperty name="LicenseInfo" property="serverName"/></td>
				</tr>
				<tr class="dark">
					<th>Application Name</th>
					<td><jsp:getProperty name="LicenseInfo" property="applicationName"/></td>
				</tr>
				<tr class="light">
					<th><jsp:getProperty name="LicenseInfo" property="expirationType"/></th>
					<td><jsp:getProperty name="LicenseInfo" property="licenseValue"/></td>
				</tr>
			</table>
		</div>
	</div>
		<% } %>
	<% } %>
</div>