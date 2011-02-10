// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
	$('.datepicker').datepicker({dateFormat: "yy-mm-dd"});
	
	// TinyMCE Rich Text Editor
	$('.tinymce').tinymce({
		script_url: '/tiny_mce/tiny_mce.js',
		theme: 'advanced',
		theme_advanced_buttons1: 'formatselect,fontsizeselect,bold,italic,underline,strikethrough,separator,justifyleft,justifycenter,justifyright,separator,bullist,numlist,separator,link,unlink,undo,redo',
		theme_advanced_buttons2: '',
		theme_advanced_buttons3: '',
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_resizing : false,
		width: "50%"
	});
	
	// AJAX Comment post
	$('#new_comment').submit(function() {
		$.ajax({
			type: 			'POST'
			, url: 			$(this).attr("action") + '.json'
			, data: ({
				comment: {
					user_id: 	$('#comment_user_id').attr('value')
					, name: 	$('#comment_name').attr('value')
					, email: 	$('#comment_email').attr('value')
					, body: 	$('#comment_body').attr('value')					
				}
			})
			, dataType: 'JSON'
			, success: 	function(data) {
				$('#comments').append(data).effect('highlight');
				$('#comment_body').val('');
			}
			, error: 		function() {
				alert("Sorry, there was an error while trying to post your comment.");
			}
		});
		
		return false;
	});
		
});