/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){tinymce.create("tinymce.plugins.PageBreakPlugin",{init:function(a,b){var c='<img src="'+a.theme.url+'/img/trans.gif" class="mcePageBreak mceItemNoResize" />',d="mcePageBreak",e=a.getParam("pagebreak_separator","<!-- pagebreak -->"),f;f=new RegExp(e.replace(/[\?\.\*\[\]\(\)\{\}\+\^\$\:]/g,function(a){return"\\"+a}),"g"),a.addCommand("mcePageBreak",function(){a.execCommand("mceInsertContent",0,c)}),a.addButton("pagebreak",{title:"pagebreak.desc",cmd:d}),a.onInit.add(function(){a.theme.onResolveName&&a.theme.onResolveName.add(function(b,c){c.node.nodeName=="IMG"&&a.dom.hasClass(c.node,d)&&(c.name="pagebreak")})}),a.onClick.add(function(a,b){b=b.target,b.nodeName==="IMG"&&a.dom.hasClass(b,d)&&a.selection.select(b)}),a.onNodeChange.add(function(a,b,c){b.setActive("pagebreak",c.nodeName==="IMG"&&a.dom.hasClass(c,d))}),a.onBeforeSetContent.add(function(a,b){b.content=b.content.replace(f,c)}),a.onPostProcess.add(function(a,b){b.get&&(b.content=b.content.replace(/<img[^>]+>/g,function(a){return a.indexOf('class="mcePageBreak')!==-1&&(a=e),a}))})},getInfo:function(){return{longname:"PageBreak",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/pagebreak",version:tinymce.majorVersion+"."+tinymce.minorVersion}}}),tinymce.PluginManager.add("pagebreak",tinymce.plugins.PageBreakPlugin)})();