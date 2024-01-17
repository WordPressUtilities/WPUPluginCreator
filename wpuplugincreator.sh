#!/bin/bash

WPUPluginCreator(){

local _WPUPLUGINCREATOR_VERSION='0.26.1';
local _SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
local _TOOLSDIR="${_SOURCEDIR}sources/";
local _CURRENT_DIR="$( pwd )/";
local _DEPENDENCY_LIST=("WPUBaseAdminDatas" "WPUBaseAdminPage" "WPUBaseCron" "WPUBaseMessages" "WPUBaseSettings" "WPUBaseUpdate" "WPUBaseFields" "WPUBaseEmail" "WPUBaseToolbox" "WPUBaseFileCache");

###################################
## Test submodules
###################################

if [[ ! -f "${_TOOLSDIR}BashUtilities/README.md" || ! -f "${_TOOLSDIR}wpubaseplugin/README.md" ]]; then
    cd "${_SOURCEDIR}";
    git submodule update --init --recursive;
    cd "${_CURRENT_DIR}";
fi;

###################################
## Tools
###################################

. "${_TOOLSDIR}BashUtilities/modules/files.sh";
. "${_TOOLSDIR}BashUtilities/modules/messages.sh";
. "${_TOOLSDIR}BashUtilities/modules/texttransform.sh";
. "${_TOOLSDIR}BashUtilities/modules/values.sh";
. "${_TOOLSDIR}BashUtilities/modules/git.sh";

###################################
## Functions
###################################

. "${_SOURCEDIR}bin/create/functions.sh";

###################################
## Start tool
###################################

case "${1}" in
    'add')
        . "${_SOURCEDIR}bin/add.sh";
    ;;
    'update')
        . "${_SOURCEDIR}bin/update.sh";
    ;;
    'create')
        . "${_SOURCEDIR}bin/check-create.sh";
        . "${_SOURCEDIR}bin/questions.sh";
        . "${_SOURCEDIR}bin/create.sh";
    ;;
    'src' )
        cd "${_SOURCEDIR}";
    ;;
    'help' | *)
        . "${_SOURCEDIR}bin/help.sh";
    ;;
esac

. "${_SOURCEDIR}bin/stop.sh";
. "${_TOOLSDIR}BashUtilities/modules/stop.sh";

}
WPUPluginCreator "$@";
