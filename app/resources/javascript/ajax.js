// Create a scope for the ajax functionality.
(function() {
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
})();