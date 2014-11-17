<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/yui/build/cookie/cookie-min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/yui/build/connection/connection-min.js"></script>
        <script type="text/javascript">
            function displayErrorMessage(message) {
                var el = document.createElement('div');
                el.className = 'message';
                el.innerHTML = message;
                document.body.appendChild(el);
            }
        </script>

        <style type="text/css">
            .message {margin:0;margin-bottom:10px;padding:20px;font-size:18px;font-family:Arial, Helvetica, sans-serif;color:#000;background-color:#FFF5F5;border:2px solid #d00;text-align:center;}
        </style>
    </head>
    <body>
        <noscript>
            <div class="message">You must enable javascript in your browser to use this application.</div>
        </noscript>
        <script type="text/javascript">
            (function(){
                var offset = new Date().getTimezoneOffset();
                var callback = {
                    success: function() {
                        var timezone = YAHOO.util.Cookie.get("tzOffset");
                        if (timezone == null) {
                            displayErrorMessage("You must allow cookies for host: " +window.location.hostname);
                            // Just resetting the page, it doesnt matter
                            window.location.reload();
                        } else {
                            window.location.reload();
                        }
                    },
                    failure: function() {
                        displayErrorMessage("There was a problem setting the local timezone.  Please contact your administrator.");
                    },
                    timeout: 5000
                }
                YAHOO.util.Connect.asyncRequest('POST', document.URL, callback, 'tzOffset='+offset);
            })();
        </script>
    </body>
</html>
