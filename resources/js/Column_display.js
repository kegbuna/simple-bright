/**
 * Created with IntelliJ IDEA.
 * User: kegbuna
 * Date: 4/10/14
 * Time: 10:25 AM
 * To change this template use File | Settings | File Templates.
 */
$.extend( $.fn.dataTable.defaults, {
    searching: false,
    lengthChange: false
});

var Column = {};
Column.Helpers = {};

Column.Helpers.Mask = {};

Column.Helpers.Mask.initialize = function ()
{

    $('.date').mask('11/11/1111');
    $('.time').mask('00:00:00');
    $('.date_time').mask('00/00/0000 00:00:00');
    $('.cep').mask('00000-000');
    $('.phone').mask('0000-0000');
    $('.phone_with_ddd').mask('(00) 0000-0000');
    $('.phone_us').mask('(000) 000-0000');
    $('.mixed').mask('AAA 000-S0S');
    $('.cpf').mask('000.000.000-00', {reverse: true});
    $('.money').mask('000.000.000.000.000,00', {reverse: true});
    $('.money2').mask("#.##0,00", {reverse: true, maxlength: false});
    $('.ip_address').mask('0ZZ.0ZZ.0ZZ.0ZZ', {translation: {'Z': {pattern: /[0-9]/, optional: true}}});
    //$('.ip_address').mask('099.099.099.099');
    $('.percent').mask('##0,00%', {reverse: true});

};

Column.Helpers.Onboarding = {};

Column.Helpers.Onboarding.setApprovalQuestions = function(answered)
{
    //console.log(answered);
    var revealVP = false;
    var revealDirector = false;
    var revealOps = false;
    if (typeof answered['Skip Hardware'] === "undefined")
    {
        revealDirector = true;
    }
    if (typeof answered['Skip Mobility'] === "undefined")
    {
        revealVP = true;
    }
    for (var i in answered)
    {

        if ((i == "Phone Accessories" && answered[i].indexOf("Wireless Headset") > -1) ||
            (i == "Requests" && (answered[i].indexOf('VPN Request') > -1 || answered[i].indexOf('Internet Access') > -1)))
        {
            revealVP = true;
        }
        if ((i == "Skip Hardware" && answered[i] != "Yes"))
        {
            revealDirector = true;
        }
        if ((i == "Hardware Items" && (answered[i].indexOf('Apple') > -1 || answered[i].indexOf('Laptop') > -1)))
        {
            revealOps = true;
        }
    }
    if (revealVP == true)
    {
        turnOn('Approving VP');
    }
    if (revealDirector == true)
    {
        turnOn('Approving Director');
    }
    if (revealOps == true)
    {
        turnOn('Approving Ops Member');
    }

    function turnOn(label)
    {
        KD.utils.Action.makeQuestionRequired(label);
        $('.questionLayer[label="' + label + '"]').removeClass('hide').addClass('fadeIn');
    }
};
Column.Helpers.FreeText = {};

Column.Helpers.FreeText.applyAutoComplete = function($q, data)
{

};

Column.Helpers.FreeText.setupPriceListener = function(question)
{
    var totalCost = 0;
    if (KD.utils.Action.getQuestionValue(question).length > 0)
    {
        totalCost = KD.utils.Action.getQuestionValue(question);
    }
    KD.utils.Action.setQuestionValue(question, totalCost);
    $('.cost-field input').formatCurrency();
    var $checkBoxes = $('.answerCheckbox>input');
    var $pricetags = $('input').siblings('span.price');
    var $qFields = $(".q-field");
    $qFields.on('keyup', function ()
    {
        reCalculateTotal();
    });
    $checkBoxes.on('click', function ()
    {
        reCalculateTotal();
    });

    function reCalculateTotal()
    {
        //all inputs with prices
        var $pricetags = $('input.answerValue:checked').siblings('.price');
        var totalCost = 0.0;
        var multiplier = 0;
        $pricetags.each(function ()
        {
            var $input = $(this).siblings('.answerValue');
            var currentPrice = parseFloat($(this).text());
            // if this has a quantity associated with it, calculate it
            if ($(this).attr('data-qty'))
            {
                multiplier = parseFloat($('#pageQuestionsForm input.answerValue[label="' + $(this).attr('data-qty') + '"]').val());
                if (isNaN(multiplier))
                {
                    multiplier = 0;
                    currentPrice = 0;
                }
                else
                {
                    currentPrice = currentPrice * multiplier;
                }
            }
            totalCost += currentPrice;
        });
        KD.utils.Action.setQuestionValue(question, totalCost);
        $('.cost-field input').formatCurrency();
    }
};

Column.Helpers.Select = {};

Column.Helpers.Select.sourceFromBridge = function (bridge, qual, $select, $watched)
{
    var category = '';
    if ($watched != null)
    {

        $watched.on('change', function ()
        {
            category = $(this).val();
            console.log(category);
            callBridge(category);
        });
    }

    var callBridge = function (param)
    {
        var connector = new KD.bridges.BridgeConnector();

        connector.search(bridge, qual,
        {
            parameters: { "Category": param},
            success: function(data)
            {
                buildOptions(JSON.parse(data.toJson()));
            }
        });
    };
    var buildOptions = function(data)
    {
        var options = data.records;
        $select.find('option').each(function ()
        {
            if(this.value.length > 0)
            {
                $(this).remove();
            }
        });
        //console.log(options);
        for (var index in options)
        {
            //console.log(options[index]);
            $select.append('<option value="' + options[index] + '">' + options[index] + '</option>');
        }
    };

};
Column.Helpers.Table = {};
Column.Helpers.Table.initialize = function($table, columns, deleteBool)
{
    var dataTableColumns = [];
    for (var i in columns)
    {
        var $this = $('#'+ columns[i]);
        //console.log($this.length);
        if (typeof $this.hasAttribute != "undefined" && $this.hasAttribute('data-column'))
        {
            dataTableColumns[i] = {data: $this.attr('data-column')};
        }
        else
        {
            dataTableColumns[i] = {data: columns[i]};
        }
    }
    //console.log(dataTableColumns);
    Column.Helpers.Table[$table.attr('id')] = $table.DataTable(
    {
        columns: dataTableColumns,
        info: false,
        "lengthChange": false,
        "order": [[0,"desc"]],
        "createdRow": function ( row, data, index )
        {
            if (deleteBool)
            {
                $(row).append('<td class="table-deleteButton" data-index="' + index + '"><i class="fa fa-2x fa-minus-circle"></i></td>');
                $(row).find('.table-deleteButton i').on('click', function()
                {
                    deleteButton(row);
                });
            }
        }
    });

    var deleteButton = function(row)
    {
        var currentRow = Column.Helpers.Table[$table.attr('id')].row(row);
        currentRow.remove();
        //keep the question updated
        var questionID = $table.attr('id');
        Column.Helpers.Table.setQuestion(questionID);
        Column.Helpers.Table[$table.attr('id')].draw();
    }
};

Column.Helpers.Table.convertToCsv = function (id)
{
    var data = Column.Helpers.Table[id].data();
    var csv = [];
    var rowHolder = [];
    var attribute;
    //console.log(data.length);


    function ConvertToCSV(objArray)
    {
        var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
        var str = '';
        var $question;
        for (var i = 0; i < array.length; i++) {
            var line = '';
            if (i==0)
            {
                for (var property in array[i])
                {
                    if (line != '')
                        line += ',';
                    $question = $('#' + property);
                    if ($question.attr('data-column'))
                        line+= $question.attr('data-column');
                    else
                        line+= property;
                }
                str += line + '|';
                line = '';
            }
            for (var index in array[i])
            {
                if (line != '')
                    line += ',';

                line += array[i][index];
            }

            str += line + '|';
        }

        return str;
    }

    return ConvertToCSV(data);
};

Column.Helpers.Table.setQuestion = function (id)
{
    var csv = Column.Helpers.Table.convertToCsv(id);

    KD.utils.Action.setQuestionValue(id, csv);
};


Column.Helpers.Table.initializeQuestions = function(qList, $table, $control)
{
    var currentType;
    var $q;
    var qButton;
    var qDropdown;

    $('input, select').tooltip(
    {
        placement: 'top',
        trigger: 'manual',
        container: 'body'
    });

    for (var qID in qList)
    {
        qID = qList[qID];
        $q = $("#"+qID);

        currentType = $q.attr('questionType');

        switch (currentType)
        {
            case "dropdown":
                break;
            case "freetext":
                break;
        }
    }

    $control.click(function (e)
    {
        $('.has-error, .has-error input').tooltip('hide').removeClass('has-error');
        e.preventDefault();
        e.stopPropagation();

        switch ($control.text())
        {
            case "Add":
                if (checkQuestions(qList))
                {
                    addToTable(qList, $table);
                }
                else
                {
                    $('select.has-error, .has-error input').tooltip('show');
                }
                break;
            case "Modify":
                break;
        }
    });

    function checkQuestions(questions)
    {
        var goodToGo = true;
        for (var i in questions)
        {
            var $currentQuestion = $('#' + questions[i]);
            if ($currentQuestion.attr('required') != null && ($currentQuestion.val() == "" || $currentQuestion.val() == null))
            {
                if ($currentQuestion.attr('questionType') == 'freetext')
                    $currentQuestion.parent().addClass('has-error');
                else if ($currentQuestion.attr('questionType') == 'dropdown')
                    $currentQuestion.addClass('has-error');

                goodToGo = false;
            }
        }

        return goodToGo;
    }

    function addToTable(qList, $table)
    {
        var questionID = $($table.table().node()).attr('id');
        $table.row.add(getQuestionData(qList));
        //keep the question updated
        Column.Helpers.Table.setQuestion(questionID);
        clearQuestions(qList);
        $table.draw();
    }

    function getQuestionData(qList)
    {
        var qData = {};
        for (i in qList)
        {
            qData[qList[i]] = $('#' + qList[i].replace(/\s/g, '')).val();
        }

        return qData;
    }

    function clearQuestions(qList)
    {
        for (var i in qList)
        {
            var $currentQuestion = $('#' + qList[i]);
            if ($currentQuestion.attr('questionType') == "dropdown")
            {
                $currentQuestion.val('');
                $currentQuestion.find('option:first-child').attr('selected','selected');
            }
            else
            {
                $currentQuestion.val('');
            }
        }
    }
};

Column.Helpers.Display = {};

Column.Helpers.Display.toggleSection = function (obj, inClass, outClass)
{
    var $obj = $(obj);

    var $currentControl = $('#' + $obj.attr('id'));
    //var $label = $currentControl.find('i');
    var $targets = $('.' + $obj.attr('data-isfor'));
    //console.log($targets);
    switch ($currentControl.attr('status'))
    {
        case "Open":
            //$label.removeClass('fa-minus').addClass('fa-plus');
            $targets.removeClass(inClass).addClass(outClass);
            setTimeout(function ()
            {
                $targets.addClass('section-hide');
            }, 150);
            $currentControl.attr('status', 'Closed');
            $currentControl.text('Expand');
            break;
        case "Closed":
            //$label.removeClass('fa-plus').addClass('fa-minus');
            $targets.removeClass('section-hide').removeClass(outClass).addClass(inClass);
            $currentControl.attr('status', 'Open');
            $currentControl.text('Collapse');
            break;
    }
};
//This is a listener used to hide and show questions based on others
// type is either question or section, obj is the html element, toggleClass is either hide or visibility, and the in and out classes are for animations
Column.Helpers.Display.questionListener = function (type, obj, toggleClass, inClass, outClass)
{
    var answers = [];
    var question;

    //if the obj is an option in the dropdown, use the parent's label
    if (obj.tagName.toUpperCase() == "OPTION")
    {
        question = $(obj).parent().attr('label');
    }
    else
    {
        question = $(obj).attr('label');
    }

    var $options = $('.answerSelect[label="'+ question +'"] option');
    //console.log($options.length);

    if (KD.utils.Action.getQuestionValue(question).length > 0)
    {
        answers = KD.utils.Action.getQuestionValue(question).split(', ');
    }
    var possibleAnswers;
    if ($options.length > 0)
    {
        possibleAnswers = $options.map (function ()
        {
            return $(this).val();
        });
    }
    else
    {
        possibleAnswers = $('.questionAnswer[label="' + question + '"] .answerValue').map(function ()
        {
            return $(this).val();
        });
    }
    var notAnswered = [];
    var revealClass = inClass;
    var hideClass = outClass;
    var targetClass;

    switch (type)
    {
        case "question":
            targetClass= "questionLayer";
            break;
        case "section":
            targetClass= "templateSection";
            break;
    }

    // let's establish the items
    var selector = "";
    var notSelector = "";
    //var types = ['.questionLayer', '.templateSection', '.dynamicText'];

    for (var i=0; i< possibleAnswers.length; i++)
    {
        if (answers.indexOf(possibleAnswers[i]) == -1 && possibleAnswers[i].length > 0)
        {
            notAnswered.push(possibleAnswers[i]);
        }

    }

    var buildArray = function(eClass)
    {
        selector = "";
        notSelector = "";
        for (var b=0; b<answers.length ;b++)
        {
            if (b > 0)
            {
                selector += ",";
            }
            selector += '.' + eClass + '.' + answers[b].replace(/\s/g, "");
        }
        for (var c=0; c<notAnswered.length; c++)
        {
            if (c > 0)
            {
                notSelector += ",";
            }
            notSelector += '.' + eClass + '.' + notAnswered[c].replace(/\s/g, "");
        }

        return [$(selector), $(notSelector)];
    };

    var $questions = buildArray('questionLayer')[0];
    //console.log($questions.length);
    var $sections = buildArray('templateSection')[0];
    //console.log($sections.length);
    var $texts = buildArray('dynamicText')[0];
    //console.log($texts.length);

    var $hiddenQuestions = buildArray('questionLayer')[1];
    var $hiddenSections = buildArray('templateSection')[1];
    var $hiddenTexts = buildArray('dynamicText')[1];
    //console.log($hiddenQuestions);

    showElements();
    hideElements();
    if (typeof toggleClass === "undefined")
    {
        toggleClass = "invisible";
    }
    function showElements()
    {
        $questions.each(function ()
        {
            var qLabel = $(this).attr('label');
            if ($(this).hasClass(toggleClass))
            {
                $(this).removeClass(toggleClass);
                $(this).removeClass(hideClass);
                $(this).addClass(revealClass);
            }
            else
            {
                $(this).removeClass(hideClass);
                $(this).addClass(revealClass);
            }
            if ($(this).hasClass("req"))
            {
                KD.utils.Action.makeQuestionRequired(qLabel);
                //console.log (qLabel + ' is now Required.');
            }
        });
        $sections.each(function ()
        {
            if ($(this).hasClass(toggleClass))
            {
                $(this).removeClass(toggleClass);
                $(this).removeClass(hideClass);
                $(this).addClass(revealClass);
            }
            else
            {
                $(this).removeClass(hideClass);
                $(this).addClass(revealClass);
            }
        });
        $texts.each(function ()
        {
            if ($(this).hasClass(toggleClass))
            {
                $(this).removeClass(toggleClass);
                $(this).removeClass(hideClass);
                $(this).addClass(revealClass);
            }
            else
            {
                $(this).removeClass(hideClass);
                $(this).addClass(revealClass);
            }
        });
    }
    function hideElements()
    {
        //console.log($hiddenQuestions);
        $hiddenQuestions.each(function ()
        {
            var qLabel = $(this).attr('label');
            var goodToGo = true;
            //console.log(qLabel);
            for (var x=0; x<answers.length; x++)
            {
                if ($(this).hasClass(answers[x].replace(/\s/g, "")))
                {
                    goodToGo = false;
                    //console.log(qLabel + ' is in both arrays, not hiding');
                    return;
                }
            }
            if ($(this).hasClass(revealClass) && goodToGo)
            {
                var $this = $(this);
                $this.removeClass(revealClass);
                $this.addClass(hideClass);
                setTimeout(function ()
                {
                    $this.addClass(toggleClass);
                }, 150);
                turnQuestionOff(qLabel);
                //console.log(qLabel + ' is now Optional.');
            }
            else if (goodToGo)
            {
                turnQuestionOff(qLabel);
                //console.log(qLabel + ' is now Optional.');
            }
        });
        $hiddenSections.each(function ()
        {
            var qLabel = $(this).attr('label');
            var goodToGo = true;

            for (var x=0; x<answers.length; x++)
            {
                if ($(this).hasClass(answers[x].replace(/\s/g, "")))
                {
                    goodToGo = false;
                    //console.log(qLabel + ' is in both arrays, not hiding');
                    return;
                }
            }
            if ($(this).hasClass(revealClass) && goodToGo)
            {
                var $this = $(this);
                $this.removeClass(revealClass);
                $this.addClass(hideClass);
                setTimeout(function ()
                {
                    $this.addClass(toggleClass);
                }, 150);
            }
        });
        $hiddenTexts.each(function ()
        {
            var goodToGo = true;
            for (var x=0; x<answers.length; x++)
            {
                if ($(this).hasClass(answers[x].replace(/\s/g, "")))
                {
                    goodToGo = false;
                    //console.log(qLabel + ' is in both arrays, not hiding');
                    return;
                }
            }
            if ($(this).hasClass(revealClass) && goodToGo)
            {
                var $this = $(this);
                $this.removeClass(revealClass);
                $this.addClass(hideClass);
                setTimeout(function ()
                {
                    $this.addClass(toggleClass);
                }, 150);
            }
        });
    }

    function turnQuestionOff(qLabel)
    {
        KD.utils.Action.makeQuestionOptional(qLabel);
        // run through array and unclick checkboxes and set default values
        $('.questionLayer[label="' + qLabel + '"]').each(function()
        {
            //this thing is a checkbox
            $('input[type=checkbox][label="'+ qLabel +'"]:checked').click();

            //setting radio defaults
            $('input[type=radio][label="'+ qLabel +'"]').each(function ()
            {
                if (typeof $(this).attr('originalvalue') != 'undefined')
                {
                    KD.utils.Action.setQuestionValue(qLabel,$(this).attr('originalvalue'));
                   $(this).click();
                }
            });

            //this thing is a dropdown(select)
            $('select[label="'+ qLabel +'"]').each(function ()
            {
                KD.utils.Action.setQuestionValue(qLabel,$(this).attr('originalvalue'));
            });
        });
    }
};
Column.Helpers.Display.enableSaveButton = function (buttonLabel)
{
    if (typeof buttonLabel === "undefined")
    {
        buttonLabel = "Save As Draft";
    }
    $('.submitButton').prepend('<div class="btn btn-warning saveDraftButton">' + buttonLabel + '</div>');
    var $page = $('#pageQuestionsForm');
    $('.saveDraftButton').click(function (e)
    {
        $.ajax(
        {
            url: $page.attr('action'),
            method: $page.attr('method'),
            data: $page.serialize(),
            success: function (s)
            {

            },
            error: function (e)
            {

            },
            complete: function(response)
            {
                if (typeof nextPageID != "undefined")
                {
                    $('#pageID').val(nextPageID);
                    $.ajax(
                        {
                            url: 'PreviousPage',
                            method: $page.attr('method'),
                            data: $page.serialize(),
                            complete: function (response)
                            {
                                //console.log(response);
                                window.location.href = BUNDLE.config.submissionsUrl + "&ticketstatus=Draft";
                            }
                        });
                }
            }
        });
    });
};

Column.Helpers.Display.skipPage = function(skipQuestion)
{
    //console.log(skipQuestion);
    var questionLabel = $(skipQuestion).attr('label');
    //we use names with no classes to denote targeted elements, so this would be SkipHardware
    var qLabelClean = questionLabel.replace(/\s/g, '');
    //label the warning after the skip question name
    var warningLabel = $(skipQuestion).attr('label') + " Warning";
    //grab the whole dynamicTest element
    var $warning = $('[label="' + warningLabel + '"].dynamicText');

    //identify top level questions which are then "turned off" if we are skipping this request
    var $targets = $('.' + qLabelClean);
    if (KD.utils.Action.getQuestionValue(questionLabel) == "Yes")
    {
        $warning.removeClass('hide').removeClass('fadeOut').addClass('fadeIn');
        //hide relevant questions
        $targets.addClass('fadeOut');
        //remove their requiredness
        $targets.each(function()
        {
            KD.utils.Action.makeQuestionOptional($(this).attr('label'));
        });
        setTimeout(function ()
        {
            $targets.addClass('hide');
        }, 100);
    }
    else
    {
        //hide the warning
        $warning.removeClass('fadeIn').addClass('fadeOut');

        setTimeout(function ()
        {
            $warning.addClass('hide');
        }, 500);

        //bring those questions back
        $targets.removeClass('hide').removeClass('fadeOut').addClass('fadeIn');
        $targets.each(function()
        {
//          //make those req classed questions REQUIRED
            if ($(this).hasClass('req'))
            {
                KD.utils.Action.makeQuestionRequired($(this).attr('label'));
            }
        });
    }

    function turnQuestionOff(qLabel)
    {
        KD.utils.Action.makeQuestionOptional(qLabel);
        // run through array and unclick checkboxes and set default values
        $('.questionLayer[label="' + qLabel + '"]').each(function()
        {
            //this thing is a checkbox
            $('input[type=checkbox][label="'+ qLabel +'"]:checked').click();

            //setting radio defaults
            $('input[type=radio][label="'+ qLabel +'"]').each(function ()
            {
                if (typeof $(this).attr('originalvalue') != 'undefined')
                {
                    KD.utils.Action.setQuestionValue(qLabel,$(this).attr('originalvalue'));
                    $(this).click();
                }
            });
        });
    }
};
Column.Helpers.Url = {};

Column.Helpers.Url.updateQueryStringParameter = function (uri, key, value)
{
    var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";
    if (uri.match(re)) {
        return uri.replace(re, '$1' + key + "=" + value + '$2');
    }
    else {
        return uri + separator + key + "=" + value;
    }
};

Column.Helpers.Url.removeParam = function(key, sourceURL)
{
    var rtn = sourceURL.split("?")[0],
        param,
        params_arr = [],
        queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
    if (queryString !== "") {
        params_arr = queryString.split("&");
        for (var i = params_arr.length - 1; i >= 0; i -= 1) {
            param = params_arr[i].split("=")[0];
            if (param === key) {
                params_arr.splice(i, 1);
            }
        }
        rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
};

function columnizeCheckboxes(labelName, requestedColumns, columnWidth)
{
    "use strict";
    // Find the element.
    var selectorString  = "div[class=\"questionAnswer\"]";
    selectorString += "[label=\"" + labelName + "\"]";
    var parentElement = $(selectorString);

    // Create a <div> string to contain the checkboxes.
    var divString = '<div style=\"float:left; width: ';
    divString += columnWidth + 'px;\"></div>';
    var wrapperDiv = $(divString);

    var answerCheckboxes = parentElement.children();
    var totalCheckboxes = answerCheckboxes.size();
    var checkboxesPerColumn = Math.ceil(totalCheckboxes / requestedColumns);

    // Loop over the columns in a given chunk and apply the div.
    var builtColumns = 1;
    for (var i = 0; builtColumns < requestedColumns; i += checkboxesPerColumn) {
        var elem = null;
        elem = answerCheckboxes.slice(i, i + checkboxesPerColumn);
        elem.wrapAll(wrapperDiv);
        builtColumns++;
    }
}
Column.Helpers.Select.searchableList = [];

Column.startTemplate = function()
{
    //Customer Contact stuff
    var data = {};
    var $submitterBox = $('#submitterBox');
    var $customerBox = $('#customerBox');
    $('div.templateSection[label=Submitter] div.questionAnswer .answerValue').each(function ()
    {
        data[$(this).attr('label')] = $(this).val();
    });

    $submitterBox.data('user', data);

    if (typeof data != "undefined" && data.hasOwnProperty("Req Login ID"))
    {
        $submitterBox.find('.full-name').text($submitterBox.data('user')['Req First Name'] + " " + $submitterBox.data('user')['Req Last Name']);
        $submitterBox.find('.phone-number').text($submitterBox.data('user')['Req Phone Number']);
        $submitterBox.find('.email-address').text($submitterBox.data('user')['Req Email Address']).parent().attr('href', 'mailto:' + $submitterBox.data('user')['Req Email Address']);
        if (KD.utils.Action.getQuestionValue('ReqFor_Login ID') == "" || KD.utils.Action.getQuestionValue('ReqFor_Login ID') == $submitterBox.data('user')['Req Login ID'])
        {
            $customerBox.find('.full-name').text($submitterBox.data('user')['Req First Name'] + " " + $submitterBox.data('user')['Req Last Name']);
            $customerBox.find('.phone-number').text($submitterBox.data('user')['Req Phone Number']);
            $customerBox.find('.email-address').text($submitterBox.data('user')['Req Email Address']).parent().attr('href', 'mailto:' + $submitterBox.data('user')['Req Email Address']);
            KD.utils.Action.setQuestionValue('ReqFor_Login ID', $submitterBox.data('user')['Req Login ID']);
            KD.utils.Action.setQuestionValue('ReqFor_First Name', $submitterBox.data('user')['Req First Name']);
            KD.utils.Action.setQuestionValue('ReqFor_Last Name', $submitterBox.data('user')['Req Last Name']);
            KD.utils.Action.setQuestionValue('ReqFor_Email', $submitterBox.data('user')['Req Email Address']);
        }
        else
        {
            $customerBox.find('.full-name').text(KD.utils.Action.getQuestionValue('ReqFor_First Name') + " " + KD.utils.Action.getQuestionValue('ReqFor_Last Name'));
            $customerBox.find('.phone-number').text(KD.utils.Action.getQuestionValue('ReqFor_Phone'));
            $customerBox.find('.email-address').text(KD.utils.Action.getQuestionValue('ReqFor_Email')).parent().attr('href', 'mailto:' + KD.utils.Action.getQuestionValue('ReqFor_Email'));
        }
    }

    data = {};
    $('div.templateSection[label="Requested For Details Section"] div.questionAnswer .answerValue').each(function ()
    {
        data[$(this).attr('label')] = $(this).val();
    });
    $customerBox.data('user', data);

    //Prepopulated table set up, get all created tables and reload their data
    $('.dataTable').each(function()
    {
        var id = $(this).attr('id');

        if (KD.utils.Action.getQuestionValue(id).length > 0)
        {
            var tableData = KD.utils.Action.getQuestionValue(id).split('|');
            //I end with a pipe for some reason so i need to pop them off
            tableData.pop();
            var fields = KD.utils.Action.getQuestionValue(id).split('|')[0].split(',');
            var jsonData = [];
            var tempJson;
            var tempId;
            var row;
            for (var i=1; i<tableData.length; i++)
            {
                row = tableData[i].split(',');
                tempJson = {};
                tempId = "";
                for (var j in fields)
                {
                    tempId = $('[data-column="' + fields[j] + '"]').attr('id');
                    tempJson[tempId] = row[j];
                }
                jsonData.push(tempJson);
            }

            var $table = $(this).DataTable();
            $table.rows.add(jsonData);
            $table.draw();
        }
    });

    // replace KD's searchableList solution.. it's good just need some freedom
    //$('.searchableList .questionAnswer option').each(function () { data.push({ value : $(this).val(), text: $(this).text()})});
};
function searchListTest()
{
    $('.searchableList').each(function ()
    {
        //set some useful vars
        var label = $(this).attr('label');
        // set up a spot for each question in the searchable list, and then add its data
        Column.Helpers.Select.searchableList[label] = [];
        console.log(Column.Helpers.Select.searchableList);
        $(this).find('select').hide();
        var targetWidth = $(this).find('select').css('width');
        console.log(targetWidth);
        $(this).find('.questionAnswer option').each(function ()
        {
            Column.Helpers.Select.searchableList[label].push(
            {
                value : $(this).val(),
                label: $(this).text()
            });
        });
        $(this).find('.questionAnswer').append('<div class="col-md-6 row"><div class="searchable-group input-group" data-answer="' + $(this).attr('label') + '"><input type="text" class="searchable-list-input form-control" data-answer="' + $(this).attr('label') + '"><span class="input-group-btn"><div class="btn btn-default searchable-list-button" data-state="closed"><i class="fa fa-caret-down"></i></div></span><div class="searchable-list-results hide animated"><ul class="list-group"></ul></div></div>');

        $(this).find('.searchable-group>.searchable-list-input').keyup(function (e)
        {
            var data = Column.Helpers.Select.searchableList[label];
            var $results = $(this).parent().find('.searchable-list-results');
            console.log(e);
            var searchValue = e.currentTarget.value;
            var $menuButton = $(this).parent().find('searchable-list-button');
            var hitCount = 0;
            $results.html('');
            if ($(this).val().length > 0)
            {
                for (var i in data)
                {
                    if (data[i]['value'].toLowerCase().indexOf(searchValue) > -1 || data[i]['label'].toLowerCase().indexOf(searchValue) > -1)
                    {
                        console.log('hit on ' + data[i]['value'] + ' with ' + searchValue);
                        $results.append('<li class="list-group-item" data-value="' + data[i]['value'] + '">' + data[i]['label'] + '</li>');
                        hitCount++;
                    }
                }
            }
            else
            {
                for (var i in data)
                {
                    $results.append('<li class="list-group-item" data-value="' + data[i]['value'] + '">' + data[i]['label'] + '</li>');
                    hitCount++;
                }
            }
            if (hitCount > 0)
            {
                $results.removeClass('hide').addClass('slideDownIn');
            }
            else
            {
                $results.addClass('hide');
            }

        }).on('blur keydown', function(e)
        {
            var $results = $(this).parent().find('.searchable-list-results');
            var data = Column.Helpers.Select.searchableList[label];
            var $this = $(this);

            if ($results.find('li').length > 0)
            {
                if (e.type == "keydown")
                {
                    if (e.keyCode == 13)
                    {
                        $(this).val($results.find('li:first-child').attr('data-value'));
                    }
                }
                if (e.type == "blur")
                {
                    $(this).val($results.find('li:first-child').attr('data-value'));
                }
            }
            else if (!checkValue())
            {
                $(this).val('');
                console.log(e);
                console.log("0'd out the field");
            }
            KD.utils.Action.setQuestionValue($(this).attr('data-answer'), $(this).val());
            $results.addClass('hide');
            function checkValue()
            {
                for (var i in data)
                {
                    if ($this.val() == data[i].value)
                        return true;
                }
                return false;
            }
        });

        $(".searchable-list-results li").click(function ()
        {
            var question = $(this).parent().attr('data-answer');
            var $input = $(this).parent().find('searchable-list-input');
            var $results = $(this).parent().find('.searchable-list-results');
            var value = $(this).attr('data-value');

            $input.val(value);
            KD.utils.setQuestionValue(question, value);
            $results.addClass('hide');
        });
    });
}

$(document).ready(function()
{
    var $searchGroup = $('#searchGroup');
    $searchGroup.find('.btn.btn-default').on('click', function()
    {
        performSearch();
    });
    $searchGroup.find('input').on('keydown', function(e)
    {
        if(e.keyCode == 13)
        {
            performSearch();
        }
    });

    function performSearch()
    {
        window.location.href = BUNDLE.config.searchUrl + "&q=" + $('#searchGroup').find('input').val();
    }
    /*  Begin customer search code
     *  This code enables the user to easily change the customer of a ticker
     */
    $('#changeCustomer').popover(
    {
        trigger: 'click',
        container: 'body',
        template: '<div class="popover search-popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>',
        html: true,
        /*selector: '[rel="popover"]',*/
        title: 'Search Users <i class="fa popover-close pull-right fa-times-circle fa-lg"></i>',
        content: function(e)
        {
            return '<div id ="customerSearch" style="margin: 0 20px 0 0;" class="input-group col-sm-12"><input type="text" class="form-control" placeholder="First name, last name, etc.."><span class="input-group-btn"><button class="btn btn-default" type="button"><i class="fa fa-search"></i></button></span></div><div id="searchIndicator" class="hide"><i class="fa-spin fa fa-3x fa-spinner"></i></div><ul id="peopleResults" class="list-group hide"></ul>';
        }
    }).on('click', function(e)
    {
        e.preventDefault();
    });
    var $body = $('body');
    $body.on('click', '#customerSearch button', function()
    {
        var terms = $('#customerSearch input').val().split(' ');
        var qualification = '';
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
        var connector = new KD.bridges.BridgeConnector({templateId: clientManager.templateId});
        //var test = "\'First Name\' LIKE \"%%Ken%%\"";
        //console.log(test);
        searchPeople(qualification);

        /* This performs a search against the Bridge model people
        *  The data will then be used to populate the menu
        * */
        function searchPeople(qual)
        {
            var $indicator = $('#searchIndicator');
            var $results = $('#peopleResults');
            $indicator.removeClass('hide');
            $results.html('');
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
                success: function(people)
                {
                    $indicator.addClass('hide');
                    populateResults(people);
                },
                error: function(error)
                {
                    console.log(qualification);
                }
            });
        }

        function populateResults(people)
        {
            var $results = $('#peopleResults');
            $results.html('');
            $results.removeClass('hide');

            if (people.records.length == 0)
            {
                $results.html('No Results..')
            }
            else
            {
                var peopleJson = JSON.parse(people.toJson());
                $results.data('fields', people.fields);
                $results.data('records', people.records);
                for (var i in peopleJson.records)
                {
                    $results.append('<li class="list-group-item"><p class="name">' + peopleJson.records[i][peopleJson.fields.indexOf('First Name')] + ' ' + peopleJson.records[i][peopleJson.fields.indexOf('Last Name')] + ' (' + peopleJson.records[i][peopleJson.fields.indexOf('Login ID')] + ')</p><p class="email">' + peopleJson.records[i][peopleJson.fields.indexOf('Email Address')] + '</p></li>');
                }
            }
        }
    });

    //press enter to search
    $body.on('keydown', '#customerSearch input', function(e)
    {
        if (e.keyCode == 13)
        {
            $('#customerSearch button').click();
        }
    });
    //press close button
    $body.on('click', '.search-popover .popover-close', function ()
    {
        var $changeCustomer = $('#changeCustomer');
        $changeCustomer.popover('toggle');
    });
    $body.on('click', '#peopleResults li', function(e)
    {
        var $results = $('#peopleResults');
        var $changeCustomer = $('#changeCustomer');
        var fields = $results.data('fields');
        var records = $results.data('records');
        var $customerBox = $('#customerBox');

        var choice = $(this).index();

        var chosenUser = records[choice].attributes;

        KD.utils.Action.setQuestionValue('Search By Person ID', chosenUser['Person ID']);

        $('#b_searchReqFor').click();

        $customerBox.find('.full-name').text(chosenUser['First Name'] + " " + chosenUser['Last Name']);
        $customerBox.find('.phone-number').text(chosenUser['Phone Number']);
        $customerBox.find('.email-address').text(chosenUser['Email Address']).parent().attr('href', 'mailto:' + chosenUser['Email Address']);

        $changeCustomer.popover('toggle');
    });

    /*
    * New searchableList code. This will attempt to use custom div/inputs to replace select lists. The lists look horrible stacked on one another
    * 
    */
    var $searchableSelect = $('.searchableList select.answerValue');
    var $selectParent = $searchableSelect.parent();

    $searchableSelect.on('click', function(e)
    {
        var $this = $(this);

        var thisHeight = $(this).css('height');
        var thisWidth = $(this).css('width');

        //hide the original select
        $this.hide();
        
        var options = [];
        $(this).find('option').each(function()
        {
            options.push(
            {
                'label' : $(this).text(),
                'value' : $(this).val()
            });
        });
        var currentList = options.slice(0);
        //print options to the console
        //console.log(options);


        var $selectParent = $this.parent();
        //fix the z-index
        $selectParent.parent().css('z-index', '9999');
        //templateSection needs it too incase of another section being right below
        $selectParent.parent().parent().css('z-index', '9999');
        //add the container for the results
        $selectParent.prepend('<div id="holder' + $this.attr('name') + '" data-for="' + $this.attr('name') + '"><ul class="list-group dropdown-list"></ul></div>');
        //add the input field for searching
        $selectParent.prepend('<input id="input' + $this.attr('name') + '" data-for="' + $this.attr('name') + '">');

        var $input = $selectParent.find('#input' + $this.attr('name'));
        var $choiceHolder = $selectParent.find('#holder' + $this.attr('name'));
        var $choiceList = $choiceHolder.find('ul');

        //handle the choice holder
        $choiceHolder.css(
        {
            'position' : 'absolute',
            'top' : thisHeight,
            'width' : (parseInt(thisWidth) + 16) + "px"
        });
        $choiceList.css(
        {
            'max-height' : '200px',
            'overflow-y' : 'scroll'
        });
        updateChoices($input);


        //focus on the new input field
        $input.focus();

        $input.css(
        {
            'position' : 'relative',
            'height' : thisHeight,
            'width' : thisWidth,
            'top' : 0,
            'left' : 0
        }).on('keyup', function(e)
        {
            if (e.keyCode == 13)
            {
                $(this).blur();
                var newValue = "";
                if (currentList.length > 0)
                {
                    newValue = currentList[0].value;
                }
                KD.utils.Action.setQuestionValue($this.attr('label'), newValue);
                closeMenu();
            }
            updateChoices($(this));
        })
        .blur(function(e) //this occurs when focus has left the field
        {

        });
        //ie10 doesn't play nice with mousedown
        $('body').on('mousedown', function(e)
        {
            if (e.target.id == $choiceList.parent().attr('id') || e.target.id == $input.attr('id'))
            {

            }
            else
            {
                closeMenu();
            }
        });
        //prevent drop from closing on usage of the scrollbar
        $choiceList.parent().on('mousedown', function(e)
        {
            e.preventDefault();
            $input.focus();
        });
        //user makes a selection
        $choiceList.on('mousedown', 'li', function(e)
        {
            KD.utils.Action.setQuestionValue($this.attr('label'), $(this).attr('value'));
            $input.blur();
        });

        function closeMenu()
        {
            //we set our questionlayer back
            $selectParent.parent().css('z-index', '50');
            //hacky but we also need to take care of the templateSection
            $selectParent.parent().parent().css('z-index', '50');
            $input.remove();
            $this.show();
            $choiceHolder.remove();
        }
        function updateChoices($userInput)
        {
            var searchTerm;

            currentList = [];
            //empty the list
            $choiceList.html('');

            if ($userInput.val())
            {
                searchTerm = $userInput.val();
            }
            else
            {
                searchTerm = "";
            }

            for ( var i in options)
            {
                var choice = options[i];
                //see if the term is in the label, lower all cases
                if (choice.label.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1)
                {
                    currentList.push(choice);
                }

            }
            if (currentList.length == 0)
            {
                $choiceList.append('<li class="list-group-item" value="">No results.</li>');
            }
            else
            {
                for (var j in currentList)
                {
                    var thisChoice = currentList[j];

                    $choiceList.append('<li class="list-group-item" value="' + thisChoice['value'] + '">'+ thisChoice['label'] +'</li>');
                }
            }
        }



    });

 });

/*
* Don't feel good about this but I need to overwrite one of kinetic's functions
* */

KD.utils.Action.openDatePicker = function(event, id)
{
    var calId = "CAL_" + id;
    //create the datepicker holder and set the z Index of the qlayer to make sure the datepicker is shown over the other stuff
    $('#QLAYER_' + id).append('<div id="' + calId + '" class="datepicker-holder"></div>').css('z-index', '75');
    $('#' + calId).datepicker(
    {
        autoclose: true
    }).on('changeDate', function(e)
    {
        //retrieve date object
        var selectedDate = $(this).datepicker('getDate');
        //form the dateArray that kinetic uses
        var dateArray = [selectedDate.getFullYear(),selectedDate.getMonth()+1,selectedDate.getDate()];
        //set the question
        KD.utils.Action.setDateFields(id, dateArray, false);
        //destroy this
        $('#' + calId).remove();
        //restore the z index -- was set beforte to ensure that the calendar shows in front of other elements
        $('#QLAYER_' + id).css('z-index', '50');
    });
};