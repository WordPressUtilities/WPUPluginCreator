#!/bin/bash

###################################
## Translation
###################################

_TRANSLATION_DIR="${_PLUGIN_DIR}lang/";
_TRANSLATION_FILE="${_TRANSLATION_DIR}${plugin_id}-${translation_lang}.po";

echo '# Create Translation file';
bashutilities_bury_copy "${_TOOLSDIR}translation.po" "${_TRANSLATION_FILE}";
wpuplugincreator_set_values "${_TRANSLATION_FILE}";

echo '# Load Translation file';
translation_string="load_plugin_textdomain('myplugin_id', false, dirname(plugin_basename(__FILE__)) . '/lang/');";
bashutilities_add_before_marker '##PLUGINS_LOADED##' "        ${translation_string}" "${_PLUGIN_FILE}";
