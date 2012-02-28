/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){var a=tinymce.DOM,b=tinymce.dom.Event,c=tinymce.each,d=tinymce.explode;tinymce.create("tinymce.plugins.TabFocusPlugin",{init:function(e,f){function g(a,c){if(c.keyCode===9)return b.cancel(c)}function h(e,f){function l(b){function d(a){return a.nodeName==="BODY"||a.type!="hidden"&&a.style.display!="none"&&a.style.visibility!="hidden"&&d(a.parentNode)}function f(a){return a.attributes.tabIndex.specified||a.nodeName=="INPUT"||a.nodeName=="TEXTAREA"}function i(){return tinymce.isIE6||tinymce.isIE7}function k(a){return(!i()||f(a))&&a.getAttribute("tabindex")!="-1"&&d(a)}j=a.select(":input:enabled,*[tabindex]"),c(j,function(a,b){if(a.id==e.id)return g=b,!1});if(b>0){for(h=g+1;h<j.length;h++)if(k(j[h]))return j[h]}else for(h=g-1;h>=0;h--)if(k(j[h]))return j[h];return null}var g,h,i,j,k;if(f.keyCode===9){k=d(e.getParam("tab_focus",e.getParam("tabfocus_elements",":prev,:next"))),k.length==1&&(k[1]=k[0],k[0]=":prev"),f.shiftKey?k[0]==":prev"?j=l(-1):j=a.get(k[0]):k[1]==":next"?j=l(1):j=a.get(k[1]);if(j)return j.id&&(e=tinymce.get(j.id||j.name))?e.focus():window.setTimeout(function(){tinymce.isWebKit||window.focus(),j.focus()},10),b.cancel(f)}}e.onKeyUp.add(g),tinymce.isGecko?(e.onKeyPress.add(h),e.onKeyDown.add(g)):e.onKeyDown.add(h)},getInfo:function(){return{longname:"Tabfocus",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/tabfocus",version:tinymce.majorVersion+"."+tinymce.minorVersion}}}),tinymce.PluginManager.add("tabfocus",tinymce.plugins.TabFocusPlugin)})();