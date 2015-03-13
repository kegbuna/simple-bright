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

//Kinetic Execution Guide.. dumb name smart results

var keg = {};
keg.form = {};

//sets the customer's information, but you need to pass in a solid data object
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
//search people
keg.form.searchPeople = function (connector, query, success, error)
{
    //tokenize by spaces
    var terms = query.split(' ');

    var qualification = "";

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

    connector.search("People", "Raw",
    {
        attributes: null,
        parameters:
        {
            'qualification' : encodeURIComponent(qualification)
        },
        metadata:
        {
            "order": [encodeURIComponent('<%=attribute["Last Name"]%>:ASC')]
        },
        success: success,
        error: error
    });
};

//puts a listener on all dropdowns, radios, and checkboxes and will hide/show make questions required as needed. Also responsible for special question types
keg.form.startQuestionListeners = function()
{
    // This is for listening to selects and revealing their parts
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

        //console.log("Actual: ", $(this).val());

        var currentAnswer = $(this).val();
        //This is what we're going to reveal
        var targetClass = $(this).val().replace(/[^a-zA-Z:]/g, '');

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

        for (var i=0; i< missedClasses.length; i++)
        {
            newQuery = i > 0 ? ',' : '';

            newQuery += "." + missedClasses[i].toString();
            missedAnswerQuery += newQuery;
        }

        // use the query to do some hiding
        $(missedAnswerQuery).each(function()
        {
            // make sure this doesn't have the target answer as well i.e. is revealed by multiple answers
            if (!$(this).hasClass(targetClass))
            {
                $(this).fadeOut();
                if ($(this).hasClass('questionLayer') && $(this).hasClass('req'))
                {
                    KD.utils.Action.makeQuestionOptional($(this).attr('label'));
                }
            }
        });
    });

    // assisting with writing a list of people, cache the selector
    var $peopleList = $('.PeopleList.questionLayer');

    //no reason to do any work if we don't have any questions to use it on
    if ($peopleList.length > 0)
    {
        //we're going to use the People bridge, create one connector to use for all of the below objects.. hope this works
        var connector = new KD.bridges.BridgeConnector();

        $peopleList.each(function ()
        {
            //the current question's label
            var questionLabel = $(this).attr("label");

            //the answer "area"
            var $questionAnswer = $(this).find('.questionAnswer');

            // the actual value.. i.e. the input/textarea/button etc
            var $answerValue = $(this).find('.answerValue');

            //hide this, we're only using it for storage
            $answerValue.addClass('hide');

            //add the new input to the question answer area
            var $newInputDiv = $('<div class="user-search"><input type="text" placeholder="Add a user.." class="search-input"><ul class="search-list"></ul></div>').appendTo($questionAnswer);

            var $newInput = $newInputDiv.find('input.search-input');

            var $resultList = $newInputDiv.find('ul.search-list');
            //set the width of the results to that of the input, also let's place it on the input
            $resultList.css(
            {
                'width': $newInput.css('width')
            });

            //on input changing value, update the ul
            $newInput.on('change', function (e)
            {
                $resultList[0].innerHTML = '<i class="indicator-icon"></i>';

                keg.form.searchPeople(connector, $(this).val(), function(data)
                {
                    var peopleArray = [];
                    data.records.forEach(function (record)
                    {
                        //build our array of attributes
                        peopleArray.push(record.attributes);
                    });

                    $resultList[0].innerHTML = getListElements(peopleArray);
                })
            });


            // result list listener
            $resultList.on('click','.result', function(e)
            {
                var selectedUser = $(this).attr('data-user');

                addUser(selectedUser);

                $resultList.html("");
                $newInput.val('');

            });

            //Listener for popping users off and removing them from the list, i call it this way to mak esure it is always listening
            $questionAnswer.on('click', '.selected-user>.close-button', function (e)
            {
                //get the close button's parent's value, we'll need it to remove the right answer
                var removedUser = $(this).parent().attr('data-value');
                $(this).parent().fadeOut("slow", function()
                {
                    removeUser(removedUser);
                });
            });

            //Now that we have all the listeners set up, let's call draw once for good measure, just in case we're opening a draft back up
            draw();

            //utility functions used throughout this component
            function getListElements(data)
            {
                var list = "";

                data.forEach(function(currentRecord)
                {
                    list += '<li data-user="'+ currentRecord['Login ID'] +'" data-index="' + currentRecord["Person ID"] + '" class="result"><p class="name">' + currentRecord['First Name'] + ' ' + currentRecord['Last Name'] + ' (' + currentRecord['Login ID'] + ')</p><p class="email">' + currentRecord['Email Address'] + '</p></li>'
                });

                return list;
            }

            function addUser(user)
            {
                var currentAnswers = getAnswerArray();

                if (currentAnswers.indexOf(user) == -1)
                {
                    currentAnswers.push(user);
                }

                KD.utils.Action.setQuestionValue(questionLabel, currentAnswers.join());

                draw();
            }

            function removeUser(user)
            {
                var currentAnswers = getAnswerArray();

                currentAnswers.splice(currentAnswers.indexOf(user), 1);

                KD.utils.Action.setQuestionValue(questionLabel, currentAnswers.join());

                draw();
            }

            function draw()
            {
                var currentAnswers = getAnswerArray();

                $questionAnswer.find('.selected-user').remove();

                var newHTML = '';

                currentAnswers.forEach(function (answer)
                {
                    newHTML += '<div data-value="' +  answer + '" class="selected-user">'+ answer +' <i class="close-button"></i></div>'
                });

                $questionAnswer.append(newHTML);
            }

            function getAnswerArray()
            {
                var answerArray = [];

                if (KD.utils.Action.getQuestionValue(questionLabel).length > 0)
                {
                    answerArray = KD.utils.Action.getQuestionValue(questionLabel).split(',');
                }

                return answerArray;
            }
        });


        //Was going to try to use twitter typeahead, but it won't work very well here..
        /*connector.search("People", "All Enabled",
        {
            attributes: null,
            parameters: null,
            metadata: null,
            success: function (RecordList)
            {
                var recordArray = RecordList.records;

                var peopleArray = [];

                //convert KD RecordList objects to array of their attributes
                recordArray.forEach(function (record)
                {
                    peopleArray.push(record.attributes);
                });

                var engine = new Bloodhound(
                {
                    name: 'people',
                    local: peopleArray,
                    datumTokenizer: function(d)
                    {
                        return Bloodhound.tokenizers.whitespace(d['Login ID']);
                    },
                    queryTokenizer: function (query)
                    {
                        //allow our user to use this more than once
                        var queryArray = query.split(/[;,]/);
                        console.log(queryArray);

                        //take the last token and trim it so we can search with it. This allows users to put in spaces
                        return [queryArray[queryArray.length - 1].trim()];
                    }
                });

                engine.initialize();

                $peopleList.typeahead(
                {
                    minLength: 2,
                    highlight: true
                },
                {
                    displayKey: function (suggestion)
                    {
                        return suggestion['Full Name'] + " (" + suggestion["Login ID"] + ")";
                    },
                    source: engine.ttAdapter()
                });
            }
        });*/
    }
};

//This function will be fired at the beginning of any service item to provide some additional functionality
keg.startTemplate = function ()
{
    initializeCustomerContact();


    keg.form.startQuestionListeners();

    //get if we need an incident number, get it
    if ($('.questionLayer[label="Incident Number"]').length > 0)
    {
        keg.Request.retrieveINC();
    }
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

//not sure why i capitalized this... my fault
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