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
    }).on('keyup', function(e)
    {

        var $container = $(this).parent();
        if (e.keyCode == 13)
        {
            window.location.href = BUNDLE.config.searchUrl + "&q=" + $(this).val();
        }
    });

    $('#AnnouncementsBox .item-summary a').on('click', function(e)
    {
        e.preventDefault();
        $(this).siblings().toggleClass('hide');
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

// Used to attach a dynamic auto complete menu to a question, using a class prefix, a model, a qualification, a boolean useAnswer (meaning should the parameter be the answer
keg.form.attachTypeAhead = function(prefix, model, qual, useAnswer)
{

};

//puts a listener on all dropdowns, radios, and checkboxes and will hide/show make questions required as needed
keg.form.startQuestionListeners = function()
{
    $('.qTrigger select.answerValue.answerSelect').on('change', function()
    {
        //get all the possible answers
        var possibleAnswers = [];
        var possibleClasses = [];

        $(this).find('option').map(function (index, domElement)
        {
            //skip the empty value
            if (index > 0)
            {
                possibleAnswers.push($(this).val());
                possibleClasses.push($(this).val().replace(/[^a-zA-Z:]/g, ''));
            }

        });

        console.log("Possible: ", possibleAnswers);
        //console.log("Actual: ", $(this).val());

        var currentAnswer = $(this).val();
        //This is what we're going to reveal
        var targetClass = $(this).val().replace(/[^a-zA-Z:]/g, '');

        console.log("Target Class: ", targetClass);

        //create array of missed answers
        //var missedAnswers = new Array(possibleAnswers);
        var missedClasses = possibleClasses.slice(0);
        if (targetClass != "")
        {
            //if we have an answer, remove it
            var answerIndex = possibleAnswers.indexOf(currentAnswer);
            //missedAnswers.splice(answerIndex, 1);
            missedClasses.splice(answerIndex, 1);

            //reveal the targets
            $('.'+ targetClass).each(function ()
            {
                $(this).removeClass('qHide').fadeIn();

                //make required questions required
                if ($(this).hasClass('questionLayer') && $(this).hasClass('req'))
                {
                    var qLabel = $(this).attr('label');
                    KD.utils.Action.makeQuestionRequired(qLabel);
                }
            });
        }

        //hide the missedAnswers, start by creating a query to seek them out
        var missedAnswerQuery = "";
        var newQuery;
        console.log(missedClasses);
        for (var i in missedClasses)
        {
            newQuery = i > 0 ? ',' : '';

            newQuery += "." + missedClasses[i].toString();
            missedAnswerQuery += newQuery;
        }
        console.log(/*"Missed Classes: ",*/ missedAnswerQuery);

        $(missedAnswerQuery).each(function()
        {
            $(this).fadeOut();
            if ($(this).hasClass('questionLayer') && $(this).hasClass('req'))
            {
                KD.utils.Action.makeQuestionOptional($(this).attr('label'));
            }
        });
    });
};

//This function will be fired at the beginning of any service item to provide some additional functionality
keg.startTemplate = function ()
{
    initializeCustomerContact();
    keg.form.startQuestionListeners();

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

        $submitterInfo.html('');

        $submitterInfo.append('<span class="person-info-box-value">' + customerData['Req First Name'] + ' ' + customerData['Req Last Name'] + '</span>');
        $submitterInfo.append('<span class="person-info-box-value"><abbr title="Phone Number">P:</abbr> ' + customerData['Req Phone Number'] + '</span>');
        $submitterInfo.append('<span class="person-info-box-value"><a href="mailto:' + customerData['Req Email Address'] + '">' + customerData['Req Email Address'] + '</a></span>');

        if (KD.utils.Action.getQuestionValue('ReqFor_Login ID') == "" || KD.utils.Action.getQuestionValue('ReqFor_Login ID') == KD.utils.Action.getQuestionValue('Req Login ID'))
        {
            keg.form.setCustomerInfo(customerData);
        }

        $('#changeCustomer').on('click', function(e)
        {
            e.preventDefault();
            var $this = $(this);
            var $container = $('#customerBox').find('.person-info-box');
            $this.toggleClass('person-info-change').toggleClass('person-info-close');


            // This means the box is closed
            if ($this.hasClass('person-info-change'))
            {
                $container.find('.person-info-search').remove();
                $container.find('.person-info-box-value').show();
            }
            /// this means the box is open
            else if ($this.hasClass('person-info-close'))
            {
                var personSearchHTML = '<div class="person-info-search"><input type="text" placeholder="Search here for users.." class="person-info-search-input"><ul class="person-info-search-list"></ul></div>'
                $container.append(personSearchHTML);
                $container.find('.person-info-box-value').hide();
                var $inputField = $container.find('.person-info-search-input');
                //focus on the input field this is ridiculous
                $inputField.focus();

                //LEt's listen for input on the input field
                $inputField.on('keyup', function()
                {
                    var terms = $(this).val().split(' ');
                    var qualification = '';
                    var $results = $('#customerBox').find('.person-info-search-list');
                    for (var i in terms)
                    {
                        if (qualification.length > 0)
                        {
                            qualification += " OR ";
                        }
                        qualification += '(\'First Name\' LIKE \"%' + terms[i] + '%\"';
                        qualification += ' OR \'Last Name\' LIKE \"%' + terms[i] + '%\")';
                        //qualification += ' OR \'Remedy Login ID\' LIKE \"%' + terms[i] + '%\"';
                    }
                    if ($(this).val().length > 0)
                    {
                        searchPeople(qualification, function (data)
                        {
                            populateResults(data);
                        });
                    }
                    else
                    {
                        $inputField.focus();
                        $results.html('');
                    }
                });
            }

            var connector = new KD.bridges.BridgeConnector({templateId: clientManager.templateId});

            /* This performs a search against the Bridge model people
             *  The data will then be used to populate the menu
             * */
            function searchPeople(qual, success, error)
            {
                var $results = $('#customerBox').find('.person-info-search-list');
                $results.html('<i class="search-indicator-icon"></i>');
                connector.search("People", "Raw",
                {
                    attributes: null,
                    parameters:
                    {
                        'qualification' : encodeURIComponent(qual)
                    },
                    metadata:
                    {
                        "order": [encodeURIComponent('<%=attribute["Last Name"]%>:ASC')]
                    },
                    success: success,
                    error: error
                });
            }

            function populateResults(people)
            {
                var $results = $('#customerBox').find('.person-info-search-list');

                $results.html('');

                if (people.records.length == 0)
                {
                    $results.html('No Results..')
                }
                else
                {
                    //using each for ie8 sake
                    $(people.records).each( function(i, el)
                    //for (var i in people.records)
                    {
                        var currentRecord = people.records[i].attributes;

                        $results.append('<li data-index="' + i + '" class="person-info-search-result"><p class="name">' + currentRecord['First Name'] + ' ' + currentRecord['Last Name'] + ' (' + currentRecord['Login ID'] + ')</p><p class="email">' + currentRecord['Email Address'] + '</p></li>');
                    });
                    $results.find('.person-info-search-result').on('click', function(e)
                    {
                        var newCustomer = {};
                        var selectedRecord = people.records[$(this).attr('data-index')].attributes;

                        newCustomer['Req Login ID'] = selectedRecord['Login ID'];
                        newCustomer['Req First Name'] = selectedRecord['First Name'];
                        newCustomer['Req Last Name'] = selectedRecord['Last Name'];
                        newCustomer['Req Email Address'] = selectedRecord['Email Address'];
                        newCustomer['Req Phone Number'] = selectedRecord['Phone Number'];

                        keg.form.setCustomerInfo(newCustomer);
                        $this.toggleClass('person-info-change').toggleClass('person-info-close');
                        $container.find('.person-info-search').remove();
                        $container.find('.person-info-box-value').show();
                    });
                }
            }
        });
    }


};

keg.Request = {};

keg.Request.retrieveINC = function()
{
    //http://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
    //generating guid used as the instance id on the num gen form
    var guid = (function() {
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000)
                .toString(16)
                .substring(1);
        }
        return function() {
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                s4() + '-' + s4() + s4() + s4();
        };
    })();

    //if the question is empty and this is not a Review
    if (KD.utils.Action.getQuestionValue("Incident Number") == "" && typeof KD.utils.Review == "undefined")
    {
        var data = {};
        data['Form'] = "HPD:CFG Ticket Num Generator";
        data['179'] = guid();
        data['id'] = "GO";

        $.ajax(
            {
                url: 'WorklogCreate',
                method: 'POST',
                data: data,
                success: function (result)
                {
                    var resultData = JSON.parse(result);
                    KD.utils.Action.setQuestionValue("Incident Number", resultData.message);
                },
                error: function (error)
                {
                    console.log(error);
                }
            });
    }
};

// Used in Send an update, sets the ticket number question to the id in the url
keg.Request.setQuestionsFromParams = function ()
{
    var params = getUrlParameters();

    if (params.hasOwnProperty('id'))
    {
        KD.utils.Action.setQuestionValue('Ticket Number', params['id']);
    }
};

/* Take care of ie8 indexOf */
if (!Array.prototype.indexOf)
{
    Array.prototype.indexOf = function(item)
    {
        return $.inArray(item, this);
    }
}