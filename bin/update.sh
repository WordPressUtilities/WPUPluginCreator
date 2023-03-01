#!/bin/bash

###################################
## Update on main file
###################################

function wpuplugincreator_update_main_file(){
    local _plugin_dir=$(basename "${_CURRENT_DIR}");
    local _plugin_file="${_plugin_dir}.php";

    # Check if main file exists
    if [[ ! -f "${_plugin_file}" ]];then
        return 0;
    fi;

    # Update loading method of textdomain
    if ! grep -q load_muplugin_textdomain "${_plugin_file}" && grep -q load_plugin_textdomain "${_plugin_file}"; then
        bashutilities_sed "s/load_plugin_textdomain('.*/##marker_textdomain##/g" "${_plugin_file}";
        local _content=$(cat << _content_
\$lang_dir = dirname(plugin_basename(__FILE__)) . '/lang/';
if (!load_plugin_textdomain('${_plugin_dir}', false, \$lang_dir)) {
    load_muplugin_textdomain('${_plugin_dir}', \$lang_dir);
}
\$this->plugin_description = __('PLUGIN DESCRIPTION', '${_plugin_dir}');
_content_
);
        bashutilities_add_after_marker '##marker_textdomain##' "${_content}" "${_plugin_file}";
        bashutilities_sed "s/##marker_textdomain##//g" "${_plugin_file}";
        echo '- Update lang loading method.'
    fi

    # Put Update URI if missing
    if ! grep -q "Update URI" "${_plugin_file}" && grep -q "Plugin URI" "${_plugin_file}"; then
        # Find line containing the Plugin URI
        local _update_string=$(grep 'Plugin URI' "${_plugin_file}");
        # Replace name by Update URI
        local _new_update_string="${_update_string/Plugin URI/Update URI}"
        # Insert it after the original
        bashutilities_add_after_marker "${_update_string}" "${_new_update_string}" "${_plugin_file}";
        echo '- Add missing Update URI.'
    fi

    # Put Text Domain if missing
    if ! grep -q "Text Domain" "${_plugin_file}" && grep -q "License" "${_plugin_file}"; then
        # Insert it before License
        bashutilities_add_before_marker "License:" "Text Domain: ${_plugin_dir}" "${_plugin_file}";
        echo '- Add missing Text Domain.'
    fi

    # Put Domain Path if missing
    if ! grep -q "Domain Path" "${_plugin_file}" && grep -q "License" "${_plugin_file}" && [[ -f "lang/${_plugin_dir}-fr_FR.po" ]]; then
        # Insert it before License
        bashutilities_add_before_marker "License:" "Domain Path: /lang" "${_plugin_file}";
        echo '- Add missing Domain Path.'
    fi

    # Put Requires version if missing
    if ! grep -q "Requires at least" "${_plugin_file}" && grep -q "License" "${_plugin_file}"; then
        # Insert it before License
        bashutilities_add_before_marker "License:" "Requires at least: 6.0" "${_plugin_file}";
        echo '- Add missing Requires at least.'
    fi

    # Put Requires PHP if missing
    if ! grep -q "Requires PHP" "${_plugin_file}" && grep -q "License" "${_plugin_file}"; then
        # Insert it before License
        bashutilities_add_before_marker "License:" "Requires PHP: 8.0" "${_plugin_file}";
        echo '- Add missing Requires PHP.'
    fi


}
wpuplugincreator_update_main_file;

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
