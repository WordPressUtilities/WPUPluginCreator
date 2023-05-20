#!/bin/bash

echo '## Create';

_ERROR_PLUGIN_EXISTS=$(bashutilities_message "The plugin “${plugin_id}” already exists !" 'error');

# Build dir
_PLUGIN_DIR="${_CURRENT_DIR}/${plugin_id}/";
if [[ "${PWD##*/}" == "${plugin_id}" ]];then
    _PLUGIN_DIR="${_CURRENT_DIR}/";
else
    if [[ -d "${_PLUGIN_DIR}" ]];then
        echo "${_ERROR_PLUGIN_EXISTS}";
        return 0;
    else
        mkdir "${_PLUGIN_DIR}";
    fi;
fi;

# Build file
_PLUGIN_FILE="${_PLUGIN_DIR}${plugin_id}.php";
if [[ -f "${_PLUGIN_FILE}" ]];then
    echo "${_ERROR_PLUGIN_EXISTS}";
    return 0;
fi;

. "${_SOURCEDIR}bin/create/file.sh";
if [[ "${has_translation}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/translation.sh";
fi;
if [[ "${has_github_actions}" == 'y' ]];then
    wpuplugincreator_create_github_actions;
fi;
if [[ "${has_post_type}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/post_type.sh";
fi;
if [[ "${has_settings}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/settings.sh";
fi;
if [[ "${has_custom_table}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/table.sh";
fi;
if [[ "${has_admin_page}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/page.sh";
fi;
if [[ "${has_messages}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/messages.sh";
fi;
if [[ "${has_crontab}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/crontab.sh";
fi;
if [[ "${has_wpcli}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/wpcli.sh";
fi;
if [[ "${has_assets}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/assets.sh";
fi;
if [[ "${has_api}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/api.sh";
    if [[ "${has_api_xml}" == 'y' ]];then
        . "${_SOURCEDIR}bin/create/api_xml.sh";
    fi;
fi;

###################################
## Set values
###################################

wpuplugincreator_set_values "${_PLUGIN_FILE}";

###################################
## Clean up
###################################

wpuplugincreator_remove_markers;

echo "## Done !";
