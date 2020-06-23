#!/bin/bash

function wpuplugincreator_set_values(){
    file_content=$(cat "${1}");
    file_content=${file_content//myplugin_classname/${plugin_classname}};
    file_content=${file_content//myplugin_name/${plugin_name}};
    file_content=${file_content//myplugin_id/${plugin_id}};
    file_content=${file_content//myplugin_lang/${translation_lang}};
    echo "${file_content}" > "${1}";
}

function wpuplugincreator_remove_markers(){
    _indent1=$'\n'"    ";
    _indent2=$'\n'"        ";
    file_content=$(cat "${_PLUGIN_FILE}");
    file_content=${file_content//${_indent2}"##CONSTRUCT##"/""};
    file_content=${file_content//${_indent2}"##PLUGINS_LOADED##"/""};
    file_content=${file_content//${_indent1}"##METHODS##"/""};
    echo "${file_content}" > "${_PLUGIN_FILE}";
}
