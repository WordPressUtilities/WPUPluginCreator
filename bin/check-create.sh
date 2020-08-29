#!/bin/bash

###################################
## Test dir
###################################

_CURRENT_DIR_NAME="${PWD##*/}"
if [[ "${_CURRENT_DIR_NAME}" != 'plugins' ]];then
    echo $(bashutilities_message "Be careful, this doesnt look like a WordPress plugin folder" 'warning');
fi;
