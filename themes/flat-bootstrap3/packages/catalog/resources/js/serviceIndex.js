/**
 * Created with JetBrains PhpStorm.
 * User: CLMENG
 * Date: 2/3/14
 * Time: 9:35 AM
 * To change this template use File | Settings | File Templates.
 */

function startIndex()
{
    var indexType = $('#indexType');
    indexType.find('li').click(function ()
    {
        $(this).siblings().removeClass('active');
        $(this).addClass('active');
        switch ($(this).id)
        {
            case "alpha":
                $('#letters').show();
                break;
        }
    });

    KDIndex.updateData();

}

KDIndex = {};
KDIndex.alphabet = "abcdefghijklmnopqrstuvwxyz";
KDIndex.activeLetters = [];
KDIndex.updateData = function()
{
    var config = {};
    config.method = "search";

    config.model = "Service Items";
    config.attributes = ["Survey Template Name", "Category", "Survey Description", "Anonymous URL"];
    config.qualification = "by Name";
    config.parameters = null;
    config.meta =
    {
        order: [encodeURIComponent('<%=attribute["Survey Template Name"]%>:ASC')]
    };

    KDHelper.Bridge.search(config, function (result)
    {
        var resultJson = JSON.parse(result.toJson());
        var records = resultJson.records;
        var template;
        for (current in records)
        {
            currentRecord = records[current];
            template = KDHelper.Render.returnTemplate(result.records[current], "index");

            if (KDIndex.activeLetters.indexOf(currentRecord[0][0]) < 0)
            {
                $('#indexNav').append('<a class="btn btn-default" href="#letter' + currentRecord[0][0] + '"><span class="navLetters">'+ currentRecord[0][0] +'</span></a>');
                KDIndex.activeLetters.push(currentRecord[0][0]);
                $('#alphaIndex').append('<div id="letter'+ currentRecord[0][0] + '" ><h2>' + currentRecord[0][0] + '</h2></div>' );
            }
            $('#letter' + currentRecord[0][0]).append(template);



            for (letterIndex in KDIndex.alphabet)
            {

            }
        }
        console.log(records);
    },
    function (result)
    {
        console.log(result);
    });

	$(".serviceType").click(function ()
	{
		var choice = $(this).attr('id');
		console.log(choice);

		switch (choice)
		{
			case "category":
				$('#indexNav, #alphaIndex').hide();
				break;
			case "alpha":
				$('#indexNav, #alphaIndex').show();
				break;
		}
	});
};
