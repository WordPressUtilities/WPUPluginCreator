#!/bin/bash

WPUPluginCreator(){

local _WPUPLUGINCREATOR_VERSION='0.6.1';
local _SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
local _TOOLSDIR="${_SOURCEDIR}sources/";
local _CURRENT_DIR="$( pwd )/";

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
## Test dir
###################################

_CURRENT_DIR_NAME="${PWD##*/}"
if [[ "${_CURRENT_DIR_NAME}" != 'plugins' ]];then
    echo $(bashutilities_message "Be careful, this doesnt look like a WordPress plugin folder" 'warning');
fi;

###################################
## Start tool
###################################

. "${_SOURCEDIR}bin/questions.sh";
. "${_SOURCEDIR}bin/create.sh";

}
WPUPluginCreator "$@";
