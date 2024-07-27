#!/bin/bash

###################################
## Bump version in WPUBasePlugin
###################################

function wpuplugincreator_upgrade_wpubaseplugin() {
    local _wpu_path="${_TOOLSDIR}wpubaseplugin/"
    local _module_name _module_name_prefix _version _version_new _version_old_slug _version_new_slug _version_main _version_main_new _upgrade_type;

    # Ask module name
    if [[ ! -z "$2" ]]; then
        _module_name="$2";
    else
        _module_name=$(bashutilities_get_user_var "- What is the Module name ?")
    fi;
    _module_name_prefix=$(bashutilities_string_to_slug "${_module_name}")

    _module_path="${_wpu_path}inc/${_module_name}"
    _module_path="${_wpu_path}inc/${_module_name}"
    _main_file="${_wpu_path}wpubaseplugin.php"
    _module_file="${_module_path}/${_module_name}.php"

    if [[ ! -d "${_module_path}" || ! -f "${_module_file}" ]]; then
        echo "- Module does not exists"
        return 0
    fi

    # Get module version
    _version=$(bashutilities_search_extract_file "Version: " "" "${_module_file}")

    # Ask version & update type
    echo "Current version is: ${_version}"
    echo "Do you want to update the version to a major, minor, or patch ?"

    _upgrade_type=$(bashutilities_get_user_var "- What is the upgrade type ?")
    _version_new=$(bashutilities_version_bump "${_version}" "${_upgrade_type}")

    # Update module version slug
    _version_old_slug="${_module_name_prefix}_${_version//\./_}"
    _version_new_slug="${_module_name_prefix}_${_version_new//\./_}"

    # Edit plugin file
    bashutilities_sed "s/${_version_old_slug}/${_version_new_slug}/g" "${_module_file}"
    bashutilities_sed "s/${_version}/${_version_new}/g" "${_module_file}"

    # Edit main file
    _version_main=$(bashutilities_search_extract_file "Version: " "" "${_main_file}")
    _version_main_new=$(bashutilities_version_bump "${_version_main}" "${_upgrade_type}")
    bashutilities_sed "s/${_version_old_slug}/${_version_new_slug}/g" "${_main_file}"
    bashutilities_sed "s/${_version_main}/${_version_main_new}/g" "${_main_file}"

    # Generate help message
    local _WPUPLUGINCREATOR_VERSION_NEW=$(bashutilities_version_bump "${_WPUPLUGINCREATOR_VERSION}" "patch");

cat <<EOT

# Go to the WPUBasePlugin folder
cd ${_SOURCEDIR}sources/WPUBasePlugin;

# Commit
git add .;
git commit -m 'v ${_version_main_new}

${_module_name} v ${_version_new} :
- Updated this feature'

# Tag
git tag -a ${_version_main_new} -m "";

# Push
git push;

# Go to the main folder
cd ${_SOURCEDIR};

# Update version
sed -i '' 's/${_WPUPLUGINCREATOR_VERSION}/${_WPUPLUGINCREATOR_VERSION_NEW}/g' ${_SOURCEDIR}wpuplugincreator.sh

# Track dir
git add ${_TOOLSDIR};
git add ${_SOURCEDIR}wpuplugincreator.sh;

# Commit message
git commit -m 'v ${_WPUPLUGINCREATOR_VERSION_NEW}

- Update dependencies'

# Tag
git tag -a ${_WPUPLUGINCREATOR_VERSION_NEW} -m ""

EOT

}

wpuplugincreator_upgrade_wpubaseplugin "$@";
