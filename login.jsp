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

	<title>Lahey Self Service</title>

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
	<script type="text/javascript" src="<%=request.getContextPath() + "/resources/js/yui/build/yahoo-dom-event/yahoo-dom-event.js"%>"></script>
	<script type="text/javascript" src="<%=request.getContextPath() + "/themes/simple-bright/common/resources/js/jquery-1.11.1.min.js"%>"></script>
	<!--[if IE 8]>
	<script type="text/javascript" src="<%=request.getContextPath() + "/themes/simple-bright/common/resources/js/ie8.js"%>"></script>
	<![endif]-->


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
					//TODO:: figure out of i want to keep this. It auto focuses the user field which hurts ie8 placeholder support but makes for a faster form
					//setFocus();
				};
				var checkMessages = function ()
				{
					try
					{
						var messageLayer = YAHOO.util.Dom.get('message');
						var titleLayer = YAHOO.util.Dom.get('loginTitle');
						if (successMessage && successMessage.length > 0)
						{
							messageLayer.innerHTML = successMessage;
							messageLayer.style.display = "block";
						}
						if (errorMessage && errorMessage.length > 0)
						{
							titleLayer.style.color = "red";
							titleLayer.innerHTML = "There was a problem logging you in:";
							if (errorMessage == "Authentication failed.")
							{
								messageLayer.innerHTML = "<p>Your username or password is incorrect.</p><p>Need help logging in? Call the Service Desk <b>781.744.8888</b></p>";
							}
							else
							{
								messageLayer.innerHTML = errorMessage;
							}
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
	<link rel="stylesheet" type="text/css" href="themes/simple-bright/common/resources/css/main.css">
	<style type="text/css">

	</style>
</head>
<body>
<noscript>
	<div class="noscript">Javascript must be enabled in your browser to use this application.</div>
</noscript>
<div id="loginBox">
	<div id="hd">
		<div class="hText">
            <img src="themes/simple-bright/common/resources/css/images/lahey-health-logo.png">
			<h3 class="site-title">Online Service Desk</h3>
			<!-- <h3 id="arserver_heading">Server:
				<jsp:getProperty name="UserContext" property="arServer"/>
			</h3> -->
		</div>

        <div class="clear"></div>
        <div class="hText">
            <h4 id="loginTitle" class="login-title">Please Login</h4>
		</div>
        <div class="clear"></div>
	</div>
	<div id="bd">
		<div id="message"></div>
		<form name='Login' id='loginForm' method='post' action='KSAuthenticationServlet'>
			<div class="username row">
				<input placeholder="Network Username..." class="formField form-control placeholder" name="UserName" type="text"
				       autocomplete="off" id="UserName"maxlength="50"/>
			</div>
			<div class="password row">
				<input class="formField form-control placeholder" name="Password" placeholder="Network Password..." type="password" autocomplete="off" id="Password" maxlength="50"/>
				<input class="formField form-control" style="display: none;" value="Network Password..." name="FakePassword" type="text" autocomplete="off" id="FakePassword" maxlength="50"/>
			</div>
			<div class="hide" id="authentication_string">
				<label for="Authentication"><strong>Authentication</strong></label>
				<input class="formField" name="Authentication" type="text" autocomplete="off" id="Authentication"
				       size="30" maxlength="50"/>
			</div>
			<div class="row submit">
				<input class="formField button--primary" name="Submit" type="button" id="Submit" value="Submit"/>
				<i id="loader" style="display: none;" class="fa fa-2x fa-spin fa-gear"></i>
				<!--<span id="loader">Authenticating...&nbsp;<img height="75" width="75" src='themes/flat-bootstrap3/packages/base/resources/images/loading.GIF'/></span>-->
			</div>

			<input type="hidden" id="loginSessionID" name="sessionID"
			       value="<jsp:getProperty name="UserContext" property="customerSessionInstanceID"/>"/>
			<input type="hidden" id="originatingPage" name="originatingPage"
			       value="<%=StringEscapeUtils.escapeXml(UserContext.getOriginatingPage())%>"/>
		</form>

	</div>
</div>
<jsp:setProperty name="UserContext" property="errorMessage" value=""/>
</body>
</html>
