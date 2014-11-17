/**
 * Created with IntelliJ IDEA.
 * User: kegbuna
 * Date: 7/11/14
 * Time: 11:39 AM
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function()
{
    $('.toggle-worklogs').on('click', function()
    {
        var ticket = $(this).attr('data-ticket');
        var $worklogs = $('#Worklogs-' + ticket);
        var currentStatus = $(this).find('.toggle-text').text();
        //toggle it
        if (currentStatus == "View")
        {
            $(this).find('.toggle-text').text("Hide");
            $worklogs.removeClass('hide').removeClass('fadeOutUp');
            $worklogs.addClass('fadeInDown');
            //console.log('showing');
        }
        else
        {
            $(this).find('.toggle-text').text("View");
            $worklogs.removeClass('fadeInDown').addClass('fadeOutUp');
            setTimeout(function ()
            {
                $worklogs.addClass('hide');
            }, 200);
            //console.log('hiding');
        }
    });

    $('.new-worklog').on('click', function()
    {

        var ticket = $(this).attr('data-ticket');
        var $worklogPanel = $('#WLPanel-' + ticket);

        $worklogPanel.removeClass('zoomOut hide');

        $worklogPanel.addClass('zoomIn');
    });

    $('.worklog-submit').on('click', function()
    {
        var $pageQuestions = $('#pageQuestionsForm');
        var data = {};
        var $panel = $("#WLPanel-" + $(this).attr('data-ticket'));
        var $text = $panel.find('.worklog-text');
        data['id'] = $(this).attr('data-ticket');
        data['Form'] = $panel.attr('data-form');
        data[$text.attr('data-field')] = $text.val();
        data['id-field'] = $panel.attr('data-field');
        data['1000000655'] = "Web";
        data['1000000761'] = "Public";
        data['1000000182'] = $(this).attr('data-ticket');
        data['1000000159'] = BUNDLE.config.user;
        $.ajax(
        {
            url: 'WorklogCreate',
            method: 'POST',
            data: data,
            success: function (result)
            {
                console.log(result == "SUCCESS");
                $text.val('');
                $panel.removeClass('zoomIn').addClass('zoomOut');
                setTimeout(function()
                {
                    $panel.addClass('hide');
                }, 500);

            },
            error: function (error)
            {
                console.log(error.responseText);
            }
        });
    });

    $('.worklog-cancel').on('click', function()
    {
        //console.log("Did this click");
        var $panel = $("#WLPanel-" + $(this).attr('data-ticket'));
        var $text = $panel.find('.worklog-text');
        $text.val('');
        $panel.removeClass('zoomIn').addClass('zoomOut');
        setTimeout(function()
        {
            $panel.addClass('hide');
        }, 500);

    });
});