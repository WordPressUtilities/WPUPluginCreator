#!/bin/bash

###################################
## Crontab
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseCron/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseCron.php";

echo '# Create Crontab files';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseCron/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

loading_string=$(cat <<EOF
        /* Include hooks */
        include dirname( __FILE__ ) . '/inc/WPUBaseCron/WPUBaseCron.php';
        \$this->basecron = new \myplugin_id\WPUBaseCron(array(
            'pluginname' => \$this->plugin_settings['name'],
            'cronhook' => 'myplugin_id__cron_hook',
            'croninterval' => 3600
        ));
        /* Callback when hook is triggered by the cron */
        add_action('myplugin_id__cron_hook', array(&\$this,
            'myplugin_id__cron_hook'
        ), 10);
EOF
);

bashutilities_add_after_marker '##PLUGINS_END_LOADED##' "${loading_string}" "${_PLUGIN_FILE}";

###################################
## Methods
###################################

methods_string=$(cat <<EOF

    public function myplugin_id__cron_hook() {

    }

EOF
);


bashutilities_add_after_marker '##METHODS##' "${methods_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$basecron;" "${_PLUGIN_FILE}";
