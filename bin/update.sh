#!/bin/bash

###################################
## Dependencies
###################################

function wpuplugincreator_update_dependency(){
    local _CLASS_FILE="${i}/${i}.php";
    if [[ -f "inc/${_CLASS_FILE}" ]];then
        _CLASS_FILE="inc/${_CLASS_FILE}";
    fi;
    if [[ ! -f "${_CLASS_FILE}" ]];then
        if [[ -f "inc/${i}.php" ]];then
            echo $(bashutilities_message "- “${i}” is installed but invalid !" 'error');
            return 0;
        fi;
        echo $(bashutilities_message "- “${i}” is not installed." 'warning' 'nowarn');
        return 0;
    fi;

    local _CLASS_NAME="${i}";
    local _CLASS_DIR=$(dirname "${_CLASS_FILE}");
    local _CLASS_SRC_DIR="${_TOOLSDIR}wpubaseplugin/inc/${_CLASS_NAME}/";
    local _CLASS_SRC_FILE="${_CLASS_SRC_DIR}${_CLASS_NAME}.php";

    local _v_src=$(bashutilities_search_extract_file "Version: " "" "${_CLASS_SRC_FILE}" );
    local _v_proj=$(bashutilities_search_extract_file "Version: " "" "${_CLASS_FILE}" );
    if [[ "${_v_src}" == "${_v_proj}" ]];then
        echo $(bashutilities_message  "- “${i}” is already up-to-date." 'success' 'nowarn');
        return 0;
    fi;

    # Extract namespace
    local _namespace=$(bashutilities_search_extract_file "namespace " ";" "${_CLASS_FILE}" );

    # Replace file by latest
    rm -rf "${_CLASS_DIR}";
    cp -R "${_CLASS_SRC_DIR}" "${_CLASS_DIR}";

    # Fix namespace
    wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${_namespace}"

    echo $(bashutilities_message "- “${i}” has been updated !" 'success');
}

for i in "${_DEPENDENCY_LIST[@]}"; do
    echo $(bashutilities_message  "# Updating “${i}” if installed." 'notice' 'nowarn');
    wpuplugincreator_update_dependency "${i}";
done;

###################################
## Protection
###################################

function wpuplugincreator_update_protect(){
    local _has_protection="1";
    local _dir;
    for _dir in {"src","inc","lang","vendor"}; do
        local _protection_file="${_dir}/.htaccess";
        local _protection_index="${_dir}/index.php";
        if [[ -d "${_dir}" ]];then
            if [[ ! -f "${_protection_file}" ]];then
                _has_protection="0";
                echo "- Protecting dir ${_dir}";
                echo 'deny from all' > "${_protection_file}";
            fi;
            if [[ ! -f "${_protection_index}" ]];then
                _has_protection="0";
                echo "- Protecting index dir ${_dir}";
                echo '<?php /* Silence */' > "${_protection_index}";
            fi;
        fi;
    done;
    if [[ "${_has_protection}" == '1' ]];then
        echo "- All directories where already protected."
    fi;
}

wpuplugincreator_update_protect;
