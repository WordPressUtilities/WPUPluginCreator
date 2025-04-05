#!/bin/bash

###################################
## Translation
###################################

wpuplugincreator__translation_dir="${_PLUGIN_DIR}lang/";
wpuplugincreator__translation_file="${wpuplugincreator__translation_dir}${plugin_id}-${translation_lang}.po";

echo '# Create Translation file';
bashutilities_bury_copy "${_TOOLSDIR}translation.po" "${wpuplugincreator__translation_file}";
wpuplugincreator_protect_dir "${wpuplugincreator__translation_dir}",
wpuplugincreator_set_values "${wpuplugincreator__translation_file}";

echo '# Load Translation file';
wpuplugincreator__translation_string="";
wpuplugincreator__translation_string=$(cat <<EOF
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
bashutilities_add_before_marker '        ##PLUGINS_LOADED##' "${wpuplugincreator__translation_string}" "${_PLUGIN_FILE}";
bashutilities_add_after_marker '##VARS##' "private \$plugin_description;" "${_PLUGIN_FILE}";
