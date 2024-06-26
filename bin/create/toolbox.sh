#!/bin/bash

###################################
## Toolbox
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseToolbox/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseToolbox.php";

echo '# Add toolbox';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseToolbox/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

toolbox_string=$(cat <<EOF
        # TOOLBOX
        require_once __DIR__ . '/inc/WPUBaseToolbox/WPUBaseToolbox.php';
        \$this->basetoolbox = new \myplugin_id\WPUBaseToolbox(array(
            'need_form_js' => false
        ));
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${toolbox_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$basetoolbox;" "${_PLUGIN_FILE}";
