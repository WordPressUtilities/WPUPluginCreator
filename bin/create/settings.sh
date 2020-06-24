#!/bin/bash

###################################
## Settings
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseSettings/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseSettings.php";

echo '# Create Settings file';
_INC_DIR="${_PLUGIN_DIR}inc/";
if [[ ! -d "${_INC_DIR}" ]];then
    mkdir "${_INC_DIR}";
fi;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseSettings/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

settings_string=$(cat <<EOF
        # SETTINGS
        \$this->settings_details = array(
            # Admin page
            'create_page' => true,
            'plugin_basename' => plugin_basename(__FILE__),
            # Default
            'plugin_name' => 'myplugin_name',
            'plugin_id' => 'myplugin_id',
            'option_id' => 'myplugin_id_options',
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
        new \myplugin_id\WPUBaseSettings(\$this->settings_details, \$this->settings);
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${settings_string}" "${_PLUGIN_FILE}";
