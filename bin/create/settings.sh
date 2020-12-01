#!/bin/bash

###################################
## Settings
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseSettings/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseSettings.php";

echo '# Create Settings file';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseSettings/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

settings_string=$(cat <<EOF
        # SETTINGS
        \$this->settings_details = array(
            # Admin page
            'create_page' => true,
            'plugin_basename' => plugin_basename(__FILE__),
            # Default
            'plugin_name' => \$this->plugin_settings['name'],
            'plugin_id' => \$this->plugin_settings['id'],
            'option_id' => \$this->plugin_settings['id'] . '_options',
            'sections' => array(
                'import' => array(
                    'name' => __('Import Settings', 'myplugin_id')
                )
            )
        );
        \$this->settings = array(
            'value' => array(
                'label' => __('My Value', 'myplugin_id'),
                'help' => __('A little help.', 'myplugin_id'),
                'type' => 'textarea'
            )
        );
        include dirname(__FILE__) . '/inc/WPUBaseSettings/WPUBaseSettings.php';
        \$this->settings_obj = new \myplugin_id\WPUBaseSettings(\$this->settings_details, \$this->settings);
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${settings_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$settings_obj;" "${_PLUGIN_FILE}";
