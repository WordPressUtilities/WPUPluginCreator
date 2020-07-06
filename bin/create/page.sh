#!/bin/bash

###################################
## Custom page
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseAdminPage/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseAdminPage.php";

echo '# Create Custom page file';
_INC_DIR="${_PLUGIN_DIR}inc/";
if [[ ! -d "${_INC_DIR}" ]];then
    mkdir "${_INC_DIR}";
fi;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseAdminPage/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

###################################
## PAGE
###################################

page_string=$(cat <<EOF
        # CUSTOM PAGE
        \$admin_pages = array(
            'main' => array(
                'menu_name' => 'Base plugin',
                'name' => 'Main page',
                'settings_link' => true,
                'settings_name' => 'Settings',
                'function_content' => array(&\$this,
                    'page_content__main'
                ),
                'function_action' => array(&\$this,
                    'page_action__main'
                )
            )
        );
        \$pages_options = array(
            'id' => \$this->plugin_settings['id'],
            'level' => 'manage_options',
            'basename' => plugin_basename(__FILE__)
        );
        // Init admin page
        include dirname( __FILE__ ) . '/inc/WPUBaseAdminPage/WPUBaseAdminPage.php';
        \$this->adminpages = new \myplugin_id\WPUBaseAdminPage();
        \$this->adminpages->init(\$pages_options, \$admin_pages);
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${page_string}" "${_PLUGIN_FILE}";

###################################
## Methods
###################################

page_string=$(cat <<EOF

    public function page_content__main() {

    }

    public function page_action__main() {

    }
EOF
);


bashutilities_add_after_marker '##METHODS##' "${page_string}" "${_PLUGIN_FILE}";
