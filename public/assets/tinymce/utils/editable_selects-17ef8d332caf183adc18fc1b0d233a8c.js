/**
 * editable_selects.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
var TinyMCE_EditableSelects={editSelectElm:null,init:function(){var a=document.getElementsByTagName("select"),b,c=document,d;for(b=0;b<a.length;b++)a[b].className.indexOf("mceEditableSelect")!=-1&&(d=new Option(tinyMCEPopup.editor.translate("value"),"__mce_add_custom__"),d.className="mceAddSelectValue",a[b].options[a[b].options.length]=d,a[b].onchange=TinyMCE_EditableSelects.onChangeEditableSelect)},onChangeEditableSelect:function(a){var b=document,c,d=window.event?window.event.srcElement:a.target;d.options[d.selectedIndex].value=="__mce_add_custom__"&&(c=b.createElement("input"),c.id=d.id+"_custom",c.name=d.name+"_custom",c.type="text",c.style.width=d.offsetWidth+"px",d.parentNode.insertBefore(c,d),d.style.display="none",c.focus(),c.onblur=TinyMCE_EditableSelects.onBlurEditableSelectInput,c.onkeydown=TinyMCE_EditableSelects.onKeyDown,TinyMCE_EditableSelects.editSelectElm=d)},onBlurEditableSelectInput:function(){var a=TinyMCE_EditableSelects.editSelectElm;a&&(a.previousSibling.value!=""?(addSelectValue(document.forms[0],a.id,a.previousSibling.value,a.previousSibling.value),selectByValue(document.forms[0],a.id,a.previousSibling.value)):selectByValue(document.forms[0],a.id,""),a.style.display="inline",a.parentNode.removeChild(a.previousSibling),TinyMCE_EditableSelects.editSelectElm=null)},onKeyDown:function(a){a=a||window.event,a.keyCode==13&&TinyMCE_EditableSelects.onBlurEditableSelectInput()}};