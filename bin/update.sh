#!/bin/bash

function wpuplugincreator_update_dependency(){
    _CLASS_FILE="inc/${i}/${i}.php";
    if [[ ! -f "${_CLASS_FILE}" ]];then
        if [[ -f "inc/${i}.php" ]];then
            echo $(bashutilities_message "- “${i}” is installed but invalid !" 'error');
            return 0;
        fi;
        echo $(bashutilities_message "- “${i}” is not installed." 'warning' 'nowarn');
        return 0;
    fi;

    _CLASS_NAME="${i}";
    _CLASS_DIR=$(dirname "${_CLASS_FILE}");
    _CLASS_SRC_DIR="${_TOOLSDIR}wpubaseplugin/inc/${_CLASS_NAME}/";
    _CLASS_SRC_FILE="${_CLASS_SRC_DIR}${_CLASS_NAME}.php";

    _v_src=$(bashutilities_search_extract_file "Version: " "" "${_CLASS_SRC_FILE}" );
    _v_proj=$(bashutilities_search_extract_file "Version: " "" "${_CLASS_FILE}" );
    if [[ "${_v_src}" == "${_v_proj}" ]];then
        echo $(bashutilities_message  "- “${i}” is already up-to-date." 'success' 'nowarn');
        return 0;
    fi;

    # Extract namespace
    _namespace=$(bashutilities_search_extract_file "namespace " ";" "${_CLASS_FILE}" );

    # Replace file by latest
    rm -rf "${_CLASS_DIR}";
    cp -R "${_CLASS_SRC_DIR}" "${_CLASS_DIR}";

    # Fix namespace
    wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${_namespace}"

    echo $(bashutilities_message "- “${i}” has been updated !" 'success');
}

_DEPENDENCY_LIST=("WPUBaseAdminDatas" "WPUBaseAdminPage" "WPUBaseCron" "WPUBaseMessages" "WPUBaseSettings" "WPUBaseUpdate");
for i in "${_DEPENDENCY_LIST[@]}"; do
    echo $(bashutilities_message  "# Updating “${i}” if installed." 'notice' 'nowarn');
    wpuplugincreator_update_dependency "${i}";
done;
