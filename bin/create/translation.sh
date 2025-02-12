#!/bin/bash

###################################
## Translation
###################################

_TRANSLATION_DIR="${_PLUGIN_DIR}lang/";
_TRANSLATION_FILE="${_TRANSLATION_DIR}${plugin_id}-${translation_lang}.po";

echo '# Create Translation file';
bashutilities_bury_copy "${_TOOLSDIR}translation.po" "${_TRANSLATION_FILE}";
wpuplugincreator_protect_dir "${_TRANSLATION_DIR}",
wpuplugincreator_set_values "${_TRANSLATION_FILE}";

echo '# Load Translation file';
translation_string="";
translation_string=$(cat <<EOF
        # TRANSLATION
        \$lang_dir = dirname(plugin_basename(__FILE__)) . '/lang/';
        if (strpos(__DIR__, 'mu-plugins') !== false) {
            load_muplugin_textdomain('myplugin_id', \$lang_dir);
        } else {
            load_plugin_textdomain('myplugin_id', false, \$lang_dir);
        }
        \$this->plugin_description = __('myplugin_name is a wonderful plugin.', 'myplugin_id');
EOF
);
bashutilities_add_before_marker '        ##PLUGINS_LOADED##' "${translation_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$plugin_description;" "${_PLUGIN_FILE}";
