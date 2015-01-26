<%@page import="com.kineticdata.request.task.TaskRestApi"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.kineticdata.request.task.TaskServer"%>
<%@page import="com.kineticdata.ksr.config.TaskIntegrationManager"%>
<%@page import="com.kineticdata.request.task.TaskIntegrationAdapter"%>
<%@page import="com.kineticdata.request.task.TaskIntegrator"%>
<%@page import="com.kineticdata.ksr.models.Catalog"%>
<%@page import="com.kineticdata.ksr.Constants.CatalogAttributes"%>
<%@page import="com.kineticdata.ksr.Constants.TemplateAttributes"%>
<%@page import="com.kineticdata.ksr.models.Template"%>
<%@page import="com.kd.arsHelpers.ArsPrecisionHelper"%>
<%@page import="com.kd.arsHelpers.SimpleEntry"%>
<%@page import="com.kd.kineticSurvey.impl.RemedyHandler"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.kineticdata.ksr.adapter.Adapter"%>
<%@page import="com.kineticdata.ksr.config.AdapterFactoryManager"%>
<%@page import="com.kineticdata.ksr.config.AdapterFactoryManager"%>
<%@page import="com.bmc.thirdparty.org.apache.commons.lang.StringUtils"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
    response.setHeader("Pragma","no-cache");
    
    Adapter systemAdapter = AdapterFactoryManager.getAdapterFactory().getSystemAdapter();

    String successMessage = "";
    String errorMessage = "";
    String srv = "";
    String categoryId = request.getParameter("newCatId");
    String categoryName = request.getParameter("newCatName");
    List<Map> routinesList = new LinkedList<Map>();

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
            Template template = systemAdapter.getTemplateByInstanceId(srv);
            Catalog catalog = systemAdapter.getCatalogByInstanceId(template.getCatalogId());
            if (template != null) {
                // Check if this template has any Kinetic Task 4+ trees
                if (Template.Application.KINETIC_REQUEST.equals(template.getApplication()) 
                    && Template.TaskEngine.KINETIC_TASK_4_PLUS.equals(template.getTaskEngine())) {
                    
                    // Retrieve the "Task Server Name" attribute value
                    String serverName = template.getAttributeValue(TemplateAttributes.TASK_SERVER_NAME);
                    if (serverName == null) {
                        serverName = catalog.getAttributeValue(CatalogAttributes.TASK_SERVER_NAME);
                    }
                    // Retrieve the "Task Source Name" attribute value
                    String sourceName = template.getAttributeValue(TemplateAttributes.TASK_SOURCE_NAME);
                    if (sourceName == null) {
                        sourceName = catalog.getAttributeValue(CatalogAttributes.TASK_SOURCE_NAME);
                    }
                    
                    // Obtain a reference to the task integrator instances
                    TaskIntegrator taskIntegrator = TaskIntegrationManager.buildTaskIntegrator(RemedyHandler.getSystemContext());
                    TaskIntegrationAdapter taskIntegratorAdapter = taskIntegrator.getAdapter();

                    // If both the task server name and task source name are defined for this template or catalog
                    if (!StringUtils.isBlank(sourceName) && !StringUtils.isBlank(serverName)) {
                        // Load the task server that this template uses
                        TaskServer taskServer = taskIntegratorAdapter.retrieveTaskServer(serverName);
                        // If the server was defined, call the Task API to get a list of all the trees
                        if (taskServer != null) {
                            // Calculate the source group
                            String sourceGroup = catalog.getName()+" > "+template.getName();
                            // Build the API request parameters
                            Map<String,String> apiRequestParameters = new LinkedHashMap<String,String>();
                            apiRequestParameters.put("source", sourceName);
                            apiRequestParameters.put("sourceGroup", sourceGroup);
                            // Call the Task API and render the results
                            TaskRestApi api = new TaskRestApi(taskServer.getAuthenticationToken(), taskServer.getApplicationBaseUrl());
                            String responseContent;
                            try {
                                responseContent = api.get("/app/api/v1/trees", apiRequestParameters);
                            } catch (TaskRestApi.ApiException e) {
                                throw new RuntimeException(e.getMessage(), e);
                            } catch (TaskRestApi.UnexpectedResponseException e) {
                                throw new RuntimeException("Unable to connect to Kinetic Task.", e);
                            }
                            
                            // Build the response map
                            Map responseObject = (Map)JSONValue.parse(responseContent);
                            // Get the trees list
                            List<Map> treesList = (List<Map>)responseObject.get("trees");
                            if (treesList != null) {
                                for (Map tree : treesList) {
                                    // If the tree is a Local Routine
                                    if ("Local Routine".equals((String)tree.get("type"))) {
                                        routinesList.add(tree);
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
                font-family: "Sans Serif",sans-serif,arial;
                font-size: 14px;
            }
            form {
                text-align:left;
            }
            label {
                display:block;
            }
            label .bold {
                font-weight:bold;
            }
            div.notice {
                color: #4682b4;
                padding: 1em;
            }
            fieldset {
                padding: 1em;
            }
            fieldset legend {
                font-size: 16px;
                font-weight: bold;
            }
            .localRoutine {
                margin-top: 1em;
            }
            .placeholder {
                margin-left: 10px;
                color: #999;
            }
            .controls {
                margin-top: 1em;
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
                // Validate definition_ids for local routines
                var definitionIds = YAHOO.util.Dom.getElementsByClassName("definition_id");
                for (var i=0; i<definitionIds.length; i++) {
                    var definitionId = definitionIds[i].value;
                    if (!/^[a-zA-Z0-9_]+$/.test(definitionId)) {
                        alert("Local Routine definition ids may only contain alpha-numeric and underscore characters.");
                        return false;
                    }
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
            <span id="cloneErrorMessage"><%= errorMessage%></span>
        </div>
        <% }%>
        <% if (!("".equals(srv)) && successMessage.equals("")) {%>
        <div class="wrapper">
            <form name="Clone" method="post" action="<%= request.getContextPath()%>/CloneServlet">
                <input type="hidden" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>" />
                <p>
                    <label for="newName" class="bold">New Template Name</label>
                    <input type="text" id="newName" name="newName" size="75" value=""/>
                </p>
                <% if (!routinesList.isEmpty()) { %>
                <div class="localRoutines">
                    <div class="notice">
                    This service item includes local routines.  Please update all local routines 
                    so that the Definition Id is unique within the system.
                    </div>
                    <fieldset>
                        <legend>Local Routines</legend>
                        <% for (Map routine : routinesList) { %>
                        <%
                            String routineName = (String)routine.get("name");
                            String definitionId = (String)routine.get("definitionId");
                        %>
                        <div class="localRoutine">
                            <label for="routines[<%=routineName%>]">Definition Id for Local Routine: <%=routineName%></label>
                            <input type="text" name="routines[<%=definitionId%>]" size="75" class="definition_id" value=""/>
                            <div class="placeholder">Original Definition Id: (<%=definitionId%>)</div>
                        </div>
                        <% } %>
                    </fieldset>
                </div>
                <% } %>
                
                <div class="controls">
                    <input type="button" name='Submit' value='Continue'/>
                    <span id="loader" style="display:none">Cloning in progress, please wait... <img src="<%=request.getContextPath()%>/app/resources/images/loading.gif" alt="cloning"/></span>
                    <input type="hidden" name="srv" value="<%=StringEscapeUtils.escapeHtml4(srv)%>"/>
                    <%if(categoryId != null) {%>
                    <input type="hidden" name="newCatId" value="<%=StringEscapeUtils.escapeHtml4(categoryId)%>"/>
                    <%}%>
                    <%if(categoryName != null) {%>
                    <input type="hidden" name="newCatName" value="<%=StringEscapeUtils.escapeHtml4(categoryName)%>"/>
                    <%}%>
                </div>
            </form>
        </div>
        <% }%>
    </body>
</html>