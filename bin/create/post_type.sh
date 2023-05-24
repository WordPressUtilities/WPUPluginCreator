#!/bin/bash

###################################
## Post type
###################################

pt_register=$(cat <<EOF
        add_action('init', array(&\$this, 'register_post_type'));
EOF
);
bashutilities_add_before_marker '        ##CONSTRUCT##' "${pt_register}" "${_PLUGIN_FILE}";

###################################
## Methods
###################################

methods_string=$(cat <<EOF

    public function register_post_type() {
        # POST TYPE
        register_post_type('${post_type_id}', array(
            'public' => true,
            'label' => __('${post_type_id}', 'myplugin_id'),
            'menu_icon' => 'dashicons-book'
        ));
    }

EOF
);


bashutilities_add_before_marker '    ##METHODS##' "${methods_string}" "${_PLUGIN_FILE}";
