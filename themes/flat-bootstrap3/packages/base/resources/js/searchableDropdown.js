$(document).ready(function () {
/*
    var $searchableSelect = $('.searchableList select.answerValue');

    $searchableSelect.css('z-index', '50');
	// dropdown with class "searchableList"
    $searchableSelect.on('click',function(e) {


		//clone dropdown to use for visuals/display
		// and lay it over the main dropdown
        $(this).parent().parent().css('z-index', '9999');
		var myClone = $(this).clone();

		myClone.removeAttributes();
		myClone.attr(
        {
            'id':'searchableDropDown',
            'type':'multiple'
        })
        .css(
        {
            'width': $(this).width(),
            'position': 'absolute',
            'left': $(this).position().left+'px',
            'top': $(this).position().top+'px'
        });
		myClone.prependTo($(this).parent());
		//create an input to search with
		// and lay it over everything to simulate 
		// searching within the dropdown
		var newInput = $('<input>');
		newInput.attr('id','searchDropDown')
            .css({
                'width': $(this).width() - 20,
                'height': '25px',
                'position': 'absolute',
                'left': $(this).position().left+'px',
                'top': $(this).position().top+'px',
                'z-index': '9920'
            });
		//add to same element as the main dropdown
		$(this).parent().prepend(newInput);
		//Add focus to illicit the user to search
		newInput.focus();
		// simulate opening the dropdown by 
		// increasing it's size
		$('#searchableDropDown').attr('size',6);
		$('#searchableDropDown').css({
			'width':$(this).width(),
			'padding-top':'30px'
		});
        // hide the original dropdown
        $(this).hide();
        //restore z-index
        $(this).parent().parent().css('z-index', 'auto');
	});

	// When an item is picked we update the original dropdown
	// and remove the searching elements
	$('.searchableList').on('click','#searchableDropDown',function() {
		$(this).siblings('select.answerValue').val($(this).val()).show();
			// we need to destroy all input fields before
			// calling fireChange because it takes the first 
			// input in the questionLayer as it's parameter
		$('#searchDropDown').remove();
		var fireId = $(this).siblings('select.answerValue').attr('id');
		$(this).remove();
		KD.utils.Action._fireChange(document.getElementById(fireId));

	});

	// on keyup search and remove items from our
	// cloned dropdown to simulate filtering
	$('.searchableList').on('keyup','#searchDropDown',function(event) {
		// if the user uses the down arrow jump to the searchableDropDown
		if(event.keyCode == 40){
			$('#searchableDropDown option:first').prop('selected',true);
			$('#searchableDropDown').focus();
			return false;
		}
		// for each keystroke we need to have the full values
		// because once you remove them you cannot add them back in
		// here we are cloning the options from our original 
		// dropdown each time
		$(this).siblings('#searchableDropDown').empty();
		$(this).siblings('select.answerValue').children('option').clone().appendTo('#searchableDropDown');

		// if there is actual search criteria then remove options
		if($(this).val() != ""){
			$(this).siblings('#searchableDropDown').find(':not(:contains("'+$(this).val()+'"))').remove();
		}
		// if user hits return with 1 item left in list
		// set that value to the main dropdown and destroy
		// the search fields
		if(event.keyCode == 13 && $('#searchableDropDown option').length == 1) {
			var myVal = $('#searchableDropDown option:first').val();
			$(this).siblings('select.answerValue').val(myVal).show();
			// we need to destroy all input fields before
			// calling fireChange because it takes the first 
			// input in the questionLayer as it's parameter
			$('#searchableDropDown').remove();
			var fireId = $(this).siblings('select.answerValue').attr('id');
			$(this).remove();
			KD.utils.Action._fireChange(document.getElementById(fireId));
			return false;
		}
		// if there are no more options let user know there are
		// no more results
		if($(this).siblings('#searchableDropDown').children().length < 1){
			$(this).siblings('#searchableDropDown').append('<option disabled>No results</option>');
		}
	});

	// Click outside of the dropdown area - remove all searching
	$('.searchableList').on('blur','#searchDropDown',function(event) {
		// blur is too quick so we need time to figure out what was clicked on
		setTimeout(function() {
			// if the click was outside of all the searching fields then destroy
			// all searching elelments and show original dropdown
			if(!$('#searchableDropDown').is(':focus')){
				$('#searchableDropDown').remove();
				$('#searchDropDown').siblings('select.answerValue').show();
				$('#searchDropDown').remove();
				return false;
			}
		},100);
	});

	// key events for searchable dropdown
	$('.searchableList').on('keyup','#searchableDropDown',function(event) {
		event.stopPropagation();
		if(event.keyCode == 13){
			var myVal = $(this).val();
			$(this).siblings('select.answerValue').val(myVal).show();
			// we need to destroy all input fields before
			// calling fireChange because it takes the first 
			// input in the questionLayer as it's parameter
			$('#searchDropDown').remove();
			var fireId = $(this).siblings('select.answerValue').attr('id');
			$(this).remove();
			KD.utils.Action._fireChange(document.getElementById(fireId));
			return false;
		}
	});
 */
});

// override the matching so that it is not case sensitive
jQuery.expr[':'].contains = function(a, i, m) {
  return jQuery(a).text().toUpperCase()
      .indexOf(m[3].toUpperCase()) >= 0;
};

//remove all attributes
jQuery.fn.removeAttributes = function() {
  return this.each(function() {
    var attributes = $.map(this.attributes, function(item) {
      return item.name;
    });
    var img = $(this);
    $.each(attributes, function(i, item) {
    img.removeAttr(item);
    });
  });
};



