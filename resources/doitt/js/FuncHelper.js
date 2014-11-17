var FuncHelper = (function(){
	var f = {};
	
	var min_divs = [];
	
	f.checkForMinimumFields = function(){
		var divs = document.getElementsByTagName('div');
		var i;
		
		for(i=0;i<divs.length;i++){
			if(divs[i].className.indexOf("validate") > -1){
				min_divs.push(divs[i]);
			}
		}
		
		for(i=0;i<min_divs.length;i++){
			var start_pos = min_divs[i].className.indexOf("validate") + "validate".length;
			var end_pos = min_divs[i].className.indexOf(" ", start_pos);
			
			if(end_pos == -1)
				end_pos = min_divs[i].className.length;
				
			var min = min_divs[i].className.substring(start_pos, end_pos);
			
			var div = document.createElement('div');
			div.className = "min-text";
			div.innerHTML = generateMinimumText(min, 0);
			
			var textarea = min_divs[i].getElementsByTagName("textarea")[0];
			textarea.addEventListener("keyup", function(){
				div.innerHTML = generateMinimumText(min, textarea.value.length);
			});
			
			min_divs[i].appendChild(div);
		}
	}
	
	function generateMinimumText(num, entered){
		var text = "Minimum " + num + " Characters. <span class=\"min-helper\">(<span class=\"min-entered\">" + entered + "</span> characters entered)</span>";
		
		return text;
	}
	
	return f;
}());