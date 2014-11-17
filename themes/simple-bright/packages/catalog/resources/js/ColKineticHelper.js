/**
 * Created with JetBrains PhpStorm.
 * User: CLMENG
 * Date: 1/28/14
 * Time: 11:22 AM
 * To change this template use File | Settings | File Templates.
 */
var KDHelper = {};
var oTable;
KDHelper.Bridge = {};
KDHelper.Render = {};
KDHelper.Templates = {};
KDHelper.Data = {};
KDHelper.Events = {};
KDHelper.Colors = ['#271493', '#511493', '#936614', '#409314', '#535353', '#433C9B'];

//Load Templates here
/*$.get("resources/partials/broadcastTemplate.html",
function(data)
{
    KDHelper.Templates.broadcast = data;
});

$.get("resources/partials/tileTemplate.html",
function(data)
{
    KDHelper.Templates.tile = data;
});

$.get("resources/partials/detailsTemplate.html",
function(data)
{
    KDHelper.Templates.details = data;
});

$.get("resources/partials/indexTemplate.html",
function(data)
{
    KDHelper.Templates.index = data;
}); */

/* Used to retrieve bridge models - arguments for model, qual, and success function */
KDHelper.Bridge.search = function(config, success, error)
{
    var connector = new KD.bridges.BridgeConnector();

    if (!config.method)
        config.method = "search";
    switch (config.method)
    {
        case "search":
            connector.search(config.model, config.qualification,
            {
                attributes: config.attributes,
                parameters: config.parameters,
                metadata: config.meta,
                success: function(result)
                {
                    success(result);
                },
                error: function(result)
                {
                    error(result);
                }
            });
            break;
        case "retrieve":
            connector.retrieve(config.model, config.qualification,
            {
                attributes: config.attributes,
                parameters: config.parameters,
                metadata: config.meta,
                success: function(result)
                {
                    success(result);
                },
                error: function(result)
                {
                    error(result);
                }
            });
            break;
        case "count":
            connector.count(config.model, config.qualification,
            {
                attributes: config.attributes,
                parameters: config.parameters,
                metadata: config.meta,
                success: function(result)
                {
                    success(result);
                },
                error: function(result)
                {
                    error(result);
                }
            });
            break;

    }



};

KDHelper.Render.withTemplate = function (data, target, templateName, component)
{
    var template;
    var current;
    var index= 0;
    var regEx;
    var config={};
	var colorArray = KDHelper.Colors;
    //TODO: Add Tiles
    switch (component)
    {
        case "carousel":
            $('#'+ target + " .carousel-indicators").html('');
            $('#'+ target + " .carousel-inner").html('');
            break;
    }
    for (entry in data)
    {
        template = KDHelper.Templates[templateName];
        current = data[entry].attributes;
		if (current.hasOwnProperty('Category'))
		{
			current.className = current.Category.replace(new RegExp("[,. ]", 'g'), '');

		}
        for (name in current)
        {
            regEx = new RegExp("{{"+name+"}}", 'g');

            template = template.replace(regEx,current[name]);
        }
        //console.log(template);
        switch (component)
        {
            case "carousel":
                $('#'+ target + " .carousel-inner").append(template);
                $('#'+ target + " .carousel-indicators").append('<li data-target="'+target+'" data-slide-to='+index+' class=""></li>');
                Holder.run();
                //make first child active - both carousel items and indicators
                $('#'+ target + " .carousel-inner>:first-child").addClass("active");
                $('#'+ target + " .carousel-indicators>:first-child").addClass("active");
                break;
            case "tile":
				var color = colorArray.pop();
				console.log(color);
				template = template.replace('<i', '<i style=" color: ' + color + '" ');
				//template = template.replace('<h2', '<h2 style=" color: ' + color + '" ');

				$('#' + target).append(template);
                config.target = $('#' + target + " :last");
                config.description = current;
                KDHelper.Render.toolTip(config);
                break;
            case "details":
                $('#' + target).append(template);
                break;
        }
		if (colorArray.length == 0)
		{
			colorArray = KDHelper.Colors;
		}
        index++;
    }

};

KDHelper.Render.returnTemplate = function(record, templateName)
{
    var template = KDHelper.Templates[templateName];
    var regEx;
    var recAttributes = record.attributes;
    if (template)
    {
        for (name in recAttributes)
        {
            regEx = new RegExp("{{"+name+"}}", 'g');
            //console.log(name);
            //console.log(record[name]);
            template = template.replace(regEx,recAttributes[name]);
        }
    }
    else
    {
        template = "Data problem.";
    }
    return template;
};

KDHelper.Data.convertToDataTable = function(fields, records)
{

};

KDHelper.Render.dataTable = function(data, target)
{
    var jsonData = JSON.parse(data.toJson());
    var aoColumns = [];

    for (x in jsonData.fields)
    {
        aoColumns.push({"sTitle": jsonData.fields[x]});
    }

    $('#' + target).dataTable(
    {
        "aaData": jsonData.records,
        "aoColumns": aoColumns,
        "bFilter":false,
        "bLengthChange": false,
        "aoColumnDefs": null,
        "bLengthChange": false,
        "bFilter": false,
        "bDestroy": true,
        "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull )
        {
            $('td:eq(3)', nRow).html(moment($('td:eq(3)', nRow).text()).format("MM-DD-YYYY HH:mm:ss"));
        }

    });
};

KDHelper.Render.toolTip = function (config)
{
    config.target.tooltip(
    {
        placement: 'top',
        container: 'body'
    });
};

KDHelper.Events.addRowListener = function(table, action)
{
    $('#' + table + " tbody tr").click(function ()
    {
        action(this);
    });
};