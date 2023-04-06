#!/bin/bash

###################################
## API
###################################

## Methods
###################################

methods_string=$(cat <<EOF

    public function api_callback(\$url) {

        \$args = array(
            'headers' => array(),
        );

        /* Call */
        \$response = wp_remote_get(\$url, \$args);

        /* Checks */
        if(!\$response){
            return false;
        }
        \$body = wp_remote_retrieve_body(\$response);
        if(!\$body){
            return false;
        }

        return \$body;
    }

EOF
);


bashutilities_add_before_marker '    ##METHODS##' "${methods_string}" "${_PLUGIN_FILE}";
