#!/bin/bash

###################################
## WP-Cli
###################################

echo '# Create WP-CLI action';

wpcli_string=$(cat <<EOF
if (defined('WP_CLI') && WP_CLI) {
    WP_CLI::add_command('myplugin_id-action', function (\$args = array()) {
        echo "Action";
    }, array(
        'shortdesc' => 'My WP-CLI action',
        'synopsis' => array()
    ));
}

EOF
);

echo "${wpcli_string}" >> "${_PLUGIN_FILE}";
