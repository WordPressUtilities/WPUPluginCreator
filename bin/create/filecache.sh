#!/bin/bash

###################################
## File Cache
###################################

_CLASS_DIR="${_PLUGIN_DIR}inc/WPUBaseFileCache/";
_CLASS_FILE="${_CLASS_DIR}WPUBaseFileCache.php";

echo '# Add filecache';
wpuplugincreator_create_inc;

cp -R "${_TOOLSDIR}wpubaseplugin/inc/WPUBaseFileCache/" "${_CLASS_DIR}";

wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${plugin_id}";

filecache_string=$(cat <<EOF
        # File Cache
        require_once dirname(__FILE__) . '/inc/WPUBaseFileCache/WPUBaseFileCache.php';
        \$this->basefilecache = new \myplugin_id\WPUBaseFileCache();
EOF
);

bashutilities_add_after_marker '##PLUGINS_LOADED##' "${filecache_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$basefilecache;" "${_PLUGIN_FILE}";
