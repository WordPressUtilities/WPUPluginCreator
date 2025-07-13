#!/bin/bash

###################################
## New lang
###################################

plugin_id=$(basename "${_CURRENT_DIR}");
wpuplugincreator__translation_dir="${_PLUGIN_DIR}lang/";
if [ ! -d "${wpuplugincreator__translation_dir}" ]; then
    echo '- Translation directory not found.';
    return;
fi;

if [[ ! -z "${2}" ]]; then
    translation_lang="${2}";
else
    translation_lang=$(bashutilities_get_user_var "- What lang do you need ?" "fr_FR");
fi;

if [ -z "${translation_lang}" ]; then
    echo '- No lang provided.';
    return;
fi;


wpuplugincreator__translation_file="${wpuplugincreator__translation_dir}${plugin_id}-${translation_lang}.po";
if [ -f "${wpuplugincreator__translation_file}" ]; then
    echo '- Translation file already exists.';
    return;
fi;

bashutilities_bury_copy "${_TOOLSDIR}translation.po" "${wpuplugincreator__translation_file}";
wpuplugincreator_set_values "${wpuplugincreator__translation_file}";

echo "- Translation file for ${translation_lang} was created.";
