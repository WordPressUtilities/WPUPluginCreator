#!/bin/bash

function wpuplugincreator_update_dependency(){
    _CLASS_FILE="${1}";

    if [[ ! -f "${_CLASS_FILE}" ]];then
        return 0;
    fi;

    _CLASS_DIR=$(dirname "${_CLASS_FILE}");
    _CLASS_NAME=$(basename "${_CLASS_DIR}");

    # Extract namespace
    _namespace=$(bashutilities_search_extract_file "namespace " ";" "${_CLASS_FILE}" );

    # Replace file by latest
    rm -rf "${_CLASS_DIR}";
    cp -R "${_TOOLSDIR}wpubaseplugin/inc/${_CLASS_NAME}/" "${_CLASS_DIR}";

    # Fix namespace
    wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${_namespace}";
}

_DEPENDENCY_LIST=("WPUBaseAdminDatas" "WPUBaseAdminPage" "WPUBaseCron" "WPUBaseMessages" "WPUBaseSettings" "WPUBaseUpdate");
for i in "${_DEPENDENCY_LIST[@]}"; do
    echo "- Updating “${i}” if installed.";
    wpuplugincreator_update_dependency "inc/${i}.php";
    wpuplugincreator_update_dependency "inc/${i}/${i}.php";
done;
