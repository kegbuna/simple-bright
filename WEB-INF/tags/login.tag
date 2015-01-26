<%@ attribute name="title" required="true" %>
<%@ attribute name="content" required="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset='utf-8'>
        <title>${title}</title>
        <link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
        <link href="<%=request.getContextPath()%>/app/thirdparty/google-fonts/fonts.css" media="all" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/app/resources/application.css" media="all" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/app/resources/temporary.css" media="all" rel="stylesheet" />
        <script src="<%=request.getContextPath()%>/app/thirdparty/jquery/jquery.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/momentjs/moment.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/bootstrap/bootstrap.min.js"></script>
        <script src="<%=request.getContextPath()%>/app/thirdparty/underscorejs/underscore.min.js"></script>
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="/app/thirdparty/html5shiv/html5shiv.js"></script>
          <script src="/app/thirdparty/respondjs/respond.min.js"></script>
        <![endif]-->
    </head>
    <body>
        <div class='task-wrapper'>
            <nav class="navbar navbar-default" role="navigation">
                <div class="container-fluid">
                    <div id="logo">
                        <a href="<%=request.getContextPath()%>/app">Kinetic Request and Survey</a>
                    </div>
                    <div class="nav-title">
                        <h3>Kinetic Request and Survey</h3>
                    </div>
                </div>
            </nav>    
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        ${content}
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
