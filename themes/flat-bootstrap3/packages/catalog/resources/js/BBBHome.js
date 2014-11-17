/**
 * Created with JetBrains PhpStorm.
 * User: CLMENG
 * Date: 1/27/14
 * Time: 2:16 PM
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function ()
{
    $(".broadcast-link").on("click", function ()
    {
        //console.log("click");
        var $broadcasts = $('#Broadcasts');
        $broadcasts.addClass("fadeOut");
        var $broadcastMessage = $(this).find('.broadcast-message');
        setTimeout(function()
        {
            //todo:: finish this call, add class hide and start the movement of the message
            $broadcasts.addClass('hide').removeClass('fadeOut');
            //console.log($broadcastMessage.html());
            $("#systemStatusHolder").append($broadcastMessage.clone().removeClass("hide").addClass("fadeIn"));
        }, 200);
    });
    $("#systemStatusHolder").on("click", '.broadcast-close', function ()
    {
        //console.log("click");
        var $systemStatusHolder = $('#systemStatusHolder');
        var $broadcasts = $('#Broadcasts');
        var $displayedBroadcast = $systemStatusHolder.children('.broadcast-message');
        //console.log($displayedBroadcast);
        $displayedBroadcast.addClass('fadeOut');
        setTimeout(function ()
        {
            $displayedBroadcast.remove();
            $broadcasts.removeClass('hide').addClass('fadeIn');
        }, 200);
    });


});
var startHome = function ()
{
    var attributes = null;
    var config = {};
    config.model = "Broadcasts";
    config.attributes = null;
    config.qualification = "Available Broadcasts";
    config.sortField = "End Date";
    config.meta =
    {
        order: [encodeURIComponent('<%=attribute["' + config.sortField + '"]%>:ASC')]
    };

    KDHelper.Bridge.search(config, function (result)
    {

        //draw broadcasts
        KDHelper.Render.withTemplate(result.records, "broadcast-holder", "broadcast", "carousel");
    },
    function (result)
    {
        // console.log(result);
    });

    config.model = "Service Item Category";
    config.attributes = ["Category", "CategoryDescription"];
    config.qualification = "by Catalog";
    config.sortField = "Category";
    config.meta =
    {
        order: [encodeURIComponent('<%=attribute["' + config.sortField + '"]%>:ASC')]
    };

    KDHelper.Bridge.search(config, function (result)
    {
        //console.log(result);
        KDHelper.Render.withTemplate(result.records, "tile-holder", "tile", "tile");
    },
    function (result)
    {

    });

};

var startArchive = function ()
{
    var config = {};
    config.model = "Tickets";
    config.attributes = ["Ticket ID", "Description", "Detailed Description",  "Submit Date", "Status"];
    config.qualification = "All Incidents";
    config.sortField = "Ticket ID";
    config.meta =
    {
        order: [encodeURIComponent('<%=attribute["' + config.sortField + '"]%>:DESC')]
    };

    KDHelper.Bridge.search(config, function (result)
        {
            KDHelper.Render.dataTable(result, "ticket-table");
            var oTable = $("#ticket-table").dataTable();
            var opts = {
                lines: 17, // The number of lines to draw
                length: 0, // The length of each line
                width: 5, // The line thickness
                radius: 10, // The radius of the inner circle
                corners: 1, // Corner roundness (0..1)
                rotate: 0, // The rotation offset
                direction: 1, // 1: clockwise, -1: counterclockwise
                color: '#273691', // #rgb or #rrggbb or array of colors
                speed: 0.5, // Rounds per second
                trail: 60, // Afterglow percentage
                shadow: false, // Whether to render a shadow
                hwaccel: true, // Whether to use hardware acceleration
                className: 'spinner', // The CSS class to assign to the spinner
                zIndex: 2e9, // The z-index (defaults to 2000000000)
                top: 'auto', // Top position relative to parent in px
                left: 'auto' // Left position relative to parent in px
            };

            KDHelper.Events.addRowListener("ticket-table", function (tr)
            {
                if (oTable.fnIsOpen(tr))
                {
                    oTable.fnClose(tr);
                }
                else
                {
                    config.row = oTable.fnGetData(tr);
                    config.method = "retrieve";
                    //console.log(config.row);
                    config.model = "Tickets";
                    config.attributes = ["Detailed Description","Description", "Status", "Submit Date"];
                    config.qualification = "by ID";
                    config.parameters =
                    {
                        "Ticket ID" : config.row[0]
                    };

                    var newTr = oTable.fnOpen(tr, '<td>Loading data...</td>');

                    var spinner = new Spinner(opts).spin(newTr);

                    KDHelper.Bridge.search(config, function (result)
                    {
                        spinner.stop();

                        JSON.parse(result.toJson());
                        //console.log(result.toJson());
                        var resultHTML = KDHelper.Render.returnTemplate(JSON.parse(result.toJson()), "details");

                        oTable.fnOpen(tr, resultHTML);
                    });

                }
            });
        },
        function (result)
        {
            //console.log(result);
        });
};