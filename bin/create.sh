#!/bin/bash

echo '## Create';

_PLUGIN_DIR="${_CURRENT_DIR}/${plugin_id}/";
_PLUGIN_FILE="${_PLUGIN_DIR}${plugin_id}.php";

if [[ -f "${_PLUGIN_DIR}" || -f "${_PLUGIN_FILE}" ]];then
    echo $(bashutilities_message "The plugin “${plugin_id}” already exists !" 'error');
    return 0;
fi;

. "${_SOURCEDIR}bin/create/file.sh";
if [[ "${has_translation}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/translation.sh";
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

###################################
## Set values
###################################

wpuplugincreator_set_values "${_PLUGIN_FILE}";

###################################
## Clean up
###################################

wpuplugincreator_remove_markers;

echo "## Done !";
