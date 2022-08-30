#!/bin/bash

function wpuplugincreator_add_dependency(){
    local _CLASS_FILE="${i}/${i}.php";
    if [[ -f "inc/${_CLASS_FILE}" ]];then
        echo $(bashutilities_message "- “${i}” is already installed !" 'error');
        return 0;
    fi;

    local _CLASS_NAME="${i}";
    local _CLASS_DIR=$(dirname "${_CLASS_FILE}");
    local _CLASS_SRC_DIR="${_TOOLSDIR}wpubaseplugin/inc/${_CLASS_NAME}/";

    # If inc/ directory exists : use it
    if [[ -d "inc" ]];then
        _CLASS_DIR="inc/${_CLASS_DIR}";
        _CLASS_FILE="inc/${_CLASS_FILE}";
    fi;

    # Add file
    cp -R "${_CLASS_SRC_DIR}" "${_CLASS_DIR}";

    # Add namespace
    local _namespace=$(basename "${_CURRENT_DIR}");
    if [[ "${_namespace}" == 'plugin' ]];then
        echo $(bashutilities_message "- You are not in a plugin directory !" 'error');
        return 0;
    fi;
    wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${_namespace}"

    echo $(bashutilities_message "- “${i}” has been installed !" 'success');
}

for i in "${_DEPENDENCY_LIST[@]}"; do
    _add_this_module=$(bashutilities_get_yn "- Install "${i}"?" 'n');
    if [[ "${_add_this_module}" == 'y' ]];then
        wpuplugincreator_add_dependency "${i}";
    fi;
done;
