#!/bin/bash

###################################
## Messages
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseMessages/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseMessages.php";

echo '# Create Messages file';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseMessages/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

messages_string=$(cat <<EOF
        # MESSAGES
        if (is_admin()) {
            include dirname( __FILE__ ) . '/inc/WPUBaseMessages/WPUBaseMessages.php';
            \$this->messages = new \myplugin_id\WPUBaseMessages(\$this->plugin_settings['id']);
        }
EOF
);

bashutilities_add_after_marker '##PLUGINS_END_LOADED##' "${messages_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$messages = false;" "${_PLUGIN_FILE}";

###################################
## Methods
###################################

page_string=$(cat <<EOF
    /* Add a message */
    public function set_message(\$id, \$message, \$group = '') {
        if(!\$this->messages){
            error_log(\$id . ' - ' . \$message);
            return;
        }
        \$this->messages->set_message(\$id, \$message, \$group);
    }
EOF
);


bashutilities_add_after_marker '##METHODS##' "${page_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$messages;" "${_PLUGIN_FILE}";
