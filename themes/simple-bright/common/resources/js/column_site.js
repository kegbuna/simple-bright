/**
 * Created by kegbuna on 12/4/2014.
 *
 * This is the base js file to be used across the whole shite.
 * It will contain functionality for common catalog pages as well as some generic data stuff
 */


$(document).ready(function()
{
    //Search area functionality
    $('#SearchInput').on('focus blur', function (e)
    {
        var $container = $(this).parent();
        if (e.type == "focus")
        {
            $container.find('a.search-button, input.search-input').addClass('active');
        }
        if (e.type == "blur" && $(this).val().length < 1)
        {
            $container.find('a.search-button, input.search-input').removeClass('active');
        }
    });

    //fire on anything and let me know

});

//My new object will be called keg.. for kinetic Extension.. gift. ken egbuna

var keg = {};
keg.form = {};
keg.form.setCustomerInfo = function(data)
{
    var $customerBox = $('#customerBox');
    var $customerInfo = $customerBox.find('.person-info-box');
    $customerInfo.html('');
    $customerInfo.append('<span class="person-info-box-value">' + data['Req First Name'] + ' ' + data['Req Last Name'] + '</span>');
    $customerInfo.append('<span class="person-info-box-value"><abbr title="Phone Number">P:</abbr> ' + data['Req Phone Number'] + '</span>');
    $customerInfo.append('<span class="person-info-box-value"><a href="mailto:' + data['Req Email Address'] + '">' + data['Req Email Address'] + '</a></span>');
    KD.utils.Action.setQuestionValue('ReqFor_Login ID', data['Req Login ID']);
    KD.utils.Action.setQuestionValue('ReqFor_First Name', data['Req First Name']);
    KD.utils.Action.setQuestionValue('ReqFor_Last Name', data['Req Last Name']);
    KD.utils.Action.setQuestionValue('ReqFor_Email', data['Req Email Address']);
};
//This function will be fired at the beginning of any service item to provide some additional functionality
keg.startTemplate = function ()
{
    initializeCustomerContact();

    //Customer/Contact boxes
    function initializeCustomerContact()
    {
        var customerData = {};
        var $submitterBox = $('#submitterBox');
        var $customerBox = $('#customerBox');
        var $submitterInfo = $submitterBox.find('.person-info-box');
        var $customerInfo = $customerBox.find('.person-info-box');
        $('div.templateSection[label=Submitter] div.questionAnswer .answerValue').each(function ()
        {
            customerData[$(this).attr('label')] = $(this).val();
        });
        console.log(customerData);

        $submitterInfo.html('');

        $submitterInfo.append('<span class="person-info-box-value">' + customerData['Req First Name'] + ' ' + customerData['Req Last Name'] + '</span>');
        $submitterInfo.append('<span class="person-info-box-value"><abbr title="Phone Number">P:</abbr> ' + customerData['Req Phone Number'] + '</span>');
        $submitterInfo.append('<span class="person-info-box-value"><a href="mailto:' + customerData['Req Email Address'] + '">' + customerData['Req Email Address'] + '</a></span>');

        if (KD.utils.Action.getQuestionValue('ReqFor_Login ID') == "" || KD.utils.Action.getQuestionValue('ReqFor_Login ID') == $submitterBox.data('user')['Req Login ID'])
        {
            keg.form.setCustomerInfo(customerData);
        }

        $('#changeCustomer').on('click', function()
        {
            e.preventDefault();


        });
    }
};