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
    $subTable.dataTable(
    {
        "data": [
            ["1234", "Open", "Summary of Ticket", "11/1/2014","N/A"],
            ["1234", "Open", "Summary of Ticket", "11/2/2014","N/A"],
            ["1234", "Closed", "Summary of Ticket", "11/3/2014","N/A"],
            ["1234", "Open", "Summary of Ticket", "11/4/2014","N/A"]
        ],
        "columns": SubmissionTable.columns
    });
};

$(document).ready(function()
{
    SubmissionTable.start();
});