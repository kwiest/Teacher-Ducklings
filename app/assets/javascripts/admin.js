//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require tinymce-jquery
//= require bootstrap-tooltip
//= require video
//= require swfobject.js
//= require jquery.uploadify.v2.1.4.min.js
//= require_self

$(function() {
  VideoJS.setupAllWhenReady();

  $('.datepicker').datepicker({dateFormat: "yy-mm-dd"});
  
  // TinyMCE Rich Text Editor
  $('.tinymce').tinymce({
    theme: 'advanced',
    theme_advanced_buttons1: 'formatselect,fontsizeselect,bold,italic,underline,strikethrough,separator,justifyleft,justifycenter,justifyright,separator,bullist,numlist,separator,link,unlink,undo,redo',
    theme_advanced_buttons2: '',
    theme_advanced_buttons3: '',
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_resizing : false,
    width: "50%"
  });
  
  // Calendar Tooltip
  $('.has-tip').tooltip({
    showURL: false,
    fixPNG: true,
    top: -120,
    left: -100,
    track: true,
  });
		
});
