#!/bin/bash

###################################
## Bump version in WPUBasePlugin
###################################

function wpuplugincreator_upgrade_wpubaseplugin() {
    local _wpu_path="${_TOOLSDIR}wpubaseplugin/"

    # Ask module name
    local _module_name=$(bashutilities_get_user_var "- What is the Module name ?")
    local _module_name_prefix=$(bashutilities_string_to_slug "${_module_name}")

    local _module_path="${_wpu_path}inc/${_module_name}"
    local _module_path="${_wpu_path}inc/${_module_name}"
    local _main_file="${_wpu_path}wpubaseplugin.php"
    local _module_file="${_module_path}/${_module_name}.php"

    if [[ ! -d "${_module_path}" || ! -f "${_module_file}" ]]; then
        echo "- Module does not exists"
        return 0
    fi

    # Get module version
    local _version=$(bashutilities_search_extract_file "Version: " "" "${_module_file}")

    # Ask version & update type
    echo "Current version is: ${_version}"
    echo "Do you want to update the version to a major, minor, or patch ?"

    local _upgrade_type=$(bashutilities_get_user_var "- What is the upgrade type ?")
    local _version_new=$(bashutilities_version_bump "${_version}" "${_upgrade_type}")

    # Update module version slug
    local _version_old_slug="${_module_name_prefix}_${_version//\./_}"
    local _version_new_slug="${_module_name_prefix}_${_version_new//\./_}"

    # Edit plugin file
    bashutilities_sed "s/${_version_old_slug}/${_version_new_slug}/g" "${_module_file}"
    bashutilities_sed "s/${_version}/${_version_new}/g" "${_module_file}"

    # Edit main file
    local _version_main=$(bashutilities_search_extract_file "Version: " "" "${_main_file}")
    local _version_main_new=$(bashutilities_version_bump "${_version_main}" "${_upgrade_type}")
    bashutilities_sed "s/${_version_old_slug}/${_version_new_slug}/g" "${_main_file}"
    bashutilities_sed "s/${_version_main}/${_version_main_new}/g" "${_main_file}"

}

wpuplugincreator_upgrade_wpubaseplugin
