<?php
/*
Plugin Name: myplugin_name
Plugin URI: https://github.com/WordPressUtilities/myplugin_id
Description: MYDESCRIPTION
Version: 0.1.0
Author: author_name
Author URI: https://author_name.me/
License: MIT License
License URI: http://opensource.org/licenses/MIT
*/

class myplugin_classname {
    private $plugin_version = '0.1.0';
    private $plugin_id = 'myplugin_id';

    public function __construct() {
        add_filter('plugins_loaded', array(&$this, 'plugins_loaded'));
        ##CONSTRUCT##
    }

    public function plugins_loaded() {
        ##PLUGINS_LOADED##
    }

    ##METHODS##
}

$myplugin_classname = new myplugin_classname();
