<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.kd.arsHelpers.*"%>
<%@page import="com.kd.kineticSurvey.impl.*"%>
<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
    response.setHeader("Pragma","no-cache");

    String successMessage = "";
    String errorMessage = "";
    String srv = "";

    if (session.getAttribute("cloneSuccessMessage") != null) {  //Needs to check if not null
        successMessage = session.getAttribute("cloneSuccessMessage").toString();
        session.setAttribute("cloneSuccessMessage", null);
    }
    if (session.getAttribute("cloneErrorMessage") != null) {  //Needs to check if not null
        errorMessage = session.getAttribute("cloneErrorMessage").toString();
        session.setAttribute("cloneErrorMessage", null);
    }

    // instanceId of the source template
    if (request.getParameter("srv") != null) {
        String decodedSrvParameter = java.net.URLDecoder.decode(request.getParameter("srv"), "UTF-8");
        ArsPrecisionHelper helper = new ArsPrecisionHelper(RemedyHandler.getDefaultHelperContext());
        SimpleEntry templateEntry = helper.getFirstSimpleEntry(
                "KS_SRV_SurveyTemplate", 
                "'179'=\""+decodedSrvParameter+"\"", 
                new String[]{"179"});
        // Ensure the retrieved template guid is the same as the parameter value
        if (templateEntry != null && templateEntry.getEntryFieldValue("179").equals(decodedSrvParameter)) {
            srv = templateEntry.getEntryFieldValue("179");
        }
    }
    
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>Clone Template</title>
        <style type="text/css">
            body {
                text-align:center;
            }
            form {
                text-align:left;
            }
            label {
                font-weight:bold;
                display:block;
                padding:1em 0;
            }
        </style>
        <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript">

            function doSubmit(e){
                var o = YAHOO.util.Event.getTarget(e);
                if (o && o.form) {
                    if (verifyForm(o.form)) {
                        o.form.submit();
                        showLoader(o.form);
                    }
                }
            }

            function verifyForm(form) {
                var newNameObj = form.newName;
                if (newNameObj == null) {
                    return false;
                }
                if (newNameObj.value == null || newNameObj.value == '') {
                    alert('Please choose a new template name before trying to clone.');
                    return false;
                }
                return true;
            }

            function showLoader(form){
                // disable the form
                form.Submit.disabled = true;
                form.newName.readOnly = true;
                //hide the error message
                var errorWrapper = document.getElementById('errorWrapper');
                if (errorWrapper) {
                    errorWrapper.style.display='none';
                }
                // show the loader image
                document.getElementById('loader').style.display = 'inline';
            }

            function init(){
                var form = document.Clone;
                if (form) {
                    YAHOO.util.Event.addListener(form.Submit,'click',doSubmit);
                }
                var newName = document.getElementById('newName');
                if (newName) {
                    newName.focus();
                }

            }

            YAHOO.util.Event.onDOMReady(init);
        </script>
    </head>
    <body>
        <% if (!successMessage.equals("")) {%>
        <div id="resultsWrapper">
            <h3>Clone Results</h3>
            <p><%= successMessage%></p>
        </div>
        <% }%>
        <% if (!errorMessage.equals("")) {%>
        <div id="errorWrapper">
            <img alt="Error Image" src="<%= request.getContextPath()%>/resources/consoles/images/Symbol Error.png"/>
            <span id="cloneErrorMessage"><%= errorMessage%></span>
        </div>
        <% }%>
        <% if (!("".equals(srv)) && successMessage.equals("")) {%>
        <div class="wrapper">
            <form name="Clone" method="post" action="<%= request.getContextPath()%>/CloneServlet">
                <p>
                    <label for="newName">Please enter a name for the new template.</label>
                    <input type="text" id="newName" name="newName" size="45" value=""/>
                    <input type="button" name='Submit' value='Continue' style="display:inline"/>
                </p>
                <span id="loader" style="display:none">Cloning in progress, please wait... <img src="loading.gif" alt="cloning"/></span>
                <input type="hidden" name="srv" value="<%= srv %>"/>
            </form>
        </div>
        <% }%>
    </body>
</html>