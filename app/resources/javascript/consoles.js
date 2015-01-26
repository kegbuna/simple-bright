// Initialize a globally accessible namespace where the common variables and functions will be
// attached to.
var KineticSr = {
    app: {}
};

var dataTableDefaults = {
    autoWidth: false,
    filter: false,
    info: false,
    paginate: false,
    ordering: false,
    columnDefs: [{
        render: function(data) {
            return $('<span>').text(data).html();
        }
    }]
};

KineticSr.app.route = function (consoleName) {
    var args = Array.prototype.slice.call(arguments, KineticSr.app.route.length);
    var consoles = {
        
    };
    
    var route = KineticSr.app.contextPath + consoles[consoleName];
    _.each(args, function(arg) {
        route += '/';
        route += encodeURIComponent(arg);
    });
    return route;
};

KineticSr.app.formatTimestamp = function (element) {
    // Ensure that the timestamp is not evaluated more than once.
    if ($(element).data('toggle') !== 'tooltip') {
        // Create a span that will hold the time content.  This is necessary because the tooltip creates
        // an additonal element and if you don't wrap it with something the styling in places this
        // function is called gets strange.
        var span = $('<span>');
        // Get the original iso8601 date from the text of the element.
        var iso8601date = $(element).text();
        // Set the text of the span to the time ago format.
        $(span).text(moment(iso8601date).fromNow());
        // Configure a tooltip that will show the date in a normal date format.
        $(span).attr('title', moment(iso8601date).format('MMMM Do YYYY, h:mm:ss A'));
        $(span).addClass('time-ago');
        $(span).data('toggle', 'tooltip');
        $(span).data('placement', 'top');
        $(span).tooltip();    
        // Replace the content of the element with the span created above.
        $(element).html(span);
    }
};

KineticSr.app.setMessage = function(data) {
    var messageDiv = $('<div>');
    if (data.messageElement) {
        messageDiv.append(data.messageElement);
    } else {
        messageDiv.text(data.message);
    }
    messageDiv.addClass('alert');
    if (data.messageType === 'error') {
        messageDiv.addClass('alert-danger');
        if (data.errors) {
            var list = $('<ul>');
            _.each(data.errors, function(error) {
                var listItem = $('<li>');
                listItem.text(error);
                list.append(listItem);
            });
            messageDiv.append(list);
        }
    } else {
        messageDiv.addClass('alert-success');
    }
    $('div.alerts').html(messageDiv);
};

// This function is a refactored version of the setMessage function above.  It directly takes the
// jqXHR object because most of the success/error callbacks had very similar logic involved when
// setting the message, so that logic was moved within here.  It also automatically scrolls up to
// the message.
KineticSr.app.setAjaxMessage = function(jqXHR) {
    // Create the div that will contain the message text.
    var messageDiv = $('<div>');
    messageDiv.addClass('alert');
    
    // Check whether or not the response was a success.  If so either look to see if there was a
    // message included in the response JSON or use the response text.
    if (jqXHR.status === 200) {
        messageDiv.addClass('alert-success');
        if (jqXHR.responseJSON) {
            messageDiv.text(jqXHR.responseJSON.message);
        } else {
            messageDiv.text(jqXHR.responseText);
        }
    } else {
        messageDiv.addClass('alert-danger');
        // If a 400 was returned, look to see if the response was JSON data that includes details
        // about the error.  If so use them otherwise simply use the status text of the response.
        if (jqXHR.status === 400 && jqXHR.responseJSON) {
            messageDiv.text(jqXHR.responseJSON.message);
            if (jqXHR.responseJSON.errors) {
                var list = $('<ul>');
                _.each(jqXHR.responseJSON.errors, function(error) {
                    var listItem = $('<li>');
                    listItem.text(error);
                    list.append(listItem);
                });
                messageDiv.append(list);
            }
        } else {
            messageDiv.text(jqXHR.statusText);
        }
    }

    // Set the content of the alerts div to the message div created above.  Note that this
    // essentially clears out the previous message as well.
    $('div.alerts').html(messageDiv);
    
    // Scroll to the header.  Note that we pad the scroll to value by 10px so that the header is not
    // on the very edge of the screen when scroll is adjusted.
    var scrollTo = $('.page-header').offset().top - 10;
    if ($(document).scrollTop() > scrollTo) {
        $('html, body').animate({
            scrollTop: scrollTo
        }, 350);
    }
};

KineticSr.app.manyToMany = function(options) {
    // Store the intial state of the associated and available options so that we can reset them if
    // necessary.
    var initialAssociated = $(options.associatedSelect).find('option');
    var initialAvailable = $(options.availableSelect).find('option');
    
    // Use the mover widget defined below to bind the events necessary for this many to many
    // functionality.
    moverWidget(options.associatedSelect, options.availableSelect, options.removeButton);
    moverWidget(options.availableSelect, options.associatedSelect, options.addButton);
    
    // Return the object that contains some helper methods for retrieving data from the many-to-many
    // form control as well as reset its state.
    return {
        reset: function() {
            $(options.associatedSelect).append(initialAssociated.detach());
            $(options.availableSelect).append(initialAvailable.detach());
        },
        getAssociated: function() {
            return _.collect($(options.associatedSelect).find('option'), function(option) {
                return $(option).attr('value');
            });
        },
        getAvailable: function() {
            return _.collect($(options.availableSelect).find('option'), function(option) {
                return $(option).attr('value');
            });
        }
    };
};

/*
 * Modifies the form submission functionality of our edit forms.  It does primarily two things:
 * converts the form data to a JSON object that the servlets can easliy to to hydrate instances for
 * creates/updates, and it replaces the normal form post with an ajax post so that if there is an
 * error the page state will remain.
 */
KineticSr.app.form = function(formSelector, dataCallback) {
    $(formSelector).submit(function(event) {
        // Prevent the normal form submission.
        event.preventDefault();
        // Store a reference to the form being submitted.
        var form = $(this);
        // Disabled the form's submit button(s).
        form.find('button[type=submit]').prop('disabled', true);
        // Initialize a data object that represents the JSON data to be posted.
        var data = {};
        // Iterate through each of the input, select, and textarea elements that have the data-field
        // attribute defined.
        form.find('input[data-field]:not([disabled]), select[data-field]:not([disabled]), textarea[data-field]:not([disabled])').each(function() {
            // Store the current input/select/textarea element.
            var el = $(this);
            // Get the field name from the data attributes of the element.
            var field = el.data('field');
            // Get the field type from the data attributes of the element (defaults to string).
            var type = el.data('type') ? el.data('type') : "string";
            // If checkbox input
            if (el.attr('type') === 'checkbox') {
                // Get the value from the 'checked' property
                if (el.prop('checked')) { 
                    setData(data, field, true, type);
                }
            }
            // For radio input
            else if (el.attr('type') === 'radio') {
                // Get the value from the 'checked' property
                if (el.prop('checked')) {
                    setData(data, field, el.attr('value'), type);
                }
            }
            // For multiple select elements we build an array of each of the option elements that
            // is currently a child of that select element.
            else if (el.is('select[multiple]')) {
                var values = _.map($(this).find('option'), function(option) {
                    return $(option).attr('value');
                });
                setData(data, field, values, type);
            }
            // For all other types of input we simply call the .val() function on that element.
            else {
                setData(data, field, el.val(), type);
            }
        });

        // If there was a data callback specified, call it passing the current data object.
        if (dataCallback) dataCallback(data);
        // Make the ajax call (url and method are defined by the form attributes).
        KineticSr.app.ajax({
            url: form.attr('action'),
            type: form.attr('method'),
            accepts: {
                json: 'application/json'
            },
            data: { _body: JSON.stringify(data) },
            dataType: 'json',
            // If successful we are expecting a redirect url and we redirect there.
            success: function(data) {
                if (data.redirectTo) {
                    window.location.href = KineticSr.app.contextPath + data.redirectTo;
                }
            },
            // If error we simply populate the alerts section with an error message.  If we get a
            // 400 we use the message returned by the server otherwise we return the error message
            // associated with the response code.
            error: function(jqXHR, textStatus, errorThrown) {
                // Reenable the form's submit button(s).
                form.find('button[type=submit]').prop('disabled', false);
                // Set the error message
                KineticSr.app.setAjaxMessage(jqXHR);
            },
            loginCanceled: function() {
                form.find('button[type=submit]').prop('disabled', false);
            }
        });
    });
};

/*
     * Wrapper for jQuery's AJAX method that will add ajax login functionality to the ajax call.
     * 
     * This wrapper does two things in additional to simply calling the jQuery.ajax function:
     * 
     * First, clones the options object and removes items from it that are not used by the
     * jQuery.ajax function.
     * 
     * Then it defines a new 'error' callback function when calling jQuery.ajax.  The new callback
     * looks to see if the response status is 401.  If so, it performs the login functionality,
     * otherwise it calls the original error callback.
     * 
     * @param {object} options
     */
    KineticSr.app.ajax = function(options) {
        // Create a clone of the options that will be passed to jQuery
        var jQueryOptions = $.extend({}, options);
        // Delete options that are not used by jQuery
        delete jQueryOptions.loginCanceled;
        // Make ajax call
        jQuery.ajax($.extend({}, jQueryOptions, {
            error: function(jqXHR, textStatus, errorThrown) {
                if (jqXHR.status === 401) {
                    // Perform ajax login functionality
                    KineticSr.app.authenticate(function() {
                        KineticSr.app.ajax(options);
                    }, options.loginCanceled);
                } else {
                    // Call original error callback
                    if (options.error) {
                        options.error(jqXHR, textStatus, errorThrown);
                    }
                }
            }
        }));
    };

/*
 * Activates the modal authentication form.
 * 
 * @param {function} success - A function that is to be called once the user successfully
 *                             authenticates.
 * @param {function} cancel  - A function that is to be called if the user cancels/closes the
 *                             login dialog.
 */
KineticSr.app.authenticate = function(success, cancel) {
    // Clone the modal authentication div and remove the id attribute
    var modalAuth = $('#modal-auth').clone().removeAttr('id');

    // Enable the modal authentication dialog
    modalAuth.modal('show');

    // Initialize a variable that tells us whether or not the authentication was successful.
    var authComplete = false;

    // Bind an on submit event to the modal authentication form that will attempt an ajax post
    // to the login route.  If login was successful we call the success callback otherwise we
    // display the error message.
    modalAuth.find('form').submit(function(event) {
        event.preventDefault();
        $.ajax({
            url: $(this).attr('action'),
            type: $(this).attr('method'),
            data: $(this).serialize(),
            dataType: 'text',
            accepts: {
                text: 'text/plain'
            },
            success: function(data) {
                authComplete = true;
                modalAuth.modal('hide');
                if (success) { success(); }
            },
            error: function(jqXHR) {
                modalAuth.find('form .alert .text').text(jqXHR.responseText);
                modalAuth.find('form .alert').show();
            }
        });        
    });

    // Bind an event that fires when the modal is shown, the event sets focus to the username
    // input field.
    modalAuth.on('shown.bs.modal', function() {
        modalAuth.find('form input[name=login]').focus();
    });

    // Bind an event that fires when the modal is hidden, the event calls the cancel callback
    // if necessary and it destroys the modal authentication element.
    modalAuth.on('hide.bs.modal', function() {
        modalAuth.remove();
        if (!authComplete && cancel) { cancel(); }
    });
};

/*
 * Adds some additional functionality to sensitive fields that makes them easier for users to work
 * with since the values are masked.
 * 
 * When initialized it sets the default value of the sensitive field to a string of asterisk
 * characters.
 */
KineticSr.app.sensitiveField = function(inputSelector) {
    // If the inputSelector is already a jQuery object, don't re-wrap and clone it (which causes
    // problems if sensitiveField is being called on an element that hasn't been attached to the
    // DOM yet).
    var input = (inputSelector instanceof jQuery) ? inputSelector : $(inputSelector);
    var initial = '********';
    input.val(initial);
    input.attr('autocomplete', 'off');
    input.data('dirty', false);
    
    // Create dummy hidden input
    var hiddenInput = $('<input>')
        .attr('id', input.attr('id'))
        .attr('name', input.attr('name'))
        .attr('disabled', true)
        .attr('data-field', input.data('field'))
        .hide();
    // Remove input name and id and apply to hidden input
    input.removeAttr('id');
    input.removeAttr('name');
    input.removeAttr('data-field');
    
    // DOM manipulation for the senesitive field functionality.
    // 
    // Create the input group div element that needs to wrap the input and the reset button.
    var inputGroup = $('<div>')
        .addClass('input-group');
    // Create the reset button.
    var resetButton = $('<button>')
        .addClass('btn')
        .addClass('btn-primary')
        .addClass('disabled');
    // Create the span that will hold the repeat image.
    var resetImage = $('<span>')
        .addClass('fa')
        .addClass('fa-repeat');
    // Add the image and text to the reset button.
    resetButton
        .append(resetImage)
        .append(' Undo Change');
    // Build the input group button
    var inputGroupButton = $('<span>')
        .addClass('input-group-btn');
    inputGroupButton.append(resetButton);
    // Replace the password element with the input group
    input.wrap(inputGroup);
    input.parent().prepend(hiddenInput);
    input.parent().append(inputGroupButton);
    
    // JavaScript events for the sensitive field functionality.
    input.keyup(function(event) {
        if (!input.data('dirty') && input.val() !== initial) {
            input.data('dirty', true);
            hiddenInput.attr('disabled', false);
            resetButton.removeClass('disabled');
        }
        hiddenInput.val($(this).val());
    });
    
    // If the input was focused by being clicked on we select all of the text by default to make it
    // easier to clear out the dummy input data.
    input.mouseup(function(event) {
        input.select();
    });
    
    resetButton.click(function(event) {
        event.preventDefault();
        hiddenInput.val('');
        hiddenInput.attr('disabled', true);
        input.val(initial);
        input.data('dirty', false);
        resetButton.addClass('disabled');
    });
    
    // Obtain a reference to input group
    // Return the input group
    return input.parent();
};

/*
 * Binds functionality to delete buttons on edit pages.  First it prevents the default action (which
 * is probably form submission).  Then it disables the delete button(s).  Then it uses the confirm
 * dialog to ensure the user actually wants to delete the record.  If the action is confirmed we
 * make the ajax delete call to the url specified as a data attribute on the button element.  If
 * succesful we redirect wherever the servlet tells us, if not we render an error message.  Also
 * note that if there was an error or the user did not confirm we need to reactivate the delete
 * button(s).
 *   
 * @param {type} selector
 * @returns {undefined}
 */
KineticSr.app.deleteButton = function (selector) {
    $(selector).click(function(event) {
        event.preventDefault();
        $(selector).prop('disabled', true);
        if (confirm("Are you sure you would like to delete this record?")) {
            KineticSr.app.ajax({
                url: $(this).data('route'),
                type: 'DELETE',
                dataType: 'json',
                accepts: {
                    json: 'application/json'
                },
                success: function(data) {
                    if (data.redirectTo) {
                        window.location.href = KineticSr.app.contextPath + data.redirectTo;
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    $(selector).prop('disabled', false);
                    // If a 400 was returned with JSON data we call the setMessager helper.
                    // Otherwise we just create the message 
                    if (jqXHR.status === 400 && jqXHR.responseJSON) {
                        KineticSr.app.setMessage(jqXHR.responseJSON);
                    } else {
                        KineticSr.app.setMessage({
                            messageType: 'error',
                            message: errorThrown
                        });
                    }
                }
            });
        } else {
            $(selector).prop('disabled', false);
        }
    });
};

/*
 * Helper function that modifies the functionality of the bootstrap dropdown menu feature.  In some
 * areas where the dropdown menu is used (trees table) the menu gets cutoff by the footer because
 * the contianer hides overflow content.  To fix this we had to instead append the dropdown menu to
 * the body of the document.
 */
KineticSr.app.fixDropdown = function(dropdown) {
    // Get the dropdown menu trigger element.
    var trigger = $(dropdown).find('[data-toggle=dropdown]');
    // Get the dropdown menu element.
    var menu = $(dropdown).find('ul.dropdown-menu');
    // Hide the original menu so that is is never shown.
    menu.hide();
    // Create another copy of the menu that will be appended to the body.
    var menuCopy = menu.clone().appendTo('body');

    // Configure a callback that is called when the dropdown is shown (triggered automatically by
    // bootstrap).  The callback shows the copied menu element and positions it beneath the trigger
    // element.
    $(dropdown).on('shown.bs.dropdown', function() {
        var top = trigger.offset().top + trigger.height();
        var left = trigger.offset().left - menuCopy.width() + trigger.width();
        // Append the dropdown menu to the body.
        menuCopy.show().offset({top: top, left: left});
    });

    // Configure a callback that is called when the dropdown is hidden (triggered by bootstrap).
    // The callback simply hides the copied menu.
   $(dropdown).on('hide.bs.dropdown', function() {
        menuCopy.hide();
    });
};

/*
 * INTERNAL HELPER FUNCTIONS
 */
/*
 * This helper function is only called by the KineticSr.app.formWidget function below and does two
 * things that help clean that function up.  The first is to convert the input values to the proper
 * javascript types (string vs. number).  The second is to determine where in the data object to
 * store the value because it may be nested in some cases.
 */
function setData(object, name, value, type) {
    // Initialize the convertedValue variable to the original value.  Depending on the type this
    // value may be updated (for example converted to a number value).
    var convertedValue = value;
    if (type === "number") {
        if (value.constructor === Array) {
            convertedValue = _.collect(value, function(x) {
                return parseInt(x);
            });
        } else {
            convertedValue = parseInt(value);
        }
    }
    // If the name has a . in it we store it as a nested property.
    if (name.match(/\./)) {
        var split = name.split(/\./);
        if (object[split[0]] === undefined) object[split[0]] = {};
        object[split[0]][split[1]] = convertedValue;
    } else {
        object[name] = convertedValue;
    }
}

function moverWidget(source, destination, button) {
    $(button).addClass('disabled');

    $(source).change(function(event) {
       // If an item to be moved from the source is selected, we activate the
       // specified move button.
       if ($(source).val().length > 0) {
           $(button).removeClass('disabled');
       }
    });
    
    $(source).blur(function(event) {
        // On blur, if the blur was not a result of clicking the move button, we reset the selected
        // items from the source and disabled the move button to reset the state of the control.
        if (!mouseDown) {
            $(source).val(null);
            $(button).addClass('disabled');
        }
    });
    
    // Here we create a variable and bind mouse down/up events that track whether or not the button
    // is in the process of being clicked.  It is used in the blur event above because we do not
    // want to perform the blur actions if they are clicking the button.
    var mouseDown = false;
    $(button).mousedown(function() { mouseDown = true; });
    $(button).mouseup(function() { mouseDown = false; });

    $(button).click(function(event) {
        event.preventDefault();
        // Load the destination option elements that we will be insterting into.
        var destinationIndex = 0;
        var destinationOptions = $(destination).find('option');

        // Iterate through each of the selected items from the source.  Detach them
        // from the current select element and insert them into the destination
        // select element.  Note that we iterate through the items in the
        // destination as well to maintain sort order.
        _.each($(source).val(), function(value) {
            // Get the currently selected option and detach it from the source
            // select element.
            var option = $(source).find('option[value="' + value + '"]');
            option.detach();
            // Start looping at the last spot in the destination options we stopped
            // at (or 0 if this is the first loop).  Here we compare the current
            // option to options from the destination until we find the correct spot
            // to insert it.
            while (destinationIndex < destinationOptions.size()) {
                if (option.text() < $(destinationOptions[destinationIndex]).text()) {
                    // Append the option to the destination before the current
                    // destination option.
                    option.insertBefore(destinationOptions[destinationIndex]);
                    // Skip to the next iteration in the source options loop.
                    return true;
                } else {
                    destinationIndex += 1;
                }
            }
            $(destination).append(option);
        });
        // Reset the select elements values to null and disable the move button.
        $(source).val(null);
        $(destination).val(null);
        $(button).addClass('disabled');
    });
}

KineticSr.app.renderConfigurablePropertyFormElement = function(property) {
    var formElement;
    if (property.options && property.options.length === 1) {
        formElement = $('<div>').addClass('input-group')
            .append($('<div>')
                .text(property.options[0].label))
            .append($('<input>').addClass('form-control')
                .attr('id', property.fieldId)
                .attr('data-field', property.dataField)
                .attr('name', property.fieldName)
                .prop('disabled', property.disabled)
                .hide()
                .val(property.value));
    } else if (property.options && property.options.length > 1) {
        formElement = $('<select>').addClass('form-control')
            .attr('id', property.fieldId)
            .attr('data-field', property.dataField)
            .attr('name', property.fieldName)
            .prop('disabled', property.disabled);
        _.each(property.options, function(option) {
            var optionElement = $('<option>')
                .text(option.label)
                .val(option.value);
            if (property.value && property.value === option.value) {
                optionElement.attr('selected', 'selected');
            }
            formElement.append(optionElement);
        });
    } else if (property.sensitive) {
        formElement = KineticSr.app.sensitiveField(
            $('<input>').addClass('form-control')
                .attr('id', property.fieldId)
                .attr('data-field', property.dataField)
                .attr('name', property.fieldName)
                .attr('type', 'password')
                .prop('disabled', property.disabled)
                .val(property.value));
    } else if (property.simplePassword) {
        formElement = $('<input>').addClass('form-control')
                .attr('id', property.fieldId)
                .attr('data-field', property.dataField)
                .attr('name', property.fieldName)
                .attr('type', 'password')
                .prop('disabled', property.disabled)
                .val(property.value);
    } else {
        formElement = $('<input>').addClass('form-control')
            .attr('id', property.fieldId)
            .attr('data-field', property.dataField)
            .attr('name', property.fieldName)
            .attr('type', 'text')
            .prop('disabled', property.disabled)
            .val(property.value);
    }

    if (property.autofocus) {
        formElement.attr('autofocus', 'autofocus');
    }

    return formElement;
};

KineticSr.app.renderConfigurablePropertyGroupElement = function(property, formElement) {
    var label = $('<label>')
        .attr('for', property.fieldId)
        .attr('title', property.description)
        .text(property.label || property.name);
    if (property.required) {
        label.append(' <abbr>*</abbr>');
    }
    return $('<div>').addClass('form-group')
        .append(label)
        .append(formElement);
};

(function($, _, undefined) {
    window.kinetic = window.kinetic || {};
    var kinetic = window.kinetic;

    kinetic.ConfigurableProperties = function ConfigurableProperties(options) {
        // If the constructor method is accidentally called without new, call new automatically
        if(!(this instanceof kinetic.ConfigurableProperties)) {
            return new kinetic.ConfigurableProperties(options);
        }
        // Clone and default the options
        options = $.extend(true, {}, options);
        // Bind 'self' to ensure the instance can be referenced regardless of the scope of 'this'
        var self = this;

        // Obtain a reference to the container element
        var container = $(options.container);

        // Build a map of property names to properties definition and rendered form element
        var propertyCount = 0;
        var propertyMap = _.inject(options.properties, function(result, property) {
            // Add the property to the result map
            result[property.name] = property;
            // If this is the first property, add the autofocus attribute
            if (propertyCount === 0) { property.autofocus = true; }
            // Add the field id and name to the property
            property.fieldName = options.prefix ? options.prefix+'['+property.name+']' : property.name;
            property.fieldId = property.fieldName.replace(/[^a-zA-Z0-9:_\-\.]/g, '');
            property.dataField = options.prefix ? options.prefix + '.' + property.name : property.name;
            // If the disabled option is a boolean set to true, disable all properties
            if ($.type(options.disable) === "boolean" && options.disable === true) {
                property.disabled = true;
            }
            // Else if the disabled option is an array of form element names, and this property name is included
            else if ($.type(options.disable) === "array" && options.disable.indexOf(property.name) !== -1) {
                property.disabled = true;
            }
            // Build the form element (IE input, select, textarea, or wrapping div etc)
            property.formElement = options.renderFormElement(property);
            // Mark the form element as a configurable property so that the dependency event 
            // delegation is applied to it
            property.formElement.attr('data-configurable-property', true);
            // If the property has a dependency, set the dependency name and dependency values 
            // so that the dependency event delegation knows which values to check
            if (property.dependency) {
                property.formElement.data('dependency-name', property.dependency.name);
                property.formElement.data('dependency-values', property.dependency.values);
            }
            // Build the group element
            property.groupElement = options.renderGroupElement(property, property.formElement);
            // Increment the propertyCount counter variable
            propertyCount += 1;
            // Return the result map
            return result;
        }, {});

        // Define the function that will automatically hide/show and enable/disable configurable
        // properties based on the value of the properties they depend on.
        var applyDependencies = function() {
            // For each of the configurable property elements
            _.each(options.properties, function(property) {
                // Check for a dependency
                var dependencyName = property.formElement.data('dependency-name');
                // If the element has a dependency
                if (dependencyName) {
                    // Determine the dependent value
                    var value = propertyMap[dependencyName].formElement.val();
                    // Build an array of dependent values
                    var values = property.formElement.data('dependency-values');
                    // If the dependent values include the value of the dependent property
                    if (_.contains(values, value)) {
                        // Show the group element
                        property.groupElement.show();
                        // Enable the form element
                        property.formElement.prop('disabled', false);
                    }
                    // If the dependent values does not include the value of the dependent property
                    else {
                        // Show the group element
                        property.groupElement.hide();
                        // Enable the form element
                        property.formElement.prop('disabled', true);
                    }
                }
            });
        };

        // Apply the initial dependencies
        applyDependencies();
        // Prepend the property group elements (IE the form elements and associated labels)
        container.prepend(_.collect(options.properties, function(property) {
            // Return the input group
            return property.groupElement;
        }));
        // Add dependency event delegation
        container.delegate('[data-configurable-property]', 'change', applyDependencies);
    };
})(jQuery, _);

// Page load functionality to be applied on every page.
$(function() {
    // Search for any element with the class 'time-ago' and call formatTimestamp on it.
    $('.time-ago').each(function() {
        KineticSr.app.formatTimestamp(this);
    });

    // Search for any forms to disable on submit.  This function binds an on submit event to the
    // designated forms that disables their submit buttons so they cannot be clicked multiple times.
    // This should be used on forms not using the ajax submit, because the ajax form functionality
    // already implements this functionality.
    $('form[data-disable-on-submit=disable-on-submit]').submit(function(event) {
        $(this).find('input[type=submit],button[type=submit]').prop('disabled', true);
    });
});