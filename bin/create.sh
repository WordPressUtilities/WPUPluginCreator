#!/bin/bash

echo '## Create';

_PLUGIN_DIR="${_CURRENT_DIR}/${plugin_id}/";
_PLUGIN_FILE="${_PLUGIN_DIR}${plugin_id}.php";

. "${_SOURCEDIR}bin/create/functions.sh";
. "${_SOURCEDIR}bin/create/file.sh";
if [[ "${has_translation}" == 'y' ]];then
    . "${_SOURCEDIR}bin/create/translation.sh";
fi;

###################################
## Set values
###################################

wpuplugincreator_set_values "${_PLUGIN_FILE}";

###################################
## Clean up
###################################

wpuplugincreator_remove_markers;
