#!/bin/bash

###################################
## Email
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseEmail/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseEmail.php";

echo '# Add emails';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseEmail/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

email_string=$(cat <<EOF
        # EMAIL
        require_once __DIR__ . '/inc/WPUBaseEmail/WPUBaseEmail.php';
        \$this->baseemail = new \myplugin_id\WPUBaseEmail();
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${email_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$baseemail;" "${_PLUGIN_FILE}";
