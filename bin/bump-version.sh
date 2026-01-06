#!/bin/bash

###################################
## Bump version
###################################


function wpuplugincreator__bump_version(){
    local _plugin_id=$(wpuplugincreator_get_plugin_id);
    local _plugin_file="${_plugin_id}.php";
    local _version _version_new _upgrade_type;
    local _upgrade_types=("major" "minor" "patch");

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

    _upgrade_type="";
    if [ "${2}" != "" ]; then
        for _type in "${_upgrade_types[@]}"; do
            if [ "${2}" = "${_type}" ]; then
                echo "Upgrade type found in arguments: ${2}";
                _upgrade_type="${2}"
            break
            fi
        done
    fi;

    if [ "${_upgrade_type}" == "" ]; then
        echo "- What is the upgrade type ?"
        select _upgrade_type in "${_upgrade_types[@]}"; do
            if [[ -n "$_upgrade_type" ]]; then
                upgrade_type="$_upgrade_type"
                break
            else
                echo "Invalid type. Please try again.";
            fi
        done
    fi;

    _version_new=$(bashutilities_version_bump "${_version}" "${_upgrade_type}")
    bashutilities_sed "s/${_version}/${_version_new}/g" "${_plugin_file}";
    echo "- New version: ${_version_new}";

}

wpuplugincreator__bump_version "$@";
