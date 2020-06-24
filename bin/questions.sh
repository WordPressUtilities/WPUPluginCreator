#!/bin/bash

echo '## Questions';

###################################
## Author name
###################################

author_name=$(bashutilities_get_user_var "- What is the author Name ?" "$(whoami)");

###################################
## Name
###################################

plugin_name=$(bashutilities_get_user_var "- What is the plugin Name ?" "My Plugin ID");

###################################
## ID
###################################

default_plugin_id=$(bashutilities_string_to_slug "${plugin_name// /_}");
plugin_id=$(bashutilities_get_user_var "- What is the plugin ID?" "${default_plugin_id}");

###################################
## Class name
###################################

default_plugin_classname=$(bashutilities_titlecase "${plugin_name// /}");
plugin_classname=$(bashutilities_get_user_var "- What is the plugin ClassName?" "${default_plugin_classname}");

###################################
## Translation
###################################

translation_lang='fr_FR';
has_translation=$(bashutilities_get_yn "- Do you need to translate this plugin ?" 'y');
if [[ "${has_translation}" == 'y' ]];then
    translation_lang=$(bashutilities_get_user_var "- What is the translation lang?" "${translation_lang}");
fi;

###################################
## Settings
###################################

has_settings=$(bashutilities_get_yn "- Do you need a settings page in this plugin ?" 'y');
