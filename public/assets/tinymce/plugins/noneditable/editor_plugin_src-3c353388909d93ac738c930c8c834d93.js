/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){var a=tinymce.dom.Event;tinymce.create("tinymce.plugins.NonEditablePlugin",{init:function(a,b){var c=this,d,e,f;c.editor=a,d=a.getParam("noneditable_editable_class","mceEditable"),e=a.getParam("noneditable_noneditable_class","mceNonEditable"),a.onNodeChange.addToTop(function(a,b,d){var g,h;g=a.dom.getParent(a.selection.getStart(),function(b){return a.dom.hasClass(b,e)}),h=a.dom.getParent(a.selection.getEnd(),function(b){return a.dom.hasClass(b,e)});if(g||h)return f=1,c._setDisabled(1),!1;f==1&&(c._setDisabled(0),f=0)})},getInfo:function(){return{longname:"Non editable elements",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/noneditable",version:tinymce.majorVersion+"."+tinymce.minorVersion}},_block:function(b,c){var d=c.keyCode;if(d>32&&d<41||d>111&&d<124)return;return a.cancel(c)},_setDisabled:function(a){var b=this,c=b.editor;tinymce.each(c.controlManager.controls,function(b){b.setDisabled(a)}),a!==b.disabled&&(a?(c.onKeyDown.addToTop(b._block),c.onKeyPress.addToTop(b._block),c.onKeyUp.addToTop(b._block),c.onPaste.addToTop(b._block),c.onContextMenu.addToTop(b._block)):(c.onKeyDown.remove(b._block),c.onKeyPress.remove(b._block),c.onKeyUp.remove(b._block),c.onPaste.remove(b._block),c.onContextMenu.remove(b._block)),b.disabled=a)}}),tinymce.PluginManager.add("noneditable",tinymce.plugins.NonEditablePlugin)})();