<?php
if (!defined('WP_UNINSTALL_PLUGIN')) {
    die;
}

/* Delete options */
$options = array(
    'wpuplugincreatorpluginid__cron_hook_croninterval',
    'wpuplugincreatorpluginid__cron_hook_lastexec',
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

/* Delete all terms */
$taxonomy = 'your_taxonomy';
$terms = get_terms($taxonomy, array('hide_empty' => false));
foreach ($terms as $term) {
    wp_delete_term($term->term_id, $taxonomy);
}
