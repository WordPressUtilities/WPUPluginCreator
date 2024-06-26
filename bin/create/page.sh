#!/bin/bash

###################################
## Custom page
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseAdminPage/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseAdminPage.php";

echo '# Create Custom page file';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseAdminPage/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

###################################
## PAGE
###################################

page_string=$(cat <<EOF
        # CUSTOM PAGE
        \$admin_pages = array(
            'main' => array(
                'icon_url' => 'dashicons-admin-generic',
                'menu_name' => \$this->plugin_settings['name'],
                'name' => 'Main page',
                'settings_link' => true,
                'settings_name' => __('Settings', 'myplugin_id'),
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
        require_once __DIR__ . '/inc/WPUBaseAdminPage/WPUBaseAdminPage.php';
        \$this->adminpages = new \myplugin_id\WPUBaseAdminPage();
        \$this->adminpages->init(\$pages_options, \$admin_pages);
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${page_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$adminpages;" "${_PLUGIN_FILE}";

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
