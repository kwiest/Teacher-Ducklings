/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){tinymce.create("tinymce.plugins.Directionality",{init:function(a,b){var c=this;c.editor=a,a.addCommand("mceDirectionLTR",function(){var b=a.dom.getParent(a.selection.getNode(),a.dom.isBlock);b&&(a.dom.getAttrib(b,"dir")!="ltr"?a.dom.setAttrib(b,"dir","ltr"):a.dom.setAttrib(b,"dir","")),a.nodeChanged()}),a.addCommand("mceDirectionRTL",function(){var b=a.dom.getParent(a.selection.getNode(),a.dom.isBlock);b&&(a.dom.getAttrib(b,"dir")!="rtl"?a.dom.setAttrib(b,"dir","rtl"):a.dom.setAttrib(b,"dir","")),a.nodeChanged()}),a.addButton("ltr",{title:"directionality.ltr_desc",cmd:"mceDirectionLTR"}),a.addButton("rtl",{title:"directionality.rtl_desc",cmd:"mceDirectionRTL"}),a.onNodeChange.add(c._nodeChange,c)},getInfo:function(){return{longname:"Directionality",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/directionality",version:tinymce.majorVersion+"."+tinymce.minorVersion}},_nodeChange:function(a,b,c){var d=a.dom,e;c=d.getParent(c,d.isBlock);if(!c){b.setDisabled("ltr",1),b.setDisabled("rtl",1);return}e=d.getAttrib(c,"dir"),b.setActive("ltr",e=="ltr"),b.setDisabled("ltr",0),b.setActive("rtl",e=="rtl"),b.setDisabled("rtl",0)}}),tinymce.PluginManager.add("directionality",tinymce.plugins.Directionality)})();