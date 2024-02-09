#!/bin/bash

###################################
## Find plugin folder if possible
###################################

wpuplugincreator_find_folder(){
local wpu_dir=$(pwd)
local wpu_p_dir=$(basename "$(dirname "$wpu_dir")")
local wpu_gdp_dir=$(basename "$(dirname "$(dirname "$wpu_dir")")")

if [[ "$wpu_p_dir" != "plugins" && "$wpu_gdp_dir" != "wp-content" && "${1}" != 'create' ]]; then
    local wpu_change_dir=$(bashutilities_get_yn "- This does not look like a plugin dir, do you want to look for it ?" 'y');
    if [[ "${wpu_change_dir}" == 'y' ]];then
        while true; do
            # Check if the current folder is the root
            if [[ "$wpu_dir" == "/" ]]; then
                echo "We could not find a plugin dir."
                break
            fi

            # Gets the parent and grandparent folder name
            wpu_p_dir=$(basename "$(dirname "$wpu_dir")")
            wpu_gdp_dir=$(basename "$(dirname "$(dirname "$wpu_dir")")")

            # Check if the names match
            if [[ "$wpu_p_dir" == "plugins" && "$wpu_gdp_dir" == "wp-content" ]]; then
                echo '- Correct plugin dir found.';
                cd "$wpu_dir";
                break
            else
                # Go up one level in the folder tree
                wpu_dir=$(dirname "$wpu_dir")
            fi
        done
    fi;

fi;
}
wpuplugincreator_find_folder;
