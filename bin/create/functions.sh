#!/bin/bash

function wpuplugincreator_set_values(){
    file_content=$(cat "${1}");
    file_content=${file_content//myplugin_classname/${plugin_classname}};
    file_content=${file_content//myplugin_name/${plugin_name}};
    file_content=${file_content//myplugin_id/${plugin_id}};
    file_content=${file_content//myplugin_lang/${translation_lang}};
    file_content=${file_content//author_id/${author_id}};
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
        cat <<EOT >> "${_INC_DIR}.htaccess";
deny from all
<FilesMatch "(^$)|(\.(css|js)$)">
    Allow From All
</FilesMatch>
EOT
    fi;
}

function wpuplugincreator_create_github_actions(){
    local _hasgithub;
    local _default_branch_name;
    local _remote_github;
    local _new_action;
    if git remote get-url origin | grep -q github.com; then
      _hasgithub="1"
    else
      return 0;
    fi

    _default_branch_name=$(git rev-parse --abbrev-ref HEAD);

    # Folder
    if [[ ! -d ".github/" ]];then
        mkdir "${_PLUGIN_DIR}.github";
        mkdir "${_PLUGIN_DIR}.github/workflows/";
        echo "deny from all" > "${_PLUGIN_DIR}.github/.htaccess";
    fi;

    # PHP
    local _php_file="${_PLUGIN_DIR}.github/workflows/php.yml";
    if [[ ! -f "${_php_file}" ]];then
        _new_action='1';
        cp "${_TOOLSDIR}github-actions-php.yml" "${_php_file}";
        bashutilities_sed "s/default_branch_name/${_default_branch_name}/g" "${_php_file}";
        echo '- Added PHP github actions.';
    fi;

    # JS
    if [[ -d "${_PLUGIN_DIR}assets" ]];then
        local _js_file="${_PLUGIN_DIR}.github/workflows/js.yml";
        if [[ ! -f "${_js_file}" ]];then
            _new_action='1';
            cp "${_TOOLSDIR}eslint.json" "${_PLUGIN_DIR}.eslintrc.json";
            cp "${_TOOLSDIR}github-actions-js.yml" "${_js_file}";
            bashutilities_sed "s/default_branch_name/${_default_branch_name}/g" "${_js_file}";
            echo '- Added JS github actions.';
        fi;
    fi;

    # Confirm
    if [[ "${_new_action}" == '1' ]];then
        echo 'Do not forget to go to the actions settings to disable PR approval for actions:';
        _remote_github=$(git config --get remote.origin.url);
        _remote_github=${_remote_github/\.git/\/settings\/actions};
        _remote_github=${_remote_github/git\@github/https\:\/\/github};
        _remote_github=${_remote_github/github.com\:/github\.com\/};
        echo "${_remote_github}";
    fi;
}

# Uninstall
function wpuplugincreator_update_uninstall(){
    local _uninstall_file='uninstall.php';
    if [[ -f "${_uninstall_file}" ]];then
        echo $(bashutilities_message  "- There is already an uninstall file." 'success' 'nowarn');
        return 0;
    fi;
    local _plugin_id="${1}";
    bashutilities_bury_copy "${_TOOLSDIR}uninstall.php" "${_uninstall_file}";
    bashutilities_sed "s/wpuplugincreatorpluginid/${_plugin_id}/g" "${_uninstall_file}";
    echo $(bashutilities_message  "- Uninstall file has been installed." 'success' 'nowarn');
}
