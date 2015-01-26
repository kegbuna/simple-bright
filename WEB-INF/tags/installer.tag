<%@tag description="Layout for the installer pages." pageEncoding="UTF-8"%>
<%@ attribute name="content" required="true" %>
<%
    // Obtain a reference to the task action request
    com.kineticdata.core.v1.web.ActionRequest actionRequest = (com.kineticdata.core.v1.web.ActionRequest)
            request.getAttribute(com.kineticdata.core.v1.web.ActionRequest.class.getName());
    // Get the logged-in user's identity
    com.kd.kineticSurvey.beans.UserContext userContext =
        (com.kd.kineticSurvey.beans.UserContext)actionRequest.getSessionAttribute("UserContext");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset='utf-8'>
        <title>Kinetic | Setup</title>
        <link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
        <link href="<%=request.getContextPath()%>/app/thirdparty/google-fonts/fonts.css" media="all" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/app/resources/application.css" media="all" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/app/resources/temporary.css" media="all" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/app/thirdparty/font-awesome/css/font-awesome.min.css" media="all" rel="stylesheet" />
        <script src="<%=request.getContextPath()%>/app/thirdparty/jquery/jquery.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/jquery/jquery-ui/jquery-ui-1.10.3.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/momentjs/moment.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/bootstrap/bootstrap.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/jquery-form/jquery.form.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/jquery-datatables/jquery.dataTables.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/jquery-datatables/dataTables.bootstrap.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/underscorejs/underscore.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/resources/javascript/consoles.js"></script>
        <script src="<%=request.getContextPath()%>/app/resources/javascript/ajax.js"></script>
        <script src="<%=request.getContextPath()%>/app/resources/javascript/installer.js"></script>
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="/app/thirdparty/html5shiv/html5shiv.js"></script>
          <script src="/app/thirdparty/respondjs/respond.min.js"></script>
        <![endif]-->
    </head>
    <body class="installer">
        <div class='task-wrapper'>
            <nav class="navbar navbar-default" role="navigation">
                <div class="container-fluid">
                    <div id="logo">
                        <a href='<%=request.getContextPath()+"/app/installer/welcome"%>'>Kinetic Data</a>
                    </div>
                    <div class="nav-title">
                        <h3>Kinetic Request and Survey</h3>
                    </div>
                    <% if (userContext != null && userContext.isAuthenticated()) { %>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="">
                                <strong><%=userContext.getUserName()%></strong>
                                <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                <li role="presentation">
                                    <a href="<%=request.getContextPath()%>/KSAuthenticationServlet?Logout&logoutURL=<%=request.getContextPath()%>/app/admin">Logout</a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                    <% } %>
                    <!-- /.navbar-collapse -->
                </div>
                <!-- /.container-fluid -->
            </nav>

            <section class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-xs-12">
                            <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                            <div class="wizard-panel">
                                ${content}
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <footer>
                <div class='container-fluid'>
                    <p>
                        <span>&copy; 2004-<%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> Kinetic Data, All Rights Reserved.</span>
                        <span class="pull-right">Kinetic Request and Survey v<%=com.kineticdata.ksr.Version.getVersion()%></span>
                    </p>
                </div>
            </footer>
            <!-- /.Footer -->
        </div>
        <%-- 
            If the content page did not pop off the session message, add it to the top of the page. 
            This ensures that we are never squelching (or persisting) messages intended to be 
            displayed after a redirect.
        --%>
        <% if (org.apache.commons.lang3.StringUtils.isNotBlank((String)session.getAttribute("message"))) {
            // Escape the message and message type
            String message = org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(
                (String)session.getAttribute("message"));
            String messageType = org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(
                (String)session.getAttribute("messageType"));
            // Translate the message type
            if ("success".equals(messageType)) { messageType = "success"; }
            else if ("error".equals(messageType)) { messageType = "danger"; }
            else { messageType = "warning"; }
            // Remove the message from the session
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        %>
        <script type="application/javascript">
            var element = $('<div>').addClass('message alerts').attr('role', 'alert')
                .append($('<div>').addClass('alert alert-<%=messageType%>')
                    .text('<%=message%>')
                    .prepend($('<button data-dismiss=\'alert\'>').addClass('close').text('&times;')));
            var licenseMessage = $('.license.message');
            if (licenseMessage.size() > 0) {
                licenseMessage.after(element);
            } else {
                $('body').prepend(element);
            }
        </script>
        <% } %>
        <script>
            var contextPath = '<%= request.getContextPath() %>';
        </script>
    </body>
</html>