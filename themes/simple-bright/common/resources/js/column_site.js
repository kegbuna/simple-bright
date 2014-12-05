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
    $(document).on("*", function(e)
    {
        console.log(e);
    });
});

//My new object will be called keg.. for ken egbuna

var keg = {};

//This function will be fired at the beginning of any service item to provide some additional functionality
keg.startTemplate = function ()
{

};