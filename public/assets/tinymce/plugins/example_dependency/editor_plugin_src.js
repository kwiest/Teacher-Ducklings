/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */
(function(){tinymce.create("tinymce.plugins.ExampleDependencyPlugin",{init:function(a,b){},getInfo:function(){return{longname:"Example Dependency plugin",author:"Some author",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/example_dependency",version:"1.0"}}}),tinymce.PluginManager.add("example_dependency",tinymce.plugins.ExampleDependencyPlugin,["example"])})();