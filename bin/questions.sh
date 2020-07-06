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
plugin_id=$(bashutilities_get_user_var "- What is the plugin ID ?" "${default_plugin_id}");

###################################
## Class name
###################################

default_plugin_classname=$(bashutilities_titlecase "${plugin_name// /}");
plugin_classname=$(bashutilities_get_user_var "- What is the plugin ClassName ?" "${default_plugin_classname}");

###################################
## Translation
###################################

translation_lang='fr_FR';
has_translation=$(bashutilities_get_yn "- Do you need translation ?" 'y');
if [[ "${has_translation}" == 'y' ]];then
    translation_lang=$(bashutilities_get_user_var "-- What is the translation lang ?" "${translation_lang}");
fi;

###################################
## Settings
###################################

has_settings=$(bashutilities_get_yn "- Do you need a settings page?" 'y');

###################################
## Custom table
###################################

has_custom_table=$(bashutilities_get_yn "- Do you need a custom MySQL table ?" 'y');

###################################
## Admin page
###################################

has_admin_page=$(bashutilities_get_yn "- Do you need an admin page ?" 'y');

###################################
## Messages
###################################

has_messages=$(bashutilities_get_yn "- Do you need to handle notices & messages ?" 'y');

###################################
## Assets
###################################

has_assets=$(bashutilities_get_yn "- Do you need CSS / JS assets ?" 'y');
if [[ "${has_assets}" == 'y' ]];then
    has_assets_front_js=$(bashutilities_get_yn "-- JS in Front-Office ?" "y");
    has_assets_back_js=$(bashutilities_get_yn "-- JS in Back-Office ?" "y");
    has_assets_front_css=$(bashutilities_get_yn "-- CSS in Front-Office ?" "y");
    has_assets_back_css=$(bashutilities_get_yn "-- CSS in Back-Office ?" "y");
fi;
