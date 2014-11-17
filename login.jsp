<jsp:useBean id="UserContext" scope="session" class="com.kd.kineticSurvey.beans.UserContext"/>
<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
	response.setDateHeader("Expires", 0); //prevents caching at the proxy server
	response.setHeader("Pragma", "No-cache");
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-Frame-Options" content="sameorigin"/>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>

	<title>MyIT Login</title>
	<link rel="shortcut icon" href="resources/images/bbbfavicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" type="text/css" href="themes/flat-bootstrap3/common/resources/css/bootstrap.min.css"/>
	<link rel="stylesheet" type="text/css" href="themes/flat-bootstrap3/common/resources/css/metro-bootstrap.css"/>
	<link rel="stylesheet" type="text/css" href="themes/flat-bootstrap3/common/resources/css/font-awesome.min.css"/>
	<link rel="stylesheet" type="text/css" href="themes/flat-bootstrap3/common/resources/css/BBBcatalog.css"/>
	<script type="text/javascript">
		try
		{
			top.document.domain;
		} catch (e)
		{
			var f = function ()
			{
				document.body.innerHTML = "";
				document.head.innerHTML = "";
			};
			setInterval(f, 1);
			if (document.body)
			{
				document.body.onload = f;
			}
		}
	</script>
	<script type="text/javascript"
	        src="<%=request.getContextPath() + "/resources/js/yui/build/yahoo-dom-event/yahoo-dom-event.js"%>"></script>
	<script type="text/javascript">
		javascript:window.history.forward(-1);
		var successMessage = "<jsp:getProperty name="UserContext" property="successMessage" />";
		var errorMessage = "<jsp:getProperty name="UserContext" property="errorMessage" />";

		if (typeof KD === "undefined")
		{
			KD = {};
		}
		if (typeof KD.ksr === "undefined")
		{
			KD.ksr = {};
		}
		if (typeof KD.ksr.Login === "undefined")
		{
			KD.ksr.Login = new function ()
			{
				var init = function ()
				{
					checkMessages();
					YAHOO.util.Event.addListener(['UserName', 'Password', 'Authentication'], 'keyup', isEnter, this);
					YAHOO.util.Event.addListener('Submit', 'click', authenticate);
					YAHOO.util.Event.addListener('Login', 'submit', showLoader);
					setFocus();
				};
				var checkMessages = function ()
				{
					try
					{
						var messageLayer = YAHOO.util.Dom.get('message');
						if (successMessage && successMessage.length > 0)
						{
							messageLayer.innerHTML = successMessage;
							messageLayer.style.display = "block";
						}
						if (errorMessage && errorMessage.length > 0)
						{
							messageLayer.innerHTML = errorMessage;
							messageLayer.style.display = "block";
						}
					} catch (e)
					{
					}
				};
				var setFocus = function ()
				{
					var input = YAHOO.util.Dom.get("UserName");
					if (input)
					{
						input.select();
						input.focus();
					}
				};
				var isEnter = function (e)
				{
					if (YAHOO.util.Event.getCharCode(e) === 13)
					{
						authenticate();
					}
				};
				var authenticate = function ()
				{
					document.Login.submit();
					showLoader();
				};
				var showLoader = function ()
				{
					// disable the form
					document.Login.disabled = true;
					var formFields = YAHOO.util.Dom.getElementsByClassName('formField');
					for (var i = 0; i < formFields.length; i++)
					{
						formFields[i].disabled = true;
					}
					// show the loader image
					var loader = YAHOO.util.Dom.get('loader');
					if (loader)
					{
						YAHOO.util.Dom.setStyle(loader, "display", "inline");
					}
				};

				var publicMethods = {
					initialize: init
				};

				return publicMethods;
			};
		}

		// kick everything off
		YAHOO.util.Event.onDOMReady(KD.ksr.Login.initialize);
	</script>
	<style type="text/css">
		html {
			background-color: #fff;
		}

		body {
		}

		#main_box {
			width: 400px;
			border: 3px double #271493;
			margin: 100px auto;
			padding: 10px 20px 20px 20px;
			background-color: #ffffff;
			text-align: left;
		}

		#hd {
		}

		.hLogo {
			float: right;
		}

		.hText {
			float: left;
			text-align: left;
		}

		.hText h3 {
			margin-top: 10px;
            font-family: "HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;
            font-weight: 900;
            color: #271493;
		}

		#bd {
		}

		#message {
			border: 1px solid #fd711c;
			border-left-width: 0px;
			border-right-width: 0px;
			color: #333;
			background-color: #ffeeee;
			margin-bottom: 10px;
			padding: 10px 5px;
			font-weight: normal;
			font-size: 13px;
			display: none;
		}

		#loginForm {
			margin: 15px;
		}

        #loginForm .row
        {
            margin-bottom: 5px;
        }

		#authentication_string {
			display: none;
		}

		.row.submit {
			margin-top: 15px;
		}

		#loader {
			display: none;
			font-size: 13px;
			color: #A0A0A0;
		}

		#loader img {
			position: relative;
			top: .4em;
		}

		.clear {
			clear: both;
			height: 0px;
			width: 100%;
		}

		.noscript {
			margin: 0;
			margin-bottom: 10px;
			padding: 20px;
			font-size: 18px;
			font-family: Arial, Helvetica, sans-serif;
			color: #000;
			background-color: #FFF5F5;
			border: 2px solid #d00;
			text-align: center;
		}
	</style>
</head>
<body>
<noscript>
	<div class="noscript">Javascript must be enabled in your browser to use this application.</div>
</noscript>
<div id="main_box">
	<div id="hd">
		<div class="hText">
            <h3>IT Services</h3>
			<!-- <h3 id="arserver_heading">Server:
				<jsp:getProperty name="UserContext" property="arServer"/>
			</h3> -->
		</div>
        <img class="hLogo" src="resources/images/bbblogo.png" height="45" width="125" alt="Bed Bath Logo"/>
        <div class="clear"></div>
        <div class="hText">
            <h4 class="text-primary">Please Login</h4>
		</div>
        <div class="clear"></div>
	</div>
	<div id="bd">
		<div id="message"></div>
		<form name='Login' id='loginForm' method='post' action='KSAuthenticationServlet'>
			<div class="row input-group">

				<input placeholder="Username..." class="formField form-control" name="UserName" type="text"
				       autocomplete="off" id="UserName" size="80" maxlength="50"/>
			</div>
			<div class="row input-group">

				<input class="formField form-control" placeholder="Password..." name="Password" type="password"
				       autocomplete="off" id="Password" size="80" maxlength="50"/>
			</div>
			<div class="row" id="authentication_string">
				<label for="Authentication"><strong>Authentication</strong></label>
				<input class="formField" name="Authentication" type="text" autocomplete="off" id="Authentication"
				       size="30" maxlength="50"/>
			</div>
			<div class="row submit">
				<input class="formField button btn btn-primary" name="Submit" type="button" id="Submit" value="Submit"/>
				<span id="loader">Authenticating...&nbsp;<img height="75" width="75" src='themes/flat-bootstrap3/packages/base/resources/images/loading.GIF'/></span>
			</div>

			<input type="hidden" id="loginSessionID" name="sessionID"
			       value="<jsp:getProperty name="UserContext" property="customerSessionInstanceID"/>"/>
			<input type="hidden" id="originatingPage" name="originatingPage"
			       value="<%=StringEscapeUtils.escapeXml(UserContext.getOriginatingPage())%>"/>
		</form>
        <img class="img img-responsive" src="resources/images/AllLogos.png" alt="All logos" >

	</div>
</div>
<jsp:setProperty name="UserContext" property="errorMessage" value=""/>
</body>
</html>
