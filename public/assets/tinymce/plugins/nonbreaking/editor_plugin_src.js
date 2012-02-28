/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){tinymce.create("tinymce.plugins.Nonbreaking",{init:function(a,b){var c=this;c.editor=a,a.addCommand("mceNonBreaking",function(){a.execCommand("mceInsertContent",!1,a.plugins.visualchars&&a.plugins.visualchars.state?'<span data-mce-bogus="1" class="mceItemHidden mceItemNbsp">&nbsp;</span>':"&nbsp;")}),a.addButton("nonbreaking",{title:"nonbreaking.nonbreaking_desc",cmd:"mceNonBreaking"}),a.getParam("nonbreaking_force_tab")&&a.onKeyDown.add(function(a,b){b.keyCode==9&&(b.preventDefault(),a.execCommand("mceNonBreaking"),a.execCommand("mceNonBreaking"),a.execCommand("mceNonBreaking"))})},getInfo:function(){return{longname:"Nonbreaking space",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/nonbreaking",version:tinymce.majorVersion+"."+tinymce.minorVersion}}}),tinymce.PluginManager.add("nonbreaking",tinymce.plugins.Nonbreaking)})();