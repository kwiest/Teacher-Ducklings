/**
 * del.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
function init(){SXE.initElementDialog("del"),SXE.currentAction=="update"&&(setFormValue("datetime",tinyMCEPopup.editor.dom.getAttrib(SXE.updateElement,"datetime")),setFormValue("cite",tinyMCEPopup.editor.dom.getAttrib(SXE.updateElement,"cite")),SXE.showRemoveButton())}function setElementAttribs(a){setAllCommonAttribs(a),setAttrib(a,"datetime"),setAttrib(a,"cite"),a.removeAttribute("data-mce-new")}function insertDel(){var a=tinyMCEPopup.editor.dom.getParent(SXE.focusElement,"DEL");if(a==null){var b=SXE.inst.selection.getContent();if(b.length>0){insertInlineElement("del");var c=SXE.inst.dom.select("del[data-mce-new]");for(var d=0;d<c.length;d++){var a=c[d];setElementAttribs(a)}}}else setElementAttribs(a);tinyMCEPopup.editor.nodeChanged(),tinyMCEPopup.execCommand("mceEndUndoLevel"),tinyMCEPopup.close()}function removeDel(){SXE.removeElement("del"),tinyMCEPopup.close()}tinyMCEPopup.onInit.add(init);