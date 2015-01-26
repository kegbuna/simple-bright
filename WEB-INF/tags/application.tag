<%@tag import="com.kd.kineticSurvey.impl.RemedyHandler"%>
<%@ attribute name="title" required="true" %>
<%@ attribute name="navigationCategory" required="false" %>
<%@ attribute name="navigationItem" required="false" %>
<%@ attribute name="navigationSubitem" required="false" %>
<%@ attribute name="content" required="true" %>
<%
    // Cache Control
    response.setHeader("CACHE-CONTROL","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
    response.setDateHeader ("EXPIRES", 0); //prevents caching at the proxy server
    response.setHeader("PRAGMA","NO-CACHE");
    
    // Get the logged-in user's identity
    com.kd.kineticSurvey.beans.UserContext context = (com.kd.kineticSurvey.beans.UserContext)session.getAttribute("UserContext");
    
    // Determine if the ARS server is reachable
    boolean isArsUnreachable = false;
    try {
        RemedyHandler.getDefaultHelperContext();
    } catch (Exception e) {
        isArsUnreachable = true;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset='utf-8'>
        <title>${title}</title>
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
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="<%=request.getContextPath()%>/app/thirdparty/html5shiv/html5shiv.js"></script>
          <script src="<%=request.getContextPath()%>/app/thirdparty/respondjs/respond.min.js"></script>
        <![endif]-->
    </head>
    <body>
        <% if ("true".equals(RemedyHandler.INITIAL_STARTUP)) { %>
        <div class="message">
            <div class="warning">
                <h3>Welcome to Kinetic Request and Survey</h3>
                <p>
                    Kinetic Request and Survey has not been configured yet.  Please 
                    <a href="<%=request.getContextPath()%>/app/admin/setup">setup</a>
                    the application before continuing.
                </p>
            </div>
        </div>
        <% } else if (isArsUnreachable) { %>
        <div class="message">
            <div class="warning">
                <h3>Unable to connect to ARS</h3>
                <p>
                    Please verify your ARS 
                    <a href="<%=request.getContextPath()%>/app/admin/setup/ars">setup</a>, and 
                    ensure the ARS Server is running.
                </p>
            </div>
        </div>
        <% } %>
        <div class='task-wrapper'>
            <nav class="navbar navbar-default" role="navigation">
                <div class="container-fluid">
                    <div id="logo">
                        <a href="<%=request.getContextPath()%>/app">Kinetic Request and Survey</a>
                    </div>
                    <div class="nav-title">
                        <h3>Kinetic Request and Survey</h3>
                    </div>
                    <% if (context != null) { %>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="">
                                <strong><%=context.getUserName()%></strong>
                                <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                <li role="presentation">
                                    <a href="<%=request.getContextPath()+"/KSAuthenticationServlet?Logout"%>">Logout</a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                    <% } %>
                    <!-- /.navbar-collapse -->
                </div>
                <!-- /.container-fluid -->
            </nav>

            <section class="configbar">
                <div class="container-fluid">
                    <ul class="nav nav-tabs">
                        <li class="<%=navigationCategory == "Admin" ? "active" : ""%>">
                            <a href="<%=request.getContextPath()%>/app/admin">Admin</a>
                        </li>
                        <li class="<%=navigationCategory == "Diagnostics" ? "active" : ""%>">
                            <a href="<%=request.getContextPath()%>/app/diagnostics">Diagnostics</a>
                        </li>
                    </ul>
                </div>
            </section>

            ${content}

            <footer>
                <div class='container-fluid'>
                    <p>
                        <span>&copy; 2004-<%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> Kinetic Data, All Rights Reserved.</span>
                        <span class="pull-right">Kinetic Request and Survey v<%=com.kineticdata.ksr.Version.getVersion()%></span>
                    </p>
                </div>
            </footer>
            <!-- /.Footer -->
            
            <!-- Modal Authentication form -->
            <div class="modal fade" id="modal-auth" tabindex="-1" role="dialog" aria-labelledby="modal-auth" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h2 class="modal-title" id="modal-auth">Sign in</h2>
                        </div>
                        <div class="modal-body">
                            <form action="<%=request.getContextPath()%>/KSAuthenticationServlet" method="POST">
                                <div class="alert alert-danger" style="display:none;">
                                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                                    <div class="text"></div>
                                </div>
                                <div class="form-group">
                                    <label for="UserName">Login</label>
                                    <input autofocus="autofocus" class="form-control" id="UserName" name="UserName" type="text">
                                </div>
                                <div class="form-group">
                                    <label for="Password">Password</label>
                                    <input autocomplete="off" class="form-control" id="Password" name="Password" type="password">
                                </div>
                                <button type="submit" class="btn btn-default">Sign in</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
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
            java.util.List<String> errors = (java.util.List<String>)session.getAttribute("errors");
            // Translate the message type
            if ("success".equals(messageType)) { messageType = "success"; }
            else if ("error".equals(messageType)) { messageType = "danger"; }
            else { messageType = "warning"; }
            // Remove the message from the session
            session.removeAttribute("message");
            session.removeAttribute("messageType");
            session.removeAttribute("errors");
        %>
        <script type="application/javascript">
            var element = $('<div>').addClass('message alerts')
                .append($('<div>').addClass('alert alert-<%=messageType%>')
                    .text('<%=message%>')
                    .prepend($('<button data-dismiss=\'alert\'>').addClass('close').text('×')));
            var licenseMessage = $('.license.message');
            if (licenseMessage.size() > 0) {
                licenseMessage.after(element);
            } else {
                $('body').prepend(element);
            }
        </script>
        <% } %>
        <script>
            KineticSr.app.contextPath = '<%= request.getContextPath() %>';
        </script>
    </body>
</html>
