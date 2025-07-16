#!/bin/bash

###################################
## Bump version
###################################


function wpuplugincreator__bump_version(){
    local _plugin_id=$(basename "${_CURRENT_DIR}");
    local _plugin_file="${_plugin_id}.php";
    local _version _version_new _upgrade_type;

    if [ ! -f "${_plugin_file}" ]; then
        echo '- Main plugin file not found.';
        return;
    fi;

    _version=$(bashutilities_search_extract_file "Version:" "" "${_plugin_file}");
    if [ -z "${_version}" ]; then
        echo '- Version not found in main plugin file.';
        return;
    fi;

    echo "- Current version: ${_version}";
    echo "Do you want to update the version to a major, minor, or patch ?"
    _upgrade_type=$(bashutilities_get_user_var "- What is the upgrade type ?" "minor")
    if [[ "${_upgrade_type}" != "major" && "${_upgrade_type}" != "minor" && "${_upgrade_type}" != "patch" ]]; then
        echo "Invalid upgrade type"
        return 0
    fi
    _version_new=$(bashutilities_version_bump "${_version}" "${_upgrade_type}")
    bashutilities_sed "s/${_version}/${_version_new}/g" "${_plugin_file}";
    echo "- New version: ${_version_new}";

}

wpuplugincreator__bump_version;
