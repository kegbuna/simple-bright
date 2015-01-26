;$(document).ready(function (event) {

    /**
     * Bind an event handler to the window to catch when the user tries to navigate without using
     * the form controls.
     */
    function bindWindowUnload () {
        window.onbeforeunload = function() {
            return "Really leave this page?";
        };
    }

    /**
     * Clears the event handler bound to the window on before unload.
     */
    function unbindWindowUnload () {
        window.onbeforeunload = function (){};
    }
    
    // bind the window unload function
    bindWindowUnload();

    // Add click handlers to buttons
    $("button.btn").on("click", function (event) {
        // prevent the default form submit
        event.preventDefault();
        // disable all buttons to prevent the user from clicking multiple actions
        $(".btn").attr("disabled", "disabled");
        // unbind the window unload event so the form can submit
        unbindWindowUnload();
        // get the current button that was clicked to obtain the parent form
        var target = $(event.target);
        var form = target.closest("form")[0];
        // set the confirmedAction input element
        $("#confirmedAction").val(target.val());
        // submit the form
        form.submit();
    });
    
    // Add click handlers to links
    $("a.btn").on("click", function(event) {
        // unbind the window unload event so the form can submit
        unbindWindowUnload();
    });
    
    // Set focus to the first form element when page is ready
    $("form :input:not(:button):visible:enabled:first").focus();
    
});