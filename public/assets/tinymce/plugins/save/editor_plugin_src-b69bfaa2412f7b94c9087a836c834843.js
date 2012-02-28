/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){tinymce.create("tinymce.plugins.Save",{init:function(a,b){var c=this;c.editor=a,a.addCommand("mceSave",c._save,c),a.addCommand("mceCancel",c._cancel,c),a.addButton("save",{title:"save.save_desc",cmd:"mceSave"}),a.addButton("cancel",{title:"save.cancel_desc",cmd:"mceCancel"}),a.onNodeChange.add(c._nodeChange,c),a.addShortcut("ctrl+s",a.getLang("save.save_desc"),"mceSave")},getInfo:function(){return{longname:"Save",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/save",version:tinymce.majorVersion+"."+tinymce.minorVersion}},_nodeChange:function(a,b,c){var a=this.editor;a.getParam("save_enablewhendirty")&&(b.setDisabled("save",!a.isDirty()),b.setDisabled("cancel",!a.isDirty()))},_save:function(){var a=this.editor,b,c,d,e;b=tinymce.DOM.get(a.id).form||tinymce.DOM.getParent(a.id,"form");if(a.getParam("save_enablewhendirty")&&!a.isDirty())return;tinyMCE.triggerSave();if(c=a.getParam("save_onsavecallback")){a.execCallback("save_onsavecallback",a)&&(a.startContent=tinymce.trim(a.getContent({format:"raw"})),a.nodeChanged());return}b?(a.isNotDirty=!0,(b.onsubmit==null||b.onsubmit()!=0)&&b.submit(),a.nodeChanged()):a.windowManager.alert("Error: No form element found.")},_cancel:function(){var a=this.editor,b,c=tinymce.trim(a.startContent);if(b=a.getParam("save_oncancelcallback")){a.execCallback("save_oncancelcallback",a);return}a.setContent(c),a.undoManager.clear(),a.nodeChanged()}}),tinymce.PluginManager.add("save",tinymce.plugins.Save)})();