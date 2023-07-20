<?php
if (!defined('WP_UNINSTALL_PLUGIN')) {
    die;
}

/* Delete options */
$options = array(
    'wpuplugincreatorpluginid_options',
    'wpuplugincreatorpluginid_wpuplugincreatorpluginid_version'
);
foreach ($options as $opt) {
    delete_option($opt);
    delete_site_option($opt);
}

/* Delete tables */
global $wpdb;
$wpdb->query("DROP TABLE IF EXISTS {$wpdb->prefix}wpuplugincreatorpluginid");

/* Delete all posts */
$allposts = get_posts(array(
    'post_type' => 'wpuplugincreatorpluginid',
    'numberposts' => -1,
    'fields' => 'ids'
));
foreach ($allposts as $p) {
    wp_delete_post($p, true);
}
