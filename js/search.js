"use strict";

// global variables
var ajaxURL;
var params;
var defaultHash = "dept=all&term=all&day=all&time=all&faculty=all&course_group=all&keyword=&sort=&page=1";
var total = $('#search_field .param').length;

// reset courses function, to be run on load and on click of "start over"
function resetCourses() {
	// clear results
	$("#results-container").html('<div id="results-container" class="row row-offcanvas row-offcanvas-right"><h4>Over 3,000 courses are offered by over 1,000 faculty members within the Faculty of Arts and Sciences. <br>To find a course, please select from the options above.</h4><ul><li><a href="http://www.registrar.fas.harvard.edu/fasro/courses/index.jsp?cat=ugrad&amp;subcat=courses/" target="_blank">Courses of Instruction</a>, <em>Official Register of Harvard University, Faculty of Arts and Sciences</em></li><li><a href="http://q.fas.harvard.edu/" target="_blank">The Q Guide</a>, <em>FAS Office of the Registrar</em><ul><li>Information and student ratings on courses.</li></ul></li><li><a href="http://www.dce.harvard.edu/" target="_blank">Division of Continuing Education</a></li></ul></div>');

	// Set all inputs back to "all"
	$("#search_field .param").each(function(index) {
		$("select#course_group option").val("all");
		var defaultOption = $(this).find('option[value="*"]');
		$(defaultOption).attr("selected", "selected");
	});

	window.location.hash = defaultHash;
	updateInputs(defaultHash);
}

// based on the new hash params, update all inputs on the page
function updateInputs(hash) {
	var inputValues = (function(a) {
	    if (a == "") return {};
	    var b = {};
	    for (var i = 0; i < a.length; ++i)
	    {
	        var p=a[i].split('=');
	        if (p.length != 2) continue;
	        b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
	    }
	    return b;
	})(hash.split('&'));

	// reset all inputs to "All"
	$("#search_field option").removeAttr('selected');

	for (var key in inputValues) {
		var dropdown = "select#" + key;

		if(key === "course_group") {
			$("select#course_group option").val(inputValues[key]);
		} else if (key === "keyword") {
			$("#keyword").val(inputValues[key]);
		} else {
			var newOption = dropdown + " option[value=" + inputValues[key] + "]";
			$(newOption).attr("selected",true);
		}

	}

}



// searches through selected inputs and grabs params needed for AJAX call, then runs getCourses;
function getParams() {
 
	// clear params
	var query;
	params = "";

	// loop through all search fields and build query string
	$("#search_field option:selected").each(function(index) {
		var param = $(this).closest('select').attr('id');
		var value = $(this).attr('value');

		// if we are on the last one, don't add the &
		if (index === total - 2) {
			query = param + "=" + value;
		} else {
			query = param + "=" + value + "&";
		}
		params += query;
	});

	// update hash with new params
	window.location.hash = params;

	// add keyword to hash
	hash.add({ keyword: $("#keyword").val() });

	// add sort
	hash.add({ sort: "department"})

	// add default page to hash
	hash.add({ page: "1" });

	// run getCourses with new query
	getCourses(window.location.hash);


}
// function to return course data via ajax
function getCourses(params) {

	params = params.replace("#", "");

	window.location.hash = params;

	ajaxURL = "http://" + window.location.host + "/cocoon/final_project/ajax/search.pdf?" + params;

	$("#results-container").html("Loading courses...");

	$.ajax({
	    type:'post',
	    url: 'ajax/search.xml?' + params,
	    success:function(xmlData){
	    	$("#results-container").html(xmlData);
			$('#pdf_link').attr('href',  ajaxURL);

			// attach event handler to new narrow-by navigation
			$('.narrow-results').on( "click", function(e)  {
				e.preventDefault();
				var param = $(this).closest('ul').attr('id');
				var paramVal = $(this).attr('id');
				narrowResults(param, paramVal);
			});

			$('.remove-result').on("click", function(e) {
				e.preventDefault();
				var param = $(this).attr('id');
				removeResults(param);
			});

			$('.sort-results').on("click", function(e) {
				e.preventDefault();
				var param = $(this).attr('id');
				sortResults(param);
			});

			
			$('.pagination').jqPagination({
				link_string	: params.slice(0, params.lastIndexOf("&")) + '&page={page_number}',
				current_page : hash.get('page'), 
				max_page : $("#total-pages").html(),
				paged		: function(page) {
					$('.log').prepend('<li>Requested page ' + page + '</li>');
				}
			});

			$(".pagination a").on("click", function(e) {
				e.preventDefault();
				var param = $(this).attr('href');
				//console.log('running AJAX call with these params: ' + param);
				getCourses(param);
			});

	    }
	});
}

// narrow results functionality updates URL params prior to re-running getCourses() data pull
function narrowResults(param, paramVal) {

	var param = param.split("-").pop();
	var dropdown = "select#" + param;
	var newOption = dropdown + " option[value=" + paramVal + "]";

	if (param === "course_group") {
		$("select#course_group option").val(paramVal);
	} else {
		$(dropdown + " option").removeAttr('selected');
		$(newOption).attr("selected",true);
	}

	getParams();
}

function removeResults(param) {

	var param = param.split("-").pop();
	var dropdown = "select#" + param;														

	if (param === "course_group") {
		$("select#course_group option").val("all");
	} else {
		$(dropdown + " option").removeAttr('selected');
	}

	getParams();
}

function sortResults(param) {
	hash.add({ sort: param });
	getCourses(window.location.hash);
}


// jQuery on ready functions
$(document).ready(function() {

	if(window.location.hash) {
	  // reload courses & update inputs
	  var hash = window.location.hash.substring(1);
	  updateInputs(hash);
	  getCourses(hash);
	} else {
	  // do nothing
	}
	
	// main search button click
	$('input#search').click(function(e) {
		getParams();
	});

	// reset button click
	$('#reset').click(function() {
		resetCourses();
	});

	$('.narrow-results').on( "click", function(e)  {
		e.preventDefault();
		var param = $(this).closest('ul').attr('id');
		var paramVal = $(this).attr('id');
		narrowResults(param, paramVal);
	});

	$('.remove-result').on("click", function(e) {
		e.preventDefault();
		var param = $(this).attr('id');
		removeResults(param);
	});

	$('.sort-results').on("click", function(e) {
		e.preventDefault();
		getParams();
		var param = $(this).attr('id');
		sortResults(param);
	});


});