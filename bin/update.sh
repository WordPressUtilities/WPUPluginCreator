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

    # Github actions
    if [[ ! -f ".github/workflows/php.yml" || ! -f ".github/workflows/js.yml" ]];then
        local has_github_actions=$(bashutilities_get_yn "- Do you need github actions ?" 'y');
        if [[ "${has_github_actions}" == 'y' ]];then
            wpuplugincreator_create_github_actions;
        fi;
    else
        echo $(bashutilities_message  "- Github actions are already installed." 'success' 'nowarn');
    fi;

    # Check http
    if grep -q "http:" "${_plugin_file}";then
        local need_http_replace=$(bashutilities_get_yn "- Do you want to replace http by https ?" 'y');
        if [[ "${need_http_replace}" == 'y' ]];then
            bashutilities_sed "s/http:/https:/g" "${_plugin_file}";
            echo '- Replace http by https.'
        fi;
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
    wpuplugincreator_update_main_file_version_replace "Text Domain" "${_plugin_dir}" "${_plugin_file}";

    # Put Domain Path if missing
    if [[ -f "lang/${_plugin_dir}-fr_FR.po" ]]; then
        wpuplugincreator_update_main_file_version_replace "Domain Path" "/lang" "${_plugin_file}";
    fi

    # Add required WordPress version
    wpuplugincreator_update_main_file_version_replace "Requires at least" "6.2" "${_plugin_file}";

    # Add PHP Version
    wpuplugincreator_update_main_file_version_replace "Requires PHP" "8.0" "${_plugin_file}";

    # Use require_once
    bashutilities_sed "s#include dirname#require_once dirname#g" "${_plugin_file}";

    # Uninstall
    wpuplugincreator_update_uninstall "${_plugin_dir}";

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
    local _plugin_dir=$(basename "${_CURRENT_DIR}");
    local _plugin_file="${_plugin_dir}.php";

    # Check if main file exists
    if [[ ! -f "${_plugin_file}" ]];then
        return 0;
    fi;

    php "${_TOOLSDIR}/update-code.php" "${_CURRENT_DIR}/${_plugin_file}";
}

wpuplugincreator_update_check_code;
