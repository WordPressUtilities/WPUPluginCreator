#!/bin/bash

###################################
## Custom Table
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseAdminDatas/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseAdminDatas.php";

echo '# Create Custom Table file';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseAdminDatas/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

table_string=$(cat <<EOF
        # CUSTOM TABLE
        require_once __DIR__ . '/inc/WPUBaseAdminDatas/WPUBaseAdminDatas.php';
        \$this->baseadmindatas = new \myplugin_id\WPUBaseAdminDatas();
        \$this->baseadmindatas->init(array(
            'handle_database' => false,
            'plugin_id' => \$this->plugin_settings['id'],
            'table_name' => 'myplugin_id',
            'table_fields' => array(
                'value' => array(
                    'public_name' => 'Value',
                    'type' => 'sql',
                    'sql' => 'varchar(100) DEFAULT NULL'
                )
            )
        ));
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${table_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$baseadmindatas;" "${_PLUGIN_FILE}";
