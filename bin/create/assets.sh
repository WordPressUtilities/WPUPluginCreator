#!/bin/bash

###################################
## Assets
###################################

echo '# Creating assets';
_ASSETS_DIR="${_PLUGIN_DIR}assets/";
mkdir "${_ASSETS_DIR}";

## Back
###################################

if [[ "${has_assets_back_js}" == 'y' || "${has_assets_back_css}" == 'y' ]];then
    assets_register=$(cat <<EOF
        # Back Assets
        add_action('admin_enqueue_scripts', array(&\$this, 'admin_enqueue_scripts'));
EOF
);

    bashutilities_add_before_marker '        ##CONSTRUCT##' "${assets_register}" "${_PLUGIN_FILE}";

    # Register JS
    assets_register_js="";
    if [[ "${has_assets_back_js}" == 'y' ]];then
        cp "${_TOOLSDIR}assets/back.js" "${_ASSETS_DIR}back.js";
        assets_register_js=$(cat <<EOF
        /* Back Script */
        wp_register_script('myplugin_id_back_script', plugins_url('assets/back.js', __FILE__), array(), \$this->plugin_version, true);
        wp_enqueue_script('myplugin_id_back_script');
EOF
);
    fi;

    # Register CSS
    assets_register_css="";
    if [[ "${has_assets_back_css}" == 'y' ]];then
        cp "${_TOOLSDIR}assets/back.css" "${_ASSETS_DIR}back.css";
        assets_register_css=$(cat <<EOF
        /* Back Style */
        wp_register_style('myplugin_id_back_style', plugins_url('assets/back.css', __FILE__), array(), \$this->plugin_version);
        wp_enqueue_style('myplugin_id_back_style');
EOF
);
    fi;

    # Create method
    assets_register_method=$(cat <<EOF

    public function admin_enqueue_scripts() {
${assets_register_css}
${assets_register_js}
    }
EOF
);
    bashutilities_add_before_marker '    ##METHODS##' "${assets_register_method}" "${_PLUGIN_FILE}";

fi;

## Front
###################################

if [[ "${has_assets_front_js}" == 'y' || "${has_assets_front_css}" == 'y' ]];then

    # Register hook
assets_register=$(cat <<EOF
        # Front Assets
        add_action('wp_enqueue_scripts', array(&\$this, 'wp_enqueue_scripts'));
EOF
);
bashutilities_add_before_marker '        ##CONSTRUCT##' "${assets_register}" "${_PLUGIN_FILE}";

    # Register JS
    assets_register_js="";
    if [[ "${has_assets_front_js}" == 'y' ]];then
        cp "${_TOOLSDIR}assets/front.js" "${_ASSETS_DIR}front.js";
        assets_register_js=$(cat <<EOF
        /* Front Script with localization / variables */
        wp_register_script('myplugin_id_front_script', plugins_url('assets/front.js', __FILE__), array(), \$this->plugin_version, true);
        wp_localize_script('myplugin_id_front_script', 'myplugin_id_settings', array(
            'my_key' => 'my_value'
        ));
        wp_enqueue_script('myplugin_id_front_script');
EOF
);
    fi;

    # Register CSS
    assets_register_css="";
    if [[ "${has_assets_front_css}" == 'y' ]];then
        cp "${_TOOLSDIR}assets/front.css" "${_ASSETS_DIR}front.css";
        assets_register_css=$(cat <<EOF
        /* Front Style */
        wp_register_style('myplugin_id_front_style', plugins_url('assets/front.css', __FILE__), array(), \$this->plugin_version);
        wp_enqueue_style('myplugin_id_front_style');
EOF
);
    fi;

    # Create method
    assets_register_method=$(cat <<EOF

    public function wp_enqueue_scripts() {
${assets_register_css}
${assets_register_js}
    }
EOF
);
    bashutilities_add_before_marker '    ##METHODS##' "${assets_register_method}" "${_PLUGIN_FILE}";

fi;
