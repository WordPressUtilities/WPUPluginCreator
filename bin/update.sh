#!/bin/bash

###################################
## Update on main file
###################################

# Helper for version

function wpuplugincreator_update_main_file_version_replace(){
    # Put Requires version if missing
    local _search_str="${1}";
    local _latest_version="${2}";
    local _plugin_file="${3}";

    if ! grep -q "${_search_str}" "${_plugin_file}" && grep -q "License:" "${_plugin_file}"; then
        # Insert it before License
        bashutilities_add_before_marker "License:" "${_search_str}: ${_latest_version}" "${_plugin_file}";
        echo "- Add missing '${_search_str}'."
    fi
    # Check latest version
    _req_version=$(bashutilities_search_extract_file "${_search_str}:" "" "${_plugin_file}");
    if [[ "${_req_version}" != "" &&  "${_req_version}" != "${_latest_version}" ]];then
        bashutilities_sed "s#${_search_str}: ${_req_version}#${_search_str}: ${_latest_version}#g" "${_plugin_file}";
    fi;
}

# Main function

function wpuplugincreator_update_main_file(){
    local _plugin_id=$(basename "${_CURRENT_DIR}");
    local _PLUGIN_DIR="./";
    local _plugin_file="${_plugin_id}.php";

    # Check if main file exists
    if [[ ! -f "${_plugin_file}" ]];then
        return 0;
    fi;

    # Update loading method of textdomain
    if ! grep -q load_muplugin_textdomain "${_plugin_file}" && grep -q load_plugin_textdomain "${_plugin_file}"; then
        bashutilities_sed "s/load_plugin_textdomain('.*/##marker_textdomain##/g" "${_plugin_file}";
        local _content=$(cat << _content_
\$lang_dir = dirname(plugin_basename(__FILE__)) . '/lang/';
if (!load_plugin_textdomain('${_plugin_id}', false, \$lang_dir)) {
    load_muplugin_textdomain('${_plugin_id}', \$lang_dir);
}
\$this->plugin_description = __('PLUGIN DESCRIPTION', '${_plugin_id}');
_content_
);
        bashutilities_add_after_marker '##marker_textdomain##' "${_content}" "${_plugin_file}";
        bashutilities_sed "s/##marker_textdomain##//g" "${_plugin_file}";
        echo '- Update lang loading method.'
    fi

    # Github actions
    local _php_workflow=".github/workflows/php.yml";
    local _js_workflow=".github/workflows/js.yml";
    if [[ ! -f "${_php_workflow}" || ! -f "${_js_workflow}" ]];then
        local has_github_actions='n';
        if git remote -v | grep -q 'github.com'; then
            has_github_actions=$(bashutilities_get_yn "- Do you need github actions ?" 'y');
        fi
        if [[ "${has_github_actions}" == 'y' ]];then
            wpuplugincreator_create_github_actions;
        fi;
    else
        echo $(bashutilities_message  "- Github actions are already installed." 'success' 'nowarn');
        if [[ -f "${_php_workflow}" ]];then
            bashutilities_sed "s#actions/checkout@v2#actions/checkout@v3#g" "${_php_workflow}";
        fi;
        if [[ -f "${_js_workflow}" ]];then
            bashutilities_sed "s#actions/checkout@v2#actions/checkout@v3#g" "${_js_workflow}";
        fi;
    fi;

    # Check http
    if grep -q "http:" "${_plugin_file}";then
        local need_http_replace=$(bashutilities_get_yn "- Do you want to replace http by https ?" 'y');
        if [[ "${need_http_replace}" == 'y' ]];then
            bashutilities_sed "s/http:/https:/g" "${_plugin_file}";
            echo '- Replaced http by https.'
        fi;
    fi;

    if grep -q "dirname" "${_plugin_file}";then
        bashutilities_sed "s/dirname( __FILE__ )/__DIR__/g" "${_plugin_file}";
        bashutilities_sed "s/dirname(__FILE__)/__DIR__/g" "${_plugin_file}";
        echo '- Replaced dirname( __FILE__ ) by __DIR__.'
    fi;

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
    wpuplugincreator_update_main_file_version_replace "Text Domain" "${_plugin_id}" "${_plugin_file}";

    # Put Domain Path if missing
    if [[ -f "lang/${_plugin_id}-fr_FR.po" ]]; then
        wpuplugincreator_update_main_file_version_replace "Domain Path" "/lang" "${_plugin_file}";
    fi

    # Add required WordPress version
    wpuplugincreator_update_main_file_version_replace "Requires at least" "6.2" "${_plugin_file}";

    # Add PHP Version
    wpuplugincreator_update_main_file_version_replace "Requires PHP" "8.0" "${_plugin_file}";

    # Use require_once
    bashutilities_sed "s#include dirname#require_once dirname#g" "${_plugin_file}";
    bashutilities_sed "s#include __DIR__#require_once __DIR__#g" "${_plugin_file}";

    # Uninstall
    wpuplugincreator_update_uninstall "." "${_plugin_id}";

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

    # Extract namespace
    local _namespace=$(bashutilities_search_extract_file "namespace " ";" "${_CLASS_FILE}" );

    # Replace file by latest
    rm -rf "${_CLASS_DIR}";
    cp -R "${_CLASS_SRC_DIR}" "${_CLASS_DIR}";

    # Fix namespace
    wpuplugincreator_replace_namespace "${_CLASS_FILE}" "${_namespace}"

    # Success message
    if [[ "${_v_src}" == "${_v_proj}" ]];then
        echo $(bashutilities_message  "- “${i}” is already up-to-date." 'success' 'nowarn');
    else
        echo $(bashutilities_message "- “${i}” has been updated !" 'success');
    fi;
}

for i in "${_DEPENDENCY_LIST[@]}"; do
    echo $(bashutilities_message  "# Updating “${i}” if installed." 'notice' 'nowarn');
    wpuplugincreator_update_dependency "${i}";
done;

###################################
## Protection
###################################

function wpuplugincreator_update_protect(){
    local _dir;
    for _dir in {"src","inc","lang","vendor"}; do
        wpuplugincreator_protect_dir "${_dir}";
    done;
    echo "- All directories have been protected."
}

wpuplugincreator_update_protect;

###################################
## Check code
###################################

function wpuplugincreator_update_check_code(){
    local _PLUGIN_DIR=$(basename "${_CURRENT_DIR}")"/";
    local _plugin_file="${_PLUGIN_DIR}.php";

    # Check if main file exists
    if [[ ! -f "${_plugin_file}" ]];then
        return 0;
    fi;

    php "${_TOOLSDIR}/update-code.php" "${_CURRENT_DIR}/${_plugin_file}";
}

wpuplugincreator_update_check_code;

###################################
## Check abspath protection
###################################

function wpuplugincreator_update_add_abspath_protection() {
    local start_of_file;
    # Find and process all PHP files in the directory and subdirectories
    find "." -type f -name "*.php" | while read file; do
        # Check if the file contains "defined('ABSPATH')" and contains more than a line
        if ! grep -q "defined('ABSPATH')" "$file" && [ $(grep -c . "$file") -gt 1 ]; then
            start_of_file=$(head -n 1 "$file");
            if [ "${start_of_file:0:5}" != '<?php' ]; then
                bashutilities_insert_at_beginning "<?php defined('ABSPATH') || die; ?>" "$file";
            elif grep -q "namespace" "$file"; then
                bashutilities_add_after_first_marker "namespace" "defined('ABSPATH') || die;" "$file"
            elif ! grep -q "<\?php" "$file"; then
                bashutilities_insert_at_beginning "<?php defined('ABSPATH') || die; ?>\n" "$file";
            else
                bashutilities_add_after_first_marker "<\?php" "defined('ABSPATH') || die;" "$file"
            fi
        fi
    done
}

wpuplugincreator_update_add_abspath_protection
