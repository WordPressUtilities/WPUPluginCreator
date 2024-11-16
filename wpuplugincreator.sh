#!/bin/bash

WPUPluginCreator(){

local _WPUPLUGINCREATOR_VERSION='0.44.5';
local _SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
local _TOOLSDIR="${_SOURCEDIR}sources/";
local _CURRENT_DIR="$( pwd )/";
local _DEPENDENCY_LIST=("WPUBaseAdminDatas" "WPUBaseAdminPage" "WPUBaseCron" "WPUBaseMessages" "WPUBaseSettings" "WPUBaseUpdate" "WPUBaseFields" "WPUBaseEmail" "WPUBaseToolbox" "WPUBaseFileCache");

###################################
## Initial
###################################

. "${_SOURCEDIR}bin/create/functions.sh";

###################################
## Test submodules
###################################

if [[ ! -f "${_TOOLSDIR}BashUtilities/README.md" || ! -f "${_TOOLSDIR}wpubaseplugin/README.md" ]]; then
    cd "${_SOURCEDIR}";
    git submodule update --init --recursive;
    cd "${_CURRENT_DIR}";
fi;

###################################
## Install WP-Cli
###################################

local _WPCLISRC="${_SOURCEDIR}wp-cli.phar";
if [ ! -f "${_WPCLISRC}" ]; then
    wpuplugincreator_install_wpcli;
fi;

function wpuplugincreator_wpcli_command(){
    php "${_WPCLISRC}" $@;
}

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

. "${_SOURCEDIR}bin/autocomplete.sh";

###################################
## Start tool
###################################

case "${1}" in
    'upgrade-wpubaseplugin' )
        . "${_SOURCEDIR}bin/${1}.sh";
    ;;
    'add' | 'plugin-check' | 'regenerate-lang' | 'self-update' )
        . "${_SOURCEDIR}bin/find-folder.sh";
        . "${_SOURCEDIR}bin/${1}.sh";
    ;;
    'update')
        . "${_SOURCEDIR}bin/find-folder.sh";
        . "${_SOURCEDIR}bin/update.sh";
        . "${_SOURCEDIR}bin/regenerate-lang.sh";
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
