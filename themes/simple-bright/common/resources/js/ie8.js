/**
 * Created by Kegbuna on 1/20/2015.
 * some quick ie8 fixes
 */

//Placeholder fix

$(document).ready(function ()
{
    $('.placeholder').each(function()
    {
        var $this = $(this);

        //passwords are tricky
        if ($this.attr('type') == "password")
        {
            var $fakePass = $('#Fake' + $this.attr('id'));

            //have to do this initially because we want keep the compatibility code separate
            $fakePass.show();
            $this.hide();

            $fakePass.on('focus', function(e)
            {
                $fakePass.hide();
                $this.show();
                $this.focus();
            });

            $this.on('blur', function()
            {
                if ($this.val() == '')
                {
                    $this.hide();
                    $fakePass.show();
                }
            })
        }
        else if ($this.attr("placeholder"))
        {
            if ($this.val() == '')
            {
                $this.val($this.attr('placeholder'));
            }
            $this.on('focus blur', function(e)
            {
                if (e.type == "focus")
                {
                    if ($this.val() == $this.attr("placeholder"))
                    {
                        $this.val('');
                    }
                }
                if (e.type == "blur")
                {
                    if ($this.val() == '')
                    {
                        $this.val($this.attr('placeholder'));
                    }
                }
            });
        }
    });
});


