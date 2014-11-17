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


SubmissionTable.start = function ()
{
    Column.Helpers.Table.initialize($('#submissionTable'), ['Request Id', 'Request Display Name', 'Requested For', 'Submitted', 'Display Status'], false);
    var $subTable = Column.Helpers.Table['submissionTable'];
    var urlParams = getUrlParameters();


    if (typeof urlParams.type == "undefined")
    {
        urlParams.type = "requests";

    }

    var reloadTable = function()
    {
        var index = 0;
        var limit = 0;
        var sortOrderField = "Request Id";
        var sortOrder = "DESC";
        var type = "requests";

        var urlParams = getUrlParameters();
        var status = "Open";
        if (typeof urlParams['ticketstatus'] != "undefined")
        {
            status = urlParams['ticketstatus'];
        }
        if (urlParams.hasOwnProperty('type'))
        {
            type = urlParams['type'];
        }
        var url = 'themes/flat-bootstrap3/packages/submissions/interface/callbacks/submissions.json.jsp?ticketstatus=' + status + '&offset=' + index + '&limit=' + limit + '&orderField=' + sortOrderField + '&order=' + sortOrder + "&type=" + type;
        if (typeof urlParams['submitter'] != "undefined")
        {
            url += "&submitter=" + urlParams['submitter'];
        }
        if (typeof urlParams['ticketid'] != "undefined")
        {
            url += "&ticketid=" + urlParams['ticketid'];
        }
        //get the magnifying glass spinnin'
        $('#filterButtonHolder').find('button i').addClass('fa-spin');
        $.ajax(
        {
            url: url,
            success: function (data)
            {
                $subTable.clear();

                var rows = data.data;

                //Customize the rows before using them in the table
                for (var row in rows)
                {
                    if (rows[row]["Request Display Name"] == null)
                    {
                        rows[row]["Request Display Name"] = rows[row]["Originating Name"];
                    }
                }
                $subTable.rows.add(rows);

                $subTable.draw();

            },
            error: function(data)
            {

            },
            complete: function()
            {
                //stop the spin
                $('#filterButtonHolder').find('button i').removeClass('fa-spin');
            }
        });
    };

    reloadTable();

    $('#filterBar').find('input').on('keyup', function(e)
    {
        var currentUrl = window.location.href;
        var ticketNumber = $('#ticketNumber').val();
        var storeNumber = $('#storeNumber').val();
        if (e.keyCode == 13)
        {
            var nextUrl = Column.Helpers.Url.updateQueryStringParameter(currentUrl, "ticketstatus", $('#statusFilter').val());

            if (ticketNumber.length > 0)
            {
                nextUrl = Column.Helpers.Url.updateQueryStringParameter(nextUrl, "ticketid", ticketNumber);
            }
            else
            {
                nextUrl = Column.Helpers.Url.removeParam("ticketid", nextUrl);
            }
            if (storeNumber.length > 0)
            {
                nextUrl = Column.Helpers.Url.updateQueryStringParameter(nextUrl, "submitter", storeNumber);
            }
            else
            {
                nextUrl = Column.Helpers.Url.removeParam("submitter", nextUrl);
            }

            window.history.replaceState(null, null, nextUrl);

            reloadTable();
        }
    });

    $('#filterButtonHolder').on('click', function(e)
    {
        var currentUrl = window.location.href;
        var ticketNumber = $('#ticketNumber').val();
        var storeNumber = $('#storeNumber').val();
        var nextUrl = Column.Helpers.Url.updateQueryStringParameter(currentUrl, "ticketstatus", $('#statusFilter').val());
        if (typeof ticketNumber != "undefined")
        {
            if (ticketNumber.length > 0)
            {
                nextUrl = Column.Helpers.Url.updateQueryStringParameter(nextUrl, "ticketid", ticketNumber);
            }
            else
            {
                nextUrl = Column.Helpers.Url.removeParam("ticketid", nextUrl);
            }
        }
        if (typeof storeNumber != "undefined")
        {
            if (storeNumber.length > 0)
            {
                nextUrl = Column.Helpers.Url.updateQueryStringParameter(nextUrl, "submitter", storeNumber);
            }
            else
            {
                nextUrl = Column.Helpers.Url.removeParam("submitter", nextUrl);
            }
        }

        window.history.replaceState(null, null, nextUrl);

        reloadTable();

    });


};

$(document).ready(function()
{
    SubmissionTable.start();
    var $subTable = Column.Helpers.Table['submissionTable'];

    //This code ensures that the right option is showing on the status filter dropdown
    if (getUrlParameters().hasOwnProperty('ticketstatus'))
    {
        $('#statusFilter option').removeAttr('selected');
        $('#statusFilter option[value='+ getUrlParameters()['ticketstatus'] + ']').attr('selected','');
    }

    //This listens to the rows for a click
    $('#submissionTable').find('tbody').on('click', 'tr', function ()
    {
        //This is the ticket's row data
        var data = $subTable.row(this).data();

        var urlParams = getUrlParameters();
        var targetUrl;
        //console.log(urlParams.type);
        if (urlParams.type == "requests" || typeof urlParams.type == "undefined" )
        {
            if (urlParams.ticketstatus == "Draft")
            {
                targetUrl = 'DisplayPage?csrv=' + data.Id;
            }
            else
            {
                targetUrl = 'DisplayPage?name=BedBath-SubmissionsActivity&id=' + data.Id;
            }

        }
        else if (urlParams.type == "approvals")
            targetUrl = 'DisplayPage?csrv=' + data.Id;

        //opens in new window
        //window.open(targetUrl);
        //to open in same window
        window.open(targetUrl,"_self");
    });
});