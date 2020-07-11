#!/bin/bash

function wpuplugincreator_set_values(){
    file_content=$(cat "${1}");
    file_content=${file_content//myplugin_classname/${plugin_classname}};
    file_content=${file_content//myplugin_name/${plugin_name}};
    file_content=${file_content//myplugin_id/${plugin_id}};
    file_content=${file_content//myplugin_lang/${translation_lang}};
    file_content=${file_content//author_name/${author_name}};
    echo "${file_content}" > "${1}";
}

function wpuplugincreator_remove_markers(){
    _indent1=$'\n'"    ";
    _indent2=$'\n'"        ";
    file_content=$(cat "${_PLUGIN_FILE}");
    file_content=${file_content//${_indent1}"##VARS##"/""};
    file_content=${file_content//${_indent2}"##CONSTRUCT##"/""};
    file_content=${file_content//${_indent2}"##PLUGINS_LOADED##"/""};
    file_content=${file_content//${_indent2}"##PLUGINS_END_LOADED##"/""};
    file_content=${file_content//${_indent1}"##METHODS##"/""};
    echo "${file_content}" > "${_PLUGIN_FILE}";
}

function wpuplugincreator_replace_namespace(){
    # Try 2nd line
    _CURRENT_NAMESPACE=$(sed '2q;d' < "${1}");
    # Try 3rd line
    if [[ "${_CURRENT_NAMESPACE}" == '' ]];then
        _CURRENT_NAMESPACE=$(sed '3q;d' < "${1}");
    fi;
    _CURRENT_NAMESPACE=${_CURRENT_NAMESPACE//namespace/};
    _CURRENT_NAMESPACE=${_CURRENT_NAMESPACE//;/};
    _CURRENT_NAMESPACE=${_CURRENT_NAMESPACE// /};
    bashutilities_sed "s/${_CURRENT_NAMESPACE}/${2}/g" "${1}";
}

function wpuplugincreator_create_inc(){
    _INC_DIR="${_PLUGIN_DIR}inc/";
    if [[ ! -d "${_INC_DIR}" ]];then
        mkdir "${_INC_DIR}";
        echo 'deny from all' > "${_INC_DIR}.htaccess";
    fi;
}
