#!/bin/bash

echo '## Questions';

###################################
## Author name
###################################

author_name=$(bashutilities_get_user_var "- What is the author Name ?" "$(whoami)");
author_id=$(echo "${author_name}" | tr '[:upper:]' '[:lower:]');

###################################
## Name
###################################

plugin_name=$(bashutilities_get_user_var "- What is the plugin Name ?" "My Plugin ID");

###################################
## ID
###################################

default_plugin_id=$(bashutilities_string_to_slug "${plugin_name// /_}");
default_plugin_id="${default_plugin_id//_/}";
plugin_id=$(bashutilities_get_user_var "- What is the plugin ID ?" "${default_plugin_id}");

###################################
## Class name
###################################

default_plugin_classname=$(bashutilities_titlecase "${plugin_name// /}");
default_plugin_classname="${default_plugin_classname//-/}";
default_plugin_classname="${default_plugin_classname//[^[:alnum:]]/}";
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
## Post type
###################################

post_type_id="";
has_post_type=$(bashutilities_get_yn "- Do you need a custom post type ?" 'y');
if [[ "${has_post_type}" == 'y' ]];then
    post_type_id=$(bashutilities_get_user_var "-- What is the post type slug ?" "${plugin_id}");
fi;

###################################
## Repository
###################################

need_repository='n';
if [ ! -f ".git/config" ];then
    need_repository=$(bashutilities_get_yn "- Do you need a git repository ?" 'y');
fi;

###################################
## Github actions
###################################

has_github_actions='n';
if [ -f ".git/config" ] && git remote -v | grep -q 'github.com']; then
    has_github_actions=$(bashutilities_get_yn "- Do you need github actions ?" 'y');
fi;

###################################
## Fields
###################################

has_fields=$(bashutilities_get_yn "- Do you need custom fields ?" 'y');

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
## Crontab
###################################

has_crontab=$(bashutilities_get_yn "- Do you need a crontab ?" 'y');

###################################
## Uninstall
###################################

has_uninstall=$(bashutilities_get_yn "- Do you need an uninstall file ?" 'y');

###################################
## Email
###################################

has_email=$(bashutilities_get_yn "- Do you need to send emails ?" 'y');

###################################
## Toolbox
###################################

has_toolbox=$(bashutilities_get_yn "- Do you need some functions from the toolbox ?" 'y');

###################################
## File cache
###################################

has_filecache=$(bashutilities_get_yn "- Do you need to use file cache ?" 'y');

###################################
## Assets
###################################

has_ajax=$(bashutilities_get_yn "- Do you need an AJAX callback ?" 'n');
if [[ "${has_ajax}" == 'y' ]];then
    has_assets='y';
else
    has_assets=$(bashutilities_get_yn "- Do you need CSS / JS assets ?" 'y');
fi;
if [[ "${has_assets}" == 'y' ]];then
    if [[ "${has_ajax}" == 'y' ]];then
        has_assets_front_js='y';
    else
        has_assets_front_js=$(bashutilities_get_yn "-- JS in Front-Office ?" "y");
    fi;
    has_assets_back_js=$(bashutilities_get_yn "-- JS in Back-Office ?" "y");
    has_assets_front_css=$(bashutilities_get_yn "-- CSS in Front-Office ?" "y");
    has_assets_back_css=$(bashutilities_get_yn "-- CSS in Back-Office ?" "y");
fi;

###################################
## API
###################################

has_api=$(bashutilities_get_yn "- Do you need to call an external API ?" 'n');
if [[ "${has_api}" == 'y' ]];then
    has_api_xml=$(bashutilities_get_yn "- Do you need to parse XML ?" 'n');
fi;

###################################
## WP-Cli
###################################

has_wpcli=$(bashutilities_get_yn "- Do you need a WP-Cli command ?" 'n');
