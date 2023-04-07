#!/bin/bash

###################################
## API XML
###################################

## Methods
###################################

methods_string=$(cat <<EOF

    public function xml_to_array(\$string) {
        \$xml = simplexml_load_string(\$string);
        \$json = json_encode(\$xml);
        return json_decode(\$json, true);
    }

EOF
);


bashutilities_add_before_marker '    ##METHODS##' "${methods_string}" "${_PLUGIN_FILE}";
