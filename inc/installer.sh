#!/bin/bash

_SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/../";
_SCRIPTDIR=$(cd "${_SOURCEDIR}";pwd);
_SCRIPTNAME="${_SCRIPTDIR}/wpuplugincreator.sh";

###################################
## Check if WPUPluginCreator is installed
###################################

_check=$(type wpuplugincreator);
if [[ $_check == *"wpuplugincreator.sh"* ]]; then
    echo "WPUPluginCreator is already installed!";
    return 0;
fi;

###################################
## Find best file to install
###################################

_FILEINSTALL="";

if [[ -f ~/.bash_aliases ]]; then
    _FILEINSTALL=~/.bash_aliases;
fi

if [[ "${_FILEINSTALL}" == '' && -f ~/.bash_profile ]]; then
    _FILEINSTALL=~/.bash_profile;
fi

if [[ "${_FILEINSTALL}" == '' && -f ~/.bashrc ]]; then
    _FILEINSTALL=~/.bashrc;
fi

if [[ "${_FILEINSTALL}" == '' ]];then
    echo "WPUPluginCreator could not be installed : no bash config file found."
    return 0;
fi;

###################################
## Install
###################################

echo "alias wpuplugincreator=\". ${_SCRIPTNAME}\"" >> "${_FILEINSTALL}";
echo "WPUPluginCreator is installed !";
