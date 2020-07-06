#!/bin/bash

###################################
## Settings
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseMessages/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseMessages.php";

echo '# Create Messages file';
_INC_DIR="${_PLUGIN_DIR}inc/";
if [[ ! -d "${_INC_DIR}" ]];then
    mkdir "${_INC_DIR}";
fi;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseMessages/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

messages_string=$(cat <<EOF
        # MESSAGES
        if (is_admin()) {
            include dirname( __FILE__ ) . '/inc/WPUBaseMessages/WPUBaseMessages.php';
            \$this->messages = new \myplugin_id\WPUBaseMessages(\$this->plugin_settings['plugin_id']);
        }
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${messages_string}" "${_PLUGIN_FILE}";
