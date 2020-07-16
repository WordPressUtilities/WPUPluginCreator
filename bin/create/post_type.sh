#!/bin/bash

###################################
## Post type
###################################

echo '# Create Post Type';
post_type_string=$(cat <<EOF
        # POST TYPE
        register_post_type('${post_type_id}', array(
            'public' => true,
            'label' => __('${post_type_id}', 'plugin_id'),
            'menu_icon' => 'dashicons-book'
        ));
EOF
);

bashutilities_add_before_marker '        ##PLUGINS_LOADED##' "${post_type_string}" "${_PLUGIN_FILE}";

