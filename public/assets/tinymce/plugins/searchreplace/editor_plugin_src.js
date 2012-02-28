/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){tinymce.create("tinymce.plugins.SearchReplacePlugin",{init:function(a,b){function c(c){window.focus(),a.windowManager.open({file:b+"/searchreplace.htm",width:420+parseInt(a.getLang("searchreplace.delta_width",0)),height:170+parseInt(a.getLang("searchreplace.delta_height",0)),inline:1,auto_focus:0},{mode:c,search_string:a.selection.getContent({format:"text"}),plugin_url:b})}a.addCommand("mceSearch",function(){c("search")}),a.addCommand("mceReplace",function(){c("replace")}),a.addButton("search",{title:"searchreplace.search_desc",cmd:"mceSearch"}),a.addButton("replace",{title:"searchreplace.replace_desc",cmd:"mceReplace"}),a.addShortcut("ctrl+f","searchreplace.search_desc","mceSearch")},getInfo:function(){return{longname:"Search/Replace",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/searchreplace",version:tinymce.majorVersion+"."+tinymce.minorVersion}}}),tinymce.PluginManager.add("searchreplace",tinymce.plugins.SearchReplacePlugin)})();