#!/bin/bash

###################################
## Fields
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseFields/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseFields.php";

echo '# Create Fields file';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseFields/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

fields_string=$(cat <<EOF
        # FIELDS
        \$fields = array(
            'demo' => array(
                'group' => 'group_1',
                'label' => 'Demo',
                'placeholder' => 'My Placeholder',
                'required' => true
            ),
            'select' => array(
                'type' => 'select',
                'group' => 'group_2',
                'label' => 'Select with Data',
                'data' => array(
                    'value_1' => 'Value 1',
                    'value_2' => 'Value 2',
                )
            ),
            'select_nodata' => array(
                'type' => 'select',
                'group' => 'group_2',
                'label' => 'Select without Data'
            )
        );
        \$field_groups = array(
            'group_1'  => array(
                'label' => 'Group 1',
                'post_type' => array('page')
            ),
            'group_2'  => array(
                'label' => 'Group 2'
            )
        );
        require_once dirname(__FILE__) . '/inc/WPUBaseFields/WPUBaseFields.php';
        \$this->basefields = new \myplugin_id\WPUBaseFields(\$fields, \$field_groups);
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${fields_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$basefields;" "${_PLUGIN_FILE}";
