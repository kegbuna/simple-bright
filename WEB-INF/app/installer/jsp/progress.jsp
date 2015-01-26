<%@page import="com.kineticdata.ksr.installer.web.SetupWizardServlet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<% 
    LinkedHashMap<String,Object> dataMap = (LinkedHashMap<String,Object>)request.getAttribute("installationState");
    String setupAction = (String)session.getAttribute(SetupWizardServlet.HttpAttribute.SETUP_ACTION);
    String completeMessage = StringUtils.equals(setupAction, SetupWizardServlet.Action.INSTALL)
        ? "Installation completed successfully."
        : "Upgrade completed successfully.";
%>
<tag:installer>
    <jsp:attribute name="content">
        <style>
            .progress {margin-bottom: 0; position:relative;}
            .progress .progress-bar { float: none; }
            .progress .progress-text {
                position: absolute;
                top: 0;
                text-align: center;
                width: 100%;
            }
        </style>
        <form action="finish" method="POST">
            <div class="title">
                <a class="pull-right h5" href="<%=request.getContextPath()%>/app/logs/installation" target="_blank">Setup Log</a>
                Kinetic Setup - Progress
            </div>
            <div class="message">
                <% if (StringUtils.equals(setupAction, SetupWizardServlet.Action.UPGRADE)) { %>
                <div class="bs-callout bs-callout-info">
                    <h4>Notice</h4>
                    <div>
                        When setup is finished upgrading the Remedy server, it may be necessary to flush the 
                        Mid-Tier cache in order to refresh the definition objects.
                    </div>
                </div>
                <% } %>
                <div class="alert alert-danger removed" id="statusMessage"></div>
                <table class="table table-hover" id="progress-table" style="width:100%;"></table>
            </div>

            <input type="hidden" name="confirmedAction" id="confirmedAction"/>
            <input type="hidden" id="CsrfToken" name="CsrfToken" value="<%=session.getAttribute("CsrfToken")%>"/>
            <div class="actions">
                <button class="btn btn-primary" type="submit" value="Continue" disabled>Continue</button>
            </div>
        </form>
        <script>
            var progressTable;
            
            function updateTable(dataObject) {
                if (dataObject) {
                    progressTable.destroy();
                    drawTable(dataObject);
                }
            }
            
            function drawTable(dataObject) {
                progressTable = $('#progress-table').DataTable({
                    autoWidth: false,
                    dom: '<"wrapper">t',
                    data: dataObject.steps,
                    order: [],
                    columns: [
                        { data: 'step', title: 'Step', width: '30%', sortable: false },
                        { data: 'substepIndex', title: 'Status', width: '15%', sortable: false, 
                            createdCell: function(td, cellData, record) {
                                if (record['status'] === "Complete") {
                                    $(td).html($('<span>')
                                        .addClass('label label-success')
                                        .text('Complete'));
                                } else if (record['status'] === "Processing") {
                                    $(td).html($('<span>')
                                        .addClass('label label-info')
                                        .text('Processing'));
                                } else if (record['status'] === "Pending") {
                                    $(td).html($('<span>')
                                        .addClass('label label-default')
                                        .text('Pending'));
                                } else if (record['status'] === "Error") {
                                    $(td).html($('<span>')
                                        .addClass('label label-danger')
                                        .text('Error'));
                                }
                            } 
                        },
                        { data: 'substepTotal', title: 'Progress', width: '55%', sortable: false,
                            createdCell: function(td, cellData, record) {
                                var width = (record['substepIndex'] / record['substepTotal'])*100;
                                var progressBarClass = (width === 100) ? 'progress-bar-success' : 'progress-bar-info';
                                var text = record['substepIndex'] + ' / ' + record['substepTotal'];
                                $(td).html(
                                    $('<div>').addClass('progress')
                                        .append($('<div>').addClass('progress-bar '+progressBarClass)
                                            .attr('role', 'progressbar')
                                            .attr('aria-valuemin', record['substepIndex'])
                                            .attr('aria-valuenow', 'progressbar')
                                            .attr('aria-valuemax', record['substepTotal'])
                                            .attr('style', 'width: '+width+'%;'))
                                        .append($('<div>').addClass('progress-text')
                                            .text(text))
                                );
                            }
                        }
                    ]
                });
            }
            
            function checkProgress() {
                // Continuously check the installation status until it is finished or an error occurs
                var checkProgressId = setInterval(function() {
                    // trigger the installation by sending the request to the server
                    KineticSr.app.ajax({
                        url: "progress",
                        type: "GET",
                        dataType: "json",
                        timeout: "1000",
                        success: function(object, textStatus, jqXHR) {
                            // Clear any error messages
                            $("#statusMessage").addClass("removed").text("");
                            // Update the installation progress
                            updateTable(object);
                            // if complete or error
                            if (object.status === "Complete" || object.status === "Error") {
                                var status = object.status;
                                // Stop checking progress
                                clearInterval(checkProgressId);
                                // Enable the navigation buttons
                                $("button").attr("disabled", false);
                                // Show the final status in the statusMessage element
                                if (status === "Complete") {
                                    $("#statusMessage")
                                        .removeClass("removed")
                                        .removeClass("alert-danger")
                                        .addClass("alert-success")
                                        .html('<%=completeMessage%>');
                                } else {
                                    $("#statusMessage")
                                        .removeClass("removed")
                                        .html('Errors were encountered during installation.');
                                }
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            // Show the error message
                            var message = jqXHR.status === 0 ? "Could not update progress, the server didn't respond." : jqXHR.responseText;
                            $("#statusMessage").removeClass("removed").text(message);
                        }
                    });
                }, 1000);
            }
    
            $(function() {
                drawTable(<%=JsonUtils.toJsonString(dataMap)%>);
                checkProgress();
            });
        </script>
    </jsp:attribute>
</tag:installer>
