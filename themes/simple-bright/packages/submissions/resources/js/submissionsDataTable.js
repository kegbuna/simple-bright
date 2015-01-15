/**
 * Created with IntelliJ IDEA.
 * User: kegbuna
 * Date: 4/10/14
 * Time: 2:41 PM
 * To change this template use File | Settings | File Templates.
 */

var SubmissionTable = {};

SubmissionTable.status = "Open";
SubmissionTable.index = 0;
SubmissionTable.sortOrderField = "Request Id";
SubmissionTable.sortOrder = "DESC";
SubmissionTable.ticketId = null;
SubmissionTable.submitter = null;
SubmissionTable.urlParams = getUrlParameters();
SubmissionTable.filter = {
    status: "Open",
    orderField: "Submit Date",
    order: "DESC",
    ticketId: null,
    limit: 0,
    offset: 0,
    type: "requests",
    sync: function(params)
    {
        for (var param in params)
        {
            this[param] = params[param];
        }
        console.log(this);
    }
};
SubmissionTable.syncFilter = function()
{

};
SubmissionTable.columns = [
    {"title": "Ticket ID"},
    {"title": "Status"},
    {"title": "Summary"},
    {"title": "Date Submitted"},
    {"title": "Date Closed"}
];
SubmissionTable.start = function ()
{
    var $subTable = $('#submissionTable');
    var tableData = {};

    $.ajax(
    {
        url: "themes/simple-bright/packages/submissions/interface/callbacks/submissions.json.jsp",
        data: SubmissionTable.filter,
        method: "GET",
        dataType: "json",
        success: function(submissions)
        {
            var columnNames = [];
            var records = [];

            for (var name in submissions.data[0])
            {
                columnNames.push({"title": name});
            }
            for (var recordIndex in submissions.data)
            {
                var currentRecord = [];

                for (var fieldIndex in columnNames)
                {
                    var fieldName = columnNames[fieldIndex].title;
                    var finalValue = "";
                    //make sure it isn't null
                    if (typeof submissions.data[recordIndex][fieldName] != "object")
                    {
                        finalValue = submissions.data[recordIndex][fieldName];
                    }

                    currentRecord.push(finalValue);
                }
                records.push(currentRecord);
            }

            var fieldReference = [];
            for (var tempIndex in submissions.data[0])
            {
                fieldReference.push(tempIndex);
            }
            console.log(fieldReference);
            $subTable.dataTable(
            {
                columns: columnNames,
                data: records,
                columnDefs: [
                {
                    targets: '_all',
                    visible: false
                }
                ],
                "createdRow": function ( row, data, index )
                {
                    $(row).addClass('request-item');
                    var submitDate = new Date(data[fieldReference.indexOf('Submit Date')]);
                    $(row).html('<div class="request-item-header"></div>');
                    var $header = $(row).find('.request-item-header');

                    $header.append('<div class="header-item"><div class="submit-date"><span class="item-label">Submit Date</span><span class="item-value">'+ submitDate.toDateString() +'</span></div></div>');
                    $header.append('<div class="header-item"><div class="template-name"><span class="item-label">Template Name</span><span class="item-value">'+ data[fieldReference.indexOf('Template Name')] +'</span></div></div>');

                    var $body = $('<div class="request-item-body"></div>').appendTo(row);

                    var $info = $('<div class="item-content"></div>').appendTo($body);
                    var $controls = $('<div class="controls"></div>').appendTo($body);

                    $info.append('<div class="request-id"><span class="item-label">Request ID</span><span class="item-value">'+ data[fieldReference.indexOf('Originating Request Id')] +'</span></div>');
                    $info.append('<div class="request-status"><span class="item-label">Status</span><span class="item-value">'+ data[fieldReference.indexOf('Display Status')] +'</span></div>');
                    $info.append('<div class="requested-for"><span class="item-label">Customer</span><span class="item-value">'+ data[fieldReference.indexOf('Requested For')] +'</span></div>');

                    $controls.append('<a href="' + BUNDLE.config.reviewUrl + data[fieldReference.indexOf('Id')] + '" class="action"><i class="action-icon"></i>Review Submission</a>');
                    $controls.append('<a class="action"><i class="action-icon"></i>Send an Update</a>');

                }
            });
        },
        error: function(error, status, thrown)
        {
            console.log("ERROR: ", status, thrown);
        }
    });
    /*$subTable.dataTable(
    {
        "data": [
            ["1234", "Open", "Summary of Ticket", "11/1/2014","N/A"],
            ["1234", "Open", "Summary of Ticket", "11/2/2014","N/A"],
            ["1234", "Closed", "Summary of Ticket", "11/3/2014","N/A"],
            ["1234", "Open", "Summary of Ticket", "11/4/2014","N/A"]
        ],
        "columns": SubmissionTable.columns
    });*/
};

$(document).ready(function()
{
    SubmissionTable.start();
});