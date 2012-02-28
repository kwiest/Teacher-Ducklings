/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 *
 * Adds auto-save capability to the TinyMCE text editor to rescue content
 * inadvertently lost. This plugin was originally developed by Speednet
 * and that project can be found here: http://code.google.com/p/tinyautosave/
 *
 * TECHNOLOGY DISCUSSION:
 * 
 * The plugin attempts to use the most advanced features available in the current browser to save
 * as much content as possible.  There are a total of four different methods used to autosave the
 * content.  In order of preference, they are:
 * 
 * 1. localStorage - A new feature of HTML 5, localStorage can store megabytes of data per domain
 * on the client computer. Data stored in the localStorage area has no expiration date, so we must
 * manage expiring the data ourselves.  localStorage is fully supported by IE8, and it is supposed
 * to be working in Firefox 3 and Safari 3.2, but in reality is is flaky in those browsers.  As
 * HTML 5 gets wider support, the AutoSave plugin will use it automatically. In Windows Vista/7,
 * localStorage is stored in the following folder:
 * C:\Users\[username]\AppData\Local\Microsoft\Internet Explorer\DOMStore\[tempFolder]
 * 
 * 2. sessionStorage - A new feature of HTML 5, sessionStorage works similarly to localStorage,
 * except it is designed to expire after a certain amount of time.  Because the specification
 * around expiration date/time is very loosely-described, it is preferrable to use locaStorage and
 * manage the expiration ourselves.  sessionStorage has similar storage characteristics to
 * localStorage, although it seems to have better support by Firefox 3 at the moment.  (That will
 * certainly change as Firefox continues getting better at HTML 5 adoption.)
 * 
 * 3. UserData - A very under-exploited feature of Microsoft Internet Explorer, UserData is a
 * way to store up to 128K of data per "document", or up to 1MB of data per domain, on the client
 * computer.  The feature is available for IE 5+, which makes it available for every version of IE
 * supported by TinyMCE.  The content is persistent across browser restarts and expires on the
 * date/time specified, just like a cookie.  However, the data is not cleared when the user clears
 * cookies on the browser, which makes it well-suited for rescuing autosaved content.  UserData,
 * like other Microsoft IE browser technologies, is implemented as a behavior attached to a
 * specific DOM object, so in this case we attach the behavior to the same DOM element that the
 * TinyMCE editor instance is attached to.
 */
(function(a){var b="autosave",c="restoredraft",d=!0,e,f,g=a.util.Dispatcher;a.create("tinymce.plugins.AutoSave",{init:function(h,i){function l(a){var b={s:1e3,m:6e4};return a=/^(\d+)([ms]?)$/.exec(""+a),(a[2]?b[a[2]]:1)*parseInt(a)}var j=this,k=h.settings;j.editor=h,a.each({ask_before_unload:d,interval:"30s",retention:"20m",minlength:50},function(a,c){c=b+"_"+c,k[c]===e&&(k[c]=a)}),k.autosave_interval=l(k.autosave_interval),k.autosave_retention=l(k.autosave_retention),h.addButton(c,{title:b+".restore_content",onclick:function(){h.getContent({draft:!0}).replace(/\s|&nbsp;|<\/?p[^>]*>|<br[^>]*>/gi,"").length>0?h.windowManager.confirm(b+".warning_message",function(a){a&&j.restoreDraft()}):j.restoreDraft()}}),h.onNodeChange.add(function(){var a=h.controlManager;a.get(c)&&a.setDisabled(c,!j.hasDraft())}),h.onInit.add(function(){h.controlManager.get(c)&&(j.setupStorage(h),setInterval(function(){j.storeDraft(),h.nodeChanged()},k.autosave_interval))}),j.onStoreDraft=new g(j),j.onRestoreDraft=new g(j),j.onRemoveDraft=new g(j),f||(window.onbeforeunload=a.plugins.AutoSave._beforeUnloadHandler,f=d)},getInfo:function(){return{longname:"Auto save",author:"Moxiecode Systems AB",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/autosave",version:a.majorVersion+"."+a.minorVersion}},getExpDate:function(){return(new Date((new Date).getTime()+this.editor.settings.autosave_retention)).toUTCString()},setupStorage:function(c){var e=this,f=b+"_test",g="OK";e.key=b+c.id,a.each([function(){if(localStorage){localStorage.setItem(f,g);if(localStorage.getItem(f)===g)return localStorage.removeItem(f),localStorage}},function(){if(sessionStorage){sessionStorage.setItem(f,g);if(sessionStorage.getItem(f)===g)return sessionStorage.removeItem(f),sessionStorage}},function(){if(a.isIE)return c.getElement().style.behavior="url('#default#userData')",{autoExpires:d,setItem:function(a,b){var d=c.getElement();d.setAttribute(a,b),d.expires=e.getExpDate();try{d.save("TinyMCE")}catch(f){}},getItem:function(a){var b=c.getElement();try{return b.load("TinyMCE"),b.getAttribute(a)}catch(d){return null}},removeItem:function(a){c.getElement().removeAttribute(a)}}}],function(a){try{e.storage=a();if(e.storage)return!1}catch(b){}})},storeDraft:function(){var a=this,b=a.storage,c=a.editor,d,e;if(b){if(!b.getItem(a.key)&&!c.isDirty())return;e=c.getContent({draft:!0}),e.length>c.settings.autosave_minlength&&(d=a.getExpDate(),a.storage.autoExpires||a.storage.setItem(a.key+"_expires",d),a.storage.setItem(a.key,e),a.onStoreDraft.dispatch(a,{expires:d,content:e}))}},restoreDraft:function(){var a=this,b=a.storage,c;b&&(c=b.getItem(a.key),c&&(a.editor.setContent(c),a.onRestoreDraft.dispatch(a,{content:c})))},hasDraft:function(){var a=this,b=a.storage,c,e;if(b){e=!!b.getItem(a.key);if(e){if(!!a.storage.autoExpires)return d;c=new Date(b.getItem(a.key+"_expires"));if((new Date).getTime()<c.getTime())return d;a.removeDraft()}}return!1},removeDraft:function(){var a=this,b=a.storage,c=a.key,d;b&&(d=b.getItem(c),b.removeItem(c),b.removeItem(c+"_expires"),d&&a.onRemoveDraft.dispatch(a,{content:d}))},"static":{_beforeUnloadHandler:function(b){var c;return a.each(tinyMCE.editors,function(a){a.plugins.autosave&&a.plugins.autosave.storeDraft();if(a.getParam("fullscreen_is_enabled"))return;!c&&a.isDirty()&&a.getParam("autosave_ask_before_unload")&&(c=a.getLang("autosave.unload_msg"))}),c}}}),a.PluginManager.add("autosave",a.plugins.AutoSave)})(tinymce);