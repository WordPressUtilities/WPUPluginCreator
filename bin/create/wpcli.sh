#!/bin/bash

###################################
## WP-Cli
###################################

echo '# Create WP-CLI action';

wpcli_string=$(cat <<EOF
if (defined('WP_CLI') && WP_CLI) {
    /* Simple action */
    WP_CLI::add_command('myplugin_id-action', function (\$args = array()) {
        WP_CLI::success('Action');
    }, array(
        'shortdesc' => 'My WP-CLI action',
        'synopsis' => array()
    ));

    /* Action with choice */
    WP_CLI::add_command('myplugin_id-action-choice', function (\$args) {
        if (!is_array(\$args) || empty(\$args)) {
            return;
        }
        if (\$args[0] == 'enable') {
            WP_CLI::success('Enabled');
        }
        if (\$args[0] == 'disable') {
            WP_CLI::success('Disabled');
        }
    }, array(
        'shortdesc' => 'Enable or disable mode.',
        'longdesc' =>   '## EXAMPLES' . "\n\n" . 'wp myplugin_id-action-choice enable'. "\n" . 'wp myplugin_id-action-choice disable',
        'synopsis' => array(
            array(
                'type'        => 'positional',
                'name'        => 'enable_or_disable',
                'description' => 'Enable or disable mode.',
                'optional'    => false,
                'repeating'   => false,
                'options'     => array( 'enable', 'disable' ),
            )
        ),
    ));
}
EOF
);

echo "${wpcli_string}" >> "${_PLUGIN_FILE}";
